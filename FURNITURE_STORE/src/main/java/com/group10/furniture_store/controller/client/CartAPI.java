package com.group10.furniture_store.controller.client;

import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.Objects;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.group10.furniture_store.domain.Cart;
import com.group10.furniture_store.domain.CartDetails;
import com.group10.furniture_store.domain.User;
import com.group10.furniture_store.repository.CartRepository;
import com.group10.furniture_store.service.ProductService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

class CartRequest {
    private long quantity;
    private long productId;

    public long getQuantity() {
        return quantity;
    }

    public void setQuantity(long quantity) {
        this.quantity = quantity;
    }

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }
}

@RestController
@RequiredArgsConstructor
public class CartAPI {
    private final ProductService productService;
    private final CartRepository cartRepository;

    @PostMapping("/api/add-product-to-cart")
    public ResponseEntity<?> addProductToCart(@RequestBody CartRequest cartRequest, HttpServletRequest request) {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        if (email == null || email.trim().isEmpty()) {
            return ResponseEntity.status(401)
                    .body("Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng");
        }

        try {
            // Validate
            if (cartRequest.getProductId() <= 0) {
                return ResponseEntity.badRequest().body("ID sản phẩm không hợp lệ");
            }

            long quantity = cartRequest.getQuantity() <= 0 ? 1 : cartRequest.getQuantity();

            // Thêm sản phẩm
            this.productService.handleAddProductToCart(email, cartRequest.getProductId(), session, quantity);

            // Lấy thông tin giỏ hàng
            Long cartId = (Long) session.getAttribute("cartId");
            if (cartId == null) {
                return ResponseEntity.badRequest().body("Giỏ hàng không tồn tại");
            }

            Cart cart = this.cartRepository.findById(cartId).orElse(null);
            if (cart == null) {
                return ResponseEntity.badRequest().body("Không tìm thấy giỏ hàng");
            }

            // Tính toán
            int cartItemCount = cart.getCartDetails() != null ? cart.getCartDetails().size() : 0;
            long totalQuantity = 0;
            double totalPrice = 0;

            for (CartDetails detail : cart.getCartDetails()) {
                totalQuantity += detail.getQuantity();
                totalPrice += detail.getPrice() * detail.getQuantity();
            }

            // Cập nhật session
            session.setAttribute("sum", cartItemCount);
            session.setAttribute("cartItemCount", cartItemCount);
            session.setAttribute("totalQuantity", totalQuantity);

            // Lưu DB
            cart.setSum((long) cartItemCount);
            this.cartRepository.save(cart);

            // Response
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("cartItemCount", cartItemCount);
            response.put("totalQuantity", totalQuantity);
            response.put("totalPrice", totalPrice);

            return ResponseEntity.ok(response);

        } catch (Exception ex) {
            ex.printStackTrace();
            return ResponseEntity.status(500).body("Có lỗi xảy ra: " + ex.getMessage());
        }
    }

