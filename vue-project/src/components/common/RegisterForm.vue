<template>
  <el-card class="register-form-container" shadow="hover">
    <!-- 注册头部 -->
    <div class="register-header">
      <h2 class="register-title">{{ title }}</h2>
      <p class="register-subtitle">创建您的账号</p>
      <!-- 错误提示 -->
      <el-alert
        v-if="registerError"
        :title="registerError"
        type="error"
        show-icon
        :closable="false"
        class="register-error-alert"
        :description="registerErrorMessage"
      />
    </div>
    
    <!-- 注册表单 -->
    <el-form 
      v-model="registerForm" 
      :rules="rules" 
      ref="registerFormRef" 
      label-width="100px"
      class="register-form"
    >
      <!-- 账号输入 -->
      <el-form-item label="账号" prop="username">
        <el-input
          v-model="registerForm.username"
          placeholder="请输入账号，3-20位字符"
          prefix-icon="el-icon-user"
          clearable
          :maxlength="20"
          @keyup.enter="handleRegister"
        >
          <template #suffix>
            <el-icon v-if="usernameChecked && !usernameError" class="check-icon"><Check /></el-icon>
            <el-icon v-else-if="usernameError" class="error-icon"><Close /></el-icon>
          </template>
        </el-input>
        <div v-if="usernameError" class="input-tip error-tip">{{ usernameError }}</div>
        <div v-else-if="usernameChecked && !usernameError" class="input-tip success-tip">账号可用</div>
      </el-form-item>
      
      <!-- 验证码 -->
      <el-form-item label="验证码" prop="code">
        <el-row :gutter="12">
          <el-col :span="16">
            <el-input
              v-model="registerForm.code"
              placeholder="请输入验证码"
              prefix-icon="el-icon-document"
              clearable
              :maxlength="6"
              @keyup.enter="handleRegister"
            >
            </el-input>
          </el-col>
          <el-col :span="8">
            <div 
              class="random-code el-button el-button--primary"
              @click="generateRandomCode"
              style="width: 100%; height: 40px; display: flex; align-items: center; justify-content: center;"
            >
              {{ randomCode }}
            </div>
          </el-col>
        </el-row>
        <div class="code-tip">点击验证码可更换</div>
      </el-form-item>
      
      <!-- 密码输入 -->
      <el-form-item label="密码" prop="password">
        <el-input
          v-model="registerForm.password"
          type="password"
          placeholder="请输入密码，6-20位字符"
          prefix-icon="el-icon-lock"
          :show-password="true"
          :maxlength="20"
          @input="checkPasswordStrength"
          @keyup.enter="handleRegister"
        >
        </el-input>
        
        <!-- 密码强度指示器 -->
        <div v-if="registerForm.password.length > 0" class="password-strength">
          <div class="strength-bars">
            <div 
              v-for="i in 3" 
              :key="i"
              class="strength-bar"
              :class="{
                'weak': i <= 1 && passwordStrength === 'weak',
                'medium': i <= 2 && passwordStrength === 'medium',
                'strong': i <= 3 && passwordStrength === 'strong'
              }"
            ></div>
          </div>
          <div class="strength-text" :class="passwordStrength">
            {{ strengthText }}
          </div>
          <!-- 密码建议 -->
          <div class="password-suggestions">
            <el-tag 
              v-for="(suggestion, index) in passwordSuggestions" 
              :key="index"
              :type="suggestion.met ? 'success' : 'info'"
              size="small"
              effect="plain"
              class="suggestion-tag"
            >
              <el-icon v-if="suggestion.met" class="suggestion-icon met"><Check /></el-icon>
              <el-icon v-else class="suggestion-icon not-met"><Close /></el-icon>
              {{ suggestion.text }}
            </el-tag>
          </div>
        </div>
      </el-form-item>
      
      <!-- 确认密码 -->
      <el-form-item label="确认密码" prop="confirmPassword">
        <el-input
          v-model="registerForm.confirmPassword"
          type="password"
          placeholder="请再次输入密码"
          prefix-icon="el-icon-lock"
          :show-password="true"
          @keyup.enter="handleRegister"
        >
          <template #suffix>
            <el-icon v-if="registerForm.confirmPassword && registerForm.password === registerForm.confirmPassword" class="check-icon"><Check /></el-icon>
          </template>
        </el-input>
      </el-form-item>
      
      <!-- 用户注册字段 -->
      <template v-if="role === 'user'">
        <el-form-item label="姓名" prop="name">
          <el-input
            v-model="registerForm.name"
            placeholder="请输入姓名"
            prefix-icon="el-icon-user"
            clearable
            :maxlength="20"
            @keyup.enter="handleRegister"
          >
          </el-input>
        </el-form-item>
        
        <el-form-item label="手机号" prop="phone" optional>
          <el-input
            v-model="registerForm.phone"
            placeholder="请输入手机号（选填）"
            prefix-icon="el-icon-phone"
            clearable
            :maxlength="11"
            @keyup.enter="handleRegister"
          >
          </el-input>
        </el-form-item>
      </template>
      
      <!-- 商家注册字段 -->
      <template v-if="role === 'shop'">
        <el-form-item label="店铺名称" prop="name">
          <el-input
            v-model="registerForm.name"
            placeholder="请输入店铺名称"
            prefix-icon="el-icon-shopping-bag"
            clearable
            :maxlength="50"
            @keyup.enter="handleRegister"
          >
          </el-input>
        </el-form-item>
        
        <el-form-item label="店铺地址" prop="address">
          <el-input
            v-model="registerForm.address"
            placeholder="请输入店铺地址"
            prefix-icon="el-icon-location"
            clearable
            :maxlength="100"
            @keyup.enter="handleRegister"
          >
          </el-input>
        </el-form-item>
        
        <el-form-item label="联系人" prop="contactPerson">
          <el-input
            v-model="registerForm.contactPerson"
            placeholder="请输入联系人姓名"
            prefix-icon="el-icon-user"
            clearable
            :maxlength="20"
            @keyup.enter="handleRegister"
          >
          </el-input>
        </el-form-item>
        
        <el-form-item label="联系电话" prop="phone">
          <el-input
            v-model="registerForm.phone"
            placeholder="请输入联系电话"
            prefix-icon="el-icon-phone"
            clearable
            :maxlength="11"
            @keyup.enter="handleRegister"
          >
          </el-input>
        </el-form-item>
        
        <el-form-item label="店铺描述" prop="description" optional>
          <el-input
            v-model="registerForm.description"
            type="textarea"
            placeholder="请简要描述您的店铺（选填）"
            :rows="3"
            clearable
            :maxlength="200"
            show-word-limit
          >
          </el-input>
        </el-form-item>
      </template>
      
      <!-- 用户协议复选框 -->
      <el-form-item prop="agreement">
        <el-checkbox v-model="registerForm.agreement" class="agreement-checkbox">
          我已阅读并同意
          <a href="#" class="terms-link" @click.prevent="showTerms('user')">用户协议</a>
          和
          <a href="#" class="terms-link" @click.prevent="showTerms('privacy')">隐私政策</a>
        </el-checkbox>
      </el-form-item>
      
      <!-- 注册按钮 -->
      <el-form-item>
        <el-button 
          type="primary" 
          class="register-button" 
          :loading="loading"
          @click="handleRegister"
          :disabled="loading"
          style="width: 100%"
          size="large"
        >
          <el-icon v-if="loading" class="el-icon--right"><Loading /></el-icon>
          {{ loading ? '注册中...' : '立即注册' }}
        </el-button>
      </el-form-item>
      
      <!-- 登录链接 -->
      <el-form-item>
        <div class="login-link">
          已有账号？
          <router-link to="/login" class="link-text">
            立即登录
          </router-link>
        </div>
      </el-form-item>
    </el-form>
    
    <!-- 用户协议对话框 -->
    <el-dialog
      v-model="showTermsDialog"
      :title="termsDialogTitle"
      width="600px"
      :close-on-click-modal="false"
    >
      <div class="terms-content">
        <p>感谢您注册使用我们的平台服务。请仔细阅读以下协议内容：</p>
        <h3>服务条款</h3>
        <p>1. 您必须年满18周岁才能使用我们的服务。</p>
        <p>2. 您需提供真实、准确的个人信息，并及时更新。</p>
        <p>3. 您负责保护您的账号安全，不得将账号借给他人使用。</p>
        <p>4. 禁止任何违法或侵害他人权益的行为。</p>
        <h3>隐私政策</h3>
        <p>1. 我们重视您的隐私保护，不会泄露您的个人信息。</p>
        <p>2. 我们收集的信息仅用于提供服务和改进用户体验。</p>
        <p>3. 您可以随时访问和修改您的个人信息。</p>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="showTermsDialog = false">关闭</el-button>
        </div>
      </template>
    </el-dialog>
  </el-card>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, onUnmounted, watch } from 'vue'
