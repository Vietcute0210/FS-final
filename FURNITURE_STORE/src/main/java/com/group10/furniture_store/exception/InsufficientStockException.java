package com.group10.furniture_store.exception;

import java.util.List;
import java.util.Map;

// Exception cho warehouse
public class InsufficientStockException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    private final Map<Long, String> stockErrors;
    private final List<Map<String, Object>> errorDetails;

    public InsufficientStockException(String message, Map<Long, String> stockErrors,
            List<Map<String, Object>> errorDetails) {
        super(message);
        this.stockErrors = stockErrors;
        this.errorDetails = errorDetails;
    }

    public InsufficientStockException(String message, Map<Long, String> stockErrors) {
        super(message);
        this.stockErrors = stockErrors;
        this.errorDetails = null;
    }

    public Map<Long, String> getStockErrors() {
        return stockErrors;
    }

    public List<Map<String, Object>> getErrorDetails() {
        return errorDetails;
    }
}
