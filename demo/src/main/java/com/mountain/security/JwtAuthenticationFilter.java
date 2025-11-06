package com.mountain.security;

import com.mountain.config.JwtConfig;
import com.mountain.entity.SysUser;
import com.mountain.mapper.SysUserMapper;
import io.jsonwebtoken.Claims;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collections;

/**
 * JWT认证过滤器
 */
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtConfig jwtConfig;

    @Autowired
    private SysUserMapper sysUserMapper;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        // 获取Authorization头
        String authorizationHeader = request.getHeader("Authorization");

        // 检查Authorization头格式
        if (StringUtils.hasText(authorizationHeader) && authorizationHeader.startsWith("Bearer ")) {
            String token = authorizationHeader.substring(7);

            try {
                // 验证令牌
                if (!jwtConfig.isTokenExpired(token)) {
                    // 从令牌中获取用户信息
                    Claims claims = jwtConfig.parseToken(token);
                    Long userId = Long.parseLong(claims.get("userId").toString());
                    Integer userType = Integer.parseInt(claims.get("userType").toString());

                    // 查询用户信息
                    SysUser user = sysUserMapper.selectById(userId);
                    if (user != null && user.getStatus() == 1) {
                        // 设置用户权限
                        String role = getRoleByUserType(userType);
                        SimpleGrantedAuthority authority = new SimpleGrantedAuthority("ROLE_" + role);

                        // 创建认证对象
                        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                                user, null, Collections.singletonList(authority));

                        // 设置认证信息到上下文中
                        SecurityContextHolder.getContext().setAuthentication(authentication);
                    }
                }
            } catch (Exception e) {
                // 令牌验证失败，清除认证信息
                SecurityContextHolder.clearContext();
            }
        }

        // 继续过滤链
        filterChain.doFilter(request, response);
    }

    /**
     * 根据用户类型获取角色
     */
    private String getRoleByUserType(Integer userType) {
        switch (userType) {
            case 1:
                return "USER";
            case 2:
                return "MERCHANT";
            case 3:
                return "ADMIN";
            default:
                return "USER";
        }
    }
}