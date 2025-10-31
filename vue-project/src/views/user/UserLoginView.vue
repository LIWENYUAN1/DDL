<script setup lang="ts">
import { ref, reactive, onMounted, onUnmounted } from 'vue'
import { ElMessage, ElForm, ElFormItem, ElInput, ElButton, ElCheckbox, ElCard, ElTabs, ElTabPane, ElLink } from 'element-plus'
import { Lock, User, View as Eye, Hide as EyeOff, Phone, Message as Mail, HomeFilled } from '@element-plus/icons-vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/store/modules/user'

const router = useRouter()
const userStore = useUserStore()

// 当前激活的标签页
const activeTab = ref('account') // account, phone, email

// 表单数据
const activeRole = ref('user') // user, shop, admin

const accountForm = reactive({
  username: '',
  password: '',
  remember: false
})

const phoneForm = reactive({
  phone: '',
  verificationCode: '',
  countdown: 0
})

const emailForm = reactive({
  email: '',
  verificationCode: '',
  countdown: 0
})

// 表单验证规则
const accountRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少为 6 个字符', trigger: 'blur' }
  ]
}

const phoneRules = {
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ],
  verificationCode: [
    { required: true, message: '请输入验证码', trigger: 'blur' },
    { length: 6, message: '验证码为6位数字', trigger: 'blur' },
    { pattern: /^\d{6}$/, message: '验证码只能是数字', trigger: 'blur' }
  ]
}

const emailRules = {
  email: [
    { required: true, message: '请输入邮箱地址', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ],
  verificationCode: [
    { required: true, message: '请输入验证码', trigger: 'blur' },
    { length: 6, message: '验证码为6位数字', trigger: 'blur' },
    { pattern: /^\d{6}$/, message: '验证码只能是数字', trigger: 'blur' }
  ]
}

// 表单引用
const accountFormRef = ref()
const phoneFormRef = ref()
const emailFormRef = ref()

// 显示/隐藏密码
const showPassword = ref(false)

// 加载状态
const loading = ref(false)

// 生命周期
onMounted(() => {
  // 初始化用户Store
  userStore.initialize()
  
  // 从URL参数中获取角色信息
  const route = useRoute()
  const urlRole = route.query.role || ''
  if (urlRole && ['user', 'shop', 'admin'].includes(urlRole)) {
    activeRole.value = urlRole
  } else {
    // 检查是否有记住的登录信息
    const savedLoginInfo = localStorage.getItem('loginInfo')
    if (savedLoginInfo) {
      try {
        const info = JSON.parse(savedLoginInfo)
        if (info.username) {
          accountForm.username = info.username
          accountForm.remember = true
          // 如果有保存的角色，恢复角色选择
          if (info.role) {
            activeRole.value = info.role
          }
        }
      } catch (e) {
        // 解析失败，清除存储
        localStorage.removeItem('loginInfo')
      }
    }
  }
  
  // 如果已登录，重定向到首页
  if (userStore.isLoggedIn) {
    // 根据用户角色跳转到相应的首页
    if (userStore.user?.role === 'admin') {
      router.push('/admin/dashboard')
    } else if (userStore.user?.role === 'shop') {
      router.push('/shop/home')
    } else {
      router.push('/user/home')
    }
  }
})

// 切换密码可见性
const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value
}

// 发送手机验证码
const sendPhoneCode = async () => {
  if (!phoneFormRef.value) return
  
  try {
    // 验证手机号
    await phoneFormRef.value.validateField('phone')
    
    // 调用发送验证码接口
    await userStore.sendVerificationCode({ 
      phone: phoneForm.phone, 
      type: 'login',
      role: activeRole.value
    })
    ElMessage.success('验证码已发送，请注意查收')
    
    // 开始倒计时
    startCountdown('phone')
  } catch (error) {
    ElMessage.error('发送验证码失败，请稍后重试')
    // 验证失败
  }
}

