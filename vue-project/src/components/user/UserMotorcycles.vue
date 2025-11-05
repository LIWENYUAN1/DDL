<template>
  <div class="user-motorcycles">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <h3>我的车辆</h3>
          <el-button type="primary" @click="showAddDialog = true">
            <el-icon><Plus /></el-icon>
            添加车辆
          </el-button>
        </div>
      </template>

      <!-- 车辆列表 -->
      <el-row :gutter="20" v-loading="loading">
        <el-col 
          :xs="24" 
          :sm="12" 
          :md="8"
          v-for="motorcycle in motorcycles" 
          :key="motorcycle.id"
        >
          <el-card class="motorcycle-card" shadow="hover">
            <div class="motorcycle-header">
              <img 
                :src="motorcycle.image || defaultImage" 
                class="motorcycle-image" 
              />
            </div>
            <div class="motorcycle-info">
              <h4>{{ motorcycle.brand }} {{ motorcycle.model }}</h4>
              <el-descriptions :column="1" size="small">
                <el-descriptions-item label="车牌号">
                  {{ motorcycle.licensePlate || '未上牌' }}
                </el-descriptions-item>
                <el-descriptions-item label="排量">
                  {{ motorcycle.displacement }}cc
                </el-descriptions-item>
                <el-descriptions-item label="购买日期">
                  {{ motorcycle.purchaseDate }}
                </el-descriptions-item>
                <el-descriptions-item label="状态">
                  <el-tag :type="motorcycle.status === 1 ? 'success' : 'info'">
                    {{ motorcycle.status === 1 ? '正常使用' : '已注销' }}
                  </el-tag>
                </el-descriptions-item>
              </el-descriptions>
            </div>
            <div class="motorcycle-actions">
              <el-button size="small" @click="editMotorcycle(motorcycle)">
                编辑
              </el-button>
              <el-button 
                size="small" 
                type="danger"
                @click="deleteMotorcycle(motorcycle)"
              >
                删除
              </el-button>
            </div>
          </el-card>
        </el-col>
      </el-row>

      <!-- 空状态 -->
      <el-empty 
        v-if="!loading && motorcycles.length === 0" 
        description="还没有添加车辆"
      >
        <el-button type="primary" @click="showAddDialog = true">
          添加车辆
        </el-button>
      </el-empty>
    </el-card>

    <!-- 添加/编辑车辆对话框 -->
    <el-dialog
      v-model="showAddDialog"
      :title="isEdit ? '编辑车辆' : '添加车辆'"
      width="500px"
      @close="resetForm"
    >
      <el-form
        ref="formRef"
        :model="motorcycleForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="品牌" prop="brand">
          <el-input v-model="motorcycleForm.brand" placeholder="如：本田、雅马哈" />
        </el-form-item>
        <el-form-item label="车型" prop="model">
          <el-input v-model="motorcycleForm.model" placeholder="如：CB400X、YZF-R3" />
        </el-form-item>
        <el-form-item label="车牌号" prop="licensePlate">
          <el-input v-model="motorcycleForm.licensePlate" placeholder="选填，如：云A12345" />
        </el-form-item>
        <el-form-item label="排量(cc)" prop="displacement">
          <el-input-number 
            v-model="motorcycleForm.displacement" 
            :min="50" 
            :max="2000"
            :step="50"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="购买日期" prop="purchaseDate">
          <el-date-picker
            v-model="motorcycleForm.purchaseDate"
            type="date"
            placeholder="选择日期"
            style="width: 100%"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        <el-form-item label="车辆识别码" prop="vin">
          <el-input v-model="motorcycleForm.vin" placeholder="VIN码（选填）" />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="showAddDialog = false">取消</el-button>
        <el-button type="primary" @click="submitForm" :loading="submitting">
          确定
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox, FormInstance, FormRules } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import {
  fetchMotorcycles,
  createMotorcycle,
  updateMotorcycle,
  removeMotorcycle,
  type MotorcyclePayload
} from '@/api/motorcycle'

interface MotorcycleItem extends MotorcyclePayload {
  id: number
  status?: number
  image?: string
}

// 状态
const loading = ref(false)
const submitting = ref(false)
const showAddDialog = ref(false)
const isEdit = ref(false)
const motorcycles = ref<MotorcycleItem[]>([])
const formRef = ref<FormInstance>()

