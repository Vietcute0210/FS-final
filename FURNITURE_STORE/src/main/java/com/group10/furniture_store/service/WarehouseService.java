package com.group10.furniture_store.service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.group10.furniture_store.domain.Product;
import com.group10.furniture_store.domain.Warehouse;
import com.group10.furniture_store.repository.ProductRepository;
import com.group10.furniture_store.repository.WarehouseRepository;

import jakarta.transaction.Transactional;

@Service
public class WarehouseService {
    private final WarehouseRepository warehouseRepository;
    private final ProductRepository productRepository;

    public WarehouseService(WarehouseRepository warehouseRepository,
            ProductRepository productRepository) {
        this.warehouseRepository = warehouseRepository;
        this.productRepository = productRepository;
    }

    public Warehouse getWarehouseByProductId(Long productId) {
        Warehouse warehouse = warehouseRepository.findByProductId(productId);
        return warehouse;
    }

    public Long getStockQuantity(Long productId) {
        Warehouse warehouse = getWarehouseByProductId(productId);
        Long quantity = warehouse != null ? warehouse.getQuantity() : 0L;
        return quantity;
    }

    public void updateStockQuantity(Long productId, Long newQuantity) {
        try {
            Warehouse warehouse = warehouseRepository.findByProductId(productId);
            if (warehouse != null) {
                warehouse.setQuantity(newQuantity);
                warehouse.setLastUpdated(LocalDateTime.now());
                warehouseRepository.save(warehouse);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    // Kiểm tra và trừ tồn kho (riêng sp)
    // Trả về true nếu trừ được , false nếu đã hết hàng
    @Transactional
    public boolean decreaseStockSafely(Long productId, Long quantity) {
        Warehouse warehouse = this.warehouseRepository.findByProductIdWithLock(productId);
        if (warehouse != null) {
            // Kiểm tra slg sp trong kho có đủ để đơn hàng lấy ko
            if (warehouse.getQuantity() < quantity) {
                return false; // Ko đủ hàng
            }

            // Trừ tồn kho
            warehouse.setQuantity(warehouse.getQuantity() - quantity);
            warehouse.setLastUpdated(LocalDateTime.now());
            warehouseRepository.save(warehouse);
            return true;
        }
        return false;
    }

    // Ktra trong kho có đủ sp ko
    public boolean checkStockAvailability(Long productId, Long quantity) {
        Long currentStock = getStockQuantity(productId);
        return currentStock >= quantity;
    }

    @Transactional
    public Map<Long, String> validateAndLockStock(Map<Long, Long> productQuantities) {
        Map<Long, String> errors = new HashMap<>();

        for (Map.Entry<Long, Long> entry : productQuantities.entrySet()) {
            Long productId = entry.getKey();
            Long requestedQty = entry.getValue();

            Warehouse warehouse = this.warehouseRepository.findByProductIdWithLock(productId);

            if (warehouse == null) {
                errors.put(productId, "Sản phẩm không có trong kho");
                continue;
            }

            if (warehouse.getQuantity() < requestedQty) {
                Product product = this.productRepository.findById(productId).orElse(null);
                String productName = product != null ? product.getName() : "ID: " + productId;
                errors.put(productId,
                        String.format("Sản phẩm %s chỉ còn %d. Xin quý khách thông cảm",
                                productName, warehouse.getQuantity()));
            }
        }

        return errors;
    }

    // Ktra và trừ tồn kho sl sp trong đơn hàng
    @Transactional
    public Map<Long, Boolean> decreaseStockForMultipleProducts(Map<Long, Long> productQuantities) {
        Map<Long, Boolean> results = new HashMap<>();

        for (Map.Entry<Long, Long> entry : productQuantities.entrySet()) {
            Long productId = entry.getKey();
            Long quantity = entry.getValue();

            // đã được lock ở validateAndLockStock, giờ chỉ cần update
            Warehouse warehouse = this.warehouseRepository.findByProductIdWithLock(productId);

            if (warehouse == null || warehouse.getQuantity() < quantity) {
                results.put(productId, false);
                throw new RuntimeException("Không đủ hàng cho sản phẩm: " + productId);
            }

            warehouse.setQuantity(warehouse.getQuantity() - quantity);
            warehouseRepository.save(warehouse);
            results.put(productId, true);

        }

        return results;
    }

    @Transactional
    public Warehouse getOrCreateWarehouse(Product product) {
        Warehouse warehouse = warehouseRepository.findByProductId(product.getId());
        try {
            if (warehouse == null) {
                Warehouse newWarehouse = new Warehouse();
                newWarehouse.setProduct(product);
                newWarehouse.setQuantity(0L);
                newWarehouse.setLastUpdated(LocalDateTime.now());
                return warehouseRepository.save(newWarehouse);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return warehouse;
    }
}
