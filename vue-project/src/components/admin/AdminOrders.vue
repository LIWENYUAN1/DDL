<template>
  <el-card>
    <el-table :data="orders" v-loading="loading">
      <el-table-column prop="orderNo" label="订单号" />
      <el-table-column prop="userName" label="用户" />
      <el-table-column prop="shopName" label="商家" />
      <el-table-column prop="amount" label="金额" />
      <el-table-column prop="status" label="状态">
        <template #default="{ row }">
          <el-tag>{{ row.statusText }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="创建时间" />
    </el-table>
  </el-card>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const loading = ref(false)
const orders = ref([
  { id: 1, orderNo: 'ORD001', userName: '张三', shopName: '极速摩托', amount: 150, status: 'completed', statusText: '已完成', createTime: '2025-01-20' }
])
</script>


