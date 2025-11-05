package com.example.demo.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.example.demo.dto.MotorcycleDTO;
import com.example.demo.entity.Motorcycle;

import java.util.List;

/**
 * 用户车辆服务
 */
public interface MotorcycleService extends IService<Motorcycle> {

    /**
     * 获取当前用户的车辆列表
     *
     * @param userId 用户ID
     * @return 车辆列表
     */
    List<MotorcycleDTO> listUserMotorcycles(Long userId);

    /**
     * 新增车辆
     *
     * @param userId 用户ID
     * @param dto    车辆信息
     * @return 新增后的车辆
     */
    MotorcycleDTO createMotorcycle(Long userId, MotorcycleDTO dto);

    /**
     * 更新车辆信息
     *
     * @param userId        用户ID
     * @param motorcycleId  车辆ID
     * @param dto           车辆信息
     * @return 是否成功
     */
    boolean updateMotorcycle(Long userId, Long motorcycleId, MotorcycleDTO dto);

    /**
     * 删除车辆
     *
     * @param userId       用户ID
     * @param motorcycleId 车辆ID
     * @return 是否成功
     */
    boolean removeMotorcycle(Long userId, Long motorcycleId);
}
