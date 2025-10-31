<template>
  <el-dialog
    v-model="visible"
    title="预约服务"
    width="700px"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <el-form
      ref="formRef"
      :model="formData"
      :rules="rules"
      label-width="120px"
      class="booking-form"
    >
      <!-- 商家信息 -->
      <div class="shop-info-section">
        <h3>商家信息</h3>
        <el-descriptions :column="2" border>
          <el-descriptions-item label="商家名称">{{ shopInfo?.name }}</el-descriptions-item>
          <el-descriptions-item label="联系电话">{{ shopInfo?.phone }}</el-descriptions-item>
          <el-descriptions-item label="商家地址" :span="2">{{ shopInfo?.address }}</el-descriptions-item>
        </el-descriptions>
      </div>

      <!-- 预约信息 -->
      <div class="booking-info-section">
        <h3>预约信息</h3>
        
        <!-- 服务项目 -->
        <el-form-item label="选择服务" prop="serviceId">
          <el-select
            v-model="formData.serviceId"
            placeholder="请选择服务项目"
            style="width: 100%"
            @change="handleServiceChange"
          >
            <el-option
              v-for="item in shopInfo?.serviceItems"
              :key="item.id"
              :label="`${item.name} - ¥${item.price} (预计${item.duration}分钟)`"
              :value="item.id"
            >
              <div class="service-option">
                <span>{{ item.name }}</span>
                <span class="price">¥{{ item.price }}</span>
              </div>
            </el-option>
          </el-select>
        </el-form-item>

        <!-- 预约时间 -->
        <el-form-item label="预约时间" prop="appointmentTime">
          <el-date-picker
            v-model="formData.appointmentTime"
            type="datetime"
            placeholder="选择日期时间"
            style="width: 100%"
            :disabled-date="disabledDate"
            :disabled-hours="disabledHours"
            format="YYYY-MM-DD HH:mm"
            value-format="YYYY-MM-DD HH:mm:ss"
          />
        </el-form-item>

        <!-- 车辆信息 -->
        <el-form-item label="摩托车型号" prop="motorcycleModel">
          <el-input
            v-model="formData.motorcycleModel"
            placeholder="例如：雅马哈 R1"
            maxlength="50"
          />
        </el-form-item>

        <el-form-item label="车牌号码" prop="licensePlate">
          <el-input
            v-model="formData.licensePlate"
            placeholder="例如：云A12345"
            maxlength="20"
          />
        </el-form-item>

        <!-- 联系方式 -->
        <el-form-item label="联系电话" prop="contactPhone">
          <el-input
            v-model="formData.contactPhone"
            placeholder="请输入手机号"
            maxlength="11"
          />
        </el-form-item>

        <!-- 问题描述 -->
        <el-form-item label="问题描述" prop="description">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="4"
            placeholder="请详细描述您的车辆问题或服务需求"
            maxlength="500"
            show-word-limit
          />
        </el-form-item>

        <!-- 备注 -->
        <el-form-item label="备注">
          <el-input
            v-model="formData.remark"
            type="textarea"
            :rows="2"
            placeholder="其他补充说明（选填）"
            maxlength="200"
            show-word-limit
          />
        </el-form-item>
      </div>

      <!-- 价格信息 -->
      <div class="price-section" v-if="selectedService">
        <el-alert
          :title="`预计费用：¥${selectedService.price} | 预计时长：${selectedService.duration}分钟`"
          type="info"
          :closable="false"
        />
      </div>
    </el-form>

    <template #footer>
      <div class="dialog-footer">
        <el-button @click="handleClose">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitting">
          确认预约
        </el-button>
      </div>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, reactive, computed, watch } from 'vue'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import { createAppointment } from '@/api/appointment'

interface ServiceItem {
  id: number
  name: string
  price: number
  duration: number
}

interface ShopInfo {
  id: number
  name: string
  phone: string
  address: string
  serviceItems: ServiceItem[]
}

interface Props {
  modelValue: boolean
  shopInfo: ShopInfo | null
  preSelectedServiceId?: number
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  shopInfo: null,
  preSelectedServiceId: undefined
})

const emit = defineEmits(['update:modelValue', 'success'])

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

const formRef = ref<FormInstance>()
const submitting = ref(false)

// 表单数据
const formData = reactive({
  merchantId: 0,
  serviceId: null as number | null,
  appointmentTime: '',
  motorcycleModel: '',
  licensePlate: '',
  contactPhone: '',
  description: '',
  remark: ''
})

