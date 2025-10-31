<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Calendar, Clock, User, Star, StarFilled, Phone, Car, Check, Close, RefreshLeft, Search, Filter } from '@element-plus/icons-vue'
import { useAppointmentStore } from '@/store/modules/appointment'

const appointmentStore = useAppointmentStore()

// 界面状态
const searchQuery = ref('')
const statusFilter = ref('all')
const loading = ref(false)
const loadingText = ref('')
const dateRange = ref<[Date | null, Date | null]>([null, null])

// 计算属性
const shopAppointments = computed(() => {
  let filtered = appointmentStore.shopAppointments
  
  // 按状态筛选
  if (statusFilter.value !== 'all') {
    filtered = filtered.filter(appointment => appointment.status === statusFilter.value)
  }
  
  // 按搜索关键词筛选
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(appointment => 
      appointment.userName?.toLowerCase().includes(query) ||
      appointment.userPhone?.includes(query) ||
      appointment.serviceName?.toLowerCase().includes(query) ||
      appointment.orderNo?.includes(query)
    )
  }
  
  // 按日期范围筛选
  if (dateRange.value[0] && dateRange.value[1]) {
    const startDate = new Date(dateRange.value[0])
    const endDate = new Date(dateRange.value[1])
    endDate.setHours(23, 59, 59, 999)
    
    filtered = filtered.filter(appointment => {
      const appointmentDate = new Date(appointment.appointmentTime)
      return appointmentDate >= startDate && appointmentDate <= endDate
    })
  }
  
  // 按预约时间倒序排序
  return filtered.sort((a, b) => 
    new Date(b.appointmentTime).getTime() - new Date(a.appointmentTime).getTime()
  )
})

const statusConfig = {
  pending: { text: '待确认', color: 'warning', icon: 'Clock' },
  confirmed: { text: '已确认', color: 'primary', icon: 'Check' },
  in_progress: { text: '进行中', color: 'info', icon: 'RefreshLeft' },
  completed: { text: '已完成', color: 'success', icon: 'StarFilled' },
  canceled: { text: '已取消', color: 'danger', icon: 'Close' }
}

// 获取状态颜色
const getStatusColor = (status) => {
  return statusConfig[status]?.color || 'default'
}

// 获取状态图标
const getStatusIcon = (status) => {
  return statusConfig[status]?.icon || 'InfoFilled'
}

// 获取状态文本
const getStatusText = (status) => {
  return statusConfig[status]?.text || '未知状态'
}

const statusOptions = [
  { label: '全部', value: 'all' },
  { label: '待确认', value: 'pending' },
  { label: '已确认', value: 'confirmed' },
  { label: '进行中', value: 'in_progress' },
  { label: '已完成', value: 'completed' },
  { label: '已取消', value: 'canceled' }
]

// 生命周期
onMounted(async () => {
  await fetchShopAppointments()
})

