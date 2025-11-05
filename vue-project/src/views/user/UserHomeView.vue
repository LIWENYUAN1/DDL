<template>
  <div class="user-home">
    <!-- 顶部导航 -->
    <el-header class="header">
      <div class="header-content">
        <div class="logo">
          <el-icon><Tools /></el-icon>
          <span>摩托车服务平台</span>
        </div>
        <div class="user-info">
          <el-dropdown @command="handleCommand">
            <span class="user-dropdown">
              <el-avatar :src="userAvatar" :size="32">
                <el-icon><UserFilled /></el-icon>
              </el-avatar>
              <span class="username">{{ userName }}</span>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                <el-dropdown-item command="appointments">我的预约</el-dropdown-item>
                <el-dropdown-item command="motorcycles">我的车辆</el-dropdown-item>
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
          <el-menu-item index="nearby">
            <el-icon><Location /></el-icon>
            <span>附近商家</span>
          </el-menu-item>
          <el-menu-item index="appointments">
            <el-icon><Calendar /></el-icon>
            <span>我的预约</span>
          </el-menu-item>
          <el-menu-item index="motorcycles">
            <el-icon><Odometer /></el-icon>
            <span>我的车辆</span>
          </el-menu-item>
          <el-menu-item index="reviews">
            <el-icon><Star /></el-icon>
            <span>我的评价</span>
          </el-menu-item>
          <el-menu-item index="profile">
            <el-icon><User /></el-icon>
            <span>个人中心</span>
          </el-menu-item>
        </el-menu>
      </el-aside>

      <!-- 内容区 -->
      <el-main class="content">
        <!-- 搜索和筛选 -->
        <div class="search-section" v-if="activeMenu === 'nearby'">
          <el-card shadow="never">
            <el-row :gutter="20">
              <el-col :span="12">
                <el-input
                  v-model="searchQuery"
                  placeholder="搜索商家名称或服务项目"
                  :prefix-icon="Search"
                  clearable
                  @input="handleSearch"
                />
              </el-col>
              <el-col :span="6">
                <el-select
                  v-model="filterType"
                  placeholder="服务类型"
                  clearable
                  @change="handleFilter"
                >
                  <el-option label="全部" value="" />
                  <el-option label="维修服务" value="1" />
                  <el-option label="保养服务" value="2" />
                  <el-option label="改装升级" value="3" />
                  <el-option label="异地托运" value="4" />
                  <el-option label="美容清洗" value="5" />
                </el-select>
              </el-col>
              <el-col :span="6">
                <el-button type="primary" @click="getLocation" :loading="locationLoading">
                  <el-icon><Location /></el-icon>
                  {{ locationLoading ? '定位中...' : '获取位置' }}
                </el-button>
              </el-col>
            </el-row>
          </el-card>
        </div>

        <el-card
          v-if="activeMenu === 'nearby'"
          class="map-card"
          shadow="never"
        >
          <template #header>
            <div class="map-card-header">
              <div class="map-card-title">
                <el-icon><Location /></el-icon>
                <span>地图定位</span>
              </div>
              <div v-if="currentLocation" class="map-card-location">
                当前位置：{{ currentLocation }}
              </div>
            </div>
          </template>
          <div class="map-wrapper">
            <div ref="mapContainer" class="map-container"></div>
          </div>
        </el-card>

        <!-- 附近商家列表 -->
        <div v-if="activeMenu === 'nearby'" class="shops-section">
          <el-row :gutter="20" v-loading="loading">
            <el-col 
              :xs="24" 
              :sm="12" 
              :md="8" 
              :lg="6"
              v-for="shop in filteredShops" 
              :key="shop.id"
            >
              <el-card class="shop-card" shadow="hover" @click="viewShopDetail(shop)">
                <div class="shop-header">
                  <img :src="shop.logo || defaultLogo" class="shop-logo" />
                  <div class="shop-info">
                    <h3>{{ shop.name }}</h3>
                    <div class="shop-rating">
                      <el-rate
                        v-model="shop.rating"
                        disabled
                        show-score
                        text-color="#ff9900"
                        score-template="{value}"
                      />
                      <span class="review-count">({{ shop.reviewCount }}条评价)</span>
                    </div>
                  </div>
                </div>
                <div class="shop-details">
                  <div class="detail-item">
                    <el-icon><Location /></el-icon>
                    <span>{{ shop.address }}</span>
                  </div>
                  <div class="detail-item">
                    <el-icon><Clock /></el-icon>
                    <span>{{ shop.businessHours }}</span>
                  </div>
                  <div class="detail-item">
                    <el-icon><Phone /></el-icon>
                    <span>{{ shop.phone }}</span>
                  </div>
                  <div class="distance">距离：{{ formatDistance(shop.distance) }}</div>
                </div>
                <div class="shop-services">
                  <el-tag 
                    v-for="service in shop.services.slice(0, 3)" 
                    :key="service"
                    size="small"
                    class="service-tag"
                  >
                    {{ service }}
                  </el-tag>
                </div>
                <el-button type="primary" class="book-btn" @click.stop="bookService(shop)">
                  立即预约
                </el-button>
              </el-card>
            </el-col>
          </el-row>
          
          <!-- 空状态 -->
          <el-empty 
            v-if="!loading && filteredShops.length === 0" 
            description="暂无附近商家"
          />
        </div>

        <!-- 我的预约 -->
        <UserAppointments v-if="activeMenu === 'appointments'" />

        <!-- 我的车辆 -->
        <UserMotorcycles v-if="activeMenu === 'motorcycles'" />

        <!-- 我的评价 -->
        <UserReviews v-if="activeMenu === 'reviews'" />

        <!-- 个人中心 -->
        <UserProfile v-if="activeMenu === 'profile'" />
      </el-main>
    </el-container>

    <!-- 商家详情对话框 -->
    <el-dialog
      v-model="showShopDetail"
      :title="selectedShop?.name"
      width="800px"
      @close="selectedShop = null"
    >
      <div v-if="selectedShop" class="shop-detail-content">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="商家地址">{{ selectedShop.address }}</el-descriptions-item>
          <el-descriptions-item label="联系电话">{{ selectedShop.phone }}</el-descriptions-item>
          <el-descriptions-item label="营业时间">{{ selectedShop.businessHours }}</el-descriptions-item>
          <el-descriptions-item label="评分">
            <el-rate v-model="selectedShop.rating" disabled />
          </el-descriptions-item>
        </el-descriptions>
        
        <h4 class="section-title">服务项目</h4>
        <el-table :data="selectedShop.serviceItems" style="width: 100%">
          <el-table-column prop="name" label="服务名称" />
          <el-table-column prop="price" label="价格">
            <template #default="{ row }">
              <span class="price">¥{{ row.price }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="duration" label="预计时长">
            <template #default="{ row }">
              {{ row.duration }}分钟
            </template>
          </el-table-column>
          <el-table-column label="操作">
            <template #default="{ row }">
              <el-button type="primary" size="small" @click="bookServiceItem(selectedShop, row)">
                预约
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
      
      <template #footer>
        <el-button @click="showShopDetail = false">关闭</el-button>
        <el-button type="primary" @click="bookService(selectedShop)">立即预约</el-button>
      </template>
    </el-dialog>

    <!-- 预约对话框 -->
    <BookingDialog
      v-model="showBookingDialog"
      :shop-info="bookingShopInfo"
      :pre-selected-service-id="preSelectedServiceId"
      @success="handleBookingSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Location, Calendar, User, Star, Odometer, Search,
  Clock, Phone, UserFilled, Tools
} from '@element-plus/icons-vue'
import UserAppointments from '@/components/user/UserAppointments.vue'
import UserMotorcycles from '@/components/user/UserMotorcycles.vue'
import UserReviews from '@/components/user/UserReviews.vue'
import UserProfile from '@/components/user/UserProfile.vue'
import BookingDialog from '@/components/user/BookingDialog.vue'
import { loadAMap } from '@/utils/amapLoader'

