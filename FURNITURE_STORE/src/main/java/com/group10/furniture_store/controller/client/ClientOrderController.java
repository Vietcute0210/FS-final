package com.group10.furniture_store.controller.client;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.Map;

import com.group10.furniture_store.domain.Cart;
import com.group10.furniture_store.domain.CartDetails;
import com.group10.furniture_store.domain.User;
import com.group10.furniture_store.exception.InsufficientStockException;
import com.group10.furniture_store.repository.CartRepository;
import com.group10.furniture_store.service.ProductService;
import com.group10.furniture_store.service.UserService;
import com.group10.furniture_store.service.WarehouseService;
import com.group10.furniture_store.service.sendEmail.SendEmailService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/order")
public class ClientOrderController {

    private static final String SELECTED_CART_DETAILS_SESSION_KEY = "selectedCartDetails";

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;

    @Autowired
    private SendEmailService sendEmailService;

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private WarehouseService warehouseService;

    private List<Long> getSelectedIdsFromSession(HttpSession session) {
        Object data = session.getAttribute(SELECTED_CART_DETAILS_SESSION_KEY);

        // Kiểm tra null
        if (data == null) {
            return Collections.emptyList();
        }

        // Kiểm tra type
        if (!(data instanceof List<?>)) {
            return Collections.emptyList();
        }

        // Chuyển đổi
        List<?> rawList = (List<?>) data;
        List<Long> result = new ArrayList<>();

        for (Object value : rawList) {
            try {
                if (value instanceof Long) {
                    result.add((Long) value);
                } else if (value instanceof Integer) {
                    result.add(((Integer) value).longValue());
                } else if (value instanceof String) {
                    result.add(Long.parseLong((String) value));
                } else if (value instanceof Number) {
                    result.add(((Number) value).longValue());
                }
            } catch (NumberFormatException ex) {
            }
        }

        return result;
    }

    private double parseDouble(String raw) {
        if (raw == null || raw.isBlank()) {
            return 0d;
        }
        try {
            return Double.parseDouble(raw.trim());
        } catch (NumberFormatException ignored) {
            return 0d;
        }
    }

    private List<Long> parseSelectedIds(String raw) {
        if (raw == null || raw.isBlank()) {
            return Collections.emptyList();
        }
        String[] parts = raw.split(",");
        List<Long> result = new ArrayList<>();
        for (String part : parts) {
            try {
                result.add(Long.parseLong(part.trim()));
            } catch (NumberFormatException ignored) {
            }
        }
        return result;
    }

    @GetMapping("/checkout")
    public String getCheckoutPage(Model model, HttpServletRequest request) {
        HttpSession session = request.getSession();

        // Load cartDetails trước
        List<CartDetails> cartDetails = new ArrayList<>();
        double totalPrice = 0.0;

        Long cartId = (Long) session.getAttribute("cartId");
        if (cartId != null) {
            Cart cart = this.cartRepository.findById(cartId).orElse(null);
            if (cart != null) {
                List<CartDetails> allCartDetails = cart.getCartDetails();
                if (allCartDetails != null && !allCartDetails.isEmpty()) {
                    List<Long> selectedIds = getSelectedIdsFromSession(session);

                    // Filter theo selectedIds nếu có
                    if (!selectedIds.isEmpty()) {
                        for (CartDetails cd : allCartDetails) {
                            if (cd != null && selectedIds.contains(cd.getId())) {
                                cartDetails.add(cd);
                            }
                        }
                    } else {
                        cartDetails = allCartDetails;
                    }

                    // Tính totalPrice
                    for (CartDetails cd : cartDetails) {
                        if (cd != null) {
                            totalPrice += cd.getPrice() * cd.getQuantity();
                        }
                    }
                }
            }
        }

        // Kiểm tra error/errorDetails từ flash attribute (chỉ tồn tại 1 request sau
        // redirect)
        boolean hasError = model.containsAttribute("error");
        boolean hasErrorDetails = model.containsAttribute("errorDetails");
        String errorParam = request.getParameter("error");

        // Nếu CÓ error/errorDetails và cartDetails TRỐNG thì hiển thị trang checkout
        // với error
        // Race Condition
        if ((hasError || hasErrorDetails || (errorParam != null && !errorParam.isEmpty()))
                && cartDetails.isEmpty()) {
            model.addAttribute("cartDetails", new ArrayList<>());
            model.addAttribute("totalPrice", 0.0);
            return "client/order/checkout";
        }

        // Nếu ko có error và cartDetails trống thì redirect về cart
        if (cartDetails.isEmpty()) {
            return "redirect:/cart";
        }

        model.addAttribute("cartDetails", cartDetails);
        model.addAttribute("totalPrice", totalPrice);

        return "client/order/checkout";
    }

    @PostMapping("/checkout")
    public String postCheckoutPage(Model model, HttpServletRequest request,
            @RequestParam(value = "selectedCartDetailIds", required = false) String selectedCartDetailIds) {

        HttpSession session = request.getSession();

        List<Long> parsedIds = parseSelectedIds(selectedCartDetailIds);
        if (parsedIds.isEmpty()) {
            session.removeAttribute(SELECTED_CART_DETAILS_SESSION_KEY);
        } else {
            session.setAttribute(SELECTED_CART_DETAILS_SESSION_KEY, parsedIds);
        }
        return getCheckoutPage(model, request);

    }

