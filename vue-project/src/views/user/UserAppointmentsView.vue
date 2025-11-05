<script setup>
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Calendar, Clock, Star, StarFilled, MapPin, Phone, User, Shop, Close, Check, WarningFilled, InfoFilled } from '@element-plus/icons-vue'
import { useAppointmentStore } from '@/store/modules/appointment'
import { useRouter } from 'vue-router'

const router = useRouter()
const appointmentStore = useAppointmentStore()

// 界面状态
const activeTab = ref('pending') // pending, completed, canceled
const loading = ref(false)
const loadingText = ref('')

// 计算属性
const appointments = computed(() => {
  return appointmentStore.userAppointments.filter(appointment => {
    if (activeTab.value === 'pending') {
      return ['pending', 'confirmed'].includes(appointment.status)
    } else if (activeTab.value === 'completed') {
      return appointment.status === 'completed'
    } else if (activeTab.value === 'canceled') {
      return appointment.status === 'canceled'
    } else if (activeTab.value === 'breached') {
      return appointment.status === 'breached'
    }
    return true
  })
})

const statusConfig = {
  pending: { text: '待确认', color: 'warning', icon: Clock },
  confirmed: { text: '已确认', color: 'primary', icon: Check },
  completed: { text: '已完成', color: 'success', icon: StarFilled },
  canceled: { text: '已取消', color: 'danger', icon: Close },
  breached: { text: '已违约', color: 'danger', icon: WarningFilled }
}

// 获取状态颜色
const getStatusColor = (status) => {
  return statusConfig[status]?.color || 'default'
}

// 获取状态图标
const getStatusIcon = (status) => {
  return statusConfig[status]?.icon || InfoFilled
}

// 获取状态文本
const getStatusText = (status) => {
  return statusConfig[status]?.text || '未知状态'
}

// 生命周期
onMounted(async () => {
  await fetchUserAppointments()
})

