<template>
  <div class="shop-info">
    <el-card shadow="never">
      <template #header><h3>店铺信息</h3></template>
      <el-form :model="shopForm" label-width="100px">
        <el-form-item label="店铺名称"><el-input v-model="shopForm.name" /></el-form-item>
        <el-form-item label="联系电话"><el-input v-model="shopForm.phone" /></el-form-item>
        <el-form-item label="店铺地址"><el-input v-model="shopForm.address" type="textarea" /></el-form-item>
        <el-form-item label="营业时间"><el-input v-model="shopForm.businessHours" /></el-form-item>
        <el-form-item><el-button type="primary" @click="saveShopInfo">保存</el-button></el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { reactive } from 'vue'
import { ElMessage } from 'element-plus'

const shopForm = reactive({
  name: '极速摩托维修店',
  phone: '13900139000',
  address: '云南省大理市下关镇幸福路100号',
  businessHours: '09:00-20:00'
})

const saveShopInfo = () => { ElMessage.success('保存成功') }
</script>

<style scoped>
h3 { margin: 0; font-size: 18px; }
</style>


