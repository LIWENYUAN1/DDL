<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElForm, ElFormItem, ElInput, ElButton, ElUpload, ElImage, ElSwitch, ElMessageBox } from 'element-plus'
import { Edit, Save, Upload, User, Lock, Phone, Message as Mail, UserFilled } from '@element-plus/icons-vue'
import { useUserStore } from '@/store/modules/user'

const userStore = useUserStore()

// 界面状态
const editMode = ref(false)
const loading = ref(false)

// 表单数据
const formData = ref({
  username: '',
  nickname: '',
  phone: '',
  email: '',
  avatar: '',
  status: true,
  lastLoginTime: '',
  lastLoginIp: ''
})

// 密码修改表单
const passwordForm = ref({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

const passwordDialogVisible = ref(false)

// 生命周期
onMounted(async () => {
  await loadAdminData()
})

// 加载管理员数据
const loadAdminData = async () => {
  try {
    loading.value = true
    await userStore.getAdminInfo()
    
    if (userStore.adminInfo) {
      formData.value = {
        username: userStore.adminInfo.username || '',
        nickname: userStore.adminInfo.nickname || '',
        phone: userStore.adminInfo.phone || '',
        email: userStore.adminInfo.email || '',
        avatar: userStore.adminInfo.avatar || '',
        status: userStore.adminInfo.status || true,
        lastLoginTime: userStore.adminInfo.lastLoginTime || '',
        lastLoginIp: userStore.adminInfo.lastLoginIp || ''
      }
    }
  } catch (error) {
    console.error('加载管理员信息失败:', error)
    ElMessage.error('加载管理员信息失败')
  } finally {
    loading.value = false
  }
}

// 切换编辑模式
const toggleEditMode = () => {
  if (editMode.value) {
    // 取消编辑，恢复原数据
    loadAdminData()
  }
  editMode.value = !editMode.value
}

// 保存管理员信息
const saveAdminInfo = async () => {
  try {
    // 表单验证
    if (!formData.value.nickname.trim()) {
      ElMessage.warning('请输入昵称')
      return
    }
    
    if (formData.value.phone) {
      const phoneRegex = /^1[3-9]\d{9}$/
      if (!phoneRegex.test(formData.value.phone)) {
        ElMessage.warning('请输入正确的手机号格式')
        return
      }
    }
    
    if (formData.value.email) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      if (!emailRegex.test(formData.value.email)) {
        ElMessage.warning('请输入正确的邮箱格式')
        return
      }
    }
    
    loading.value = true
    
    await userStore.updateAdminInfo(formData.value)
    
    ElMessage.success('管理员信息更新成功')
    editMode.value = false
  } catch (error) {
    console.error('更新管理员信息失败:', error)
    ElMessage.error('更新管理员信息失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 处理头像上传
const handleAvatarUpload = (uploadFile: any) => {
  const reader = new FileReader()
  reader.onload = (e) => {
    if (e.target?.result) {
      // @ts-ignore
      formData.value.avatar = String(e.target.result)
    }
  }
  reader.readAsDataURL(uploadFile.raw)
  return false // 阻止默认上传
}

// 打开密码修改对话框
const openPasswordDialog = () => {
  passwordForm.value = {
    oldPassword: '',
    newPassword: '',
    confirmPassword: ''
  }
  passwordDialogVisible.value = true
}

// 修改密码
const changePassword = async () => {
  try {
    // 表单验证
    if (!passwordForm.value.oldPassword.trim()) {
      ElMessage.warning('请输入原密码')
      return
    }
    
    if (!passwordForm.value.newPassword.trim()) {
      ElMessage.warning('请输入新密码')
      return
    }
    
    if (passwordForm.value.newPassword !== passwordForm.value.confirmPassword) {
      ElMessage.warning('两次输入的密码不一致')
      return
    }
    
    // 密码强度验证
    if (passwordForm.value.newPassword.length < 6) {
      ElMessage.warning('密码长度不能少于6位')
      return
    }
    
    await userStore.changeAdminPassword({
      oldPassword: passwordForm.value.oldPassword,
      newPassword: passwordForm.value.newPassword
    })
    
    ElMessage.success('密码修改成功，请重新登录')
    passwordDialogVisible.value = false
    // 这里可以添加登出逻辑
    // await userStore.logout()
  } catch (error) {
    console.error('修改密码失败:', error)
    ElMessage.error('修改密码失败，请检查原密码是否正确')
  }
}

// 格式化时间
const formatDate = (dateString?: string) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  })
}
</script>

<template>
  <div class="admin-profile-container">
    <div class="page-header">
      <h1>个人资料</h1>
    </div>

    <el-card class="profile-card">
      <div v-if="loading" class="loading-state">
        <el-skeleton :rows="12" animated />
      </div>
      
      <div v-else>
        <!-- 管理员基本信息 -->
        <div class="profile-header">
          <div class="avatar-section">
            <el-upload
              v-if="editMode"
              action="#"
              :on-change="handleAvatarUpload"
              :auto-upload="false"
              accept="image/*"
              class="avatar-uploader"
            >
              <el-image 
                v-if="formData.avatar" 
                :src="formData.avatar"
                class="avatar"
              />
              <div v-else class="avatar-placeholder">
                <el-icon><UserFilled /></el-icon>
              </div>
              <div class="avatar-tip">
                <el-icon><Upload /></el-icon>
                更换头像
              </div>
            </el-upload>
            
            <el-image 
              v-else
              v-if="formData.avatar" 
              :src="formData.avatar"
              class="avatar"
            />
            <div v-else class="avatar-placeholder">
              <el-icon><UserFilled /></el-icon>
            </div>
          </div>
          
          <div class="admin-info">
            <div class="info-header">
              <h2 class="admin-name">{{ formData.nickname || formData.username || '未设置昵称' }}</h2>
              <div class="info-actions">
                <el-button 
                  v-if="!editMode" 
                  type="primary" 
                  @click="toggleEditMode"
                >
                  <Edit /> 编辑资料
                </el-button>
                <el-button 
                  v-else 
                  @click="toggleEditMode"
                >
                  取消
                </el-button>
                <el-button 
                  v-else 
                  type="primary" 
                  @click="saveAdminInfo"
                  :loading="loading"
                >
                  <Save /> 保存修改
                </el-button>
              </div>
            </div>
            
            <div class="login-info">
              <div class="login-item">
                <el-icon class="login-icon"><Clock /></el-icon>
                <span>最后登录时间：{{ formatDate(formData.lastLoginTime) }}</span>
              </div>
              <div class="login-item">
                <el-icon class="login-icon"><Position /></el-icon>
                <span>最后登录IP：{{ formData.lastLoginIp || '-' }}</span>
              </div>
            </div>
          </div>
        </div>

        <el-divider />

        <!-- 详细信息表单 -->
        <div class="profile-form">
          <h3>基本信息</h3>
          <el-form label-position="top" :disabled="!editMode">
            <div class="form-row">
              <el-form-item label="用户名" required class="form-col">
                <el-input
                  v-model="formData.username"
                  placeholder="请输入用户名"
                  maxlength="20"
                  show-word-limit
                  disabled
                />
              </el-form-item>
              
              <el-form-item label="昵称" required class="form-col">
                <el-input
                  v-model="formData.nickname"
                  placeholder="请输入昵称"
                  maxlength="20"
                  show-word-limit
                />
              </el-form-item>
            </div>
            
            <div class="form-row">
              <el-form-item label="手机号" class="form-col">
                <el-input
                  v-model="formData.phone"
                  placeholder="请输入手机号"
                  maxlength="11"
                  show-word-limit
                />
              </el-form-item>
              
              <el-form-item label="邮箱" class="form-col">
                <el-input
                  v-model="formData.email"
                  placeholder="请输入邮箱"
                  maxlength="50"
                  show-word-limit
                />
              </el-form-item>
            </div>
            
            <el-form-item label="账号状态">
              <el-switch v-model="formData.status" disabled />
              <span class="status-text">{{ formData.status ? '启用' : '禁用' }}</span>
            </el-form-item>
          </el-form>
        </div>

        <el-divider />
        
        <!-- 安全设置 -->
        <div class="security-section">
          <h3>安全设置</h3>
          <div class="security-item">
            <div class="security-label">
              <el-icon><Lock /></el-icon>
              <span>修改密码</span>
            </div>
            <el-button type="primary" @click="openPasswordDialog">
              修改
            </el-button>
          </div>
        </div>
      </div>
    </el-card>

    <!-- 密码修改对话框 -->
    <el-dialog
      v-model="passwordDialogVisible"
      title="修改密码"
      width="500px"
      destroy-on-close
    >
      <el-form :model="passwordForm" label-width="120px">
        <el-form-item label="原密码" required>
          <el-input 
            v-model="passwordForm.oldPassword" 
            type="password" 
            placeholder="请输入原密码" 
          />
        </el-form-item>
        
        <el-form-item label="新密码" required>
          <el-input 
            v-model="passwordForm.newPassword" 
            type="password" 
            placeholder="请输入新密码" 
            show-password
          />
        </el-form-item>
        
        <el-form-item label="确认新密码" required>
          <el-input 
            v-model="passwordForm.confirmPassword" 
            type="password" 
            placeholder="请再次输入新密码" 
            show-password
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="passwordDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="changePassword">确认修改</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.admin-profile-container {
  padding: 20px;
}