// 获取商家预约列表
const fetchShopAppointments = async () => {
  try {
    loading.value = true
    await appointmentStore.getShopAppointments()
  } catch (error) {
    console.error('获取预约列表失败:', error)
    ElMessage.error('获取预约列表失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 更新预约状态
const updateAppointmentStatus = async (appointmentId: string, newStatus: string) => {
  try {
    let confirmMessage = ''
    let confirmTitle = ''
    
    switch (newStatus) {
      case 'confirmed':
        confirmTitle = '确认预约'
        confirmMessage = '确定要确认该预约吗？'
        break
      case 'in_progress':
        confirmTitle = '开始服务'
        confirmMessage = '确定要开始为该客户服务吗？'
        break
      case 'completed':
        confirmTitle = '完成服务'
        confirmMessage = '确定该服务已完成吗？'
        break
      case 'canceled':
        confirmTitle = '取消预约'
        confirmMessage = '确定要取消该预约吗？'
        break
    }
    
    if (confirmMessage) {
      await ElMessageBox.confirm(
        confirmMessage,
        confirmTitle,
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: newStatus === 'canceled' ? 'warning' : 'primary'
        }
      )
    }
    
    loadingText.value = appointmentId
    await appointmentStore.updateAppointmentStatus(appointmentId, newStatus)
    ElMessage.success('操作成功')
  } catch (error) {
    if (error !== 'cancel') {
      console.error('操作失败:', error)
      ElMessage.error('操作失败，请稍后重试')
    }
  } finally {
    loadingText.value = ''
  }
}

// 获取可执行的操作
const getAvailableActions = (status: string) => {
  const actions = []
  
  switch (status) {
    case 'pending':
      actions.push(
        { text: '确认', value: 'confirmed', type: 'primary' },
        { text: '取消', value: 'canceled', type: 'danger' }
      )
      break
    case 'confirmed':
      actions.push(
        { text: '开始服务', value: 'in_progress', type: 'primary' },
        { text: '取消', value: 'canceled', type: 'danger' }
      )
      break
    case 'in_progress':
      actions.push(
        { text: '完成', value: 'completed', type: 'success' }
      )
      break
  }
  
  return actions
}

// 格式化日期
const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return new Intl.DateTimeFormat('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  }).format(date)
}

// 重置筛选条件
const resetFilters = () => {
  searchQuery.value = ''
  statusFilter.value = 'all'
  dateRange.value = [null, null]
}
</script>

<template>
  <div class="shop-appointments-container">
    <div class="page-header">
      <h1>预约管理</h1>
    </div>

    <!-- 筛选区域 -->
    <el-card class="filter-card">
      <div class="filter-content">
        <div class="filter-item">
          <el-input
            v-model="searchQuery"
            placeholder="搜索用户姓名、电话、服务项目或预约单号"
            prefix-icon="Search"
            clearable
          />
        </div>
        
        <div class="filter-item">
          <el-select
            v-model="statusFilter"
            placeholder="选择状态"
            prefix-icon="Filter"
            clearable
          >
            <el-option
              v-for="option in statusOptions"
              :key="option.value"
              :label="option.label"
              :value="option.value"
            />
          </el-select>
        </div>
        
        <div class="filter-item">
          <el-date-picker
            v-model="dateRange"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
          />
        </div>
        
        <div class="filter-item">
          <el-button type="primary" @click="fetchShopAppointments">
            <Search /> 查询
          </el-button>
          <el-button @click="resetFilters">
            重置
          </el-button>
        </div>
      </div>
    </el-card>

    <!-- 预约列表 -->
    <el-card class="appointments-card">
      <div v-if="loading" class="loading-state">
        <el-skeleton :rows="5" animated />
      </div>
      
      <div v-else-if="shopAppointments.length === 0" class="empty-state">
        <el-empty description="暂无预约记录" />
      </div>
      
      <el-table 
        v-else
        :data="shopAppointments" 
        style="width: 100%"
        border
        :row-style="{ cursor: 'pointer' }"
      >
        <el-table-column prop="orderNo" label="预约单号" width="180">
          <template #default="scope">
            <el-tag size="small">{{ scope.row.orderNo }}</el-tag>
          </template>
        </el-table-column>
        
        <el-table-column label="客户信息" width="200">
          <template #default="scope">
            <div class="user-info">
              <div class="user-name">{{ scope.row.userName || '未知用户' }}</div>
              <div class="user-phone">{{ scope.row.userPhone || '未提供电话' }}</div>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="服务项目" width="200">
          <template #default="scope">
            <div class="service-info">
              <div class="service-name">{{ scope.row.serviceName }}</div>
              <div class="service-price">¥{{ scope.row.price.toFixed(2) }}</div>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column prop="appointmentTime" label="预约时间" width="180">
          <template #default="scope">
            {{ formatDate(scope.row.appointmentTime) }}
          </template>
        </el-table-column>
        
        <el-table-column prop="status" label="状态" width="120">
          <template #default="scope">
            <el-tag 
              :type="getStatusColor(scope.row.status)"
            size="large"
          >
            <el-icon><component :is="getStatusIcon(scope.row.status)"></component></el-icon>
            {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column label="备注" min-width="150">
          <template #default="scope">
            <el-tooltip :content="scope.row.remark || '无备注'" placement="top">
              <span>{{ scope.row.remark || '无备注' }}</span>
            </el-tooltip>
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="scope">
            <div class="action-buttons">
              <el-button
                v-for="action in getAvailableActions(scope.row.status)"
                :key="action.value"
                :type="action.type"
                size="small"
                @click="updateAppointmentStatus(scope.row.id, action.value)"
                :loading="loadingText === scope.row.id"
              >
                {{ action.text }}
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<style scoped>
.shop-appointments-container {
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

.filter-card {
  margin-bottom: 20px;
}

.filter-content {
  display: flex;
  gap: 15px;
  flex-wrap: wrap;
  align-items: flex-end;
}

.filter-item {
  flex: 1;
  min-width: 200px;
}

.filter-item:last-child {
  flex-shrink: 0;
  display: flex;
  gap: 10px;
}

.appointments-card {
  overflow-x: auto;
}

.user-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.user-name {
  font-weight: 500;
  color: #303133;
}

.user-phone {
  font-size: 13px;
  color: #606266;
}

.service-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.service-name {
  color: #303133;
}

.service-price {
  font-size: 13px;
  color: #f56c6c;
  font-weight: 500;
}

.action-buttons {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.loading-state {
  padding: 20px;
}

.empty-state {
  padding: 40px 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .shop-appointments-container {
    padding: 10px;
  }
  
  .filter-content {
    flex-direction: column;
  }
  
  .filter-item {
    min-width: 100%;
  }
  
  .filter-item:last-child {
    flex-direction: column;
    width: 100%;
  }
  
  .filter-item:last-child .el-button {
    width: 100%;
  }
  
  .el-table {
    font-size: 13px;
  }
}

@media (max-width: 480px) {
  .page-header h1 {
    font-size: 20px;
  }
}
</style>