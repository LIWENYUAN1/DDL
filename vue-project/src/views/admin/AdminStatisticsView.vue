<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage, ElCard, ElSelect, ElOption, ElDatePicker, ElTabs, ElTabPane, ElProgress, ElTable, ElTableColumn } from 'element-plus'
import { ArrowUp, ArrowDown, BarChart, LineChart, PieChart, User, Business, Calendar, DollarSign } from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import { useAppointmentStore } from '@/store/modules/appointment'
import { useUserStore } from '@/store/modules/user'
import { useShopStore } from '@/store/modules/shop'

const appointmentStore = useAppointmentStore()
const userStore = useUserStore()
const shopStore = useShopStore()

// 时间范围选择
const dateRange = ref<[string, string]>(['', ''])
const dateType = ref('7d') // 7d, 30d, 90d, custom

// 图表实例
let appointmentTrendChart: any = null
let serviceTypeChart: any = null
let incomeTrendChart: any = null
let geoDistributionChart: any = null

// 统计数据
const statistics = ref({
  totalUsers: 0,
  newUsers: 0,
  totalShops: 0,
  newShops: 0,
  totalAppointments: 0,
  pendingAppointments: 0,
  totalIncome: 0,
  averageOrderValue: 0,
  userGrowthRate: 0,
  shopGrowthRate: 0,
  appointmentGrowthRate: 0,
  incomeGrowthRate: 0
})

// 热门服务
const popularServices = ref<any[]>([])

// 生命周期
onMounted(async () => {
  await loadStatisticsData()
  initCharts()
  window.addEventListener('resize', handleResize)
})

// 清理
const cleanup = () => {
  window.removeEventListener('resize', handleResize)
  if (appointmentTrendChart) {
    appointmentTrendChart.dispose()
  }
  if (serviceTypeChart) {
    serviceTypeChart.dispose()
  }
  if (incomeTrendChart) {
    incomeTrendChart.dispose()
  }
  if (geoDistributionChart) {
    geoDistributionChart.dispose()
  }
}

// 监听组件销毁
import { onUnmounted } from 'vue'
onUnmounted(() => cleanup())

// 加载统计数据
const loadStatisticsData = async () => {
  try {
    // 设置日期范围
    const startDate = new Date()
    const endDate = new Date()
    
    switch (dateType.value) {
      case '7d':
        startDate.setDate(startDate.getDate() - 6)
        break
      case '30d':
        startDate.setDate(startDate.getDate() - 29)
        break
      case '90d':
        startDate.setDate(startDate.getDate() - 89)
        break
      case 'custom':
        if (!dateRange.value[0] || !dateRange.value[1]) {
          ElMessage.warning('请选择日期范围')
          return
        }
        break
    }
    
    const startDateStr = dateRange.value[0] || startDate.toISOString().split('T')[0]
    const endDateStr = dateRange.value[1] || endDate.toISOString().split('T')[0]
    
    // 模拟加载数据
    // 在实际应用中，这里应该调用API获取真实数据
    
    // 模拟统计数据
    statistics.value = {
      totalUsers: 1256,
      newUsers: 48,
      totalShops: 89,
      newShops: 7,
      totalAppointments: 2341,
      pendingAppointments: 45,
      totalIncome: 128560,
      averageOrderValue: 286.5,
      userGrowthRate: 12.5,
      shopGrowthRate: 8.9,
      appointmentGrowthRate: 15.2,
      incomeGrowthRate: 18.7
    }
    
    // 模拟热门服务
    popularServices.value = [
      { name: '摩托车保养', count: 325, revenue: 48750, avgRating: 4.8 },
      { name: '轮胎更换', count: 286, revenue: 34320, avgRating: 4.7 },
      { name: '发动机维修', count: 178, revenue: 35600, avgRating: 4.9 },
      { name: '刹车系统保养', count: 165, revenue: 19800, avgRating: 4.6 },
      { name: '电路检修', count: 132, revenue: 15840, avgRating: 4.5 },
      { name: '车身清洗', count: 345, revenue: 17250, avgRating: 4.4 },
      { name: '改装服务', count: 89, revenue: 44500, avgRating: 4.9 },
      { name: '电池更换', count: 156, revenue: 23400, avgRating: 4.7 }
    ]
    
    // 更新图表
    updateCharts()
  } catch (error) {
    console.error('加载统计数据失败:', error)
    ElMessage.error('加载统计数据失败')
  }
}

