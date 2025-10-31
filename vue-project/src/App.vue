<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
// import { ElMessage } from 'element-plus'
// import { useUserStore } from '@/store/modules/user'
// import { useShopStore } from '@/store/modules/shop'
// import { User, Shop, Setting, Logout, Menu, X, HomeFilled, UserFilled, Calendar, Star, Award, BarChart, Users, Package, AlertCircle, ArrowDown, ArrowLeft, ArrowRight } from '@element-plus/icons-vue'

// 路由和状态
const router = useRouter()
const route = useRoute()
// 暂时移除对 store 的依赖
// const userStore = useUserStore()
// const shopStore = useShopStore()

// 界面状态
const isCollapse = ref(false)
const isMobileMenuOpen = ref(false)
const currentRole = ref('')

// 定义用户信息接口
interface UserInfo {
  username: string;
  token: string;
  role: 'user' | 'shop' | 'admin';
  [key: string]: any;
}

// 从localStorage读取用户信息，恢复登录状态
const userInfo = ref<UserInfo | null>(null)

// 初始化函数，从localStorage获取用户信息
const initUserInfo = () => {
  const storedUserInfo = localStorage.getItem('userInfo') || sessionStorage.getItem('userInfo')
  if (storedUserInfo) {
    try {
      userInfo.value = JSON.parse(storedUserInfo)
    } catch (e) {
      console.error('解析用户信息失败:', e)
    }
  }
}

// 立即执行初始化
initUserInfo()

// 根据localStorage中的用户信息计算登录状态
const isLoggedIn = computed(() => {
  return !!userInfo.value && !!userInfo.value?.token
})

const isUser = computed(() => {
  return isLoggedIn.value && userInfo.value?.role === 'user'
})

const isShop = computed(() => {
  return isLoggedIn.value && userInfo.value?.role === 'shop'
})

const isAdmin = computed(() => {
  return isLoggedIn.value && userInfo.value?.role === 'admin'
})

const currentUser = computed(() => {
  return isLoggedIn.value ? userInfo.value?.username : '访客'
})

const sidebarMenus = computed(() => {
  // 用户端菜单
  const userMenus = [
    {
      path: '/user/home',
      name: '首页',
      icon: 'home', // 替换为简单字符串
      active: ['/user/home']
    },
    {
      path: '/user/appointments',
      name: '我的预约',
      icon: 'calendar',
      active: ['/user/appointments']
    },
    {
      path: '/user/favorites',
      name: '我的收藏',
      icon: 'star',
      active: ['/user/favorites']
    },
    {
      path: '/user/ratings',
      name: '我的评价',
      icon: 'star-filled',
      active: ['/user/ratings']
    },
    {
      path: '/user/profile',
      name: '个人中心',
      icon: 'user',
      active: ['/user/profile']
    }
  ]

  // 商家端菜单
  const shopMenus = [
    {
      path: '/shop/home',
      name: '工作台',
      icon: 'home',
      active: ['/shop/home']
    },
    {
      path: '/shop/appointments',
      name: '预约管理',
      icon: 'calendar',
      active: ['/shop/appointments']
    },
    {
      path: '/shop/services',
      name: '服务管理',
      icon: 'package',
      active: ['/shop/services']
    },
    {
      path: '/shop/ratings',
      name: '客户评价',
      icon: 'star',
      active: ['/shop/ratings']
    },
    {
      path: '/shop/statistics',
      name: '经营统计',
      icon: 'barchart',
      active: ['/shop/statistics']
    },
    {
      path: '/shop/profile',
      name: '商家信息',
      icon: 'shop',
      active: ['/shop/profile']
    }
  ]

  // 管理员端菜单
  const adminMenus = [
    {
      path: '/admin/home',
      name: '控制台',
      icon: 'home',
      active: ['/admin/home']
    },
    {
      path: '/admin/users',
      name: '用户管理',
      icon: 'users',
      active: ['/admin/users']
    },
    {
      path: '/admin/shops',
      name: '商家管理',
      icon: 'shop',
      active: ['/admin/shops']
    },
    {
      path: '/admin/appointments',
      name: '预约审核',
      icon: 'calendar',
      active: ['/admin/appointments']
    },
    {
      path: '/admin/ratings',
      name: '评价管理',
      icon: 'star',
      active: ['/admin/ratings']
    },
    {
      path: '/admin/categories',
      name: '分类管理',
      icon: 'package',
      active: ['/admin/categories']
    },
    {
      path: '/admin/settings',
      name: '系统设置',
      icon: 'setting',
      active: ['/admin/settings']
    }
  ]

  if (isAdmin.value) return adminMenus
  if (isShop.value) return shopMenus
  if (isUser.value) return userMenus
  return []
})

