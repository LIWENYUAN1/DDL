<template>
  <div class="login-page">
    <!-- 动态粒子背景 -->
    <div class="particles-bg">
      <div class="particle" v-for="i in 50" :key="i" :style="getParticleStyle(i)"></div>
    </div>

    <!-- 背景装饰圆圈 -->
    <div class="bg-decoration">
      <div class="circle circle-1"></div>
      <div class="circle circle-2"></div>
      <div class="circle circle-3"></div>
      <div class="gradient-orb orb-1"></div>
      <div class="gradient-orb orb-2"></div>
    </div>

    <!-- 登录内容区域 -->
    <div class="login-content">
      <div class="login-card" :class="{ 'card-shake': loginError }">
        <!-- Logo和标题 -->
        <div class="login-logo">
          <div class="logo-icon" :class="{ 'logo-spin': isLoading }">
            <el-icon :size="48"><Tools /></el-icon>
            <div class="logo-ring"></div>
            <div class="logo-ring ring-2"></div>
          </div>
          <h1 class="platform-name">
            <span class="word" v-for="(char, index) in platformTitle" :key="index" :style="{ animationDelay: index * 0.1 + 's' }">
              {{ char }}
            </span>
          </h1>
          <p class="platform-desc">
            <el-icon class="desc-icon"><Star /></el-icon>
            专业的摩托车维修、保养与配件服务
            <el-icon class="desc-icon"><Star /></el-icon>
          </p>
        </div>

        <!-- 登录表单 -->
        <LoginForm @login-success="handleLoginSuccess" @loading="handleLoading" />

        <!-- 底部链接 -->
        <div class="login-footer-links">
          <router-link to="/" class="footer-link">
            <el-icon><HomeFilled /></el-icon>
            <span>返回首页</span>
          </router-link>
          <router-link to="/register" class="footer-link primary">
            <el-icon><UserFilled /></el-icon>
            <span>还没有账号？立即注册</span>
          </router-link>
        </div>
      </div>
      
      <!-- 特色标签 -->
      <div class="feature-tags">
        <div class="tag" v-for="(tag, index) in featureTags" :key="index" :style="{ animationDelay: index * 0.2 + 's' }">
          <el-icon><component :is="tag.icon" /></el-icon>
          <span>{{ tag.text }}</span>
        </div>
      </div>
    </div>
    
    <!-- 页脚版权信息 -->
    <div class="login-footer">
      <p>&copy; 2025 摩托车服务平台 | 提供专业的摩托车维修、保养与配件服务</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Tools, UserFilled, Star, HomeFilled, Location, Calendar, Setting } from '@element-plus/icons-vue'
import LoginForm from '../components/common/LoginForm.vue'

const router = useRouter()
const platformTitle = '摩托车服务平台'
const isLoading = ref(false)
const loginError = ref(false)

// 特色标签
const featureTags = [
  { icon: Location, text: '附近商家' },
  { icon: Calendar, text: '在线预约' },
  { icon: Setting, text: '专业服务' }
]

// 生成粒子样式
const getParticleStyle = (index: number) => {
  const size = Math.random() * 4 + 2
  const duration = Math.random() * 20 + 10
  const delay = Math.random() * 5
  const left = Math.random() * 100
  const opacity = Math.random() * 0.5 + 0.1
  
  return {
    width: `${size}px`,
    height: `${size}px`,
    left: `${left}%`,
    animationDuration: `${duration}s`,
    animationDelay: `${delay}s`,
    opacity: opacity
  }
}

const handleLoading = (loading: boolean) => {
  isLoading.value = loading
}

const handleLoginSuccess = (formData: { username: string; role: string }) => {
  console.log('登录成功回调:', formData)
  
  // 登录成功后根据角色跳转到对应首页
  const role = formData.role
  localStorage.setItem('role', role)
  
  const roleHomePage: Record<string, string> = {
    'user': '/user/home',
    'shop': '/shop/home',
    'admin': '/admin/home'
  }
  
  // 延迟跳转，让用户看到成功消息
  setTimeout(() => {
    const targetPath = roleHomePage[role] || '/'
    console.log('准备跳转到:', targetPath)
    router.push(targetPath)
  }, 800)
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 20px;
  position: relative;
  overflow: hidden;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

/* 粒子背景 */
.particles-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 0;
}

.particle {
  position: absolute;
  background: rgba(255, 255, 255, 0.6);
  border-radius: 50%;
  animation: particleFloat linear infinite;
  bottom: -10px;
}

@keyframes particleFloat {
  0% {
    transform: translateY(0) translateX(0) rotate(0deg);
    opacity: 0;
  }
  10% {
    opacity: 1;
  }
  90% {
    opacity: 1;
  }
  100% {
    transform: translateY(-100vh) translateX(100px) rotate(360deg);
    opacity: 0;
  }
}

/* 背景装饰 */
.bg-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 0;
}

.circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.08);
  animation: float 20s infinite ease-in-out;
  filter: blur(2px);
}

.circle-1 {
  width: 400px;
  height: 400px;
  top: -200px;
  left: -200px;
  animation-delay: 0s;
}

.circle-2 {
  width: 300px;
  height: 300px;
  bottom: -150px;
  right: -150px;
  animation-delay: 5s;
}

.circle-3 {
  width: 250px;
  height: 250px;
  top: 40%;
  right: 5%;
  animation-delay: 10s;
}

.gradient-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(40px);
  animation: orbFloat 15s infinite ease-in-out;
}

