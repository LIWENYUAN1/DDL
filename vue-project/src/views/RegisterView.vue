<template>
  <div class="register-page">
    <!-- 动态粒子背景 -->
    <div class="particles-bg">
      <div class="particle" v-for="i in 40" :key="i" :style="getParticleStyle(i)"></div>
    </div>

    <!-- 背景装饰 -->
    <div class="bg-decoration">
      <div class="wave wave-1"></div>
      <div class="wave wave-2"></div>
      <div class="wave wave-3"></div>
      <div class="gradient-orb orb-1"></div>
      <div class="gradient-orb orb-2"></div>
    </div>

    <div class="register-content">
      <div class="register-card" :class="{ 'card-pulse': showSuccess }">
        <!-- Logo和标题 -->
        <div class="register-header">
          <div class="logo-icon" :class="{ 'logo-bounce': isRegistering }">
            <el-icon :size="40"><Tools /></el-icon>
            <div class="logo-glow"></div>
          </div>
          <h1 class="platform-name">
            <span class="word" v-for="(char, index) in '创建账号'" :key="index" :style="{ animationDelay: index * 0.08 + 's' }">
              {{ char }}
            </span>
          </h1>
          <p class="platform-desc">
            <el-icon class="star-icon"><Star /></el-icon>
            加入摩托车服务平台
            <el-icon class="star-icon"><Star /></el-icon>
          </p>
        </div>

        <!-- 角色选择 -->
        <div class="role-selector">
          <div class="role-selector-label">
            <el-icon><Setting /></el-icon>
            <span>选择注册类型</span>
          </div>
          <el-segmented v-model="selectedRole" :options="roleOptions" size="large">
            <template #default="{ item }">
              <div class="role-option">
                <el-icon :size="20">
                  <component :is="item.icon" />
                </el-icon>
                <span>{{ item.label }}</span>
              </div>
            </template>
          </el-segmented>
        </div>
        
        <!-- 注册表单 -->
        <div class="form-container">
          <RegisterForm 
            :role="selectedRole"
            @registerSuccess="handleRegisterSuccess"
            @registering="handleRegistering"
          />
        </div>

        <!-- 底部链接 -->
        <div class="register-footer-links">
          <router-link to="/" class="footer-link">
            <el-icon><HomeFilled /></el-icon>
            <span>返回首页</span>
          </router-link>
          <router-link to="/login" class="footer-link primary">
            <el-icon><ArrowLeft /></el-icon>
            <span>已有账号？立即登录</span>
          </router-link>
        </div>
      </div>
      
      <!-- 特色提示 -->
      <div class="feature-tips">
        <div class="tip-item" v-for="(tip, index) in featureTips" :key="index" :style="{ animationDelay: index * 0.15 + 's' }">
          <el-icon class="tip-icon"><component :is="tip.icon" /></el-icon>
          <span>{{ tip.text }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Tools, User, Shop, ArrowLeft, Star, HomeFilled, Setting, Lock, Timer, TrendCharts } from '@element-plus/icons-vue'
import RegisterForm from '@/components/common/RegisterForm.vue'

const router = useRouter()

// 选择的角色
const selectedRole = ref('user')
const isRegistering = ref(false)
const showSuccess = ref(false)

// 角色选项
const roleOptions = [
  {
    value: 'user',
    label: '用户注册',
    icon: User
  },
  {
    value: 'shop',
    label: '商家入驻',
    icon: Shop
  }
]

// 特色提示
const featureTips = [
  { icon: Lock, text: '安全保障' },
  { icon: Timer, text: '快速响应' },
  { icon: TrendCharts, text: '服务优质' }
]

// 生成粒子样式
const getParticleStyle = (index: number) => {
  const size = Math.random() * 4 + 2
  const duration = Math.random() * 25 + 15
  const delay = Math.random() * 8
  const left = Math.random() * 100
  const opacity = Math.random() * 0.4 + 0.2
  
  return {
    width: `${size}px`,
    height: `${size}px`,
    left: `${left}%`,
    animationDuration: `${duration}s`,
    animationDelay: `${delay}s`,
    opacity: opacity
  }
}

const handleRegistering = (registering: boolean) => {
  isRegistering.value = registering
}

