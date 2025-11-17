package com.group10.furniture_store.service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import org.springframework.stereotype.Service;

import com.group10.furniture_store.config.VNPayConfig;
import com.group10.furniture_store.domain.DTO.PaymentDTO;
import com.group10.furniture_store.utils.VNPayUtils;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class VNPayService implements IVNPayService {
    private final VNPayConfig vnPayConfig;
    private final VNPayUtils vnPayUtils;

    @Override
    public String createPaymentUrl(PaymentDTO paymentDTO, HttpServletRequest request) {
        String version = "2.1.0";
        String command = "pay";
        String orderInfo = "Thanh toán đơn hàng tại Furniture Store";
        String orderType = "other";
        long amount = paymentDTO.getAmount() * 100; // VND * 100
        String bankCode = paymentDTO.getBankCode();

        String clientIPAddr = vnPayUtils.getIpAddress(request);
        String transactionReference = vnPayUtils.getRandomNumber(8);
        String terminalCode = vnPayConfig.getVnpTmnCode();

        Map<String, String> vnpParams = new HashMap<>();
        vnpParams.put("vnp_Version", version);
        vnpParams.put("vnp_Command", command);
        vnpParams.put("vnp_TmnCode", terminalCode);
        vnpParams.put("vnp_Amount", String.valueOf(amount));
        vnpParams.put("vnp_CurrCode", "VND");

        if (bankCode != null && !bankCode.isEmpty()) {
            vnpParams.put("vnp_BankCode", bankCode);
        }

        vnpParams.put("vnp_TxnRef", transactionReference);
        vnpParams.put("vnp_OrderInfo", orderInfo + transactionReference);
        vnpParams.put("vnp_OrderType", orderType);

        String locale = paymentDTO.getLocale();
        if (locale != null && !locale.isEmpty()) {
            vnpParams.put("vnp_Locale", locale);
        } else {
            vnpParams.put("vnp_Locale", "vn");
        }
        vnpParams.put("vnp_ReturnUrl", vnPayConfig.getVnpReturnUrl());
        vnpParams.put("vnp_IpAddr", clientIPAddr);

        Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        String createdDate = dateFormat.format(calendar.getTime());
        vnpParams.put("vnp_CreateDate", createdDate);

        calendar.add(Calendar.MINUTE, 15);
        String expireDate = dateFormat.format(calendar.getTime());
        vnpParams.put("vnp_ExpireDate", expireDate);

        List<String> sortedFieldNames = new ArrayList<>(vnpParams.keySet());
        Collections.sort(sortedFieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder queryData = new StringBuilder();
        for (Iterator<String> iterator = sortedFieldNames.iterator(); iterator.hasNext();) {
            String fieldName = iterator.next();
            String fieldValue = vnpParams.get(fieldName);

            if (fieldValue != null && !fieldValue.isEmpty()) {
                hashData.append(fieldName).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                queryData.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII))
                        .append('=')
                        .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
            }

            if (iterator.hasNext()) {
                hashData.append('&');
                queryData.append('&');
            }
        }

        String secureHash = vnPayUtils.hmacSHA512(vnPayConfig.getSecretKey(), hashData.toString());
        queryData.append("&vnp_SecureHash=").append(secureHash);

        return vnPayConfig.getVnpPayUrl() + "?" + queryData.toString();
    }
}
