<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElForm, ElFormItem, ElInput, ElButton, ElUpload, ElImage, ElRate } from 'element-plus'
import { Edit, Save, Upload, Shop, Phone, MapPin, Star, StarFilled, Lock, Business } from '@element-plus/icons-vue'
import { useShopStore } from '@/store/modules/shop'

const shopStore = useShopStore()

// 界面状态
const editMode = ref(false)
const loading = ref(false)

// 表单数据
const formData = ref({
  shopName: '',
  phone: '',
  address: '',
  description: '',
  logo: '',
  coverImage: '',
  businessHours: '',
  contactPerson: '',
  contactPhone: '',
  licenseNumber: '',
  location: { lat: 0, lng: 0 }
})

// 生命周期
onMounted(async () => {
  await loadShopData()
})

// 加载商家数据
const loadShopData = async () => {
  try {
    loading.value = true
    await shopStore.getShopInfo()
    
    if (shopStore.shopInfo) {
      formData.value = {
        shopName: shopStore.shopInfo.shopName || '',
        phone: shopStore.shopInfo.phone || '',
        address: shopStore.shopInfo.address || '',
        description: shopStore.shopInfo.description || '',
        logo: shopStore.shopInfo.logo || '',
        coverImage: shopStore.shopInfo.coverImage || '',
        businessHours: shopStore.shopInfo.businessHours || '',
        contactPerson: shopStore.shopInfo.contactPerson || '',
        contactPhone: shopStore.shopInfo.contactPhone || '',
        licenseNumber: shopStore.shopInfo.licenseNumber || '',
        location: shopStore.shopInfo.location || { lat: 0, lng: 0 }
      }
    }
  } catch (error) {
    console.error('加载商家信息失败:', error)
    ElMessage.error('加载商家信息失败')
  } finally {
    loading.value = false
  }
}

// 切换编辑模式
const toggleEditMode = () => {
  if (editMode.value) {
    // 取消编辑，恢复原数据
    loadShopData()
  }
  editMode.value = !editMode.value
}

