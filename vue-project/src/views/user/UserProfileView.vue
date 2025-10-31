<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElForm, ElFormItem, ElInput, ElButton, ElUpload, ElImage } from 'element-plus'
import { Edit, Save, Upload, User, Phone, MapPin, Calendar, IDCard, Lock, Document } from '@element-plus/icons-vue'
import { useUserStore } from '@/store/modules/user'

const userStore = useUserStore()
const router = useRouter()

// 界面状态
const editMode = ref(false)
const loading = ref(false)

// 表单数据
const formData = ref({
  name: '',
  phone: '',
  avatar: '',
  address: '',
  birthDate: '',
  idCard: '',
  email: ''
})

// 生命周期
onMounted(async () => {
  await loadUserData()
})

// 加载用户数据
const loadUserData = async () => {
  try {
    loading.value = true
    await userStore.getUserInfo()
    
    if (userStore.userInfo) {
      formData.value = {
        name: userStore.userInfo.name || '',
        phone: userStore.userInfo.phone || '',
        avatar: userStore.userInfo.avatar || '',
        address: userStore.userInfo.address || '',
        birthDate: userStore.userInfo.birthDate || '',
        idCard: userStore.userInfo.idCard || '',
        email: userStore.userInfo.email || ''
      }
    }
  } catch (error) {
    console.error('加载用户信息失败:', error)
    ElMessage.error('加载用户信息失败')
  } finally {
    loading.value = false
  }
}

// 切换编辑模式
const toggleEditMode = () => {
  if (editMode.value) {
    // 取消编辑，恢复原数据
    loadUserData()
  }
  editMode.value = !editMode.value
}