// 处理注册成功事件
const handleRegisterSuccess = () => {
  showSuccess.value = true
  ElMessage.success({
    message: selectedRole.value === 'shop' ? '商家注册成功，请登录' : '注册成功，请登录',
    duration: 2000
  })
  
  // 注册成功后跳转到登录页面
  setTimeout(() => {
    router.push('/login')
  }, 1500)
}
</script>

<style scoped>
.register-page {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
  position: relative;
  overflow: hidden;
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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
  background: rgba(255, 255, 255, 0.5);
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
    transform: translateY(-100vh) translateX(80px) rotate(360deg);
    opacity: 0;
  }
}

/* 背景装饰 - 波浪效果 */
.bg-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 0;
}

.wave {
  position: absolute;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255,255,255,0.08) 0%, transparent 70%);
  animation: wave 25s linear infinite;
  filter: blur(3px);
}

.wave-1 {
  top: -50%;
  left: -50%;
  animation-delay: 0s;
}

.wave-2 {
  bottom: -50%;
  right: -50%;
  animation-delay: 8s;
}

.wave-3 {
  top: 20%;
  left: 20%;
  animation-delay: 16s;
}

.gradient-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(50px);
  animation: orbFloat 18s infinite ease-in-out;
}

.orb-1 {
  width: 250px;
  height: 250px;
  background: rgba(255, 255, 255, 0.12);
  top: 15%;
  left: 15%;
}

.orb-2 {
  width: 300px;
  height: 300px;
  background: rgba(0, 242, 254, 0.15);
  bottom: 10%;
  right: 10%;
  animation-delay: 9s;
}

@keyframes wave {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}

@keyframes orbFloat {
  0%, 100% {
    transform: translate(0, 0) scale(1);
  }
  33% {
    transform: translate(40px, -40px) scale(1.15);
  }
  66% {
    transform: translate(-40px, 40px) scale(0.85);
  }
}

.register-content {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 580px;
  animation: fadeInScale 0.7s cubic-bezier(0.4, 0, 0.2, 1);
}

@keyframes fadeInScale {
  from {
    opacity: 0;
    transform: scale(0.9) translateY(20px);
  }
  to {
    opacity: 1;
    transform: scale(1) translateY(0);
  }
}

.register-card {
  background: rgba(255, 255, 255, 0.96);
  border-radius: 28px;
  padding: 45px 40px;
  box-shadow: 0 30px 90px rgba(0, 0, 0, 0.35);
  backdrop-filter: blur(25px);
  position: relative;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.4);
}

.register-card::before {
  content: '';
  position: absolute;
  top: -3px;
  left: -3px;
  right: -3px;
  bottom: -3px;
  background: linear-gradient(45deg, #4facfe, #00f2fe, #4facfe);
  border-radius: 28px;
  z-index: -1;
  animation: borderGlow 4s linear infinite;
  opacity: 0.2;
}

@keyframes borderGlow {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.card-pulse {
  animation: cardPulse 0.6s ease-out;
}

@keyframes cardPulse {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.02); }
}

.register-header {
  text-align: center;
  margin-bottom: 32px;
}

.logo-icon {
  width: 80px;
  height: 80px;
  margin: 0 auto 20px;
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  border-radius: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  box-shadow: 0 10px 30px rgba(79, 172, 254, 0.5);
  position: relative;
  animation: logoFloat 4s ease-in-out infinite;
}

.logo-bounce {
  animation: logoBounce 0.8s ease-in-out infinite !important;
}

.logo-glow {
  position: absolute;
  width: 100%;
  height: 100%;
  border-radius: 22px;
  background: inherit;
  filter: blur(15px);
  opacity: 0.5;
  z-index: -1;
  animation: glowPulse 2s ease-in-out infinite;
}

@keyframes logoFloat {
  0%, 100% {
    transform: translateY(0) rotate(0deg);
  }
  50% {
    transform: translateY(-8px) rotate(3deg);
  }
}

@keyframes logoBounce {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
}

@keyframes glowPulse {
  0%, 100% {
    opacity: 0.4;
    transform: scale(0.95);
  }
  50% {
    opacity: 0.7;
    transform: scale(1.05);
  }
}

