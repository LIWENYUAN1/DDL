<template>
  <div class="shop-home">
    <!-- 顶部导航 -->
    <el-header class="header">
      <div class="header-content">
        <div class="logo">
          <el-icon><Shop /></el-icon>
          <span>商家管理后台</span>
        </div>
        <div class="user-info">
          <el-dropdown @command="handleCommand">
            <span class="user-dropdown">
              <el-avatar :size="32">
                <el-icon><UserFilled /></el-icon>
              </el-avatar>
              <span class="username">{{ shopName }}</span>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">店铺信息</el-dropdown-item>
                <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </el-header>

    <!-- 主内容区 -->
    <el-container class="main-container">
      <!-- 侧边栏 -->
      <el-aside width="200px" class="sidebar">
        <el-menu
          :default-active="activeMenu"
          class="sidebar-menu"
          @select="handleMenuSelect"
        >
          <el-menu-item index="dashboard">
            <el-icon><DataAnalysis /></el-icon>
            <span>数据看板</span>
          </el-menu-item>
          <el-menu-item index="appointments">
            <el-icon><Calendar /></el-icon>
            <span>预约管理</span>
          </el-menu-item>
          <el-menu-item index="orders">
            <el-icon><DocumentCopy /></el-icon>
            <span>订单管理</span>
          </el-menu-item>
          <el-menu-item index="services">
            <el-icon><Setting /></el-icon>
            <span>服务项目</span>
          </el-menu-item>
          <el-menu-item index="shop-info">
            <el-icon><Shop /></el-icon>
            <span>店铺信息</span>
          </el-menu-item>
        </el-menu>
      </el-aside>

      <!-- 内容区 -->
      <el-main class="content">
        <!-- 数据看板 -->
        <ShopDashboard v-if="activeMenu === 'dashboard'" />

        <!-- 预约管理 -->
        <ShopAppointments v-if="activeMenu === 'appointments'" />

        <!-- 订单管理 -->
        <ShopOrders v-if="activeMenu === 'orders'" />

        <!-- 服务项目 -->
        <ShopServices v-if="activeMenu === 'services'" />

        <!-- 店铺信息 -->
        <ShopInfo v-if="activeMenu === 'shop-info'" />
      </el-main>
    </el-container>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  Shop, UserFilled, DataAnalysis, DocumentCopy, Setting, Calendar
} from '@element-plus/icons-vue'
import ShopDashboard from '@/components/shop/ShopDashboard.vue'
import ShopAppointments from '@/views/shop/ShopAppointmentsView.vue'
import ShopOrders from '@/components/shop/ShopOrders.vue'
import ShopServices from '@/components/shop/ShopServices.vue'
import ShopInfo from '@/components/shop/ShopInfo.vue'

const router = useRouter()

// 店铺信息
const shopName = ref(localStorage.getItem('userInfo') ? JSON.parse(localStorage.getItem('userInfo')!).username : '商家')

// 菜单状态
const activeMenu = ref('dashboard')

// 菜单选择
const handleMenuSelect = (index: string) => {
  activeMenu.value = index
}

// 用户菜单命令
const handleCommand = (command: string) => {
  if (command === 'logout') {
    ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }).then(() => {
      localStorage.clear()
      sessionStorage.clear()
      ElMessage.success('已退出登录')
      router.push('/login')
    })
  } else if (command === 'profile') {
    activeMenu.value = 'shop-info'
  }
}

// 初始化
onMounted(() => {
  // 加载店铺信息
})
</script>

<style scoped>
.shop-home {
  min-height: 100vh;
  background-color: #f5f7fa;
}

.header {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
  color: white;
  padding: 0;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
  padding: 0 20px;
  max-width: 1400px;
  margin: 0 auto;
}

.logo {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 20px;
  font-weight: 600;
}

.logo .el-icon {
  font-size: 28px;
}

.user-dropdown {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 8px 12px;
  border-radius: 20px;
  transition: background-color 0.3s;
}

.user-dropdown:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.username {
  font-size: 14px;
}

.main-container {
  max-width: 1400px;
  margin: 20px auto;
  background-color: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.sidebar {
  background-color: #f8f9fa;
  border-right: 1px solid #e0e0e0;
}

.sidebar-menu {
  border: none;
  background-color: transparent;
}

.content {
  padding: 20px;
}

@media (max-width: 768px) {
  .header-content {
    padding: 0 15px;
  }
  
  .logo span {
    font-size: 16px;
  }
  
  .sidebar {
    display: none;
  }
  
  .content {
    padding: 15px;
  }
}
</style>
