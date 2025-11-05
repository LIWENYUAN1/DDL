<template>
  <div class="user-profile">
    <el-card shadow="never">
      <template #header>
        <h3>个人中心</h3>
      </template>

      <el-tabs v-model="activeTab">
        <!-- 基本信息 -->
        <el-tab-pane label="基本信息" name="basic">
          <el-form
            ref="profileFormRef"
            :model="profileForm"
            :rules="profileRules"
            label-width="100px"
            class="profile-form"
          >
            <el-form-item label="头像">
              <el-upload
                class="avatar-uploader"
                :show-file-list="false"
                :on-success="handleAvatarSuccess"
                :before-upload="beforeAvatarUpload"
                action="#"
                :auto-upload="false"
              >
                <img v-if="profileForm.avatar" :src="profileForm.avatar" class="avatar">
                <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
              </el-upload>
            </el-form-item>

            <el-form-item label="用户名" prop="username">
              <el-input v-model="profileForm.username" disabled />
            </el-form-item>

            <el-form-item label="真实姓名" prop="realName">
              <el-input v-model="profileForm.realName" placeholder="请输入真实姓名" />
            </el-form-item>

            <el-form-item label="手机号" prop="phone">
              <el-input v-model="profileForm.phone" placeholder="请输入手机号">
                <template #append>
                  <el-button>验证</el-button>
                </template>
              </el-input>
            </el-form-item>

            <el-form-item label="邮箱" prop="email">
              <el-input v-model="profileForm.email" placeholder="请输入邮箱" />
            </el-form-item>

            <el-form-item label="常用地址">
              <el-input 
                v-model="profileForm.address" 
                placeholder="请输入常用地址"
                type="textarea"
                :rows="2"
              />
            </el-form-item>

            <el-form-item>
              <el-button type="primary" @click="saveProfile" :loading="saving">
                保存修改
              </el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>

        <!-- 修改密码 -->
        <el-tab-pane label="修改密码" name="password">
          <el-form
            ref="passwordFormRef"
            :model="passwordForm"
            :rules="passwordRules"
            label-width="100px"
            class="password-form"
          >
            <el-form-item label="当前密码" prop="oldPassword">
              <el-input 
                v-model="passwordForm.oldPassword" 
                type="password"
                placeholder="请输入当前密码"
                show-password
              />
            </el-form-item>

            <el-form-item label="新密码" prop="newPassword">
              <el-input 
                v-model="passwordForm.newPassword" 
                type="password"
                placeholder="请输入新密码（6-20位）"
                show-password
              />
            </el-form-item>

            <el-form-item label="确认密码" prop="confirmPassword">
              <el-input 
                v-model="passwordForm.confirmPassword" 
                type="password"
                placeholder="请再次输入新密码"
                show-password
              />
            </el-form-item>

            <el-form-item>
              <el-button type="primary" @click="changePassword" :loading="changing">
                修改密码
              </el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>

        <!-- 账号设置 -->
        <el-tab-pane label="账号设置" name="settings">
          <el-form label-width="150px" class="settings-form">
            <el-form-item label="消息通知">
              <el-switch v-model="settings.messageNotify" />
              <span class="form-tip">接收系统消息和预约通知</span>
            </el-form-item>

            <el-form-item label="邮件通知">
              <el-switch v-model="settings.emailNotify" />
              <span class="form-tip">接收邮件提醒</span>
            </el-form-item>

            <el-form-item label="短信通知">
              <el-switch v-model="settings.smsNotify" />
              <span class="form-tip">接收短信提醒</span>
            </el-form-item>

            <el-form-item>
              <el-button type="primary" @click="saveSettings">
                保存设置
              </el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, FormInstance, FormRules } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import { userApi } from '@/api/index'

// 表单引用
const profileFormRef = ref<FormInstance>()
const passwordFormRef = ref<FormInstance>()

// 状态
const activeTab = ref('basic')
const saving = ref(false)
const changing = ref(false)

