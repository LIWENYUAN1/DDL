<template>
  <div class="shop-reviews">
    <div class="page-header">
      <h1>客户评价互动</h1>
      <el-button :loading="loading" @click="loadReviews">
        <el-icon><Refresh /></el-icon>
        刷新
      </el-button>
    </div>

    <el-card class="review-card" shadow="never">
      <template v-if="loading">
        <el-skeleton :rows="4" animated />
      </template>

      <template v-else>
        <el-empty
          v-if="!reviews.length"
          :description="emptyDescription"
        >
          <el-button type="primary" @click="loadReviews">重新加载</el-button>
        </el-empty>

        <div v-else class="review-list">
          <div
            v-for="review in reviews"
            :key="review.id"
            class="review-item"
          >
            <div class="review-item__header">
              <div class="review-item__user">
                <el-avatar :size="40">
                  <el-icon><UserFilled /></el-icon>
                </el-avatar>
                <div class="review-item__user-info">
                  <span class="review-item__user-name">{{ review.userName }}</span>
                  <span class="review-item__order">预约单号：{{ review.orderNo || '未知' }}</span>
                </div>
              </div>

              <div class="review-item__score">
                <el-rate :model-value="review.score" disabled show-score />
                <span class="review-item__time">{{ review.createTime }}</span>
              </div>
            </div>

            <div class="review-item__service">
              <span class="label">服务项目</span>
              <span>{{ review.serviceItemName || '服务项目' }}</span>
            </div>

            <div class="review-item__content">
              <p>{{ review.content || '暂无评价内容' }}</p>
              <div v-if="review.imgList.length" class="review-item__images">
                <el-image
                  v-for="(img, index) in review.imgList"
                  :key="index"
                  :src="img"
                  :preview-src-list="review.imgList"
                  fit="cover"
                  class="review-item__image"
                />
              </div>
            </div>

            <div class="review-item__scores" v-if="hasSubScores(review)">
              <div v-if="review.serviceScore !== null">
                <span class="label">服务评分</span>
                <el-rate :model-value="review.serviceScore" disabled />
              </div>
              <div v-if="review.qualityScore !== null">
                <span class="label">质量评分</span>
                <el-rate :model-value="review.qualityScore" disabled />
              </div>
              <div v-if="review.attitudeScore !== null">
                <span class="label">态度评分</span>
                <el-rate :model-value="review.attitudeScore" disabled />
              </div>
            </div>

            <div v-if="review.replyContent" class="review-item__reply">
              <div class="reply-header">
                <el-icon><ChatDotSquare /></el-icon>
                <span>我的回复</span>
                <span class="reply-time">{{ review.replyTime }}</span>
              </div>
              <p>{{ review.replyContent }}</p>
            </div>

            <div class="review-item__actions">
              <el-button
                type="primary"
                @click="openReplyDialog(review)"
              >
                {{ review.replyContent ? '修改回复' : '回复评价' }}
              </el-button>
            </div>
          </div>
        </div>
      </template>
    </el-card>

    <el-dialog
      v-model="replyDialogVisible"
      title="回复客户评价"
      width="500px"
      destroy-on-close
    >
      <el-form :model="replyForm" label-width="80px">
        <el-form-item label="评价内容">
          <div class="reply-preview">
            <p>{{ selectedReview?.content || '暂无评价内容' }}</p>
            <span class="reply-preview__time">{{ selectedReview?.createTime }}</span>
          </div>
        </el-form-item>
        <el-form-item label="回复内容" required>
          <el-input
            v-model="replyForm.replyContent"
            type="textarea"
            :rows="4"
            maxlength="300"
            show-word-limit
            placeholder="请输入回复内容，与客户保持良好沟通"
          />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="replyDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="replySubmitting" @click="submitReply">
          提交回复
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { Refresh, UserFilled, ChatDotSquare } from '@element-plus/icons-vue'
import { getMerchantReviews, replyReview } from '@/api/review'
import { mapReviewResponse, type ReviewItem, formatDateTime } from '@/utils/review'

const loading = ref(false)
const reviews = ref<ReviewItem[]>([])
const replyDialogVisible = ref(false)
const replySubmitting = ref(false)
const selectedReview = ref<ReviewItem | null>(null)

const replyForm = reactive({
  reviewId: 0,
  replyContent: ''
})

const mockMerchantReviews: ReviewItem[] = [
  {
    id: 1001,
    appointmentId: 2001,
    orderNo: 'APT20250123001',
    serviceItemName: '精品洗车',
    merchantName: '我的门店',
    userName: '匿名用户',
    isAnonymous: true,
    score: 5,
    serviceScore: 5,
    qualityScore: 5,
    attitudeScore: 5,
    content: '店里环境很好，洗完车像新的一样，点赞！',
    imgList: [],
    createTime: '2025-01-23 11:20',
    replyContent: '感谢您的信任，我们会继续努力！',
    replyTime: '2025-01-23 13:05'
  },
  {
    id: 1002,
    appointmentId: 2003,
    orderNo: 'APT20250121008',
    serviceItemName: '保养套餐',
    merchantName: '我的门店',
    userName: '李先生',
    isAnonymous: false,
    score: 4,
    serviceScore: 4,
    qualityScore: 4,
    attitudeScore: 4,
    content: '整体不错，就是等待时间稍长，希望可以提前预约。',
    imgList: [],
    createTime: '2025-01-21 16:42',
    replyContent: '',
    replyTime: ''
  }
]

