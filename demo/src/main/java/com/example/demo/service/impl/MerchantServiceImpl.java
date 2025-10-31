package com.example.demo.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.demo.common.ResultCode;
import com.example.demo.dto.PageDTO;
import com.example.demo.entity.Appointment;
import com.example.demo.entity.Merchant;
import com.example.demo.exception.BusinessException;
import com.example.demo.mapper.AppointmentMapper;
import com.example.demo.mapper.MerchantMapper;
import com.example.demo.service.MerchantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 商家服务实现类
 */
@Service
public class MerchantServiceImpl extends ServiceImpl<MerchantMapper, Merchant> implements MerchantService {

    @Autowired
    private MerchantMapper merchantMapper;

    @Autowired
    private AppointmentMapper appointmentMapper;

    @Override
    public Merchant getMerchantByUserId(Long userId) {
        Merchant merchant = merchantMapper.selectByUserId(userId);
        if (merchant == null) {
            throw new BusinessException(ResultCode.MERCHANT_NOT_EXIST);
        }
        return merchant;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean updateMerchantInfo(Merchant merchant, Long userId) {
        // 验证商家是否存在
        Merchant existMerchant = getMerchantByUserId(userId);
        
        // 更新商家信息
        merchant.setId(existMerchant.getId());
        merchant.setUpdateTime(LocalDateTime.now());
        
        return merchantMapper.updateById(merchant) > 0;
    }

    @Override
    public List<Appointment> getMerchantAppointments(PageDTO pageDTO, Long merchantId, Integer status) {
        Page<Appointment> page = new Page<>(pageDTO.getPageNum(), pageDTO.getPageSize());
        return appointmentMapper.selectByMerchantId(page, merchantId, status).getRecords();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean confirmAppointment(Long appointmentId, Long merchantId) {
        Appointment appointment = appointmentMapper.selectById(appointmentId);
        if (appointment == null) {
            throw new BusinessException(ResultCode.APPOINTMENT_NOT_EXIST);
        }

        // 验证是否是该商家的预约
        if (!appointment.getMerchantId().equals(merchantId)) {
            throw new BusinessException(ResultCode.PERMISSION_DENIED);
        }

        // 验证预约状态
        if (appointment.getStatus() != 0) {
            throw new BusinessException(ResultCode.APPOINTMENT_STATUS_ERROR);
        }

        // 更新预约状态
        appointment.setStatus(1); // 已确认
        appointment.setUpdateTime(LocalDateTime.now());

        return appointmentMapper.updateById(appointment) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean completeAppointment(Long appointmentId, Long merchantId) {
        Appointment appointment = appointmentMapper.selectById(appointmentId);
        if (appointment == null) {
            throw new BusinessException(ResultCode.APPOINTMENT_NOT_EXIST);
        }

        // 验证是否是该商家的预约
        if (!appointment.getMerchantId().equals(merchantId)) {
            throw new BusinessException(ResultCode.PERMISSION_DENIED);
        }

        // 验证预约状态
        if (appointment.getStatus() != 1) {
            throw new BusinessException(ResultCode.APPOINTMENT_STATUS_ERROR);
        }

        // 更新预约状态
        appointment.setStatus(2); // 已完成
        appointment.setUpdateTime(LocalDateTime.now());

        return appointmentMapper.updateById(appointment) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean rejectAppointment(Long appointmentId, Long merchantId, String reason) {
        Appointment appointment = appointmentMapper.selectById(appointmentId);
        if (appointment == null) {
            throw new BusinessException(ResultCode.APPOINTMENT_NOT_EXIST);
        }

        // 验证是否是该商家的预约
        if (!appointment.getMerchantId().equals(merchantId)) {
            throw new BusinessException(ResultCode.PERMISSION_DENIED);
        }

        // 验证预约状态
        if (appointment.getStatus() != 0) {
            throw new BusinessException(ResultCode.APPOINTMENT_STATUS_ERROR);
        }

        // 更新预约状态
        appointment.setStatus(3); // 已取消/已拒绝
        appointment.setRemark(appointment.getRemark() + "\n[商家拒绝原因：" + reason + "]");
        appointment.setUpdateTime(LocalDateTime.now());

        return appointmentMapper.updateById(appointment) > 0;
    }

    @Override
    public Map<String, Object> getMerchantStatistics(Long merchantId) {
        Map<String, Object> statistics = new HashMap<>();
        
        // 待确认预约数
        QueryWrapper<Appointment> pendingWrapper = new QueryWrapper<>();
        pendingWrapper.eq("merchant_id", merchantId).eq("status", 0);
        Long pendingCount = appointmentMapper.selectCount(pendingWrapper);
        statistics.put("pendingCount", pendingCount);
        
        // 今日预约数
        QueryWrapper<Appointment> todayWrapper = new QueryWrapper<>();
        todayWrapper.eq("merchant_id", merchantId)
                .ge("create_time", LocalDateTime.now().toLocalDate().atStartOfDay())
                .lt("create_time", LocalDateTime.now().toLocalDate().plusDays(1).atStartOfDay());
        Long todayCount = appointmentMapper.selectCount(todayWrapper);
        statistics.put("todayCount", todayCount);
        
        // 总预约数
        QueryWrapper<Appointment> totalWrapper = new QueryWrapper<>();
        totalWrapper.eq("merchant_id", merchantId);
        Long totalCount = appointmentMapper.selectCount(totalWrapper);
        statistics.put("totalCount", totalCount);
        
        // 已完成预约数
        QueryWrapper<Appointment> completedWrapper = new QueryWrapper<>();
        completedWrapper.eq("merchant_id", merchantId).eq("status", 2);
        Long completedCount = appointmentMapper.selectCount(completedWrapper);
        statistics.put("completedCount", completedCount);
        
        return statistics;
    }

    @Override
    public List<Merchant> getNearbyMerchants(Double latitude, Double longitude, Double distance, Integer merchantType) {
        // 简化实现：查询所有已通过审核的商家
        // 实际应该使用地理位置索引进行附近搜索
        QueryWrapper<Merchant> wrapper = new QueryWrapper<>();
        wrapper.eq("status", 1); // 已通过审核
        if (merchantType != null) {
            wrapper.eq("merchant_type", merchantType);
        }
        return merchantMapper.selectList(wrapper);
    }
}





