package com.group10.furniture_store.domain;

import java.time.LocalDateTime;

import com.group10.furniture_store.constant.AppConstant;

import jakarta.persistence.Column;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;

public class BaseEntity {

    @Column(name = "CREATE_DAY_TIME")
    private String createDayTime;

    @Column(name = "UPDATE_DAY_TIME")
    private String updateDayTime;

    @PrePersist
    public void prePersist() {
        this.createDayTime = LocalDateTime.now().format(AppConstant.formatter);
        this.updateDayTime = this.createDayTime;
    }

    @PreUpdate
    public void preUpdate() {
        if (this.createDayTime == null) {
            this.createDayTime = LocalDateTime.now().format(AppConstant.formatter);
        }
        this.updateDayTime = LocalDateTime.now().format(AppConstant.formatter);
    }
}
