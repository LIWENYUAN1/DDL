<template>
  <div class="home-page">
    <!-- 顶部导航 -->
    <header class="header">
      <div class="container">
        <div class="logo">
          <el-icon :size="28"><Tools /></el-icon>
          <span>摩托车服务平台</span>
        </div>
        <nav class="nav">
          <router-link to="/login" class="nav-btn login-btn">登录</router-link>
          <router-link to="/register" class="nav-btn register-btn">注册</router-link>
        </nav>
      </div>
    </header>

    <!-- 主内容 -->
    <main class="main">
      <div class="container">
        <!-- Hero 区域 -->
        <section class="hero">
          <h1 class="title animate-fade-in">摩托车一站式服务平台</h1>
          <p class="subtitle animate-fade-in-delay">专业 · 便捷 · 高效 · 安全</p>
          
          <!-- 摩托车轮播展示 -->
          <div class="motorcycle-carousel">
            <div class="carousel-container">
              <div class="carousel-track" :style="{ transform: `translateX(-${currentSlide * 100}%)` }">
                <div 
                  v-for="(image, index) in motorcycleImages" 
                  :key="index"
                  class="carousel-slide"
                  :class="{ 'active': currentSlide === index }"
                >
                  <div class="slide-image-wrapper">
                    <img 
                      :src="image.url" 
                      :alt="image.title"
                      class="slide-image"
                      @error="handleImageError"
                    />
                    <div class="slide-overlay">
                      <div class="slide-content">
                        <h3 class="slide-title">{{ image.title }}</h3>
                        <p class="slide-description">{{ image.description }}</p>
                        <div class="slide-tags">
                          <span v-for="(tag, idx) in image.tags" :key="idx" class="tag">{{ tag }}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              
              <!-- 导航按钮 -->
              <button class="carousel-btn prev" @click="prevSlide" :disabled="currentSlide === 0">
                <el-icon><ArrowLeft /></el-icon>
              </button>
              <button class="carousel-btn next" @click="nextSlide" :disabled="currentSlide === motorcycleImages.length - 1">
                <el-icon><ArrowRight /></el-icon>
              </button>
              
              <!-- 指示器 -->
              <div class="carousel-indicators">
                <button 
                  v-for="(image, index) in motorcycleImages" 
                  :key="index"
                  class="indicator"
                  :class="{ 'active': currentSlide === index }"
                  @click="goToSlide(index)"
                >
                  <span class="indicator-label">{{ index + 1 }}</span>
                </button>
              </div>
              
              <!-- 自动播放控制 -->
              <button class="autoplay-btn" @click="toggleAutoplay">
                <el-icon v-if="isAutoplay"><VideoPause /></el-icon>
                <el-icon v-else><VideoPlay /></el-icon>
              </button>
            </div>
          </div>
          
          <!-- 平台功能介绍 -->
          <div class="platform-features">
            <h2 class="features-title">一站式摩托车服务解决方案</h2>
            <p class="features-subtitle">基于O2O模式，连接车主与优质服务商，提供全方位专业服务</p>
            
            <div class="features-cards">
              <div class="feature-card-main animate-slide-up">
                <div class="feature-icon-main">
                  <el-icon :size="48"><User /></el-icon>
                </div>
                <h3>车主服务</h3>
                <ul class="feature-list">
                  <li><el-icon><Check /></el-icon> 快速查找附近优质商家</li>
                  <li><el-icon><Check /></el-icon> 透明的服务项目和价格</li>
                  <li><el-icon><Check /></el-icon> 在线预约与便捷支付</li>
                  <li><el-icon><Check /></el-icon> 实时查看订单进度</li>
                  <li><el-icon><Check /></el-icon> 评价反馈与售后保障</li>
                </ul>
              </div>

              <div class="feature-card-main animate-slide-up delay-1">
                <div class="feature-icon-main">
                  <el-icon :size="48"><Shop /></el-icon>
                </div>
                <h3>商家管理</h3>
                <ul class="feature-list">
                  <li><el-icon><Check /></el-icon> 店铺信息与服务项目管理</li>
                  <li><el-icon><Check /></el-icon> 智能订单接收与处理</li>
                  <li><el-icon><Check /></el-icon> 客户关系维护系统</li>
                  <li><el-icon><Check /></el-icon> 经营数据分析看板</li>
                  <li><el-icon><Check /></el-icon> 营业时间灵活设置</li>
                </ul>
              </div>

              <div class="feature-card-main animate-slide-up delay-2">
                <div class="feature-icon-main">
                  <el-icon :size="48"><Monitor /></el-icon>
                </div>
                <h3>平台优势</h3>
                <ul class="feature-list">
                  <li><el-icon><Check /></el-icon> LBS地理位置智能匹配</li>
                  <li><el-icon><Check /></el-icon> 完善的评价与信用体系</li>
                  <li><el-icon><Check /></el-icon> 多种支付方式支持</li>
                  <li><el-icon><Check /></el-icon> 7×24小时客服支持</li>
                  <li><el-icon><Check /></el-icon> 专业认证保障服务质量</li>
                </ul>
              </div>
            </div>

            <!-- CTA按钮 -->
            <div class="cta-buttons">
              <router-link to="/register" class="cta-btn primary">
                <el-icon><UserFilled /></el-icon>
                <span>立即注册</span>
              </router-link>
              <router-link to="/login" class="cta-btn secondary">
                <el-icon><Promotion /></el-icon>
                <span>立即登录</span>
              </router-link>
            </div>
          </div>
        </section>
      </div>
    </main>

    <!-- 平台介绍 -->
    <section class="platform-intro">
      <div class="container">
        <h2 class="section-title">关于平台</h2>
        <p class="intro-text">
          我们是专业的摩托车服务平台，致力于为广大摩托车爱好者提供全方位、一站式的服务体验。
          平台汇聚了众多优质商家，提供维修、保养、改装、托运等多种服务，让您的爱车随时保持最佳状态。
        </p>
        <div class="intro-stats">
          <div class="stat-item">
            <div class="stat-number">1000+</div>
            <div class="stat-label">注册用户</div>
          </div>
          <div class="stat-item">
            <div class="stat-number">200+</div>
            <div class="stat-label">合作商家</div>
          </div>
          <div class="stat-item">
            <div class="stat-number">5000+</div>
            <div class="stat-label">服务订单</div>
          </div>
          <div class="stat-item">
            <div class="stat-number">98%</div>
            <div class="stat-label">满意度</div>
          </div>
        </div>
      </div>
    </section>

    <!-- 摩托车类型展示 -->
    <section class="motorcycle-types">
      <div class="container">
        <h2 class="section-title">热门车型服务</h2>
        <p class="section-subtitle">支持各类摩托车型的专业服务</p>
        
        <div class="types-grid">
          <div 
            v-for="(type, index) in motorcycleTypes" 
            :key="index"
            class="type-card"
            :class="{ 'active': hoveredType === index }"
            @mouseenter="hoveredType = index"
            @mouseleave="hoveredType = null"
          >
            <div class="type-icon">
              <div class="motorcycle-svg" v-html="type.icon"></div>
            </div>
            <h3 class="type-name">{{ type.name }}</h3>
            <p class="type-desc">{{ type.description }}</p>
            <div class="type-features">
              <span v-for="(feature, idx) in type.features" :key="idx" class="feature-tag">
                {{ feature }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 服务特色 -->
    <section class="features-section">
      <div class="container">
        <h2 class="section-title">服务特色</h2>
        <div class="features-grid">
          <div class="feature-card">
            <div class="feature-icon">
              <el-icon :size="40"><Location /></el-icon>
            </div>
            <h3>附近商家</h3>
            <p>基于地理位置，快速找到附近的优质服务商家</p>
          </div>
          <div class="feature-card">
            <div class="feature-icon">
              <el-icon :size="40"><Calendar /></el-icon>
            </div>
            <h3>在线预约</h3>
            <p>便捷的在线预约系统，合理安排您的服务时间</p>
          </div>
          <div class="feature-card">
            <div class="feature-icon">
              <el-icon :size="40"><Star /></el-icon>
            </div>
            <h3>评价系统</h3>
            <p>真实的用户评价，帮助您选择最合适的服务</p>
          </div>
          <div class="feature-card">
            <div class="feature-icon">
              <el-icon :size="40"><Tools /></el-icon>
            </div>
            <h3>专业服务</h3>
            <p>认证商家，专业技师，确保服务质量</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 页脚 -->
    <footer class="footer">
      <div class="container">
        <div class="footer-content">
          <div class="footer-section">
            <h4>关于我们</h4>
            <p>专业的摩托车服务平台</p>
          </div>
          <div class="footer-section">
            <h4>联系方式</h4>
            <p>客服电话：400-888-8888</p>
            <p>邮箱：service@moto.com</p>
          </div>
          <div class="footer-section">
            <h4>快速链接</h4>
            <p><router-link to="/login">用户登录</router-link></p>
            <p><router-link to="/register">用户注册</router-link></p>
            <p><router-link to="/shop/login">商家登录</router-link></p>
          </div>
        </div>
        <div class="footer-bottom">
          <p>&copy; 2025 摩托车服务平台 | 让您的爱车焕发新生</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
// 只导入实际存在的 Element Plus 图标
import { 
  User, Shop, Setting, UserFilled, 
  Promotion, Location, Calendar, Star, Tools,
  ArrowLeft, ArrowRight, VideoPause, VideoPlay,
  Monitor, Check
} from '@element-plus/icons-vue'

const router = useRouter()
const hoveredType = ref<number | null>(null)

// 轮播图相关状态
const currentSlide = ref(0)
const isAutoplay = ref(true)
let autoplayTimer: number | null = null

// 摩托车图片数据
const motorcycleImages = ref([
  {
    url: 'https://images.unsplash.com/photo-1558981852-426c6c22a060?w=800&h=450&fit=crop',
    title: '经典雅马哈 R1',
    description: '白色涂装，极致性能跑车',
    tags: ['跑车', '高性能', '经典配色']
  },
  {
    url: 'https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800&h=450&fit=crop',
    title: '暗夜骑士',
    description: '黑色雅马哈，神秘优雅',
    tags: ['黑色涂装', '隧道特拍', '运动风格']
  },
  {
    url: 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?w=800&h=450&fit=crop',
    title: '银蓝竞技',
    description: '银蓝配色，赛道基因',
    tags: ['银蓝色', '竞技版', '专业级']
  },
  {
    url: 'https://images.unsplash.com/photo-1609630875171-b1321377ee65?w=800&h=450&fit=crop',
    title: '赛道飞驰',
    description: '白色战驹，极速体验',
    tags: ['赛道版', '运动骑行', '专业装备']
  },
  {
    url: 'https://images.unsplash.com/photo-1558980664-10e7170b5df9?w=800&h=450&fit=crop',
    title: '山道之王',
    description: '白蓝配色，征服山路',
    tags: ['山路骑行', '风景线', '旅行利器']
  },
  {
    url: 'https://images.unsplash.com/photo-1599819177583-1b13d099e91e?w=800&h=450&fit=crop',
    title: '黑红魅影',
    description: '黑红涂装，个性十足',
    tags: ['黑红配色', '个性改装', '运动美学']
  }
])

// 轮播图方法
const nextSlide = () => {
  if (currentSlide.value < motorcycleImages.value.length - 1) {
    currentSlide.value++
  } else {
    currentSlide.value = 0
  }
}

const prevSlide = () => {
  if (currentSlide.value > 0) {
    currentSlide.value--
  } else {
    currentSlide.value = motorcycleImages.value.length - 1
  }
}

const goToSlide = (index: number) => {
  currentSlide.value = index
}

const toggleAutoplay = () => {
  isAutoplay.value = !isAutoplay.value
  if (isAutoplay.value) {
    startAutoplay()
  } else {
    stopAutoplay()
  }
}

const startAutoplay = () => {
  if (autoplayTimer) {
    clearInterval(autoplayTimer)
  }
  autoplayTimer = window.setInterval(() => {
    nextSlide()
  }, 4000)
}

const stopAutoplay = () => {
  if (autoplayTimer) {
    clearInterval(autoplayTimer)
    autoplayTimer = null
  }
}

const handleImageError = (event: Event) => {
  const target = event.target as HTMLImageElement
  // 使用占位符SVG
  target.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iODAwIiBoZWlnaHQ9IjQ1MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICA8cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZjVmN2ZhIi8+CiAgPHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIyNCIgZmlsbD0iIzkwOTM5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZG9taW5hbnQtYmFzZWxpbmU9Im1pZGRsZSI+CiAgICDmkqvor7flsIblm77niYfkv53lrZjliLAgL2ltYWdlcy9tb3RvcmN5Y2xlcy8KICDlubblkb3lkI1kuLogbW90by0xLmpwZywgbW90by0yLmpwZyDnrYkKICA8L3RleHQ+Cjwvc3ZnPg=='
}

// 摩托车类型数据
const motorcycleTypes = ref([
  {
    name: '街车',
    description: '城市通勤的最佳选择，灵活便捷',
    icon: `<svg viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg">
      <circle cx="40" cy="70" r="20" fill="#333" stroke="#666" stroke-width="3"/>
      <circle cx="160" cy="70" r="20" fill="#333" stroke="#666" stroke-width="3"/>
      <path d="M 40 70 L 80 40 L 120 40 L 160 70" stroke="#667eea" stroke-width="4" fill="none"/>
      <rect x="70" y="25" width="40" height="20" fill="#764ba2" rx="3"/>
      <path d="M 80 40 L 90 20 L 110 20 L 120 40" fill="#667eea"/>
    </svg>`,
    features: ['日常通勤', '操控灵活', '经济实用']
  },
  {
    name: '跑车',
    description: '速度与激情的完美结合',
    icon: `<svg viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg">
      <circle cx="45" cy="75" r="18" fill="#333" stroke="#666" stroke-width="3"/>
      <circle cx="155" cy="75" r="18" fill="#333" stroke="#666" stroke-width="3"/>
      <path d="M 45 75 L 70 35 L 140 30 L 155 75" stroke="#f56c6c" stroke-width="4" fill="none"/>
      <path d="M 70 35 L 140 30 L 150 50 L 100 55 Z" fill="#e6a23c" opacity="0.8"/>
      <circle cx="120" cy="42" r="8" fill="#409eff" opacity="0.6"/>
    </svg>`,
    features: ['高性能', '运动外观', '极速体验']
  },
  {
    name: '巡航车',
    description: '长途旅行，舒适稳定',
    icon: `<svg viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg">
      <circle cx="50" cy="70" r="22" fill="#333" stroke="#666" stroke-width="3"/>
      <circle cx="150" cy="70" r="22" fill="#333" stroke="#666" stroke-width="3"/>
      <path d="M 50 70 L 75 50 L 125 45 L 150 70" stroke="#43e97b" stroke-width="4" fill="none"/>
      <rect x="70" y="35" width="50" height="18" fill="#38f9d7" rx="4"/>
      <path d="M 125 45 L 145 35 L 150 50" fill="#43e97b" opacity="0.7"/>
    </svg>`,
    features: ['长途舒适', '稳定性好', '载物能力强']
  },
  {
    name: '越野车',
    description: '征服各种路况，冒险首选',
    icon: `<svg viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg">
      <circle cx="45" cy="75" r="20" fill="#333" stroke="#666" stroke-width="3"/>
      <circle cx="155" cy="75" r="20" fill="#333" stroke="#666" stroke-width="3"/>
      <path d="M 45 75 L 80 30 L 130 35 L 155 75" stroke="#67c23a" stroke-width="4" fill="none"/>
      <rect x="75" y="20" width="45" height="18" fill="#85ce61" rx="3"/>
      <path d="M 80 30 L 100 15 L 120 20 L 130 35" fill="#67c23a" opacity="0.7"/>
      <line x1="85" y1="38" x2="95" y2="48" stroke="#333" stroke-width="2"/>
    </svg>`,
    features: ['越野性能', '通过性强', '户外冒险']
  },
  {
    name: '复古车',
    description: '经典造型，情怀之选',
    icon: `<svg viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg">
      <circle cx="50" cy="70" r="20" fill="#333" stroke="#666" stroke-width="3"/>
      <circle cx="145" cy="70" r="20" fill="#333" stroke="#666" stroke-width="3"/>
      <path d="M 50 70 L 80 45 L 120 45 L 145 70" stroke="#c67162" stroke-width="4" fill="none"/>
      <circle cx="100" y="35" r="15" fill="#d4a574" opacity="0.8"/>
      <rect x="75" y="30" width="35" height="25" fill="#8b5a3c" rx="5" opacity="0.7"/>
    </svg>`,
    features: ['经典设计', '怀旧风格', '个性独特']
  },
  {
    name: '踏板车',
    description: '轻便灵活，城市代步首选',
    icon: `<svg viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg">
      <circle cx="55" cy="75" r="18" fill="#333" stroke="#666" stroke-width="3"/>
      <circle cx="140" cy="75" r="18" fill="#333" stroke="#666" stroke-width="3"/>
      <path d="M 55 75 L 80 60 L 120 55 L 140 75" stroke="#909399" stroke-width="4" fill="none"/>
      <rect x="70" y="45" width="55" height="20" fill="#a6a9ad" rx="10"/>
      <path d="M 80 60 L 95 40 L 115 45" fill="#909399" opacity="0.6"/>
    </svg>`,
    features: ['轻便灵活', '自动挡', '省油省心']
  }
])

// 检查登录状态，如果已登录则自动跳转
onMounted(() => {
  const token = localStorage.getItem('token')
  const role = localStorage.getItem('role')
  
  if (token && role) {
    const roleHomePage: Record<string, string> = {
      'user': '/user/home',
      'shop': '/shop/home',
      'admin': '/admin/home'
    }
    // 自动跳转到对应首页
    router.push(roleHomePage[role] || '/login')
  }
  
  // 启动轮播自动播放
  if (isAutoplay.value) {
    startAutoplay()
  }
})

// 组件卸载时清理定时器
onUnmounted(() => {
  stopAutoplay()
})
</script>

<style scoped>
* {
  box-sizing: border-box;
}

.home-page {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  width: 100%;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  overflow-y: auto;
  overflow-x: hidden;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  width: 100%;
}

/* 头部 */
.header {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  padding: 16px 0;
  position: sticky;
  top: 0;
  z-index: 100;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.header .container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo {
  display: flex;
  align-items: center;
  gap: 10px;
  color: white;
  font-size: 20px;
  font-weight: 600;
}

.nav {
  display: flex;
  gap: 12px;
}

.nav-btn {
  padding: 8px 24px;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 500;
  transition: all 0.3s;
  font-size: 14px;
}

.login-btn {
  color: white;
  border: 1px solid rgba(255, 255, 255, 0.3);
}

.login-btn:hover {
  background: rgba(255, 255, 255, 0.1);
  border-color: white;
}

.register-btn {
  background: white;
  color: #667eea;
}

.register-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

/* 主内容 */
.main {
  padding: 60px 0 40px;
}

.hero {
  text-align: center;
  color: white;
  width: 100%;
}

.title {
  font-size: 48px;
  font-weight: 700;
  margin: 0 0 16px 0;
  letter-spacing: -0.5px;
}

.subtitle {
  font-size: 20px;
  margin: 0 0 50px 0;
  opacity: 0.95;
  font-weight: 300;
  letter-spacing: 2px;
}

/* 动画 */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in {
  animation: fadeIn 0.8s ease-out;
}

.animate-fade-in-delay {
  animation: fadeIn 0.8s ease-out 0.2s both;
}

.animate-slide-up {
  animation: slideUp 0.6s ease-out;
}

.animate-slide-up.delay-1 {
  animation: slideUp 0.6s ease-out 0.15s both;
}

.animate-slide-up.delay-2 {
  animation: slideUp 0.6s ease-out 0.3s both;
}

/* 摩托车轮播图 */
.motorcycle-carousel {
  width: 100%;
  max-width: 1200px;
  margin: 48px auto 60px;
  animation: fadeIn 1s ease-out 0.4s both;
}

.carousel-container {
  position: relative;
  width: 100%;
  height: 500px;
  border-radius: 24px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  background: #000;
}

.carousel-track {
  display: flex;
  height: 100%;
  transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);
}

.carousel-slide {
  min-width: 100%;
  height: 100%;
  position: relative;
  opacity: 0.7;
  transition: opacity 0.8s;
}

.carousel-slide.active {
  opacity: 1;
}

.slide-image-wrapper {
  width: 100%;
  height: 100%;
  position: relative;
  overflow: hidden;
}

.slide-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 8s ease-out;
}