// 发送邮箱验证码
const sendEmailCode = async () => {
  if (!emailFormRef.value) return
  
  try {
    // 验证邮箱
    await emailFormRef.value.validateField('email')
    
    // 调用发送验证码接口
    await userStore.sendVerificationCode({ 
      email: emailForm.email, 
      type: 'login',
      role: activeRole.value
    })
    ElMessage.success('验证码已发送到邮箱，请注意查收')
    
    // 开始倒计时
    startCountdown('email')
  } catch (error) {
    ElMessage.error('发送验证码失败，请稍后重试')
    // 验证失败
  }
}

// 开始倒计时
const startCountdown = (type: 'phone' | 'email') => {
  if (type === 'phone') {
    phoneForm.countdown = 60
    const timer = setInterval(() => {
      phoneForm.countdown--
      if (phoneForm.countdown <= 0) {
        clearInterval(timer)
      }
    }, 1000)
  } else {
    emailForm.countdown = 60
    const timer = setInterval(() => {
      emailForm.countdown--
      if (emailForm.countdown <= 0) {
        clearInterval(timer)
      }
    }, 1000)
  }
}

// 处理账号登录
const handleAccountLogin = async () => {
  if (!accountFormRef.value) return
  
  try {
    await accountFormRef.value.validate()
    await performLogin('account')
  } catch (error) {
    // 表单验证失败
  }
}

// 处理手机登录
const handlePhoneLogin = async () => {
  if (!phoneFormRef.value) return
  
  try {
    await phoneFormRef.value.validate()
    await performLogin('phone')
  } catch (error) {
    // 表单验证失败
  }
}

// 处理邮箱登录
const handleEmailLogin = async () => {
  if (!emailFormRef.value) return
  
  try {
    await emailFormRef.value.validate()
    await performLogin('email')
  } catch (error) {
    // 表单验证失败
  }
}

// 执行登录
const performLogin = async (type: 'account' | 'phone' | 'email') => {
  loading.value = true
  
  try {
    let result
    
    // 根据角色调用不同的登录方法
    if (activeRole.value === 'user') {
      if (type === 'account') {
        result = await userStore.login({
          username: accountForm.username,
          password: accountForm.password,
          remember: accountForm.remember
        })
      } else if (type === 'phone') {
        result = await userStore.login({
          phone: phoneForm.phone,
          verificationCode: phoneForm.verificationCode,
          remember: accountForm.remember
        })
      } else if (type === 'email') {
        result = await userStore.login({
          email: emailForm.email,
          verificationCode: emailForm.verificationCode,
          remember: accountForm.remember
        })
      }
    } else if (activeRole.value === 'shop') {
      if (type === 'account') {
        result = await userStore.shopLogin({
          username: accountForm.username,
          password: accountForm.password,
          remember: accountForm.remember
        })
      } else if (type === 'phone') {
        result = await userStore.shopLogin({
          phone: phoneForm.phone,
          verificationCode: phoneForm.verificationCode,
          remember: accountForm.remember
        })
      } else if (type === 'email') {
        result = await userStore.shopLogin({
          email: emailForm.email,
          verificationCode: emailForm.verificationCode,
          remember: accountForm.remember
        })
      }
    } else if (activeRole.value === 'admin') {
      if (type === 'account') {
        result = await userStore.adminLogin({
          username: accountForm.username,
          password: accountForm.password,
          remember: accountForm.remember
        })
      } else if (type === 'phone') {
        result = await userStore.adminLogin({
          phone: phoneForm.phone,
          verificationCode: phoneForm.verificationCode,
          remember: accountForm.remember
        })
      } else if (type === 'email') {
        result = await userStore.adminLogin({
          email: emailForm.email,
          verificationCode: emailForm.verificationCode,
          remember: accountForm.remember
        })
      }
    }
    
    // 保存记住密码和角色信息
    if (accountForm.remember && activeRole.value !== 'admin') {
      const loginInfo = {
        username: accountForm.username,
        role: activeRole.value
      }
      localStorage.setItem('loginInfo', JSON.stringify(loginInfo))
    } else {
      localStorage.removeItem('loginInfo')
    }
    
    ElMessage.success('登录成功')
    
    // 根据角色跳转到相应页面
    switch (activeRole.value) {
      case 'user':
        router.push('/user/home')
        break
      case 'shop':
        router.push('/shop/home')
        break
      case 'admin':
        router.push('/admin/dashboard')
        break
    }
  } catch (error) {
    ElMessage.error('登录失败，请检查账号密码或验证码')
    console.error('登录错误:', error)
  } finally {
    loading.value = false
  }
}

