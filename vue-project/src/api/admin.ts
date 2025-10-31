import axios from '@/utils/axios'

/**
 * 管理员相关API
 */

// 获取用户列表
export const getUsers = (params: any) => {
  return axios.get('/api/admin/users', { params })
}

// 修改用户状态
export const updateUserStatus = (userId: number, status: number) => {
  return axios.put(`/api/admin/users/${userId}/status`, null, {
    params: { status }
  })
}

// 获取商家列表
export const getMerchants = (params: any) => {
  return axios.get('/api/admin/merchants', { params })
}

// 审核商家（通过）
export const approveMerchant = (merchantId: number) => {
  return axios.post(`/api/admin/merchants/${merchantId}/approve`)
}

// 审核商家（拒绝）
export const rejectMerchant = (merchantId: number, reason?: string) => {
  return axios.post(`/api/admin/merchants/${merchantId}/reject`, null, {
    params: { reason }
  })
}

// 获取所有预约
export const getAllAppointments = (params: any) => {
  return axios.get('/api/admin/appointments', { params })
}

// 获取平台数据统计
export const getStatistics = () => {
  return axios.get('/api/admin/statistics')
}