// 选中的服务
const selectedService = computed(() => {
  if (!formData.serviceId || !props.shopInfo) return null
  return props.shopInfo.serviceItems.find(item => item.id === formData.serviceId)
})

// 表单验证规则
const rules: FormRules = {
  serviceId: [
    { required: true, message: '请选择服务项目', trigger: 'change' }
  ],
  appointmentTime: [
    { required: true, message: '请选择预约时间', trigger: 'change' }
  ],
  motorcycleModel: [
    { required: true, message: '请输入摩托车型号', trigger: 'blur' },
    { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
  ],
  licensePlate: [
    { required: true, message: '请输入车牌号码', trigger: 'blur' },
    { pattern: /^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z][A-Z][A-Z0-9]{4,5}[A-Z0-9挂学警港澳]$/, message: '请输入正确的车牌号', trigger: 'blur' }
  ],
  contactPhone: [
    { required: true, message: '请输入联系电话', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号', trigger: 'blur' }
  ],
  description: [
    { required: true, message: '请描述您的问题或需求', trigger: 'blur' },
    { min: 10, max: 500, message: '长度在 10 到 500 个字符', trigger: 'blur' }
  ]
}

// 监听商家信息变化
watch(() => props.shopInfo, (newVal) => {
  if (newVal) {
    formData.merchantId = newVal.id
    // 如果有预选服务，设置服务ID
    if (props.preSelectedServiceId) {
      formData.serviceId = props.preSelectedServiceId
    }
  }
}, { immediate: true })

// 禁用过去的日期
const disabledDate = (time: Date) => {
  return time.getTime() < Date.now() - 8.64e7 // 不能选择今天之前的日期
}

// 禁用非营业时间
const disabledHours = () => {
  // 这里可以根据商家的营业时间来设置
  // 例如：营业时间 9:00-20:00，则禁用 0-8 和 21-23 点
  const disabled: number[] = []
  for (let i = 0; i < 9; i++) {
    disabled.push(i)
  }
  for (let i = 21; i < 24; i++) {
    disabled.push(i)
  }
  return disabled
}

// 服务变更
const handleServiceChange = (serviceId: number) => {
  console.log('Selected service:', serviceId)
}

// 提交预约
const handleSubmit = async () => {
  if (!formRef.value) return

  try {
    await formRef.value.validate()
    
    submitting.value = true

    // 准备提交数据
    const submitData = {
      merchantId: formData.merchantId,
      serviceItemId: formData.serviceId,
      appointmentTime: formData.appointmentTime,
      motorcycleModel: formData.motorcycleModel,
      licensePlate: formData.licensePlate,
      contactPhone: formData.contactPhone,
      description: formData.description,
      remark: formData.remark
    }

    console.log('提交预约数据：', submitData)

    // 调用API
    const response = await createAppointment(submitData)
    
    if (response.code === 200) {
      ElMessage.success('预约成功！商家将尽快与您联系')
      emit('success', response.data)
      handleClose()
    } else {
      ElMessage.error(response.msg || '预约失败，请稍后重试')
    }
  } catch (error: any) {
    console.error('预约失败：', error)
    if (error.message) {
      ElMessage.error(error.message)
    }
  } finally {
    submitting.value = false
  }
}

// 关闭对话框
const handleClose = () => {
  formRef.value?.resetFields()
  formData.serviceId = null
  formData.appointmentTime = ''
  formData.motorcycleModel = ''
  formData.licensePlate = ''
  formData.contactPhone = ''
  formData.description = ''
  formData.remark = ''
  visible.value = false
}
</script>

<style scoped lang="scss">
.booking-form {
  max-height: 600px;
  overflow-y: auto;
  padding-right: 10px;

  h3 {
    font-size: 16px;
    font-weight: 600;
    color: #303133;
    margin: 0 0 16px 0;
    padding-bottom: 8px;
    border-bottom: 2px solid #409eff;
  }

  .shop-info-section {
    margin-bottom: 24px;
  }

  .booking-info-section {
    margin-bottom: 24px;
  }

  .price-section {
    margin-top: 20px;
  }

  .service-option {
    display: flex;
    justify-content: space-between;
    align-items: center;

    .price {
      color: #f56c6c;
      font-weight: 600;
    }
  }
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

:deep(.el-descriptions__label) {
  font-weight: 600;
}
</style>