.page-header {
  margin-bottom: 30px;
}

.page-header h1 {
  font-size: 24px;
  font-weight: 500;
  color: #303133;
}

.profile-card {
  background-color: #ffffff;
  overflow: hidden;
}

.loading-state {
  padding: 20px;
}

/* 头像和基本信息 */
.profile-header {
  display: flex;
  align-items: flex-start;
  gap: 30px;
  padding: 20px 0;
}

.avatar-section {
  flex-shrink: 0;
  position: relative;
}

.avatar {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  object-fit: cover;
}

.avatar-placeholder {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  background-color: #f0f2f5;
  display: flex;
  justify-content: center;
  align-items: center;
  color: #909399;
  font-size: 48px;
}

.avatar-uploader {
  position: relative;
  cursor: pointer;
}

.avatar-tip {
  position: absolute;
  bottom: -30px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  align-items: center;
  gap: 5px;
  color: #409EFF;
  font-size: 14px;
}

.admin-info {
  flex: 1;
}

.info-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.admin-name {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
}

.info-actions {
  display: flex;
  gap: 10px;
}

.login-info {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.login-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #606266;
}

.login-icon {
  color: #909399;
  font-size: 16px;
}

/* 表单样式 */
.profile-form {
  margin-bottom: 30px;
}

.profile-form h3 {
  font-size: 18px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 20px;
}

.form-row {
  display: flex;
  gap: 30px;
  margin-bottom: 20px;
}

.form-col {
  flex: 1;
}

.status-text {
  margin-left: 10px;
  color: #606266;
}

/* 安全设置 */
.security-section h3 {
  font-size: 18px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 20px;
}

.security-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 0;
  border-bottom: 1px solid #f0f2f5;
}

.security-label {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  color: #303133;
}

.security-label .el-icon {
  color: #606266;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .admin-profile-container {
    padding: 10px;
  }
  
  .profile-header {
    flex-direction: column;
    align-items: center;
    text-align: center;
    gap: 20px;
  }
  
  .info-header {
    flex-direction: column;
    align-items: center;
    gap: 10px;
  }
  
  .form-row {
    flex-direction: column;
    gap: 15px;
  }
  
  .security-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
}

@media (max-width: 480px) {
  .page-header h1 {
    font-size: 20px;
  }
  
  .avatar {
    width: 100px;
    height: 100px;
  }
  
  .avatar-placeholder {
    width: 100px;
    height: 100px;
    font-size: 40px;
  }
  
  .admin-name {
    font-size: 20px;
  }
}
</style>