// 处理角色切换
const handleRoleChange = (tab) => {
  // 切换角色时重置表单
  activeTab.value = 'account'
  activeRole.value = tab.props.name
  
  // 清空表单数据
  accountForm.username = ''
  accountForm.password = ''
  phoneForm.phone = ''
  phoneForm.verificationCode = ''
  emailForm.email = ''
  emailForm.verificationCode = ''
  
  // 清空计时器
  if (phoneForm.countdown > 0) {
    const timer = setInterval(() => {
      phoneForm.countdown = 0
      clearInterval(timer)
    }, 1)
  }
  if (emailForm.countdown > 0) {
    const timer = setInterval(() => {
      emailForm.countdown = 0
      clearInterval(timer)
    }, 1)
  }
}

// 处理注册跳转
const handleRegister = () => {
  router.push('/register')
}

// 处理商家注册跳转
const handleShopRegister = () => {
  router.push('/shop/register')
}

// 跳转到商家登录
const goToShopLogin = () => {
  router.push('/shop/login')
}

// 跳转到管理员登录
const goToAdminLogin = () => {
  router.push('/admin/login')
}

// 处理键盘事件
const handleKeyDown = (e: KeyboardEvent) => {
  if (e.key === 'Enter') {
    if (activeTab.value === 'account') {
      handleAccountLogin()
    } else if (activeTab.value === 'phone') {
      handlePhoneLogin()
    } else if (activeTab.value === 'email') {
      handleEmailLogin()
    }
  }
}

// 组件挂载时添加键盘事件监听
onMounted(() => {
  document.addEventListener('keydown', handleKeyDown)
})

// 组件卸载时移除键盘事件监听
onUnmounted(() => {
  document.removeEventListener('keydown', handleKeyDown)
})
</script>

