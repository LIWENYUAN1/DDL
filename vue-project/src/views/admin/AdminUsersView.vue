<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { ElMessage, ElTable, ElTableColumn, ElPagination, ElForm, ElFormItem, ElInput, ElButton, ElSelect, ElOption, ElDatePicker, ElDialog, ElSwitch, ElMessageBox } from 'element-plus'
import { Search, Filter, Refresh, Plus, Edit, Delete, User, Star, Calendar, MapPin, Phone, Lock } from '@element-plus/icons-vue'
import type { FormInstance } from 'element-plus'
import { useUserStore } from '@/store/modules/user'

const userStore = useUserStore()

// 表格数据和分页
const users = ref<any[]>([])
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 搜索表单
const searchForm = ref({
  keyword: '',
  status: '',
  role: 'user', // 管理员页面默认查看普通用户
  startTime: '',
  endTime: ''
})

const searchFormRef = ref<FormInstance>()

// 对话框状态
const editDialogVisible = ref(false)
const editingUser = ref({
  id: '',
  username: '',
  nickname: '',
  phone: '',
  email: '',
  status: true,
  avatar: ''
})

// 计算属性
const filteredUsers = computed(() => {
  let result = [...users.value]
  
  // 按状态筛选
  if (searchForm.value.status) {
    result = result.filter(user => 
      searchForm.value.status === 'active' ? user.status : !user.status
    )
  }
  
  // 按关键词筛选
  if (searchForm.value.keyword) {
    const keyword = searchForm.value.keyword.toLowerCase()
    result = result.filter(user => 
      user.username.toLowerCase().includes(keyword) ||
      user.nickname?.toLowerCase().includes(keyword) ||
      user.phone?.includes(keyword) ||
      user.email?.toLowerCase().includes(keyword)
    )
  }
  
  // 按时间范围筛选
  if (searchForm.value.startTime && searchForm.value.endTime) {
    result = result.filter(user => {
      const createTime = new Date(user.createdAt)
      return createTime >= new Date(searchForm.value.startTime) &&
             createTime <= new Date(searchForm.value.endTime)
    })
  }
  
  return result
})

// 生命周期
onMounted(() => {
  loadUsers()
})

