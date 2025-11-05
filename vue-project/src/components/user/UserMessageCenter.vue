<template>
  <div class="user-message-center">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <div>
            <h3>消息通知中心</h3>
            <p class="card-subtitle">查看系统提醒、预约状态和支付通知</p>
          </div>
          <div class="header-actions">
            <el-button text type="primary" @click="fetchRemoteNotifications" :loading="loading">
              <el-icon><Refresh /></el-icon>
              同步服务器
            </el-button>
            <el-button text @click="markAll" :disabled="!notificationStore.hasUnread">
              <el-icon><Bell /></el-icon>
              全部标记已读
            </el-button>
            <el-popconfirm title="确认清空所有消息？" @confirm="clearAll">
              <template #reference>
                <el-button text type="danger">清空</el-button>
              </template>
            </el-popconfirm>
          </div>
        </div>
      </template>

      <el-segmented v-model="filterType" :options="filters" class="filter-segmented" />

      <el-empty v-if="filteredNotifications.length === 0" description="暂无消息">
        <el-button type="primary" @click="fetchRemoteNotifications">刷新</el-button>
      </el-empty>

      <el-timeline v-else class="notification-list">
        <el-timeline-item
          v-for="item in filteredNotifications"
          :key="item.id"
          :timestamp="formatDate(item.createdAt)"
          :type="getTimelineType(item.type)"
        >
          <el-card :class="['notification-card', { unread: !item.read }]" shadow="hover">
            <div class="notification-header">
              <div class="notification-title">
                <el-tag :type="getTagType(item.type)" effect="plain" size="small">
                  {{ getTagLabel(item.type) }}
                </el-tag>
                <h4>{{ item.title }}</h4>
              </div>
              <div class="notification-actions">
                <el-button text size="small" @click="handleMarkRead(item)" v-if="!item.read">
                  标记已读
                </el-button>
                <el-button text size="small" type="danger" @click="remove(item)">
                  删除
                </el-button>
              </div>
            </div>
            <p class="notification-content">{{ item.content }}</p>
            <div v-if="item.actionText" class="notification-footer">
              <el-button type="primary" link>{{ item.actionText }}</el-button>
            </div>
          </el-card>
        </el-timeline-item>
      </el-timeline>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { Bell, Refresh } from '@element-plus/icons-vue'
import { useNotificationStore } from '@/store/modules/notification'
import {
  deleteNotification,
  getUserNotifications,
  markAllNotificationsRead,
  markNotificationRead
} from '@/api/notification'

const notificationStore = useNotificationStore()

const loading = ref(false)
const filterType = ref<'all' | 'unread' | 'appointment' | 'payment' | 'system' | 'complaint'>('all')

const filters = [
  { label: '全部', value: 'all' },
  { label: '未读', value: 'unread' },
  { label: '预约', value: 'appointment' },
  { label: '支付', value: 'payment' },
  { label: '系统', value: 'system' },
  { label: '投诉', value: 'complaint' }
]

const filteredNotifications = computed(() => {
  if (filterType.value === 'unread') {
    return notificationStore.sortedNotifications.filter(item => !item.read)
  }
  if (filterType.value === 'all') {
    return notificationStore.sortedNotifications
  }
  return notificationStore.sortedNotifications.filter(item => item.type === filterType.value)
})

const formatDate = (date: string) => {
  return new Date(date).toLocaleString()
}

const getTagLabel = (type: string) => {
  const map: Record<string, string> = {
    system: '系统',
    appointment: '预约',
    payment: '支付',
    review: '评价',
    complaint: '投诉'
  }
  return map[type] ?? '通知'
}

const getTagType = (type: string) => {
  const map: Record<string, any> = {
    system: 'info',
    appointment: 'primary',
    payment: 'success',
    review: 'warning',
    complaint: 'danger'
  }
  return map[type] ?? 'info'
}

const getTimelineType = (type: string) => {
  const map: Record<string, any> = {
    system: 'info',
    appointment: 'primary',
    payment: 'success',
    review: 'warning',
    complaint: 'danger'
  }
  return map[type] ?? 'info'
}

const handleMarkRead = async (item: { id: number }) => {
  try {
    notificationStore.markAsRead(item.id)
    await markNotificationRead(item.id)
  } catch (error) {
    console.warn('标记已读失败，已本地处理', error)
  }
}

const markAll = async () => {
  try {
    notificationStore.markAllAsRead()
    await markAllNotificationsRead()
    ElMessage.success('已标记所有消息为已读')
  } catch (error) {
    console.warn('批量标记失败', error)
  }
}

const remove = async (item: { id: number }) => {
  try {
    notificationStore.removeNotification(item.id)
    await deleteNotification(item.id)
  } catch (error) {
    console.warn('删除通知失败，已本地移除', error)
  }
}

const clearAll = () => {
  notificationStore.clear()
}

const fetchRemoteNotifications = async () => {
  loading.value = true
  try {
    const response = await getUserNotifications()
    const list = response.data?.records || []
    const parsed = list.map((item: any, index: number) => ({
      id: item.id ?? index + 1,
      title: item.title ?? item.subject ?? '系统通知',
      content: item.content ?? item.body ?? '暂无内容',
      type: item.type ?? 'system',
      createdAt: item.createdAt ?? item.createTime ?? new Date().toISOString(),
      read: item.read ?? item.status === 1,
      actionText: item.actionText,
      relatedId: item.relatedId
    }))
    notificationStore.replaceNotifications(parsed)
  } catch (error: any) {
    console.warn('同步通知失败，使用本地数据', error)
    if (!notificationStore.notifications.length) {
      seedNotifications()
    }
    ElMessage.warning(error.message || '同步失败，已显示本地消息')
  } finally {
    loading.value = false
  }
}

const seedNotifications = () => {
  notificationStore.replaceNotifications([
    {
      id: Date.now(),
      title: '预约已确认',
      content: '极速摩托维修店已确认您 2025-01-25 的保养预约，请准时到店。',
      type: 'appointment',
      createdAt: new Date().toISOString(),
      read: false
    },
    {
      id: Date.now() - 1,
      title: '支付提醒',
      content: '请在预约开始前完成在线支付或准备到店支付。',
      type: 'payment',
      createdAt: new Date().toISOString(),
      read: false
    }
  ])
}

onMounted(() => {
  if (!notificationStore.notifications.length) {
    seedNotifications()
  }
})
</script>

<style scoped>
.user-message-center {
  width: 100%;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}

.card-header h3 {
  margin: 0;
}

.card-subtitle {
  margin: 4px 0 0;
  color: #909399;
  font-size: 13px;
}

.header-actions {
  display: flex;
  gap: 12px;
  align-items: center;
}

.filter-segmented {
  margin-bottom: 16px;
}

.notification-list {
  margin-top: 16px;
}

.notification-card {
  transition: transform 0.2s ease;
}

.notification-card.unread {
  border: 1px solid #409eff;
  background-color: #f0f9ff;
}

.notification-card:hover {
  transform: translateY(-2px);
}

.notification-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
}

.notification-title {
  display: flex;
  gap: 10px;
  align-items: center;
}

.notification-title h4 {
  margin: 0;
  font-size: 16px;
}

.notification-content {
  margin: 12px 0 0;
  color: #606266;
  line-height: 1.6;
}

.notification-footer {
  margin-top: 12px;
}
</style>
