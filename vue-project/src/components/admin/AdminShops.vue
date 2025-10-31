<template>
  <el-card>
    <el-table :data="shops" v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="商家名称" />
      <el-table-column prop="phone" label="电话" />
      <el-table-column prop="address" label="地址" />
      <el-table-column prop="status" label="状态">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'warning'">
            {{ row.status === 0 ? '待审核' : row.status === 1 ? '已通过' : '已驳回' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template #default="{ row }">
          <el-button v-if="row.status === 0" size="small" type="success">审核通过</el-button>
          <el-button v-if="row.status === 0" size="small" type="danger">驳回</el-button>
        </template>
      </el-table-column>
    </el-table>
  </el-card>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const loading = ref(false)
const shops = ref([
  { id: 1, name: '极速摩托维修店', phone: '13900139000', address: '大理市', status: 1 }
])
</script>


