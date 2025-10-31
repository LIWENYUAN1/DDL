package com.example.demo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.demo.entity.AppointmentServiceItem;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 预约服务项目关联Mapper
 */
@Mapper
public interface AppointmentServiceItemMapper extends BaseMapper<AppointmentServiceItem> {

    /**
     * 根据预约ID查询服务项目列表
     * @param appointmentId 预约ID
     * @return 服务项目列表
     */
    List<AppointmentServiceItem> selectByAppointmentId(@Param("appointmentId") Long appointmentId);

    /**
     * 删除预约的服务项目
     * @param appointmentId 预约ID
     * @return 删除结果
     */
    int deleteByAppointmentId(@Param("appointmentId") Long appointmentId);
}