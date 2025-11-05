package com.example.demo.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.example.demo.common.ResultCode;
import com.example.demo.dto.MotorcycleDTO;
import com.example.demo.entity.Motorcycle;
import com.example.demo.entity.OwnerInfo;
import com.example.demo.exception.BusinessException;
import com.example.demo.mapper.MotorcycleMapper;
import com.example.demo.mapper.OwnerInfoMapper;
import com.example.demo.service.MotorcycleService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 用户车辆服务实现
 */
@Service
public class MotorcycleServiceImpl extends ServiceImpl<MotorcycleMapper, Motorcycle> implements MotorcycleService {

    @Autowired
    private MotorcycleMapper motorcycleMapper;

    @Autowired
    private OwnerInfoMapper ownerInfoMapper;

    @Override
    public List<MotorcycleDTO> listUserMotorcycles(Long userId) {
        OwnerInfo ownerInfo = ownerInfoMapper.selectByUserId(userId);
        if (ownerInfo == null) {
            return Collections.emptyList();
        }

        List<Motorcycle> motorcycles = motorcycleMapper.selectByOwnerId(ownerInfo.getId());
        return motorcycles.stream().map(this::convertToDTO).collect(Collectors.toList());
    }

    @Override
    public MotorcycleDTO createMotorcycle(Long userId, MotorcycleDTO dto) {
        OwnerInfo ownerInfo = getOrCreateOwnerInfo(userId);
        validateUniqueFields(dto, null);

        Motorcycle motorcycle = new Motorcycle();
        BeanUtils.copyProperties(dto, motorcycle);
        motorcycle.setOwnerId(ownerInfo.getId());
        motorcycle.setStatus(dto.getStatus() != null ? dto.getStatus() : 1);
        motorcycle.setPurchaseTime(dto.getPurchaseDate());
        motorcycle.setCreateTime(LocalDateTime.now());
        motorcycle.setUpdateTime(LocalDateTime.now());

        this.save(motorcycle);
        return convertToDTO(motorcycle);
    }

    @Override
    public boolean updateMotorcycle(Long userId, Long motorcycleId, MotorcycleDTO dto) {
        OwnerInfo ownerInfo = getOrCreateOwnerInfo(userId);
        Motorcycle motorcycle = this.getById(motorcycleId);
        if (motorcycle == null || !Objects.equals(motorcycle.getOwnerId(), ownerInfo.getId())) {
            throw new BusinessException(ResultCode.MOTORCYCLE_NOT_EXIST);
        }

        validateUniqueFields(dto, motorcycleId);

        if (StringUtils.hasText(dto.getBrand())) {
            motorcycle.setBrand(dto.getBrand());
        }
        if (StringUtils.hasText(dto.getModel())) {
            motorcycle.setModel(dto.getModel());
        }
        if (dto.getDisplacement() != null) {
            motorcycle.setDisplacement(dto.getDisplacement());
        }
        motorcycle.setLicensePlate(dto.getLicensePlate());
        motorcycle.setVin(dto.getVin());
        motorcycle.setPurchaseTime(dto.getPurchaseDate());
        if (dto.getStatus() != null) {
            motorcycle.setStatus(dto.getStatus());
        }
        motorcycle.setUpdateTime(LocalDateTime.now());

        return this.updateById(motorcycle);
    }

    @Override
    public boolean removeMotorcycle(Long userId, Long motorcycleId) {
        OwnerInfo ownerInfo = ownerInfoMapper.selectByUserId(userId);
        if (ownerInfo == null) {
            throw new BusinessException(ResultCode.MOTORCYCLE_NOT_EXIST);
        }

        Motorcycle motorcycle = this.getById(motorcycleId);
        if (motorcycle == null || !Objects.equals(motorcycle.getOwnerId(), ownerInfo.getId())) {
            throw new BusinessException(ResultCode.MOTORCYCLE_NOT_EXIST);
        }

        return this.removeById(motorcycleId);
    }

    private MotorcycleDTO convertToDTO(Motorcycle motorcycle) {
        MotorcycleDTO dto = new MotorcycleDTO();
        BeanUtils.copyProperties(motorcycle, dto);
        dto.setPurchaseDate(motorcycle.getPurchaseTime());
        return dto;
    }

    private OwnerInfo getOrCreateOwnerInfo(Long userId) {
        OwnerInfo ownerInfo = ownerInfoMapper.selectByUserId(userId);
        if (ownerInfo == null) {
            ownerInfo = new OwnerInfo();
            ownerInfo.setUserId(userId);
            ownerInfo.setCreateTime(LocalDateTime.now());
            ownerInfo.setUpdateTime(LocalDateTime.now());
            ownerInfoMapper.insert(ownerInfo);
        }
        return ownerInfo;
    }

    private void validateUniqueFields(MotorcycleDTO dto, Long ignoreId) {
        if (StringUtils.hasText(dto.getLicensePlate())) {
            Motorcycle existing = motorcycleMapper.selectByLicensePlate(dto.getLicensePlate());
            if (existing != null && !Objects.equals(existing.getId(), ignoreId)) {
                throw new BusinessException(ResultCode.LICENSE_PLATE_ALREADY_EXISTS);
            }
        }
        if (StringUtils.hasText(dto.getVin())) {
            Motorcycle existingByVin = this.lambdaQuery()
                    .eq(Motorcycle::getVin, dto.getVin())
                    .one();
            if (existingByVin != null && !Objects.equals(existingByVin.getId(), ignoreId)) {
                throw new BusinessException(ResultCode.VIN_ALREADY_EXISTS);
            }
        }
    }
}
