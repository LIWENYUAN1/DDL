package com.mountain.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.mountain.dto.AppointmentRequestDTO;
import com.mountain.dto.PageDTO;
import com.mountain.entity.Appointment;
import java.util.List;

/**
 * 预约服务接口
 */
public interface AppointmentService extends IService<Appointment> {

    /**
     * 创建预约
     * @param appointmentRequestDTO 预约请求参数
     * @param userId 用户ID
     * @return 预约ID
     */
    Long createAppointment(AppointmentRequestDTO appointmentRequestDTO, Long userId);

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
     * 取消预约
     * @param appointmentId 预约ID
     * @param userId 用户ID
     * @param isMerchant 是否是商家取消
     * @return 取消结果
     */
    boolean cancelAppointment(Long appointmentId, Long userId, boolean isMerchant);

    /**
     * 获取预约详情
     * @param appointmentId 预约ID
     * @return 预约详情
     */
    Appointment getAppointmentById(Long appointmentId);

    /**
     * 获取用户预约列表
     * @param pageDTO 分页参数
     * @param userId 用户ID
     * @return 预约列表
     */
    List<Appointment> getUserAppointmentList(PageDTO pageDTO, Long userId);

    /**
     * 获取商家预约列表
     * @param pageDTO 分页参数
     * @param merchantId 商家ID
     * @param status 预约状态（可选）
     * @return 预约列表
     */
    List<Appointment> getMerchantAppointmentList(PageDTO pageDTO, Long merchantId, Integer status);
}