    @PostMapping("/api/update-cart-quantity")
    public ResponseEntity<Map<String, Object>> updateCartQuantity(
            @RequestBody Map<String, Object> requestBody,
            HttpServletRequest request) {

        HttpSession session = request.getSession();
        Map<String, Object> response = new HashMap<>();

        try {
            // Validate input
            if (!requestBody.containsKey("cartDetailId") || !requestBody.containsKey("quantity")) {
                response.put("success", false);
                response.put("message", "Thiếu tham số");
                return ResponseEntity.badRequest().body(response);
            }

            Long cartDetailId = Long.parseLong(requestBody.get("cartDetailId").toString());
            Long quantity = Long.parseLong(requestBody.get("quantity").toString());

            if (quantity < 1) {
                response.put("success", false);
                response.put("message", "Số lượng phải lớn hơn hoặc bằng 1");
                return ResponseEntity.badRequest().body(response);
            }

            // Cập nhật số lượng
            this.productService.updateCartDetailQuantity(cartDetailId, quantity, session);

            // Lấy giỏ hàng
            Long cartId = (Long) session.getAttribute("cartId");
            if (cartId == null) {
                response.put("success", false);
                response.put("message", "Giỏ hàng không tồn tại");
                return ResponseEntity.badRequest().body(response);
            }

            Cart cart = this.cartRepository.findById(cartId).orElse(null);
            if (cart == null) {
                response.put("success", false);
                response.put("message", "Không tìm thấy giỏ hàng");
                return ResponseEntity.badRequest().body(response);
            }

            // Tính toán tổng
            double totalPrice = 0;
            double subtotal = 0;
            long totalQuantity = 0;

            for (CartDetails cd : cart.getCartDetails()) {
                double cdTotal = cd.getPrice() * cd.getQuantity();
                totalPrice += cdTotal;
                totalQuantity += cd.getQuantity();

                if (cd.getId() == cartDetailId) {
                    subtotal = cdTotal;
                }
            }

            // Cập nhật session
            int cartItemCount = cart.getCartDetails().size();
            session.setAttribute("sum", cartItemCount);
            session.setAttribute("totalQuantity", totalQuantity);

            // Lưu DB
            cart.setSum((long) cartItemCount);
            this.cartRepository.save(cart);

            response.put("success", true);
            response.put("subtotal", subtotal);
            response.put("totalPrice", totalPrice);
            response.put("cartItemCount", cartItemCount);
            response.put("totalQuantity", totalQuantity);

            return ResponseEntity.ok().body(response);

        } catch (NumberFormatException ex) {
            response.put("success", false);
            response.put("message", "Định dạng số không hợp lệ");
            return ResponseEntity.badRequest().body(response);
        } catch (Exception ex) {
            ex.printStackTrace();
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + ex.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    @GetMapping("/api/cart/preview")
    public ResponseEntity<Map<String, Object>> getCartPreview(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("id") == null) {
            return ResponseEntity.ok(buildPreviewResponse(Collections.emptyList(), 0));
        }

        Object userIdAttr = session.getAttribute("id");
        if (!(userIdAttr instanceof Number)) {
            return ResponseEntity.ok(buildPreviewResponse(Collections.emptyList(), 0));
        }

        long userId = ((Number) userIdAttr).longValue();
        User currentUser = new User();
        currentUser.setId(userId);

        Cart cart = this.productService.fetchCartByUser(currentUser);
        if (cart == null || cart.getCartDetails() == null) {
            return ResponseEntity.ok(buildPreviewResponse(Collections.emptyList(), 0));
        }

        List<Map<String, Object>> previewItems = cart.getCartDetails().stream()
                .filter(Objects::nonNull)
                .sorted(Comparator.comparingLong(CartDetails::getId).reversed())
                .limit(5)
                .map(cartDetails -> {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", cartDetails.getId());
                    map.put("quantity", cartDetails.getQuantity());
                    map.put("price", cartDetails.getPrice());
                    if (cartDetails.getProduct() != null) {
                        map.put("productId", cartDetails.getProduct().getId());
                        map.put("name", cartDetails.getProduct().getName());
                        map.put("image", cartDetails.getProduct().getImage());
                    } else {
                        map.put("productId", null);
                        map.put("name", "Sản phẩm");
                        map.put("image", null);
                    }
                    return map;
                })
                .collect(Collectors.toList());

        long totalDistinctItems = cart.getCartDetails().stream()
                .filter(Objects::nonNull)
                .map(cd -> cd.getProduct() != null ? cd.getProduct().getId() : cd.getId())
                .distinct()
                .count();

        return ResponseEntity.ok(buildPreviewResponse(previewItems, (int) totalDistinctItems));
    }

    private Map<String, Object> buildPreviewResponse(List<Map<String, Object>> items, int totalQuantity) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("items", items);
        payload.put("totalQuantity", Math.max(0, totalQuantity));
        return payload;
    }
}
