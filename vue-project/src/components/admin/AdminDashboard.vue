<template>
  <div class="admin-dashboard">
    <el-row :gutter="20">
      <el-col :span="6" v-for="stat in stats" :key="stat.title">
        <el-card shadow="hover">
          <div class="stat-card">
            <div class="stat-icon" :style="{ background: stat.color }">
              <el-icon :size="32"><component :is="stat.icon" /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stat.value }}</div>
              <div class="stat-title">{{ stat.title }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { User, Shop, Document, TrendCharts } from '@element-plus/icons-vue'

const stats = ref([
  { title: '用户总数', value: 1520, icon: User, color: '#1890ff' },
  { title: '商家总数', value: 85, icon: Shop, color: '#52c41a' },
  { title: '订单总数', value: 3680, icon: Document, color: '#fa8c16' },
  { title: '总收入', value: '¥156,800', icon: TrendCharts, color: '#eb2f96' }
])
</script>

<style scoped>
.stat-card { display: flex; gap: 15px; }
.stat-icon { width: 60px; height: 60px; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white; }
.stat-value { font-size: 24px; font-weight: 600; }
.stat-title { font-size: 14px; color: #909399; margin-top: 5px; }
</style>


