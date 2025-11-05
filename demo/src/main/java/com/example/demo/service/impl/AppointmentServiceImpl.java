package com.example.demo.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.demo.common.ResultCode;
import com.example.demo.dto.AppointmentRequestDTO;
import com.example.demo.dto.PageDTO;
import com.example.demo.entity.Appointment;
import com.example.demo.entity.AppointmentServiceItem;
import com.example.demo.entity.Merchant;
import com.example.demo.entity.Motorcycle;
import com.example.demo.entity.OwnerInfo;
import com.example.demo.exception.BusinessException;
import com.example.demo.mapper.AppointmentMapper;
import com.example.demo.mapper.AppointmentServiceItemMapper;
import com.example.demo.mapper.MerchantMapper;
import com.example.demo.mapper.MotorcycleMapper;
import com.example.demo.mapper.OwnerInfoMapper;
import com.example.demo.service.AppointmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

/**
 * 预约服务实现类
 */
@Service
public class AppointmentServiceImpl extends ServiceImpl<AppointmentMapper, Appointment> implements AppointmentService {

    @Autowired
    private AppointmentMapper appointmentMapper;

    @Autowired
    private AppointmentServiceItemMapper appointmentServiceItemMapper;

    @Autowired
    private MerchantMapper merchantMapper;

    @Autowired
    private MotorcycleMapper motorcycleMapper;
    
    @Autowired
    private OwnerInfoMapper ownerInfoMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createAppointment(AppointmentRequestDTO appointmentRequestDTO, Long userId) {
        // 验证商家是否存在
        if (merchantMapper.selectById(appointmentRequestDTO.getMerchantId()) == null) {
            throw new BusinessException(ResultCode.MERCHANT_NOT_EXIST);
        }

        // 处理车辆ID：如果没有提供，则自动创建车辆记录
        Long motorcycleId = appointmentRequestDTO.getMotorcycleId();
        if (motorcycleId == null) {
            // 1. 先获取或创建owner_info记录
            Long ownerId = getOrCreateOwnerId(userId);
            
            // 2. 创建新的车辆记录
            Motorcycle motorcycle = new Motorcycle();
            motorcycle.setOwnerId(ownerId);  // 使用owner_info.id而不是sys_user.id
            motorcycle.setModel(appointmentRequestDTO.getMotorcycleModel());
            motorcycle.setLicensePlate(appointmentRequestDTO.getLicensePlate());
            motorcycle.setBrand(extractBrand(appointmentRequestDTO.getMotorcycleModel())); // 添加品牌字段
            motorcycle.setStatus(1); // 正常状态
            motorcycle.setCreateTime(LocalDateTime.now());
            motorcycle.setUpdateTime(LocalDateTime.now());
            motorcycleMapper.insert(motorcycle);
            motorcycleId = motorcycle.getId();
        } else {
            // 验证车辆是否存在
            if (motorcycleMapper.selectById(motorcycleId) == null) {
                throw new BusinessException(ResultCode.MOTORCYCLE_NOT_EXIST);
            }
        }

        // 解析预约时间
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        LocalDateTime appointmentTime = LocalDateTime.parse(appointmentRequestDTO.getAppointmentTime(), formatter);

        // 创建预约记录
        Appointment appointment = new Appointment();
        appointment.setOrderNo(generateOrderNo());
        appointment.setUserId(userId);
        appointment.setMerchantId(appointmentRequestDTO.getMerchantId());
        appointment.setMotorcycleId(motorcycleId);
        appointment.setAppointmentTime(appointmentTime);
        appointment.setAppointmentType(appointmentRequestDTO.getAppointmentType());
        appointment.setServiceType(appointmentRequestDTO.getServiceType());
        appointment.setServiceAddress(appointmentRequestDTO.getServiceAddress());
        appointment.setContactPhone(appointmentRequestDTO.getContactPhone());
        appointment.setDescription(appointmentRequestDTO.getDescription());
        appointment.setRemark(appointmentRequestDTO.getRemark());
        appointment.setStatus(0); // 待确认
        appointment.setCreateTime(LocalDateTime.now());
        appointment.setUpdateTime(LocalDateTime.now());

        // 保存预约记录
        appointmentMapper.insert(appointment);

        // 保存预约服务项目
        AppointmentServiceItem appointmentServiceItem = new AppointmentServiceItem();
        appointmentServiceItem.setAppointmentId(appointment.getId());
        appointmentServiceItem.setServiceItemId(appointmentRequestDTO.getServiceItemId());
        appointmentServiceItem.setQuantity(1);
        appointmentServiceItem.setCreateTime(LocalDateTime.now());
        appointmentServiceItemMapper.insert(appointmentServiceItem);

        return appointment.getId();
    }

