package com.example.demo.controller;

import com.example.demo.common.R;
import com.example.demo.dto.PasswordResetDTO;
import com.example.demo.dto.UserDTO;
import com.example.demo.entity.SysUser;
import com.example.demo.service.SysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * 用户控制器
 */
@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private SysUserService sysUserService;

    /**
     * 获取用户信息
     * @return 用户信息
     */
    @GetMapping("/info")
    public R<UserDTO> getUserInfo() {
        // 获取当前登录用户
        Long userId = getCurrentUserId();
        
        // 查询用户信息
        UserDTO userDTO = sysUserService.getUserInfoById(userId);
        return R.success(userDTO);
    }

    /**
     * 更新用户信息
     * @param userDTO 用户信息
     * @return 更新结果
     */
    @PutMapping("/update")
    public R<Boolean> updateUserInfo(@Validated @RequestBody UserDTO userDTO) {
        // 获取当前登录用户
        Long userId = getCurrentUserId();
        
        // 设置用户ID
        userDTO.setId(userId);
        
        // 更新用户信息
        boolean result = sysUserService.updateUserInfo(userDTO);
        return R.success(result);
    }

    /**
     * 重置密码
     * @param oldPassword 旧密码
     * @param newPassword 新密码
     * @return 重置结果
     */
    @PostMapping("/resetPassword")
    public R<Boolean> resetPassword(@Validated @RequestBody PasswordResetDTO passwordResetDTO) {
        // 获取当前登录用户
        Long userId = getCurrentUserId();

        // 重置密码
        boolean result = sysUserService.resetPassword(userId, passwordResetDTO.getOldPassword(), passwordResetDTO.getNewPassword());
        return R.success(result);
    }

    /**
     * 获取当前登录用户ID
     */
    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        SysUser user = (SysUser) authentication.getPrincipal();
        return user.getId();
    }
}