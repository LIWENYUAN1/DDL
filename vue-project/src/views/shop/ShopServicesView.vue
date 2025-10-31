<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox, ElForm, ElFormItem, ElInput, ElInputNumber, ElButton, ElDialog, ElUpload, ElSwitch, ElImage } from 'element-plus'
import { Plus, Edit, Delete, Search, Check, Close, RefreshLeft, Download } from '@element-plus/icons-vue'
import { useShopStore } from '@/store/modules/shop'

const shopStore = useShopStore()

// 界面状态
const searchQuery = ref('')
const loading = ref(false)
const loadingText = ref('')
const dialogVisible = ref(false)
const editMode = ref(false)
const currentServiceId = ref('')

// 表单数据
const formData = ref({
  name: '',
  description: '',
  price: 0,
  duration: 30, // 分钟
  category: '',
  status: true,
  images: []
})

// 计算属性
const services = computed(() => {
  let filtered = shopStore.services
  
  // 按搜索关键词筛选
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    filtered = filtered.filter(service => 
      service.name?.toLowerCase().includes(query) ||
      service.description?.toLowerCase().includes(query) ||
      service.category?.toLowerCase().includes(query)
    )
  }
  
  return filtered
})

// 生命周期
onMounted(async () => {
  await fetchServices()
})

