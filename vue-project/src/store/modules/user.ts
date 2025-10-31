import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

interface UserInfo {
  id: string
  username?: string
  name?: string
  phone?: string
  email?: string
  role: string
  avatar?: string
  shop_name?: string
  created_at?: string
}

export const useUserStore = defineStore('user', () => {
  // 状态
  const token = ref<string>(localStorage.getItem('token') || '')
  const storedUserInfo = localStorage.getItem('userInfo')
  const userInfo = ref<UserInfo | null>(storedUserInfo ? JSON.parse(storedUserInfo) as UserInfo : null)
  const role = ref<string>(localStorage.getItem('role') || '')
  const isLoading = ref(false)
  const error = ref<string>('')

  // 计算属性
  const hasToken = computed(() => !!token.value)
  const isLoggedIn = computed(() => !!token.value && !!userInfo.value)
  const isUser = computed(() => role.value === 'user')
  const isShop = computed(() => role.value === 'shop')
  const isAdmin = computed(() => role.value === 'admin')
  const user = computed(() => userInfo.value)
  const userName = computed(() => userInfo.value?.username || userInfo.value?.name || '')

  // 操作
  // 用户登录
  async function login(credentials: {
    username?: string
    phone?: string
    email?: string
    password: string
    remember?: boolean
  }) {
    isLoading.value = true
    error.value = ''
    
    try {
      // 模拟登录成功
      const mockResponse = {
        data: {
          token: 'mock-jwt-token-' + Date.now(),
          userInfo: {
            id: '1',
            username: credentials.username || 'test_user',
            name: credentials.username || '测试用户',
            phone: credentials.phone || '13800138000',
            email: credentials.email || 'test@example.com',
            role: 'user',
            avatar: 'https://picsum.photos/200',
            created_at: new Date().toISOString()
          }
        }
      }
      
      const { token: newToken, userInfo: newUserInfo } = mockResponse.data
      
      // 保存token
      token.value = newToken
      const storage = credentials.remember ? localStorage : sessionStorage
      storage.setItem('token', newToken)
      
      // 保存用户信息
      userInfo.value = newUserInfo
      role.value = 'user'
      localStorage.setItem('userInfo', JSON.stringify(newUserInfo))
      localStorage.setItem('role', 'user')
      
      return mockResponse
    } catch (err) {
      error.value = err instanceof Error ? err.message : '登录失败，请重试'
      throw err
    } finally {
      isLoading.value = false
    }
  }

  // 商家登录
  async function shopLogin(credentials: {
    username?: string
    phone?: string
    password: string
    remember?: boolean
  }) {
    isLoading.value = true
    error.value = ''
    
    try {
      // 模拟商家登录成功
      const mockResponse = {
        data: {
          token: 'mock-shop-token-' + Date.now(),
          userInfo: {
            id: '100',
            username: credentials.username || 'test_shop',
            name: credentials.username || '测试商家',
            phone: credentials.phone || '13900139000',
            role: 'shop',
            avatar: 'https://picsum.photos/201',
            shop_name: '测试摩托车店',
            created_at: new Date().toISOString()
          }
        }
      }
      
      const { token: newToken, userInfo: newUserInfo } = mockResponse.data
      
      // 保存token
      token.value = newToken
      const storage = credentials.remember ? localStorage : sessionStorage
      storage.setItem('token', newToken)
      
      // 保存用户信息
      userInfo.value = newUserInfo
      role.value = 'shop'
      localStorage.setItem('userInfo', JSON.stringify(newUserInfo))
      localStorage.setItem('role', 'shop')
      
      return mockResponse
    } catch (err) {
      error.value = err instanceof Error ? err.message : '登录失败，请重试'
      throw err
    } finally {
      isLoading.value = false
    }
  }

  // 管理员登录
  async function adminLogin(credentials: {
    username: string
    password: string
    remember?: boolean
  }) {
    isLoading.value = true
    error.value = ''
    
    try {
      // 模拟管理员登录成功
      const mockResponse = {
        data: {
          token: 'mock-admin-token-' + Date.now(),
          userInfo: {
            id: '200',
            username: credentials.username,
            name: credentials.username,
            role: 'admin',
            avatar: 'https://picsum.photos/202',
            created_at: new Date().toISOString()
          }
        }
      }
      
      const { token: newToken, userInfo: newUserInfo } = mockResponse.data
      
      // 保存token
      token.value = newToken
      const storage = credentials.remember ? localStorage : sessionStorage
      storage.setItem('token', newToken)
      
      // 保存用户信息
      userInfo.value = newUserInfo
      role.value = 'admin'
      localStorage.setItem('userInfo', JSON.stringify(newUserInfo))
      localStorage.setItem('role', 'admin')
      
      return mockResponse
    } catch (err) {
      error.value = err instanceof Error ? err.message : '登录失败，请重试'
      throw err
    } finally {
      isLoading.value = false
    }
  }

  // 注册
  async function register(data: {
    username: string
    phone: string
    verificationCode: string
    password: string
  }) {
    isLoading.value = true
    error.value = ''
    
    try {
      // 模拟注册成功
      await new Promise(resolve => setTimeout(resolve, 1000))
      return { success: true }
    } catch (err) {
      error.value = err instanceof Error ? err.message : '注册失败，请重试'
      throw err
    } finally {
      isLoading.value = false
    }
  }

  // 发送验证码
  async function sendVerificationCode(params: { phone?: string; email?: string; type?: string; role?: string } | string) {
    try {
      // 模拟发送验证码
      await new Promise(resolve => setTimeout(resolve, 500))
      // 处理不同的参数类型
      const contactInfo = typeof params === 'string' ? params : (params.phone || params.email || '')
      console.log('验证码已发送到:', contactInfo)
      return { success: true }
    } catch (err) {
      error.value = err instanceof Error ? err.message : '发送验证码失败'
      throw err
    }
  }

  // 获取用户信息
  async function getUserInfo() {
    if (!token.value) return
    
    isLoading.value = true
    error.value = ''
    
    try {
      // 模拟从服务器获取用户信息
      await new Promise(resolve => setTimeout(resolve, 300))
      
      // 如果localStorage中没有用户信息，使用默认值
      if (!userInfo.value) {
        userInfo.value = {
          id: '1',
          username: 'test_user',
          name: '测试用户',
          role: role.value || 'user'
        }
        localStorage.setItem('userInfo', JSON.stringify(userInfo.value))
      }
      
      return userInfo.value
    } catch (err) {
      error.value = err instanceof Error ? err.message : '获取用户信息失败'
      logout()
      throw err
    } finally {
      isLoading.value = false
    }
  }

  // 更新用户信息
  async function updateUserInfo(data: Partial<UserInfo>) {
    if (!token.value) throw new Error('未登录')
    
    isLoading.value = true
    error.value = ''
    
    try {
      // 模拟更新用户信息
      await new Promise(resolve => setTimeout(resolve, 500))
      
      if (userInfo.value) {
        userInfo.value = { ...userInfo.value, ...data }
        localStorage.setItem('userInfo', JSON.stringify(userInfo.value))
      }
      
      return { data: userInfo.value }
    } catch (err) {
      error.value = err instanceof Error ? err.message : '更新用户信息失败'
      throw err
    } finally {
      isLoading.value = false
    }
  }

  // 修改密码
  async function changePassword(data: {
    oldPassword: string
    newPassword: string
    confirmPassword?: string
  }) {
    if (!token.value) throw new Error('未登录')
    
    isLoading.value = true
    error.value = ''
    
    try {
      // 模拟修改密码
      await new Promise(resolve => setTimeout(resolve, 1000))
      return { success: true }
    } catch (err) {
      error.value = err instanceof Error ? err.message : '修改密码失败'
      throw err
    } finally {
      isLoading.value = false
    }
  }

  // 登出
  function logout() {
    // 清除token
    token.value = ''
    localStorage.removeItem('token')
    sessionStorage.removeItem('token')
    
    // 清除用户信息
    userInfo.value = null
    role.value = ''
    localStorage.removeItem('userInfo')
    localStorage.removeItem('role')
    
    // 清除错误信息
    error.value = ''
  }

  // 初始化 - 从本地存储恢复状态
  function initialize() {
    // 已经在初始化时从localStorage读取了token和用户信息
    if (token.value && !userInfo.value) {
      // 如果有token但没有用户信息，尝试获取
      getUserInfo().catch(() => {
        // 如果获取用户信息失败，清除token
        logout()
      })
    }
  }

  // 重置用户状态
  function resetUser() {
    token.value = ''
    userInfo.value = null
    role.value = 'guest'
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
    localStorage.removeItem('role')
    sessionStorage.removeItem('token')
    sessionStorage.removeItem('userInfo')
    sessionStorage.removeItem('role')
  }

  // 设置用户信息（用于实际API登录后）
  async function setUserInfo(userData: {
    token: string,
    username: string,
    role: string,
    remember: boolean
  }) {
    // 保存token
    token.value = userData.token
    const storage = userData.remember ? localStorage : sessionStorage
    storage.setItem('token', userData.token)
    
    // 构建完整的用户信息对象，确保包含所有必要字段
    const now = new Date().toISOString()
    
    // 根据角色构建不同的用户信息对象，确保与原有模拟登录方法保持一致
    let fullUserInfo: UserInfo
    
    switch (userData.role) {
      case 'user':
        fullUserInfo = {
          id: '1',
          username: userData.username,
          name: userData.username,
          phone: '13800138000',
          email: userData.username + '@example.com',
          role: 'user',
          avatar: 'https://picsum.photos/200',
          created_at: now
        }
        break
      case 'shop':
        fullUserInfo = {
          id: '100',
          username: userData.username,
          name: userData.username,
          phone: '13900139000',
          role: 'shop',
          avatar: 'https://picsum.photos/201',
          shop_name: userData.username + '的店铺',
          created_at: now
        }
        break
      case 'admin':
        fullUserInfo = {
          id: '200',
          username: userData.username,
          name: userData.username,
          role: 'admin',
          avatar: 'https://picsum.photos/202',
          created_at: now
        }
        break
      default:
        fullUserInfo = {
          id: '1',
          username: userData.username,
          name: userData.username,
          role: userData.role,
          avatar: 'https://picsum.photos/200',
          created_at: now
        }
    }
    
    // 保存完整的用户信息
    userInfo.value = fullUserInfo
    role.value = userData.role
    localStorage.setItem('userInfo', JSON.stringify(userInfo.value))
    localStorage.setItem('role', userData.role)
    
    return { success: true }
  }

  return {
    // 状态
    token,
    userInfo,
    role,
    isLoading,
    error,
    
    // 计算属性
    hasToken,
    isLoggedIn,
    isUser,
    isShop,
    isAdmin,
    user,
    userName,
    
    // 方法
    login,
    shopLogin,
    adminLogin,
    register,
    sendVerificationCode,
    getUserInfo,
    updateUserInfo,
    changePassword,
    logout,
    initialize,
    resetUser,
    setUserInfo
  }
})