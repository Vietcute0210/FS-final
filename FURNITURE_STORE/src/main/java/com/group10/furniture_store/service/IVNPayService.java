package com.group10.furniture_store.service;

import com.group10.furniture_store.domain.DTO.PaymentDTO;

import jakarta.servlet.http.HttpServletRequest;

public interface IVNPayService {
    String createPaymentUrl(PaymentDTO paymentDTO, HttpServletRequest request);
}