// 获取用户预约列表
const fetchUserAppointments = async () => {
  try {
    loading.value = true
    
    // 如果已经有预约数据（比如刚刚创建的模拟预约），则直接使用
    if (appointmentStore.userAppointments.length > 0) {
      ElMessage.success('已加载预约数据')
      return
    }
    
    // 尝试从后端获取数据，如果失败则使用模拟数据
    try {
      await appointmentStore.getUserAppointments()
    } catch (backendError) {
      console.warn('后端获取失败，使用模拟数据:', backendError)
      // 添加一些模拟预约数据
      const mockAppointments = [
        {
          id: '1',
          shopId: '1',
          shopName: '极速摩托车维修中心',
          shopAddress: '北京市朝阳区建国路88号',
          shopPhone: '13800138001',
          serviceId: '101',
          serviceName: '摩托车保养',
          serviceDescription: '专业摩托车常规保养服务',
          appointmentTime: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(), // 明天
          remark: '希望准时接待',
          price: 299,
          status: 'pending',
          orderNo: 'ORD20241021001',
          createdAt: new Date().toISOString()
        },
        {
          id: '2',
          shopId: '2',
          shopName: '铁骑摩托车服务站',
          shopAddress: '北京市海淀区中关村大街1号',
          shopPhone: '13800138002',
          serviceId: '202',
          serviceName: '洗车服务',
          serviceDescription: '高压洗车+内饰清洁',
          appointmentTime: new Date(Date.now() + 48 * 60 * 60 * 1000).toISOString(), // 后天
          remark: '',
          price: 99,
          status: 'confirmed',
          orderNo: 'ORD20241021002',
          createdAt: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString() // 2小时前
        }
      ]
      
      // 添加模拟数据到store
      mockAppointments.forEach(app => {
        appointmentStore.userAppointments.push(app)
      })
      
      ElMessage.info('已加载模拟预约数据')
    }
  } catch (error) {
    console.error('获取预约列表失败:', error)
    ElMessage.error('获取预约列表失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 取消预约
const cancelAppointment = async (appointmentId) => {
  try {
    await ElMessageBox.confirm(
      '确定要取消该预约吗？',
      '取消预约',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    loadingText.value = appointmentId
    await appointmentStore.updateAppointmentStatus(appointmentId, 'canceled')
    ElMessage.success('预约已取消')
  } catch (error) {
    if (error !== 'cancel') {
      console.error('取消预约失败:', error)
      ElMessage.error('取消预约失败，请稍后重试')
    }
  } finally {
    loadingText.value = ''
  }
}

// 去评价
const goToRate = (appointmentId) => {
  router.push(`/user/ratings/create?appointmentId=${appointmentId}`)
}

// 重新预约
const reBook = (appointmentId) => {
  const appointment = appointmentStore.userAppointments.find(a => a.id === appointmentId)
  if (appointment) {
    router.push(`/user/home?shopId=${appointment.shopId}`)
  }
}

// 格式化日期
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  }).format(date)
}
</script>

<template>
  <div class="user-appointments-container">
    <div class="page-header">
      <h1>我的预约</h1>
    </div>

    <!-- 标签页 -->
    <el-tabs v-model="activeTab" class="appointment-tabs" @tab-click="fetchUserAppointments">
      <el-tab-pane label="待处理" name="pending">
        <div class="appointment-list">
          <div v-if="loading" class="loading-state">
            <el-skeleton :rows="3" animated />
          </div>
          
          <div v-else-if="appointments.length === 0" class="empty-state">
            <el-empty description="暂无待处理的预约" />
          </div>
          
          <el-card 
            v-for="appointment in appointments" 
            :key="appointment.id"
            class="appointment-card"
            shadow="hover"
          >
            <div class="appointment-header">
              <div class="shop-info">
                <h3>{{ appointment.shopName }}</h3>
                <div class="shop-meta">
                  <span class="meta-item"><MapPin class="meta-icon" /> {{ appointment.shopAddress }}</span>
                  <span class="meta-item"><Phone class="meta-icon" /> {{ appointment.shopPhone }}</span>
                </div>
              </div>
              <el-tag 
                :type="getStatusColor(appointment.status)"
                size="large"
              >
                <el-icon><component :is="getStatusIcon(appointment.status)"></component></el-icon>
                {{ getStatusText(appointment.status) }}
              </el-tag>
            </div>

            <div class="appointment-body">
              <div class="service-info">
                <h4>{{ appointment.serviceName }}</h4>
                <p class="service-desc">{{ appointment.serviceDescription || '暂无描述' }}</p>
              </div>
              
              <div class="appointment-details">
                <div class="detail-item">
                  <div class="detail-label">预约时间</div>
                  <div class="detail-value">
                    <el-icon><Calendar /></el-icon>
                    {{ formatDate(appointment.appointmentTime) }}
                  </div>
                </div>
                <div class="detail-item">
                  <div class="detail-label">预约金额</div>
                  <div class="detail-value price">¥{{ appointment.price.toFixed(2) }}</div>
                </div>
                <div class="detail-item">
                  <div class="detail-label">预约单号</div>
                  <div class="detail-value">{{ appointment.orderNo }}</div>
                </div>
                <div class="detail-item">
                  <div class="detail-label">下单时间</div>
                  <div class="detail-value">{{ formatDate(appointment.createdAt) }}</div>
                </div>
              </div>
            </div>

            <div class="appointment-footer">
              <el-button 
                v-if="appointment.status === 'pending'" 
                type="danger" 
                @click="cancelAppointment(appointment.id)"
                :loading="loadingText === appointment.id"
              >
                取消预约
              </el-button>
              <el-button 
                v-if="appointment.status === 'completed'" 
                type="primary" 
                @click="goToRate(appointment.id)"
              >
                <Star /> 去评价
              </el-button>
              <el-button 
                v-if="appointment.status === 'canceled'" 
                @click="reBook(appointment.id)"
              >
                重新预约
              </el-button>
            </div>
          </el-card>
        </div>
      </el-tab-pane>

      <el-tab-pane label="已完成" name="completed">
        <div class="appointment-list">
          <div v-if="loading" class="loading-state">
            <el-skeleton :rows="3" animated />
          </div>
          
          <div v-else-if="appointments.length === 0" class="empty-state">
            <el-empty description="暂无已完成的预约" />
          </div>
          
          <el-card 
            v-for="appointment in appointments" 
            :key="appointment.id"
            class="appointment-card"
            shadow="hover"
          >
            <div class="appointment-header">
              <div class="shop-info">
                <h3>{{ appointment.shopName }}</h3>
                <div class="shop-meta">
                  <span class="meta-item"><MapPin class="meta-icon" /> {{ appointment.shopAddress }}</span>
                  <span class="meta-item"><Phone class="meta-icon" /> {{ appointment.shopPhone }}</span>
                </div>
              </div>
              <el-tag 
                :type="getStatusColor(appointment.status)"
          size="large"
        >
          <el-icon><component :is="getStatusIcon(appointment.status)"></component></el-icon>
          {{ getStatusText(appointment.status) }}
              </el-tag>
            </div>

            <div class="appointment-body">
              <div class="service-info">
                <h4>{{ appointment.serviceName }}</h4>
                <p class="service-desc">{{ appointment.serviceDescription || '暂无描述' }}</p>
              </div>
              
              <div class="appointment-details">
                <div class="detail-item">
                  <div class="detail-label">预约时间</div>
                  <div class="detail-value">
                    <el-icon><Calendar /></el-icon>
                    {{ formatDate(appointment.appointmentTime) }}
                  </div>
                </div>
                <div class="detail-item">
                  <div class="detail-label">服务技师</div>
                  <div class="detail-value">{{ appointment.technicianName || '系统分配' }}</div>
                </div>
                <div class="detail-item">
                  <div class="detail-label">预约金额</div>
                  <div class="detail-value price">¥{{ appointment.price.toFixed(2) }}</div>
                </div>
                <div class="detail-item">
                  <div class="detail-label">完成时间</div>
                  <div class="detail-value">{{ appointment.completedAt ? formatDate(appointment.completedAt) : '-' }}</div>
                </div>
              </div>
              
              <!-- 评价信息 -->
              <div v-if="appointment.rating" class="rating-info">
                <div class="rating-header">
                  <span class="rating-label">我的评价：</span>
                  <el-rate v-model="appointment.rating.stars" disabled show-score />
                </div>
                <p class="rating-comment">{{ appointment.rating.comment || '暂无评价内容' }}</p>
              </div>
            </div>

            <div class="appointment-footer">
              <el-button 
                v-if="!appointment.rating" 
                type="primary" 
                @click="goToRate(appointment.id)"
              >
                <Star /> 去评价
              </el-button>
              <el-button @click="reBook(appointment.id)">
                再次预约
              </el-button>
            </div>
          </el-card>
        </div>
      </el-tab-pane>

      <el-tab-pane label="已取消" name="canceled">
        <div class="appointment-list">
          <div v-if="loading" class="loading-state">
            <el-skeleton :rows="3" animated />
          </div>
          
          <div v-else-if="appointments.length === 0" class="empty-state">
            <el-empty description="暂无已取消的预约" />
          </div>
          
          <el-card 
            v-for="appointment in appointments" 
            :key="appointment.id"
            class="appointment-card"
            shadow="hover"
          >
            <div class="appointment-header">
              <div class="shop-info">
                <h3>{{ appointment.shopName }}</h3>
                <div class="shop-meta">
                  <span class="meta-item"><MapPin class="meta-icon" /> {{ appointment.shopAddress }}</span>
                  <span class="meta-item"><Phone class="meta-icon" /> {{ appointment.shopPhone }}</span>
                </div>
              </div>
              <el-tag 
                :type="getStatusColor(appointment.status)"
              size="large"
            >
              <el-icon><component :is="getStatusIcon(appointment.status)"></component></el-icon>
              {{ getStatusText(appointment.status) }}
              </el-tag>
            </div>

            <div class="appointment-body">
              <div class="service-info">
                <h4>{{ appointment.serviceName }}</h4>
                <p class="service-desc">{{ appointment.serviceDescription || '暂无描述' }}</p>
              </div>
              
              <div class="appointment-details">
                <div class="detail-item">
                  <div class="detail-label">预约时间</div>
                  <div class="detail-value">
                    <el-icon><Calendar /></el-icon>
                    {{ formatDate(appointment.appointmentTime) }}
                  </div>
                </div>
                <div class="detail-item">
                  <div class="detail-label">取消原因</div>
                  <div class="detail-value">{{ appointment.cancelReason || '用户取消' }}</div>
                </div>
                <div class="detail-item">
                  <div class="detail-label">取消时间</div>
                  <div class="detail-value">{{ appointment.canceledAt ? formatDate(appointment.canceledAt) : '-' }}</div>
                </div>
              </div>
            </div>

            <div class="appointment-footer">
              <el-button @click="reBook(appointment.id)">
                重新预约
              </el-button>
            </div>
          </el-card>
        </div>
      </el-tab-pane>

      <el-tab-pane label="已违约" name="breached">
        <div class="appointment-list">
          <div v-if="loading" class="loading-state">
            <el-skeleton :rows="3" animated />
          </div>

          <div v-else-if="appointments.length === 0" class="empty-state">
            <el-empty description="暂无违约的预约" />
          </div>

          <el-card
            v-for="appointment in appointments"
            :key="appointment.id"
            class="appointment-card"
            shadow="hover"
          >
            <div class="appointment-header">
              <div class="shop-info">
                <h3>{{ appointment.shopName }}</h3>
                <div class="shop-meta">
                  <span class="meta-item"><MapPin class="meta-icon" /> {{ appointment.shopAddress }}</span>
                  <span class="meta-item"><Phone class="meta-icon" /> {{ appointment.shopPhone }}</span>
                </div>
              </div>
              <el-tag
                :type="getStatusColor(appointment.status)"
                size="large"
              >
                <el-icon><component :is="getStatusIcon(appointment.status)"></component></el-icon>
                {{ getStatusText(appointment.status) }}
              </el-tag>
            </div>

            <div class="appointment-body">
              <div class="service-info">
                <h4>{{ appointment.serviceName }}</h4>
                <p class="service-desc">{{ appointment.serviceDescription || '暂无描述' }}</p>
              </div>

              <div class="appointment-details">
                <div class="detail-item">
                  <div class="detail-label">预约时间</div>
                  <div class="detail-value">
                    <el-icon><Calendar /></el-icon>
                    {{ formatDate(appointment.appointmentTime) }}
                  </div>
                </div>
                <div class="detail-item">
                  <div class="detail-label">违约说明</div>
                  <div class="detail-value">{{ appointment.breachReason || '系统记录违约' }}</div>
                </div>
                <div class="detail-item">
                  <div class="detail-label">违约时间</div>
                  <div class="detail-value">{{ appointment.breachedAt ? formatDate(appointment.breachedAt) : '-' }}</div>
                </div>
              </div>
            </div>

            <div class="appointment-footer">
              <el-button type="primary" @click="reBook(appointment.id)">
                再次预约
              </el-button>
            </div>
          </el-card>
        </div>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<style scoped>
.user-appointments-container {
  padding: 20px;
}

.page-header {
  margin-bottom: 30px;
}

.page-header h1 {
  font-size: 24px;
  font-weight: 500;
  color: #303133;
}

.appointment-tabs {
  background-color: #ffffff;
  border-radius: 8px;
  padding: 0 20px 20px;
}

.appointment-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
  margin-top: 20px;
}

