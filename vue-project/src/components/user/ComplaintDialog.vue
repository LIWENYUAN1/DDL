<template>
  <el-dialog
    v-model="visible"
    title="投诉与建议"
    width="520px"
    destroy-on-close
    @closed="handleClosed"
  >
    <el-alert
      title="我们会尽快处理您的反馈"
      type="info"
      show-icon
      :closable="false"
      class="mb-20"
    />

    <el-form
      ref="formRef"
      :model="form"
      :rules="rules"
      label-width="90px"
    >
      <el-form-item label="投诉类型" prop="type">
        <el-select v-model="form.type" placeholder="选择类型">
          <el-option label="服务质量" value="service" />
          <el-option label="价格争议" value="price" />
          <el-option label="支付问题" value="payment" />
          <el-option label="其他问题" value="other" />
        </el-select>
      </el-form-item>

      <el-form-item label="问题描述" prop="content">
        <el-input
          v-model="form.content"
          type="textarea"
          placeholder="请描述遇到的问题或建议"
          :rows="5"
          maxlength="500"
          show-word-limit
        />
      </el-form-item>

      <el-form-item label="联系方式">
        <el-input
          v-model="form.contact"
          placeholder="可选，方便客服与您联系"
        />
      </el-form-item>
    </el-form>

    <template #footer>
      <el-button @click="close">取消</el-button>
      <el-button type="primary" @click="submit" :loading="submitting">
        提交反馈
      </el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { computed, reactive, ref, watch } from 'vue'
import type { FormInstance, FormRules } from 'element-plus'

const props = withDefaults(defineProps<{
  modelValue: boolean
  appointmentId: number
}>(), {
  appointmentId: 0
})

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void
  (e: 'submit', payload: { appointmentId: number; type: string; content: string; contact?: string }): void
  (e: 'closed'): void
}>()

const visible = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
})

const formRef = ref<FormInstance>()
const submitting = ref(false)

const form = reactive({
  type: '',
  content: '',
  contact: ''
})

const rules = reactive<FormRules>({
  type: [{ required: true, message: '请选择投诉类型', trigger: 'change' }],
  content: [{ required: true, message: '请输入问题描述', trigger: 'blur' }]
})

watch(() => props.modelValue, value => {
  if (value) {
    form.type = ''
    form.content = ''
    form.contact = ''
    submitting.value = false
  }
})

const close = () => {
  visible.value = false
}

const submit = async () => {
  if (!formRef.value) return

  await formRef.value.validate(valid => {
    if (!valid) return
    submitting.value = true
    emit('submit', {
      appointmentId: props.appointmentId,
      type: form.type,
      content: form.content,
      contact: form.contact
    })
  })
}

const handleClosed = () => {
  submitting.value = false
  emit('closed')
}
</script>

<style scoped>
.mb-20 {
  margin-bottom: 20px;
}
</style>
