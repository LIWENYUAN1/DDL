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

// 获取预约详情
export const getAppointmentDetail = (appointmentId: number) => {
  return axios.get(`/api/appointment/detail/${appointmentId}`)
}





