package com.group10.furniture_store.service;

import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.function.Predicate;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;

import com.group10.furniture_store.domain.Cart;
import com.group10.furniture_store.domain.CartDetails;
import com.group10.furniture_store.domain.Order;
import com.group10.furniture_store.domain.OrderDetail;
import com.group10.furniture_store.domain.Product;
import com.group10.furniture_store.domain.User;
import com.group10.furniture_store.domain.Warehouse;
import com.group10.furniture_store.exception.InsufficientStockException;
import com.group10.furniture_store.repository.CartDetailsRepository;
import com.group10.furniture_store.repository.CartRepository;
import com.group10.furniture_store.repository.OrderDetailRepository;
import com.group10.furniture_store.repository.OrderRepository;
import com.group10.furniture_store.repository.ProductRepository;

import jakarta.servlet.http.HttpSession;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ProductService {
    private final ProductRepository productRepository;
    private final CartRepository cartRepository;
    private final CartDetailsRepository cartDetailsRepository;
    private final UserService userService;
    private final OrderRepository orderRepository;
    private final OrderDetailRepository orderDetailRepository;
    private final WarehouseService warehouseService;

    // dùng xử lý logic filter
    private static final Map<String, double[]> PRICE_RANGE_MAP = createPriceRangeMap();
    private static final Map<String, Set<String>> FACTORY_SYNONYMS = createFactorySynonyms();
    private static final Map<String, Set<String>> TARGET_KEYWORDS = createTargetKeywordMap();
    private static final List<String> TARGET_PRIORITY = List.of("GAMING", "SINHVIEN-VANPHONG",
            "THIET-KE-DO-HOA", "MONG-NHE", "DOANH-NHAN");
    private static final Set<String> CLOTHING_RACK_KEYWORDS = Set.of("GIA-TREO", "GIA-TREO-QUAN-AO",
            "GIA-DE-QUAN-AO", "PIPE-RACK", "GIA-TREO-PIPE-RACK");

    public ProductService(ProductRepository productRepository, CartRepository cartRepository,
            CartDetailsRepository cartDetailsRepository, UserService userService, OrderRepository orderRepository,
            OrderDetailRepository orderDetailRepository, WarehouseService warehouseService) {
        this.productRepository = productRepository;
        this.cartRepository = cartRepository;
        this.cartDetailsRepository = cartDetailsRepository;
        this.userService = userService;
        this.orderRepository = orderRepository;
        this.orderDetailRepository = orderDetailRepository;
        this.warehouseService = warehouseService;
    }

    public Page<Product> getAllProducts(Pageable pageable) {
        Page<Product> products = this.productRepository.findAll(pageable);
        // Load warehouse cho mỗi product để quantity được hiển thị đúng
        products.getContent().forEach(p -> {
            Warehouse warehouse = warehouseService.getWarehouseByProductId(p.getId());
            if (warehouse != null) {
                p.setWarehouse(warehouse);
            }
        });
        return products;
    }

    @Transactional
    public Product handleSaveProduct(Product product) {
        // Lưu product trước
        Product savedProduct = this.productRepository.save(product);

        // Đồng bộ quantity vào warehouse
        // Lấy quantity từ product (có thể từ form binding hoặc từ warehouse hiện tại)
        long quantity = product.getQuantity();
        if (quantity >= 0) { // Cho phép quantity = 0
            // getOrCreateWarehouse sẽ tạo warehouse mới nếu chưa có
            Warehouse warehouse = warehouseService.getOrCreateWarehouse(savedProduct);
            if (warehouse != null) {
                // Cập nhật quantity vào warehouse
                warehouseService.updateStockQuantity(savedProduct.getId(), quantity);
                // Load lại warehouse để đảm bảo product có reference đúng
                warehouse = warehouseService.getWarehouseByProductId(savedProduct.getId());
                if (warehouse != null) {
                    savedProduct.setWarehouse(warehouse);
                }
            }
        }

        return savedProduct;
    }

    public Product getProductById(long id) {
        Optional<Product> productOptional = this.productRepository.findById(id);
        Product product = productOptional.isPresent() ? productOptional.get() : null;
        // Load warehouse để quantity được hiển thị đúng
        if (product != null) {
            Warehouse warehouse = warehouseService.getWarehouseByProductId(product.getId());
            if (warehouse != null) {
                product.setWarehouse(warehouse);
            }
        }
        return product;
    }

    public List<Product> getRecommendedProducts(Product product, int limit) {
        if (product == null) {
            return Collections.emptyList();
        }
        int resolvedLimit = limit > 0 ? limit : 4;
        long excludedId = product.getId();
        String normalizedTarget = normalizeValue(product.getTarget());
        String normalizedFactory = normalizeValue(product.getFactory());

        List<Product> sortedProducts = productRepository.findAll().stream()
                .filter(Objects::nonNull)
                .sorted(Comparator.comparingLong(Product::getSold).reversed())
                .collect(Collectors.toList());

        List<Product> recommendations = new ArrayList<>();
        Set<Long> addedIds = new HashSet<>();

        if (normalizedTarget != null) {
            collectRecommendations(sortedProducts, recommendations, addedIds, resolvedLimit, excludedId,
                    candidate -> matchesTargetSelection(normalizeValue(candidate.getTarget()),
                            buildSearchableKeywords(candidate), normalizedTarget));
        }

        if (recommendations.size() < resolvedLimit && normalizedFactory != null) {
            collectRecommendations(sortedProducts, recommendations, addedIds, resolvedLimit, excludedId,
                    candidate -> {
                        String candidateFactory = normalizeValue(candidate.getFactory());
                        if (candidateFactory != null && candidateFactory.equals(normalizedFactory)) {
                            return true;
                        }
                        return matchWithSynonyms(candidateFactory, buildSearchableKeywords(candidate),
                                normalizedFactory, FACTORY_SYNONYMS);
                    });
        }

        if (recommendations.size() < resolvedLimit) {
            collectRecommendations(sortedProducts, recommendations, addedIds, resolvedLimit, excludedId,
                    candidate -> true);
        }

        return recommendations;
    }

    public void handleDeleteProduct(long id) {
        this.productRepository.deleteById(id);
    }

    private void updateSessionCartState(HttpSession session, Cart cart) {
        if (session == null || cart == null) {
            return;
        }

        long cartItemCount = cart.getCartDetails() != null ? cart.getCartDetails().size() : 0;
        long totalQuantity = cart.getCartDetails() != null
                ? cart.getCartDetails().stream().mapToLong(CartDetails::getQuantity).sum()
                : 0;

        session.setAttribute("cartId", cart.getId());
        session.setAttribute("sum", cartItemCount); // Số lượng items
        session.setAttribute("cartItemCount", cartItemCount);
        session.setAttribute("totalQuantity", totalQuantity); // Tổng số lượng (quantity * items)

    }

    public void handleAddProductToCart(String email, long productId, HttpSession session, long quantity) {
        try {
            User user = this.userService.getUserByEmail(email);
            if (user != null) {
                // check user đã có Cart chưa ? Nếu chưa => Tạo mới
                Cart cart = this.cartRepository.findByUser(user);
                if (cart == null) {
                    // tạo mới cart khi user chưa có cart
                    Cart otherCart = new Cart();
                    otherCart.setUser(user);
                    otherCart.setSum(0L);

                    cart = this.cartRepository.save(otherCart);
                }
                // tìm productById
                Optional<Product> producOptional = this.productRepository.findById(productId);
                if (producOptional.isPresent()) {
                    Product pr = producOptional.get();

                    // Kiểm tra tồn kho trước khi thêm
                    Long availableStock = this.warehouseService.getStockQuantity(pr.getId());
                    if (availableStock <= 0) {
                        throw new RuntimeException("Sản phẩm đã hết hàng");
                    }

                    // check sản phẩm đã từng được thêm vào giỏ hàng trước đó chưa
                    CartDetails oldCartDetail = this.cartDetailsRepository.findByCartAndProduct(cart, pr);

                    // Nếu chưa được thêm , thì phải thêm vào giỏ
                    if (oldCartDetail == null) {
                        CartDetails cd = new CartDetails();

                        cd.setCart(cart);
                        cd.setProduct(pr);
                        cd.setPrice(pr.getPrice());
                        cd.setQuantity(quantity);

                        this.cartDetailsRepository.save(cd);
                    }

                    // Nếu sp đã được thêm vào giỏ hàng trước đó rồi , thì update quantity cho nó
                    else {
                        oldCartDetail.setQuantity(oldCartDetail.getQuantity() + quantity);
                        this.cartDetailsRepository.save(oldCartDetail);
                    }

                    // Cập nhật Cart sum (số lượng items - không phải tổng quantity)
                    List<CartDetails> allCartDetails = cart.getCartDetails();
                    long cartItemCount = allCartDetails != null ? allCartDetails.size() : 0;
                    cart.setSum(cartItemCount);
                    this.cartRepository.save(cart);

                    // Cập nhật session
                    updateSessionCartState(session, cart);
                }
            }
        } catch (IllegalArgumentException ex) {
            throw ex;
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Không thể thêm sản phẩm vào giỏ hàng" + ex.getMessage());
        }
    }

    @Transactional
    public void handleRemoveCartDetail(long cartDetailId, HttpSession session) {
        Optional<CartDetails> cartDetailsOptional = this.cartDetailsRepository.findById(cartDetailId);
        if (cartDetailsOptional.isPresent()) {
            CartDetails cartDetails = cartDetailsOptional.get();
            Cart currentCart = cartDetails.getCart();
            Long cartId = currentCart.getId();

            // delete cartDetail
            this.cartDetailsRepository.deleteById(cartDetailId);

            // lấy lại currentCart từ database để lấy cartDetails mới nhất
            currentCart = this.cartRepository.findById(cartId).orElse(null);

            if (currentCart != null && !currentCart.getCartDetails().isEmpty()) {
                List<CartDetails> currentCartDetails = currentCart.getCartDetails();
                if (currentCartDetails != null && !currentCartDetails.isEmpty()) {
                    Long sum = (long) currentCartDetails.size();
                    currentCart.setSum(sum);
                    this.cartRepository.save(currentCart);
                    updateSessionCartState(session, currentCart);
                } else {
                    // 0 còn sp trong cart -> xóa cart
                    this.cartRepository.deleteById(cartId);
                    session.removeAttribute("cartId");
                    session.setAttribute("sum", 0L);
                    session.setAttribute("cartItemCount", 0L);
                    session.setAttribute("totalQuantity", 0L);
                }

            }
        } else {
            throw new RuntimeException("Không tìm thấy sản phẩm trong giỏ hàng");
        }
    }

    public void handleUpdateCartBeforeCheckout(List<CartDetails> cartDetails) {
        for (CartDetails cd : cartDetails) {
            Optional<CartDetails> cdOptional = this.cartDetailsRepository.findById(cd.getId());
            if (cdOptional.isPresent()) {
                CartDetails currentCartDetails = cdOptional.get();
                currentCartDetails.setQuantity(cd.getQuantity());
                this.cartDetailsRepository.save(currentCartDetails);
            }
        }
    }

    // bản đơn giản (giữ tương thích với PaymentController hiện tại)
    @Transactional
    public void handlePlaceOrder(User user,
            HttpSession session,
            String receiverName,
            String receiverAddress,
            String receiverPhone,
            String paymentMethod,
            String uuid,
            Double totalPrice) {
        handlePlaceOrder(user, session, receiverName, receiverAddress, receiverPhone,
                paymentMethod, uuid, totalPrice, null);
    }

    @Transactional(isolation = Isolation.SERIALIZABLE)
    public void handlePlaceOrder(User user,
            HttpSession session,
            String receiverName,
            String receiverAddress,
            String receiverPhone,
            String paymentMethod,
            String uuid,
            Double totalPrice,
            List<Long> selectedCartDetailIds) {

        // ===== 1. GET CART =====
        Cart cart = this.cartRepository.findByUser(user);
        if (cart == null) {
            throw new RuntimeException("Giỏ hàng không tồn tại");
        }

        List<CartDetails> cartDetails = cart.getCartDetails();
        if (cartDetails == null || cartDetails.isEmpty()) {
            throw new RuntimeException("Giỏ hàng trống");
        }

        // ===== 2. FILTER SELECTED ITEMS =====
        List<CartDetails> orderItems = cartDetails;
        if (selectedCartDetailIds != null && !selectedCartDetailIds.isEmpty()) {
            Set<Long> selectedIdSet = selectedCartDetailIds.stream()
                    .filter(Objects::nonNull)
                    .collect(Collectors.toSet());
            orderItems = cartDetails.stream()
                    .filter(cd -> cd != null && selectedIdSet.contains(cd.getId()))
                    .collect(Collectors.toList());
        }

        if (orderItems.isEmpty()) {
            throw new RuntimeException("Không có sản phẩm nào được chọn");
        }

        // Lock và Validate Stock
        Map<Long, Long> productQuantities = new HashMap<>();
        for (CartDetails cd : orderItems) {
            if (cd.getProduct() != null) {
                Long productId = cd.getProduct().getId();
                long requestedQty = cd.getQuantity();
                productQuantities.merge(productId, requestedQty, Long::sum);
            }
        }

        // Lock warehouse và kiểm tra tồn kho trong 1 transaction
        // Đây là bước quan trọng để xử lý race condition - lock pessimistic
        Map<Long, String> stockErrors = warehouseService.validateAndLockStock(productQuantities);
        if (!stockErrors.isEmpty()) {
            // Tạo danh sách chi tiết các sản phẩm bị lỗi để hiển thị bảng
            List<Map<String, Object>> errorDetails = new ArrayList<>();
            for (CartDetails cd : orderItems) {
                if (cd != null && cd.getProduct() != null && stockErrors.containsKey(cd.getProduct().getId())) {
                    Map<String, Object> errorInfo = new HashMap<>();
                    errorInfo.put("productId", cd.getProduct().getId());
                    errorInfo.put("productName", cd.getProduct().getName());
                    errorInfo.put("requestedQuantity", cd.getQuantity());
                    // Lấy số lượng còn trong kho (đã được lock ở validateAndLockStock)
                    Warehouse warehouse = warehouseService.getWarehouseByProductId(cd.getProduct().getId());
                    Long availableStock = warehouse != null && warehouse.getQuantity() != null
                            ? warehouse.getQuantity()
                            : 0L;
                    errorInfo.put("availableQuantity", availableStock);
                    errorInfo.put("message",
                            "Sản phẩm " + cd.getProduct().getName() + " chỉ còn " + availableStock + " sản phẩm");
                    errorDetails.add(errorInfo);
                }
            }

            // Format error message đẹp hơn
            String errorMessage = String.join(", ", stockErrors.values());
            throw new InsufficientStockException(errorMessage, stockErrors, errorDetails);
        }

        // tính tổng tiền
        double calculatedTotal = orderItems.stream()
                .mapToDouble(cd -> cd.getPrice() * cd.getQuantity())
                .sum();
        double resolvedTotal = calculatedTotal > 0
                ? calculatedTotal
                : (totalPrice != null ? totalPrice : 0d);

        // tạo đơn hàng
        Order order = new Order();
        order.setUser(user);
        order.setReceiverName(receiverName);
        order.setReceiverAddress(receiverAddress);
        order.setReceiverPhone(receiverPhone);
        order.setStatus("Chưa được xử lý");
        order.setPaymentMethod(paymentMethod);
        order.setPaymentStatus("Thanh toán thành công");
        order.setPaymentRef("COD".equals(paymentMethod) ? "UNKNOWN" : uuid);
        order.setTotalPrice(resolvedTotal);
        order = this.orderRepository.save(order);

        // tạo chi tiết đơn hàng
        for (CartDetails cd : orderItems) {
            OrderDetail orderDetail = new OrderDetail();
            orderDetail.setOrder(order);
            orderDetail.setProduct(cd.getProduct());
            orderDetail.setPrice(cd.getPrice());
            orderDetail.setQuantity(cd.getQuantity());
            this.orderDetailRepository.save(orderDetail);
        }

        // trừ kho(đã lock trước đó)
        Map<Long, Boolean> stockResults = warehouseService.decreaseStockForMultipleProducts(productQuantities);

        for (Map.Entry<Long, Boolean> entry : stockResults.entrySet()) {
            if (!entry.getValue()) {
                // Rollback tự động do @Transactional
                throw new RuntimeException("Không thể trừ kho cho sản phẩm: " + entry.getKey());
            }
        }

        // xóa các mục trong giỏ hàng
        for (CartDetails cd : orderItems) {
            this.cartDetailsRepository.deleteById(cd.getId());
        }

        // Nếu đã mua hết cart thì xóa cart
        cart = this.cartRepository.findById(cart.getId()).orElse(null);
        if (cart != null && (cart.getCartDetails() == null || cart.getCartDetails().isEmpty())) {
            this.cartRepository.deleteById(cart.getId());
            session.setAttribute("sum", 0L);
            session.setAttribute("cartItemCount", 0L);
            session.setAttribute("totalQuantity", 0L);
        } else if (cart != null) {
            // Update session nếu còn items
            updateSessionCartState(session, cart);
        }

        System.out.println("Order placed successfully: " + order.getId());
    }

    public Cart fetchCartByUser(User user) {
        return this.cartRepository.findByUser(user);
    }

    public void updatePaymentStatus(String paymentRef, String paymentStatus) {
        Order order = this.orderRepository.findByPaymentRef(paymentRef);
        order.setPaymentStatus(paymentStatus);
    }

    public List<Product> searchByName(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }
        System.out.println("Searching for: " + keyword);
        try {
            List<Product> results = productRepository.findByNameContainingIgnoreCaseOrderByIdDesc(keyword);
            System.out.println("Search results: " + results.size());

            // Load warehouse cho mỗi product
            results.forEach(p -> {
                Warehouse warehouse = warehouseService.getWarehouseByProductId(p.getId());
                if (warehouse != null) {
                    p.setWarehouse(warehouse);
                } else {
                }
            });

            return results;
        } catch (Exception e) {
            System.err.println("Error searching: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Kiểm tra tồn kho trước khi đặt hàng
    public Map<Long, String> validateStockAvailability(List<CartDetails> cartDetails) {
        Map<Long, String> errors = new HashMap<>();
        for (CartDetails cd : cartDetails) {
            Long productId = cd.getProduct().getId();
            Long requestedQuantity = cd.getQuantity();
            Long availableQuantity = warehouseService.getStockQuantity(productId);

            if (availableQuantity < requestedQuantity) {
                errors.put(productId, String.format("Sản phẩm '%s' chỉ còn %d sản phẩm", cd.getProduct().getName(),
                        availableQuantity));
            }
        }
        return errors;
    }

    @Transactional
    public void updateCartDetailQuantity(Long cartDetailId, Long quantity, HttpSession session) {
        try {
            // Validate
            if (cartDetailId == null || cartDetailId <= 0) {
                throw new IllegalArgumentException("ID CartDetail không hợp lệ");
            }
            if (quantity == null || quantity < 1) {
                throw new IllegalArgumentException("Số lượng phải lớn hơn 0");
            }

            CartDetails cartDetail = this.cartDetailsRepository.findById(cartDetailId)
                    .orElseThrow(() -> new RuntimeException("CartDetail không tồn tại"));

            Cart cart = cartDetail.getCart();

            // Cập nhật quantity
            cartDetail.setQuantity(quantity);
            this.cartDetailsRepository.save(cartDetail);

            // Cập nhật cart
            long cartItemCount = cart.getCartDetails().size();
            cart.setSum(cartItemCount);
            this.cartRepository.save(cart);

            // Cập nhật session
            updateSessionCartState(session, cart);
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Không thể cập nhật số lượng sản phẩm");
        }
    }

    // Các hàm tạo map tĩnh cho filter (giá, hãng, đối tượng) (pv làm)
    private static Map<String, double[]> createPriceRangeMap() {
        Map<String, double[]> ranges = new HashMap<>();
        putPriceRange(ranges, "duoi-10-trieu", 0d, 10_000_000d);
        putPriceRange(ranges, "10-15-trieu", 10_000_000d, 15_000_000d);
        putPriceRange(ranges, "15-20-trieu", 15_000_000d, 20_000_000d);
        putPriceRange(ranges, "tren-20-trieu", 20_000_000d, Double.POSITIVE_INFINITY);
        return Collections.unmodifiableMap(ranges);
    }

    private static Map<String, Set<String>> createFactorySynonyms() {
        Map<String, List<String>> raw = new HashMap<>();
        raw.put("FACTORY1", List.of("FACTORY1", "CTY1", "CONG-TY-1", "NHA-MAY-1", "HANG1"));
        raw.put("FACTORY2", List.of("FACTORY2", "CTY2", "CONG-TY-2", "NHA-MAY-2", "HANG2"));
        raw.put("FACTORY3", List.of("FACTORY3", "CTY3", "CONG-TY-3", "NHA-MAY-3", "HANG3"));
        return normalizeSynonymMap(raw);
    }

    private static Map<String, Set<String>> createTargetKeywordMap() {
        Map<String, List<String>> raw = new HashMap<>();
        raw.put("GAMING",
                List.of("GHE", "GHE-XOAY", "GHE-CONG-THAI-HOC", "GHE-GAMING", "GHE-VAN-PHONG", "GHE-TRE-EM",
                        "GHE-THU-GIAN", "SOFA", "SALON", "GHE-SOFA", "BO-BAN-GHE"));
        raw.put("SINHVIEN-VANPHONG",
                List.of("BAN", "BAN-AN", "BAN-LAM-VIEC", "BAN-HOC", "BAN-MAY-TINH", "BAN-TRANG-DIEM", "BAN-TRA",
                        "BAN-DAU-GIUONG", "BAN-CAFE", "BAN-SOFA", "BAN-THONG-MINH", "BO-BAN-GHE", "BAN-CHU-A",
                        "BAN-CHU-A-120CM", "BAN-CHU-A-120", "KINH-TRON", "BAN-KINH-TRON"));
        raw.put("MONG-NHE",
                List.of("TU", "TU-QUAN-AO", "TU-GO", "TU-NHUA", "TU-GIAY", "TU-BEP", "TU-TRANG-TRI"));
        raw.put("DOANH-NHAN",
                List.of("KE", "KE-SACH", "KE-GO", "KE-TIVI", "KE-TRANG-TRI", "KE-GOC", "KE-GIAY", "KE-TREO"));
        raw.put("THIET-KE-DO-HOA",
                List.of("GIUONG", "GIUONG-NGU", "GIUONG-GO", "GIUONG-THONG-MINH", "BO-GIUONG"));
        return normalizeSynonymMap(raw);
    }

    private static Map<String, Set<String>> normalizeSynonymMap(Map<String, List<String>> rawMap) {
        Map<String, Set<String>> normalized = new HashMap<>();
        rawMap.forEach((key, values) -> {
            String normalizedKey = normalizeValue(key);
            if (normalizedKey == null) {
                return;
            }
            Set<String> normalizedValues = values.stream()
                    .map(ProductService::normalizeValue)
                    .filter(Objects::nonNull)
                    .collect(Collectors.toCollection(LinkedHashSet::new));
            normalized.put(normalizedKey, normalizedValues);
        });
        return Collections.unmodifiableMap(normalized);
    }

    private static boolean matchWithSynonyms(String normalizedFieldValue,
            String fallbackSearchText,
            String selectedCode,
            Map<String, Set<String>> synonymsMap) {
        if (selectedCode == null) {
            return false;
        }
        Set<String> synonyms = synonymsMap.getOrDefault(selectedCode, Collections.singleton(selectedCode));
        boolean hasFieldValue = normalizedFieldValue != null && !normalizedFieldValue.isEmpty();
        boolean fieldRecognized = hasFieldValue && belongsToKnownCategory(normalizedFieldValue, synonymsMap);

        for (String synonym : synonyms) {
            if (synonym == null || synonym.isEmpty()) {
                continue;
            }
            if (hasFieldValue && valueMatches(normalizedFieldValue, synonym)) {
                return true;
            }
            if ((!hasFieldValue || !fieldRecognized) && fallbackSearchText != null
                    && fallbackSearchText.contains(synonym)) {
                return true;
            }
        }
        return false;
    }

    private static boolean valueMatches(String value, String keyword) {
        return value.equals(keyword) || value.contains(keyword);
    }

    private static boolean containsKeyword(String text, Set<String> keywords) {
        if (text == null || text.isEmpty() || keywords == null || keywords.isEmpty()) {
            return false;
        }
        for (String keyword : keywords) {
            if (keyword != null && !keyword.isEmpty() && text.contains(keyword)) {
                return true;
            }
        }
        return false;
    }

    private static boolean belongsToKnownCategory(String normalizedFieldValue, Map<String, Set<String>> synonymsMap) {
        if (normalizedFieldValue == null || normalizedFieldValue.isEmpty() || synonymsMap == null) {
            return false;
        }
        for (Set<String> values : synonymsMap.values()) {
            if (values == null) {
                continue;
            }
            for (String synonym : values) {
                if (synonym == null || synonym.isEmpty()) {
                    continue;
                }
                if (valueMatches(normalizedFieldValue, synonym)) {
                    return true;
                }
            }
        }
        return false;
    }

    private static boolean matchesTargetSelection(String normalizedProductTarget, String fallbackSearchText,
            String normalizedSelection) {
        if (normalizedSelection == null) {
            return false;
        }
        if (normalizedProductTarget != null && normalizedSelection.equals(normalizedProductTarget)) {
            return true;
        }
        return matchWithSynonyms(normalizedProductTarget, fallbackSearchText, normalizedSelection, TARGET_KEYWORDS);
    }

    private static String resolveDominantTarget(String normalizedProductTarget, String fallbackSearchText) {
        if (containsKeyword(fallbackSearchText, CLOTHING_RACK_KEYWORDS)) {
            return "KHAC";
        }
        for (String code : TARGET_PRIORITY) {
            if (matchesTargetSelection(null, fallbackSearchText, code)) {
                return code;
            }
        }
        if (normalizedProductTarget != null && TARGET_PRIORITY.contains(normalizedProductTarget)) {
            return normalizedProductTarget;
        }
        return null;
    }

    private static void collectRecommendations(List<Product> candidates,
            List<Product> destination,
            Set<Long> addedIds,
            int limit,
            long excludedId,
            Predicate<Product> matcher) {
        if (matcher == null || candidates == null || destination == null) {
            return;
        }
        for (Product candidate : candidates) {
            if (candidate == null) {
                continue;
            }
            long candidateId = candidate.getId();
            if (candidateId == excludedId || addedIds.contains(candidateId)) {
                continue;
            }
            if (matcher.test(candidate)) {
                destination.add(candidate);
                addedIds.add(candidateId);
                if (destination.size() >= limit) {
                    break;
                }
            }
        }
    }

    private static String buildSearchableKeywords(Product product) {
        StringBuilder builder = new StringBuilder();
        appendNormalized(builder, product.getName());
        appendNormalized(builder, product.getShortDesc());
        appendNormalized(builder, product.getDetailDesc());
        return builder.length() == 0 ? null : builder.toString();
    }

    private static void appendNormalized(StringBuilder builder, String source) {
        String normalized = normalizeValue(source);
        if (normalized == null) {
            return;
        }
        if (builder.length() > 0) {
            builder.append('-');
        }
        builder.append(normalized);
    }

    private static void putPriceRange(Map<String, double[]> ranges, String code, double min, double max) {
        String normalizedCode = normalizeValue(code);
        if (normalizedCode != null) {
            ranges.put(normalizedCode, new double[] { min, max });
        }
    }

    private static String normalizeValue(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        if (trimmed.isEmpty()) {
            return null;
        }
        String normalized = Normalizer.normalize(trimmed, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "")
                .replaceAll("[^A-Za-z0-9]+", "-")
                .replaceAll("(^-|-$)", "")
                .toUpperCase();
        return normalized.isEmpty() ? null : normalized;
    }

    // Method để filter products dựa trên các tiêu chí
    public List<Product> filterProducts(List<String> factories, List<String> targets, List<String> prices,
            String sort) {
        List<Product> allProducts = productRepository.findAll();
        List<Product> filtered = new ArrayList<>();

        for (Product product : allProducts) {
            boolean matchesFactory = true;
            boolean matchesTarget = true;
            boolean matchesPrice = true;
            String searchableKeywords = buildSearchableKeywords(product);
            String normalizedProductFactory = normalizeValue(product.getFactory());
            String normalizedProductTarget = normalizeValue(product.getTarget());
            String resolvedTargetCode = resolveDominantTarget(normalizedProductTarget, searchableKeywords);
            boolean hasResolvedPrimaryTarget = resolvedTargetCode != null && !"KHAC".equals(resolvedTargetCode);
            boolean allowFallbackCategoryMatch = resolvedTargetCode == null;
            boolean resolvedAsOther = "KHAC".equals(resolvedTargetCode);

            // Filter by factory
            if (factories != null && !factories.isEmpty()) {
                matchesFactory = false;
                for (String factory : factories) {
                    String normalizedFactory = normalizeValue(factory);
                    if (normalizedFactory == null) {
                        continue;
                    }
                    boolean directMatch = normalizedProductFactory != null
                            && normalizedProductFactory.equals(normalizedFactory);
                    if (directMatch || matchWithSynonyms(normalizedProductFactory,
                            searchableKeywords, normalizedFactory, FACTORY_SYNONYMS)) {
                        matchesFactory = true;
                        break;
                    }
                }
            }

            // Filter by target
            if (targets != null && !targets.isEmpty()) {
                matchesTarget = false;
                for (String target : targets) {
                    String normalizedTarget = normalizeValue(target);
                    if (normalizedTarget == null) {
                        continue;
                    }
                    if ("KHAC".equals(normalizedTarget)) {
                        if (!hasResolvedPrimaryTarget || resolvedAsOther) {
                            matchesTarget = true;
                            break;
                        }
                        continue;
                    }
                    if (hasResolvedPrimaryTarget && normalizedTarget.equals(resolvedTargetCode)) {
                        matchesTarget = true;
                        break;
                    }
                    if (allowFallbackCategoryMatch
                            && matchesTargetSelection(normalizedProductTarget, searchableKeywords, normalizedTarget)) {
                        matchesTarget = true;
                        break;
                    }
                }
            }

            // Filter by price
            if (prices != null && !prices.isEmpty()) {
                matchesPrice = false;
                for (String priceCode : prices) {
                    String normalizedPriceCode = normalizeValue(priceCode);
                    if (normalizedPriceCode != null && PRICE_RANGE_MAP.containsKey(normalizedPriceCode)) {
                        double[] range = PRICE_RANGE_MAP.get(normalizedPriceCode);
                        double min = range[0];
                        double max = range[1];
                        if (product.getPrice() >= min && product.getPrice() <= max) {
                            matchesPrice = true;
                            break;
                        }
                    }
                }
            }

            if (matchesFactory && matchesTarget && matchesPrice) {
                filtered.add(product);
            }
        }

        // Sort products
        if (sort != null && !sort.isEmpty()) {
            String normalizedSort = normalizeValue(sort);
            if ("GIA-TANG-DAN".equals(normalizedSort)) {
                filtered.sort((p1, p2) -> Double.compare(p1.getPrice(), p2.getPrice()));
            } else if ("GIA-GIAM-DAN".equals(normalizedSort)) {
                filtered.sort((p1, p2) -> Double.compare(p2.getPrice(), p1.getPrice()));
            }
        }

        // Load warehouse cho mỗi product
        filtered.forEach(p -> {
            Warehouse warehouse = warehouseService.getWarehouseByProductId(p.getId());
            if (warehouse != null) {
                p.setWarehouse(warehouse);
            }
        });

        return filtered;
    }

}
