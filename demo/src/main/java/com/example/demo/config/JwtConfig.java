package com.example.demo.config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * JWT配置类
 */
@Slf4j
@Component
public class JwtConfig {

    /**
     * 密钥(Base64编码)
     */
    @Value("${jwt.secret:bW90b3JjeWNsZS1wbGF0Zm9ybS1zdXBlci1zZWNyZXQta2V5LWZvci1qd3QtdG9rZW4tZ2VuZXJhdGlvbi0yMDI0LWxvbmctZW5vdWdoLWZvci1obWFjLXNoYTUxMg==}")
    private String secret;

    /**
     * 过期时间（毫秒）
     */
    @Value("${jwt.expiration:86400000}")
    private long expiration;

    /**
     * 获取签名密钥
     */
    private Key getSigningKey() {
        try {
            byte[] keyBytes = Base64.getDecoder().decode(secret);
            return Keys.hmacShaKeyFor(keyBytes);
        } catch (Exception e) {
            log.error("获取签名密钥失败", e);
            // 如果Base64解码失败，直接使用原始字符串
            byte[] keyBytes = secret.getBytes();
            // 确保密钥长度足够(HMAC-SHA512需要至少64字节)
            if (keyBytes.length < 64) {
                byte[] paddedKey = new byte[64];
                System.arraycopy(keyBytes, 0, paddedKey, 0, Math.min(keyBytes.length, 64));
                return Keys.hmacShaKeyFor(paddedKey);
            }
            return Keys.hmacShaKeyFor(keyBytes);
        }
    }

    /**
     * 生成JWT令牌
     * @param userId 用户ID
     * @param username 用户名
     * @param userType 用户类型
     * @return JWT令牌
     */
    public String generateToken(Long userId, String username, Integer userType) {
        try {
            Date now = new Date();
            Date expirationDate = new Date(now.getTime() + expiration);

            Map<String, Object> claims = new HashMap<>();
            claims.put("userId", userId);
            claims.put("username", username);
            claims.put("userType", userType);

            String token = Jwts.builder()
                    .setClaims(claims)
                    .setIssuedAt(now)
                    .setExpiration(expirationDate)
                    .signWith(getSigningKey(), SignatureAlgorithm.HS512)
                    .compact();
            
            log.info("成功生成token for user: {}, userType: {}", username, userType);
            return token;
        } catch (Exception e) {
            log.error("生成token失败 for user: " + username, e);
            throw new RuntimeException("生成token失败", e);
        }
    }

    /**
     * 解析JWT令牌
     * @param token JWT令牌
     * @return Claims
     */
    public Claims parseToken(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(getSigningKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            log.error("解析token失败", e);
            throw new RuntimeException("解析token失败", e);
        }
    }

    /**
     * 从令牌中获取用户ID
     * @param token JWT令牌
     * @return 用户ID
     */
    public Long getUserIdFromToken(String token) {
        Claims claims = parseToken(token);
        return Long.parseLong(claims.get("userId").toString());
    }

    /**
     * 从令牌中获取用户名
     * @param token JWT令牌
     * @return 用户名
     */
    public String getUsernameFromToken(String token) {
        Claims claims = parseToken(token);
        return claims.get("username").toString();
    }

    /**
     * 从令牌中获取用户类型
     * @param token JWT令牌
     * @return 用户类型
     */
    public Integer getUserTypeFromToken(String token) {
        Claims claims = parseToken(token);
        return Integer.parseInt(claims.get("userType").toString());
    }

    /**
     * 验证令牌是否过期
     * @param token JWT令牌
     * @return 是否过期
     */
    public boolean isTokenExpired(String token) {
        try {
            Claims claims = parseToken(token);
            Date expiration = claims.getExpiration();
            return expiration.before(new Date());
        } catch (Exception e) {
            return true;
        }
    }
}