const router = useRouter()

// 用户信息
const userName = ref(localStorage.getItem('userInfo') ? JSON.parse(localStorage.getItem('userInfo')!).username : '用户')
const userAvatar = ref('')

// 菜单状态
const activeMenu = ref('nearby')

// 搜索和筛选
const searchQuery = ref('')
const filterType = ref('')
const currentLocation = ref('')
const locationLoading = ref(false)

// 地图相关
const mapContainer = ref<HTMLDivElement | null>(null)
const amap = ref<any>(null)
const mapInstance = ref<any>(null)
const mapReady = ref(false)
const geocoder = ref<any>(null)
const userMarker = ref<any>(null)
let mapInitPromise: Promise<void> | null = null

// 商家数据
const loading = ref(false)
const shops = ref<any[]>([])
const selectedShop = ref<any>(null)
const showShopDetail = ref(false)

// 预约对话框
const showBookingDialog = ref(false)
const bookingShopInfo = ref<any>(null)
const preSelectedServiceId = ref<number | undefined>(undefined)

// 使用SVG作为默认Logo，避免外部图片加载失败
const defaultLogo = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iODAiIGhlaWdodD0iODAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHJlY3Qgd2lkdGg9IjgwIiBoZWlnaHQ9IjgwIiBmaWxsPSIjZjVmNWY1Ii8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtc2l6ZT0iMTQiIGZpbGw9IiM5OTk5OTkiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGR5PSIuM2VtIj5Mb2dvPC90ZXh0Pjwvc3ZnPg=='

