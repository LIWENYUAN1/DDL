package com.example.demo.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.demo.dto.LoginRequestDTO;
import com.example.demo.dto.RegisterRequestDTO;
import com.example.demo.dto.UserDTO;
import com.example.demo.entity.SysUser;

/**
 * 用户服务接口
 */
public interface SysUserService extends IService<SysUser> {

    /**
     * 用户登录
     * @param loginRequestDTO 登录请求参数
     * @return 用户信息和token
     */
    UserDTO login(LoginRequestDTO loginRequestDTO);

    /**
     * 用户注册
     * @param registerRequestDTO 注册请求参数
     * @return 注册结果
     */
    boolean register(RegisterRequestDTO registerRequestDTO);

    /**
     * 根据用户ID获取用户信息
     * @param userId 用户ID
     * @return 用户信息
     */
    UserDTO getUserInfoById(Long userId);

    /**
     * 更新用户信息
     * @param userDTO 用户信息
     * @return 更新结果
     */
    boolean updateUserInfo(UserDTO userDTO);

    /**
     * 重置密码
     * @param userId 用户ID
     * @param oldPassword 旧密码
     * @param newPassword 新密码
     * @return 重置结果
     */
    boolean resetPassword(Long userId, String oldPassword, String newPassword);
}