// 生命周期 - 暂时简化，移除对 store 的依赖
// import { onMounted, watch } from 'vue'
// onMounted(() => {
//   // 检查登录状态
//   // checkLoginStatus()
//   // 监听窗口大小变化
//   window.addEventListener('resize', handleResize)
// })

// // 监听路由变化
// watch(() => route.path, (newPath) => {
//   updateCurrentRole(newPath)
// })

// // 检查登录状态
// const checkLoginStatus = async () => {
//   try {
//     // 尝试恢复登录状态
//     // if (userStore.hasToken) {
//     //   await userStore.getUserInfo()
//     // }
//     // if (shopStore.hasToken) {
//     //   await shopStore.getShopInfo()
//     // }
//   } catch (error) {
//     console.error('恢复登录状态失败:', error)
//     // 清除无效的token
//     // if (userStore.hasToken) await userStore.logout()
//     // if (shopStore.hasToken) await shopStore.logout()
//   }
// }

// 更新当前角色
const updateCurrentRole = (path: string) => {
  if (path.startsWith('/user/')) {
    currentRole.value = 'user'
  } else if (path.startsWith('/shop/')) {
    currentRole.value = 'shop'
  } else if (path.startsWith('/admin/')) {
    currentRole.value = 'admin'
  } else {
    currentRole.value = 'guest'
  }
}

// 处理窗口大小变化
const handleResize = () => {
  if (window.innerWidth > 768) {
    isMobileMenuOpen.value = false
  }
}

// 切换侧边栏
const toggleSidebar = () => {
  isCollapse.value = !isCollapse.value
}

// 切换移动端菜单
const toggleMobileMenu = () => {
  isMobileMenuOpen.value = !isMobileMenuOpen.value
}

// 导航到指定路由
const navigateTo = (path: string) => {
  router.push(path)
  isMobileMenuOpen.value = false
}

// 切换到用户端
const switchToUser = () => {
  navigateTo('/user/home')
}

// 切换到商家端
const switchToShop = () => {
  navigateTo('/shop/home')
}

// 退出登录 - 暂时简化，移除对 store 的依赖
const logout = async () => {
  try {
    // if (userStore.hasToken) {
    //   await userStore.logout()
    // }
    // if (shopStore.hasToken) {
    //   await shopStore.logout()
    // }
    // ElMessage.success('退出登录成功')
    console.log('退出登录功能暂时禁用，需要安装 pinia 和 element-plus 依赖')
  } catch (error) {
    console.error('退出登录失败:', error)
  } finally {
    // 无论如何都导航到首页
    router.push('/')
  }
}

// 处理角色切换
const handleRoleChange = () => {
  if (currentRole.value === 'user') {
    navigateTo('/user/home')
  } else if (currentRole.value === 'shop') {
    navigateTo('/shop/home')
  } else if (currentRole.value === 'admin') {
    navigateTo('/admin/home')
  }
}
</script>

