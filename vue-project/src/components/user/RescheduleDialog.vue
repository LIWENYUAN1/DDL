<template>
  <el-dialog
    v-model="visible"
    title="修改预约时间"
    width="480px"
    destroy-on-close
    @closed="handleClosed"
  >
    <el-form
      ref="formRef"
      :model="form"
      :rules="rules"
      label-width="90px"
    >
      <el-form-item label="预约日期" prop="date">
        <el-date-picker
          v-model="form.date"
          type="date"
          placeholder="选择日期"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          :disabled-date="disabledDate"
          style="width: 100%"
        />
      </el-form-item>

      <el-form-item label="时间段" prop="time">
        <el-select v-model="form.time" placeholder="选择时间段">
          <el-option
            v-for="slot in timeOptions"
            :key="slot.value"
            :label="slot.label"
            :value="slot.value"
          />
        </el-select>
      </el-form-item>

      <el-form-item label="备注">
        <el-input
          v-model="form.remark"
          type="textarea"
          placeholder="补充说明（选填）"
          :rows="3"
        />
      </el-form-item>
    </el-form>

    <template #footer>
      <el-button @click="close">取消</el-button>
      <el-button type="primary" @click="submit" :loading="submitting">
        确认修改
      </el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { computed, reactive, ref, watch } from 'vue'
import type { FormInstance, FormRules } from 'element-plus'

type TimeSlot = {
  label: string
  value: string
}

const props = withDefaults(defineProps<{
  modelValue: boolean
  appointmentDate?: string
  appointmentTime?: string
  timeOptions?: TimeSlot[]
}>(), {
  appointmentDate: '',
  appointmentTime: '',
  timeOptions: () => [
    { label: '09:00 - 10:00', value: '09:00-10:00' },
    { label: '10:00 - 11:00', value: '10:00-11:00' },
    { label: '14:00 - 15:00', value: '14:00-15:00' },
    { label: '15:00 - 16:30', value: '15:00-16:30' }
  ]
})

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void
  (e: 'confirm', payload: { date: string; time: string; remark: string }): void
  (e: 'closed'): void
}>()

const visible = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
})

const formRef = ref<FormInstance>()
const submitting = ref(false)

const form = reactive({
  date: props.appointmentDate,
  time: props.appointmentTime,
  remark: ''
})

const rules = reactive<FormRules>({
  date: [{ required: true, message: '请选择预约日期', trigger: 'change' }],
  time: [{ required: true, message: '请选择时间段', trigger: 'change' }]
})

watch(() => props.modelValue, value => {
  if (value) {
    form.date = props.appointmentDate || ''
    form.time = props.appointmentTime || ''
    form.remark = ''
    submitting.value = false
  }
})

const disabledDate = (date: Date) => {
  const now = new Date()
  now.setHours(0, 0, 0, 0)
  return date.getTime() < now.getTime()
}

const close = () => {
  visible.value = false
}

const submit = async () => {
  if (!formRef.value) return

  await formRef.value.validate((valid) => {
    if (!valid) return
    submitting.value = true
    emit('confirm', {
      date: form.date,
      time: form.time,
      remark: form.remark
    })
  })
}

const handleClosed = () => {
  submitting.value = false
  emit('closed')
}
</script>

<style scoped>
</style>
