import axios from '@/utils/axios'

export const getUserFavorites = () => {
  return axios.get('/api/user/favorites')
}

export const removeUserFavorite = (favoriteId: number) => {
  return axios.delete(`/api/user/favorites/${favoriteId}`)
}

export const getBrowseHistory = () => {
  return axios.get('/api/user/history')
}

export const clearBrowseHistory = () => {
  return axios.delete('/api/user/history')
}

export const toggleFavoriteShop = (shopId: number) => {
  return axios.post(`/api/user/favorites/toggle/${shopId}`)
}
