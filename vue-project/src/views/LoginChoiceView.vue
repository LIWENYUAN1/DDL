<template>
  <div class="choice-page">
    <!-- 背景装饰元素 -->
    <div class="bg-decorations">
      <div class="decor decor-1"></div>
      <div class="decor decor-2"></div>
      <div class="decor decor-3"></div>
    </div>
    
    <div class="choice-container">
      <div class="choice-header">
        <h2 class="title">请选择您的身份</h2>
        <p class="welcome-text">欢迎回来，{{ userName }}</p>
      </div>
      
      <div class="choice-grid">
        <div 
          class="choice-card user-choice" 
          @click="navigateToRole('user')"
        >
          <div class="card-shine"></div>
          <div class="choice-icon">
            <svg viewBox="0 0 24 24" width="48" height="48">
              <path fill="currentColor" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z"/>
            </svg>
          </div>
          <h3>用户模式</h3>
          <p>预约维修、查看服务、管理个人信息</p>
          <div class="card-features">
            <span class="feature-tag">预约维修</span>
            <span class="feature-tag">服务查询</span>
            <span class="feature-tag">个人中心</span>
          </div>
          <div class="arrow-icon"></div>
        </div>
        
        <div 
          class="choice-card shop-choice" 
          @click="navigateToRole('shop')"
        >
          <div class="card-shine"></div>
          <div class="choice-icon">
            <svg viewBox="0 0 24 24" width="48" height="48">
              <path fill="currentColor" d="M16 6V4c0-1.11-.89-2-2-2h-4c-1.11 0-2 .89-2 2v2H4c-1.11 0-1.99.89-1.99 2L2 19c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2h-4zm-6-2h4v2h-4V4zm0 15l-3-3.86 1.64-1.42 1.36 1.63 4.36-5.17 1.63 1.42L10 17z"/>
            </svg>
          </div>
          <h3>商家模式</h3>
          <p>管理服务、查看预约、处理订单</p>
          <div class="card-features">
            <span class="feature-tag">服务管理</span>
            <span class="feature-tag">订单处理</span>
            <span class="feature-tag">数据统计</span>
          </div>
          <div class="arrow-icon"></div>
        </div>
        
        <div 
          class="choice-card admin-choice" 
          @click="navigateToRole('admin')"
        >
          <div class="card-shine"></div>
          <div class="choice-icon">
            <svg viewBox="0 0 24 24" width="48" height="48">
              <path fill="currentColor" d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/>
            </svg>
          </div>
          <h3>管理员模式</h3>
          <p>用户管理、商家管理、数据统计</p>
          <div class="card-features">
            <span class="feature-tag">用户管理</span>
            <span class="feature-tag">商家管理</span>
            <span class="feature-tag">系统设置</span>
          </div>
          <div class="arrow-icon"></div>
        </div>
      </div>
      
      <div class="choice-footer">
        <button class="logout-btn" @click="handleLogout">
          <span class="logout-icon">↵</span>
          退出登录
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/store/modules/user'

const router = useRouter()
const userStore = useUserStore()

// 获取用户名
const userName = computed(() => userStore.userName || '用户')

// 导航到对应角色的首页
const navigateToRole = (role: 'user' | 'shop' | 'admin') => {
  // 更新用户角色（如果当前角色与选择的角色不同）
  if (userStore.role !== role) {
    userStore.setUserInfo({
      token: userStore.token,
      username: userStore.userName,
      role: role,
      remember: true
    })
  }
  
  // 添加导航动画效果
  document.body.style.opacity = '0'
  
  // 跳转到首页（因为角色首页视图还未实现）
  setTimeout(() => {
    router.push('/')
    // 页面加载后恢复透明度
    setTimeout(() => {
      document.body.style.opacity = '1'
    }, 100)
  }, 300)
}

// 退出登录
const handleLogout = () => {
  // 添加退出动画效果
  document.body.style.opacity = '0'
  
  setTimeout(() => {
    userStore.logout()
    router.push('/login')
    // 页面加载后恢复透明度
    setTimeout(() => {
      document.body.style.opacity = '1'
    }, 100)
  }, 300)
}
</script>

<style scoped>
.choice-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
  font-family: 'Arial', sans-serif;
  position: relative;
  overflow: hidden;
}