// 初始化图表
const initCharts = () => {
  // 预约趋势图
  const appointmentTrendElement = document.getElementById('appointment-trend-chart')
  if (appointmentTrendElement) {
    appointmentTrendChart = echarts.init(appointmentTrendElement)
  }
  
  // 服务类型分布图
  const serviceTypeElement = document.getElementById('service-type-chart')
  if (serviceTypeElement) {
    serviceTypeChart = echarts.init(serviceTypeElement)
  }
  
  // 收入趋势图
  const incomeTrendElement = document.getElementById('income-trend-chart')
  if (incomeTrendElement) {
    incomeTrendChart = echarts.init(incomeTrendElement)
  }
  
  // 地理分布图
  const geoDistributionElement = document.getElementById('geo-distribution-chart')
  if (geoDistributionElement) {
    geoDistributionChart = echarts.init(geoDistributionElement)
  }
}

// 更新图表
const updateCharts = () => {
  // 生成过去7天的日期标签
  const dates = []
  const now = new Date()
  for (let i = 6; i >= 0; i--) {
    const date = new Date(now)
    date.setDate(date.getDate() - i)
    dates.push(`${date.getMonth() + 1}/${date.getDate()}`)
  }
  
  // 模拟预约趋势数据
  const appointmentData = [120, 132, 101, 134, 90, 160, 130]
  const comparisonData = [100, 110, 120, 115, 105, 125, 120]
  
  // 预约趋势图配置
  if (appointmentTrendChart) {
    appointmentTrendChart.setOption({
      title: {
        text: '预约量趋势',
        left: 'center',
        textStyle: {
          fontSize: 16,
          fontWeight: 500
        }
      },
      tooltip: {
        trigger: 'axis'
      },
      legend: {
        data: ['当前周期', '上一周期'],
        bottom: 0
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '15%',
        top: '20%',
        containLabel: true
      },
      xAxis: {
        type: 'category',
        boundaryGap: false,
        data: dates
      },
      yAxis: {
        type: 'value'
      },
      series: [
        {
          name: '当前周期',
          type: 'line',
          stack: 'Total',
          data: appointmentData,
          smooth: true,
          lineStyle: {
            color: '#409EFF'
          },
          areaStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(64, 158, 255, 0.3)' },
              { offset: 1, color: 'rgba(64, 158, 255, 0.1)' }
            ])
          }
        },
        {
          name: '上一周期',
          type: 'line',
          stack: 'Total',
          data: comparisonData,
          smooth: true,
          lineStyle: {
            color: '#909399',
            type: 'dashed'
          }
        }
      ]
    })
  }
  
  // 服务类型分布数据
  const serviceTypeData = [
    { value: 325, name: '摩托车保养' },
    { value: 286, name: '轮胎更换' },
    { value: 178, name: '发动机维修' },
    { value: 165, name: '刹车系统保养' },
    { value: 132, name: '电路检修' },
    { value: 345, name: '车身清洗' },
    { value: 89, name: '改装服务' },
    { value: 156, name: '电池更换' }
  ]
  
  // 服务类型分布图配置
  if (serviceTypeChart) {
    serviceTypeChart.setOption({
      title: {
        text: '服务类型分布',
        left: 'center',
        textStyle: {
          fontSize: 16,
          fontWeight: 500
        }
      },
      tooltip: {
        trigger: 'item',
        formatter: '{b}: {c} ({d}%)'
      },
      legend: {
        orient: 'vertical',
        left: 'left',
        top: 'middle',
        formatter: (name: string) => {
          const item = serviceTypeData.find(item => item.name === name)
          return `${name} (${item?.value})`
        }
      },
      series: [
        {
          name: '服务类型',
          type: 'pie',
          radius: '60%',
          center: ['60%', '50%'],
          data: serviceTypeData,
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.5)'
            }
          },
          label: {
            formatter: '{b}\n{d}%'
          }
        }
      ]
    })
  }
  
  // 模拟收入数据
  const incomeData = [15200, 18500, 12600, 16800, 14500, 21000, 19500]
  const incomeComparisonData = [13200, 15500, 14600, 15800, 13500, 18000, 16500]
  
  // 收入趋势图配置
  if (incomeTrendChart) {
    incomeTrendChart.setOption({
      title: {
        text: '收入趋势',
        left: 'center',
        textStyle: {
          fontSize: 16,
          fontWeight: 500
        }
      },
      tooltip: {
        trigger: 'axis',
        formatter: (params: any) => {
          let result = params[0].name + '<br/>'
          params.forEach((param: any) => {
            result += `${param.marker}${param.seriesName}: ¥${param.value.toLocaleString()}<br/>`
          })
          return result
        }
      },
      legend: {
        data: ['当前周期', '上一周期'],
        bottom: 0
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '15%',
        top: '20%',
        containLabel: true
      },
      xAxis: {
        type: 'category',
        boundaryGap: false,
        data: dates
      },
      yAxis: {
        type: 'value',
        axisLabel: {
          formatter: (value: number) => '¥' + (value / 10000).toFixed(1) + 'w'
        }
      },
      series: [
        {
          name: '当前周期',
          type: 'line',
          stack: 'Total',
          data: incomeData,
          smooth: true,
          lineStyle: {
            color: '#67C23A'
          },
          areaStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(103, 194, 58, 0.3)' },
              { offset: 1, color: 'rgba(103, 194, 58, 0.1)' }
            ])
          }
        },
        {
          name: '上一周期',
          type: 'line',
          stack: 'Total',
          data: incomeComparisonData,
          smooth: true,
          lineStyle: {
            color: '#909399',
            type: 'dashed'
          }
        }
      ]
    })
  }
  
  // 地理分布数据
  const geoData = [
    { name: '北京', value: 235 },
    { name: '上海', value: 225 },
    { name: '广州', value: 158 },
    { name: '深圳', value: 148 },
    { name: '成都', value: 125 },
    { name: '杭州', value: 115 },
    { name: '武汉', value: 98 },
    { name: '西安', value: 88 },
    { name: '南京', value: 85 },
    { name: '重庆', value: 82 }
  ]
  
  // 地理分布图配置
  if (geoDistributionChart) {
    geoDistributionChart.setOption({
      title: {
        text: '服务地域分布',
        left: 'center',
        textStyle: {
          fontSize: 16,
          fontWeight: 500
        }
      },
      tooltip: {
        trigger: 'item',
        formatter: '{b}: {c}家店铺'
      },
      visualMap: {
        min: 0,
        max: 250,
        left: 'left',
        top: 'bottom',
        text: ['高', '低'],
        calculable: true
      },
      series: [
        {
          name: '店铺数量',
          type: 'map',
          map: 'china',
          roam: false,
          label: {
            show: true,
            fontSize: 10
          },
          emphasis: {
            label: {
              show: true,
              fontSize: 12,
              fontWeight: 'bold'
            },
            itemStyle: {
              areaColor: '#ffcc33'
            }
          },
          data: geoData
        }
      ]
    })
  }
}

