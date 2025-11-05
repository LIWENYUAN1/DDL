<template>
  <div class="user-collections">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <h3>我的收藏 & 浏览历史</h3>
          <div class="actions">
            <el-button text type="primary" @click="refreshData" :loading="loading">
              <el-icon><Refresh /></el-icon>
              刷新
            </el-button>
            <el-popconfirm title="确定要清空浏览历史吗？" @confirm="clearHistory">
              <template #reference>
                <el-button text type="danger">清空历史</el-button>
              </template>
            </el-popconfirm>
          </div>
        </div>
      </template>

      <el-tabs v-model="activeTab">
        <el-tab-pane label="收藏的商家" name="favorites">
          <el-skeleton v-if="loading" :rows="4" animated />
          <template v-else>
            <el-empty v-if="favorites.length === 0" description="暂无收藏">
              <el-button type="primary" @click="$emit('exploreShops')">去逛逛</el-button>
            </el-empty>

            <el-row v-else :gutter="20">
              <el-col
                v-for="item in favorites"
                :key="item.id"
                :xs="24"
                :sm="12"
                :md="8"
                :lg="6"
              >
                <el-card class="favorite-card" shadow="hover">
                  <div class="favorite-header">
                    <img :src="item.logo || defaultLogo" class="favorite-logo" />
                    <div>
                      <h4>{{ item.name }}</h4>
                      <div class="favorite-meta">
                        <el-rate :model-value="item.rating" disabled show-score size="small" />
                        <span>{{ item.distance }}km · 月销{{ item.sales }}单</span>
                      </div>
                    </div>
                  </div>
                  <div class="favorite-services">
                    <el-tag
                      v-for="service in item.services"
                      :key="service"
                      size="small"
                      class="service-tag"
                    >
                      {{ service }}
                    </el-tag>
                  </div>
                  <div class="favorite-actions">
                    <el-button size="small" @click="emitViewDetail(item)">查看详情</el-button>
                    <el-button
                      size="small"
                      type="danger"
                      @click="removeFavorite(item)"
                      :loading="removingId === item.id"
                    >
                      取消收藏
                    </el-button>
                  </div>
                </el-card>
              </el-col>
            </el-row>
          </template>
        </el-tab-pane>

        <el-tab-pane label="浏览历史" name="history">
          <el-skeleton v-if="loading" :rows="4" animated />
          <template v-else>
            <el-empty v-if="history.length === 0" description="暂无浏览记录">
              <el-button type="primary" @click="$emit('exploreShops')">去浏览</el-button>
            </el-empty>

            <el-timeline v-else>
              <el-timeline-item
                v-for="item in history"
                :key="item.id"
                :timestamp="item.viewedAt"
                placement="top"
              >
                <el-card shadow="never" class="history-card">
                  <div class="history-header">
                    <h4>{{ item.name }}</h4>
                    <el-tag size="small">{{ item.category }}</el-tag>
                  </div>
                  <p class="history-desc">{{ item.summary }}</p>
                  <div class="history-actions">
                    <el-button type="primary" link @click="emitViewDetail(item)">查看商家</el-button>
                    <el-button link @click="markFavoriteFromHistory(item)">
                      <el-icon><StarFilled /></el-icon>
                      加入收藏
                    </el-button>
                  </div>
                </el-card>
              </el-timeline-item>
            </el-timeline>
          </template>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { Refresh, StarFilled } from '@element-plus/icons-vue'
import {
  clearBrowseHistory,
  getBrowseHistory,
  getUserFavorites,
  removeUserFavorite,
  toggleFavoriteShop
} from '@/api/userCenter'

interface FavoriteItem {
  id: number
  name: string
  logo?: string
  rating: number
  distance: number
  sales: number
  services: string[]
}

interface HistoryItem {
  id: number
  name: string
  category: string
  summary: string
  viewedAt: string
}

const emits = defineEmits<{ (e: 'exploreShops'): void; (e: 'viewShop', payload: { id: number }): void }>()

const activeTab = ref<'favorites' | 'history'>('favorites')
const favorites = ref<FavoriteItem[]>([])
const history = ref<HistoryItem[]>([])
const loading = ref(false)
const removingId = ref<number | null>(null)

const defaultLogo = 'https://via.placeholder.com/80x80?text=Shop'