<template>
  <div class="app-container">
    <!-- 顶部导航栏（首页、登录、注册页不显示） -->
    <header class="header" v-if="!['/', '/login', '/register', '/login-choice', '/shop/login', '/shop/register', '/admin/login'].includes(route.path)">
      <div class="header-content">
        <!-- 左侧菜单按钮和Logo -->
        <div class="header-left">
          <button 
            class="menu-button"
            @click="toggleMobileMenu"
          >
            ☰
          </button>
          <div class="logo" @click="navigateTo('/')">
            <span class="logo-text">摩托车服务平台</span>
          </div>
          
          <!-- 导航切换（仅在登录后显示） -->
          <div class="nav-switch" v-if="isLoggedIn">
            <div class="role-tabs">
              <button 
                class="role-tab" 
                :class="{ active: currentRole === 'user' }"
                @click="switchToUser"
              >
                用户中心
              </button>
              <button 
                class="role-tab" 
                :class="{ active: currentRole === 'shop' }"
                v-if="false"
                @click="switchToShop"
              >
                商家中心
              </button>
              <button 
                class="role-tab" 
                :class="{ active: currentRole === 'admin' }"
                v-if="isAdmin"
                @click="navigateTo('/admin/home')"
              >
                管理中心
              </button>
            </div>
          </div>
        </div>
        
        <!-- 右侧用户信息 -->
        <div class="header-right">
          <div v-if="isLoggedIn" class="user-info">
            <!-- 简化的用户信息显示 -->
            <div class="user-menu">
              <span class="user-name">{{ currentUser }}</span>
              <div class="dropdown-menu">
                <div class="dropdown-item" @click="navigateTo(isUser ? '/user/profile' : (isShop ? '/shop/profile' : '/'))">
                  个人信息
                </div>
                <div class="dropdown-item" @click="logout">
                  退出登录
                </div>
              </div>
            </div>
          </div>
          <div v-else class="guest-info">
            <button class="btn-text" @click="navigateTo('/login')">登录</button>
            <button class="btn-primary-small" @click="navigateTo('/register')">注册</button>
          </div>
        </div>
      </div>
    </header>

    <!-- 主内容区 -->
    <div class="main-container">
      <!-- 侧边栏 -->
      <aside 
          :class="['sidebar', { collapsed: isCollapse, mobileOpen: isMobileMenuOpen }]"
          v-if="isLoggedIn && sidebarMenus.length > 0"
        >
        <div class="sidebar-header" v-if="!isCollapse">
          <h3>{{ isUser ? '用户中心' : (isShop ? '商家中心' : '管理中心') }}</h3>
        </div>
        <nav class="sidebar-nav">
          <ul class="nav-list">
            <li 
              v-for="menu in sidebarMenus" 
              :key="menu.path"
              :class="['nav-item', { active: menu.active.includes(route.path) }]"
              @click="navigateTo(menu.path)"
            >
              <!-- 使用简单的图标文本代替 -->
              <div class="nav-icon">
                {{ menu.icon === 'home' ? '🏠' : 
                   menu.icon === 'calendar' ? '📅' : 
                   menu.icon === 'star' ? '⭐' : 
                   menu.icon === 'star-filled' ? '🌟' : 
                   menu.icon === 'user' ? '👤' : 
                   menu.icon === 'package' ? '📦' : 
                   menu.icon === 'barchart' ? '📊' : 
                   menu.icon === 'shop' ? '🏪' : 
                   menu.icon === 'users' ? '👥' : 
                   menu.icon === 'setting' ? '⚙️' : 
                   '•' }}
              </div>
              <div class="nav-text" v-if="!isCollapse">{{ menu.name }}</div>
            </li>
          </ul>
        </nav>
        <div class="sidebar-footer" @click="toggleSidebar">
          <span v-if="!isCollapse">◀</span>
          <span v-else>▶</span>
        </div>
      </aside>

      <!-- 遮罩层（移动端） -->
      <div 
        class="sidebar-mask"
        v-if="isMobileMenuOpen"
        @click="isMobileMenuOpen = false"
      ></div>

      <!-- 内容区域 -->
      <main 
        class="content"
        :class="{ 
          'sidebar-open': isLoggedIn && !isCollapse && !isMobileMenuOpen,
          'sidebar-collapsed': isLoggedIn && isCollapse && !isMobileMenuOpen
        }"
      >
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </main>
    </div>
  </div>
</template>

<style>
/* 全局样式重置 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

/* body 样式移到各个页面组件中控制 */
body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  /* 移除固定背景色，让各个页面组件自己控制 */
  /* background-color: #f5f7fa; */
  color: #303133;
}

/* 应用容器 */
.app-container {
  display: flex;
  flex-direction: column;
  height: 100vh;
  overflow: hidden;
}

/* 头部样式 */
.header {
  background-color: #ffffff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  height: 60px;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 20px;
}

.menu-button {
  display: none;
  padding: 8px 12px;
  background: none;
  border: none;
  font-size: 20px;
  cursor: pointer;
}

.btn-text {
  padding: 6px 12px;
  background: none;
  border: none;
  color: #333;
  cursor: pointer;
}

.btn-text:hover {
  color: #409eff;
}

.btn-primary-small {
  padding: 4px 12px;
  background-color: #409eff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
}

.btn-primary-small:hover {
  background-color: #66b1ff;
}

/* 用户菜单样式 */
.user-menu {
  position: relative;
  display: inline-block;
  cursor: pointer;
}