/* 背景装饰 */
.bg-decorations {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 0;
}

.decor {
  position: absolute;
  border-radius: 50%;
  filter: blur(60px);
  opacity: 0.3;
  animation: float 15s infinite ease-in-out;
}

.decor-1 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  top: 10%;
  left: 5%;
  animation-delay: 0s;
}

.decor-2 {
  width: 250px;
  height: 250px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  bottom: 15%;
  right: 8%;
  animation-delay: -5s;
}

.decor-3 {
  width: 200px;
  height: 200px;
  background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
  top: 60%;
  left: 15%;
  animation-delay: -10s;
}

@keyframes float {
  0%, 100% { transform: translate(0, 0) rotate(0deg); }
  33% { transform: translate(30px, -20px) rotate(5deg); }
  66% { transform: translate(-20px, 30px) rotate(-5deg); }
}

.choice-container {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 20px;
  padding: 40px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
  max-width: 900px;
  width: 100%;
  text-align: center;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  position: relative;
  z-index: 1;
  transition: all 0.3s ease;
}

.choice-header .title {
  color: #1f2937;
  margin-bottom: 15px;
  font-size: 32px;
  font-weight: 700;
  letter-spacing: -0.5px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: fadeInUp 0.6s ease-out;
}

.welcome-text {
  color: #6b7280;
  margin-bottom: 50px;
  font-size: 18px;
  animation: fadeInUp 0.6s ease-out 0.2s both;
}

.choice-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
  gap: 30px;
  margin-bottom: 40px;
}

.choice-card {
  background: #ffffff;
  border: 2px solid transparent;
  border-radius: 16px;
  padding: 35px 25px;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  position: relative;
  overflow: hidden;
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
  animation: fadeInUp 0.6s ease-out;
}

.choice-card:nth-child(1) { animation-delay: 0.3s; }
.choice-card:nth-child(2) { animation-delay: 0.5s; }
.choice-card:nth-child(3) { animation-delay: 0.7s; }

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.choice-card:hover {
  transform: translateY(-10px) scale(1.02);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.user-choice {
  border-color: rgba(40, 167, 69, 0.3);
}

.user-choice:hover {
  border-color: #28a745;
  background: linear-gradient(135deg, rgba(248, 255, 248, 0.9), rgba(232, 245, 232, 0.9));
}

.shop-choice {
  border-color: rgba(23, 162, 184, 0.3);
}

.shop-choice:hover {
  border-color: #17a2b8;
  background: linear-gradient(135deg, rgba(240, 248, 255, 0.9), rgba(230, 247, 255, 0.9));
}

.admin-choice {
  border-color: rgba(220, 53, 69, 0.3);
}

.admin-choice:hover {
  border-color: #dc3545;
  background: linear-gradient(135deg, rgba(255, 248, 248, 0.9), rgba(255, 230, 230, 0.9));
}

/* 卡片发光效果 */
.card-shine {
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: linear-gradient(
    to right, 
    rgba(255, 255, 255, 0) 0%, 
    rgba(255, 255, 255, 0.4) 50%, 
    rgba(255, 255, 255, 0) 100%
  );
  transform: rotate(30deg);
  animation: shine 6s infinite;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.choice-card:hover .card-shine {
  opacity: 1;
}

@keyframes shine {
  0% { transform: translateX(-100%) rotate(30deg); }
  20%, 100% { transform: translateX(100%) rotate(30deg); }
}

.choice-icon {
  margin-bottom: 25px;
  height: 100px;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
  z-index: 1;
}

.user-choice .choice-icon {
  color: #28a745;
  filter: drop-shadow(0 4px 6px rgba(40, 167, 69, 0.3));
}

.shop-choice .choice-icon {
  color: #17a2b8;
  filter: drop-shadow(0 4px 6px rgba(23, 162, 184, 0.3));
}

.admin-choice .choice-icon {
  color: #dc3545;
  filter: drop-shadow(0 4px 6px rgba(220, 53, 69, 0.3));
}

.choice-card h3 {
  color: #1f2937;
  margin-bottom: 12px;
  font-size: 22px;
  font-weight: 700;
  position: relative;
  z-index: 1;
  transition: transform 0.3s ease;
}

.choice-card:hover h3 {
  transform: translateY(-3px);
}

.choice-card p {
  color: #6b7280;
  font-size: 14px;
  line-height: 1.6;
  margin-bottom: 20px;
  position: relative;
  z-index: 1;
  transition: color 0.3s ease;
}

.user-choice:hover p {
  color: #28a745;
}

.shop-choice:hover p {
  color: #17a2b8;
}

.admin-choice:hover p {
  color: #dc3545;
}

/* 功能标签 */
.card-features {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  justify-content: center;
  margin-top: 15px;
  position: relative;
  z-index: 1;
}

.feature-tag {
  font-size: 11px;
  padding: 5px 10px;
  border-radius: 12px;
  background-color: #f3f4f6;
  color: #6b7280;
  transition: all 0.3s ease;
  border: 1px solid transparent;
}

.choice-card:hover .feature-tag {
  background-color: rgba(255, 255, 255, 0.8);
  border-color: rgba(107, 114, 128, 0.2);
}

.user-choice:hover .feature-tag {
  background-color: rgba(40, 167, 69, 0.1);
  color: #28a745;
  border-color: rgba(40, 167, 69, 0.3);
}

.shop-choice:hover .feature-tag {
  background-color: rgba(23, 162, 184, 0.1);
  color: #17a2b8;
  border-color: rgba(23, 162, 184, 0.3);
}

.admin-choice:hover .feature-tag {
  background-color: rgba(220, 53, 69, 0.1);
  color: #dc3545;
  border-color: rgba(220, 53, 69, 0.3);
}

/* 箭头图标 */
.arrow-icon {
  position: absolute;
  bottom: 15px;
  right: 15px;
  width: 30px;
  height: 30px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transform: translateX(10px);
  transition: all 0.3s ease;
}

.arrow-icon::after {
  content: '→';
  color: #667eea;
  font-weight: bold;
  font-size: 16px;
}

.choice-card:hover .arrow-icon {
  opacity: 1;
  transform: translateX(0);
}

.choice-footer {
  margin-top: 40px;
  animation: fadeInUp 0.6s ease-out 0.9s both;
}

.logout-btn {
  background: transparent;
  border: 2px solid #667eea;
  color: #667eea;
  padding: 12px 24px;
  border-radius: 25px;
  cursor: pointer;
  font-size: 15px;
  font-weight: 500;
  transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  position: relative;
  overflow: hidden;
}

.logout-btn::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(102, 126, 234, 0.2), transparent);
  transition: all 0.5s ease;
}