.orb-1 {
  width: 200px;
  height: 200px;
  background: rgba(255, 255, 255, 0.15);
  top: 20%;
  left: 10%;
}

.orb-2 {
  width: 250px;
  height: 250px;
  background: rgba(118, 75, 162, 0.2);
  bottom: 15%;
  right: 15%;
  animation-delay: 7s;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0) rotate(0deg);
  }
  50% {
    transform: translateY(-30px) rotate(180deg);
  }
}

@keyframes orbFloat {
  0%, 100% {
    transform: translate(0, 0) scale(1);
  }
  33% {
    transform: translate(30px, -30px) scale(1.1);
  }
  66% {
    transform: translate(-30px, 30px) scale(0.9);
  }
}

.login-content {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 480px;
}

.login-card {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 24px;
  padding: 50px 40px;
  box-shadow: 0 25px 80px rgba(0, 0, 0, 0.35);
  backdrop-filter: blur(20px);
  animation: slideUp 0.8s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid rgba(255, 255, 255, 0.3);
  position: relative;
  overflow: hidden;
}

.login-card::before {
  content: '';
  position: absolute;
  top: -2px;
  left: -2px;
  right: -2px;
  bottom: -2px;
  background: linear-gradient(45deg, #667eea, #764ba2, #667eea);
  border-radius: 24px;
  z-index: -1;
  animation: borderRotate 3s linear infinite;
  opacity: 0.3;
}

@keyframes borderRotate {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.card-shake {
  animation: shake 0.5s;
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(-10px); }
  75% { transform: translateX(10px); }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(40px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

.login-logo {
  text-align: center;
  margin-bottom: 35px;
}

.logo-icon {
  width: 90px;
  height: 90px;
  margin: 0 auto 24px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  box-shadow: 0 10px 30px rgba(102, 126, 234, 0.5);
  position: relative;
  animation: logoFloat 3s ease-in-out infinite;
}

.logo-spin {
  animation: logoSpin 1s linear infinite !important;
}

.logo-ring {
  position: absolute;
  width: 110%;
  height: 110%;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 24px;
  animation: ringPulse 2s ease-in-out infinite;
}

.logo-ring.ring-2 {
  animation-delay: 1s;
  width: 120%;
  height: 120%;
}

@keyframes logoFloat {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

@keyframes logoSpin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

@keyframes ringPulse {
  0%, 100% {
    opacity: 0;
    transform: scale(0.8);
  }
  50% {
    opacity: 1;
    transform: scale(1.2);
  }
}

.platform-name {
  font-size: 32px;
  font-weight: 700;
  margin: 0 0 12px 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: 1px;
}

.platform-name .word {
  display: inline-block;
  animation: wordFadeIn 0.8s ease-out both;
}

@keyframes wordFadeIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.platform-desc {
  font-size: 14px;
  color: #909399;
  margin: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.desc-icon {
  color: #f6d365;
  animation: starTwinkle 2s ease-in-out infinite;
}

.desc-icon:nth-child(3) {
  animation-delay: 1s;
}

@keyframes starTwinkle {
  0%, 100% {
    opacity: 0.3;
    transform: scale(0.8);
  }
  50% {
    opacity: 1;
    transform: scale(1.2);
  }
}

.login-footer-links {
  margin-top: 30px;
  display: flex;
  justify-content: center;
  gap: 12px;
  flex-wrap: wrap;
}

.footer-link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 24px;
  color: #667eea;
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  border-radius: 12px;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  background: rgba(102, 126, 234, 0.08);
  border: 1.5px solid transparent;
}

.footer-link:hover {
  background: rgba(102, 126, 234, 0.15);
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
  border-color: rgba(102, 126, 234, 0.3);
}

.footer-link.primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
}

.footer-link.primary:hover {
  transform: translateY(-3px) scale(1.05);
  box-shadow: 0 12px 30px rgba(102, 126, 234, 0.4);
}

/* 特色标签 */
.feature-tags {
  margin-top: 24px;
  display: flex;
  justify-content: center;
  gap: 16px;
  flex-wrap: wrap;
}

.feature-tags .tag {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 20px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 16px;
  color: #667eea;
  font-size: 14px;
  font-weight: 600;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
  animation: tagFadeIn 0.6s ease-out both;
  transition: all 0.3s;
  backdrop-filter: blur(10px);
}

.feature-tags .tag:hover {
  transform: translateY(-5px) scale(1.05);
  box-shadow: 0 12px 30px rgba(102, 126, 234, 0.3);
}

@keyframes tagFadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.login-footer {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  text-align: center;
  padding: 20px;
  z-index: 1;
}

.login-footer p {
  color: rgba(255, 255, 255, 0.9);
  font-size: 13px;
  margin: 0;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .login-page {
    padding: 16px;
  }
  
  .login-card {
    padding: 40px 24px;
  }
  
  .logo-icon {
    width: 75px;
    height: 75px;
  }
  
  .platform-name {
    font-size: 26px;
  }
  
  .login-footer {
    position: relative;
    margin-top: 30px;
  }
  
  .login-footer-links {
    flex-direction: column;
  }
  
  .feature-tags {
    gap: 12px;
  }
  
  .feature-tags .tag {
    font-size: 13px;
    padding: 10px 16px;
  }
}

@media (max-width: 480px) {
  .login-card {
    padding: 35px 20px;
  }
  
  .platform-name {
    font-size: 24px;
  }
  
  .login-footer p {
    font-size: 12px;
  }
  
  .footer-link {
    padding: 10px 20px;
    font-size: 13px;
  }
}
</style>