const defaultImage = 'https://via.placeholder.com/300x200?text=Motorcycle'

// 表单数据
const motorcycleForm = reactive({
  id: null as number | null,
  brand: '',
  model: '',
  licensePlate: '',
  displacement: 150,
  purchaseDate: '',
  vin: ''
})

// 表单验证规则
const rules = reactive<FormRules>({
  brand: [
    { required: true, message: '请输入品牌', trigger: 'blur' }
  ],
  model: [
    { required: true, message: '请输入车型', trigger: 'blur' }
  ],
  displacement: [
    { required: true, message: '请输入排量', trigger: 'change' }
  ]
})

// 编辑车辆
const editMotorcycle = (motorcycle: MotorcycleItem) => {
  isEdit.value = true
  Object.assign(motorcycleForm, {
    id: motorcycle.id,
    brand: motorcycle.brand,
    model: motorcycle.model,
    licensePlate: motorcycle.licensePlate || '',
    displacement: motorcycle.displacement || 150,
    purchaseDate: motorcycle.purchaseDate || '',
    vin: motorcycle.vin || ''
  })
  showAddDialog.value = true
}

// 删除车辆
const deleteMotorcycle = (motorcycle: MotorcycleItem) => {
  ElMessageBox.confirm(
    '确定要删除这辆车吗？',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  )
    .then(async () => {
      await removeMotorcycle(motorcycle.id)
      ElMessage.success('删除成功')
      await loadMotorcycles()
    })
    .catch(() => {})
}

const buildPayload = (): MotorcyclePayload => ({
  brand: motorcycleForm.brand.trim(),
  model: motorcycleForm.model.trim(),
  licensePlate: motorcycleForm.licensePlate?.trim() || undefined,
  displacement: motorcycleForm.displacement || undefined,
  purchaseDate: motorcycleForm.purchaseDate || undefined,
  vin: motorcycleForm.vin?.trim() || undefined
})

// 提交表单
const submitForm = async () => {
  try {
    await formRef.value?.validate()
    submitting.value = true

    const payload = buildPayload()

    if (isEdit.value && motorcycleForm.id) {
      await updateMotorcycle(motorcycleForm.id, payload)
      ElMessage.success('车辆信息更新成功')
    } else {
      await createMotorcycle(payload)
      ElMessage.success('车辆添加成功')
    }

    showAddDialog.value = false
    await loadMotorcycles()
  } catch (error) {
    if (error instanceof Error) {
      ElMessage.error(error.message)
    }
    console.error('保存车辆信息失败', error)
  } finally {
    submitting.value = false
  }
}

// 重置表单
const resetForm = () => {
  isEdit.value = false
  Object.assign(motorcycleForm, {
    id: null,
    brand: '',
    model: '',
    licensePlate: '',
    displacement: 150,
    purchaseDate: '',
    vin: ''
  })
  formRef.value?.clearValidate()
}

// 加载车辆列表
const loadMotorcycles = async () => {
  loading.value = true
  try {
    const response = await fetchMotorcycles()
    motorcycles.value = (response.data || []).map(item => ({
      ...item,
      displacement: item.displacement ?? undefined,
      purchaseDate: item.purchaseDate || '',
      status: item.status ?? 1
    }))
  } catch (error) {
    ElMessage.error('车辆信息加载失败')
    console.error('loadMotorcycles error', error)
  } finally {
    loading.value = false
  }
}

// 初始化
onMounted(() => {
  loadMotorcycles()
})
</script>

<style scoped>
.user-motorcycles {
  width: 100%;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h3 {
  margin: 0;
  font-size: 18px;
}

.motorcycle-card {
  margin-bottom: 20px;
  height: 100%;
}

.motorcycle-header {
  margin-bottom: 15px;
}

.motorcycle-image {
  width: 100%;
  height: 200px;
  object-fit: cover;
  border-radius: 4px;
  background-color: #f5f7fa;
}

.motorcycle-info h4 {
  margin: 0 0 15px 0;
  font-size: 18px;
  color: #303133;
}

.motorcycle-actions {
  display: flex;
  gap: 10px;
  margin-top: 15px;
  padding-top: 15px;
  border-top: 1px solid #e0e0e0;
}

.motorcycle-actions .el-button {
  flex: 1;
}
</style>


