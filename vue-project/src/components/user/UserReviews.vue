<template>
  <div class="user-reviews">
    <el-card shadow="never">
      <template #header>
        <h3>我的评价</h3>
      </template>

      <!-- 评价列表 -->
      <div class="reviews-list" v-loading="loading">
        <el-empty 
          v-if="!loading && reviews.length === 0" 
          description="还没有评价"
        />
        
        <div 
          v-for="review in reviews" 
          :key="review.id"
          class="review-item"
        >
          <div class="review-header">
            <div class="shop-info">
              <h4>{{ review.shopName }}</h4>
              <span class="service-name">{{ review.serviceName }}</span>
            </div>
            <div class="review-meta">
              <el-rate v-model="review.score" disabled show-score />
              <span class="review-date">{{ review.createTime }}</span>
            </div>
          </div>
          
          <div class="review-content">
            <p>{{ review.content }}</p>
            <div v-if="review.images && review.images.length > 0" class="review-images">
              <el-image
                v-for="(img, index) in review.images"
                :key="index"
                :src="img"
                :preview-src-list="review.images"
                fit="cover"
                class="review-image"
              />
            </div>
          </div>
          
          <div v-if="review.reply" class="shop-reply">
            <div class="reply-label">商家回复：</div>
            <p>{{ review.reply }}</p>
            <span class="reply-time">{{ review.replyTime }}</span>
          </div>
        </div>
      </div>

      <!-- 分页 -->
      <el-pagination
        v-if="total > 0"
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :total="total"
        :page-sizes="[10, 20, 50]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        class="pagination"
      />
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'

// 状态
const loading = ref(false)
const reviews = ref<any[]>([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

// 模拟数据
const mockReviews = [
  {
    id: 1,
    shopName: '极速摩托维修店',
    serviceName: '更换机油',
    score: 5,
    content: '服务很专业，师傅很细心，价格也公道，下次还会来！',
    images: [],
    createTime: '2025-01-20 15:30',
    reply: '感谢您的支持，期待您的下次光临！',
    replyTime: '2025-01-20 18:00'
  },
  {
    id: 2,
    shopName: '专业摩托保养中心',
    serviceName: '定期保养套餐',
    score: 4,
    content: '整体还不错，就是等待时间有点长。',
    images: [],
    createTime: '2025-01-18 10:15',
    reply: null,
    replyTime: null
  }
]

// 分页处理
const handleSizeChange = (val: number) => {
  pageSize.value = val
  loadReviews()
}

const handleCurrentChange = (val: number) => {
  currentPage.value = val
  loadReviews()
}

// 加载评价列表
const loadReviews = async () => {
  loading.value = true
  try {
    // const response = await reviewApi.getUserReviews({
    //   page: currentPage.value,
    //   pageSize: pageSize.value
    // })
    // reviews.value = response.data.records
    // total.value = response.data.total
    
    // 模拟数据
    reviews.value = mockReviews
    total.value = mockReviews.length
  } catch (error) {
    ElMessage.error('加载失败')
  } finally {
    loading.value = false
  }
}

// 初始化
onMounted(() => {
  loadReviews()
})
</script>

<style scoped>
.user-reviews {
  width: 100%;
}

.card-header h3 {
  margin: 0;
  font-size: 18px;
}

.reviews-list {
  min-height: 300px;
}

.review-item {
  padding: 20px;
  border-bottom: 1px solid #e0e0e0;
}

.review-item:last-child {
  border-bottom: none;
}

.review-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 15px;
}

.shop-info h4 {
  margin: 0 0 5px 0;
  font-size: 16px;
  color: #303133;
}

.service-name {
  font-size: 14px;
  color: #909399;
}

.review-meta {
  text-align: right;
}

.review-date {
  display: block;
  margin-top: 5px;
  font-size: 12px;
  color: #909399;
}

.review-content p {
  margin: 0 0 10px 0;
  line-height: 1.6;
  color: #606266;
}

.review-images {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.review-image {
  width: 100px;
  height: 100px;
  border-radius: 4px;
  cursor: pointer;
}

.shop-reply {
  margin-top: 15px;
  padding: 15px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.reply-label {
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
}

.shop-reply p {
  margin: 0 0 8px 0;
  color: #606266;
  line-height: 1.6;
}

.reply-time {
  font-size: 12px;
  color: #909399;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>