.carousel-slide.active .slide-image {
  animation: slowZoom 8s ease-out;
}

@keyframes slowZoom {
  from {
    transform: scale(1);
  }
  to {
    transform: scale(1.1);
  }
}

.slide-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(to top, rgba(0,0,0,0.9) 0%, rgba(0,0,0,0.5) 50%, transparent 100%);
  padding: 60px 48px 40px;
  transform: translateY(20px);
  opacity: 0;
  transition: all 0.6s ease-out;
}

.carousel-slide.active .slide-overlay {
  transform: translateY(0);
  opacity: 1;
}

.slide-content {
  max-width: 600px;
}

.slide-title {
  font-size: 36px;
  font-weight: 700;
  color: white;
  margin: 0 0 12px 0;
  text-shadow: 0 4px 12px rgba(0, 0, 0, 0.5);
  animation: slideInFromLeft 0.8s ease-out 0.2s both;
}

.slide-description {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.9);
  margin: 0 0 20px 0;
  line-height: 1.6;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.5);
  animation: slideInFromLeft 0.8s ease-out 0.4s both;
}

.slide-tags {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  animation: slideInFromLeft 0.8s ease-out 0.6s both;
}

.slide-tags .tag {
  padding: 8px 16px;
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.3);
  border-radius: 20px;
  color: white;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s;
}

