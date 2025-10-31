<template>
  <div class="register-container">
    <div class="register-card">
      <div class="register-header">
        <h2>商家注册</h2>
        <p>欢迎加入摩托车服务平台</p>
      </div>
      
      <el-form
        ref="registerFormRef"
        :model="registerForm"
        :rules="rules"
        label-width="100px"
        class="register-form"
      >
        <el-form-item label="店铺名称" prop="shopName">
          <el-input
            v-model="registerForm.shopName"
            placeholder="请输入店铺名称"
            prefix-icon="Shop"
            :disabled="loading"
          />
        </el-form-item>
        
        <el-form-item label="负责人姓名" prop="contactName">
          <el-input
            v-model="registerForm.contactName"
            placeholder="请输入负责人姓名"
            prefix-icon="User"
            :disabled="loading"
          />
        </el-form-item>
        
        <el-form-item label="手机号" prop="phone">
          <el-input
            v-model="registerForm.phone"
            placeholder="请输入手机号"
            prefix-icon="Phone"
            :disabled="loading"
          />
        </el-form-item>
        
        <el-form-item label="验证码" prop="verificationCode">
          <el-input-group>
            <el-input
              v-model="registerForm.verificationCode"
              placeholder="请输入验证码"
              prefix-icon="DocumentCopy"
              :disabled="loading"
              style="width: 50%"
            />
            <el-button
              type="primary"
              :disabled="countdown > 0 || loading"
              @click="sendVerificationCode"
              style="margin-left: 10px"
            >
              {{ countdown > 0 ? `${countdown}s后重新发送` : '发送验证码' }}
            </el-button>
          </el-input-group>
        </el-form-item>
        
        <el-form-item label="密码" prop="password">
          <el-input
            v-model="registerForm.password"
            type="password"
            placeholder="请设置密码（6-20位）"
            prefix-icon="Lock"
            :disabled="loading"
            show-password
          />
        </el-form-item>
        
        <el-form-item label="确认密码" prop="confirmPassword">
          <el-input
            v-model="registerForm.confirmPassword"
            type="password"
            placeholder="请再次输入密码"
            prefix-icon="Lock"
            :disabled="loading"
            show-password
          />
        </el-form-item>
        
        <el-form-item label="店铺地址" prop="address">
          <el-input
            v-model="registerForm.address"
            placeholder="请输入店铺详细地址"
            prefix-icon="Location"
            :disabled="loading"
            type="textarea"
            :rows="2"
          />
        </el-form-item>
        
        <el-form-item label="营业执照" prop="license">
          <el-upload
            class="avatar-uploader"
            :action="''"
            :show-file-list="false"
            :before-upload="beforeUploadLicense"
            :disabled="loading"
          >
            <img v-if="licenseUrl" :src="licenseUrl" class="license-img" alt="营业执照" />
            <el-icon v-else class="avatar-uploader-icon"><Upload /></el-icon>
          </el-upload>
          <div class="upload-tip">请上传营业执照照片（PNG、JPG格式）</div>
        </el-form-item>
        
        <el-form-item>
          <el-checkbox v-model="registerForm.agreement" :disabled="loading">
            我已阅读并同意 <el-link type="primary">用户协议</el-link> 和 <el-link type="primary">隐私政策</el-link>
          </el-checkbox>
        </el-form-item>
        
        <el-form-item>
          <el-button
            type="primary"
            class="register-btn"
            :loading="loading"
            @click="handleRegister"
          >
            提交注册
          </el-button>
        </el-form-item>
        
        <div class="login-link">
          已有账号？<el-link type="primary" @click="toLogin">立即登录</el-link>
        </div>
      </el-form>
      
      <div class="switch-role">
        <el-link @click="switchToUserRegister">用户注册入口</el-link>
        <el-link @click="switchToAdminLogin">管理员登录</el-link>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useShopStore } from '@/store/modules/shop'
import type { FormInstance, FormRules } from 'element-plus'
import { Upload } from '@element-plus/icons-vue'

const router = useRouter()
const shopStore = useShopStore()
const registerFormRef = ref<FormInstance>()

// 表单数据
const registerForm = reactive({
  shopName: '',
  contactName: '',
  phone: '',
  verificationCode: '',
  password: '',
  confirmPassword: '',
  address: '',
  agreement: false
})

// 营业执照图片
const licenseUrl = ref('')
// 验证码倒计时
const countdown = ref(0)
// 加载状态
const loading = ref(false)

