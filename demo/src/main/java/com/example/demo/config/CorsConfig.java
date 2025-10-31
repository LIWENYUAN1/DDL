package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

/**
 * 跨域配置
 */
@Configuration
public class CorsConfig {

    @Bean
    public CorsFilter corsFilter() {
        // 创建CORS配置源
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        
        // 创建CORS配置
        CorsConfiguration config = new CorsConfiguration();
        
        // 允许所有来源进行跨域请求
        config.addAllowedOriginPattern("*");
        
        // 允许所有请求头
        config.addAllowedHeader("*");
        
        // 允许所有HTTP方法
        config.addAllowedMethod("*");
        
        // 允许携带凭证（如cookies）
        config.setAllowCredentials(true);
        
        // 设置预检请求的有效期，单位为秒
        config.setMaxAge(3600L);
        
        // 应用配置到所有路径
        source.registerCorsConfiguration("/**", config);
        
        return new CorsFilter(source);
    }
}