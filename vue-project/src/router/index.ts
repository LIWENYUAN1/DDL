import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
import store from '@/store'
// const UserHomeView = () => import('@/views/user/UserHomeView.vue')
// const UserAppointmentsView = () => import('@/views/user/UserAppointmentsView.vue')
  // const UserProfileView = () => import('@/views/user/UserProfileView.vue')
  // const ShopAppointmentsView = () => import('@/views/shop/ShopAppointmentsView.vue')
  // const ShopServicesView = () => import('@/views/shop/ShopServicesView.vue')
  // const ShopHomeView = () => import('@/views/shop/ShopHomeView.vue')
  // const ShopProfileView = () => import('@/views/shop/ShopProfileView.vue')
  // const AdminHomeView = () => import('@/views/admin/AdminHomeView.vue')
  // const AdminUsersView = () => import('@/views/admin/AdminUsersView.vue')
  // const AdminShopsView = () => import('@/views/admin/AdminShopsView.vue')
  // const AdminAppointmentsView = () => import('@/views/admin/AdminAppointmentsView.vue')
  // const AdminProfileView = () => import('@/views/admin/AdminProfileView.vue')
  // const AdminStatisticsView = () => import('@/views/admin/AdminStatisticsView.vue')

const routes: Array<RouteRecordRaw> = [
  // 公共路由
  {
    path: '/',
    name: 'home',
    component: () => import('@/views/HomeView.vue') as any,
    meta: {
      title: '摩托车服务平台',
      requiresAuth: false
    }
  },
  {
    path: '/login-choice',
    name: 'loginChoice',
    component: () => import('@/views/LoginChoiceView.vue') as any,
    meta: {
      title: '选择登录方式 - 摩托车服务平台',
      requiresAuth: false
    }
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/LoginView.vue') as any,
    meta: {
      title: '登录 - 摩托车服务平台',
      requiresAuth: false
    }
  },
  {
    path: '/register',
    name: 'register',
    component: () => import('@/views/RegisterView.vue') as any,
    meta: {
      title: '注册 - 摩托车服务平台',
      requiresAuth: false
    }
  },
  {
    path: '/shop/login',
    name: 'shopLogin',
    component: () => import('@/views/shop/ShopLoginView.vue') as any,
    meta: {
      title: '商家登录 - 摩托车服务平台',
      requiresAuth: false
    }
  },
  {
    path: '/shop/register',
    name: 'shopRegister',
    component: () => import('@/views/shop/ShopRegisterView.vue') as any,
    meta: {
      title: '商家注册 - 摩托车服务平台',
      requiresAuth: false
    }
  },
  {
    path: '/admin/login',
    name: 'adminLogin',
    component: () => import('@/views/admin/AdminLoginView.vue') as any,
    meta: {
      title: '管理员登录 - 摩托车服务平台',
      requiresAuth: false
    }
  },
  
  // 用户端路由
  {
    path: '/user/home',
    name: 'userHome',
    component: () => import('@/views/user/UserHomeView.vue'),
    meta: {
      title: '用户首页 - 摩托车服务平台',
      requiresAuth: true,
      role: 'user'
    }
  },
  // {
  //   path: '/user/appointments',
  //   name: 'UserAppointments',
  //   component: () => import('@/views/user/UserAppointmentsView.vue'),
  //   meta: {
  //     title: '我的预约 - 摩托车服务平台',
  //     requiresAuth: true,
  //     role: 'user'
  //   }
  // },
  // {
  //   path: '/user/profile',
  //   name: 'UserProfile',
  //   component: () => import('@/views/user/UserProfileView.vue'),
  //   meta: {
  //     title: '个人中心 - 摩托车服务平台',
  //     requiresAuth: true,
  //     role: 'user'
  //   }
  // },
  // {
  //   path: '/user/ratings',
  //   name: 'userRatings',
  //   component: () => import('../views/user/RatingsView.vue'),
  //   meta: {
  //     title: '我的评价 - 摩托车服务平台',
  //     requiresAuth: true,
  //     role: 'user'
  //   }
  // },
  // 暂时注释掉收藏功能路由，因为FavoriteView.vue文件不存在
  // {
  //   path: '/user/favorites',
  //   name: 'userFavorites',
  //   component: () => import('../views/user/FavoriteView.vue'),
  //   meta: {
  //     title: '我的收藏 - 摩托车服务平台',
  //     requiresAuth: true,
  //     role: 'user'
  //   }
  // },
  
  // 商家端路由
  {
    path: '/shop/home',
    name: 'shopHome',
    component: () => import('@/views/shop/ShopHomeView.vue'),
    meta: {
      title: '商家首页 - 摩托车服务平台',
      requiresAuth: true,
      role: 'shop'
    }
  },
  // {
  //   path: '/shop/appointments',
  //   name: 'ShopAppointments',
  //   component: () => import('@/views/shop/ShopAppointmentsView.vue'),
  //   meta: {
  //     title: '预约管理 - 摩托车服务平台',
  //     requiresAuth: true,
  //     role: 'shop'
  //   }
  // },
  // {
  //   path: '/shop/services',
  //   name: 'ShopServices',
  //   component: () => import('@/views/shop/ShopServicesView.vue'),
  //   meta: {
  //     title: '服务管理 - 摩托车服务平台',
  //     requiresAuth: true,
  //     role: 'shop'
  //   }
  // },
  // {
  //   path: '/shop/profile',
  //   name: 'ShopProfile',
  //   component: () => import('@/views/shop/ShopProfileView.vue'),
  //   meta: {
  //     title: '商家信息 - 摩托车服务平台',
  //     requiresAuth: true,
  //     role: 'shop'
  //   }
  // },
  
  // 管理员端路由
  {
    path: '/admin/home',
    name: 'adminHome',
    component: () => import('@/views/admin/AdminHomeView.vue'),
    meta: {
      title: '管理控制台 - 摩托车服务平台',
      requiresAuth: true,
      role: 'admin'
    }
  },
  // {
  //   path: '/admin/users',
  //   name: 'AdminUsers',
  //   component: () => import('@/views/admin/AdminUsersView.vue'),
  //   meta: {
  //     title: '用户管理 - 摩托车服务平台',
  //     requiresAuth: true,
  //     role: 'admin'
  //   }
  // },
  // {
  //   path: '/admin/shops',
  //   name: 'AdminShops',
  //   component: () => import('@/views/admin/AdminShopsView.vue'),
  //   meta: {
  //     title: '商家管理 - 摩托车服务平台',
  //     requiresAuth: true,
  //     role: 'admin'
  //   }
  // },
  // {
  //   path: '/admin/appointments',
  //   name: 'AdminAppointments',
  //   component: () => import('@/views/admin/AdminAppointmentsView.vue'),
  //   meta: {
  //     title: '预约审核 - 摩托车服务平台',
  //     requiresAuth: true,
  //     role: 'admin'
  //   }
  // },
  // {
  //   path: '/admin/profile',
  //   name: 'AdminProfile',
  //   component: () => import('@/views/admin/AdminProfileView.vue'),
  //   meta: {
  //     title: '管理员信息 - 摩托车服务平台',
  //     requiresAuth: true,
  //     role: 'admin'
  //   }
  // },
  // {
  //   path: '/admin/statistics',
  //   name: 'AdminStatistics',
  //   component: () => import('@/views/admin/AdminStatisticsView.vue'),
  //   meta: {
  //     title: '数据统计 - 摩托车服务平台',
  //     requiresAuth: true,
  //     role: 'admin'
  //   }
  // },
  
    // 404 页面路由
    {
      path: '/:pathMatch(.*)*',
      name: 'notFound',
      component: () => import('@/views/NotFound.vue') as any,
      meta: {
        title: '页面不存在 - 摩托车服务平台',
        requiresAuth: false
      }
    }
  ]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

