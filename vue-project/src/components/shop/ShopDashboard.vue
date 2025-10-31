<template>
  <div class="shop-dashboard">
    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stats-row">
      <el-col :xs="24" :sm="12" :md="6">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background-color: #ecf5ff; color: #409eff;">
              <el-icon><DocumentCopy /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.totalOrders }}</div>
              <div class="stat-label">总订单数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background-color: #f0f9ff; color: #67c23a;">
              <el-icon><Check /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.completedOrders }}</div>
              <div class="stat-label">已完成</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background-color: #fef0f0; color: #f56c6c;">
              <el-icon><Wallet /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">¥{{ stats.totalRevenue }}</div>
              <div class="stat-label">总收入</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="12" :md="6">
        <el-card shadow="hover" class="stat-card">
          <div class="stat-content">
            <div class="stat-icon" style="background-color: #fdf6ec; color: #e6a23c;">
              <el-icon><Star /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.avgRating }}</div>
              <div class="stat-label">平均评分</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 待处理订单 -->
    <el-card shadow="never" class="section-card">
      <template #header>
        <h3>待处理订单</h3>
      </template>
      <el-table :data="pendingOrders" v-loading="loading">
        <el-table-column prop="orderNo" label="订单号" width="150" />
        <el-table-column prop="customerName" label="客户" width="100" />
        <el-table-column prop="serviceName" label="服务项目" />
        <el-table-column prop="appointmentTime" label="预约时间" width="150" />
        <el-table-column prop="amount" label="金额" width="100">
          <template #default="{ row }">¥{{ row.amount }}</template>
        </el-table-column>
        <el-table-column label="操作" width="180">
          <template #default="{ row }">
            <el-button size="small" type="success" @click="confirmOrder(row)">确认</el-button>
            <el-button size="small" type="danger" @click="rejectOrder(row)">拒绝</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { DocumentCopy, Check, Wallet, Star } from '@element-plus/icons-vue'

const loading = ref(false)

const stats = reactive({
  totalOrders: 156,
  completedOrders: 128,
  totalRevenue: 45680,
  avgRating: 4.8
})

const pendingOrders = ref([
  { id: 1, orderNo: 'ORD20250121001', customerName: '张三', serviceName: '更换机油', appointmentTime: '2025-01-25 10:00', amount: 150 },
  { id: 2, orderNo: 'ORD20250121002', customerName: '李四', serviceName: '轮胎更换', appointmentTime: '2025-01-25 14:00', amount: 300 }
])

const confirmOrder = (order: any) => {
  ElMessage.success('订单已确认')
}

const rejectOrder = (order: any) => {
  ElMessage.warning('订单已拒绝')
}

onMounted(() => {
  // 加载数据
})
</script>

<style scoped>
.shop-dashboard {
  width: 100%;
}

.stats-row {
  margin-bottom: 20px;
}

.stat-card {
  margin-bottom: 20px;
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 15px;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 4px;
}

.stat-label {
  font-size: 14px;
  color: #909399;
}

.section-card h3 {
  margin: 0;
  font-size: 18px;
}
</style>


