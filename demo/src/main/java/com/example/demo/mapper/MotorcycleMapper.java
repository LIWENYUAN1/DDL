package com.example.demo.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.example.demo.entity.Motorcycle;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 摩托车Mapper
 */
@Mapper
public interface MotorcycleMapper extends BaseMapper<Motorcycle> {

    /**
     * 根据车主ID查询车辆列表
     * @param ownerId 车主ID
     * @return 车辆列表
     */
    List<Motorcycle> selectByOwnerId(Long ownerId);

    /**
     * 根据车牌号查询车辆
     * @param licensePlate 车牌号
     * @return 车辆信息
     */
    Motorcycle selectByLicensePlate(String licensePlate);
}