// 处理窗口大小变化
const handleResize = () => {
  if (appointmentTrendChart) appointmentTrendChart.resize()
  if (serviceTypeChart) serviceTypeChart.resize()
  if (incomeTrendChart) incomeTrendChart.resize()
  if (geoDistributionChart) geoDistributionChart.resize()
}

// 切换时间范围
const handleDateTypeChange = (value: string) => {
  dateType.value = value
  if (value !== 'custom') {
    dateRange.value = ['', '']
  }
  loadStatisticsData()
}

// 处理日期范围变化
const handleDateRangeChange = () => {
  if (dateRange.value[0] && dateRange.value[1]) {
    dateType.value = 'custom'
    loadStatisticsData()
  }
}

// 格式化数字
const formatNumber = (num: number) => {
  if (num >= 10000) {
    return (num / 10000).toFixed(1) + '万'
  }
  return num.toString()
}

// 格式化金额
const formatMoney = (amount: number) => {
  return '¥' + amount.toLocaleString()
}

// 获取增长率图标
const getGrowthIcon = (rate: number) => {
  return rate >= 0 ? <ArrowUp /> : <ArrowDown />
}

// 获取增长率样式
const getGrowthStyle = (rate: number) => {
  return {
    color: rate >= 0 ? '#67C23A' : '#F56C6C'
  }
}
</script>