// 模拟商家数据（匹配数据库实际数据）
// 注意：serviceItems 的 ID 必须与数据库 service_item 表中的 ID 一致
const mockShops = [
  {
    id: 1,
    name: '极速摩托维修店',
    logo: '',
    address: '云南省大理市下关镇幸福路100号',
    phone: '13900139000',
    businessHours: '09:00-20:00',
    rating: 4.5,
    reviewCount: 128,
    distance: 1.2,
    location: [100.2676, 25.6065] as [number, number],
    services: ['机油保养', '刹车维修', '链条保养'],
    serviceItems: [
      { id: 3, name: '机油更换服务', price: 180, duration: 30 },
      { id: 4, name: '刹车保养', price: 280, duration: 60 }
    ]
  },
  {
    id: 2,
    name: 'DDL测试维修店',
    logo: '',
    address: '北京市朝阳区建国路99号',
    phone: '13008620788',
    businessHours: '08:00-21:00',
    rating: 4.8,
    reviewCount: 256,
    distance: 2.5,
    location: [116.483, 39.914] as [number, number],
    services: ['基础保养', '刹车系统', '综合维护'],
    serviceItems: [
      { id: 1, name: '常规保养套餐', price: 200, duration: 60 },
      { id: 2, name: '刹车系统维护', price: 300, duration: 90 }
    ]
  }
]

// 过滤后的商家列表
const filteredShops = computed(() => {
  let result = shops.value

  // 按搜索关键词过滤
  if (searchQuery.value) {
    result = result.filter(shop =>
      shop.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      shop.services.some((s: string) => s.includes(searchQuery.value))
    )
  }

  // 按类型过滤
  if (filterType.value) {
    // 这里可以根据实际的类型字段进行过滤
    // result = result.filter(shop => shop.type === filterType.value)
  }

  return result
})

// 菜单选择
const handleMenuSelect = (index: string) => {
  activeMenu.value = index
}

// 搜索
const handleSearch = () => {
  // 搜索逻辑已在computed中实现
}

// 筛选
const handleFilter = () => {
  // 筛选逻辑已在computed中实现
}

const calculateDistance = (start: [number, number], end: [number, number]) => {
  try {
    if (amap.value?.GeometryUtil?.distance) {
      const meters = amap.value.GeometryUtil.distance(start, end)
      if (typeof meters === 'number' && !Number.isNaN(meters)) {
        return meters / 1000
      }
    }
  } catch (error) {
    console.warn('高德地图距离计算失败，使用兜底计算', error)
  }

  const toRad = (value: number) => (value * Math.PI) / 180
  const [lng1, lat1] = start
  const [lng2, lat2] = end
  const R = 6371
  const dLat = toRad(lat2 - lat1)
  const dLng = toRad(lng2 - lng1)
  const a = Math.sin(dLat / 2) ** 2 + Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLng / 2) ** 2
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  return R * c
}

const formatDistance = (distance?: number) => {
  if (typeof distance !== 'number' || Number.isNaN(distance)) {
    return '未知'
  }
  if (distance < 1) {
    return `${Math.round(distance * 1000)}m`
  }
  return `${distance.toFixed(1)}km`
}

const renderShopMarkers = (data: any[]) => {
  if (!mapInstance.value || !amap.value) {
    return
  }

  mapInstance.value.clearMap()

  data.forEach((shop: any) => {
    if (!shop.location) {
      return
    }

    const marker = new amap.value.Marker({
      position: shop.location,
      title: shop.name,
      map: mapInstance.value
    })

    marker.setLabel({
      direction: 'top',
      offset: new amap.value.Pixel(0, -28),
      content: `<div class="map-marker-label">${shop.name}</div>`
    })
  })

  if (userMarker.value) {
    userMarker.value.setMap(mapInstance.value)
  }

  if (!userMarker.value && data.some(shop => shop.location)) {
    mapInstance.value.setFitView()
  }
}

