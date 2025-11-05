const AMAP_KEY = 'e95641304e550bc391789d699c39be09'
const AMAP_SECURITY_CODE = '93c9f5862d0214cca10b61ff3e48c9a5'

const AMAP_SCRIPT_SRC = `https://webapi.amap.com/maps?v=2.0&key=${AMAP_KEY}&plugin=AMap.Geolocation,AMap.Geocoder,AMap.GeometryUtil&securityJsCode=${AMAP_SECURITY_CODE}`

let amapPromise: Promise<any> | null = null

export const loadAMap = (): Promise<any> => {
  if (typeof window === 'undefined') {
    return Promise.reject(new Error('AMap JS API can only be loaded in a browser environment'))
  }

  if (window.AMap) {
    return Promise.resolve(window.AMap)
  }

  if (amapPromise) {
    return amapPromise
  }

  amapPromise = new Promise((resolve, reject) => {
    const script = document.createElement('script')
    script.type = 'text/javascript'
    script.async = true
    script.src = AMAP_SCRIPT_SRC

    script.onload = () => {
      if (window.AMap) {
        resolve(window.AMap)
      } else {
        reject(new Error('AMap JS API failed to load'))
        amapPromise = null
      }
    }

    script.onerror = () => {
      reject(new Error('AMap JS API failed to load'))
      amapPromise = null
      script.remove()
    }

    document.head.appendChild(script)
  })

  return amapPromise
}

declare global {
  interface Window {
    AMap: any
  }
}