.slide-tags .tag:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
}

@keyframes slideInFromLeft {
  from {
    opacity: 0;
    transform: translateX(-30px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

/* 轮播导航按钮 */
.carousel-btn {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  width: 56px;
  height: 56px;
  border: none;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(10px);
  border-radius: 50%;
  color: white;
  font-size: 24px;
  cursor: pointer;
  transition: all 0.3s;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
}

.carousel-container:hover .carousel-btn {
  opacity: 1;
}

.carousel-btn:hover:not(:disabled) {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-50%) scale(1.1);
}

.carousel-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

.carousel-btn.prev {
  left: 24px;
}

.carousel-btn.next {
  right: 24px;
}

/* 轮播指示器 */
.carousel-indicators {
  position: absolute;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 12px;
  z-index: 10;
}

.indicator {
  position: relative;
  width: 12px;
  height: 12px;
  border: 2px solid rgba(255, 255, 255, 0.5);
  background: transparent;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.3s;
  padding: 0;
  overflow: visible;
}

.indicator:hover {
  border-color: rgba(255, 255, 255, 0.8);
  transform: scale(1.2);
}

.indicator.active {
  background: white;
  border-color: white;
  width: 40px;
  border-radius: 6px;
}

.indicator-label {
  position: absolute;
  top: -30px;
  left: 50%;
  transform: translateX(-50%);
  padding: 4px 8px;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(10px);
  border-radius: 6px;
  color: white;
  font-size: 12px;
  white-space: nowrap;
  opacity: 0;
  pointer-events: none;
  transition: all 0.3s;
}

.indicator:hover .indicator-label {
  opacity: 1;
  top: -35px;
}

/* 自动播放控制按钮 */
.autoplay-btn {
  position: absolute;
  top: 24px;
  right: 24px;
  width: 48px;
  height: 48px;
  border: none;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(10px);
  border-radius: 12px;
  color: white;
  font-size: 20px;
  cursor: pointer;
  transition: all 0.3s;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: center;
}

.autoplay-btn:hover {
  background: rgba(255, 255, 255, 0.25);
  transform: scale(1.05);
}

/* 平台功能介绍 */
.platform-features {
  margin: 60px 0 40px;
  text-align: center;
}

.features-title {
  font-size: 36px;
  font-weight: 700;
  color: white;
  margin: 0 0 16px 0;
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.features-subtitle {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.95);
  margin: 0 0 50px 0;
  max-width: 700px;
  margin-left: auto;
  margin-right: auto;
  line-height: 1.6;
}

.features-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 30px;
  max-width: 1200px;
  margin: 0 auto 50px;
}

.feature-card-main {
  background: white;
  padding: 40px 30px;
  border-radius: 20px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  text-align: left;
}

.feature-card-main:hover {
  transform: translateY(-12px);
  box-shadow: 0 16px 48px rgba(0, 0, 0, 0.2);
}

.feature-icon-main {
  width: 80px;
  height: 80px;
  margin: 0 0 24px 0;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  transition: all 0.4s;
}

.feature-card-main:nth-child(2) .feature-icon-main {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
}

.feature-card-main:nth-child(3) .feature-icon-main {
  background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
}

.feature-card-main:hover .feature-icon-main {
  transform: scale(1.1) rotate(5deg);
}

.feature-card-main h3 {
  font-size: 24px;
  font-weight: 700;
  color: #303133;
  margin: 0 0 20px 0;
}

.feature-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.feature-list li {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 0;
  font-size: 15px;
  color: #606266;
  line-height: 1.6;
}

.feature-list li .el-icon {
  color: #67c23a;
  font-size: 18px;
  flex-shrink: 0;
}

/* CTA按钮 */
.cta-buttons {
  display: flex;
  gap: 20px;
  justify-content: center;
  margin-top: 40px;
}

.cta-btn {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  padding: 18px 40px;
  border-radius: 14px;
  text-decoration: none;
  font-size: 18px;
  font-weight: 600;
  transition: all 0.3s;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.cta-btn.primary {
  background: white;
  color: #667eea;
}

.cta-btn.primary:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(255, 255, 255, 0.4);
}

.cta-btn.secondary {
  background: rgba(255, 255, 255, 0.15);
  color: white;
  border: 2px solid rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(10px);
}

.cta-btn.secondary:hover {
  background: rgba(255, 255, 255, 0.25);
  border-color: white;
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(255, 255, 255, 0.3);
}

/* 平台介绍 */
.platform-intro {
  background: white;
  padding: 80px 0;
  text-align: center;
}

.section-title {
  font-size: 36px;
  font-weight: 700;
  color: #303133;
  margin: 0 0 24px 0;
}

.section-subtitle {
  font-size: 16px;
  color: #909399;
  margin: 0 0 50px 0;
}

.intro-text {
  font-size: 18px;
  line-height: 1.8;
  color: #606266;
  max-width: 800px;
  margin: 0 auto 60px;
}

.intro-stats {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 40px;
  max-width: 900px;
  margin: 0 auto;
}

.stat-item {
  text-align: center;
}

.stat-number {
  font-size: 48px;
  font-weight: 700;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 16px;
  color: #909399;
}

/* 摩托车类型展示 */
.motorcycle-types {
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  padding: 80px 0;
}

.types-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 32px;
  max-width: 1000px;
  margin: 0 auto;
}

