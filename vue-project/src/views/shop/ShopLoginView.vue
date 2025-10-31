<script setup lang="ts">
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

// 生命周期 - 重定向到统一登录页面并设置角色为shop
onMounted(() => {
  // 重定向到统一登录页面并设置商家角色
  router.replace('/login?role=shop')
})

// 所有登录功能已迁移到统一登录页面，此页面仅作为重定向使用
</script>

<template>
  <div class="redirect-container">
    <div class="redirect-content">
      <h2>正在跳转到统一登录页面...</h2>
      <p>如果没有自动跳转，请点击 <a href="/login?role=shop">这里</a></p>
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
  background: linear-gradient(135deg, #4158D0 0%, #C850C0 50%, #FFCC70 100%);
  overflow: hidden;
}

.redirect-content {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 12px;
  padding: 40px;
  text-align: center;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  animation: fadeIn 0.5s ease-out;
}

.redirect-content h2 {
  color: #4158D0;
  margin-bottom: 16px;
  font-size: 24px;
}

.redirect-content p {
  color: #606266;
  font-size: 16px;
}

.redirect-content a {
  color: #4158D0;
  text-decoration: none;
  font-weight: 500;
}

.redirect-content a:hover {
  text-decoration: underline;
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

/* 响应式设计 */
@media (max-width: 768px) {
  .redirect-content {
    padding: 30px 20px;
    margin: 0 20px;
  }
  
  .redirect-content h2 {
    font-size: 20px;
  }
  
  .redirect-content p {
    font-size: 14px;
  }
}
</style>