// 全局前置守卫
router.beforeEach((to, from, next) => {
  // 设置页面标题
  document.title = (to.meta.title as string) || '摩托车服务平台'
  
  // 简化的认证检查，从 localStorage 获取用户信息
  const token = localStorage.getItem('token')
  const role = localStorage.getItem('role')
  const requiresAuth = to.meta.requiresAuth || false
  
  console.log('🛡️ 路由守卫:', {
    to: to.path,
    from: from.path,
    token: token ? token.substring(0, 20) + '...' : null,
    role: role,
    requiresAuth: requiresAuth,
    pageRole: to.meta.role
  })
  
  // 角色首页映射
  const roleHomePage: Record<string, string> = {
    'user': '/user/home',
    'shop': '/shop/home', 
    'admin': '/admin/home'
  }
  
  // 1. 已登录用户访问首页，自动跳转到对应角色首页
  if (to.path === '/' && token && role) {
    next({ path: roleHomePage[role] || '/login' })
    return
  }
  
  // 2. 处理不需要认证的页面
  if (!requiresAuth) {
    // 已登录用户访问登录/注册页面，重定向到对应首页
    if ((to.path === '/login' || to.path === '/register' || to.path === '/shop/login' || to.path === '/shop/register' || to.path === '/admin/login') && token && role) {
      next({ path: roleHomePage[role] || '/' })
      return
    }
    // 直接放行不需要认证的页面
    next()
    return
  }
  
  // 3. 处理需要认证的页面
  if (!token) {
    // 未登录，重定向到登录页
    console.log('❌ 未登录，跳转到登录页')
    next({ path: '/login' })
    return
  }
  
  // 4. 处理特定角色页面
  if (to.meta.role) {
    // 如果没有角色信息或角色不匹配，清除登录信息并跳转到登录页
    if (!role || role !== to.meta.role) {
      console.log('❌ 角色不匹配，清除登录信息', {
        需要角色: to.meta.role,
        当前角色: role
      })
      localStorage.clear()
      sessionStorage.clear()
      next({ path: '/login' })
      return
    }
  }
  
  // 5. 所有条件都满足，直接导航
  console.log('✅ 路由守卫放行，允许导航到:', to.path)
  next()
})

export default router