    // viết riêng API để kiểm tra stock trước khi submit form
    @PostMapping("/check-stock")
    @ResponseBody
    public Map<String, Object> checkStockBeforeOrder(HttpServletRequest request) {
        Map<String, Object> response = new HashMap<>();

        try {
            HttpSession session = request.getSession();
            Long cartId = (Long) session.getAttribute("cartId");

            if (cartId == null) {
                response.put("success", false);
                response.put("message", "Giỏ hàng trống");
                return response;
            }

            Cart cart = this.cartRepository.findById(cartId).orElse(null);
            if (cart == null) {
                response.put("success", false);
                response.put("message", "Giỏ hàng không tồn tại");
                return response;
            }

            List<CartDetails> cartDetails = cart.getCartDetails();
            if (cartDetails == null || cartDetails.isEmpty()) {
                response.put("success", false);
                response.put("message", "Giỏ hàng trống");
                return response;
            }

            // Lọc theo selectedIds nếu có
            List<Long> selectedIds = getSelectedIdsFromSession(session);
            if (!selectedIds.isEmpty()) {
                List<CartDetails> filtered = new ArrayList<>();
                for (CartDetails cd : cartDetails) {
                    if (cd != null && selectedIds.contains(cd.getId())) {
                        filtered.add(cd);
                    }
                }
                cartDetails = filtered;
            }

            if (cartDetails.isEmpty()) {
                response.put("success", false);
                response.put("message", "Không có sản phẩm được chọn");
                return response;
            }

            // Kiểm tra stock
            Map<Long, String> stockErrors = productService.validateStockAvailability(cartDetails);
            if (!stockErrors.isEmpty()) {
                // Tạo danh sách chi tiết các sản phẩm bị lỗi
                List<Map<String, Object>> errorDetails = new ArrayList<>();
                for (CartDetails cd : cartDetails) {
                    if (cd != null && cd.getProduct() != null && stockErrors.containsKey(cd.getProduct().getId())) {
                        Map<String, Object> errorInfo = new HashMap<>();
                        errorInfo.put("productId", cd.getProduct().getId());
                        errorInfo.put("productName", cd.getProduct().getName());
                        errorInfo.put("requestedQuantity", cd.getQuantity());
                        // Lấy số lượng còn trong kho
                        Long availableStock = warehouseService.getStockQuantity(cd.getProduct().getId());
                        errorInfo.put("availableQuantity", availableStock != null ? availableStock : 0);
                        errorInfo.put("message",
                                "Sản phẩm " + cd.getProduct().getName() + " chỉ còn " + availableStock + " sản phẩm");
                        errorDetails.add(errorInfo);
                    }
                }

                response.put("success", false);
                response.put("message", String.join(", ", stockErrors.values()));
                response.put("errors", stockErrors);
                response.put("errorDetails", errorDetails); // Danh sách chi tiết
                return response;
            }

            response.put("success", true);
            response.put("message", "Đủ hàng");
            return response;
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra khi kiểm tra tồn kho: " + e.getMessage());
            return response;
        }
    }

    @PostMapping("/place-order")
    public String handlePlaceOrder(
            HttpServletRequest request,
            RedirectAttributes redirectAttributes,
            @RequestParam("receiverName") String receiverName,
            @RequestParam("receiverAddress") String receiverAddress,
            @RequestParam("receiverPhone") String receiverPhone,
            @RequestParam("paymentMethod") String paymentMethod,
            @RequestParam(value = "totalPrice", required = false) String totalPrice) {

        HttpSession session = request.getSession();
        long id = (long) session.getAttribute("id");

        User currentUser = new User();
        currentUser.setId(id);

        final String uuid = UUID.randomUUID().toString().replace("-", "");
        try {
            this.productService.handlePlaceOrder(
                    currentUser,
                    session,
                    receiverName,
                    receiverAddress,
                    receiverPhone,
                    paymentMethod,
                    uuid,
                    parseDouble(totalPrice),
                    getSelectedIdsFromSession(session));

            session.removeAttribute(SELECTED_CART_DETAILS_SESSION_KEY);
            return "redirect:/thankyou";
        } catch (InsufficientStockException ex) {
            // Xử lý lỗi không đủ hàng với errorDetails chi tiết - redirect về trang failed
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            // Lưu errorDetails vào flash attribute để hiển thị bảng chi tiết
            if (ex.getErrorDetails() != null && !ex.getErrorDetails().isEmpty()) {
                redirectAttributes.addFlashAttribute("errorDetails", ex.getErrorDetails());
            }
            return "redirect:/order/failed";
        } catch (RuntimeException ex) {
            // Redirect về trang failed với error message
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
            return "redirect:/order/failed";
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi đặt hàng: " + ex.getMessage());
            return "redirect:/order/failed";
        }
    }

    @GetMapping("/failed")
    public String getFailedPage(Model model, HttpServletRequest request) {
        // Trang failed để hiển thị lỗi khi đặt hàng thất bại
        // Không cần kiểm tra cart hay gì cả - chỉ cần hiển thị error
        // Error và errorDetails được truyền qua flash attributes từ redirect trước đó
        return "client/order/failed";
    }

    @GetMapping("/after-order")
    public String getAfterOrderPage(HttpServletRequest request) {
        HttpSession session = request.getSession();
        long id = (long) session.getAttribute("id");

        User user = this.userService.getUserById(id);
        String email = user.getEmail();

        sendEmailService.sendEmail(
                email,
                "Xác nhận đơn hàng",
                "Furniture Store chân thành cảm ơn bạn đã tin tưởng sử dụng sản phẩm của chúng tôi!");

        return "client/cart/after-order";
    }
}
