import { defineStore } from 'pinia'
import { appointmentApi } from '@/api'

interface Appointment {
  id: string;
  userId?: string;
  userName?: string;
  userPhone?: string;
  serviceName?: string;
  appointmentTime?: string;
  status: string;
  createdAt?: string;
  [key: string]: any;
}

interface Shop {
  id: string;
  name: string;
  address: string;
  phone: string;
  distance: number;
  rating: number;
  image: string;
  [key: string]: any;
}

interface Service {
  id: string;
  name: string;
  description: string;
  price: number;
  duration: number;
  [key: string]: any;
}

interface CurrentAppointment {
  id: string;
  shopId?: any;
  shopName?: any;
  shopAddress?: any;
  shopPhone?: any;
  serviceId?: any;
  serviceName?: any;
  serviceDescription?: any;
  appointmentTime?: any;
  remark?: any;
  price?: any;
  status: string;
  orderNo: string;
  createdAt: string;
  isUser?: any;
  [key: string]: any;
}

export const useAppointmentStore = defineStore('appointment', {
  state: function() {
    return {
      nearbyShops: [] as Shop[],
      shopServices: [] as Service[],
      userAppointments: [] as Appointment[],
      shopAppointments: [] as Appointment[],
      currentAppointment: null as CurrentAppointment | null,
      loading: false
    }
  },
  
  getters: {
    pendingAppointments: function(state) {
      return state.userAppointments.filter((app: Appointment) => app?.status === 'pending')
    },
    completedAppointments: function(state) {
      return state.userAppointments.filter((app: Appointment) => app?.status === 'completed')
    },
    canceledAppointments: function(state) {
      return state.userAppointments.filter((app: Appointment) => app?.status === 'canceled')
    },
    shopPendingAppointments: function(state) {
      return state.shopAppointments.filter((app: Appointment) => app?.status === 'pending')
    }
  },
  
  actions: {
    // 获取附近商家列表
    async getNearbyShops(params: any) {
      this.loading = true;
      try {
        // 模拟数据
        const mockShops = [
          {
            id: '1',
            name: '极速摩托车服务店',
            address: '市中心大道123号',
            phone: '13800138001',
            distance: 1.2,
            rating: 4.8,
            image: '/shop1.jpg'
          },
          {
            id: '2',
            name: '专业摩托维修中心',
            address: '科技路456号',
            phone: '13800138002',
            distance: 2.5,
            rating: 4.6,
            image: '/shop2.jpg'
          }
        ];
        this.nearbyShops = mockShops as Shop[];
        return mockShops;
      } catch (error) {
        console.error('获取附近商家失败:', error);
        throw error;
      } finally {
        this.loading = false;
      }
    },
    
    // 获取商家服务项目
    async getShopServices(shopId: string) {
      try {
        // 模拟数据
        const mockServices = [
          {
            id: '101',
            name: '常规保养',
            description: '包含机油更换、滤清器更换等',
            price: 199,
            duration: 60
          },
          {
            id: '102',
            name: '刹车系统检修',
            description: '检查刹车片、刹车油等',
            price: 150,
            duration: 45
          }
        ];
        this.shopServices = mockServices as Service[];
        return mockServices;
      } catch (error) {
        console.error('获取商家服务项目失败:', error);
        throw error;
      }
    },
    
    // 创建预约
    async createAppointment(data: any) {
      try {
        // 模拟创建预约成功的响应
        const mockAppointment = {
          id: Date.now().toString(),
          shopId: data.shopId,
          shopName: data.shopName || '摩托车服务店',
          shopAddress: data.shopAddress || '店铺地址',
          shopPhone: data.shopPhone || '13800138000',
          serviceId: data.serviceId,
          serviceName: data.serviceName || '摩托车服务',
          serviceDescription: data.serviceDescription || '专业摩托车服务',
          appointmentTime: data.appointmentTime,
          remark: data.remark || '',
          price: data.price || 0,
          status: 'pending',
          orderNo: 'ORD' + Date.now(),
          createdAt: new Date().toISOString(),
          isUser: data.isUser
        };
        
        const mockResponse = { data: mockAppointment };
        this.currentAppointment = mockAppointment as CurrentAppointment;
        
        // 如果是用户端，添加到用户预约列表
        if (data.isUser) {
          this.userAppointments.unshift(mockAppointment as Appointment);
        }
        
        return mockResponse;
      } catch (error) {
        console.error('创建预约失败:', error);
        throw error;
      }
    },
    
    // 获取用户预约列表
    async getUserAppointments(params: any) {
      try {
        // 模拟数据
        const mockAppointments = [
          {
            id: '1001',
            shopId: '1',
            shopName: '极速摩托车服务店',
            shopAddress: '市中心大道123号',
            serviceName: '常规保养',
            appointmentTime: '2024-12-25 14:00:00',
            status: 'pending',
            orderNo: 'ORD123456',
            createdAt: '2024-12-20T10:00:00Z'
          }
        ];
        this.userAppointments = mockAppointments as Appointment[];
        return mockAppointments;
      } catch (error) {
        console.error('获取用户预约列表失败:', error);
        throw error;
      }
    },
    
    // 获取商家预约列表（使用真实API）
    async getShopAppointments(params: any = {}) {
      try {
        this.loading = true;
        // 调用后端API
        const response = await appointmentApi.getMerchantAppointments({
          pageNum: params.pageNum || 1,
          pageSize: params.pageSize || 10,
          status: params.status
        });
        
        if (response.code === 200 && response.data) {
          // 映射后端数据到前端格式
          const appointments = response.data.records.map((item: any) => ({
            id: item.id.toString(),
            orderNo: item.orderNo,
            userId: item.userId?.toString(),
            userName: item.userName || '未知用户',
            userPhone: item.contactPhone || '',
            serviceName: item.serviceItemName || '未知服务',
            appointmentTime: item.appointmentTime,
            price: Number(item.totalAmount ?? item.servicePrice ?? 0),
            status: this.mapStatusFromBackend(item.status),
            motorcycleModel: item.motorcycleModel || '',
            licensePlate: item.licensePlate || '',
            description: item.description || '',
            remark: item.remark || '',
            createdAt: item.createTime
          }));
          
          this.shopAppointments = appointments;
          return appointments;
        } else {
          console.error('获取商家预约列表失败:', response.msg);
          this.shopAppointments = [];
          return [];
        }
      } catch (error) {
        console.error('获取商家预约列表失败:', error);
        // 出错时返回空数组而不是抛出异常
        this.shopAppointments = [];
        return [];
      } finally {
        this.loading = false;
      }
    },
    
    // 状态映射：后端状态 -> 前端状态
    mapStatusFromBackend(backendStatus: number): string {
      const statusMap: Record<number, string> = {
        0: 'pending',      // 待确认
        1: 'confirmed',    // 已确认
        2: 'completed',    // 已完成
        3: 'canceled',     // 已取消
        4: 'breached'      // 已违约
      };
      return statusMap[backendStatus] || 'pending';
    },

    // 状态映射：前端状态 -> 后端状态
    mapStatusToBackend(frontendStatus: string): number {
      const statusMap: Record<string, number> = {
        'pending': 0,
        'confirmed': 1,
        'completed': 2,
        'canceled': 3,
        'breached': 4
      };
      return statusMap[frontendStatus] || 0;
    },
    
    // 更新预约状态（使用真实API）
    async updateAppointmentStatus(id: string, status: string) {
      try {
        let response;
        const appointmentId = parseInt(id);
        
        // 根据目标状态调用不同的API
        if (status === 'confirmed') {
          // 确认预约
          response = await appointmentApi.confirmAppointment(appointmentId);
        } else if (status === 'completed') {
          // 完成预约
          response = await appointmentApi.completeAppointment(appointmentId);
        } else if (status === 'canceled') {
          // 取消预约
          response = await appointmentApi.cancelMerchantAppointment(appointmentId);
        } else {
          throw new Error('不支持的状态更新操作');
        }

        if (response.code === 200) {
          // 更新本地状态
          const shopIndex = this.shopAppointments.findIndex((app: Appointment) => app?.id === id);
          if (shopIndex !== -1 && this.shopAppointments[shopIndex]) {
            this.shopAppointments[shopIndex].status = status;
          }

          return { success: true, message: response.msg || '状态更新成功' };
        } else {
          throw new Error(response.msg || '状态更新失败');
        }
      } catch (error) {
        console.error('更新预约状态失败:', error);
        throw error;
      }
    },
    
    // 取消预约
    async cancelAppointment(id: string) {
      try {
        // 模拟成功响应
        const mockResponse = { success: true, message: '预约已取消' };
        
        // 更新用户预约列表中的状态
        const userIndex = this.userAppointments.findIndex((app: Appointment) => app?.id === id);
        if (userIndex !== -1 && this.userAppointments[userIndex]) {
          this.userAppointments[userIndex].status = 'canceled';
        }

        // 更新商家预约列表中的状态
        const shopIndex = this.shopAppointments.findIndex((app: Appointment) => app?.id === id);
        if (shopIndex !== -1 && this.shopAppointments[shopIndex]) {
          this.shopAppointments[shopIndex].status = 'canceled';
        }
        
        return mockResponse;
      } catch (error) {
        console.error('取消预约失败:', error);
        throw error;
      }
    },
    
    // 重置状态
    reset: function() {
      this.nearbyShops = [];
      this.shopServices = [];
      this.currentAppointment = null;
    }
  }
})