<template>
  <div class="user-login-container">
    <div class="login-bg"></div>
    <div class="login-content">
      <div class="login-card">
        <div class="login-header">
          <div class="login-logo">
            <HomeFilled class="logo-icon" />
            <span class="logo-text">摩托车服务平台</span>
          </div>
          <h2 class="login-title">摩托车服务平台</h2>
          <p class="login-subtitle">欢迎回来，请登录</p>
        </div>
        
        <!-- 角色切换标签页 -->
        <div class="role-tabs">
          <el-tabs v-model="activeRole" class="role-tabs" @tab-click="handleRoleChange">
            <el-tab-pane label="用户登录" name="user" />
            <el-tab-pane label="商家登录" name="shop" />
            <el-tab-pane label="管理员登录" name="admin" />
          </el-tabs>
        </div>
        
        <el-card class="form-card">
          <el-tabs v-model="activeTab" class="login-tabs">
            <el-tab-pane label="账号密码" name="account">
              <el-form
                ref="accountFormRef"
                :model="accountForm"
                :rules="accountRules"
                status-icon
                class="login-form"
              >
                <el-form-item prop="username">
                  <el-input
                    v-model="accountForm.username"
                    placeholder="请输入用户名"
                    prefix-icon="User"
                    clearable
                    auto-complete="username"
                  >
                    <template #prefix>
                      <User />
                    </template>
                  </el-input>
                </el-form-item>
                
                <el-form-item prop="password">
                  <el-input
                    v-model="accountForm.password"
                    :type="showPassword ? 'text' : 'password'"
                    placeholder="请输入密码"
                    prefix-icon="Lock"
                    show-password-toggle
                    auto-complete="current-password"
                  >
                    <template #prefix>
                      <Lock />
                    </template>
                    <template #suffix>
                      <span @click="togglePasswordVisibility" class="password-toggle">
                        <Eye v-if="showPassword" />
                        <EyeOff v-else />
                      </span>
                    </template>
                  </el-input>
                </el-form-item>
                
                <el-form-item>
                  <div class="form-options">
                    <el-checkbox v-model="accountForm.remember">记住密码</el-checkbox>
                    <div class="login-hint">
                      测试账号: testuser / test123
                    </div>
                  </div>
                </el-form-item>
                
                <el-form-item>
                  <el-button
                    type="primary"
                    :loading="userStore.isLoading"
                    @click="handleAccountLogin"
                    class="login-button"
                    :disabled="userStore.isLoading"
                  >
                    登录
                  </el-button>
                </el-form-item>
              </el-form>
            </el-tab-pane>
            
            <el-tab-pane label="手机号" name="phone">
              <el-form
                ref="phoneFormRef"
                :model="phoneForm"
                :rules="phoneRules"
                status-icon
                class="login-form"
              >
                <el-form-item prop="phone">
                  <el-input
                    v-model="phoneForm.phone"
                    placeholder="请输入手机号"
                    prefix-icon="Phone"
                    clearable
                    auto-complete="tel"
                  >
                    <template #prefix>
                      <Phone />
                    </template>
                  </el-input>
                </el-form-item>
                
                <el-form-item prop="verificationCode">
                  <el-input
                    v-model="phoneForm.verificationCode"
                    placeholder="请输入验证码"
                    clearable
                  >
                    <template #append>
                      <el-button
                        type="text"
                        :disabled="phoneForm.countdown > 0"
                        @click="sendPhoneCode"
                        class="code-button"
                      >
                        {{ phoneForm.countdown > 0 ? `${phoneForm.countdown}秒后重新发送` : '获取验证码' }}
                      </el-button>
                    </template>
                  </el-input>
                </el-form-item>
                
                <el-form-item>
                  <div class="form-hint">
                    测试手机号: 13800138000<br/>
                    测试验证码: 123456
                  </div>
                </el-form-item>
                
                <el-form-item>
                  <el-button
                    type="primary"
                    :loading="userStore.isLoading"
                    @click="handlePhoneLogin"
                    class="login-button"
                    :disabled="userStore.isLoading"
                  >
                    登录
                  </el-button>
                </el-form-item>
              </el-form>
            </el-tab-pane>
            
            <el-tab-pane label="邮箱" name="email">
              <el-form
                ref="emailFormRef"
                :model="emailForm"
                :rules="emailRules"
                status-icon
                class="login-form"
              >
                <el-form-item prop="email">
                  <el-input
                    v-model="emailForm.email"
                    placeholder="请输入邮箱地址"
                    prefix-icon="Mail"
                    clearable
                    auto-complete="email"
                  >
                    <template #prefix>
                      <Mail />
                    </template>
                  </el-input>
                </el-form-item>
                
                <el-form-item prop="verificationCode">
                  <el-input
                    v-model="emailForm.verificationCode"
                    placeholder="请输入验证码"
                    clearable
                  >
                    <template #append>
                      <el-button
                        type="text"
                        :disabled="emailForm.countdown > 0"
                        @click="sendEmailCode"
                        class="code-button"
                      >
                        {{ emailForm.countdown > 0 ? `${emailForm.countdown}秒后重新发送` : '获取验证码' }}
                      </el-button>
                    </template>
                  </el-input>
                </el-form-item>
                
                <el-form-item>
                  <div class="form-hint">
                    测试邮箱: test@example.com<br/>
                    测试验证码: 123456
                  </div>
                </el-form-item>
                
                <el-form-item>
                  <el-button
                    type="primary"
                    :loading="userStore.isLoading"
                    @click="handleEmailLogin"
                    class="login-button"
                    :disabled="userStore.isLoading"
                  >
                    登录
                  </el-button>
                </el-form-item>
              </el-form>
            </el-tab-pane>
          </el-tabs>
        </el-card>
        
        <div class="login-footer">
          <template v-if="activeRole === 'user'">
            <div class="login-switch">
              <span>没有账号？</span>
              <el-link type="primary" @click="handleRegister">立即注册</el-link>
            </div>
          </template>
          <template v-else-if="activeRole === 'shop'">
            <div class="login-switch">
              <span>没有商家账号？</span>
              <el-link type="primary" @click="handleShopRegister">立即注册</el-link>
            </div>
          </template>
          <div class="system-info">
            © 2024 摩托车服务平台 v1.0
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.user-login-container {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: #f5f7fa;
  overflow: hidden;
}

.login-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  z-index: 0;
}