<template>
  <div class="admin-statistics-container">
    <div class="page-header">
      <h1>数据统计</h1>
      
      <div class="date-selector">
        <el-select v-model="dateType" placeholder="选择时间范围" @change="handleDateTypeChange">
          <el-option label="近7天" value="7d" />
          <el-option label="近30天" value="30d" />
          <el-option label="近90天" value="90d" />
          <el-option label="自定义" value="custom" />
        </el-select>
        
        <el-date-picker
          v-model="dateRange"
          type="daterange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          value-format="YYYY-MM-DD"
          style="margin-left: 10px"
          @change="handleDateRangeChange"
          :disabled="dateType !== 'custom'"
        />
      </div>
    </div>

    <!-- 统计卡片 -->
    <div class="stats-grid">
      <el-card class="stat-card">
        <div class="stat-icon user-icon">
          <User />
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ formatNumber(statistics.totalUsers) }}</div>
          <div class="stat-label">总用户数</div>
          <div class="stat-change" :style="getGrowthStyle(statistics.userGrowthRate)">
            {{ getGrowthIcon(statistics.userGrowthRate) }}
            <span>{{ Math.abs(statistics.userGrowthRate) }}%</span>
            <span class="change-label">较上期</span>
          </div>
        </div>
        <div class="stat-detail">
          新增: {{ formatNumber(statistics.newUsers) }}
        </div>
      </el-card>

      <el-card class="stat-card">
        <div class="stat-icon shop-icon">
          <Business />
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ formatNumber(statistics.totalShops) }}</div>
          <div class="stat-label">总商家数</div>
          <div class="stat-change" :style="getGrowthStyle(statistics.shopGrowthRate)">
            {{ getGrowthIcon(statistics.shopGrowthRate) }}
            <span>{{ Math.abs(statistics.shopGrowthRate) }}%</span>
            <span class="change-label">较上期</span>
          </div>
        </div>
        <div class="stat-detail">
          新增: {{ formatNumber(statistics.newShops) }}
        </div>
      </el-card>

      <el-card class="stat-card">
        <div class="stat-icon appointment-icon">
          <Calendar />
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ formatNumber(statistics.totalAppointments) }}</div>
          <div class="stat-label">总预约数</div>
          <div class="stat-change" :style="getGrowthStyle(statistics.appointmentGrowthRate)">
            {{ getGrowthIcon(statistics.appointmentGrowthRate) }}
            <span>{{ Math.abs(statistics.appointmentGrowthRate) }}%</span>
            <span class="change-label">较上期</span>
          </div>
        </div>
        <div class="stat-detail">
          待处理: {{ statistics.pendingAppointments }}
        </div>
      </el-card>

      <el-card class="stat-card">
        <div class="stat-icon income-icon">
          <DollarSign />
        </div>
        <div class="stat-content">
          <div class="stat-number">{{ formatMoney(statistics.totalIncome) }}</div>
          <div class="stat-label">总收入</div>
          <div class="stat-change" :style="getGrowthStyle(statistics.incomeGrowthRate)">
            {{ getGrowthIcon(statistics.incomeGrowthRate) }}
            <span>{{ Math.abs(statistics.incomeGrowthRate) }}%</span>
            <span class="change-label">较上期</span>
          </div>
        </div>
        <div class="stat-detail">
          客单价: {{ formatMoney(statistics.averageOrderValue) }}
        </div>
      </el-card>
    </div>

    <!-- 趋势图表 -->
    <el-tabs v-model="activeTab" class="charts-tabs">
      <el-tab-pane label="预约趋势" name="appointment">
        <el-card class="chart-card">
          <div id="appointment-trend-chart" class="chart-container"></div>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="服务类型" name="service">
        <el-card class="chart-card">
          <div id="service-type-chart" class="chart-container"></div>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="收入分析" name="income">
        <el-card class="chart-card">
          <div id="income-trend-chart" class="chart-container"></div>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="地域分布" name="geo">
        <el-card class="chart-card">
          <div id="geo-distribution-chart" class="chart-container"></div>
        </el-card>
      </el-tab-pane>
    </el-tabs>

    <!-- 热门服务 -->
    <div class="popular-services-section">
      <h2>热门服务排行</h2>
      <el-card class="services-card">
        <el-table :data="popularServices" style="width: 100%">
          <el-table-column type="index" width="80" label="排名" />
          <el-table-column prop="name" label="服务名称" min-width="150" />
          <el-table-column prop="count" label="预约次数" width="120">
            <template #default="{ row }">
              <div>
                {{ row.count }}
                <span class="count-unit">次</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="revenue" label="营收" width="120">
            <template #default="{ row }">
              <span class="revenue-amount">{{ formatMoney(row.revenue) }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="avgRating" label="平均评分" width="120">
            <template #default="{ row }">
              <div class="rating-container">
                <el-rate v-model="row.avgRating" disabled show-score />
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="count" label="占比" min-width="150">
            <template #default="{ row }">
              <div class="percentage-container">
                <el-progress 
                  :percentage="(row.count / statistics.totalAppointments * 100).toFixed(1)" 
                  :format="() => ''"
                  color="#409EFF"
                />
                <span class="percentage-value">
                  {{ (row.count / statistics.totalAppointments * 100).toFixed(1) }}%
                </span>
              </div>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </div>
  </div>
</template>

<style scoped>
.admin-statistics-container {
  padding: 20px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.page-header h1 {
  font-size: 24px;
  font-weight: 500;
  color: #303133;
  margin: 0;
}

.date-selector {
  display: flex;
  align-items: center;
}

/* 统计卡片 */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 30px;
}

.stat-card {
  position: relative;
  background-color: #ffffff;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.stat-icon {
  position: absolute;
  top: 20px;
  right: 20px;
  width: 48px;
  height: 48px;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 24px;
  opacity: 0.1;
}

.user-icon {
  background-color: #409EFF;
  color: #409EFF;
}

.shop-icon {
  background-color: #67C23A;
  color: #67C23A;
}

.appointment-icon {
  background-color: #E6A23C;
  color: #E6A23C;
}

.income-icon {
  background-color: #F56C6C;
  color: #F56C6C;
}

.stat-content {
  padding: 20px;
}

.stat-number {
  font-size: 32px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  color: #606266;
  margin-bottom: 10px;
}

.stat-change {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 14px;
  font-weight: 500;
}

.change-label {
  color: #909399;
  font-weight: normal;
}

.stat-detail {
  position: absolute;
  bottom: 15px;
  left: 20px;
  font-size: 12px;
  color: #909399;
}

/* 图表区域 */
.charts-tabs {
  margin-bottom: 30px;
}

.chart-card {
  background-color: #ffffff;
  border-radius: 8px;
  padding: 20px;
}

.chart-container {
  width: 100%;
  height: 400px;
}

/* 热门服务 */
.popular-services-section {
  margin-bottom: 30px;
}

.popular-services-section h2 {
  font-size: 20px;
  font-weight: 500;
  color: #303133;
  margin-bottom: 15px;
}

.services-card {
  background-color: #ffffff;
  border-radius: 8px;
}

.count-unit {
  color: #909399;
  font-size: 12px;
  margin-left: 2px;
}

.revenue-amount {
  color: #F56C6C;
  font-weight: 500;
}

.rating-container {
  display: flex;
  justify-content: center;
}

.percentage-container {
  display: flex;
  align-items: center;
  gap: 10px;
}

.percentage-value {
  font-size: 12px;
  color: #606266;
  min-width: 50px;
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .admin-statistics-container {
    padding: 10px;
  }
  
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }
  
  .date-selector {
    width: 100%;
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .date-selector .el-select,
  .date-selector .el-date-picker {
    width: 100%;
    margin-left: 0 !important;
  }
  
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .chart-container {
    height: 300px;
  }
  
  .el-table {
    font-size: 12px;
  }
  
  .percentage-container {
    flex-direction: column;
    align-items: flex-start;
    gap: 5px;
  }
}

@media (max-width: 480px) {
  .page-header h1 {
    font-size: 20px;
  }
  
  .stat-number {
    font-size: 24px;
  }
  
  .stat-icon {
    width: 40px;
    height: 40px;
    font-size: 20px;
    top: 15px;
    right: 15px;
  }
}
</style>