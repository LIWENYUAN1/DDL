import request from '../utils/axios'

// 用户相关API
export const userApi = {
  // 用户登录
  login: (data: { username: string; password: string; userType?: number }) => request.post('/auth/login', data),
  // 用户注册
  register: (data: any) => request.post('/auth/register', data),
  // 发送验证码
  sendCode: (data: { phone: string }) => request.post('/auth/sendCode', data),
  // 获取用户信息
  getUserInfo: () => request.get('/user/info'),
  // 更新用户信息
  updateUserInfo: (data: any) => request.put('/user/update', data),
  // 修改密码
  changePassword: (data: { oldPassword: string; newPassword: string }) => request.post('/user/resetPassword', { ...data })
}

// 商家相关API
export const shopApi = {
  // 商家登录
  login: (data: { phone: string; password: string }) => request.post('/shop/login', data),
  // 商家注册/申请
  register: (data: any) => request.post('/shop/register', data),
  // 获取商家信息
  getShopInfo: () => request.get('/shop/info'),
  // 更新商家信息
  updateShopInfo: (data: any) => request.put('/shop/info', data),
  // 获取商家服务项目列表
  getServices: () => request.get('/shop/services'),
  // 添加服务项目
  addService: (data: any) => request.post('/shop/services', data),
  // 更新服务项目
  updateService: (id: number, data: any) => request.put(`/shop/services/${id}`, data),
  // 删除服务项目
  deleteService: (id: number) => request.delete(`/shop/services/${id}`)
}

// 预约相关API
export const appointmentApi = {
  // 获取附近商家列表
  getNearbyShops: (params: { latitude: number; longitude: number; distance?: number }) => request.get('/appointment/nearby', { params }),
  // 获取商家服务项目
  getShopServices: (shopId: number) => request.get(`/appointment/shop/${shopId}/services`),
  // 创建预约
  createAppointment: (data: any) => request.post('/api/appointment/create', data),
  // 获取用户预约列表
  getUserAppointments: (params?: any) => request.get('/api/appointment/user/list', { params }),
  // 获取商家预约列表（匹配后端路径）
  getMerchantAppointments: (params?: any) => request.get('/api/appointment/merchant/list', { params }),
  // 确认预约（商家操作）
  confirmAppointment: (appointmentId: number) => request.post(`/api/appointment/confirm/${appointmentId}`),
  // 完成预约（商家操作）
  completeAppointment: (appointmentId: number) => request.post(`/api/appointment/complete/${appointmentId}`),
  // 取消预约（用户/商家都可以）
  cancelAppointment: (appointmentId: number) => request.post(`/api/appointment/cancel/${appointmentId}`),
  // 取消预约（商家端专用，与上面功能相同）
  cancelMerchantAppointment: (appointmentId: number) => request.post(`/api/appointment/cancel/${appointmentId}`),
  // 获取预约详情
  getAppointmentDetail: (appointmentId: number) => request.get(`/api/appointment/detail/${appointmentId}`)
}

// 评价相关API
export const reviewApi = {
  // 创建评价
  createReview: (data: any) => request.post('/review', data),
  // 获取商家评价列表
  getShopReviews: (shopId: number, params?: any) => request.get(`/review/shop/${shopId}`, { params }),
  // 获取用户评价列表
  getUserReviews: (params?: any) => request.get('/review/user', { params })
}

// 管理员相关API
export const adminApi = {
  // 管理员登录
  login: (data: { username: string; password: string }) => request.post('/admin/login', data),
  // 获取用户列表
  getUsers: (params?: any) => request.get('/admin/users', { params }),
  // 获取商家列表
  getShops: (params?: any) => request.get('/admin/shops', { params }),
  // 审核商家
  auditShop: (id: number, data: { status: string; reason?: string }) => request.put(`/admin/shops/${id}/audit`, data),
  // 获取预约统计
  getAppointmentStats: (params?: any) => request.get('/admin/stats/appointments', { params }),
  // 获取用户统计
  getUserStats: () => request.get('/admin/stats/users')
}

export default {
  userApi,
  shopApi,
  appointmentApi,
  reviewApi,
  adminApi
}