const createUserMarker = (position: [number, number]) => {
  if (!mapInstance.value || !amap.value) {
    return
  }

  if (!userMarker.value) {
    userMarker.value = new amap.value.Marker({
      position,
      map: mapInstance.value,
      title: '当前位置',
      icon: new amap.value.Icon({
        image: 'https://a.amap.com/jsapi_demos/static/demo-center/icons/poi-marker-red.png',
        imageSize: new amap.value.Size(25, 34),
        size: new amap.value.Size(25, 34)
      }),
      offset: new amap.value.Pixel(-12, -34)
    })

    userMarker.value.setLabel({
      direction: 'top',
      offset: new amap.value.Pixel(0, -32),
      content: '<div class="map-marker-label map-marker-label--user">我在这里</div>'
    })
  } else {
    userMarker.value.setPosition(position)
    userMarker.value.setMap(mapInstance.value)
  }
}

const updateCurrentLocation = (lng: number, lat: number, formattedAddress?: string) => {
  if (formattedAddress) {
    currentLocation.value = formattedAddress
    return
  }

  if (geocoder.value) {
    geocoder.value.getAddress([lng, lat], (status: string, result: any) => {
      if (status === 'complete' && result?.regeocode) {
        currentLocation.value = result.regeocode.formattedAddress
      } else {
        currentLocation.value = `经度: ${lng.toFixed(4)}, 纬度: ${lat.toFixed(4)}`
      }
    })
  } else {
    currentLocation.value = `经度: ${lng.toFixed(4)}, 纬度: ${lat.toFixed(4)}`
  }
}

const loadNearbyShops = (lat?: number, lng?: number) => {
  loading.value = true

  const hasLocation = typeof lat === 'number' && typeof lng === 'number'
  const userPosition = hasLocation ? ([lng!, lat!] as [number, number]) : null

  const data = mockShops.map((shop) => {
    const distance = userPosition && shop.location
      ? calculateDistance(userPosition, shop.location)
      : shop.distance

    return {
      ...shop,
      distance: typeof distance === 'number' ? Number(distance.toFixed(2)) : distance
    }
  })

  if (userPosition) {
    data.sort((a, b) => {
      const distanceA = typeof a.distance === 'number' ? a.distance : Number.POSITIVE_INFINITY
      const distanceB = typeof b.distance === 'number' ? b.distance : Number.POSITIVE_INFINITY
      return distanceA - distanceB
    })

    if (mapInstance.value) {
      mapInstance.value.setZoomAndCenter(14, userPosition)
    }
  } else if (mapInstance.value && data[0]?.location) {
    mapInstance.value.setCenter(data[0].location)
  }

  shops.value = data
  renderShopMarkers(data)
  loading.value = false
}

const processLocation = (lng: number, lat: number, formattedAddress?: string) => {
  createUserMarker([lng, lat])

  if (mapInstance.value) {
    mapInstance.value.setZoomAndCenter(15, [lng, lat])
  }

  updateCurrentLocation(lng, lat, formattedAddress)
  loadNearbyShops(lat, lng)
  locationLoading.value = false
  ElMessage.success('定位成功')
}

const handleLocationSuccess = (data: any) => {
  const position = data?.position
  const lng = typeof position?.getLng === 'function' ? position.getLng() : position?.lng
  const lat = typeof position?.getLat === 'function' ? position.getLat() : position?.lat

  if (typeof lng !== 'number' || typeof lat !== 'number') {
    handleLocationError(new Error('无法获取定位坐标'))
    return
  }

  processLocation(lng, lat, data?.formattedAddress)
}

const handleLocationError = (error: any) => {
  console.error('AMap geolocation error', error)

  if (navigator.geolocation) {
    ElMessage.warning('地图定位失败，尝试使用浏览器定位')
    navigator.geolocation.getCurrentPosition(
      (position) => {
        const { latitude, longitude } = position.coords
        processLocation(longitude, latitude)
      },
      () => {
        locationLoading.value = false
        ElMessage.error('定位失败，请检查浏览器权限')
        loadNearbyShops()
      }
    )
  } else {
    locationLoading.value = false
    ElMessage.warning('浏览器不支持定位功能')
    loadNearbyShops()
  }
}

const initMap = async (): Promise<void> => {
  if (mapReady.value) {
    return
  }

  if (mapInitPromise) {
    await mapInitPromise
    return
  }

  mapInitPromise = (async () => {
    try {
      const AMap = await loadAMap()
      amap.value = AMap
      await nextTick()

      if (!mapContainer.value) {
        throw new Error('地图容器未初始化')
      }

      mapInstance.value = new AMap.Map(mapContainer.value, {
        viewMode: '2D',
        zoom: 12,
        center: mockShops[0]?.location ?? [116.397428, 39.90923]
      })

      geocoder.value = new AMap.Geocoder()
      mapReady.value = true
    } catch (error) {
      console.error('地图加载失败', error)
      ElMessage.error('地图加载失败，请稍后重试')
    } finally {
      loadNearbyShops()
    }
  })()

  await mapInitPromise
  mapInitPromise = null
}

