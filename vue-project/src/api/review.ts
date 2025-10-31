import request from '@/utils/axios'

/**
 * 评价相关 API
 */

// 评价请求参数
export interface ReviewCreateDTO {
  appointmentId: number
  score: number
  serviceScore?: number
  qualityScore?: number
  attitudeScore?: number
  content?: string
  imgUrls?: string
  isAnonymous?: number
}

/**
 * 创建评价
 */
export const createReview = (data: ReviewCreateDTO) => {
  return request({
    url: '/api/review/create',
    method: 'post',
    data
  })
}

/**
 * 检查预约是否可以评价
 */
export const checkCanReview = (appointmentId: number) => {
  return request({
    url: `/api/review/check-can-review/${appointmentId}`,
    method: 'get'
  })
}

/**
 * 根据预约ID获取评价
 */
export const getReviewByAppointmentId = (appointmentId: number) => {
  return request({
    url: `/api/review/by-appointment/${appointmentId}`,
    method: 'get'
  })
}

/**
 * 获取用户的评价列表
 */
export const getUserReviews = () => {
  return request({
    url: '/api/review/user/list',
    method: 'get'
  })
}

/**
 * 获取商家的评价列表
 */
export const getMerchantReviews = () => {
  return request({
    url: '/api/review/merchant/list',
    method: 'get'
  })
}

/**
 * 商家回复评价
 */
export const replyReview = (reviewId: number, replyContent: string) => {
  return request({
    url: `/api/review/reply/${reviewId}`,
    method: 'post',
    params: { replyContent }
  })
}


