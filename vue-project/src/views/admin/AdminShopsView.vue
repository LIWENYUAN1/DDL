<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { ElMessage, ElTable, ElTableColumn, ElPagination, ElForm, ElFormItem, ElInput, ElButton, ElSelect, ElOption, ElDatePicker, ElDialog, ElSwitch, ElMessageBox, ElRate } from 'element-plus'
import { Search, Filter, Refresh, Plus, Edit, Delete, Business, Star, Calendar, MapPin, Phone, Check } from '@element-plus/icons-vue'
import type { FormInstance } from 'element-plus'
import { useShopStore } from '@/store/modules/shop'

const shopStore = useShopStore()

// 表格数据和分页
const shops = ref<any[]>([])
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 搜索表单
const searchForm = ref({
  keyword: '',
  status: '',
  startTime: '',
  endTime: ''
})

const searchFormRef = ref<FormInstance>()

// 对话框状态
const editDialogVisible = ref(false)
const editingShop = ref({
  id: '',
  shopName: '',
  phone: '',
  address: '',
  description: '',
  status: true,
  logo: '',
  coverImage: '',
  businessHours: '',
  rating: 0,
  reviewCount: 0
})

// 计算属性
const filteredShops = computed(() => {
  let result = [...shops.value]
  
  // 按状态筛选
  if (searchForm.value.status) {
    result = result.filter(shop => 
      searchForm.value.status === 'active' ? shop.status : !shop.status
    )
  }
  
  // 按关键词筛选
  if (searchForm.value.keyword) {
    const keyword = searchForm.value.keyword.toLowerCase()
    result = result.filter(shop => 
      shop.shopName.toLowerCase().includes(keyword) ||
      shop.phone?.includes(keyword) ||
      shop.address?.toLowerCase().includes(keyword)
    )
  }
  
  // 按时间范围筛选
  if (searchForm.value.startTime && searchForm.value.endTime) {
    result = result.filter(shop => {
      const createTime = new Date(shop.createdAt)
      return createTime >= new Date(searchForm.value.startTime) &&
             createTime <= new Date(searchForm.value.endTime)
    })
  }
  
  return result
})

// 生命周期
onMounted(() => {
  loadShops()
})

