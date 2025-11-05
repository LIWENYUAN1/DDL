import { createPinia } from 'pinia'
import { useAppointmentStore } from './modules/appointment'
import { useUserStore } from './modules/user'
import { useNotificationStore } from './modules/notification'
import type { App } from 'vue'

const pinia = createPinia()

// 添加setupStore函数导出
export function setupStore(app: App) {
  app.use(pinia)
}

// 导出store
export { useAppointmentStore, useUserStore, useNotificationStore }
export default pinia