.platform-name {
  font-size: 28px;
  font-weight: 700;
  margin: 0 0 12px 0;
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: 0.5px;
}

.platform-name .word {
  display: inline-block;
  animation: wordBounceIn 0.7s ease-out both;
}

@keyframes wordBounceIn {
  from {
    opacity: 0;
    transform: translateY(-25px);
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

.star-icon {
  color: #4facfe;
  animation: starRotate 3s ease-in-out infinite;
}

.star-icon:nth-child(3) {
  animation-delay: 1.5s;
}

@keyframes starRotate {
  0%, 100% {
    opacity: 0.4;
    transform: rotate(0deg) scale(0.9);
  }
  50% {
    opacity: 1;
    transform: rotate(180deg) scale(1.2);
  }
}

.role-selector {
  margin-bottom: 28px;
}

.role-selector-label {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 600;
  color: #4facfe;
  margin-bottom: 12px;
  animation: labelSlide 0.6s ease-out;
}

@keyframes labelSlide {
  from {
    opacity: 0;
    transform: translateX(-20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.role-option {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 10px 20px;
  transition: all 0.3s;
}

:deep(.el-segmented) {
  width: 100%;
  background-color: #f5f7fa;
  padding: 6px;
  border-radius: 14px;
  box-shadow: inset 0 2px 8px rgba(0, 0, 0, 0.05);
}

:deep(.el-segmented__item) {
  border-radius: 11px;
  font-weight: 600;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

:deep(.el-segmented__item:hover) {
  background: rgba(79, 172, 254, 0.1);
}

:deep(.el-segmented__item.is-selected) {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  color: white;
  box-shadow: 0 5px 15px rgba(79, 172, 254, 0.4);
  transform: translateY(-2px);
}

.form-container {
  width: 100%;
}

.register-footer-links {
  margin-top: 28px;
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
  color: #4facfe;
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  border-radius: 12px;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  background: rgba(79, 172, 254, 0.08);
  border: 1.5px solid transparent;
}

.footer-link:hover {
  background: rgba(79, 172, 254, 0.15);
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(79, 172, 254, 0.2);
  border-color: rgba(79, 172, 254, 0.3);
}

.footer-link.primary {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  color: white;
  border: none;
}

.footer-link.primary:hover {
  transform: translateY(-3px) scale(1.05);
  box-shadow: 0 12px 30px rgba(79, 172, 254, 0.4);
}

/* 特色提示 */
.feature-tips {
  margin-top: 24px;
  display: flex;
  justify-content: center;
  gap: 16px;
  flex-wrap: wrap;
}

.tip-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 20px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 16px;
  color: #4facfe;
  font-size: 14px;
  font-weight: 600;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
  animation: tipFadeIn 0.7s ease-out both;
  transition: all 0.3s;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(79, 172, 254, 0.2);
}

.tip-item:hover {
  transform: translateY(-5px) scale(1.05);
  box-shadow: 0 12px 30px rgba(79, 172, 254, 0.3);
  border-color: rgba(79, 172, 254, 0.4);
}

.tip-icon {
  font-size: 18px;
  animation: iconBounce 2s ease-in-out infinite;
}

@keyframes tipFadeIn {
  from {
    opacity: 0;
    transform: translateY(25px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes iconBounce {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-5px);
  }
}

/* 响应式设计 */
@media (max-width: 768px) {
  .register-page {
    padding: 16px;
  }
  
  .register-card {
    padding: 40px 24px;
  }
  
  .logo-icon {
    width: 70px;
    height: 70px;
  }
  
  .platform-name {
    font-size: 24px;
  }
  
  .register-footer-links {
    flex-direction: column;
  }
  
  .feature-tips {
    gap: 12px;
  }
  
  .tip-item {
    font-size: 13px;
    padding: 10px 16px;
  }
}

@media (max-width: 480px) {
  .register-card {
    padding: 35px 20px;
  }
  
  .platform-name {
    font-size: 22px;
  }
  
  .role-option {
    padding: 8px 14px;
    font-size: 13px;
  }
  
  .footer-link {
    padding: 10px 20px;
    font-size: 13px;
  }
}
</style>