// 获取位置
const getLocation = async () => {
  locationLoading.value = true

  try {
    await initMap()

    if (!amap.value) {
      throw new Error('高德地图未加载')
    }

    const geolocation = new amap.value.Geolocation({
      enableHighAccuracy: true,
      timeout: 10000,
      position: 'RB',
      offset: [10, 20],
      zoomToAccuracy: true,
      showCircle: true,
      showButton: false
    })

    geolocation.on('complete', handleLocationSuccess)
    geolocation.on('error', handleLocationError)
    geolocation.getCurrentPosition()
  } catch (error) {
    console.error('定位失败', error)
    ElMessage.error('定位失败，请稍后重试')
    locationLoading.value = false
  }
}

// 查看商家详情
const viewShopDetail = (shop: any) => {
  selectedShop.value = shop
  showShopDetail.value = true
}

// 预约服务
const bookService = (shop: any) => {
  bookingShopInfo.value = shop
  preSelectedServiceId.value = undefined
  showBookingDialog.value = true
  showShopDetail.value = false // 关闭商家详情对话框
}

// 预约具体服务项目
const bookServiceItem = (shop: any, item: any) => {
  bookingShopInfo.value = shop
  preSelectedServiceId.value = item.id
  showBookingDialog.value = true
  showShopDetail.value = false // 关闭商家详情对话框
}

// 预约成功回调
const handleBookingSuccess = (appointmentId: number) => {
  console.log('预约成功，ID：', appointmentId)
  ElMessage.success('预约成功！您可以在"我的预约"中查看详情')
  // 可以选择刷新预约列表或跳转到预约详情
  // activeMenu.value = 'appointments'
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
  } else {
    activeMenu.value = command
  }
}

// 初始化
onMounted(() => {
  initMap()
})
</script>

<style scoped>
.user-home {
  min-height: 100vh;
  background-color: #f5f7fa;
}

.header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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

.search-section {
  margin-bottom: 20px;
}

.map-card {
  margin-bottom: 20px;
}

.map-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 12px;
}

.map-card-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 600;
  color: #303133;
}

.map-card-location {
  font-size: 14px;
  color: #606266;
  display: flex;
  align-items: center;
  gap: 6px;
}

.map-wrapper {
  height: 360px;
  border-radius: 12px;
  overflow: hidden;
  background-color: #eef1f6;
}

.map-container {
  width: 100%;
  height: 100%;
}

:deep(.map-marker-label) {
  background: rgba(64, 158, 255, 0.92);
  color: #fff;
  padding: 4px 10px;
  border-radius: 4px;
  font-size: 12px;
  white-space: nowrap;
  box-shadow: 0 2px 8px rgba(64, 158, 255, 0.35);
}

:deep(.map-marker-label--user) {
  background: rgba(103, 194, 58, 0.95);
  box-shadow: 0 2px 8px rgba(103, 194, 58, 0.35);
}

.location-info {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 12px;
  color: #606266;
  font-size: 14px;
}

.shops-section {
  margin-top: 20px;
}

.shop-card {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;
  height: 100%;
}

.shop-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.shop-header {
  display: flex;
  gap: 15px;
  margin-bottom: 15px;
}

.shop-logo {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  object-fit: cover;
  background-color: #f5f7fa;
}

.shop-info {
  flex: 1;
}

.shop-info h3 {
  margin: 0 0 8px 0;
  font-size: 18px;
  color: #303133;
}

.shop-rating {
  display: flex;
  align-items: center;
  gap: 8px;
}

.review-count {
  font-size: 12px;
  color: #909399;
}

.shop-details {
  margin-bottom: 12px;
}

.detail-item {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  font-size: 14px;
  color: #606266;
}

.detail-item .el-icon {
  color: #909399;
}

.distance {
  color: #67c23a;
  font-size: 13px;
  font-weight: 500;
  margin-top: 8px;
}

.shop-services {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  margin-bottom: 15px;
}

.service-tag {
  font-size: 12px;
}

.book-btn {
  width: 100%;
}

.shop-detail-content {
  padding: 20px 0;
}

.section-title {
  margin: 20px 0 15px;
  font-size: 16px;
  color: #303133;
}

.price {
  color: #f56c6c;
  font-weight: 600;
  font-size: 16px;
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
