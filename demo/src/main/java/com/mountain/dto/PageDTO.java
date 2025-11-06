package com.mountain.dto;

import lombok.Data;

import jakarta.validation.constraints.Min;
import java.io.Serializable;

/**
 * 分页查询请求DTO
 */
@Data
public class PageDTO implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 当前页码，默认为1
     */
    @Min(value = 1, message = "页码不能小于1")
    private Integer pageNum = 1;

    /**
     * 每页条数，默认为10
     */
    @Min(value = 1, message = "每页条数不能小于1")
    private Integer pageSize = 10;

    /**
     * 排序字段
     */
    private String sortField;

    /**
     * 排序方式：asc 或 desc
     */
    private String sortOrder;
}