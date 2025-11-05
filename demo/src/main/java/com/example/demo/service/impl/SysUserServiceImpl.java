package com.example.demo.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.demo.common.ResultCode;
import com.example.demo.config.JwtConfig;
import com.example.demo.dto.LoginRequestDTO;
import com.example.demo.dto.RegisterRequestDTO;
import com.example.demo.dto.UserDTO;
import com.example.demo.entity.OwnerInfo;
import com.example.demo.entity.SysUser;
import com.example.demo.exception.BusinessException;
import com.example.demo.mapper.SysUserMapper;
import com.example.demo.mapper.OwnerInfoMapper;
import com.example.demo.service.SysUserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 用户服务实现类
 */
@Slf4j
@Service
public class SysUserServiceImpl extends ServiceImpl<SysUserMapper, SysUser> implements SysUserService {

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtConfig jwtConfig;

    @Autowired
    private OwnerInfoMapper ownerInfoMapper;

    @Override
    public UserDTO login(LoginRequestDTO loginRequestDTO) {
        // 根据用户名查询用户
        SysUser user = sysUserMapper.selectByUsername(loginRequestDTO.getUsername());
        if (user == null) {
            throw new BusinessException(ResultCode.USERNAME_OR_PASSWORD_ERROR);
        }

        // 验证密码
        if (!passwordEncoder.matches(loginRequestDTO.getPassword(), user.getPassword())) {
            throw new BusinessException(ResultCode.USERNAME_OR_PASSWORD_ERROR);
        }

        // 验证用户类型
        if (user.getUserType() != loginRequestDTO.getUserType()) {
            throw new BusinessException(ResultCode.USER_TYPE_ERROR);
        }

        // 验证用户状态
        if (user.getStatus() == 0) {
            throw new BusinessException(ResultCode.USER_ACCOUNT_DISABLED);
        }

        // 生成token
        String token = generateToken(user);

        // 转换为DTO返回
        UserDTO userDTO = new UserDTO();
        userDTO.setId(user.getId());
        userDTO.setUsername(user.getUsername());
        userDTO.setPhone(user.getPhone());
        userDTO.setEmail(user.getEmail());
        userDTO.setUserType(user.getUserType());
        userDTO.setAvatar(user.getAvatar());
        userDTO.setRealName(user.getRealName());
        userDTO.setToken(token);

        OwnerInfo ownerInfo = ownerInfoMapper.selectByUserId(user.getId());
        if (ownerInfo != null) {
            userDTO.setAddress(ownerInfo.getAddress());
            userDTO.setLatitude(convertToDouble(ownerInfo.getLatitude()));
            userDTO.setLongitude(convertToDouble(ownerInfo.getLongitude()));
        }

        return userDTO;
    }

    @Override
    public boolean register(RegisterRequestDTO registerRequestDTO) {
        // 验证用户名是否已存在
        SysUser existingUser = sysUserMapper.selectByUsername(registerRequestDTO.getUsername());
        if (existingUser != null) {
            throw new BusinessException(ResultCode.USERNAME_ALREADY_EXISTS);
        }

        // 验证手机号是否已存在
        existingUser = sysUserMapper.selectByPhone(registerRequestDTO.getPhone());
        if (existingUser != null) {
            throw new BusinessException(ResultCode.PHONE_ALREADY_EXISTS);
        }

        // 验证两次密码是否一致
        if (!registerRequestDTO.getPassword().equals(registerRequestDTO.getConfirmPassword())) {
            throw new BusinessException(ResultCode.PASSWORD_CONFIRM_ERROR);
        }

        // 创建用户对象
        SysUser user = new SysUser();
        user.setUsername(registerRequestDTO.getUsername());
        user.setPassword(passwordEncoder.encode(registerRequestDTO.getPassword()));
        user.setPhone(registerRequestDTO.getPhone());
        user.setUserType(registerRequestDTO.getUserType());
        user.setStatus(1); // 默认为启用状态
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());

