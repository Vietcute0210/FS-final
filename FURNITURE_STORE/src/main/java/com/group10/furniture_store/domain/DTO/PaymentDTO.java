package com.group10.furniture_store.domain.DTO;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PaymentDTO {
    private Long orderId;
    private Long amount;
    private String orderInfo;
    private String bankCode;
    private String locale;
    private String orderType;

    public PaymentDTO(Long orderId, Long amount) {
        this.orderId = orderId;
        this.amount = amount;
        this.locale = "vn";
        this.orderType = "other";
    }

    public PaymentDTO(Long orderId, Long amount, String orderInfo) {
        this.orderId = orderId;
        this.amount = amount;
        this.orderInfo = orderInfo;
        this.locale = "vn";
        this.orderType = "other";
    }
}