import { ElMessage, FormInstance, FormRules } from 'element-plus'
import { useRouter } from 'vue-router'
import { Check, Close, Loading } from '@element-plus/icons-vue'
import { userApi } from '@/api/index'

// 定义组件属性
interface Props {
  role: 'user' | 'shop'
}

const props = defineProps<Props>()

// 定义组件事件
const emit = defineEmits<{
  registerSuccess: []
}>()

const router = useRouter()

// 表单引用
const registerFormRef = ref<FormInstance>()
const loading = ref(false)

// 注册错误信息
const registerError = ref<string>('')
const registerErrorMessage = ref<string>('')

// 用户名验证状态
const usernameChecked = ref(false)
const usernameError = ref<string>('')

// 用户协议对话框
const showTermsDialog = ref(false)
const termsDialogTitle = ref('')

// 表单数据
const registerForm = reactive({
  username: '',
  code: '',
  password: '',
  confirmPassword: '',
  name: '',
  address: '',
  contactPerson: '',
  phone: '',
  description: '',
  agreement: false
})

// 验证码相关
const randomCode = ref('')

// 密码强度相关
const passwordStrength = ref('')
const strengthText = ref('')
const passwordSuggestions = ref<Array<{ text: string; met: boolean }>>([])

// 计算属性：标题
const title = computed(() => {
  return props.role === 'user' ? '用户注册' : '商家入驻'
})

