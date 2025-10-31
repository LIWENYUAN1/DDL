package com.example.demo.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.demo.common.R;
import com.example.demo.common.PageResult;
import com.example.demo.dto.PageDTO;
import com.example.demo.entity.Appointment;
import com.example.demo.entity.Merchant;
import com.example.demo.entity.SysUser;
import com.example.demo.mapper.AppointmentMapper;
import com.example.demo.mapper.MerchantMapper;
import com.example.demo.mapper.SysUserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 管理员控制器
 */
@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @Autowired
    private SysUserMapper sysUserMapper;

    @Autowired
    private MerchantMapper merchantMapper;

    @Autowired
    private AppointmentMapper appointmentMapper;

    /**
     * 获取用户列表
     */
    @GetMapping("/users")
    public R<PageResult<SysUser>> getUserList(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) Integer userType,
            @RequestParam(required = false) String keyword) {
        
        Page<SysUser> page = new Page<>(pageNum, pageSize);
        QueryWrapper<SysUser> wrapper = new QueryWrapper<>();
        
        if (userType != null) {
            wrapper.eq("user_type", userType);
        }
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like("username", keyword).or().like("phone", keyword));
        }
        wrapper.orderByDesc("create_time");
        
        Page<SysUser> resultPage = sysUserMapper.selectPage(page, wrapper);
        
        PageResult<SysUser> pageResult = new PageResult<>();
        pageResult.setRecords(resultPage.getRecords());
        pageResult.setCurrent(resultPage.getCurrent());
        pageResult.setSize(resultPage.getSize());
        pageResult.setTotal(resultPage.getTotal());
        pageResult.setPages(resultPage.getPages());
        
        return R.success(pageResult);
    }

    /**
     * 修改用户状态
     */
    @PutMapping("/users/{userId}/status")
    public R<Boolean> updateUserStatus(
            @PathVariable Long userId,
            @RequestParam Integer status) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            return R.error("用户不存在");
        }
        
        user.setStatus(status);
        int result = sysUserMapper.updateById(user);
        return R.success(result > 0);
    }

    /**
     * 获取商家列表
     */
    @GetMapping("/merchants")
    public R<PageResult<Merchant>> getMerchantList(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) Integer merchantType) {
        
        Page<Merchant> page = new Page<>(pageNum, pageSize);
        QueryWrapper<Merchant> wrapper = new QueryWrapper<>();
        
        if (status != null) {
            wrapper.eq("status", status);
        }
        if (merchantType != null) {
            wrapper.eq("merchant_type", merchantType);
        }
        wrapper.orderByDesc("create_time");
        
        Page<Merchant> resultPage = merchantMapper.selectPage(page, wrapper);
        
        PageResult<Merchant> pageResult = new PageResult<>();
        pageResult.setRecords(resultPage.getRecords());
        pageResult.setCurrent(resultPage.getCurrent());
        pageResult.setSize(resultPage.getSize());
        pageResult.setTotal(resultPage.getTotal());
        pageResult.setPages(resultPage.getPages());
        
        return R.success(pageResult);
    }

    /**
     * 审核商家（通过）
     */
    @PostMapping("/merchants/{merchantId}/approve")
    public R<Boolean> approveMerchant(@PathVariable Long merchantId) {
        Merchant merchant = merchantMapper.selectById(merchantId);
        if (merchant == null) {
            return R.error("商家不存在");
        }
        
        merchant.setStatus(1); // 已通过
        merchant.setUpdateTime(LocalDateTime.now());
        int result = merchantMapper.updateById(merchant);
        return R.success(result > 0);
    }

    /**
     * 审核商家（拒绝）
     */
    @PostMapping("/merchants/{merchantId}/reject")
    public R<Boolean> rejectMerchant(
            @PathVariable Long merchantId,
            @RequestParam(required = false) String reason) {
        Merchant merchant = merchantMapper.selectById(merchantId);
        if (merchant == null) {
            return R.error("商家不存在");
        }
        
        merchant.setStatus(2); // 已拒绝
        if (reason != null && !reason.isEmpty()) {
            merchant.setDescription("审核拒绝原因：" + reason);
        }
        merchant.setUpdateTime(LocalDateTime.now());
        int result = merchantMapper.updateById(merchant);
        return R.success(result > 0);
    }

    /**
     * 获取所有预约列表
     */
    @GetMapping("/appointments")
    public R<PageResult<Appointment>> getAllAppointments(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false) Integer status) {
        
        Page<Appointment> page = new Page<>(pageNum, pageSize);
        QueryWrapper<Appointment> wrapper = new QueryWrapper<>();
        
        if (status != null) {
            wrapper.eq("status", status);
        }
        wrapper.orderByDesc("create_time");
        
        Page<Appointment> resultPage = appointmentMapper.selectPage(page, wrapper);
        
        PageResult<Appointment> pageResult = new PageResult<>();
        pageResult.setRecords(resultPage.getRecords());
        pageResult.setCurrent(resultPage.getCurrent());
        pageResult.setSize(resultPage.getSize());
        pageResult.setTotal(resultPage.getTotal());
        pageResult.setPages(resultPage.getPages());
        
        return R.success(pageResult);
    }

    /**
     * 获取平台数据统计
     */
    @GetMapping("/statistics")
    public R<Map<String, Object>> getStatistics() {
        Map<String, Object> statistics = new HashMap<>();
        
        // 用户总数
        Long totalUsers = sysUserMapper.selectCount(new QueryWrapper<SysUser>().eq("user_type", 1));
        statistics.put("totalUsers", totalUsers);
        
        // 商家总数
        Long totalMerchants = merchantMapper.selectCount(new QueryWrapper<>());
        statistics.put("totalMerchants", totalMerchants);
        
        // 待审核商家数
        Long pendingMerchants = merchantMapper.selectCount(new QueryWrapper<Merchant>().eq("status", 0));
        statistics.put("pendingMerchants", pendingMerchants);
        
        // 预约总数
        Long totalAppointments = appointmentMapper.selectCount(new QueryWrapper<>());
        statistics.put("totalAppointments", totalAppointments);
        
        // 今日预约数
        QueryWrapper<Appointment> todayWrapper = new QueryWrapper<>();
        todayWrapper.ge("create_time", LocalDateTime.now().toLocalDate().atStartOfDay())
                .lt("create_time", LocalDateTime.now().toLocalDate().plusDays(1).atStartOfDay());
        Long todayAppointments = appointmentMapper.selectCount(todayWrapper);
        statistics.put("todayAppointments", todayAppointments);
        
        // 待确认预约数
        Long pendingAppointments = appointmentMapper.selectCount(new QueryWrapper<Appointment>().eq("status", 0));
        statistics.put("pendingAppointments", pendingAppointments);
        
        return R.success(statistics);
    }
}