    @Override
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
    public boolean cancelAppointment(Long appointmentId, Long userId, boolean isMerchant) {
        Appointment appointment = appointmentMapper.selectById(appointmentId);
        if (appointment == null) {
            throw new BusinessException(ResultCode.APPOINTMENT_NOT_EXIST);
        }

        // 验证权限
        if (isMerchant) {
            // 商家取消：验证商家身份及预约归属
            Merchant merchant = merchantMapper.selectByUserId(userId);
            if (merchant == null || !appointment.getMerchantId().equals(merchant.getId())) {
                throw new BusinessException(ResultCode.PERMISSION_DENIED);
            }
        } else {
            // 用户取消：验证是否是该用户的预约
            if (!appointment.getUserId().equals(userId)) {
                throw new BusinessException(ResultCode.PERMISSION_DENIED);
            }
        }

        // 验证预约状态（只有待确认和已确认的预约可以取消）
        if (appointment.getStatus() != 0 && appointment.getStatus() != 1) {
            throw new BusinessException(ResultCode.APPOINTMENT_STATUS_ERROR);
        }

        // 更新预约状态
        appointment.setStatus(3); // 已取消
        appointment.setUpdateTime(LocalDateTime.now());

        return appointmentMapper.updateById(appointment) > 0;
    }

    @Override
    public Appointment getAppointmentById(Long appointmentId) {
        Appointment appointment = appointmentMapper.selectById(appointmentId);
        if (appointment == null) {
            throw new BusinessException(ResultCode.APPOINTMENT_NOT_EXIST);
        }
        return appointment;
    }

    @Override
    public List<Appointment> getUserAppointmentList(PageDTO pageDTO, Long userId) {
        // 构建查询条件
        com.baomidou.mybatisplus.extension.plugins.pagination.Page<Appointment> page = new com.baomidou.mybatisplus.extension.plugins.pagination.Page<>(
                pageDTO.getPageNum(), pageDTO.getPageSize());

        // 执行分页查询
        return appointmentMapper.selectByUserId(page, userId).getRecords();
    }

    @Override
    public List<Appointment> getMerchantAppointmentList(PageDTO pageDTO, Long merchantId, Integer status) {
        // 构建查询条件
        com.baomidou.mybatisplus.extension.plugins.pagination.Page<Appointment> page = new com.baomidou.mybatisplus.extension.plugins.pagination.Page<>(
                pageDTO.getPageNum(), pageDTO.getPageSize());

        // 执行分页查询
        return appointmentMapper.selectByMerchantId(page, merchantId, status).getRecords();
    }

    /**
     * 获取或创建车主信息ID
     * 确保用户有对应的owner_info记录
     */
    private Long getOrCreateOwnerId(Long userId) {
        // 查询是否已有owner_info记录
        OwnerInfo ownerInfo = ownerInfoMapper.selectByUserId(userId);
        
        if (ownerInfo == null) {
            // 如果没有，创建新的owner_info记录
            ownerInfo = new OwnerInfo();
            ownerInfo.setUserId(userId);
            ownerInfo.setCreateTime(LocalDateTime.now());
            ownerInfo.setUpdateTime(LocalDateTime.now());
            ownerInfoMapper.insert(ownerInfo);
        }
        
        return ownerInfo.getId();
    }
    
    /**
     * 从车型中提取品牌
     * 如果车型中包含常见品牌名称，则提取；否则使用默认值
     */
    private String extractBrand(String model) {
        if (model == null || model.isEmpty()) {
            return "未知品牌";
        }
        
        // 常见摩托车品牌列表
        String[] brands = {"雅马哈", "YAMAHA", "本田", "HONDA", "川崎", "KAWASAKI", 
                          "铃木", "SUZUKI", "宝马", "BMW", "杜卡迪", "DUCATI", 
                          "哈雷", "HARLEY", "KTM", "春风", "CFMOTO", "钱江", "隆鑫",
                          "宗申", "豪爵", "五羊", "大阳", "力帆", "建设", "嘉陵"};
        
        String modelUpper = model.toUpperCase();
        for (String brand : brands) {
            if (modelUpper.contains(brand.toUpperCase())) {
                return brand;
            }
        }
        
        // 如果没有匹配到品牌，尝试从车型中提取第一个单词作为品牌
        String[] parts = model.split("\\s+");
        if (parts.length > 0 && !parts[0].isEmpty()) {
            return parts[0];
        }
        
        return "其他品牌";
    }
    
    /**
     * 生成预约单号
     */
    private String generateOrderNo() {
        return "APT" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }
}