// 生成随机验证码
const generateRandomCode = () => {
  // 生成6位随机验证码，包含数字和字母
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
  let code = ''
  for (let i = 0; i < 6; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length))
  }
  randomCode.value = code
}

// 检查用户名是否可用
const checkUsername = async () => {
  if (!registerForm.username || registerForm.username.length < 3) {
    usernameChecked.value = false
    usernameError.value = '账号长度至少3位'
    return
  }
  
  // 模拟用户名检查
  await new Promise(resolve => setTimeout(resolve, 500))
  
  // 简单模拟，实际应该调用API检查
  const reservedUsernames = ['admin', 'root', 'system', 'testadmin']
  if (reservedUsernames.includes(registerForm.username.toLowerCase())) {
    usernameChecked.value = true
    usernameError.value = '该账号已被占用'
  } else {
    usernameChecked.value = true
    usernameError.value = ''
  }
}

// 检查密码强度
const checkPasswordStrength = (event: Event) => {
  const input = event.target as HTMLInputElement
  const password = input.value
  
  if (!password) {
    passwordStrength.value = ''
    strengthText.value = ''
    passwordSuggestions.value = []
    return
  }
  
  // 检查密码各方面强度
  const hasNumber = /\d/.test(password)
  const hasLowercase = /[a-z]/.test(password)
  const hasUppercase = /[A-Z]/.test(password)
  const hasSpecial = /[^a-zA-Z0-9]/.test(password)
  const isLongEnough = password.length >= 8
  const isVeryLong = password.length >= 12
  
  // 设置密码建议
  passwordSuggestions.value = [
    { text: '至少8个字符', met: isLongEnough },
    { text: '包含数字', met: hasNumber },
    { text: '包含小写字母', met: hasLowercase },
    { text: '包含大写字母', met: hasUppercase },
    { text: '包含特殊字符', met: hasSpecial }
  ]
  
  // 计算强度得分
  let strength = 0
  if (isLongEnough) strength++
  if (hasNumber) strength++
  if (hasLowercase) strength++
  if (hasUppercase) strength++
  if (hasSpecial) strength++
  if (isVeryLong) strength++
  
  // 设置强度等级和文本
  if (strength <= 2) {
    passwordStrength.value = 'weak'
    strengthText.value = '弱密码'
  } else if (strength <= 4) {
    passwordStrength.value = 'medium'
    strengthText.value = '中等强度'
  } else {
    passwordStrength.value = 'strong'
    strengthText.value = '强密码'
  }
}

