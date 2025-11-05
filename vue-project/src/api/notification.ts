import axios from '@/utils/axios'

export interface NotificationQuery {
  unreadOnly?: boolean
  type?: string
}

export const getUserNotifications = (params?: NotificationQuery) => {
  return axios.get('/api/notification/user', { params })
}

export const markNotificationRead = (id: number) => {
  return axios.post(`/api/notification/read/${id}`)
}

export const markAllNotificationsRead = () => {
  return axios.post('/api/notification/read-all')
}

export const deleteNotification = (id: number) => {
  return axios.delete(`/api/notification/${id}`)
}
