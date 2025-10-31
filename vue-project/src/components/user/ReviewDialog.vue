<template>
  <el-dialog
    v-model="visible"
    title="评价服务"
    width="600px"
    @close="handleClose"
  >
    <el-form
      ref="formRef"
      :model="formData"
      :rules="rules"
      label-width="100px"
    >
      <!-- 综合评分 -->
      <el-form-item label="综合评分" prop="score" required>
        <el-rate
          v-model="formData.score"
          :colors="rateColors"
          show-text
          :texts="['很差', '较差', '一般', '满意', '非常满意']"
        />
      </el-form-item>

      <!-- 详细评分 -->
      <el-form-item label="服务评分" prop="serviceScore">
        <el-rate
          v-model="formData.serviceScore"
          :colors="rateColors"
        />
        <span class="rate-tips">对服务态度的评价</span>
      </el-form-item>

      <el-form-item label="质量评分" prop="qualityScore">
        <el-rate
          v-model="formData.qualityScore"
          :colors="rateColors"
        />
        <span class="rate-tips">对服务质量的评价</span>
      </el-form-item>

      <el-form-item label="态度评分" prop="attitudeScore">
        <el-rate
          v-model="formData.attitudeScore"
          :colors="rateColors"
        />
        <span class="rate-tips">对服务态度的评价</span>
      </el-form-item>

      <!-- 评价内容 -->
      <el-form-item label="评价内容" prop="content">
        <el-input
          v-model="formData.content"
          type="textarea"
          :rows="4"
          placeholder="请分享您的使用体验，帮助其他用户做出选择~"
          maxlength="500"
          show-word-limit
        />
      </el-form-item>

      <!-- 是否匿名 -->
      <el-form-item label="匿名评价">
        <el-switch
          v-model="formData.isAnonymous"
          :active-value="1"
          :inactive-value="0"
          active-text="匿名"
          inactive-text="实名"
        />
      </el-form-item>
    </el-form>

    <template #footer>
      <el-button @click="handleClose">取消</el-button>
      <el-button
        type="primary"
        :loading="submitting"
        @click="handleSubmit"
      >
        提交评价
      </el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, reactive, watch } from 'vue'
import { ElMessage, type FormInstance, type FormRules } from 'element-plus'
import { createReview, type ReviewCreateDTO } from '@/api/review'

// Props
interface Props {
  modelValue: boolean
  appointmentId: number
  appointmentInfo?: {
    orderNo: string
    shopName: string
    serviceName: string
  }
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: false,
  appointmentId: 0
})

// Emits
const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  'success': []
}>()

// 显示状态
const visible = ref(props.modelValue)

// 表单引用
const formRef = ref<FormInstance>()

// 评分颜色
const rateColors = ['#F56C6C', '#E6A23C', '#409EFF']

// 表单数据
const formData = reactive<ReviewCreateDTO>({
  appointmentId: props.appointmentId,
  score: 5,
  serviceScore: 5,
  qualityScore: 5,
  attitudeScore: 5,
  content: '',
  imgUrls: '',
  isAnonymous: 0
})

// 提交状态
const submitting = ref(false)

// 表单验证规则
const rules: FormRules = {
  score: [
    { required: true, message: '请选择综合评分', trigger: 'change' },
    { type: 'number', min: 1, max: 5, message: '评分必须在1-5之间', trigger: 'change' }
  ],
  content: [
    { max: 500, message: '评价内容不能超过500个字符', trigger: 'blur' }
  ]
}

// 监听 modelValue 变化
watch(() => props.modelValue, (newVal) => {
  visible.value = newVal
  if (newVal) {
    // 重置表单数据
    formData.appointmentId = props.appointmentId
    formData.score = 5
    formData.serviceScore = 5
    formData.qualityScore = 5
    formData.attitudeScore = 5
    formData.content = ''
    formData.isAnonymous = 0
  }
})

// 监听 visible 变化
watch(visible, (newVal) => {
  emit('update:modelValue', newVal)
})

// 关闭对话框
const handleClose = () => {
  visible.value = false
  formRef.value?.resetFields()
}

// 提交评价
const handleSubmit = async () => {
  if (!formRef.value) return

  try {
    // 验证表单
    await formRef.value.validate()

    // 开始提交
    submitting.value = true

    console.log('📝 提交评价数据：', {
      ...formData,
      appointmentId: props.appointmentId
    })

    // 调用 API
    const response = await createReview({
      ...formData,
      appointmentId: props.appointmentId
    })

    console.log('✅ 评价响应：', response)

    if (response.code === 200) {
      ElMessage.success('评价成功！感谢您的反馈')
      emit('success')
      handleClose()
    } else {
      ElMessage.error(response.msg || '评价失败，请稍后重试')
    }
  } catch (error: any) {
    console.error('❌ 评价失败：', error)
    if (error?.message) {
      ElMessage.error(error.message)
    } else {
      ElMessage.error('评价失败，请检查网络连接')
    }
  } finally {
    submitting.value = false
  }
}
</script>

<style scoped>
.rate-tips {
  margin-left: 10px;
  font-size: 12px;
  color: #909399;
}

:deep(.el-rate__text) {
  font-size: 14px;
  color: #606266;
}

:deep(.el-form-item__label) {
  font-weight: 500;
}
</style>


