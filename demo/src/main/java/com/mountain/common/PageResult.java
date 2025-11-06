package com.mountain.common;

import lombok.Data;

import java.io.Serializable;
import java.util.List;

/**
 * 分页响应结果
 */
@Data
public class PageResult<T> implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 当前页码
     */
    private Long current;

    /**
     * 每页数量
     */
    private Long size;

    /**
     * 总记录数
     */
    private Long total;

    /**
     * 总页数
     */
    private Long pages;
    
    /**
     * 设置总页数
     */
    public void setPages(Long pages) {
        this.pages = pages;
    }

    /**
     * 数据列表
     */
    private List<T> records;

    /**
     * 是否有上一页
     */
    private Boolean hasPrevious;

    /**
     * 是否有下一页
     */
    private Boolean hasNext;

    public PageResult() {}

    public PageResult(Long current, Long size, Long total, List<T> records) {
        this.current = current;
        this.size = size;
        this.total = total;
        this.records = records;
        this.pages = total > 0 ? (total + size - 1) / size : 0;
        this.hasPrevious = current > 1;
        this.hasNext = current < pages;
    }
}