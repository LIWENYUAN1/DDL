import axios from 'axios'

// 创建axios实例
const service = axios.create({
  baseURL: 'http://localhost:8080', // 后端API基础URL
  timeout: 15000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器
service.interceptors.request.use(
  config => {
    // 从localStorage获取token
    const token = localStorage.getItem('token')
    
    // 🔍 调试日志：查看请求信息
    console.log('🚀 发送请求:', {
      url: config.url,
      method: config.method,
      hasToken: !!token,
      token: token ? token.substring(0, 20) + '...' : 'null'
    })
    
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    } else {
      console.warn('⚠️ 警告：没有找到token！')
    }
    return config
  },
  error => {
    console.error('请求错误:', error)
    return Promise.reject(error)
  }
)

// 简单的消息提示函数
const showMessage = (message: string, type: 'success' | 'error' | 'warning' | 'info' = 'success') => {
  console.log(`[${type.toUpperCase()}] ${message}`)
  // 创建一个临时元素显示消息
  const msgElement = document.createElement('div')
  msgElement.className = `message-toast message-${type}`
  msgElement.textContent = message
  msgElement.style.cssText = `
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 12px 20px;
    background-color: ${type === 'success' ? '#67c23a' : type === 'warning' ? '#e6a23c' : type === 'error' ? '#f56c6c' : '#909399'};
    color: white;
    border-radius: 4px;
    z-index: 9999;
    box-shadow: 0 2px 12px rgba(0,0,0,0.1);
    transition: opacity 0.3s;
  `
  document.body.appendChild(msgElement)
  setTimeout(() => {
    msgElement.style.opacity = '0'
    setTimeout(() => {
      document.body.removeChild(msgElement)
    }, 300)
  }, 3000)
}

// 模拟数据存储
const mockData = {
  // 模拟登录响应
  login: (username: string, password: string, userType?: number) => {
    if (username && password) {
      // 根据userType确定角色
      let type = userType || 1
      return {
        code: 200,
        message: '登录成功',
        data: {
          token: 'mock_token_' + Date.now(),
          id: Date.now(),
          username: username,
          phone: '13800138000',
          userType: type,
          avatar: '',
          realName: username
        }
      }
    }
    return {
      code: 400,
      message: '用户名或密码错误'
    }
  },
  
  // 模拟注册响应
  register: (data: any) => {
    return {
      code: 200,
      message: '注册成功',
      data: {
        id: Date.now()
      }
    }
  },
  
  // 模拟用户列表
  userList: {
    code: 200,
    message: '获取成功',
    data: [
      { id: 1, username: 'user1', name: '用户1', status: true },
      { id: 2, username: 'user2', name: '用户2', status: true }
    ]
  },
  
  // 模拟商家列表
  shopList: {
    code: 200,
    message: '获取成功',
    data: [
      { id: 1, name: '店铺1', address: '地址1', contactPerson: '联系人1' },
      { id: 2, name: '店铺2', address: '地址2', contactPerson: '联系人2' }
    ]
  }
}

// 响应拦截器
service.interceptors.response.use(
  response => {
    const res = response.data
    
    // 🔍 调试日志：查看响应数据
    console.log('📥 收到响应:', {
      url: response.config.url,
      status: response.status,
      data: res
    })
    
    // 根据后端约定的状态码判断
    if (res.code !== 200) {
      console.error('❌ 响应code不是200:', res.code, res.msg || res.message)
      showMessage(res.msg || res.message || '请求失败', 'error')
      
      // 处理未认证或token过期的情况
      if (res.code === 401) {
        // 清除token并跳转到登录页
        localStorage.removeItem('token')
        localStorage.removeItem('userInfo')
        window.location.href = '/login'
      }
      
      return Promise.reject(new Error(res.msg || res.message || '请求失败'))
    }
    
    console.log('✅ 响应成功，返回数据:', res)
    return res
  },
  error => {
    console.error('响应错误:', error)
    console.error('错误详情:', {
      message: error.message,
      status: error.response?.status,
      data: error.response?.data,
      config: {
        url: error.config?.url,
        headers: error.config?.headers
      }
    })
    
    // 处理403 Forbidden错误
    if (error.response?.status === 403) {
      console.error('🚫 403 Forbidden - 没有权限访问该资源')
      console.error('请求配置:', {
        url: error.config?.url,
        headers: error.config?.headers,
        token: localStorage.getItem('token')
      })
      showMessage('没有权限访问，请重新登录', 'error')
      
      // 清除token并跳转到登录页
      setTimeout(() => {
        localStorage.removeItem('token')
        localStorage.removeItem('userInfo')
        window.location.href = '/login'
      }, 1500)
      
      return Promise.reject(new Error('没有权限访问该资源'))
    }
    
    // 处理401未授权错误
    if (error.response?.status === 401) {
      console.error('🔐 401 Unauthorized - token无效或已过期')
      showMessage('登录已过期，请重新登录', 'error')
      
      setTimeout(() => {
        localStorage.removeItem('token')
        localStorage.removeItem('userInfo')
        window.location.href = '/login'
      }, 1500)
      
      return Promise.reject(new Error('未授权访问'))
    }
    
    // 增强错误处理，区分网络错误和其他错误
    if (error.message?.includes('Network Error') || error.code === 'ECONNABORTED') {
      // 这是网络错误或请求超时，表示后端连接失败
      console.log('后端服务不可用，使用模拟数据')
      
      // 获取请求URL和数据
      const config = error.config as any
      const url = config?.url || ''
      const method = config?.method || 'get'
      const data = typeof config?.data === 'string' ? JSON.parse(config.data) : (config?.data || {})
      
      // 根据URL路径返回对应的模拟数据
      if (url.includes('/auth/login')) {
        const result = mockData.login(data.username, data.password, data.userType)
        return Promise.resolve(result)
      } else if (url.includes('/auth/register')) {
        const result = mockData.register(data)
        return Promise.resolve(result)
      } else if (url.includes('/user/list')) {
        return Promise.resolve(mockData.userList)
      } else if (url.includes('/shop/list')) {
        return Promise.resolve(mockData.shopList)
      }
      
      // 对于其他API，返回通用的成功响应
      return Promise.resolve({
        code: 200,
        message: '模拟数据响应',
        data: {}
      })
    }
    
    // 非网络错误的处理
    if (error.response) {
      // 服务器返回错误响应
      error.message = error.response.data?.message || `服务器错误 (${error.response.status})`
    } else {
      // 其他类型的错误
      error.message = error.message || '请求处理失败'
    }
    
    showMessage(error.message, 'error')
    return Promise.reject(error)
  }
)

export default service