.type-card {
  background: white;
  border-radius: 20px;
  padding: 32px 24px;
  text-align: center;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
  position: relative;
  overflow: hidden;
}

.type-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(102, 126, 234, 0.1), transparent);
  transition: left 0.5s;
}

.type-card.active::before,
.type-card:hover::before {
  left: 100%;
}

.type-card:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 12px 32px rgba(102, 126, 234, 0.2);
}

.type-icon {
  width: 100%;
  height: 120px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
}

.motorcycle-svg {
  width: 100%;
  height: 100%;
  transition: transform 0.4s;
}

.type-card:hover .motorcycle-svg {
  transform: scale(1.1);
}

.type-name {
  font-size: 22px;
  font-weight: 600;
  color: #303133;
  margin: 0 0 12px 0;
}

.type-desc {
  font-size: 14px;
  color: #909399;
  margin: 0 0 20px 0;
  line-height: 1.6;
}

.type-features {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  justify-content: center;
}

.feature-tag {
  padding: 6px 14px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 500;
}

/* 服务特色 */
.features-section {
  background: white;
  padding: 80px 0;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 32px;
  max-width: 1100px;
  margin: 0 auto;
}

.feature-card {
  text-align: center;
  padding: 32px 20px;
  border-radius: 16px;
  transition: all 0.3s;
  background: #f8f9fa;
}