// 保存商家信息
const saveShopInfo = async () => {
  try {
    // 表单验证
    if (!formData.value.shopName.trim()) {
      ElMessage.warning('请输入店铺名称')
      return
    }
    
    if (!formData.value.phone.trim()) {
      ElMessage.warning('请输入店铺电话')
      return
    }
    
    if (!formData.value.address.trim()) {
      ElMessage.warning('请输入店铺地址')
      return
    }
    
    // 手机号格式验证
    const phoneRegex = /^1[3-9]\d{9}$/
    if (!phoneRegex.test(formData.value.phone)) {
      ElMessage.warning('请输入正确的手机号格式')
      return
    }
    
    loading.value = true
    
    await shopStore.updateShopInfo(formData.value)
    
    ElMessage.success('商家信息更新成功')
    editMode.value = false
  } catch (error) {
    console.error('更新商家信息失败:', error)
    ElMessage.error('更新商家信息失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 处理图片上传
const handleImageUpload = (field: string, uploadFile: any) => {
  const reader = new FileReader()
  reader.onload = (e) => {
    if (e.target?.result) {
      // @ts-ignore
      formData.value[field] = String(e.target.result)
    }
  }
  reader.readAsDataURL(uploadFile.raw)
  return false // 阻止默认上传
}

// 修改密码
const changePassword = () => {
  ElMessage.info('修改密码功能即将上线')
}

// 模拟的商家评分数据
const shopRating = ref(4.8)
const reviewCount = ref(156)
</script>

<template>
  <div class="shop-profile-container">
    <div class="page-header">
      <h1>商家信息</h1>
    </div>

    <el-card class="profile-card">
      <div v-if="loading" class="loading-state">
        <el-skeleton :rows="12" animated />
      </div>
      
      <div v-else>
        <!-- 店铺封面和基本信息 -->
        <div class="cover-section">
          <el-upload
            v-if="editMode"
            action="#"
            :on-change="(file) => handleImageUpload('coverImage', file)"
            :auto-upload="false"
            accept="image/*"
            class="cover-uploader"
          >
            <el-image 
              v-if="formData.coverImage" 
              :src="formData.coverImage"
              class="cover-image"
            />
            <div v-else class="cover-placeholder">
              <el-icon><Upload /></el-icon>
              <div class="cover-text">上传店铺封面</div>
            </div>
          </el-upload>
          
          <el-image 
            v-else
            v-if="formData.coverImage" 
            :src="formData.coverImage"
            class="cover-image"
          />
          <div v-else class="cover-placeholder">
            <el-icon><Shop /></el-icon>
            <div class="cover-text">暂无封面</div>
          </div>
        </div>

        <div class="profile-content">
          <div class="basic-info">
            <div class="shop-identity">
              <el-upload
                v-if="editMode"
                action="#"
                :on-change="(file) => handleImageUpload('logo', file)"
                :auto-upload="false"
                accept="image/*"
                class="logo-uploader"
              >
                <el-image 
                  v-if="formData.logo" 
                  :src="formData.logo"
                  class="shop-logo"
                />
                <div v-else class="logo-placeholder">
                  <el-icon><Upload /></el-icon>
                </div>
              </el-upload>
              
              <el-image 
                v-else
                v-if="formData.logo" 
                :src="formData.logo"
                class="shop-logo"
              />
              <div v-else class="logo-placeholder">
                <el-icon><Business /></el-icon>
              </div>
              
              <div class="shop-info">
                <h2 class="shop-name">{{ formData.shopName || '未设置店铺名称' }}</h2>
                <div class="shop-meta">
                  <div class="rating-info">
                    <el-rate v-model="shopRating" disabled show-score />
                    <span class="review-count">({{ reviewCount }}条评价)</span>
                  </div>
                  <div class="business-hours">{{ formData.businessHours || '营业时间待定' }}</div>
                </div>
              </div>
              
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
                  @click="saveShopInfo"
                  :loading="loading"
                >
                  <Save /> 保存修改
                </el-button>
              </div>
            </div>

            <div class="shop-description">
              <h3>店铺介绍</h3>
              <p>{{ formData.description || '暂无店铺介绍' }}</p>
            </div>
          </div>

          <!-- 详细信息表单 -->
          <el-divider />
          
          <div class="profile-form">
            <h3>基本信息</h3>
            <el-form label-position="top" :disabled="!editMode">
              <div class="form-row">
                <el-form-item label="店铺名称" required class="form-col">
                  <el-input
                    v-model="formData.shopName"
                    placeholder="请输入店铺名称"
                    maxlength="30"
                    show-word-limit
                  />
                </el-form-item>
                
                <el-form-item label="店铺电话" required class="form-col">
                  <el-input
                    v-model="formData.phone"
                    placeholder="请输入店铺电话"
                    maxlength="11"
                    show-word-limit
                  />
                </el-form-item>
              </div>
              
              <el-form-item label="店铺地址" required>
                <el-input
                  v-model="formData.address"
                  placeholder="请输入店铺详细地址"
                  maxlength="100"
                  show-word-limit
                />
              </el-form-item>
              
              <el-form-item label="营业时间">
                <el-input
                  v-model="formData.businessHours"
                  placeholder="如：周一至周日 09:00-21:00"
                  maxlength="50"
                  show-word-limit
                />
              </el-form-item>
              
              <el-form-item label="店铺介绍">
                <el-input
                  v-model="formData.description"
                  placeholder="请输入店铺介绍"
                  type="textarea"
                  :rows="4"
                  maxlength="500"
                  show-word-limit
                />
              </el-form-item>
            </el-form>
          </div>

          <el-divider />
          
          <div class="profile-form">
            <h3>联系信息</h3>
            <el-form label-position="top" :disabled="!editMode">
              <div class="form-row">
                <el-form-item label="联系人" class="form-col">
                  <el-input
                    v-model="formData.contactPerson"
                    placeholder="请输入联系人姓名"
                    maxlength="20"
                    show-word-limit
                  />
                </el-form-item>
                
                <el-form-item label="联系电话" class="form-col">
                  <el-input
                    v-model="formData.contactPhone"
                    placeholder="请输入联系人电话"
                    maxlength="11"
                    show-word-limit
                  />
                </el-form-item>
              </div>
              
              <el-form-item label="营业执照号">
                <el-input
                  v-model="formData.licenseNumber"
                  placeholder="请输入营业执照号"
                  maxlength="50"
                  show-word-limit
                  show-password
                />
              </el-form-item>
            </el-form>
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
      </div>
    </el-card>
  </div>
</template>

<style scoped>
.shop-profile-container {
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

/* 封面图 */
.cover-section {
  width: 100%;
  height: 200px;
  overflow: hidden;
}

.cover-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.cover-placeholder {
  width: 100%;
  height: 100%;
  background-color: #f0f2f5;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  color: #909399;
  transition: all 0.3s ease;
}

.cover-placeholder:hover {
  background-color: #e6e8eb;
  color: #606266;
}

.cover-placeholder .el-icon {
  font-size: 48px;
  margin-bottom: 10px;
}

.cover-text {
  font-size: 16px;
}

.cover-uploader .cover-placeholder {
  border: 2px dashed #dcdfe6;
}

/* 基本信息 */
.profile-content {
  padding: 30px;
}

.shop-identity {
  display: flex;
  align-items: flex-start;
  gap: 30px;
  margin-bottom: 30px;
}

.logo-uploader {
  flex-shrink: 0;
}

.shop-logo {
  width: 100px;
  height: 100px;
  border-radius: 8px;
  object-fit: cover;
}

.logo-placeholder {
  width: 100px;
  height: 100px;
  border-radius: 8px;
  background-color: #f0f2f5;
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  color: #909399;
  font-size: 32px;
  transition: all 0.3s ease;
}

.logo-placeholder:hover {
  background-color: #e6e8eb;
  color: #606266;
}

.logo-uploader .logo-placeholder {
  border: 2px dashed #dcdfe6;
}

.shop-info {
  flex: 1;
}

.shop-name {
  font-size: 28px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 10px;
}

.shop-meta {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.rating-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.review-count {
  font-size: 14px;
  color: #606266;
}

.business-hours {
  font-size: 14px;
  color: #606266;
}

.info-actions {
  flex-shrink: 0;
  display: flex;
  gap: 10px;
}

.shop-description {
  margin-bottom: 30px;
}

.shop-description h3 {
  font-size: 18px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 10px;
}

.shop-description p {
  font-size: 14px;
  color: #606266;
  line-height: 1.6;
  white-space: pre-wrap;
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
  .shop-profile-container {
    padding: 10px;
  }
  
  .cover-section {
    height: 150px;
  }
  
  .profile-content {
    padding: 20px;
  }
  
  .shop-identity {
    flex-direction: column;
    align-items: flex-start;
    gap: 20px;
  }
  
  .info-actions {
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
  
  .cover-section {
    height: 120px;
  }
  
  .shop-name {
    font-size: 24px;
  }
}
</style>