package com.example.demo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.example.demo.entity.Appointment;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 预约Mapper
 */
@Mapper
public interface AppointmentMapper extends BaseMapper<Appointment> {

    /**
     * 根据用户ID分页查询预约列表
     * @param page 分页参数
     * @param userId 用户ID
     * @return 分页结果
     */
    Page<Appointment> selectByUserId(@Param("page") Page<Appointment> page, @Param("userId") Long userId);

    /**
     * 根据商家ID分页查询预约列表
     * @param page 分页参数
     * @param merchantId 商家ID
     * @param status 预约状态（可选）
     * @return 分页结果
     */
    Page<Appointment> selectByMerchantId(@Param("page") Page<Appointment> page, 
                                        @Param("merchantId") Long merchantId, 
                                        @Param("status") Integer status);
}