.feature-card:hover {
  background: #667eea;
  color: white;
  transform: translateY(-8px);
  box-shadow: 0 8px 24px rgba(102, 126, 234, 0.3);
}

.feature-icon {
  width: 80px;
  height: 80px;
  margin: 0 auto 20px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: white;
  color: #667eea;
  transition: all 0.3s;
}

.feature-card:hover .feature-icon {
  background: rgba(255, 255, 255, 0.2);
  color: white;
  transform: scale(1.1);
}

.feature-card h3 {
  font-size: 18px;
  font-weight: 600;
  margin: 0 0 12px 0;
}

.feature-card p {
  font-size: 14px;
  line-height: 1.6;
  color: #606266;
  margin: 0;
}

.feature-card:hover p {
  color: rgba(255, 255, 255, 0.9);
}

/* 页脚 */
.footer {
  background: #2c3e50;
  color: white;
  padding: 50px 0 30px;
}

.footer-content {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 40px;
  margin-bottom: 40px;
}

.footer-section h4 {
  font-size: 18px;
  margin: 0 0 16px 0;
  font-weight: 600;
}

.footer-section p {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.7);
  margin: 8px 0;
  line-height: 1.6;
}

.footer-section a {
  color: rgba(255, 255, 255, 0.7);
  text-decoration: none;
  transition: color 0.3s;
}