// 获取服务列表
const fetchServices = async () => {
  try {
    loading.value = true
    await shopStore.getShopServices()
  } catch (error) {
    console.error('获取服务列表失败:', error)
    ElMessage.error('获取服务列表失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 打开新增服务弹窗
const openAddDialog = () => {
  editMode.value = false
  currentServiceId.value = ''
  resetForm()
  dialogVisible.value = true
}

// 打开编辑服务弹窗
const openEditDialog = (service: any) => {
  editMode.value = true
  currentServiceId.value = service.id
  formData.value = {
    name: service.name || '',
    description: service.description || '',
    price: service.price || 0,
    duration: service.duration || 30,
    category: service.category || '',
    status: service.status !== false,
    images: service.images || []
  }
  dialogVisible.value = true
}

// 关闭弹窗
const closeDialog = () => {
  dialogVisible.value = false
  setTimeout(() => {
    resetForm()
  }, 300)
}

// 重置表单
const resetForm = () => {
  formData.value = {
    name: '',
    description: '',
    price: 0,
    duration: 30,
    category: '',
    status: true,
    images: []
  }
}

// 保存服务
const saveService = async () => {
  try {
    // 表单验证
    if (!formData.value.name.trim()) {
      ElMessage.warning('请输入服务名称')
      return
    }
    
    if (formData.value.price <= 0) {
      ElMessage.warning('请输入有效的价格')
      return
    }
    
    if (formData.value.duration <= 0) {
      ElMessage.warning('请输入有效的服务时长')
      return
    }
    
    loadingText.value = 'saving'
    
    if (editMode.value) {
      // 更新服务
      await shopStore.updateShopService(currentServiceId.value, formData.value)
      ElMessage.success('服务更新成功')
    } else {
      // 新增服务
      await shopStore.addShopService(formData.value)
      ElMessage.success('服务添加成功')
    }
    
    closeDialog()
  } catch (error) {
    console.error('保存服务失败:', error)
    ElMessage.error(editMode.value ? '服务更新失败' : '服务添加失败')
  } finally {
    loadingText.value = ''
  }
}

// 删除服务
const deleteService = async (serviceId: string, serviceName: string) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除服务「${serviceName}」吗？删除后将无法恢复。`,
      '删除服务',
      {
        confirmButtonText: '确定删除',
        cancelButtonText: '取消',
        type: 'danger'
      }
    )
    
    loadingText.value = serviceId
    await shopStore.deleteShopService(serviceId)
    ElMessage.success('服务删除成功')
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除服务失败:', error)
      ElMessage.error('删除服务失败，请稍后重试')
    }
  } finally {
    loadingText.value = ''
  }
}

// 切换服务状态
const toggleServiceStatus = async (serviceId: string, newStatus: boolean) => {
  try {
    loadingText.value = `${serviceId}_status`
    await shopStore.updateShopService(serviceId, { status: newStatus })
    ElMessage.success(`服务已${newStatus ? '启用' : '停用'}`)
  } catch (error) {
    console.error('更新服务状态失败:', error)
    ElMessage.error('更新状态失败，请稍后重试')
    // 重新获取数据以恢复正确状态
    await fetchServices()
  } finally {
    loadingText.value = ''
  }
}

// 处理图片上传
const handleImageUpload = (uploadFile: any) => {
  // 这里可以实现实际的图片上传逻辑
  // 为了演示，我们直接将文件添加到表单中
  const reader = new FileReader()
  reader.onload = (e) => {
    if (e.target?.result) {
      formData.value.images.push(String(e.target.result))
    }
  }
  reader.readAsDataURL(uploadFile.raw)
  return false // 阻止默认上传
}

// 删除图片
const removeImage = (index: number) => {
  formData.value.images.splice(index, 1)
}
</script>

<template>
  <div class="shop-services-container">
    <div class="page-header">
      <div class="header-left">
        <h1>服务管理</h1>
      </div>
      <div class="header-right">
        <el-button type="primary" @click="openAddDialog">
          <Plus /> 新增服务
        </el-button>
      </div>
    </div>

    <!-- 搜索区域 -->
    <el-card class="search-card">
      <div class="search-content">
        <el-input
          v-model="searchQuery"
          placeholder="搜索服务名称、描述或分类"
          prefix-icon="Search"
          clearable
          class="search-input"
        />
        <el-button type="primary" @click="fetchServices">
          <Search /> 查询
        </el-button>
      </div>
    </el-card>

    <!-- 服务列表 -->
    <el-card class="services-card">
      <div v-if="loading" class="loading-state">
        <el-skeleton :rows="5" animated />
      </div>
      
      <div v-else-if="services.length === 0" class="empty-state">
        <el-empty description="暂无服务项目" />
      </div>
      
      <el-table 
        v-else
        :data="services" 
        style="width: 100%"
        border
        :row-style="{ cursor: 'pointer' }"
      >
        <el-table-column prop="name" label="服务名称" min-width="200">
          <template #default="scope">
            <div class="service-name">
              {{ scope.row.name }}
            </div>
          </template>
        </el-table-column>
        
        <el-table-column prop="description" label="服务描述" min-width="300">
          <template #default="scope">
            <el-tooltip :content="scope.row.description || '无描述'" placement="top">
              <span>{{ scope.row.description || '无描述' }}</span>
            </el-tooltip>
          </template>
        </el-table-column>
        
        <el-table-column prop="price" label="价格" width="100">
          <template #default="scope">
            <span class="price">¥{{ scope.row.price?.toFixed(2) }}</span>
          </template>
        </el-table-column>
        
        <el-table-column prop="duration" label="服务时长" width="120">
          <template #default="scope">
            {{ scope.row.duration }}分钟
          </template>
        </el-table-column>
        
        <el-table-column prop="category" label="分类" width="120">
          <template #default="scope">
            <el-tag size="small">{{ scope.row.category || '未分类' }}</el-tag>
          </template>
        </el-table-column>
        
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-switch
              v-model="scope.row.status"
              active-color="#13ce66"
              inactive-color="#ff4949"
              :active-text="'启用'"
              :inactive-text="'停用'"
              @change="toggleServiceStatus(scope.row.id, $event)"
              :loading="loadingText === `${scope.row.id}_status`"
            />
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="scope">
            <div class="action-buttons">
              <el-button
                type="primary"
                size="small"
                @click="openEditDialog(scope.row)"
                :loading="loadingText === 'saving'"
              >
                <Edit /> 编辑
              </el-button>
              <el-button
                type="danger"
                size="small"
                @click="deleteService(scope.row.id, scope.row.name)"
                :loading="loadingText === scope.row.id"
              >
                <Delete /> 删除
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 服务编辑弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="editMode ? '编辑服务' : '新增服务'"
      width="600px"
      :before-close="closeDialog"
    >
      <el-form label-position="top">
        <el-form-item label="服务名称" required>
          <el-input
            v-model="formData.name"
            placeholder="请输入服务名称"
            maxlength="50"
            show-word-limit
          />
        </el-form-item>
        
        <el-form-item label="服务描述">
          <el-input
            v-model="formData.description"
            placeholder="请输入服务描述"
            type="textarea"
            :rows="3"
            maxlength="200"
            show-word-limit
          />
        </el-form-item>
        
        <div class="form-row">
          <el-form-item label="价格" required class="form-col">
            <el-input-number
              v-model="formData.price"
              :min="0"
              :step="0.01"
              placeholder="0.00"
              :precision="2"
              style="width: 100%"
            />
          </el-form-item>
          
          <el-form-item label="服务时长(分钟)" required class="form-col">
            <el-input-number
              v-model="formData.duration"
              :min="1"
              :step="5"
              placeholder="30"
              style="width: 100%"
            />
          </el-form-item>
        </div>
        
        <el-form-item label="分类">
          <el-input
            v-model="formData.category"
            placeholder="请输入服务分类"
            maxlength="20"
          />
        </el-form-item>
        
        <el-form-item label="服务图片">
          <el-upload
            list-type="picture-card"
            :on-change="handleImageUpload"
            :auto-upload="false"
            accept="image/*"
          >
            <el-icon><Plus /></el-icon>
            <template #tip>
              <div class="el-upload__tip">
                支持上传JPG、PNG格式图片，最多9张
              </div>
            </template>
          </el-upload>
          
          <div class="image-preview-list" v-if="formData.images.length > 0">
            <div
              v-for="(image, index) in formData.images"
              :key="index"
              class="image-preview-item"
            >
              <el-image :src="image" :preview-src-list="formData.images" />
              <el-button
                type="danger"
                size="small"
                icon="Delete"
                @click="removeImage(index)"
                class="image-remove-btn"
              />
            </div>
          </div>
        </el-form-item>
        
        <el-form-item label="服务状态">
          <el-switch
            v-model="formData.status"
            active-color="#13ce66"
            inactive-color="#ff4949"
            :active-text="'启用'"
            :inactive-text="'停用'"
          />
          <div class="status-tip">
            启用后，客户可在预约系统中看到该服务
          </div>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="closeDialog">
            取消
          </el-button>
          <el-button type="primary" @click="saveService" :loading="loadingText === 'saving'">
            {{ editMode ? '更新' : '保存' }}
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.shop-services-container {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.page-header h1 {
  font-size: 24px;
  font-weight: 500;
  color: #303133;
}

.search-card {
  margin-bottom: 20px;
}

.search-content {
  display: flex;
  gap: 15px;
  align-items: center;
}

.search-input {
  max-width: 400px;
}

.services-card {
  overflow-x: auto;
}

.service-name {
  font-weight: 500;
  color: #303133;
}

.price {
  color: #f56c6c;
  font-weight: 500;
  font-size: 16px;
}

.action-buttons {
  display: flex;
  gap: 8px;
}

.loading-state {
  padding: 20px;
}

.empty-state {
  padding: 40px 0;
}

/* 表单样式 */
.form-row {
  display: flex;
  gap: 20px;
}

.form-col {
  flex: 1;
}

.image-preview-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 10px;
}

.image-preview-item {
  position: relative;
  width: 100px;
  height: 100px;
}

.image-remove-btn {
  position: absolute;
  top: -8px;
  right: -8px;
  z-index: 10;
}

.status-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .shop-services-container {
    padding: 10px;
  }
  
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }
  
  .search-content {
    flex-direction: column;
  }
  
  .search-input {
    max-width: 100%;
    width: 100%;
  }
  
  .form-row {
    flex-direction: column;
  }
  
  .el-table {
    font-size: 13px;
  }
}

@media (max-width: 480px) {
  .page-header h1 {
    font-size: 20px;
  }
}
</style>