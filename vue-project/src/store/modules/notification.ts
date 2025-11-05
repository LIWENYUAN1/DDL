import { defineStore } from 'pinia'
import { computed, ref } from 'vue'

export type NotificationType = 'system' | 'appointment' | 'payment' | 'review' | 'complaint'

export interface NotificationItem {
  id: number
  title: string
  content: string
  type: NotificationType
  createdAt: string
  read: boolean
  actionText?: string
  relatedId?: number
}

const STORAGE_KEY = 'userNotifications'

const loadFromStorage = (): NotificationItem[] => {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (!raw) return []
    const parsed = JSON.parse(raw) as NotificationItem[]
    return Array.isArray(parsed) ? parsed : []
  } catch (error) {
    console.warn('读取通知缓存失败', error)
    return []
  }
}

const persistToStorage = (items: NotificationItem[]) => {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(items))
}

export const useNotificationStore = defineStore('notification', () => {
  const notifications = ref<NotificationItem[]>(loadFromStorage())

  const sortedNotifications = computed(() => {
    return [...notifications.value].sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
  })

  const unreadCount = computed(() => notifications.value.filter(item => !item.read).length)

  const hasUnread = computed(() => unreadCount.value > 0)

  const addNotification = (payload: Omit<NotificationItem, 'id' | 'createdAt' | 'read'> & {
    id?: number
    createdAt?: string
    read?: boolean
  }) => {
    const item: NotificationItem = {
      id: payload.id ?? Date.now(),
      title: payload.title,
      content: payload.content,
      type: payload.type,
      createdAt: payload.createdAt ?? new Date().toISOString(),
      read: payload.read ?? false,
      actionText: payload.actionText,
      relatedId: payload.relatedId
    }

    notifications.value.unshift(item)
    persistToStorage(notifications.value)
  }

  const markAsRead = (id: number) => {
    const target = notifications.value.find(item => item.id === id)
    if (!target) return
    target.read = true
    persistToStorage(notifications.value)
  }

  const markAllAsRead = () => {
    notifications.value.forEach(item => {
      item.read = true
    })
    persistToStorage(notifications.value)
  }

  const replaceNotifications = (items: NotificationItem[]) => {
    notifications.value = items
    persistToStorage(notifications.value)
  }

  const removeNotification = (id: number) => {
    notifications.value = notifications.value.filter(item => item.id !== id)
    persistToStorage(notifications.value)
  }

  const clear = () => {
    notifications.value = []
    persistToStorage([])
  }

  return {
    notifications,
    sortedNotifications,
    unreadCount,
    hasUnread,
    addNotification,
    markAsRead,
    markAllAsRead,
    replaceNotifications,
    removeNotification,
    clear
  }
})