// 个人信息表单
const profileForm = reactive({
  avatar: '',
  username: '',
  realName: '',
  phone: '',
  email: '',
  address: ''
})

// 密码表单
const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

// 设置
const settings = reactive({
  messageNotify: true,
  emailNotify: true,
  smsNotify: false
})

// 表单验证规则
const profileRules = reactive<FormRules>({
  realName: [
    { required: true, message: '请输入真实姓名', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '手机号格式不正确', trigger: 'blur' }
  ],
  email: [
    { type: 'email', message: '邮箱格式不正确', trigger: 'blur' }
  ]
})

const passwordRules = reactive<FormRules>({
  oldPassword: [
    { required: true, message: '请输入当前密码', trigger: 'blur' }
  ],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度为6-20位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请再次输入新密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== passwordForm.newPassword) {
          callback(new Error('两次输入的密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
})

// 头像上传
const handleAvatarSuccess = (response: any, file: any) => {
  profileForm.avatar = URL.createObjectURL(file.raw)
}

const beforeAvatarUpload = (file: any) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isImage) {
    ElMessage.error('只能上传图片文件')
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB')
  }
  return isImage && isLt2M
}

// 保存个人信息
const saveProfile = async () => {
  try {
    await profileFormRef.value?.validate()
    saving.value = true

    const payload = {
      realName: profileForm.realName,
      phone: profileForm.phone,
      email: profileForm.email,
      address: profileForm.address,
      avatar: profileForm.avatar
    }

    await userApi.updateUserInfo(payload)
    ElMessage.success('保存成功')
    await loadUserInfo()
  } catch (error) {
    if (error instanceof Error) {
      ElMessage.error(error.message)
    }
    console.error('保存失败', error)
  } finally {
    saving.value = false
  }
}

// 修改密码
const changePassword = async () => {
  try {
    await passwordFormRef.value?.validate()
    changing.value = true

    await userApi.changePassword({
      oldPassword: passwordForm.oldPassword,
      newPassword: passwordForm.newPassword
    })

    ElMessage.success('密码修改成功，请重新登录')
    passwordForm.oldPassword = ''
    passwordForm.newPassword = ''
    passwordForm.confirmPassword = ''
  } catch (error) {
    if (error instanceof Error) {
      ElMessage.error(error.message)
    }
    console.error('修改失败', error)
  } finally {
    changing.value = false
  }
}

// 保存设置
const saveSettings = () => {
  ElMessage.success('设置已保存')
}

// 加载用户信息
const loadUserInfo = async () => {
  try {
    const response = await userApi.getUserInfo()
    const user = response.data || {}
    profileForm.username = user.username || ''
    profileForm.phone = user.phone || ''
    profileForm.email = user.email || ''
    profileForm.realName = user.realName || ''
    profileForm.avatar = user.avatar || ''
    profileForm.address = user.address || ''

    localStorage.setItem('userInfo', JSON.stringify(user))
  } catch (error) {
    ElMessage.error('获取用户信息失败')
    console.error('加载用户信息失败', error)
  }
}

// 初始化
onMounted(() => {
  loadUserInfo()
})
</script>

<style scoped>
.user-profile {
  width: 100%;
}

h3 {
  margin: 0;
  font-size: 18px;
}

.profile-form,
.password-form,
.settings-form {
  max-width: 600px;
  padding: 20px 0;
}

.avatar-uploader {
  display: inline-block;
}

.avatar-uploader :deep(.el-upload) {
  border: 1px dashed var(--el-border-color);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
}

.avatar-uploader :deep(.el-upload:hover) {
  border-color: var(--el-color-primary);
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 120px;
  height: 120px;
  text-align: center;
  line-height: 120px;
}

.avatar {
  width: 120px;
  height: 120px;
  display: block;
  object-fit: cover;
  border-radius: 6px;
}

.form-tip {
  margin-left: 10px;
  font-size: 12px;
  color: #909399;
}
</style>


