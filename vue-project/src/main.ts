import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import App from './App.vue'
import router from './router'
import pinia from './store'

// 创建应用实例
const app = createApp(App)

// 配置Element Plus
app.use(ElementPlus, {
  locale: zhCn,
  size: 'default'
})

// 注册所有Element Plus图标
for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

// 配置Pinia
app.use(pinia)

// 配置路由
app.use(router)

// 挂载应用
app.mount('#app')
