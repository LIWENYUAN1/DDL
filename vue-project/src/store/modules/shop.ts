import { defineStore } from 'pinia'
import { shopApi } from '@/api'

interface ShopInfo {
  id: number | string;
  name: string;
  [key: string]: any;
}

interface Service {
  id: number | string;
  [key: string]: any;
}

export const useShopStore = defineStore('shop', {
  state: () => ({
    shopInfo: null as ShopInfo | null,
    services: [] as Service[],
    loading: false
  }),
  
  getters: {
    hasShopInfo: (state) => !!state.shopInfo,
    shopName: (state) => state.shopInfo?.name || '',
    serviceCount: (state) => state.services.length
  },
  
  actions: {
    // 商家登录
    async login(data: { phone: string; password: string }) {
      this.loading = true
      try {
        const response = await shopApi.login(data)
        return response
      } catch (error) {
        console.error('商家登录失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    },
    
    // 商家注册/申请
    async register(data: any) {
      this.loading = true
      try {
        const response = await shopApi.register(data)
        return response
      } catch (error) {
        console.error('商家注册失败:', error)
        throw error
      } finally {
        this.loading = false
      }
    },
    
    // 获取商家信息
    async getShopInfo() {
      try {
        const response = await shopApi.getShopInfo()
        this.shopInfo = response.data
        return this.shopInfo
      } catch (error) {
        console.error('获取商家信息失败:', error)
        throw error
      }
    },
    
    // 更新商家信息
    async updateShopInfo(data: any) {
      try {
        const response = await shopApi.updateShopInfo(data)
        this.shopInfo = response.data
        return response
      } catch (error) {
        console.error('更新商家信息失败:', error)
        throw error
      }
    },
    
    // 获取商家服务项目列表
    async getServices() {
      try {
        const response = await shopApi.getServices()
        this.services = response.data
        return this.services
      } catch (error) {
        console.error('获取服务项目失败:', error)
        throw error
      }
    },
    
    // 添加服务项目
    async addService(data: any) {
      try {
        const response = await shopApi.addService(data)
        this.services.push(response.data)
        return response
      } catch (error) {
        console.error('添加服务项目失败:', error)
        throw error
      }
    },
    
    // 更新服务项目
    async updateService(id: number | string, data: any) {
      try {
        const response = await shopApi.updateService(Number(id), data)
        const index = this.services.findIndex(service => service?.id === id)
        if (index !== -1 && this.services[index]) {
          this.services[index] = response.data as Service
        }
        return response
      } catch (error) {
        console.error('更新服务项目失败:', error)
        throw error
      }
    },
    
    // 删除服务项目
    async deleteService(id: number | string) {
      try {
        await shopApi.deleteService(Number(id))
        this.services = this.services.filter(service => service?.id !== id)
      } catch (error) {
        console.error('删除服务项目失败:', error)
        throw error
      }
    },
    
    // 重置状态
    reset() {
      this.shopInfo = null
      this.services = []
    }
  }
})