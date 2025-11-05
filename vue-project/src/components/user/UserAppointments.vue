<template>
  <div class="user-appointments">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <h3>我的预约</h3>
          <el-button type="primary" @click="showCreateDialog = true">
            <el-icon><Plus /></el-icon>
            新建预约
          </el-button>
        </div>
      </template>

      <!-- 状态筛选 -->
      <el-tabs v-model="activeStatus" @tab-click="handleStatusChange">
        <el-tab-pane label="全部" name="all" />
        <el-tab-pane label="待确认" name="pending" />
        <el-tab-pane label="已确认" name="confirmed" />
        <el-tab-pane label="已完成" name="completed" />
        <el-tab-pane label="已取消" name="canceled" />
        <el-tab-pane label="已违约" name="breached" />
      </el-tabs>

      <!-- 预约列表 -->
      <el-table 
        :data="filteredAppointments" 
        v-loading="loading"
        style="width: 100%"
      >
        <el-table-column prop="orderNo" label="预约编号" width="180" />
        <el-table-column prop="shopName" label="商家名称" width="200" />
        <el-table-column prop="serviceName" label="服务项目" width="180" />
        <el-table-column prop="appointmentDate" label="预约日期" width="120" />
        <el-table-column prop="appointmentTime" label="预约时间" width="120" />
      <el-table-column prop="amount" label="金额" width="100">
        <template #default="{ row }">
          <span class="amount">¥{{ row.amount }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="paymentStatus" label="支付状态" width="110">
        <template #default="{ row }">
          <el-tag :type="getPaymentStatusType(row.paymentStatus)">
            {{ getPaymentStatusText(row.paymentStatus) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="getStatusType(row.status)">
            {{ getStatusText(row.status) }}
          </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" fixed="right" width="180">
          <template #default="{ row }">
            <el-button
              v-if="row.paymentStatus === 'unpaid' && (row.status === 'pending' || row.status === 'confirmed')"
              size="small"
              type="success"
              @click="openPayment(row)"
            >
              去支付
            </el-button>
            <el-button
              v-if="['pending', 'confirmed'].includes(row.status)"
              size="small"
              type="primary"
              plain
              @click="openReschedule(row)"
            >
              修改
            </el-button>
            <el-button
              size="small"
              @click="viewDetail(row)"
            >
              查看
            </el-button>
            <el-button 
              v-if="row.status === 'pending' || row.status === 'confirmed'"
              size="small" 
              type="danger"
              @click="cancelAppointment(row)"
            >
              取消
            </el-button>
            <el-button
              v-if="row.status === 'completed' && !row.reviewed"
              size="small"
              type="warning"
              @click="reviewAppointment(row)"
            >
              评价
            </el-button>
            <el-button
              v-else-if="row.status === 'completed' && row.reviewed"
              size="small"
              type="primary"
              plain
              @click="viewReview(row)"
            >
              查看评价
            </el-button>
            <el-button
              v-if="row.status === 'completed'"
              size="small"
              type="danger"
              plain
              @click="openComplaint(row)"
            >
              投诉
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :total="total"
        :page-sizes="[10, 20, 50]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        class="pagination"
      />
    </el-card>

    <!-- 预约详情对话框 -->
    <el-dialog
      v-model="showDetailDialog"
      title="预约详情"
      width="600px"
    >
      <el-descriptions v-if="selectedAppointment" :column="2" border>
        <el-descriptions-item label="预约编号" :span="2">
          {{ selectedAppointment.orderNo }}
        </el-descriptions-item>
        <el-descriptions-item label="商家名称" :span="2">
          {{ selectedAppointment.shopName }}
        </el-descriptions-item>
        <el-descriptions-item label="服务项目">
          {{ selectedAppointment.serviceName }}
        </el-descriptions-item>
        <el-descriptions-item label="金额">
          <span class="amount">¥{{ selectedAppointment.amount }}</span>
        </el-descriptions-item>
        <el-descriptions-item label="预约日期">
          {{ selectedAppointment.appointmentDate }}
        </el-descriptions-item>
        <el-descriptions-item label="预约时间">
          {{ selectedAppointment.appointmentTime }}
        </el-descriptions-item>
        <el-descriptions-item label="状态" :span="2">
          <el-tag :type="getStatusType(selectedAppointment.status)">
            {{ getStatusText(selectedAppointment.status) }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="备注" :span="2">
          {{ selectedAppointment.remark || '无' }}
        </el-descriptions-item>
      </el-descriptions>
      
      <template #footer>
        <el-button @click="showDetailDialog = false">关闭</el-button>
      </template>
    </el-dialog>

    <!-- 创建预约对话框 -->
    <el-dialog
      v-model="showCreateDialog"
      title="新建预约"
      width="500px"
    >
      <el-alert
        title="提示"
        description="请先选择商家和服务项目"
        type="info"
        :closable="false"
        show-icon
      />
      <div style="margin-top: 20px; text-align: center;">
        <el-button type="primary" @click="goToShopList">
          选择商家
        </el-button>
      </div>
    </el-dialog>

    <!-- 评价对话框 -->
    <ReviewDialog
      v-model="showReviewDialog"
      :appointment-id="selectedAppointmentForReview?.id || 0"
      :appointment-info="{
        orderNo: selectedAppointmentForReview?.orderNo || '',
        shopName: selectedAppointmentForReview?.shopName || '',
        serviceName: selectedAppointmentForReview?.serviceName || ''
      }"
      @success="handleReviewSuccess"
    />

    <el-dialog
      v-model="showReviewDetailDialog"
      title="评价详情"
      width="520px"
      destroy-on-close
    >
      <div v-if="currentReview" class="review-detail">
        <div class="review-detail__header">
          <div class="review-detail__info">
            <h4>{{ currentReview.serviceItemName || selectedAppointmentForReview?.serviceName }}</h4>
            <p class="review-detail__order">
              预约单号：{{ currentReview.orderNo || selectedAppointmentForReview?.orderNo || '未获取' }}
            </p>
          </div>
          <div class="review-detail__score">
            <el-rate :model-value="currentReview.score" disabled show-score />
            <span class="review-detail__time">{{ currentReview.createTime }}</span>
          </div>
        </div>

        <div class="review-detail__content">
          <p class="review-detail__text">{{ currentReview.content || '暂无评价内容' }}</p>
          <div v-if="currentReview.imgList.length" class="review-detail__images">
            <el-image
              v-for="(img, index) in currentReview.imgList"
              :key="index"
              :src="img"
              :preview-src-list="currentReview.imgList"
              fit="cover"
              class="review-detail__image"
            />
          </div>
        </div>

        <div class="review-detail__scores">
          <div v-if="currentReview.serviceScore !== null" class="review-detail__score-item">
            服务评分：<el-rate :model-value="currentReview.serviceScore" disabled />
          </div>
          <div v-if="currentReview.qualityScore !== null" class="review-detail__score-item">
            质量评分：<el-rate :model-value="currentReview.qualityScore" disabled />
          </div>
          <div v-if="currentReview.attitudeScore !== null" class="review-detail__score-item">
            态度评分：<el-rate :model-value="currentReview.attitudeScore" disabled />
          </div>
        </div>

        <div v-if="currentReview.replyContent" class="review-detail__reply">
          <div class="review-detail__reply-label">商家回复</div>
          <p class="review-detail__reply-text">{{ currentReview.replyContent }}</p>
          <span class="review-detail__reply-time">{{ currentReview.replyTime }}</span>
        </div>
      </div>

      <template #footer>
        <el-button @click="showReviewDetailDialog = false">关闭</el-button>
      </template>
    </el-dialog>

    <PaymentDialog
      v-model="showPaymentDialog"
      :order-no="selectedAppointmentForPayment?.orderNo ?? ''"
      :service-name="selectedAppointmentForPayment?.serviceName ?? ''"
      :amount="selectedAppointmentForPayment?.amount ?? 0"
      :default-method="paymentDialogDefaultMethod"
      :support-offline="true"
      :processing="paymentProcessing"
      @confirm="handlePaymentConfirm"
      @closed="handlePaymentDialogClosed"
    />

    <RescheduleDialog
      v-model="showRescheduleDialog"
      :appointment-date="selectedAppointmentForReschedule?.appointmentDate"
      :appointment-time="selectedAppointmentForReschedule?.appointmentTime"
      :time-options="rescheduleTimeOptions"
      @confirm="handleRescheduleConfirm"
      @closed="handleRescheduleClosed"
    />

    <ComplaintDialog
      v-model="showComplaintDialog"
      :appointment-id="selectedAppointmentForComplaint?.id || 0"
      @submit="handleComplaintSubmit"
      @closed="handleComplaintClosed"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import {
  getUserAppointments,
  cancelAppointment as cancelAppointmentApi,
  payForAppointment,
  rescheduleAppointment,
  submitAppointmentComplaint
} from '@/api/appointment'
import { getReviewByAppointmentId } from '@/api/review'
import { mapReviewResponse, type ReviewItem } from '@/utils/review'
import ReviewDialog from './ReviewDialog.vue'
import PaymentDialog from './PaymentDialog.vue'
import RescheduleDialog from './RescheduleDialog.vue'
import ComplaintDialog from './ComplaintDialog.vue'
import { useNotificationStore } from '@/store/modules/notification'

type AppointmentStatus = 'pending' | 'confirmed' | 'completed' | 'canceled' | 'breached'
type PaymentStatus = 'unpaid' | 'paid' | 'partial' | 'refunded'

interface AppointmentItem {
  id: number
  orderNo: string
  shopName: string
  serviceName: string
  appointmentDate: string
  appointmentTime: string
  amount: number
  status: AppointmentStatus
  remark: string
  reviewed: boolean
  review?: ReviewItem | null
  paymentStatus: PaymentStatus
  paymentMethod?: 'alipay' | 'wechat' | 'offline'
}

const router = useRouter()
const notificationStore = useNotificationStore()

// 状态
const loading = ref(false)
const activeStatus = ref('all')
const appointments = ref<AppointmentItem[]>([])
const selectedAppointment = ref<AppointmentItem | null>(null)
const showDetailDialog = ref(false)
const showCreateDialog = ref(false)
const showReviewDialog = ref(false)
const selectedAppointmentForReview = ref<AppointmentItem | null>(null)
const showReviewDetailDialog = ref(false)
const currentReview = ref<ReviewItem | null>(null)
const showPaymentDialog = ref(false)
const selectedAppointmentForPayment = ref<AppointmentItem | null>(null)
const showRescheduleDialog = ref(false)
const selectedAppointmentForReschedule = ref<AppointmentItem | null>(null)
const showComplaintDialog = ref(false)
const selectedAppointmentForComplaint = ref<AppointmentItem | null>(null)
const paymentDialogDefaultMethod = ref<'alipay' | 'wechat' | 'offline'>('alipay')
const paymentProcessing = ref(false)
const rescheduleTimeOptions = [
  { label: '09:00 - 10:00', value: '09:00-10:00' },
  { label: '10:00 - 11:00', value: '10:00-11:00' },
  { label: '14:00 - 15:00', value: '14:00-15:00' },
  { label: '15:00 - 16:30', value: '15:00-16:30' }
]

// 分页
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 模拟数据
const mockAppointments: AppointmentItem[] = [
  {
    id: 1,
    orderNo: 'APT202501210001',
    shopName: '极速摩托维修店',
    serviceName: '更换机油',
    appointmentDate: '2025-01-25',
    appointmentTime: '10:00-11:00',
    amount: 150,
    status: 'confirmed',
    remark: '请准备全合成机油',
    reviewed: false,
    paymentStatus: 'unpaid',
    paymentMethod: 'alipay'
  },
  {
    id: 2,
    orderNo: 'APT202501200002',
    shopName: '专业摩托保养中心',
    serviceName: '定期保养套餐',
    appointmentDate: '2025-01-22',
    appointmentTime: '14:00-15:30',
    amount: 280,
    status: 'pending',
    remark: '',
    reviewed: false,
    paymentStatus: 'unpaid'
  },
  {
    id: 3,
    orderNo: 'APT202501150003',
    shopName: '酷改摩托改装店',
    serviceName: '外观件改装',
    appointmentDate: '2025-01-18',
    appointmentTime: '09:00-13:00',
    amount: 1200,
    status: 'completed',
    remark: '需要定制涂装',
    reviewed: true,
    paymentStatus: 'paid',
    paymentMethod: 'wechat'
  }
]

// 过滤后的预约列表
const filteredAppointments = computed(() => {
  if (activeStatus.value === 'all') {
    return appointments.value
  }
  return appointments.value.filter(apt => apt.status === activeStatus.value)
})

// 状态筛选
const handleStatusChange = () => {
  loadAppointments()
}

// 获取状态类型
const getStatusType = (status: string) => {
  const typeMap: Record<string, any> = {
    pending: 'warning',
    confirmed: 'info',
    completed: 'success',
    canceled: 'danger',
    breached: 'danger'
  }
  return typeMap[status] || 'info'
}

// 获取状态文本
const getStatusText = (status: string) => {
  const textMap: Record<string, string> = {
    pending: '待确认',
    confirmed: '已确认',
    completed: '已完成',
    canceled: '已取消',
    breached: '已违约'
  }
  return textMap[status] || status
}

const getPaymentStatusType = (status: PaymentStatus) => {
  const typeMap: Record<PaymentStatus, any> = {
    unpaid: 'warning',
    paid: 'success',
    partial: 'info',
    refunded: 'danger'
  }
  return typeMap[status] || 'info'
}

const getPaymentStatusText = (status: PaymentStatus) => {
  const textMap: Record<PaymentStatus, string> = {
    unpaid: '未支付',
    paid: '已支付',
    partial: '部分支付',
    refunded: '已退款'
  }
  return textMap[status] || '未知'
}

// 查看详情
const viewDetail = (appointment: any) => {
  selectedAppointment.value = appointment
  showDetailDialog.value = true
}

// 取消预约
const cancelAppointment = (appointment: AppointmentItem) => {
  ElMessageBox.confirm(
    '确定要取消这个预约吗？',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      const response = await cancelAppointmentApi(appointment.id)
      if (response.code === 200) {
        ElMessage.success('预约已取消')
        notificationStore.addNotification({
          title: '预约已取消',
          content: `您的预约 ${appointment.orderNo} 已取消${appointment.paymentStatus === 'paid' ? '，系统将为您处理退款。' : '。'}`,
          type: 'appointment',
          relatedId: appointment.id
        })
        if (appointment.paymentStatus === 'paid') {
          appointment.paymentStatus = 'refunded'
        }
        appointment.status = 'canceled'
        loadAppointments()
      } else {
        ElMessage.error(response.msg || '取消失败')
      }
    } catch (error: any) {
      console.error('取消预约失败：', error)
      ElMessage.error(error.message || '取消失败')
    }
  }).catch(() => {
    // 用户点击了取消按钮
  })
}

// 评价预约
const reviewAppointment = (appointment: AppointmentItem) => {
  console.log('📝 开始评价预约：', appointment)
  selectedAppointmentForReview.value = appointment
  showReviewDialog.value = true
}

const viewReview = async (appointment: AppointmentItem) => {
  if (!appointment?.id) return

  try {
    selectedAppointmentForReview.value = appointment
    if (appointment.review) {
      currentReview.value = appointment.review
      showReviewDetailDialog.value = true
      return
    }

    const response = await getReviewByAppointmentId(appointment.id)
    if (response.code === 200 && response.data) {
      const reviewData = mapReviewResponse(response.data)
      appointment.review = reviewData
      appointment.reviewed = true
      currentReview.value = reviewData
      showReviewDetailDialog.value = true
    } else {
      ElMessage.warning(response.msg || '暂未查询到评价信息')
    }
  } catch (error: any) {
    console.error('获取评价详情失败：', error)
    ElMessage.error(error.message || '获取评价详情失败')
  }
}

const openPayment = (appointment: AppointmentItem) => {
  selectedAppointmentForPayment.value = appointment
  paymentDialogDefaultMethod.value = (appointment.paymentMethod as 'alipay' | 'wechat' | 'offline') || 'alipay'
  showPaymentDialog.value = true
}

const handlePaymentConfirm = async (payload: { method: string; amount: number; payType: 'deposit' | 'full' }) => {
  const target = selectedAppointmentForPayment.value
  if (!target) return

  paymentProcessing.value = true
  try {
    const response = await payForAppointment(target.id, {
      method: payload.method,
      amount: payload.amount,
      payType: payload.payType
    })

    if (response.code === 200) {
      ElMessage.success('支付信息已同步')
      showPaymentDialog.value = false
      const status: PaymentStatus = payload.payType === 'deposit' ? 'partial' : 'paid'
      target.paymentStatus = status
      target.paymentMethod = payload.method as 'alipay' | 'wechat' | 'offline'
      notificationStore.addNotification({
        title: '支付完成',
        content: `预约 ${target.orderNo} 已通过${getPaymentMethodLabel(payload.method)}完成${status === 'partial' ? '定金' : '全额'}支付。`,
        type: 'payment',
        relatedId: target.id
      })
    } else {
      ElMessage.error(response.msg || '支付失败，请稍后重试')
    }
  } catch (error: any) {
    console.error('支付失败：', error)
    ElMessage.error(error.message || '支付失败，请稍后重试')
  } finally {
    paymentProcessing.value = false
  }
}

const handlePaymentDialogClosed = () => {
  selectedAppointmentForPayment.value = null
  paymentDialogDefaultMethod.value = 'alipay'
  paymentProcessing.value = false
}

const openReschedule = (appointment: AppointmentItem) => {
  selectedAppointmentForReschedule.value = appointment
  showRescheduleDialog.value = true
}

const handleRescheduleConfirm = async (payload: { date: string; time: string; remark: string }) => {
  const target = selectedAppointmentForReschedule.value
  if (!target) return

  try {
    const response = await rescheduleAppointment(target.id, {
      appointmentTime: `${payload.date} ${payload.time}`,
      remark: payload.remark
    })

    if (response.code === 200) {
      ElMessage.success('预约已修改')
      showRescheduleDialog.value = false
      target.appointmentDate = payload.date
      target.appointmentTime = payload.time
      target.remark = payload.remark
      notificationStore.addNotification({
        title: '预约时间已更新',
        content: `预约 ${target.orderNo} 已改期至 ${payload.date} ${payload.time}。`,
        type: 'appointment',
        relatedId: target.id
      })
    } else {
      ElMessage.error(response.msg || '修改预约失败')
    }
  } catch (error: any) {
    console.error('修改预约失败：', error)
    ElMessage.error(error.message || '修改预约失败')
  }
}

const handleRescheduleClosed = () => {
  selectedAppointmentForReschedule.value = null
}

const openComplaint = (appointment: AppointmentItem) => {
  selectedAppointmentForComplaint.value = appointment
  showComplaintDialog.value = true
}

const handleComplaintSubmit = async (payload: { appointmentId: number; type: string; content: string; contact?: string }) => {
  const target = selectedAppointmentForComplaint.value
  try {
    const response = await submitAppointmentComplaint(payload)
    if (response.code === 200) {
      ElMessage.success('投诉已提交，我们会尽快处理')
      showComplaintDialog.value = false
      if (target) {
        notificationStore.addNotification({
          title: '投诉已受理',
          content: `关于预约 ${target.orderNo} 的投诉已提交，客服将尽快联系您。`,
          type: 'complaint',
          relatedId: target.id
        })
      }
    } else {
      ElMessage.error(response.msg || '投诉提交失败')
    }
  } catch (error: any) {
    console.error('投诉提交失败：', error)
    ElMessage.error(error.message || '投诉提交失败')
  }
}

const handleComplaintClosed = () => {
  selectedAppointmentForComplaint.value = null
}

// 评价成功回调
const handleReviewSuccess = () => {
  console.log('✅ 评价成功，重新加载预约列表')
  ElMessage.success('评价提交成功！')
  loadAppointments()
}

// 跳转到商家列表
const goToShopList = () => {
  showCreateDialog.value = false
  router.push({ name: 'userHome' })
}

// 分页处理
const handleSizeChange = (val: number) => {
  pageSize.value = val
  loadAppointments()
}

const handleCurrentChange = (val: number) => {
  currentPage.value = val
  loadAppointments()
}

// 加载预约列表
const loadAppointments = async () => {
  loading.value = true
  try {
    currentReview.value = null
    showReviewDetailDialog.value = false
    const response = await getUserAppointments({
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      status: activeStatus.value === 'all' ? undefined : activeStatus.value
    })
    
    if (response.code === 200) {
      // 处理后端返回的数据，转换为前端需要的格式
      const records = response.data.records || []
      
      // 检查每个预约是否已评价
      const appointmentsWithReviewStatus = await Promise.all(
        records.map(async (item: any) => {
          let reviewed = false
          let reviewData: ReviewItem | null = null

          if (item.status === 2) {
            try {
              const reviewResponse = await getReviewByAppointmentId(item.id)
              if (reviewResponse.code === 200 && reviewResponse.data) {
                reviewData = mapReviewResponse(reviewResponse.data)
                reviewed = true
              }
            } catch (error) {
              console.log(`预约 ${item.id} 暂无评价`)
            }
          }

          const mappedStatus = mapStatus(item.status)

          return {
            id: item.id,
            orderNo: item.orderNo,
            shopName: item.merchantName || '未知商家',
            serviceName: item.serviceItemName || '未知服务',
            appointmentDate: item.appointmentTime ? item.appointmentTime.split(' ')[0] : '',
            appointmentTime: item.appointmentTime ? item.appointmentTime.split(' ')[1] : '',
            amount: item.totalAmount || 0,
            status: mappedStatus as AppointmentStatus,
            remark: item.remark || '',
            reviewed,
            review: reviewData,
            paymentStatus: mapPaymentStatus(item.paymentStatus, mappedStatus),
            paymentMethod: mapPaymentMethod(item.paymentMethod)
          }
        })
      )
      
      appointments.value = appointmentsWithReviewStatus
      total.value = response.data.total || 0
    } else {
      ElMessage.error(response.msg || '加载失败')
      // 如果加载失败，显示模拟数据
      appointments.value = mockAppointments
      total.value = mockAppointments.length
    }
  } catch (error: any) {
    console.error('加载预约列表失败：', error)
    ElMessage.warning('暂时使用模拟数据')
    // 如果API调用失败，使用模拟数据
    appointments.value = mockAppointments
    total.value = mockAppointments.length
  } finally {
    loading.value = false
  }
}

// 映射后端状态到前端状态
const mapStatus = (backendStatus: number): AppointmentStatus => {
  const statusMap: Record<number, AppointmentStatus> = {
    0: 'pending',      // 待确认
    1: 'confirmed',    // 已确认
    2: 'completed',    // 已完成
    3: 'canceled',     // 已取消
    4: 'breached'      // 已违约
  }
  return statusMap[backendStatus] || 'pending'
}

const mapPaymentStatus = (status: any, appointmentStatus: AppointmentStatus): PaymentStatus => {
  if (typeof status === 'string') {
    if (['paid', 'unpaid', 'partial', 'refunded'].includes(status)) {
      return status as PaymentStatus
    }
  }
  if (typeof status === 'number') {
    const mapping: Record<number, PaymentStatus> = {
      0: 'unpaid',
      1: 'paid',
      2: 'partial',
      3: 'refunded'
    }
    return mapping[status] ?? 'unpaid'
  }

  if (appointmentStatus === 'completed') {
    return 'paid'
  }
  if (appointmentStatus === 'canceled') {
    return 'refunded'
  }
  return 'unpaid'
}

const mapPaymentMethod = (method: any): 'alipay' | 'wechat' | 'offline' => {
  if (typeof method === 'string') {
    if (['alipay', 'wechat', 'offline'].includes(method)) {
      return method as 'alipay' | 'wechat' | 'offline'
    }
  }
  if (typeof method === 'number') {
    const mapping: Record<number, 'alipay' | 'wechat' | 'offline'> = {
      0: 'offline',
      1: 'alipay',
      2: 'wechat'
    }
    return mapping[method] ?? 'offline'
  }
  return 'alipay'
}

const getPaymentMethodLabel = (method: string) => {
  const map: Record<string, string> = {
    alipay: '支付宝',
    wechat: '微信支付',
    offline: '到店支付'
  }
  return map[method] ?? '线下支付'
}

// 初始化
onMounted(() => {
  loadAppointments()
})
</script>

<style scoped>
.user-appointments {
  width: 100%;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h3 {
  margin: 0;
  font-size: 18px;
}

.amount {
  color: #f56c6c;
  font-weight: 600;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

:deep(.el-tabs__nav-wrap::after) {
  display: none;
}

.review-detail {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.review-detail__header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
}

.review-detail__info h4 {
  margin: 0 0 4px;
  font-size: 16px;
  color: #303133;
}

.review-detail__order {
  margin: 0;
  font-size: 13px;
  color: #909399;
}

.review-detail__score {
  text-align: right;
}

.review-detail__time {
  display: block;
  margin-top: 6px;
  font-size: 12px;
  color: #909399;
}

.review-detail__content {
  padding: 12px;
  background-color: #f5f7fa;
  border-radius: 6px;
}

.review-detail__text {
  margin: 0 0 10px;
  line-height: 1.6;
  color: #606266;
}

.review-detail__images {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.review-detail__image {
  width: 90px;
  height: 90px;
  border-radius: 6px;
  object-fit: cover;
}

.review-detail__scores {
  display: grid;
  gap: 10px;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
}

.review-detail__score-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: #606266;
}

.review-detail__reply {
  padding: 14px;
  background-color: #ecf5ff;
  border-radius: 6px;
}

.review-detail__reply-label {
  font-weight: 600;
  color: #409eff;
  margin-bottom: 6px;
}

.review-detail__reply-text {
  margin: 0 0 6px;
  color: #606266;
  line-height: 1.6;
}

.review-detail__reply-time {
  font-size: 12px;
  color: #909399;
}
</style>