// 显示用户协议或隐私政策
const showTerms = (type: 'user' | 'privacy') => {
  termsDialogTitle.value = type === 'user' ? '用户协议' : '隐私政策'
  showTermsDialog.value = true
}

// 重置注册错误
const resetRegisterError = () => {
  registerError.value = ''
  registerErrorMessage.value = ''
}

// 表单验证规则
const rules = reactive<FormRules>({
  username: [
    { required: true, message: '请输入账号', trigger: 'blur' },
    { min: 3, max: 20, message: '账号长度应为3-20位', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (usernameChecked.value && usernameError.value) {
          callback(new Error(usernameError.value))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ],
  code: [
    { required: true, message: '请输入验证码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (!value || value.toLowerCase() !== randomCode.value.toLowerCase()) {
          callback(new Error('验证码错误'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度应为6-20位', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        // 至少需要满足3个密码强度条件
        const conditions = [
          /\d/.test(value),
          /[a-z]/.test(value),
          /[A-Z]/.test(value),
          /[^a-zA-Z0-9]/.test(value),
          value.length >= 8
        ]
        const metCount = conditions.filter(Boolean).length
        
        if (metCount < 2) {
          callback(new Error('密码强度不足，请满足至少2个密码强度条件'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (!value || value !== registerForm.password) {
          callback(new Error('两次输入的密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ],
  name: [
    { required: true, message: props.role === 'user' ? '请输入姓名' : '请输入店铺名称', trigger: 'blur' },
    { min: 2, message: props.role === 'user' ? '姓名长度至少2位' : '店铺名称长度至少2位', trigger: 'blur' }
  ],
  phone: [
    {
      pattern: /^1[3-9]\d{9}$/,
      message: '请输入正确的手机号格式',
      trigger: 'blur',
      required: false
    }
  ],
  address: props.role === 'shop' ? [
    { required: true, message: '请输入店铺地址', trigger: 'blur' },
    { min: 5, message: '地址长度至少5位', trigger: 'blur' }
  ] : [],
  contactPerson: props.role === 'shop' ? [
    { required: true, message: '请输入联系人姓名', trigger: 'blur' },
    { min: 2, message: '联系人姓名长度至少2位', trigger: 'blur' }
  ] : [],
  agreement: [
    { 
      validator: (rule, value, callback) => {
        if (!value) {
          callback(new Error('请阅读并同意用户协议和隐私政策'))
        } else {
          callback()
        }
      },
      trigger: 'change'
    }
  ]
})

// 注册处理函数
const handleRegister = async () => {
  try {
    // 重置错误信息
    resetRegisterError()
    
    // 使用Element Plus表单验证
    await registerFormRef.value?.validate()
    
    loading.value = true
    
    // 准备注册数据，按照后端RegisterRequestDTO的格式
    const registerData: any = {
      username: registerForm.username,
      password: registerForm.password,
      confirmPassword: registerForm.confirmPassword,
      phone: registerForm.phone || '13800138000', // 后端要求必填
      userType: props.role === 'shop' ? 2 : 1, // 1-普通用户，2-商家
      code: registerForm.code
    }
    
    // 调用后端注册API
    const response = await userApi.register(registerData)
    
    // 注册成功
    if (response.code === 200) {
      ElMessage.success({
        message: props.role === 'shop' ? '商家注册成功，请等待审核' : '注册成功，请登录',
        duration: 2000
      })
      
      // 注册成功后跳转到登录页
      setTimeout(() => {
        router.push({
          path: '/login',
          query: { username: registerForm.username }
        })
      }, 1500)
    }
  } catch (error: any) {
    console.error('注册失败:', error)
    // 验证失败时显示错误信息
    if (error !== false) { // 排除表单验证取消的情况
      registerError.value = '注册失败'
      registerErrorMessage.value = error.response?.data?.message || error.message || '请检查输入信息'
    }
  } finally {
    loading.value = false
  }
}

// 重置表单
const resetForm = () => {
  registerFormRef.value?.resetFields()
  // 重新生成验证码
  generateRandomCode()
  // 清除状态
  passwordStrength.value = ''
  strengthText.value = ''
  passwordSuggestions.value = []
  usernameChecked.value = false
  usernameError.value = ''
  resetRegisterError()
}

// 监听用户名变化，延迟检查
let usernameCheckTimer: number | null = null
watch(() => registerForm.username, (newValue) => {
  if (usernameCheckTimer) {
    clearTimeout(usernameCheckTimer)
  }
  
  if (newValue.length >= 3) {
    usernameCheckTimer = window.setTimeout(() => {
      checkUsername()
    }, 800)
  } else {
    usernameChecked.value = false
    usernameError.value = ''
  }
})

// 组件挂载时生成验证码
onMounted(() => {
  generateRandomCode()
})

// 清理定时器
  const cleanup = () => {
    if (usernameCheckTimer) {
      clearTimeout(usernameCheckTimer)
    }
  }

  // 组件卸载时清理
  onUnmounted(cleanup)

  // 暴露方法给父组件
defineExpose({
  resetForm,
  generateRandomCode
})
</script>

<style scoped>
/* 注册表单容器样式 */
.register-form-container {
  max-width: 500px;
  margin: 0 auto;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.register-form-container:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
}

/* 注册表单头部样式 */
.register-header {
  text-align: center;
  padding: 25px 0 15px;
  margin-bottom: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  border-radius: 12px 12px 0 0;
}

.register-title {
  font-size: 28px;
  font-weight: 700;
  color: #1f2937;
  margin-bottom: 8px;
  letter-spacing: -0.5px;
}

.register-subtitle {
  font-size: 16px;
  color: #6b7280;
  margin-bottom: 10px;
}

/* 错误提示样式 */
.register-error-alert {
  margin: 15px 20px 0;
  animation: shake 0.5s ease-in-out;
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
  20%, 40%, 60%, 80% { transform: translateX(5px); }
}

/* 注册表单样式 */
.register-form {
  padding: 0 25px 25px;
}

/* 输入提示样式 */
.input-tip {
  font-size: 12px;
  margin-top: 4px;
  transition: all 0.3s ease;
}

.success-tip {
  color: #67c23a;
}

.error-tip {
  color: #f56c6c;
}

/* 输入框图标样式 */
:deep(.el-input__suffix-inner .check-icon),
:deep(.el-input__suffix-inner .error-icon) {
  font-size: 18px;
  transition: all 0.3s ease;
}

.check-icon {
  color: #67c23a;
}

.error-icon {
  color: #f56c6c;
}

/* 验证码样式 */
.random-code {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  cursor: pointer;
  user-select: none;
  font-weight: bold;
  letter-spacing: 2px;
  font-style: italic;
  border-radius: 4px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
}

.random-code::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(
    to right, 
    rgba(255,255,255,0) 0%, 
    rgba(255,255,255,0.3) 50%, 
    rgba(255,255,255,0) 100%
  );
  transform: rotate(30deg);
  animation: shine 3s infinite;
}

@keyframes shine {
  0% { transform: translateX(-100%) rotate(30deg); }
  100% { transform: translateX(100%) rotate(30deg); }
}

.random-code:hover {
  background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
  transform: scale(1.02);
}

.code-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

/* 密码强度指示器样式 */
.password-strength {
  margin-top: 12px;
}

.strength-bars {
  display: flex;
  gap: 5px;
  margin-bottom: 8px;
}

.strength-bar {
  flex: 1;
  height: 5px;
  background-color: #e0e0e0;
  border-radius: 3px;
  transition: all 0.3s ease;
}

.strength-bar.weak {
  background-color: #f56c6c;
  animation: pulse 1s infinite;
}

.strength-bar.medium {
  background-color: #e6a23c;
}

.strength-bar.strong {
  background-color: #67c23a;
  animation: glow 1.5s infinite;
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.7; }
}

@keyframes glow {
  0%, 100% { box-shadow: 0 0 0 0 rgba(103, 194, 58, 0.7); }
  50% { box-shadow: 0 0 8px 2px rgba(103, 194, 58, 0.5); }
}

.strength-text {
  font-size: 13px;
  font-weight: 500;
  margin-bottom: 8px;
  transition: color 0.3s ease;
}

.strength-text.weak {
  color: #f56c6c;
}

.strength-text.medium {
  color: #e6a23c;
}

.strength-text.strong {
  color: #67c23a;
}

/* 密码建议样式 */
.password-suggestions {
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
}

.suggestion-tag {
  font-size: 11px !important;
  padding: 0 8px !important;
  height: 22px !important;
  line-height: 22px !important;
  border-radius: 11px !important;
  transition: all 0.3s ease;
}

.suggestion-icon {
  font-size: 10px !important;
  margin-right: 3px;
}

.suggestion-icon.met {
  color: #67c23a;
}

.suggestion-icon.not-met {
  color: #909399;
}

/* 用户协议样式 */
.agreement-checkbox {
  display: flex;
  align-items: center;
  justify-content: center;
  padding-top: 10px;
}

.terms-link {
  color: #409eff;
  text-decoration: none;
  cursor: pointer;
  transition: color 0.3s ease;
  position: relative;
}

.terms-link::after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 0;
  height: 1px;
  background-color: #409eff;
  transition: width 0.3s ease;
}

.terms-link:hover {
  color: #66b1ff;
}

.terms-link:hover::after {
  width: 100%;
}

/* 注册按钮样式 */
.register-button {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  border: none;
  transition: all 0.3s ease;
  height: 45px;
  font-size: 16px;
  font-weight: 600;
}

.register-button:hover:not(:disabled) {
  background: linear-gradient(135deg, #00f2fe 0%, #4facfe 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 15px rgba(79, 172, 254, 0.4);
}

.register-button:active:not(:disabled) {
  transform: translateY(0);
}

.register-button:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

/* 登录链接样式 */
.login-link {
  text-align: center;
  margin-top: 20px;
  font-size: 14px;
  color: #606266;
}

.link-text {
  color: #409eff;
  text-decoration: none;
  font-weight: 500;
  position: relative;
  padding: 0 4px;
  transition: color 0.3s ease;
}

.link-text:hover {
  color: #66b1ff;
}

.link-text::before {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 0;
  width: 100%;
  height: 2px;
  background-color: #66b1ff;
  transform: scaleX(0);
  transition: transform 0.3s ease;
}

.link-text:hover::before {
  transform: scaleX(1);
}

/* 用户协议对话框样式 */
.terms-content {
  max-height: 400px;
  overflow-y: auto;
  line-height: 1.8;
}

.terms-content h3 {
  color: #303133;
  margin: 20px 0 10px;
  font-size: 16px;
}

.terms-content p {
  color: #606266;
  margin-bottom: 10px;
}

/* 表单元素聚焦样式 */
:deep(.el-input__inner:focus) {
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.1);
}

:deep(.el-form-item.is-error .el-input__inner) {
  border-color: #f56c6c;
}

:deep(.el-form-item.is-success .el-input__inner) {
  border-color: #67c23a;
}

/* 响应式样式 */
@media (max-width: 768px) {
  .register-form-container {
    margin: 0 15px;
    max-width: none;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  }
  
  .register-header {
    padding: 20px 15px 10px;
  }
  
  .register-title {
    font-size: 24px;
  }
  
  .register-form {
    padding: 0 15px 20px;
  }
  
  .password-suggestions {
    justify-content: center;
  }
  
  .suggestion-tag {
    font-size: 10px !important;
    padding: 0 6px !important;
  }
  
  .el-form-item__label {
    font-size: 13px;
  }
}
</style>