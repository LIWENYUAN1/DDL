export interface ReviewItem {
  id: number
  appointmentId: number
  orderNo: string
  serviceItemName: string
  merchantName: string
  userName: string
  isAnonymous: boolean
  score: number
  serviceScore: number | null
  qualityScore: number | null
  attitudeScore: number | null
  content: string
  imgList: string[]
  createTime: string
  replyContent: string
  replyTime: string
}

export const parseImageUrls = (imgUrls?: string | string[] | null): string[] => {
  if (!imgUrls) return []
  if (Array.isArray(imgUrls)) {
    return imgUrls.filter((item) => !!item)
  }
  return imgUrls
    .split(',')
    .map((item) => item.trim())
    .filter((item) => item.length > 0)
}

export const formatDateTime = (value?: string | null): string => {
  if (!value) return ''
  if (typeof value !== 'string') {
    return ''
  }
  // 将后端 LocalDateTime 格式转换为更易读的字符串
  return value.replace('T', ' ').replace(/\.\d+$/, '')
}

export const mapReviewResponse = (data: any): ReviewItem => {
  return {
    id: Number(data?.id ?? 0),
    appointmentId: Number(data?.appointmentId ?? 0),
    orderNo: data?.orderNo || '',
    serviceItemName: data?.serviceItemName || '',
    merchantName: data?.merchantName || '',
    userName:
      data?.isAnonymous === 1
        ? '匿名用户'
        : data?.username || data?.userName || '用户',
    isAnonymous: Number(data?.isAnonymous ?? 0) === 1,
    score: Number(data?.score ?? 0),
    serviceScore: data?.serviceScore ?? null,
    qualityScore: data?.qualityScore ?? null,
    attitudeScore: data?.attitudeScore ?? null,
    content: data?.content || '',
    imgList: parseImageUrls(data?.imgUrls),
    createTime: formatDateTime(data?.createTime) || '',
    replyContent: data?.replyContent || '',
    replyTime: formatDateTime(data?.replyTime) || ''
  }
}