// 表单验证规则
const rules = reactive<FormRules>({
  shopName: [
    { required: true, message: '请输入店铺名称', trigger: 'blur' },
    { min: 2, max: 50, message: '店铺名称长度在 2 到 50 个字符', trigger: 'blur' }
  ],
  contactName: [
    { required: true, message: '请输入负责人姓名', trigger: 'blur' },
    { min: 2, max: 20, message: '姓名长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
  ],
  verificationCode: [
    { required: true, message: '请输入验证码', trigger: 'blur' },
    { pattern: /^\d{4,6}$/, message: '验证码格式不正确', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请设置密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== registerForm.password) {
          callback(new Error('两次输入的密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ],
  address: [
    { required: true, message: '请输入店铺地址', trigger: 'blur' },
    { min: 5, max: 200, message: '地址长度在 5 到 200 个字符', trigger: 'blur' }
  ],
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

// 上传营业执照前的校验
const beforeUploadLicense = (file: File) => {
  const isImage = file.type === 'image/jpeg' || file.type === 'image/png'
  if (!isImage) {
    ElMessage.error('只能上传 JPG 或 PNG 格式的图片！')
    return false
  }
  
  const isLt2M = file.size / 1024 / 1024 < 2
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB！')
    return false
  }
  
  // 本地预览
  const reader = new FileReader()
  reader.onload = (e) => {
    licenseUrl.value = e.target?.result ? String(e.target.result) : ''
  }
  reader.readAsDataURL(file)
  
  return false // 阻止自动上传
}

// 发送验证码
const sendVerificationCode = async () => {
  // 验证手机号
  const phoneValid = await registerFormRef.value?.validateField('phone')
  if (phoneValid) return
  
  try {
    // 调用发送验证码接口
    // await shopStore.sendVerificationCode(registerForm.phone)
    ElMessage.success('验证码已发送，请注意查收')
    
    // 开始倒计时
    countdown.value = 60
    const timer = setInterval(() => {
      countdown.value--
      if (countdown.value <= 0) {
        clearInterval(timer)
      }
    }, 1000)
  } catch (error) {
    ElMessage.error('发送验证码失败，请重试')
  }
}

// 处理注册
const handleRegister = async () => {
  // 表单验证
  const isValid = await registerFormRef.value?.validate()
  if (!isValid) return
  
  // 检查是否上传了营业执照
  if (!licenseUrl.value) {
    ElMessage.error('请上传营业执照照片')
    return
  }
  
  loading.value = true
  
  try {
    // 准备注册数据
    const registerData = {
      ...registerForm,
      license: licenseUrl.value // 实际项目中这里应该是文件上传后的URL
    }
    
    // 调用注册接口
    // await shopStore.register(registerData)
    
    // 模拟注册成功
    await new Promise(resolve => setTimeout(resolve, 1500))
    
    ElMessage.success('注册成功，等待管理员审核通过后即可登录')
    
    // 跳转到登录页
    setTimeout(() => {
      router.push('/shop/login')
    }, 2000)
  } catch (error) {
    ElMessage.error('注册失败，请重试')
  } finally {
    loading.value = false
  }
}

// 跳转到登录页
const toLogin = () => {
  router.push('/shop/login')
}

// 跳转到用户注册
const switchToUserRegister = () => {
  router.push('/register')
}

// 跳转到管理员登录
const switchToAdminLogin = () => {
  router.push('/admin/login')
}
</script>

<style scoped>
.register-container {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  padding: 20px;
}

.register-card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  padding: 30px;
  width: 100%;
  max-width: 500px;
}

.register-header {
  text-align: center;
  margin-bottom: 30px;
}

.register-header h2 {
  margin: 0 0 10px 0;
  color: #333;
  font-size: 24px;
  font-weight: 600;
}

.register-header p {
  margin: 0;
  color: #666;
  font-size: 14px;
}

.register-form {
  margin-bottom: 20px;
}

.avatar-uploader {
  display: flex;
  justify-content: center;
  margin-bottom: 10px;
}

.license-img {
  width: 120px;
  height: 120px;
  object-fit: cover;
  border-radius: 4px;
}

.avatar-uploader-icon {
  width: 120px;
  height: 120px;
  font-size: 24px;
  color: #909399;
  background-color: #f0f2f5;
  border: 1px dashed #dcdfe6;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  justify-content: center;
  align-items: center;
}

.upload-tip {
  text-align: center;
  color: #909399;
  font-size: 12px;
}

.register-btn {
  width: 100%;
  height: 40px;
  font-size: 16px;
}

.login-link {
  text-align: center;
  margin: 20px 0;
  font-size: 14px;
  color: #666;
}

.switch-role {
  display: flex;
  justify-content: space-between;
  padding-top: 20px;
  border-top: 1px solid #eee;
  font-size: 14px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .register-container {
    padding: 10px;
  }
  
  .register-card {
    padding: 20px;
  }
  
  .register-header h2 {
    font-size: 20px;
  }
}
</style>