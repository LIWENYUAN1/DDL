import axios from '@/utils/axios'

/**
 * 商家相关API
 */

// 获取商家信息
export const getMerchantInfo = () => {
  return axios.get('/api/merchant/info')
}

// 更新商家信息
export const updateMerchantInfo = (data: any) => {
  return axios.put('/api/merchant/info', data)
}

// 获取商家预约列表（修正路径以匹配后端）
export const getMerchantAppointments = (params: any) => {
  return axios.get('/api/appointment/merchant/list', { params })
}

// 确认预约（修正路径以匹配后端）
export const confirmAppointment = (appointmentId: number) => {
  return axios.post(`/api/appointment/confirm/${appointmentId}`)
}

// 完成预约（修正路径以匹配后端）
export const completeAppointment = (appointmentId: number) => {
  return axios.post(`/api/appointment/complete/${appointmentId}`)
}

// 取消预约（商家端也可以取消）
export const cancelMerchantAppointment = (appointmentId: number) => {
  return axios.post(`/api/appointment/cancel/${appointmentId}`)
}

// 获取商家营业统计
export const getMerchantStatistics = () => {
  return axios.get('/api/merchant/statistics')
}

// 查询附近商家（公共API）
export const getNearbyMerchants = (params: any) => {
  return axios.get('/api/public/merchants/nearby', { params })
}

// 获取商家详情（公共API）
export const getMerchantDetail = (merchantId: number) => {
  return axios.get(`/api/public/merchants/${merchantId}`)
}

// 获取所有已审核商家（公共API）
export const getAllMerchants = (params?: any) => {
  return axios.get('/api/public/merchants', { params })
}




