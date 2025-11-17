package com.group10.furniture_store.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class VNPayConfig {

    @Value("${vnpay.tmncode}")
    private String vnpTmnCode;

    @Value("${vnpay.hashsecret}")
    private String secretKey;

    @Value("${vnpay.apiurl}")
    private String vnpPayUrl;

    @Value("${vnpay.returnurl}")
    private String vnpReturnUrl;

    public String getVnpTmnCode() {
        return vnpTmnCode;
    }

    public String getSecretKey() {
        return secretKey;
    }

    public String getVnpPayUrl() {
        return vnpPayUrl;
    }

    public String getVnpReturnUrl() {
        return vnpReturnUrl;
    }
}