.appointment-card {
  transition: all 0.3s ease;
}

.appointment-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
}

.appointment-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid #ebeef5;
}

.shop-info h3 {
  font-size: 18px;
  font-weight: 500;
  margin-bottom: 10px;
  color: #303133;
}

.shop-meta {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 5px;
  color: #606266;
  font-size: 14px;
}

.meta-icon {
  font-size: 14px;
}

.appointment-body {
  margin-bottom: 20px;
}

.service-info {
  margin-bottom: 20px;
}

.service-info h4 {
  font-size: 16px;
  font-weight: 500;
  margin-bottom: 8px;
  color: #303133;
}

.service-desc {
  color: #606266;
  font-size: 14px;
  line-height: 1.6;
}

.appointment-details {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 15px;
  margin-bottom: 20px;
}

.detail-item {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.detail-label {
  font-size: 13px;
  color: #909399;
}

.detail-value {
  font-size: 14px;
  color: #303133;
  display: flex;
  align-items: center;
  gap: 5px;
}

.detail-value.price {
  color: #f56c6c;
  font-weight: 500;
  font-size: 16px;
}

.rating-info {
  padding: 15px;
  background-color: #f5f7fa;
  border-radius: 6px;
  margin-top: 15px;
}

.rating-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}

.rating-label {
  font-size: 14px;
  color: #606266;
}

.rating-comment {
  font-size: 14px;
  color: #303133;
  line-height: 1.6;
}

.appointment-footer {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding-top: 15px;
  border-top: 1px solid #ebeef5;
}

.loading-state {
  padding: 20px;
}

.empty-state {
  padding: 40px 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .user-appointments-container {
    padding: 10px;
  }
  
  .appointment-tabs {
    padding: 0 15px 15px;
  }
  
  .appointment-header {
    flex-direction: column;
    gap: 15px;
    align-items: flex-start;
  }
  
  .shop-meta {
    flex-direction: column;
    gap: 8px;
  }
  
  .appointment-details {
    grid-template-columns: 1fr;
  }
  
  .appointment-footer {
    flex-direction: column;
    gap: 10px;
  }
}

@media (max-width: 480px) {
  .page-header h1 {
    font-size: 20px;
  }
  
  .shop-info h3 {
    font-size: 16px;
  }
  
  .service-info h4 {
    font-size: 15px;
  }
}
</style>