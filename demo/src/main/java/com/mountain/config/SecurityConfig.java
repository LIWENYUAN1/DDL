package com.mountain.config;

import com.mountain.security.JwtAuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * Spring Security配置类
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // 关闭CSRF（前后端分离项目）
            .csrf(csrf -> csrf.disable())
            // 不通过Session获取SecurityContext
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            // 配置授权规则
            .authorizeHttpRequests(auth -> auth
                // 允许所有用户访问的接口（同时支持 /api/auth 和 /auth）
                .requestMatchers("/api/auth/**", "/auth/**").permitAll()
                .requestMatchers("/actuator/**").permitAll()
                .requestMatchers("/error").permitAll()
                // 公共API（无需登录）
                .requestMatchers("/api/public/**").permitAll()
                // 管理员端接口
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                // 商家端接口
                .requestMatchers("/api/merchant/**").hasAnyRole("MERCHANT", "ADMIN")
                // 预约接口（用户和商家都可以访问）
                .requestMatchers("/api/appointment/**").hasAnyRole("USER", "MERCHANT", "ADMIN")
                // 用户端接口
                .requestMatchers("/api/user/**").hasAnyRole("USER", "ADMIN")
                // 其他所有请求都需要认证
                .anyRequest().authenticated()
            )
            // 添加JWT过滤器
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}