.logout-btn:hover::before {
  left: 100%;
}

.logout-btn:hover {
  background: #667eea;
  color: white;
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
}

.logout-icon {
  margin-right: 8px;
  font-size: 16px;
  font-weight: bold;
  display: inline-block;
  transition: transform 0.3s ease;
}

.logout-btn:hover .logout-icon {
  transform: translateX(-3px);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .choice-container {
    padding: 30px 20px;
    border-radius: 16px;
  }
  
  .choice-header .title {
    font-size: 28px;
  }
  
  .welcome-text {
    font-size: 16px;
    margin-bottom: 40px;
  }
  
  .choice-grid {
    gap: 20px;
  }
  
  .choice-card {
    padding: 30px 20px;
  }
  
  .choice-icon {
    height: 80px;
  }
  
  .choice-icon svg {
    width: 40px;
    height: 40px;
  }
  
  .decor {
    opacity: 0.2;
  }
}

@media (max-width: 480px) {
  .choice-page {
    padding: 15px;
  }
  
  .choice-container {
    padding: 25px 15px;
    border-radius: 12px;
  }
  
  .choice-header .title {
    font-size: 24px;
  }
  
  .welcome-text {
    font-size: 15px;
    margin-bottom: 30px;
  }
  
  .choice-grid {
    grid-template-columns: 1fr;
    gap: 15px;
  }
  
  .choice-card {
    padding: 25px 15px;
  }
  
  .card-features {
    gap: 5px;
  }
  
  .feature-tag {
    font-size: 10px;
    padding: 4px 8px;
  }
  
  .decor-1 {
    width: 200px;
    height: 200px;
  }
  
  .decor-2 {
    width: 180px;
    height: 180px;
  }
  
  .decor-3 {
    width: 150px;
    height: 150px;
  }
}
</style>