<template>
  <div class="admin-home">
    <el-container class="admin-container">
      <!-- 侧边栏 -->
      <el-aside width="200px" class="sidebar">
        <div class="logo">管理后台</div>
        <el-menu :default-active="activeMenu" @select="handleMenuSelect">
          <el-menu-item index="dashboard"><el-icon><DataLine /></el-icon><span>数据统计</span></el-menu-item>
          <el-menu-item index="users"><el-icon><User /></el-icon><span>用户管理</span></el-menu-item>
          <el-menu-item index="shops"><el-icon><Shop /></el-icon><span>商家管理</span></el-menu-item>
          <el-menu-item index="orders"><el-icon><Document /></el-icon><span>订单管理</span></el-menu-item>
        </el-menu>
      </el-aside>

      <!-- 主内容区 -->
      <el-container>
        <!-- 顶部导航 -->
        <el-header class="header">
          <span class="title">{{ menuTitle }}</span>
          <el-dropdown @command="handleCommand">
            <span class="user-info">
              <el-avatar :size="32"><el-icon><UserFilled /></el-icon></el-avatar>
              <span>{{ userName }}</span>
        </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
      </template>
          </el-dropdown>
        </el-header>

        <!-- 内容 -->
        <el-main class="content">
          <AdminDashboard v-if="activeMenu === 'dashboard'" />
          <AdminUsers v-if="activeMenu === 'users'" />
          <AdminShops v-if="activeMenu === 'shops'" />
          <AdminOrders v-if="activeMenu === 'orders'" />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { DataLine, User, Shop, Document, UserFilled } from '@element-plus/icons-vue'
import AdminDashboard from '@/components/admin/AdminDashboard.vue'
import AdminUsers from '@/components/admin/AdminUsers.vue'
import AdminShops from '@/components/admin/AdminShops.vue'
import AdminOrders from '@/components/admin/AdminOrders.vue'

const router = useRouter()
const activeMenu = ref('dashboard')
const userName = ref('管理员')

const menuTitle = computed(() => {
  const titles: Record<string, string> = {
    dashboard: '数据统计',
    users: '用户管理',
    shops: '商家管理',
    orders: '订单管理'
  }
  return titles[activeMenu.value] || ''
})

const handleMenuSelect = (index: string) => { activeMenu.value = index }
const handleCommand = (command: string) => {
  if (command === 'logout') {
    ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      localStorage.clear()
      ElMessage.success('已退出登录')
      router.push('/login')
    })
  }
}
</script>

<style scoped>
.admin-home { height: 100vh; }
.admin-container { height: 100%; }
.sidebar { background: #001529; }
.logo { color: white; padding: 20px; font-size: 20px; font-weight: 600; text-align: center; }
.sidebar .el-menu { background: #001529; border: none; }
.sidebar :deep(.el-menu-item) { color: rgba(255,255,255,0.65); }
.sidebar :deep(.el-menu-item:hover),
.sidebar :deep(.el-menu-item.is-active) { color: white; background: #1890ff; }
.header { background: white; box-shadow: 0 1px 4px rgba(0,21,41,.08); display: flex; justify-content: space-between; align-items: center; }
.title { font-size: 18px; font-weight: 600; }
.user-info { display: flex; align-items: center; gap: 8px; cursor: pointer; }
.content { background: #f0f2f5; padding: 20px; }
</style>
