package com.example.demo.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.demo.dto.PageDTO;
import com.example.demo.entity.Appointment;
import com.example.demo.entity.Merchant;

import java.util.List;
import java.util.Map;

/**
 * 商家服务接口
 */
public interface MerchantService extends IService<Merchant> {

    /**
     * 根据用户ID获取商家信息
     * @param userId 用户ID
     * @return 商家信息
     */
    Merchant getMerchantByUserId(Long userId);

    /**
     * 更新商家信息
     * @param merchant 商家信息
     * @param userId 用户ID
     * @return 更新结果
     */
    boolean updateMerchantInfo(Merchant merchant, Long userId);

    /**
     * 获取商家预约列表
     * @param pageDTO 分页参数
     * @param merchantId 商家ID
     * @param status 预约状态（可选）
     * @return 预约列表
     */
    List<Appointment> getMerchantAppointments(PageDTO pageDTO, Long merchantId, Integer status);

    /**
     * 确认预约
     * @param appointmentId 预约ID
     * @param merchantId 商家ID
     * @return 确认结果
     */
    boolean confirmAppointment(Long appointmentId, Long merchantId);

    /**
     * 完成预约
     * @param appointmentId 预约ID
     * @param merchantId 商家ID
     * @return 完成结果
     */
    boolean completeAppointment(Long appointmentId, Long merchantId);

    /**
     * 拒绝预约
     * @param appointmentId 预约ID
     * @param merchantId 商家ID
     * @param reason 拒绝原因
     * @return 拒绝结果
     */
    boolean rejectAppointment(Long appointmentId, Long merchantId, String reason);

    /**
     * 获取商家营业统计
     * @param merchantId 商家ID
     * @return 统计数据
     */
    Map<String, Object> getMerchantStatistics(Long merchantId);

    /**
     * 查询附近商家
     * @param latitude 纬度
     * @param longitude 经度
     * @param distance 距离（公里）
     * @param merchantType 商家类型（可选）
     * @return 商家列表
     */
    List<Merchant> getNearbyMerchants(Double latitude, Double longitude, Double distance, Integer merchantType);
}