// 加载用户列表
const loadUsers = async () => {
  try {
    loading.value = true
    await userStore.getUsersList({
      page: currentPage.value,
      pageSize: pageSize.value,
      role: searchForm.value.role,
      keyword: searchForm.value.keyword,
      status: searchForm.value.status,
      startTime: searchForm.value.startTime,
      endTime: searchForm.value.endTime
    })
    
    users.value = userStore.usersList || []
    total.value = userStore.total || 0
  } catch (error) {
    console.error('加载用户列表失败:', error)
    ElMessage.error('加载用户列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  loadUsers()
}

// 重置搜索
const handleReset = () => {
  searchFormRef.value?.resetFields()
  searchForm.value.role = 'user'
  currentPage.value = 1
  loadUsers()
}

// 刷新
const handleRefresh = () => {
  loadUsers()
}

// 分页变化
const handlePageChange = (page: number) => {
  currentPage.value = page
  loadUsers()
}

// 每页条数变化
const handleSizeChange = (size: number) => {
  pageSize.value = size
  currentPage.value = 1
  loadUsers()
}

// 编辑用户
const handleEditUser = (user: any) => {
  editingUser.value = {
    id: user.id,
    username: user.username,
    nickname: user.nickname || '',
    phone: user.phone || '',
    email: user.email || '',
    status: user.status,
    avatar: user.avatar || ''
  }
  editDialogVisible.value = true
}

// 保存用户信息
const saveUserInfo = async () => {
  try {
    // 表单验证
    if (!editingUser.value.nickname.trim()) {
      ElMessage.warning('请输入用户昵称')
      return
    }
    
    if (editingUser.value.phone) {
      const phoneRegex = /^1[3-9]\d{9}$/
      if (!phoneRegex.test(editingUser.value.phone)) {
        ElMessage.warning('请输入正确的手机号格式')
        return
      }
    }
    
    if (editingUser.value.email) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      if (!emailRegex.test(editingUser.value.email)) {
        ElMessage.warning('请输入正确的邮箱格式')
        return
      }
    }
    
    await userStore.updateUser(editingUser.value)
    
    ElMessage.success('用户信息更新成功')
    editDialogVisible.value = false
    loadUsers()
  } catch (error) {
    console.error('更新用户信息失败:', error)
    ElMessage.error('更新用户信息失败')
  }
}

// 禁用/启用用户
const toggleUserStatus = async (user: any) => {
  try {
    const newStatus = !user.status
    const action = newStatus ? '启用' : '禁用'
    
    await ElMessageBox.confirm(
      `确定要${action}用户「${user.username}」吗？`,
      '操作确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    await userStore.updateUserStatus(user.id, newStatus)
    
    ElMessage.success(`用户${action}成功`)
    loadUsers()
  } catch (error) {
    // 用户取消操作时不显示错误
    if (error !== 'cancel') {
      console.error(`${user.status ? '禁用' : '启用'}用户失败:`, error)
      ElMessage.error(`${user.status ? '禁用' : '启用'}用户失败`)
    }
  }
}

// 删除用户
const deleteUser = async (user: any) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除用户「${user.username}」吗？此操作不可恢复！`,
      '删除确认',
      {
        confirmButtonText: '确定删除',
        cancelButtonText: '取消',
        type: 'error'
      }
    )
    
    await userStore.deleteUser(user.id)
    
    ElMessage.success('用户删除成功')
    loadUsers()
  } catch (error) {
    // 用户取消操作时不显示错误
    if (error !== 'cancel') {
      console.error('删除用户失败:', error)
      ElMessage.error('删除用户失败')
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
  <div class="admin-users-container">
    <div class="page-header">
      <h1>用户管理</h1>
    </div>

    <el-card class="filter-card">
      <el-form ref="searchFormRef" :model="searchForm" :inline="true" size="small">
        <el-form-item label="关键字搜索">
          <el-input
            v-model="searchForm.keyword"
            placeholder="用户名/昵称/手机号/邮箱"
            prefix-icon="Search"
            clearable
          />
        </el-form-item>
        
        <el-form-item label="用户状态">
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
        <span class="table-title">用户列表</span>
        <div class="table-actions">
          <el-button type="primary" @click="loadUsers">
            <Refresh /> 刷新列表
          </el-button>
        </div>
      </div>
      
      <el-table
        v-loading="loading"
        :data="filteredUsers"
        stripe
        border
        style="width: 100%"
      >
        <el-table-column prop="id" label="用户ID" width="80" />
        
        <el-table-column prop="username" label="用户名" min-width="120">
          <template #default="{ row }">
            <div class="user-info">
              <el-image
                v-if="row.avatar"
                :src="row.avatar"
                class="avatar"
                fit="cover"
              />
              <div v-else class="avatar-placeholder">
                <User />
              </div>
              <span class="username">{{ row.username }}</span>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column prop="nickname" label="昵称" min-width="100" />
        
        <el-table-column prop="phone" label="手机号" min-width="120">
          <template #default="{ row }">
            <el-tooltip :content="row.phone || '未设置'" placement="top">
              <div>{{ row.phone || '-' }}</div>
            </el-tooltip>
          </template>
        </el-table-column>
        
        <el-table-column prop="email" label="邮箱" min-width="150">
          <template #default="{ row }">
            <el-tooltip :content="row.email || '未设置'" placement="top">
              <div>{{ row.email || '-' }}</div>
            </el-tooltip>
          </template>
        </el-table-column>
        
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
        
        <el-table-column prop="lastLoginAt" label="最后登录" min-width="160">
          <template #default="{ row }">
            {{ formatDate(row.lastLoginAt) }}
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="{ row }">
            <el-button 
              type="primary" 
              size="small" 
              @click="handleEditUser(row)"
            >
              <Edit /> 编辑
            </el-button>
            <el-switch
              v-model="row.status"
              active-text="启用"
              inactive-text="禁用"
              @change="() => toggleUserStatus(row)"
              style="margin-left: 10px"
            />
            <el-button 
              type="danger" 
              size="small" 
              @click="deleteUser(row)"
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

    <!-- 编辑用户对话框 -->
    <el-dialog
      v-model="editDialogVisible"
      title="编辑用户信息"
      width="500px"
      destroy-on-close
    >
      <el-form :model="editingUser" label-width="100px">
        <el-form-item label="用户ID" disabled>
          <el-input v-model="editingUser.id" />
        </el-form-item>
        
        <el-form-item label="用户名" disabled>
          <el-input v-model="editingUser.username" />
        </el-form-item>
        
        <el-form-item label="昵称" required>
          <el-input v-model="editingUser.nickname" placeholder="请输入昵称" />
        </el-form-item>
        
        <el-form-item label="手机号">
          <el-input v-model="editingUser.phone" placeholder="请输入手机号" />
        </el-form-item>
        
        <el-form-item label="邮箱">
          <el-input v-model="editingUser.email" placeholder="请输入邮箱" />
        </el-form-item>
        
        <el-form-item label="状态">
          <el-switch v-model="editingUser.status" />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="editDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveUserInfo">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped>
.admin-users-container {
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

/* 用户信息样式 */
.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
}

.avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
}

.avatar-placeholder {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background-color: #f0f2f5;
  display: flex;
  justify-content: center;
  align-items: center;
  color: #909399;
}

.username {
  font-weight: 500;
  color: #303133;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .admin-users-container {
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