const emptyDescription = computed(() => {
  if (!loading.value && !reviews.value.length) {
    return '暂时没有新的评价，继续保持优质服务吧～'
  }
  return '暂无数据'
})

const hasSubScores = (review: ReviewItem) => {
  return [review.serviceScore, review.qualityScore, review.attitudeScore].some(
    (score) => score !== null && score !== undefined
  )
}

const loadReviews = async () => {
  loading.value = true
  try {
    const response = await getMerchantReviews()
    if (response.code === 200) {
      if (Array.isArray(response.data)) {
        reviews.value = response.data.map((item: any) => mapReviewResponse(item))
      } else {
        if (typeof response.data === 'string' && response.data) {
          ElMessage.info(response.data)
        }
        reviews.value = mockMerchantReviews
      }
    } else {
      throw new Error(response.msg || '获取评价失败')
    }
  } catch (error: any) {
    console.error('获取商家评价失败：', error)
    ElMessage.warning(error?.message || '暂未获取到评价，已展示示例数据')
    reviews.value = mockMerchantReviews
  } finally {
    loading.value = false
  }
}

const openReplyDialog = (review: ReviewItem) => {
  selectedReview.value = review
  replyForm.reviewId = review.id
  replyForm.replyContent = review.replyContent
  replyDialogVisible.value = true
}

const submitReply = async () => {
  if (!replyForm.replyContent.trim()) {
    ElMessage.warning('请输入回复内容')
    return
  }
  try {
    replySubmitting.value = true
    const response = await replyReview(replyForm.reviewId, replyForm.replyContent.trim())
    if (response.code === 200) {
      const target = reviews.value.find((item) => item.id === replyForm.reviewId)
      if (target) {
        target.replyContent = replyForm.replyContent.trim()
        target.replyTime = formatDateTime(new Date().toISOString())
      }
      ElMessage.success(response.msg || '回复成功')
      replyDialogVisible.value = false
    } else {
      throw new Error(response.msg || '回复失败')
    }
  } catch (error: any) {
    console.error('回复评价失败：', error)
    ElMessage.error(error?.message || '回复失败，请稍后再试')
  } finally {
    replySubmitting.value = false
  }
}

onMounted(() => {
  loadReviews()
})
</script>

<style scoped>
.shop-reviews {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-header h1 {
  margin: 0;
  font-size: 22px;
  font-weight: 600;
  color: #303133;
}

.review-card {
  min-height: 300px;
}

.review-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.review-item {
  padding: 20px;
  border: 1px solid #ebeef5;
  border-radius: 12px;
  transition: box-shadow 0.3s ease;
}

.review-item:hover {
  box-shadow: 0 10px 30px -12px rgba(64, 158, 255, 0.4);
}

.review-item__header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 12px;
  margin-bottom: 16px;
}

.review-item__user {
  display: flex;
  align-items: center;
  gap: 12px;
}

.review-item__user-name {
  font-weight: 600;
  color: #303133;
}

.review-item__user-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
  font-size: 13px;
  color: #909399;
}

.review-item__score {
  text-align: right;
}

.review-item__time {
  display: block;
  margin-top: 6px;
  font-size: 12px;
  color: #909399;
}

.review-item__service {
  display: flex;
  gap: 10px;
  align-items: center;
  margin-bottom: 12px;
  font-size: 14px;
  color: #606266;
}

.review-item__service .label {
  font-weight: 600;
  color: #303133;
}

.review-item__content {
  margin-bottom: 12px;
  line-height: 1.6;
  color: #606266;
}

.review-item__images {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  margin-top: 10px;
}

.review-item__image {
  width: 90px;
  height: 90px;
  border-radius: 6px;
  object-fit: cover;
}

.review-item__scores {
  display: grid;
  gap: 12px;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  margin-bottom: 12px;
}

.review-item__scores .label {
  margin-right: 6px;
  color: #303133;
  font-weight: 600;
}

.review-item__reply {
  padding: 14px;
  background-color: #ecf5ff;
  border-radius: 8px;
  margin-bottom: 12px;
  color: #409eff;
}

.review-item__reply .reply-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  font-weight: 600;
}

.review-item__reply p {
  margin: 0;
  color: #606266;
  line-height: 1.6;
}

.review-item__reply .reply-time {
  margin-left: auto;
  font-size: 12px;
  color: #909399;
}

.review-item__actions {
  display: flex;
  justify-content: flex-end;
}

.reply-preview {
  padding: 12px;
  background-color: #f5f7fa;
  border-radius: 6px;
  color: #606266;
  line-height: 1.6;
}

.reply-preview__time {
  display: block;
  margin-top: 8px;
  font-size: 12px;
  color: #909399;
}

@media (max-width: 768px) {
  .review-item {
    padding: 16px;
  }

  .review-item__header {
    flex-direction: column;
    align-items: flex-start;
  }

  .review-item__score {
    text-align: left;
  }
}
</style>