.footer-section a:hover {
  color: white;
}

.footer-bottom {
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  padding-top: 24px;
  text-align: center;
}

.footer-bottom p {
  margin: 0;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.6);
}

/* 响应式 */
@media (max-width: 1024px) {
  .types-grid,
  .features-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .intro-stats {
    grid-template-columns: repeat(2, 1fr);
    gap: 30px;
  }
}

@media (max-width: 768px) {
  .title {
    font-size: 36px;
  }

  .subtitle {
    font-size: 16px;
  }

  .features-cards {
    grid-template-columns: 1fr;
    max-width: 500px;
    margin-left: auto;
    margin-right: auto;
  }

  .cta-buttons {
    flex-direction: column;
    max-width: 350px;
    margin-left: auto;
    margin-right: auto;
  }

  .cta-btn {
    width: 100%;
    justify-content: center;
  }

  .types-grid,
  .features-grid {
    grid-template-columns: 1fr;
  }

  .footer-content {
    grid-template-columns: 1fr;
    gap: 30px;
  }

  .section-title {
    font-size: 28px;
  }

  .intro-text {
    font-size: 16px;
  }

  .intro-stats {
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
  }

  .stat-number {
    font-size: 36px;
  }

  /* 轮播图响应式 */
  .carousel-container {
    height: 400px;
  }

  .slide-title {
    font-size: 28px;
  }

  .slide-description {
    font-size: 16px;
  }

  .slide-overlay {
    padding: 40px 32px 28px;
  }

  .carousel-btn {
    width: 48px;
    height: 48px;
    font-size: 20px;
  }

  .carousel-btn.prev {
    left: 16px;
  }

  .carousel-btn.next {
    right: 16px;
  }
}