// 保存用户信息
const saveUserInfo = async () => {
  try {
    // 表单验证
    if (!formData.value.name.trim()) {
      ElMessage.warning('请输入姓名')
      return
    }
    
    if (!formData.value.phone.trim()) {
      ElMessage.warning('请输入手机号')
      return
    }
    
    // 手机号格式验证
    const phoneRegex = /^1[3-9]\d{9}$/
    if (!phoneRegex.test(formData.value.phone)) {
      ElMessage.warning('请输入正确的手机号格式')
      return
    }
    
    loading.value = true
    
    await userStore.updateUserInfo(formData.value)
    
    ElMessage.success('个人信息更新成功')
    editMode.value = false
  } catch (error) {
    console.error('更新个人信息失败:', error)
    ElMessage.error('更新个人信息失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 处理头像上传
const handleAvatarUpload = (uploadFile: any) => {
  // 这里可以实现实际的头像上传逻辑
  // 为了演示，我们直接将文件添加到表单中
  const reader = new FileReader()
  reader.onload = (e) => {
    if (e.target?.result) {
      formData.value.avatar = String(e.target.result)
    }
  }
  reader.readAsDataURL(uploadFile.raw)
  return false // 阻止默认上传
}

// 修改密码
const changePassword = () => {
  // 可以导航到修改密码页面或显示修改密码弹窗
  ElMessage.info('修改密码功能即将上线')
}

// 跳转到预约订单页面
const goToAppointments = () => {
  router.push('/user/appointments')
}
</script>

<template>
  <div class="user-profile-container">
    <div class="page-header">
      <h1>个人中心</h1>
    </div>

    <el-card class="profile-card">
      <div v-if="loading" class="loading-state">
        <el-skeleton :rows="10" animated />
      </div>
      
      <div v-else>
        <!-- 头像和基本信息 -->
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
                <el-icon><Upload /></el-icon>
                <div class="avatar-text">上传头像</div>
              </div>
            </el-upload>
            
            <el-image 
              v-else
              v-if="formData.avatar" 
              :src="formData.avatar"
              class="avatar"
            />
            <div v-else class="avatar-placeholder">
              <el-icon><User /></el-icon>
              <div class="avatar-text">{{ formData.name.charAt(0) || '用' }}</div>
            </div>
          </div>
          
          <div class="basic-info">
            <h2 class="user-name">{{ formData.name || '未设置姓名' }}</h2>
            <p class="user-phone">{{ formData.phone || '未设置手机号' }}</p>
            <p class="user-email">{{ formData.email || '未设置邮箱' }}</p>
          </div>
          
          <div class="header-actions">
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
              @click="saveUserInfo"
              :loading="loading"
            >
              <Save /> 保存修改
            </el-button>
          </div>
        </div>

        <!-- 详细信息表单 -->
        <el-divider />
        
        <div class="profile-form">
          <el-form label-position="top" :disabled="!editMode">
            <div class="form-row">
              <el-form-item label="姓名" required class="form-col">
                <el-input
                  v-model="formData.name"
                  placeholder="请输入姓名"
                  maxlength="20"
                  show-word-limit
                />
              </el-form-item>
              
              <el-form-item label="手机号" required class="form-col">
                <el-input
                  v-model="formData.phone"
                  placeholder="请输入手机号"
                  maxlength="11"
                  show-word-limit
                />
              </el-form-item>
            </div>
            
            <div class="form-row">
              <el-form-item label="邮箱" class="form-col">
                <el-input
                  v-model="formData.email"
                  placeholder="请输入邮箱"
                  maxlength="50"
                  show-word-limit
                />
              </el-form-item>
              
              <el-form-item label="身份证号" class="form-col">
                <el-input
                  v-model="formData.idCard"
                  placeholder="请输入身份证号"
                  maxlength="18"
                  show-word-limit
                  show-password
                />
              </el-form-item>
            </div>
            
            <el-form-item label="居住地址">
              <el-input
                v-model="formData.address"
                placeholder="请输入居住地址"
                type="textarea"
                :rows="2"
                maxlength="100"
                show-word-limit
              />
            </el-form-item>
            
            <el-form-item label="出生日期">
              <el-date-picker
                v-model="formData.birthDate"
                type="date"
                placeholder="选择出生日期"
                style="width: 100%"
              />
            </el-form-item>
          </el-form>
        </div>

        <!-- 订单管理 -->
        <el-divider />
        
        <div class="order-section">
          <h3>订单管理</h3>
          <div class="order-item">
            <div class="order-label">
              <el-icon><Document /></el-icon>
              <span>我的预约订单</span>
            </div>
            <el-button type="primary" @click="goToAppointments">
              查看订单
            </el-button>
          </div>
        </div>
        
        <!-- 安全设置 -->
        <el-divider />
        
        <div class="security-section">
          <h3>安全设置</h3>
          <div class="security-item">
            <div class="security-label">
              <el-icon><Lock /></el-icon>
              <span>修改密码</span>
            </div>
            <el-button type="primary" @click="changePassword">
              修改
            </el-button>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<style scoped>
.user-profile-container {
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
}

.loading-state {
  padding: 20px;
}

/* 头像和基本信息 */
.profile-header {
  display: flex;
  align-items: center;
  gap: 30px;
  padding: 30px 0;
  border-bottom: 1px solid #ebeef5;
}

.avatar-section {
  flex-shrink: 0;
}

.avatar {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  cursor: pointer;
}

.avatar-placeholder {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  background-color: #f0f2f5;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  color: #909399;
  transition: all 0.3s ease;
}

.avatar-placeholder:hover {
  background-color: #e6e8eb;
  color: #606266;
}

.avatar-placeholder .el-icon {
  font-size: 36px;
  margin-bottom: 8px;
}

.avatar-text {
  font-size: 14px;
}

.avatar-uploader .avatar-placeholder {
  border: 2px dashed #dcdfe6;
}

.basic-info {
  flex: 1;
}

.user-name {
  font-size: 24px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 8px;
}

.user-phone,
.user-email {
  font-size: 14px;
  color: #606266;
  margin-bottom: 4px;
}

.header-actions {
  flex-shrink: 0;
  display: flex;
  gap: 10px;
}

/* 表单样式 */
.profile-form {
  padding: 30px 0;
}

.form-row {
  display: flex;
  gap: 30px;
  margin-bottom: 20px;
}

.form-col {
  flex: 1;
}

/* 订单管理 */
.order-section {
  padding: 20px 0;
}

.order-section h3 {
  font-size: 18px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 20px;
}

.order-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 0;
  border-bottom: 1px solid #f0f2f5;
}

.order-label {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 14px;
  color: #303133;
}

.order-label .el-icon {
  color: #606266;
}

/* 安全设置 */
.security-section {
  padding: 20px 0;
}

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
  .user-profile-container {
    padding: 10px;
  }
  
  .profile-header {
    flex-direction: column;
    text-align: center;
    gap: 20px;
  }
  
  .header-actions {
    justify-content: center;
    width: 100%;
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
  }
  
  .user-name {
    font-size: 20px;
  }
}
</style>