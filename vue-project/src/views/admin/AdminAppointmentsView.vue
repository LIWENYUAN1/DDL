<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { ElMessage, ElTable, ElTableColumn, ElPagination, ElForm, ElFormItem, ElInput, ElButton, ElSelect, ElOption, ElDatePicker, ElDialog, ElMessageBox, ElTag } from 'element-plus'
import { Search, Filter, Refresh, View, Download, Calendar, User, Business, Clock } from '@element-plus/icons-vue'
import type { FormInstance } from 'element-plus'
import { useAppointmentStore } from '@/store/modules/appointment'

const appointmentStore = useAppointmentStore()

// 表格数据和分页
const appointments = ref<any[]>([])
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 搜索表单
const searchForm = ref({
  keyword: '', // 可以搜索用户名、商家名、预约ID
  status: '',
  appointmentType: '',
  startTime: '',
  endTime: ''
})

const searchFormRef = ref<FormInstance>()

// 对话框状态
const detailDialogVisible = ref(false)
const currentAppointment = ref<any>(null)

// 状态选项
const statusOptions = [
  { label: '待确认', value: 'pending' },
  { label: '已确认', value: 'confirmed' },
  { label: '进行中', value: 'processing' },
  { label: '已完成', value: 'completed' },
  { label: '已取消', value: 'cancelled' },
  { label: '已拒绝', value: 'rejected' }
]

// 计算属性
const filteredAppointments = computed(() => {
  let result = [...appointments.value]
  
  // 按状态筛选
  if (searchForm.value.status) {
    result = result.filter(app => app.status === searchForm.value.status)
  }
  
  // 按关键词筛选
  if (searchForm.value.keyword) {
    const keyword = searchForm.value.keyword.toLowerCase()
    result = result.filter(app => 
      app.id?.toString().includes(keyword) ||
      app.user?.username?.toLowerCase().includes(keyword) ||
      app.shop?.shopName?.toLowerCase().includes(keyword) ||
      app.services?.some((s: any) => s.name?.toLowerCase().includes(keyword))
    )
  }
  
  // 按时间范围筛选
  if (searchForm.value.startTime && searchForm.value.endTime) {
    result = result.filter(app => {
      const appointmentTime = new Date(app.appointmentTime)
      return appointmentTime >= new Date(searchForm.value.startTime) &&
             appointmentTime <= new Date(searchForm.value.endTime)
    })
  }
  
  return result
})

// 生命周期
onMounted(() => {
  loadAppointments()
})

