<template>
  <div class="shop-orders">
    <el-card shadow="never">
      <template #header><h3>订单管理</h3></template>
      <el-tabs v-model="activeStatus">
        <el-tab-pane label="全部" name="all" />
        <el-tab-pane label="待确认" name="pending" />
        <el-tab-pane label="进行中" name="in_progress" />
        <el-tab-pane label="已完成" name="completed" />
      </el-tabs>
      <el-table :data="orders" v-loading="loading">
        <el-table-column prop="orderNo" label="订单号" width="150" />
        <el-table-column prop="customerName" label="客户" />
        <el-table-column prop="serviceName" label="服务" />
        <el-table-column prop="amount" label="金额" />
        <el-table-column prop="status" label="状态">
          <template #default="{ row }">
            <el-tag :type="row.status === 'completed' ? 'success' : 'warning'">
              {{ row.statusText }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template #default="{ row }">
            <el-button size="small" @click="viewOrder(row)">查看</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const loading = ref(false)
const activeStatus = ref('all')
const orders = ref([
  { id: 1, orderNo: 'ORD001', customerName: '张三', serviceName: '保养', amount: 200, status: 'completed', statusText: '已完成' }
])

const viewOrder = (order: any) => {
  console.log('查看订单', order)
}
</script>

<style scoped>
h3 { margin: 0; font-size: 18px; }
</style>


