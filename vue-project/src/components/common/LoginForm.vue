<template>
  <el-card class="login-form-container" shadow="hover">
    <!-- 登录头部 -->
    <div class="login-header">
      <h2 class="login-title">欢迎登录</h2>
      <p class="login-subtitle">摩托车服务平台</p>
      <!-- 错误提示 -->
      <el-alert
        v-if="loginError"
        :title="loginError"
        type="error"
        show-icon
        :closable="false"
        class="login-error-alert"
        :description="loginErrorMessage"
      />
    </div>
    
    <!-- 角色选择标签页 -->
    <el-tabs v-model="loginForm.role" class="role-tabs">
      <el-tab-pane label="用户登录" name="user">
        <div class="role-description">预约维修、查看服务、管理个人信息</div>
      </el-tab-pane>
      <el-tab-pane label="商家登录" name="shop">
        <div class="role-description">管理服务、查看预约、处理订单</div>
      </el-tab-pane>
      <el-tab-pane label="管理员登录" name="admin">
        <div class="role-description">用户管理、商家管理、数据统计</div>
      </el-tab-pane>
    </el-tabs>
    
    <!-- 登录表单 -->
    <el-form 
      v-model="loginForm" 
      :rules="rules" 
      ref="loginFormRef" 
      label-width="80px"
      class="login-form"
    >
      <!-- 账号输入 -->
      <el-form-item label="账号" prop="username">
        <el-input
          v-model="loginForm.username"
          placeholder="请输入账号"
          prefix-icon="el-icon-user"
          clearable
          :maxlength="20"
          @keyup.enter="handleLogin"
        >
        </el-input>
      </el-form-item>
      
      <!-- 密码输入 -->
      <el-form-item label="密码" prop="password">
        <el-input
          v-model="loginForm.password"
          type="password"
          placeholder="请输入密码"
          prefix-icon="el-icon-lock"
          :show-password="showPassword"
          :maxlength="20"
          @keyup.enter="handleLogin"
        >
        </el-input>
      </el-form-item>
      
      <!-- 验证码（可选） -->
      <el-form-item v-if="showCaptcha" label="验证码" prop="captcha">
        <el-row :gutter="12">
          <el-col :span="16">
            <el-input
              v-model="loginForm.captcha"
              placeholder="请输入验证码"
              prefix-icon="el-icon-document"
              clearable
              :maxlength="6"
              @keyup.enter="handleLogin"
            >
            </el-input>
          </el-col>
          <el-col :span="8">
            <div 
              class="captcha-image el-button el-button--primary"
              @click="refreshCaptcha"
              style="width: 100%; height: 40px; display: flex; align-items: center; justify-content: center;"
            >
              {{ captchaCode }}
            </div>
          </el-col>
        </el-row>
      </el-form-item>
      
      <!-- 记住密码和测试账号 -->
      <el-form-item>
        <div class="form-helper">
          <el-checkbox v-model="loginForm.remember" class="remember-checkbox">
            记住密码
          </el-checkbox>
          
          <!-- 测试账号提示 -->
          <template v-if="loginForm.role === 'admin'">
            <el-popover
              placement="bottom"
              :width="200"
              trigger="click"
              content="账号: testadmin<br>密码: test123"
              :close-on-click-outside="false"
            >
              <template #reference>
                <el-button 
                  type="text" 
                  class="test-account-btn"
                  @click.stop="useTestAccount"
                >
                  使用测试账号
                </el-button>
              </template>
            </el-popover>
          </template>
        </div>
      </el-form-item>
      
      <!-- 登录按钮 -->
      <el-form-item>
        <el-button 
          type="primary" 
          class="login-button" 
          :loading="loading"
          @click="handleLogin"
          :disabled="loading"
          style="width: 100%"
        >
          <el-icon v-if="loading" class="el-icon--right"><Loading /></el-icon>
          {{ loading ? '登录中...' : '登录' }}
        </el-button>
      </el-form-item>
      
      <!-- 其他操作链接 -->
      <el-form-item>
        <div class="form-links">
          <router-link to="/register" class="link-text">
            注册账号
          </router-link>
          <a href="#" class="link-text" @click.prevent="showForgotPassword = true">
            忘记密码
          </a>
        </div>
      </el-form-item>
    </el-form>
    
    <!-- 忘记密码对话框 -->
    <el-dialog
      v-model="showForgotPassword"
      title="找回密码"
      width="400px"
      :close-on-click-modal="false"
    >
      <el-form ref="forgotFormRef" :model="forgotForm" :rules="forgotRules">
        <el-form-item label="账号" prop="username">
          <el-input v-model="forgotForm.username" placeholder="请输入账号"></el-input>
        </el-form-item>
        <el-form-item label="新密码" prop="newPassword">
          <el-input v-model="forgotForm.newPassword" type="password" placeholder="请输入新密码"></el-input>
        </el-form-item>
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input v-model="forgotForm.confirmPassword" type="password" placeholder="请确认新密码"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="showForgotPassword = false">取消</el-button>
          <el-button type="primary" @click="handleResetPassword">重置密码</el-button>
        </div>
      </template>
    </el-dialog>
  </el-card>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { ElForm, FormInstance, ElMessage, FormRules } from 'element-plus'