.user-name {
  padding: 6px 12px;
  display: inline-block;
}

.dropdown-menu {
  position: absolute;
  top: 100%;
  right: 0;
  background: white;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  min-width: 120px;
  z-index: 1000;
  display: none;
}

.user-menu:hover .dropdown-menu {
  display: block;
}

.dropdown-item {
  padding: 8px 16px;
  cursor: pointer;
  white-space: nowrap;
}

.dropdown-item:hover {
  background-color: #f5f7fa;
}

.logo {
  cursor: pointer;
}

.logo-text {
  font-size: 20px;
  font-weight: bold;
  color: #fff;
}

/* 角色切换标签样式 */
.role-tabs {
  display: flex;
  gap: 4px;
  margin-left: 20px;
}

.role-tab {
  padding: 6px 16px;
  border: 1px solid #409eff;
  background-color: transparent;
  color: #409eff;
  cursor: pointer;
  border-radius: 4px;
  font-size: 14px;
  transition: all 0.3s;
}

.role-tab:hover {
  background-color: #ecf5ff;
}

.role-tab.active {
  background-color: #409eff;
  color: #fff;
}

/* 导航图标样式优化 */
.nav-icon {
  font-size: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
}

.nav-switch {
  margin-left: 30px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 15px;
}

.user-info {
  cursor: pointer;
}

.el-dropdown-link {
  display: flex;
  align-items: center;
  gap: 5px;
  color: #606266;
}

/* 主内容区 */
.main-container {
  display: flex;
  flex: 1;
  overflow: hidden;
}

/* 侧边栏 */
.sidebar {
  width: 240px;
  background-color: #ffffff;
  box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
  transition: all 0.3s ease;
  z-index: 99;
}

.sidebar.collapsed {
  width: 60px;
}

.sidebar.mobileOpen {
    position: fixed;
    left: 0;
    top: 60px;
    height: calc(100vh - 60px);
  }

.sidebar-header {
  padding: 20px;
  border-bottom: 1px solid #ebeef5;
}

.sidebar-header h3 {
  margin: 0;
  font-size: 16px;
  color: #303133;
}

.sidebar-nav {
  flex: 1;
  padding: 20px 0;
  overflow-y: auto;
}

.nav-list {
  list-style: none;
}

.nav-item {
  display: flex;
  align-items: center;
  padding: 12px 20px;
  cursor: pointer;
  transition: all 0.3s ease;
  color: #606266;
}

.nav-item:hover {
  background-color: #ecf5ff;
  color: #409eff;
}

.nav-item.active {
  background-color: #ecf5ff;
  color: #409eff;
  border-right: 3px solid #409eff;
}

.nav-icon {
  font-size: 18px;
  margin-right: 10px;
}

.nav-text {
  font-size: 14px;
}

.sidebar-footer {
  padding: 15px 0;
  text-align: center;
  cursor: pointer;
  color: #909399;
  transition: all 0.3s ease;
}

.sidebar-footer:hover {
  color: #409eff;
  background-color: #f5f7fa;
}

/* 遮罩层 */
.sidebar-mask {
  position: fixed;
  top: 60px;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 98;
}

/* 内容区域 */
.content {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  transition: margin-left 0.3s ease;
  background-color: #f5f7fa;
}

.content.sidebar-open {
  margin-left: 0;
}

.content.sidebar-collapsed {
  margin-left: 0;
}

/* 过渡动画 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .header-content {
    padding: 0 15px;
  }
  
  .menu-button {
    display: block;
  }
  
  .nav-switch {
    display: none;
  }
  
  .sidebar {
    position: fixed;
    left: -240px;
    top: 60px;
    height: calc(100vh - 60px);
  }
  
  .sidebar.collapsed {
    left: -60px;
    width: 60px;
  }
  
  .content {
    padding: 10px;
    margin-left: 0;
  }
}

/* 小屏幕适配 */
@media (max-width: 480px) {
  .header-content {
    padding: 0 10px;
  }
  
  .logo-text {
    font-size: 16px;
  }
  
  .header-right {
    gap: 10px;
  }
}

/* 中等屏幕适配 */
@media (min-width: 769px) and (max-width: 1024px) {
  .nav-switch {
    margin-left: 15px;
  }
  
  .sidebar {
    width: 200px;
  }
  
  .sidebar.collapsed {
    width: 50px;
  }
  
  .content {
    padding: 15px;
  }
}
</style>
