<template>
  <div class="shop-services">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <h3>服务项目管理</h3>
          <el-button type="primary" @click="showAddDialog = true">添加服务</el-button>
        </div>
      </template>
      <el-table :data="services" v-loading="loading">
        <el-table-column prop="name" label="服务名称" />
        <el-table-column prop="price" label="价格" />
        <el-table-column prop="duration" label="时长(分钟)" />
        <el-table-column prop="status" label="状态">
          <template #default="{ row }">
            <el-switch v-model="row.status" />
          </template>
        </el-table-column>
        <el-table-column label="操作">
          <template #default="{ row }">
            <el-button size="small" @click="editService(row)">编辑</el-button>
            <el-button size="small" type="danger" @click="deleteService(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    <el-dialog v-model="showAddDialog" title="添加服务">
      <el-form :model="serviceForm" label-width="100px">
        <el-form-item label="服务名称"><el-input v-model="serviceForm.name" /></el-form-item>
        <el-form-item label="价格"><el-input-number v-model="serviceForm.price" /></el-form-item>
        <el-form-item label="时长"><el-input-number v-model="serviceForm.duration" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="submitService">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'

const loading = ref(false)
const showAddDialog = ref(false)
const services = ref([
  { id: 1, name: '更换机油', price: 150, duration: 30, status: true }
])
const serviceForm = reactive({ name: '', price: 0, duration: 0 })

const editService = (service: any) => { console.log('编辑', service) }
const deleteService = (service: any) => { ElMessage.success('已删除') }
const submitService = () => { showAddDialog.value = false; ElMessage.success('已添加') }
</script>

<style scoped>
.card-header { display: flex; justify-content: space-between; align-items: center; }
h3 { margin: 0; font-size: 18px; }
</style>