.login-content {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 480px;
  padding: 0 20px;
}

.login-card {
    background: rgba(255, 255, 255, 0.95);
    border-radius: 12px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.2);
    overflow: hidden;
    animation: slideUp 0.6s ease-out;
  }
  
  .role-tabs {
    margin: 0 30px 20px;
  }
  
  .role-tabs >>> .el-tabs__header {
    margin-bottom: 16px;
  }
  
  .role-tabs >>> .el-tabs__nav-wrap::after {
    background-color: #ebeef5;
  }
  
  .role-tabs >>> .el-tabs__active-bar {
    background-color: #667eea;
  }
  
  .role-tabs >>> .el-tabs__item.is-active {
    color: #667eea;
  }

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-header {
  text-align: center;
  padding: 30px 30px 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.login-logo {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
}

.logo-icon {
  font-size: 32px;
  margin-right: 10px;
}

.logo-text {
  font-size: 24px;
  font-weight: 600;
}

.login-title {
  font-size: 28px;
  font-weight: 600;
  margin: 0 0 10px;
}

.login-subtitle {
  font-size: 14px;
  opacity: 0.9;
  margin: 0;
}

.form-card {
  border: none;
  box-shadow: none;
  margin: 0;
  padding: 30px;
}

.login-tabs {
  width: 100%;
}

.login-tabs .el-tabs__header {
  margin-bottom: 20px;
}

.login-tabs .el-tabs__nav-wrap::after {
  height: 1px;
}

.login-form {
  margin: 0;
}

.el-form-item {
  margin-bottom: 24px;
}

.el-input {
  border-radius: 8px;
  transition: all 0.3s;
}

.el-input:focus-within {
  box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
}

.el-input__wrapper {
  border-radius: 8px;
  background-color: #f8f9fa;
}

.el-input__wrapper:focus-within {
  box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
  background-color: #ffffff;
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.login-hint,
.form-hint {
  font-size: 12px;
  color: #606266;
  background: #f5f7fa;
  padding: 6px 10px;
  border-radius: 4px;
  border: 1px solid #ebeef5;
  line-height: 1.5;
}

.form-hint {
  text-align: center;
  margin-bottom: 8px;
}

.login-button {
  width: 100%;
  padding: 12px 0;
  font-size: 16px;
  font-weight: 500;
  border-radius: 8px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  transition: all 0.3s;
}

.login-button:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.login-button:active:not(:disabled) {
  transform: translateY(0);
}

.login-button:disabled {
  background: #dcdfe6;
  cursor: not-allowed;
}

.code-button {
  color: #667eea;
  font-size: 14px;
  padding: 0 15px;
}

.code-button:hover {
  color: #536dfe;
}

.code-button:disabled {
  color: #c0c4cc;
  cursor: not-allowed;
}

.login-footer {
  padding: 20px 30px;
  background: #f8f9fa;
  border-top: 1px solid #ebeef5;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.login-switch {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #606266;
}

.login-switch .el-link {
  font-size: 14px;
}

.system-info {
  text-align: center;
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

/* 密码切换按钮样式 */
.password-toggle {
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  color: #909399;
  transition: color 0.3s;
}

.password-toggle:hover {
  color: #667eea;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .login-content {
    padding: 0 15px;
  }
  
  .login-header {
    padding: 25px 20px 15px;
  }
  
  .login-title {
    font-size: 24px;
  }
  
  .logo-text {
    font-size: 20px;
  }
  
  .form-card {
    padding: 25px 20px;
  }
  
  .login-footer {
    padding: 15px 20px;
  }
}

@media (max-width: 480px) {
  .login-card {
    border-radius: 8px;
  }
  
  .login-header {
    padding: 20px 15px 15px;
  }
  
  .login-title {
    font-size: 22px;
  }
  
  .login-subtitle {
    font-size: 13px;
  }
  
  .form-card {
    padding: 20px 15px;
  }
  
  .el-form-item {
    margin-bottom: 20px;
  }
  
  .form-options {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .login-hint {
    align-self: flex-end;
  }
}

/* 动画效果 */
.el-input__inner {
  transition: all 0.3s ease;
}

.el-checkbox {
  user-select: none;
}
</style>