@media (max-width: 480px) {
  .logo span {
    display: none;
  }

  .title {
    font-size: 28px;
  }

  .subtitle {
    font-size: 14px;
    letter-spacing: 1px;
  }

  .features-cards {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .feature-card-main {
    padding: 32px 24px;
  }

  .cta-buttons {
    flex-direction: column;
    gap: 16px;
  }

  .cta-btn {
    width: 100%;
    justify-content: center;
  }

  .platform-intro,
  .motorcycle-types,
  .features-section {
    padding: 50px 0;
  }

  .intro-stats {
    gap: 16px;
  }

  .stat-number {
    font-size: 28px;
  }

  .stat-label {
    font-size: 13px;
  }

  /* 轮播图移动端优化 */
  .motorcycle-carousel {
    margin: 32px auto 48px;
  }

  .carousel-container {
    height: 320px;
    border-radius: 16px;
  }

  .slide-title {
    font-size: 22px;
  }

  .slide-description {
    font-size: 14px;
  }

  .slide-overlay {
    padding: 30px 24px 20px;
  }

  .slide-tags .tag {
    font-size: 12px;
    padding: 6px 12px;
  }

  .carousel-btn {
    width: 40px;
    height: 40px;
    font-size: 18px;
  }

  .carousel-btn.prev {
    left: 12px;
  }

  .carousel-btn.next {
    right: 12px;
  }

  .carousel-indicators {
    bottom: 16px;
    gap: 8px;
  }

  .indicator {
    width: 8px;
    height: 8px;
  }

  .indicator.active {
    width: 28px;
  }

  .autoplay-btn {
    width: 40px;
    height: 40px;
    font-size: 18px;
    top: 16px;
    right: 16px;
  }
}
</style>