// 加载预约列表
const loadAppointments = async () => {
  try {
    loading.value = true
    await appointmentStore.getAppointmentsList({
      page: currentPage.value,
      pageSize: pageSize.value,
      keyword: searchForm.value.keyword,
      status: searchForm.value.status,
      startTime: searchForm.value.startTime,
      endTime: searchForm.value.endTime
    })
    
    appointments.value = appointmentStore.appointmentsList || []
    total.value = appointmentStore.total || 0
  } catch (error) {
    console.error('加载预约列表失败:', error)
    ElMessage.error('加载预约列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  loadAppointments()
}

// 重置搜索
const handleReset = () => {
  searchFormRef.value?.resetFields()
  currentPage.value = 1
  loadAppointments()
}

// 刷新
const handleRefresh = () => {
  loadAppointments()
}

// 分页变化
const handlePageChange = (page: number) => {
  currentPage.value = page
  loadAppointments()
}

// 每页条数变化
const handleSizeChange = (size: number) => {
  pageSize.value = size
  currentPage.value = 1
  loadAppointments()
}

// 查看预约详情
const viewAppointmentDetail = (appointment: any) => {
  currentAppointment.value = appointment
  detailDialogVisible.value = true
}

// 导出报表
const exportReport = async () => {
  try {
    await appointmentStore.exportAppointments({
      keyword: searchForm.value.keyword,
      status: searchForm.value.status,
      startTime: searchForm.value.startTime,
      endTime: searchForm.value.endTime
    })
    
    ElMessage.success('报表导出成功')
  } catch (error) {
    console.error('导出报表失败:', error)
    ElMessage.error('导出报表失败')
  }
}

// 格式化状态
const formatStatus = (status: string) => {
  const option = statusOptions.find(opt => opt.value === status)
  return option ? option.label : status
}

// 状态标签样式
const getStatusTagStyle = (status: string) => {
  const styleMap: Record<string, any> = {
    'pending': { color: '#E6A23C', backgroundColor: '#FDF6EC' },
    'confirmed': { color: '#409EFF', backgroundColor: '#ECF5FF' },
    'processing': { color: '#67C23A', backgroundColor: '#F0F9EB' },
    'completed': { color: '#909399', backgroundColor: '#F4F4F5' },
    'cancelled': { color: '#909399', backgroundColor: '#F4F4F5' },
    'rejected': { color: '#F56C6C', backgroundColor: '#FEF0F0' }
  }
  return styleMap[status] || { color: '#909399', backgroundColor: '#F4F4F5' }
}

// 格式化时间
const formatDate = (dateString?: string) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// 格式化金额
const formatPrice = (price?: number) => {
  if (price === undefined || price === null) return '¥0.00'
  return `¥${price.toFixed(2)}`
}

// 格式化服务列表
const formatServices = (services?: any[]) => {
  if (!services || services.length === 0) return '暂无'
  return services.map(s => s.name).join(', ')
}
</script>

<template>
  <div class="admin-appointments-container">
    <div class="page-header">
      <h1>预约管理</h1>
    </div>

    <el-card class="filter-card">
      <el-form ref="searchFormRef" :model="searchForm" :inline="true" size="small">
        <el-form-item label="关键字搜索">
          <el-input
            v-model="searchForm.keyword"
            placeholder="预约ID/用户名/商家名/服务名称"
            prefix-icon="Search"
            clearable
          />
        </el-form-item>
        
        <el-form-item label="预约状态">
          <el-select v-model="searchForm.status" placeholder="全部" clearable>
            <el-option v-for="option in statusOptions" :key="option.value" :label="option.label" :value="option.value" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="预约时间">
          <el-date-picker
            v-model="[searchForm.startTime, searchForm.endTime]"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <Search /> 搜索
          </el-button>
          <el-button @click="handleReset">
            <Refresh /> 重置
          </el-button>
          <el-button @click="handleRefresh">
            <Refresh /> 刷新
          </el-button>
          <el-button type="success" @click="exportReport">
            <Download /> 导出报表
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <div class="table-header">
        <span class="table-title">预约列表</span>
        <div class="table-actions">
          <el-button type="primary" @click="loadAppointments">
            <Refresh /> 刷新列表
          </el-button>
        </div>
      </div>
      
      <el-table
        v-loading="loading"
        :data="filteredAppointments"
        stripe
        border
        style="width: 100%"
      >
        <el-table-column prop="id" label="预约ID" width="120" />
        
        <el-table-column label="用户信息" min-width="180">
          <template #default="{ row }">
            <div class="user-shop-info">
              <div class="info-item">
                <el-icon class="info-icon"><User /></el-icon>
                <span>{{ row.user?.username || '-' }}</span>
              </div>
              <div class="info-item">
                <el-icon class="info-icon"><Phone /></el-icon>
                <span>{{ row.user?.phone || '-' }}</span>
              </div>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="商家信息" min-width="180">
          <template #default="{ row }">
            <div class="user-shop-info">
              <div class="info-item">
                <el-icon class="info-icon"><Business /></el-icon>
                <span>{{ row.shop?.shopName || '-' }}</span>
              </div>
              <div class="info-item">
                <el-icon class="info-icon"><Phone /></el-icon>
                <span>{{ row.shop?.phone || '-' }}</span>
              </div>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="服务项目" min-width="200">
          <template #default="{ row }">
            <el-tooltip :content="formatServices(row.services)" placement="top">
              <div class="services-list">{{ formatServices(row.services) }}</div>
            </el-tooltip>
          </template>
        </el-table-column>
        
        <el-table-column prop="appointmentTime" label="预约时间" min-width="160">
          <template #default="{ row }">
            {{ formatDate(row.appointmentTime) }}
          </template>
        </el-table-column>
        
        <el-table-column prop="totalPrice" label="预约金额" width="100">
          <template #default="{ row }">
            <span class="price">{{ formatPrice(row.totalPrice) }}</span>
          </template>
        </el-table-column>
        
        <el-table-column prop="status" label="预约状态" width="100">
          <template #default="{ row }">
            <el-tag :style="getStatusTagStyle(row.status)">
              {{ formatStatus(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column prop="createdAt" label="创建时间" min-width="160">
          <template #default="{ row }">
            {{ formatDate(row.createdAt) }}
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button 
              type="primary" 
              size="small" 
              @click="viewAppointmentDetail(row)"
            >
              <View /> 查看
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>

    <!-- 预约详情对话框 -->
    <el-dialog
      v-model="detailDialogVisible"
      title="预约详情"
      width="700px"
      destroy-on-close
    >
      <div v-if="currentAppointment" class="appointment-detail">
        <div class="detail-section">
          <h3 class="section-title">基本信息</h3>
          <div class="detail-grid">
            <div class="detail-item">
              <span class="detail-label">预约ID：</span>
              <span class="detail-value">{{ currentAppointment.id }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">预约状态：</span>
              <el-tag :style="getStatusTagStyle(currentAppointment.status)">
                {{ formatStatus(currentAppointment.status) }}
              </el-tag>
            </div>
            <div class="detail-item">
              <span class="detail-label">预约时间：</span>
              <span class="detail-value">{{ formatDate(currentAppointment.appointmentTime) }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">创建时间：</span>
              <span class="detail-value">{{ formatDate(currentAppointment.createdAt) }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">更新时间：</span>
              <span class="detail-value">{{ formatDate(currentAppointment.updatedAt) }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">总金额：</span>
              <span class="detail-value price">{{ formatPrice(currentAppointment.totalPrice) }}</span>
            </div>
          </div>
        </div>

        <el-divider />

        <div class="detail-section">
          <h3 class="section-title">用户信息</h3>
          <div class="detail-grid">
            <div class="detail-item">
              <span class="detail-label">用户名：</span>
              <span class="detail-value">{{ currentAppointment.user?.username || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">手机号：</span>
              <span class="detail-value">{{ currentAppointment.user?.phone || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">昵称：</span>
              <span class="detail-value">{{ currentAppointment.user?.nickname || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">邮箱：</span>
              <span class="detail-value">{{ currentAppointment.user?.email || '-' }}</span>
            </div>
          </div>
        </div>

        <el-divider />

        <div class="detail-section">
          <h3 class="section-title">商家信息</h3>
          <div class="detail-grid">
            <div class="detail-item">
              <span class="detail-label">商家名称：</span>
              <span class="detail-value">{{ currentAppointment.shop?.shopName || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">联系电话：</span>
              <span class="detail-value">{{ currentAppointment.shop?.phone || '-' }}</span>
            </div>
            <div class="detail-item">
              <span class="detail-label">商家地址：</span>
              <span class="detail-value">{{ currentAppointment.shop?.address || '-' }}</span>
            </div>
          </div>
        </div>

        <el-divider />

        <div class="detail-section">
          <h3 class="section-title">服务项目</h3>
          <el-table :data="currentAppointment.services || []" style="width: 100%">
            <el-table-column prop="name" label="服务名称" />
            <el-table-column prop="price" label="服务价格" width="100">
              <template #default="{ row }">
                {{ formatPrice(row.price) }}
              </template>
            </el-table-column>
            <el-table-column prop="quantity" label="数量" width="80" />
            <el-table-column label="小计" width="100">
              <template #default="{ row }">
                {{ formatPrice((row.price || 0) * (row.quantity || 1)) }}
              </template>
            </el-table-column>
          </el-table>
        </div>

        <el-divider v-if="currentAppointment.remark" />

        <div v-if="currentAppointment.remark" class="detail-section">
          <h3 class="section-title">备注信息</h3>
          <p class="remark-text">{{ currentAppointment.remark }}</p>
        </div>
      </div>
      
      <template #footer>
        <el-button @click="detailDialogVisible = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.admin-appointments-container {
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

.table-card {
  background-color: #ffffff;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.table-title {
  font-size: 16px;
  font-weight: 500;
  color: #303133;
}

.table-actions {
  display: flex;
  gap: 10px;
}

/* 用户商家信息样式 */
.user-shop-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 6px;
}

.info-icon {
  font-size: 14px;
  color: #909399;
}

.services-list {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100%;
}

.price {
  color: #F56C6C;
  font-weight: 500;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* 详情对话框样式 */
.appointment-detail {
  padding: 10px;
}

.detail-section {
  margin-bottom: 20px;
}

.section-title {
  font-size: 16px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 15px;
}

.detail-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}

.detail-item {
  display: flex;
  align-items: center;
}

.detail-label {
  font-size: 14px;
  color: #909399;
  width: 100px;
  flex-shrink: 0;
}

.detail-value {
  font-size: 14px;
  color: #303133;
  flex: 1;
}

.remark-text {
  font-size: 14px;
  color: #606266;
  line-height: 1.6;
  white-space: pre-wrap;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .admin-appointments-container {
    padding: 10px;
  }
  
  .table-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .pagination-container {
    justify-content: center;
  }
  
  .detail-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .page-header h1 {
    font-size: 20px;
  }
  
  .el-form--inline .el-form-item {
    margin-right: 0;
    margin-bottom: 10px;
  }
}
</style>