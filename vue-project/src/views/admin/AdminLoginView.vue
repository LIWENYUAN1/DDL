<script setup lang="ts">
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElButton } from 'element-plus'

const router = useRouter()

// 手动跳转到登录页面
const goToLogin = () => {
  router.replace('/login?role=admin')
}

// 生命周期
onMounted(() => {
  // 自动重定向到统一登录页面，并设置角色为管理员
  router.replace('/login?role=admin')
})
</script>

<template>
  <div class="redirect-container">
    <div class="redirect-content">
      <div class="redirect-message">
        <h2>正在跳转到统一登录页面...</h2>
        <p>为了提供更好的用户体验，所有登录功能已整合到统一登录页面</p>
        <el-button type="primary" @click="goToLogin" style="margin-top: 20px;">
          立即前往
        </el-button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.redirect-container {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  overflow: hidden;
}

.redirect-content {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 500px;
  padding: 40px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  text-align: center;
  animation: fadeIn 0.8s ease-out;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: scale(0.9);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.redirect-message h2 {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 12px;
}

.redirect-message p {
  font-size: 16px;
  color: #606266;
  line-height: 1.6;
  margin-bottom: 24px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .redirect-content {
    margin: 0 20px;
    padding: 30px 20px;
  }
  
  .redirect-message h2 {
    font-size: 20px;
  }
  
  .redirect-message p {
    font-size: 14px;
  }
}

@media (max-width: 480px) {
  .redirect-content {
    margin: 0 15px;
    padding: 25px 15px;
    border-radius: 8px;
  }
}
</style>