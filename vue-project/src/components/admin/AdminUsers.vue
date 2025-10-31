<template>
  <el-card>
    <el-table :data="users" v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="username" label="用户名" />
      <el-table-column prop="phone" label="手机号" />
      <el-table-column prop="userType" label="类型">
        <template #default="{ row }">
          <el-tag>{{ row.userType === 1 ? '普通用户' : row.userType === 2 ? '商家' : '管理员' }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态">
        <template #default="{ row }">
          <el-switch v-model="row.status" />
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="注册时间" />
    </el-table>
  </el-card>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const loading = ref(false)
const users = ref([
  { id: 1, username: 'testuser1', phone: '13800138001', userType: 1, status: true, createTime: '2025-01-20' }
])
</script>


