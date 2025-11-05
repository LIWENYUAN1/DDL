import axios from '@/utils/axios'

/**
 * 预约相关API
 */

// 创建预约
export const createAppointment = (data: any) => {
  return axios.post('/api/appointment/create', data)
}

// 获取用户预约列表
export const getUserAppointments = (params: any) => {
  return axios.get('/api/appointment/user/list', { params })
}

// 获取商家预约列表
export const getMerchantAppointments = (params: any) => {
  return axios.get('/api/appointment/merchant/list', { params })
}

// 确认预约
export const confirmAppointment = (appointmentId: number) => {
  return axios.post(`/api/appointment/confirm/${appointmentId}`)
}

// 完成预约
export const completeAppointment = (appointmentId: number) => {
  return axios.post(`/api/appointment/complete/${appointmentId}`)
}

// 取消预约
export const cancelAppointment = (appointmentId: number) => {
  return axios.post(`/api/appointment/cancel/${appointmentId}`)
}

// 重新安排预约
export const rescheduleAppointment = (appointmentId: number, data: { appointmentTime: string; remark?: string }) => {
  return axios.post(`/api/appointment/reschedule/${appointmentId}`, data)
}

// 支付预约费用
export const payForAppointment = (appointmentId: number, data: { amount: number; method: string; payType?: string }) => {
  return axios.post(`/api/appointment/pay/${appointmentId}`, data)
}

// 获取预约详情
export const getAppointmentDetail = (appointmentId: number) => {
  return axios.get(`/api/appointment/detail/${appointmentId}`)
}

// 提交预约投诉
export const submitAppointmentComplaint = (data: {
  appointmentId: number
  type: string
  content: string
  contact?: string
}) => {
  return axios.post('/api/complaint/appointment', data)
}