// 加载商家列表
const loadShops = async () => {
  try {
    loading.value = true
    await shopStore.getShopsList({
      page: currentPage.value,
      pageSize: pageSize.value,
      keyword: searchForm.value.keyword,
      status: searchForm.value.status,
      startTime: searchForm.value.startTime,
      endTime: searchForm.value.endTime
    })
    
    shops.value = shopStore.shopsList || []
    total.value = shopStore.total || 0
  } catch (error) {
    console.error('加载商家列表失败:', error)
    ElMessage.error('加载商家列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  loadShops()
}

// 重置搜索
const handleReset = () => {
  searchFormRef.value?.resetFields()
  currentPage.value = 1
  loadShops()
}

// 刷新
const handleRefresh = () => {
  loadShops()
}

// 分页变化
const handlePageChange = (page: number) => {
  currentPage.value = page
  loadShops()
}

// 每页条数变化
const handleSizeChange = (size: number) => {
  pageSize.value = size
  currentPage.value = 1
  loadShops()
}

// 编辑商家信息
const handleEditShop = (shop: any) => {
  editingShop.value = {
    id: shop.id,
    shopName: shop.shopName,
    phone: shop.phone || '',
    address: shop.address || '',
    description: shop.description || '',
    status: shop.status,
    logo: shop.logo || '',
    coverImage: shop.coverImage || '',
    businessHours: shop.businessHours || '',
    rating: shop.rating || 0,
    reviewCount: shop.reviewCount || 0
  }
  editDialogVisible.value = true
}

// 保存商家信息
const saveShopInfo = async () => {
  try {
    // 表单验证
    if (!editingShop.value.shopName.trim()) {
      ElMessage.warning('请输入店铺名称')
      return
    }
    
    if (!editingShop.value.phone.trim()) {
      ElMessage.warning('请输入店铺电话')
      return
    }
    
    if (!editingShop.value.address.trim()) {
      ElMessage.warning('请输入店铺地址')
      return
    }
    
    // 手机号格式验证
    const phoneRegex = /^1[3-9]\d{9}$/
    if (!phoneRegex.test(editingShop.value.phone)) {
      ElMessage.warning('请输入正确的手机号格式')
      return
    }
    
    await shopStore.updateShop(editingShop.value)
    
    ElMessage.success('商家信息更新成功')
    editDialogVisible.value = false
    loadShops()
  } catch (error) {
    console.error('更新商家信息失败:', error)
    ElMessage.error('更新商家信息失败')
  }
}

// 禁用/启用商家
const toggleShopStatus = async (shop: any) => {
  try {
    const newStatus = !shop.status
    const action = newStatus ? '启用' : '禁用'
    
    await ElMessageBox.confirm(
      `确定要${action}商家「${shop.shopName}」吗？`,
      '操作确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    await shopStore.updateShopStatus(shop.id, newStatus)
    
    ElMessage.success(`商家${action}成功`)
    loadShops()
  } catch (error) {
    // 用户取消操作时不显示错误
    if (error !== 'cancel') {
      console.error(`${shop.status ? '禁用' : '启用'}商家失败:`, error)
      ElMessage.error(`${shop.status ? '禁用' : '启用'}商家失败`)
    }
  }
}

// 删除商家
const deleteShop = async (shop: any) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除商家「${shop.shopName}」吗？此操作不可恢复！`,
      '删除确认',
      {
        confirmButtonText: '确定删除',
        cancelButtonText: '取消',
        type: 'error'
      }
    )
    
    await shopStore.deleteShop(shop.id)
    
    ElMessage.success('商家删除成功')
    loadShops()
  } catch (error) {
    // 用户取消操作时不显示错误
    if (error !== 'cancel') {
      console.error('删除商家失败:', error)
      ElMessage.error('删除商家失败')
    }
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
    minute: '2-digit'
  })
}

// 格式化状态
const formatStatus = (status: boolean) => {
  return status ? '正常' : '禁用'
}

// 格式化状态样式
const statusStyle = (status: boolean) => {
  return {
    color: status ? '#67C23A' : '#909399',
    backgroundColor: status ? '#F0F9EB' : '#F4F4F5'
  }
}
</script>

<template>
  <div class="admin-shops-container">
    <div class="page-header">
      <h1>商家管理</h1>
    </div>

    <el-card class="filter-card">
      <el-form ref="searchFormRef" :model="searchForm" :inline="true" size="small">
        <el-form-item label="关键字搜索">
          <el-input
            v-model="searchForm.keyword"
            placeholder="店铺名称/电话/地址"
            prefix-icon="Search"
            clearable
          />
        </el-form-item>
        
        <el-form-item label="商家状态">
          <el-select v-model="searchForm.status" placeholder="全部" clearable>
            <el-option label="正常" value="active" />
            <el-option label="禁用" value="inactive" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="注册时间">
          <el-date-picker
            v-model="[searchForm.startTime, searchForm.endTime]"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <Search /> 搜索
          </el-button>
          <el-button @click="handleReset">
            <Refresh /> 重置
          </el-button>
          <el-button @click="handleRefresh">
            <Refresh /> 刷新
          </el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-card class="table-card">
      <div class="table-header">
        <span class="table-title">商家列表</span>
        <div class="table-actions">
          <el-button type="primary" @click="loadShops">
            <Refresh /> 刷新列表
          </el-button>
        </div>
      </div>
      
      <el-table
        v-loading="loading"
        :data="filteredShops"
        stripe
        border
        style="width: 100%"
      >
        <el-table-column prop="id" label="商家ID" width="80" />
        
        <el-table-column prop="shopName" label="店铺名称" min-width="180">
          <template #default="{ row }">
            <div class="shop-info">
              <el-image
                v-if="row.logo"
                :src="row.logo"
                class="logo"
                fit="cover"
              />
              <div v-else class="logo-placeholder">
                <Business />
              </div>
              <span class="shop-name">{{ row.shopName }}</span>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column prop="phone" label="联系电话" min-width="120">
          <template #default="{ row }">
            <el-tooltip :content="row.phone || '未设置'" placement="top">
              <div>{{ row.phone || '-' }}</div>
            </el-tooltip>
          </template>
        </el-table-column>
        
        <el-table-column prop="address" label="店铺地址" min-width="200">
          <template #default="{ row }">
            <el-tooltip :content="row.address || '未设置'" placement="top">
              <div class="address-text">{{ row.address || '-' }}</div>
            </el-tooltip>
          </template>
        </el-table-column>
        
        <el-table-column prop="rating" label="评分" width="100">
          <template #default="{ row }">
            <div class="rating-info">
              <el-rate v-model="row.rating" disabled show-score />
            </div>
          </template>
        </el-table-column>
        
        <el-table-column prop="reviewCount" label="评价数" width="100" />
        
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :style="statusStyle(row.status)">
              {{ formatStatus(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column prop="createdAt" label="注册时间" min-width="160">
          <template #default="{ row }">
            {{ formatDate(row.createdAt) }}
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="220" fixed="right">
          <template #default="{ row }">
            <el-button 
              type="primary" 
              size="small" 
              @click="handleEditShop(row)"
            >
              <Edit /> 编辑
            </el-button>
            <el-switch
              v-model="row.status"
              active-text="启用"
              inactive-text="禁用"
              @change="() => toggleShopStatus(row)"
              style="margin-left: 10px"
            />
            <el-button 
              type="danger" 
              size="small" 
              @click="deleteShop(row)"
              style="margin-left: 10px"
            >
              <Delete /> 删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>

    <!-- 编辑商家对话框 -->
    <el-dialog
      v-model="editDialogVisible"
      title="编辑商家信息"
      width="600px"
      destroy-on-close
    >
      <el-form :model="editingShop" label-width="120px">
        <el-form-item label="商家ID" disabled>
          <el-input v-model="editingShop.id" />
        </el-form-item>
        
        <el-form-item label="店铺名称" required>
          <el-input v-model="editingShop.shopName" placeholder="请输入店铺名称" />
        </el-form-item>
        
        <el-form-item label="联系电话" required>
          <el-input v-model="editingShop.phone" placeholder="请输入联系电话" />
        </el-form-item>
        
        <el-form-item label="店铺地址" required>
          <el-input v-model="editingShop.address" placeholder="请输入店铺地址" />
        </el-form-item>
        
        <el-form-item label="营业时间">
          <el-input v-model="editingShop.businessHours" placeholder="如：周一至周日 09:00-21:00" />
        </el-form-item>
        
        <el-form-item label="店铺介绍">
          <el-input 
            v-model="editingShop.description" 
            type="textarea" 
            :rows="3" 
            placeholder="请输入店铺介绍" 
          />
        </el-form-item>
        
        <el-form-item label="店铺状态">
          <el-switch v-model="editingShop.status" />
        </el-form-item>
        
        <el-form-item label="店铺评分" disabled>
          <div class="disabled-rating">
            <el-rate v-model="editingShop.rating" disabled show-score />
            <span class="review-info">({{ editingShop.reviewCount }}条评价)</span>
          </div>
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="editDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveShopInfo">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.admin-shops-container {
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

.filter-card {
  margin-bottom: 20px;
}

.table-card {
  background-color: #ffffff;
}

.table-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.table-title {
  font-size: 16px;
  font-weight: 500;
  color: #303133;
}

.table-actions {
  display: flex;
  gap: 10px;
}

/* 商家信息样式 */
.shop-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.logo {
  width: 40px;
  height: 40px;
  border-radius: 8px;
}

.logo-placeholder {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  background-color: #f0f2f5;
  display: flex;
  justify-content: center;
  align-items: center;
  color: #909399;
}

.shop-name {
  font-weight: 500;
  color: #303133;
}

.address-text {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100%;
}

.rating-info {
  display: flex;
  align-items: center;
}

.disabled-rating {
  display: flex;
  align-items: center;
  gap: 10px;
}

.review-info {
  font-size: 14px;
  color: #909399;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .admin-shops-container {
    padding: 10px;
  }
  
  .table-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .pagination-container {
    justify-content: center;
  }
}

@media (max-width: 480px) {
  .page-header h1 {
    font-size: 20px;
  }
  
  .el-form--inline .el-form-item {
    margin-right: 0;
    margin-bottom: 10px;
  }
}
</style>