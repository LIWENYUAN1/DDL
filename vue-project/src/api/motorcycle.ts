import axios from '@/utils/axios'

export interface MotorcyclePayload {
  brand: string
  model: string
  licensePlate?: string
  displacement?: number
  purchaseDate?: string
  vin?: string
  status?: number
}

export const fetchMotorcycles = () => {
  return axios.get('/user/motorcycles')
}

export const createMotorcycle = (payload: MotorcyclePayload) => {
  return axios.post('/user/motorcycles', payload)
}

export const updateMotorcycle = (id: number, payload: MotorcyclePayload) => {
  return axios.put(`/user/motorcycles/${id}`, payload)
}

export const removeMotorcycle = (id: number) => {
  return axios.delete(`/user/motorcycles/${id}`)
}