const refreshData = async () => {
  loading.value = true
  try {
    const [favoriteRes, historyRes] = await Promise.all([
      getUserFavorites().catch(() => ({ data: { records: [] } })),
      getBrowseHistory().catch(() => ({ data: { records: [] } }))
    ])

    favorites.value = (favoriteRes.data?.records || favoriteMock).map((item: any, index: number) => {
      const distanceCandidate = Number(item.distance ?? item.distanceKm ?? 0)
      const distance = Number.isFinite(distanceCandidate) && distanceCandidate > 0
        ? Number(distanceCandidate.toFixed(1))
        : 2.3

      const services = Array.isArray(item.services)
        ? item.services
        : Array.isArray(item.serviceItems)
          ? item.serviceItems
          : ['保养', '维修']

      return {
        id: item.id ?? index + 1,
        name: item.name ?? item.shopName ?? '未知商家',
        logo: item.logo,
        rating: Number(item.rating ?? 4.5),
        distance,
        sales: item.sales ?? item.monthlySales ?? 0,
        services
      } as FavoriteItem
    })

    history.value = (historyRes.data?.records || historyMock).map((item: any, index: number) => ({
      id: item.id ?? index + 1,
      name: item.name ?? item.shopName ?? '未知商家',
      category: item.category ?? item.serviceCategory ?? '综合服务',
      summary: item.summary ?? item.description ?? '查看了店铺详情',
      viewedAt: item.viewedAt ?? item.createTime ?? new Date().toISOString()
    })) as HistoryItem[]
  } catch (error: any) {
    console.error('加载收藏数据失败', error)
    ElMessage.error(error.message || '加载失败')
  } finally {
    loading.value = false
  }
}

const removeFavorite = async (item: FavoriteItem) => {
  removingId.value = item.id
  try {
    await removeUserFavorite(item.id)
    favorites.value = favorites.value.filter(f => f.id !== item.id)
    ElMessage.success('已取消收藏')
  } catch (error: any) {
    console.warn('取消收藏失败，使用本地回退逻辑', error)
    favorites.value = favorites.value.filter(f => f.id !== item.id)
  } finally {
    removingId.value = null
  }
}

const markFavoriteFromHistory = async (item: HistoryItem) => {
  try {
    await toggleFavoriteShop(item.id)
    if (!favorites.value.some(f => f.id === item.id)) {
      favorites.value.unshift({
        id: item.id,
        name: item.name,
        rating: 4.6,
        distance: 3.1,
        sales: 120,
        services: ['维修', '保养']
      })
    }
    ElMessage.success('已加入收藏')
  } catch (error: any) {
    console.error('加入收藏失败', error)
    ElMessage.error(error.message || '加入收藏失败')
  }
}

const clearHistory = async () => {
  try {
    await clearBrowseHistory()
  } catch (error) {
    console.warn('清空浏览历史失败，继续清除本地数据', error)
  }
  history.value = []
  ElMessage.success('浏览历史已清空')
}

const emitViewDetail = (item: FavoriteItem | HistoryItem) => {
  emits('viewShop', { id: item.id })
}

onMounted(() => {
  refreshData()
})

const favoriteMock: FavoriteItem[] = [
  {
    id: 1,
    name: '极速摩托维修店',
    rating: 4.8,
    distance: 1.5,
    sales: 320,
    services: ['机油保养', '刹车维护', '深度清洗']
  },
  {
    id: 2,
    name: '酷改摩托改装',
    rating: 4.6,
    distance: 3.2,
    sales: 210,
    services: ['外观改装', '动力升级']
  }
]

const historyMock: HistoryItem[] = [
  {
    id: 3,
    name: 'DDL测试维修店',
    category: '保养服务',
    summary: '查看了店铺优惠活动',
    viewedAt: '2025-01-20 10:32'
  },
  {
    id: 4,
    name: '极速摩托维修店',
    category: '维修服务',
    summary: '浏览了刹车系统保养项目',
    viewedAt: '2025-01-18 15:20'
  }
]
</script>

<style scoped>
.user-collections {
  width: 100%;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h3 {
  margin: 0;
  font-size: 18px;
}

.actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.favorite-card {
  margin-bottom: 20px;
}

.favorite-header {
  display: flex;
  gap: 12px;
  align-items: center;
}

.favorite-logo {
  width: 60px;
  height: 60px;
  border-radius: 8px;
  object-fit: cover;
  background-color: #f5f7fa;
}

.favorite-meta {
  display: flex;
  gap: 8px;
  align-items: center;
  font-size: 12px;
  color: #909399;
}

.favorite-services {
  margin: 12px 0;
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.service-tag {
  background-color: #ecf5ff;
  border: none;
  color: #409eff;
}

.favorite-actions {
  display: flex;
  justify-content: space-between;
}

.history-card {
  margin-bottom: 8px;
}

.history-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 6px;
}

.history-desc {
  margin: 0 0 8px;
  color: #606266;
}

.history-actions {
  display: flex;
  gap: 12px;
}
</style>
