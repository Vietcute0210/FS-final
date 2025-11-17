package com.group10.furniture_store.controller.client;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import com.group10.furniture_store.domain.Cart;
import com.group10.furniture_store.domain.CartDetails;
import com.group10.furniture_store.domain.Product;
import com.group10.furniture_store.domain.User;
import com.group10.furniture_store.service.ProductService;
import com.group10.furniture_store.service.WarehouseService;

@Controller
public class ItemController {
    @Autowired
    private final ProductService productService;
    @Autowired
    private WarehouseService warehouseService;

    public ItemController(ProductService productService, WarehouseService warehouseService) {
        this.productService = productService;
        this.warehouseService = warehouseService;
    }

    @GetMapping("/product/{id}")
    public String getProductPage(Model model, @PathVariable long id) {
        Product product = this.productService.getProductById(id);
        if (product == null) {
            return "redirect:/products";
        }
        model.addAttribute("product", product);
        List<Product> recommendations = this.productService.getRecommendedProducts(product, 4);
        model.addAttribute("recommendations", recommendations);
        return "client/product/detail";
    }

    @GetMapping("/products")
    public String getProductPage(Model model,
            @RequestParam("page") Optional<String> pageOptional, HttpServletRequest request) {
        int page = 1;
        try {
            if (pageOptional.isPresent()) {
                page = Integer.parseInt(pageOptional.get());
            }
        } catch (Exception ex) {
        }

        Pageable pageable = PageRequest.of(page - 1, 3);
        Page<Product> products = this.productService.getAllProducts(pageable);

        // Lấy query string
        String queryString = request.getQueryString();
        if (queryString != null && queryString.contains("page=")) {
            queryString = queryString.replaceAll("page=\\d+&?", "");
            queryString = queryString.replaceAll("&$", "");
            if (queryString.length() > 0 && !queryString.startsWith("&")) {
                queryString = "&" + queryString;
            } else if (queryString.length() == 0) {
                queryString = "";
            }
        } else if (queryString != null && queryString.length() > 0) {
            queryString = "&" + queryString;
        } else {
            queryString = "";
        }

        model.addAttribute("products", products.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", products.getTotalPages());
        model.addAttribute("queryString", queryString);
        return "client/product/show";
    }

    @PostMapping("/add-product-to-cart/{id}")
    public String addProductToCart(Model model, @PathVariable long id, HttpServletRequest request,
            @RequestParam(value = "page", required = false) String page) {
        long productId = id;
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        if (email == null) {
            return "redirect:/login";
        }

        this.productService.handleAddProductToCart(email, productId, session, 1);

        String redirectUrl = "/products";
        if (page != null && !page.isEmpty()) {
            redirectUrl += "?page=" + page;
        }
        return "redirect:" + redirectUrl;
    }

    @PostMapping("/add-product-from-view-detail")
    public String handleAddProductFromViewDetail(
            @RequestParam("id") long id,
            @RequestParam("quantity") long quantity,
            HttpServletRequest request) {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        this.productService.handleAddProductToCart(email, id, session, quantity);
        return "redirect:/products/" + id;
    }

    @GetMapping("/cart")
    public String getCartPage(Model model, HttpServletRequest request) {
        HttpSession session = request.getSession();
        long id = (long) session.getAttribute("id");

        User currentUser = new User();
        currentUser.setId(id);

        Cart cart = this.productService.fetchCartByUser(currentUser);
        if (cart != null) {
            session.setAttribute("cartId", cart.getId());
            cart = this.productService.fetchCartByUser(currentUser);
            Long sum = cart.getCartDetails() != null ? (long) cart.getCartDetails().size() : 0L;
            cart.setSum(sum);
            session.setAttribute("sum", sum);
        } else {
            // Nếu không có cart, reset sum về 0
            session.removeAttribute("cartId");
            session.setAttribute("sum", 0L);
        }
        List<CartDetails> cartDetails = cart == null ? new ArrayList<>() : cart.getCartDetails();

        double totalPrice = 0;
        for (CartDetails cd : cartDetails) {
            totalPrice += cd.getQuantity() * cd.getPrice();
        }
        model.addAttribute("cartDetails", cartDetails);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("cart", cart);
        return "client/cart/show";
    }

    @PostMapping("/delete-cart-product/{id}")
    public String deleteCartDetail(@PathVariable long id, HttpServletRequest request) {
        HttpSession session = request.getSession();
        long cartDetailId = id;
        this.productService.handleRemoveCartDetail(cartDetailId, session);
        return "redirect:/cart";
    }

    @PostMapping("/confirm-checkout")
    public String confirmCheckout(@ModelAttribute("cart") Cart cart) {
        List<CartDetails> cartDetails = cart == null ? new ArrayList<>() : cart.getCartDetails();
        this.productService.handleUpdateCartBeforeCheckout(cartDetails);
        return "redirect:/checkout";
    }

    @GetMapping("/search")
    public ResponseEntity<?> searchProducts(@RequestParam("keyword") String keyword) {
        try {

            if (keyword == null || keyword.trim().isEmpty()) {
                return ResponseEntity.ok().contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                        .body(new java.util.ArrayList<>());
            }

            List<Product> products = productService.searchByName(keyword.trim());

            List<Map<String, Object>> result = products.stream().map(p -> {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("id", p.getId());
                map.put("name", p.getName());
                map.put("image", p.getImage());
                map.put("price", p.getPrice());
                map.put("shortDesc", p.getShortDesc());

                // Load stock từ warehouse service
                Long stockQuantity = warehouseService.getStockQuantity(p.getId());
                map.put("stockQuantity", stockQuantity != null ? stockQuantity : 0L);

                return map;
            }).collect(java.util.stream.Collectors.toList());

            return ResponseEntity.ok()
                    .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                    .header("Access-Control-Allow-Origin", "*")
                    .body(result);
        } catch (Exception ex) {
            ex.printStackTrace();
            // Trả về JSON object với lỗi
            Map<String, Object> errorResponse = new java.util.HashMap<>();
            errorResponse.put("error", true);
            errorResponse.put("message", "Lỗi khi tìm kiếm sản phẩm: " + ex.getMessage());
            errorResponse.put("products", new java.util.ArrayList<>());
            return ResponseEntity.status(500)
                    .contentType(org.springframework.http.MediaType.APPLICATION_JSON)
                    .body(errorResponse);
        }
    }

    @GetMapping("/products/filter-data")
    public ResponseEntity<?> filterProducts(
            @RequestParam(value = "factories", required = false) List<String> factories,
            @RequestParam(value = "targets", required = false) List<String> targets,
            @RequestParam(value = "prices", required = false) List<String> prices,
            @RequestParam(value = "sort", required = false) String sort) {
        try {
            List<Product> products = productService.filterProducts(factories, targets, prices, sort);
            List<Map<String, Object>> result = products.stream().map(p -> {
                Map<String, Object> map = new java.util.HashMap<>();
                map.put("id", p.getId());
                map.put("name", p.getName());
                map.put("image", p.getImage());
                map.put("price", p.getPrice());
                map.put("shortDesc", p.getShortDesc());

                // Load stock từ warehouse service
                Long stockQuantity = warehouseService.getStockQuantity(p.getId());
                map.put("stockQuantity", stockQuantity != null ? stockQuantity : 0L);

                return map;
            }).collect(java.util.stream.Collectors.toList());

            return ResponseEntity.ok(result);
        } catch (Exception ex) {
            ex.printStackTrace();
            return ResponseEntity.status(500).body("Lỗi khi lọc sản phẩm: " + ex.getMessage());
        }
    }

    @GetMapping("/thankyou")
    public String thankyouPage(@RequestParam(required = false) String orderId, Model model) {
        if (orderId != null) {
            model.addAttribute("orderId", orderId);
        }
        return "client/order/thankyou";
    }
}
