<template>
  <el-dialog
    v-model="visible"
    title="选择支付方式"
    width="480px"
    destroy-on-close
    @closed="handleClosed"
  >
    <div class="payment-content">
      <div class="payment-summary">
        <h4>预约信息</h4>
        <el-descriptions :column="1" size="small" border>
          <el-descriptions-item label="订单号">{{ orderNo }}</el-descriptions-item>
          <el-descriptions-item label="服务项目">{{ serviceName }}</el-descriptions-item>
          <el-descriptions-item label="应付金额">
            <span class="amount">¥{{ amount.toFixed(2) }}</span>
          </el-descriptions-item>
        </el-descriptions>
      </div>

      <div class="payment-method">
        <h4>支付方式</h4>
        <el-radio-group v-model="paymentMethod" class="method-group">
          <el-radio-button label="alipay">支付宝</el-radio-button>
          <el-radio-button label="wechat">微信支付</el-radio-button>
          <el-radio-button v-if="supportOffline" label="offline">到店支付</el-radio-button>
        </el-radio-group>

        <div v-if="paymentMethod !== 'offline'" class="payment-qrcode">
          <el-card shadow="never">
            <div class="qrcode-placeholder">
              <el-icon class="qrcode-icon"><CreditCard /></el-icon>
              <p>请使用{{ paymentMethod === 'alipay' ? '支付宝' : '微信' }}扫码完成支付</p>
            </div>
          </el-card>
        </div>
        <el-alert
          v-else
          title="选择到店支付后，请在服务开始前向商家完成支付"
          type="info"
          show-icon
        />
      </div>

      <div v-if="showDeposit" class="deposit-tip">
        <el-alert
          title="该服务支持预付定金"
          type="warning"
          show-icon
          :closable="false"
        >
          <template #default>
            可选预付金额：<span class="amount">¥{{ depositAmount?.toFixed(2) }}</span>
          </template>
        </el-alert>
        <el-switch
          v-model="payDeposit"
          inline-prompt
          active-text="预付定金"
          inactive-text="全额支付"
        />
      </div>
    </div>

    <template #footer>
      <el-button @click="close">取消</el-button>
      <el-button type="primary" @click="confirm" :loading="props.processing">
        确认支付
      </el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { CreditCard } from '@element-plus/icons-vue'

const props = withDefaults(defineProps<{
  modelValue: boolean
  orderNo: string
  serviceName: string
  amount: number
  defaultMethod?: 'alipay' | 'wechat' | 'offline'
  supportOffline?: boolean
  showDeposit?: boolean
  depositAmount?: number
  processing?: boolean
}>(), {
  defaultMethod: 'alipay',
  supportOffline: true,
  showDeposit: false,
  depositAmount: 0,
  processing: false
})

const emit = defineEmits<{
  (e: 'update:modelValue', value: boolean): void
  (e: 'confirm', payload: { method: string; amount: number; payType: 'deposit' | 'full' }): void
  (e: 'closed'): void
}>()

const visible = computed({
  get: () => props.modelValue,
  set: value => emit('update:modelValue', value)
})

const paymentMethod = ref(props.defaultMethod)
const payDeposit = ref(false)

watch(() => props.modelValue, value => {
  if (value) {
    paymentMethod.value = props.defaultMethod
    payDeposit.value = false
  }
})

const amount = computed(() => props.amount)

const close = () => {
  visible.value = false
}

const confirm = () => {
  const payType = props.showDeposit && payDeposit.value ? 'deposit' : 'full'
  emit('confirm', {
    method: paymentMethod.value,
    amount: amount.value,
    payType
  })
}

const handleClosed = () => {
  payDeposit.value = false
  emit('closed')
}
</script>

<style scoped>
.payment-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.payment-summary h4,
.payment-method h4 {
  margin: 0 0 12px;
  font-size: 16px;
  color: #303133;
}

.method-group {
  width: 100%;
  display: flex;
  justify-content: space-between;
}

.payment-qrcode {
  margin-top: 16px;
}

.qrcode-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 30px 0;
  color: #606266;
}

.qrcode-icon {
  font-size: 40px;
  color: #409eff;
}

.amount {
  color: #f56c6c;
  font-weight: 600;
}

.deposit-tip {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
</style>