        // 保存用户
        return sysUserMapper.insert(user) > 0;
    }

    @Override
    public UserDTO getUserInfoById(Long userId) {
        SysUser user = this.getById(userId);
        if (user == null) {
            throw new BusinessException(ResultCode.USER_NOT_EXIST);
        }

        UserDTO userDTO = new UserDTO();
        userDTO.setId(user.getId());
        userDTO.setUsername(user.getUsername());
        userDTO.setPhone(user.getPhone());
        userDTO.setEmail(user.getEmail());
        userDTO.setUserType(user.getUserType());
        userDTO.setAvatar(user.getAvatar());
        userDTO.setRealName(user.getRealName());

        OwnerInfo ownerInfo = ownerInfoMapper.selectByUserId(userId);
        if (ownerInfo != null) {
            userDTO.setAddress(ownerInfo.getAddress());
            userDTO.setLatitude(convertToDouble(ownerInfo.getLatitude()));
            userDTO.setLongitude(convertToDouble(ownerInfo.getLongitude()));
        }
        return userDTO;
    }

    @Override
    public boolean updateUserInfo(UserDTO userDTO) {
        SysUser user = this.getById(userDTO.getId());
        if (user == null) {
            throw new BusinessException(ResultCode.USER_NOT_EXIST);
        }

        // 只更新允许修改的字段
        if (userDTO.getRealName() != null) {
            user.setRealName(userDTO.getRealName());
        }
        if (userDTO.getAvatar() != null) {
            user.setAvatar(userDTO.getAvatar());
        }
        if (userDTO.getPhone() != null) {
            user.setPhone(userDTO.getPhone());
        }
        if (userDTO.getEmail() != null) {
            user.setEmail(userDTO.getEmail());
        }
        user.setUpdateTime(LocalDateTime.now());

        boolean updated = this.updateById(user);

        if (userDTO.getAddress() != null || userDTO.getLatitude() != null || userDTO.getLongitude() != null) {
            OwnerInfo ownerInfo = ownerInfoMapper.selectByUserId(userDTO.getId());
            if (ownerInfo == null) {
                ownerInfo = new OwnerInfo();
                ownerInfo.setUserId(userDTO.getId());
                ownerInfo.setCreateTime(LocalDateTime.now());
            }
            if (userDTO.getAddress() != null) {
                ownerInfo.setAddress(userDTO.getAddress());
            }
            if (userDTO.getLatitude() != null) {
                ownerInfo.setLatitude(BigDecimal.valueOf(userDTO.getLatitude()));
            }
            if (userDTO.getLongitude() != null) {
                ownerInfo.setLongitude(BigDecimal.valueOf(userDTO.getLongitude()));
            }
            ownerInfo.setUpdateTime(LocalDateTime.now());

            if (ownerInfo.getId() == null) {
                ownerInfoMapper.insert(ownerInfo);
            } else {
                ownerInfoMapper.updateById(ownerInfo);
            }
        }

        return updated;
    }

    @Override
    public boolean resetPassword(Long userId, String oldPassword, String newPassword) {
        SysUser user = this.getById(userId);
        if (user == null) {
            throw new BusinessException(ResultCode.USER_NOT_EXIST);
        }

        // 验证旧密码
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new BusinessException(ResultCode.OLD_PASSWORD_ERROR);
        }

        // 设置新密码
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setUpdateTime(LocalDateTime.now());

        return this.updateById(user);
    }

    private Double convertToDouble(BigDecimal value) {
        return value != null ? value.doubleValue() : null;
    }

    private String generateToken(SysUser user) {
        // 使用JwtConfig生成真实的JWT token
        String token = jwtConfig.generateToken(user.getId(), user.getUsername(), user.getUserType());
        log.info("为用户 {} 生成token: {}", user.getUsername(), token);
        return token;
    }
}
