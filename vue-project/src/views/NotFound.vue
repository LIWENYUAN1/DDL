<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const count = ref(5)

onMounted(() => {
  // 5秒后自动返回首页
  const timer = setInterval(() => {
    count.value--
    if (count.value <= 0) {
      clearInterval(timer)
      router.push('/')
    }
  }, 1000)

  return () => clearInterval(timer)
})

const goHome = () => {
  router.push('/')
}
</script>

<template>
  <div class="not-found-container">
    <div class="not-found-content">
      <div class="error-code">404</div>
      <h2 class="error-title">页面不存在</h2>
      <p class="error-message">
        抱歉，您访问的页面不存在或已被删除。
        您将在 <span class="countdown">{{ count }}</span> 秒后自动返回首页。
      </p>
      <div class="error-actions">
        <button class="btn-primary" @click="goHome">
          返回首页
        </button>
        <button class="btn-secondary" @click="router.back()">
          返回上一页
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.btn-primary {
  padding: 8px 16px;
  background-color: #409eff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  margin-right: 10px;
}

.btn-primary:hover {
  background-color: #66b1ff;
}

.btn-secondary {
  padding: 8px 16px;
  background-color: #f0f0f0;
  color: #333;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  cursor: pointer;
}

.btn-secondary:hover {
  background-color: #e6e6e6;
}
.not-found-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-color: #f5f7fa;
}

.not-found-content {
  text-align: center;
  background-color: #ffffff;
  padding: 40px;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  max-width: 500px;
  width: 90%;
}

.error-code {
  font-size: 80px;
  font-weight: bold;
  color: #409eff;
  margin-bottom: 20px;
  line-height: 1;
}

.error-title {
  font-size: 24px;
  color: #303133;
  margin-bottom: 15px;
  font-weight: 500;
}

.error-message {
  font-size: 16px;
  color: #606266;
  margin-bottom: 30px;
  line-height: 1.5;
}

.countdown {
  color: #409eff;
  font-weight: bold;
  font-size: 20px;
}

.error-actions {
  display: flex;
  justify-content: center;
  gap: 15px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .error-code {
    font-size: 60px;
  }
  
  .error-title {
    font-size: 20px;
  }
  
  .error-message {
    font-size: 14px;
  }
  
  .not-found-content {
    padding: 30px 20px;
  }
}

@media (max-width: 480px) {
  .error-code {
    font-size: 50px;
  }
  
  .error-actions {
    flex-direction: column;
    align-items: center;
  }
  
  .error-actions .el-button {
    width: 100%;
    max-width: 200px;
  }
}
</style>