import { User, Shop, Setting, Lock, UserFilled, Loading } from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import { userApi } from '@/api/index'

// Emits
const emit = defineEmits<{
  'login-success': [formData: { username: string; role: string }]
}>()

const router = useRouter()

// 表单状态
const loading = ref(false)
const showPassword = ref(false)
const loginFormRef = ref<FormInstance>()
const forgotFormRef = ref<FormInstance>()

// 登录错误信息
const loginError = ref<string>('')
const loginErrorMessage = ref<string>('')

// 验证码相关
const showCaptcha = ref(false)
const captchaCode = ref('')

// 忘记密码对话框
const showForgotPassword = ref(false)

// 登录表单数据
const loginForm = reactive({
  username: '',
  password: '',
  role: 'user',
  remember: false,
  captcha: ''
})

// 忘记密码表单
const forgotForm = reactive({
  username: '',
  newPassword: '',
  confirmPassword: ''
})

// 表单验证规则
const rules = reactive<FormRules>({
  username: [
    { required: true, message: '请输入账号', trigger: 'blur' },
    { min: 3, max: 20, message: '账号长度应为3-20位', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度应为6-20位', trigger: 'blur' }
  ],
  role: [
    { required: true, message: '请选择角色', trigger: 'change' }
  ],
  captcha: showCaptcha.value ? [
    { required: true, message: '请输入验证码', trigger: 'blur' },
    { min: 4, max: 6, message: '验证码格式不正确', trigger: 'blur' }
  ] : []
})

// 忘记密码验证规则
const forgotRules = reactive<FormRules>({
  username: [
    { required: true, message: '请输入账号', trigger: 'blur' }
  ],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度应为6-20位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== forgotForm.newPassword) {
          callback(new Error('两次输入的密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
})

// 生成验证码
const generateCaptcha = () => {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789'
  let code = ''
  for (let i = 0; i < 4; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length))
  }
  return code
}

// 刷新验证码
const refreshCaptcha = () => {
  captchaCode.value = generateCaptcha()
}

// 使用测试账号
const useTestAccount = () => {
  loginForm.username = 'testadmin'
  loginForm.password = 'test123'
  loginForm.role = 'admin'
  ElMessage.success('已自动填充测试账号')
}

// 重置登录错误
const resetLoginError = () => {
  loginError.value = ''
  loginErrorMessage.value = ''
}

// 处理登录
const handleLogin = async () => {
  try {
    // 重置错误信息
    resetLoginError()
    
    // 表单验证
    await loginFormRef.value?.validate()
    
    // 如果显示验证码，验证验证码
    if (showCaptcha.value) {
      if (!loginForm.captcha || loginForm.captcha.toLowerCase() !== captchaCode.value.toLowerCase()) {
        loginError.value = '验证失败'
        loginErrorMessage.value = '验证码错误'
        refreshCaptcha()
        return
      }
    }
    
    loading.value = true
    
    // 根据角色类型映射到后端的 userType
    // 1-车主，2-商家管理员，3-平台管理员
    let userType = 1
    if (loginForm.role === 'shop') {
      userType = 2
    } else if (loginForm.role === 'admin') {
      userType = 3
    }
    
    console.log('🚀 发送登录请求:', {
      username: loginForm.username,
      userType: userType
    })
    
    // 调用后端登录API
    const response = await userApi.login({
      username: loginForm.username,
      password: loginForm.password,
      userType: userType
    })
    
    console.log('📦 登录响应:', response)
    
    // 登录成功，处理响应数据
    if (response.data) {
      const { token, username, userType: responseUserType } = response.data
      
      // 确定角色
      let role = 'user'
      if (responseUserType === 2) {
        role = 'shop'
      } else if (responseUserType === 3) {
        role = 'admin'
      }
      
      // 保存token和用户信息（统一使用localStorage以确保路由守卫能正确读取）
      localStorage.setItem('token', token)
      localStorage.setItem('role', role)
      localStorage.setItem('userInfo', JSON.stringify(response.data))
      
      console.log('💾 已保存登录信息:', {
        token: token.substring(0, 20) + '...',
        role: role
      })
      
      ElMessage.success('登录成功')
      
      // 发送登录成功事件
      emit('login-success', {
        username: username || loginForm.username,
        role: role
      })
    }
    
  } catch (error: any) {
    console.error('登录失败:', error)
    
    if (error !== false) { // 排除表单验证取消的情况
      loginError.value = '登录失败'
      loginErrorMessage.value = error.response?.data?.message || error.message || '用户名或密码错误'
      
      // 连续失败后显示验证码
      if (!showCaptcha.value) {
        showCaptcha.value = true
        refreshCaptcha()
      }
    }
  } finally {
    loading.value = false
  }
}

// 处理重置密码
const handleResetPassword = async () => {
  try {
    await forgotFormRef.value?.validate()
    
    // 模拟重置密码
    await new Promise(resolve => setTimeout(resolve, 500))
    
    ElMessage.success('密码重置成功，请使用新密码登录')
    showForgotPassword.value = false
    
    // 自动填充用户名到登录表单
    loginForm.username = forgotForm.username
  } catch (error) {
    console.error('重置密码失败:', error)
  }
}

// 组件挂载时生成验证码（如果需要）
if (showCaptcha.value) {
  refreshCaptcha()
}
</script>

<style scoped>
.login-form-container {
  max-width: 420px;
  width: 100%;
  background-color: rgba(255, 255, 255, 0.95);
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
  animation: fadeInUp 0.5s ease-out;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-header {
  text-align: center;
  padding: 30px 20px 20px;
  position: relative;
}

.login-title {
  font-size: 26px;
  font-weight: 700;
  margin: 0 0 8px 0;
  color: #303133;
  background: linear-gradient(135deg, #409eff, #67c23a);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.login-subtitle {
  font-size: 14px;
  color: #909399;
  margin: 0 0 16px 0;
}

.login-error-alert {
  margin-top: 10px;
  animation: shake 0.5s ease-in-out;
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
  20%, 40%, 60%, 80% { transform: translateX(5px); }
}

.role-tabs {
  padding: 0 20px;
  margin-bottom: 20px;
}

.role-description {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

.login-form {
  padding: 0 20px 20px;
}

.form-helper {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.remember-checkbox {
  font-size: 14px;
  color: #606266;
}

.remember-checkbox .el-checkbox__label {
  font-size: 14px;
}

.test-account-btn {
  color: #409eff;
  font-size: 14px;
  transition: color 0.3s;
}

.test-account-btn:hover {
  color: #66b1ff;
}

.login-button {
  height: 44px;
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 15px;
  transition: all 0.3s;
}

.login-button:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
}

.form-links {
  display: flex;
  justify-content: space-between;
  padding: 0 10px;
}

.link-text {
  color: #409eff;
  font-size: 14px;
  text-decoration: none;
  transition: all 0.3s;
  position: relative;
  padding: 5px 10px;
  border-radius: 4px;
}

.link-text:hover {
  color: #66b1ff;
  background-color: rgba(64, 158, 255, 0.1);
}

.captcha-image {
  background-color: #f5f7fa;
  color: #606266;
  font-size: 16px;
  font-weight: bold;
  letter-spacing: 2px;
  cursor: pointer;
  transition: all 0.3s;
  user-select: none;
}

.captcha-image:hover {
  background-color: #e6e8eb;
  transform: scale(1.02);
}

/* 验证码背景干扰线 */
.captcha-image::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: 
    linear-gradient(45deg, transparent 20%, rgba(64, 158, 255, 0.1) 25%, transparent 25%),
    linear-gradient(-45deg, transparent 20%, rgba(103, 194, 58, 0.1) 25%, transparent 25%),
    linear-gradient(45deg, transparent 75%, rgba(64, 158, 255, 0.1) 80%, transparent 80%),
    linear-gradient(-45deg, transparent 75%, rgba(103, 194, 58, 0.1) 80%, transparent 80%);
  background-size: 20px 20px;
  pointer-events: none;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .login-form-container {
    max-width: 100%;
    margin: 0 16px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  }
  
  .login-header {
    padding: 20px 16px 16px;
  }
  
  .login-title {
    font-size: 22px;
  }
  
  .login-form {
    padding: 0 16px 16px;
  }
  
  .role-tabs {
    padding: 0 16px;
  }
  
  .form-helper {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .form-links {
    flex-direction: column;
    gap: 10px;
    align-items: center;
  }
  
  .link-text {
    display: block;
    text-align: center;
    width: 100%;
  }
}

@media (max-width: 480px) {
  .login-form-container {
    margin: 0 12px;
  }
  
  .login-button {
    height: 40px;
    font-size: 15px;
  }
}
</style>