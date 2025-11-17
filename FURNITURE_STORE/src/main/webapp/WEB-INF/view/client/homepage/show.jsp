<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Trang chủ - FURNITURE STORE</title>
                    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
                    <link rel="preconnect" href="https://fonts.googleapis.com">
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                    <link
                        href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <link href="/client/lib/lightbox/css/lightbox.min.css" rel="stylesheet">
                    <link href="/client/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
                    <link href="/client/css/bootstrap.min.css" rel="stylesheet">
                    <link href="/client/css/style.css" rel="stylesheet">
                    <link href="/client/css/override.css" rel="stylesheet">
                    <link href="/client/css/effects.css" rel="stylesheet">
                    <meta name="_csrf" content="${_csrf.token}" />
                    <meta name="_csrf_header" content="${_csrf.headerName}" />
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/jquery-toast-plugin/1.3.2/jquery.toast.min.css"
                        rel="stylesheet">
                </head>

                <body>

                    <!-- Spinner Start -->
                    <div id="spinner"
                        class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50 d-flex align-items-center justify-content-center">
                        <div class="spinner-grow text-primary" role="status"></div>
                    </div>
                    <!-- Spinner End -->

                    <jsp:include page="../layout/header.jsp" />

                    <jsp:include page="../layout/banner.jsp" />

                    <section class="container home-metrics translate-up-sm">
                        <div class="row g-4">
                            <div class="col-6 col-lg-3">
                                <div class="metric-card">
                                    <p class="metric-label">Năm chế tác</p>
                                    <p class="metric-value">12+</p>
                                    <p class="metric-copy mb-0">Xưởng trên khắp Việt Nam</p>
                                </div>
                            </div>
                            <div class="col-6 col-lg-3">
                                <div class="metric-card">
                                    <p class="metric-label">Thiết kế theo yêu cầu</p>
                                    <p class="metric-value">340+</p>
                                    <p class="metric-copy mb-0">Hoàn thiện thủ công mỗi tuần</p>
                                </div>
                            </div>
                            <div class="col-6 col-lg-3">
                                <div class="metric-card">
                                    <p class="metric-label">Gia đình hài lòng</p>
                                    <p class="metric-value">9k</p>
                                    <p class="metric-copy mb-0">Đánh giá trung bình 4.9/5</p>
                                </div>
                            </div>
                            <div class="col-6 col-lg-3">
                                <div class="metric-card">
                                    <p class="metric-label">Vật liệu xanh</p>
                                    <p class="metric-value">72%</p>
                                    <p class="metric-copy mb-0">Gỗ đạt chứng chỉ bền vững</p>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section class="container-fluid signature-collections py-5">
                        <div class="container py-5">
                            <div class="row align-items-center g-4 mb-4">
                                <div class="col-lg-8 text-lg-start text-center">
                                    <p class="eyebrow text-uppercase text-white-50 mb-2">Bộ sưu tập đặc trưng</p>
                                    <h2 class="text-white mb-0">Tinh tuyển cảm hứng từ lối sống hiện đại</h2>
                                </div>
                                <div class="col-lg-4 text-lg-end text-center">
                                    <a class="btn btn-outline-light rounded-pill px-4" href="/products">Xem danh mục</a>
                                </div>
                            </div>
                            <div class="row g-4">
                                <div class="col-md-6 col-lg-4">
                                    <a class="collection-card collection-card--living" href="/products">
                                        <div class="collection-card__body">
                                            <span class="collection-chip">Phòng khách</span>
                                            <h3>Đường nét mềm mại &amp; ánh sáng ấm</h3>
                                            <p>Sofa dáng thấp, bàn trà module, chất liệu trung tính.</p>
                                            <span class="collection-link">Khám phá ngay</span>
                                        </div>
                                    </a>
                                </div>
                                <div class="col-md-6 col-lg-4">
                                    <a class="collection-card collection-card--bedroom" href="/products">
                                        <div class="collection-card__body">
                                            <span class="collection-chip">Phòng ngủ</span>
                                            <h3>Sắc trung tính cho buổi sáng chậm rãi</h3>
                                            <p>Giường bọc nệm, tab đầu giường có ổ điện, đèn ngủ dịu.</p>
                                            <span class="collection-link">Tăng thêm ấm cúng</span>
                                        </div>
                                    </a>
                                </div>
                                <div class="col-md-6 col-lg-4">
                                    <a class="collection-card collection-card--workspace" href="/products">
                                        <div class="collection-card__body">
                                            <span class="collection-chip">Góc làm việc</span>
                                            <h3>Bàn nổi bật &amp; lưu trữ thông minh</h3>
                                            <p>Kệ treo tường, bàn không dây, ghế công thái học thoáng khí.</p>
                                            <span class="collection-link">Thiết kế góc làm việc</span>
                                        </div>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section class="container home-story py-5">
                        <div class="row g-4 align-items-stretch">
                            <div class="col-lg-6 d-flex">
                                <div class="story-media w-100">
                                    <span class="story-label">Bảng cảm hứng trong tuần</span>
                                    <h3>Gỗ sồi tự nhiên, vải xanh sage và điểm nhấn đồng.</h3>
                                    <p>Chúng tôi kết hợp đường nét vượt thời gian với bề mặt chạm tay để mỗi căn phòng
                                        đều tinh gọn mà vẫn
                                        ấm áp.</p>
                                </div>
                            </div>
                            <div class="col-lg-6 d-flex">
                                <div class="story-panel w-100">
                                    <p class="eyebrow text-uppercase mb-2 text-accent-orange">Tâm điểm trong tuần</p>
                                    <h3 class="mb-4 text-accent-green">Sản phẩm được yêu thích nhất</h3>
                                    <c:choose>
                                        <c:when test="${not empty products}">
                                            <c:forEach var="product" items="${products}" varStatus="status">
                                                <c:if test="${status.index lt 3}">
                                                    <a class="spotlight-product"
                                                        href="/images/product/${product.id}/${product.image}">
                                                        <div class="spotlight-index">0${status.count}</div>
                                                        <div class="spotlight-copy">
                                                            <p class="spotlight-name mb-1">${product.name}</p>
                                                            <p class="spotlight-desc mb-0">${product.shortDesc}</p>
                                                        </div>
                                                        <div class="spotlight-price text-end">
                                                            <fmt:formatNumber type="number" value="${product.price}" />
                                                            &#8363;
                                                        </div>
                                                    </a>
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted mb-0">Danh mục đang được cập nhật. Vui lòng quay lại
                                                sau ít phút.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </section>

                    <div class="container-fluid fruite py-5 home-showcase">
                        <div class="container py-5">
                            <div class="tab-class text-center">
                                <div class="row g-4 align-items-center mb-4">
                                    <div class="col-lg-7 text-lg-start text-center">
                                        <p class="eyebrow text-uppercase text-secondary mb-2">Hàng mới</p>
                                        <h1 class="mb-3 headlined">Thiết kế nổi bật cho sinh hoạt hằng ngày</h1>
                                        <p class="text-muted mb-0">Vân gỗ ấm, đệm mây mềm, giải pháp lưu trữ gọn gàng.
                                            Mỗi sản phẩm đều được
                                            chọn lọc cho căn hộ nhỏ lẫn biệt thự rộng.</p>
                                    </div>
                                    <div class="col-lg-5">
                                        <div
                                            class="home-product-actions d-flex flex-wrap justify-content-lg-end justify-content-center gap-3">
                                            <a class="btn btn-outline-secondary rounded-pill px-4" href="/products">Xem
                                                tất cả</a>
                                            <a class="btn btn-primary rounded-pill px-4" href="/products?page=1">Xem
                                                hàng mới</a>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-content">
                                    <div id="tab-1" class="tab-pane fade show p-0 active">
                                        <div class="row g-4">
                                            <div class="col-lg-12">
                                                <div class="row g-4">
                                                    <c:forEach var="product" items="${products}">
                                                        <div class="col-md-6 col-lg-4 col-xl-3">
                                                            <div class="rounded position-relative fruite-item">
                                                                <div class="fruite-img">
                                                                    <img src="/images/product/${product.image}"
                                                                        class="img-fluid w-100 rounded-top"
                                                                        alt="${product.name}">
                                                                </div>
                                                                <div class="product-pill">
                                                                    <span class="badge bg-white text-dark shadow-sm">Sẵn
                                                                        sàng giao</span>
                                                                </div>
                                                                <div
                                                                    class="p-4 border border-secondary border-top-0 rounded-bottom">
                                                                    <h4 class="mb-2">
                                                                        <a
                                                                            href="/product/${product.id}">${product.name}</a>
                                                                    </h4>
                                                                    <p class="home-product-desc mb-3">
                                                                        ${product.shortDesc}</p>
                                                                    <p class="product-meta mb-4">Gỗ bền vững · Sơn chống
                                                                        dị ứng · Bảo hành khung 5 năm</p>
                                                                    <div
                                                                        class="d-flex flex-column flex-xl-row align-items-center gap-3 product-cta-row">
                                                                        <p class="text-dark fw-bold mb-0 display-price">
                                                                            <fmt:formatNumber type="number"
                                                                                value="${product.price}" />&#8363;
                                                                        </p>
                                                                        <form
                                                                            action="/add-product-to-cart/${product.id}"
                                                                            method="post"
                                                                            class="flex-grow-1 product-card-form">
                                                                            <input type="hidden"
                                                                                name="${_csrf.parameterName}"
                                                                                value="${_csrf.token}" />
                                                                            <button
                                                                                class="w-100 btn border border-secondary rounded-pill px-3 text-primary product-card-btn">
                                                                                <i
                                                                                    class="fa fa-shopping-bag me-2 text-primary"></i>
                                                                                Thêm vào giỏ
                                                                            </button>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <section class="container home-journal py-5">
                        <div class="row g-4 align-items-center mb-4">
                            <div class="col-lg-8 text-lg-start text-center">
                                <p class="eyebrow text-uppercase text-secondary mb-2">Nhật ký thiết kế</p>
                                <h2 class="mb-0">Ý tưởng phối chất liệu, ánh sáng và cảm xúc</h2>
                            </div>
                            <div class="col-lg-4 text-lg-end text-center">
                                <a class="btn btn-outline-dark rounded-pill px-4" href="/products">Xem moodboard</a>
                            </div>
                        </div>
                        <div class="row g-4">
                            <div class="col-md-6 col-lg-4">
                                <article class="journal-card">
                                    <div class="journal-media">
                                        <img src="https://images.unsplash.com/photo-1505691938895-1758d7feb511?auto=format&amp;fit=crop&amp;w=900&amp;q=80"
                                            alt="Layering lighting" loading="lazy">
                                    </div>
                                    <div class="journal-body">
                                        <p class="journal-tag">Chiếu sáng</p>
                                        <h4>Phối nhiều lớp ánh sáng cho phòng đa năng</h4>
                                        <p>Kết hợp đèn đứng dạng vòng với dải LED ẩn để không gian làm việc vẫn dịu mắt.
                                        </p>
                                        <a class="journal-link" href="/products">Mua theo gợi ý</a>
                                    </div>
                                </article>
                            </div>
                            <div class="col-md-6 col-lg-4">
                                <article class="journal-card">
                                    <div class="journal-media">
                                        <img src="https://images.unsplash.com/photo-1524758870432-af57e54afa26?auto=format&amp;fit=crop&amp;w=900&amp;q=80"
                                            alt="Natural palette bedroom" loading="lazy">
                                    </div>
                                    <div class="journal-body">
                                        <p class="journal-tag">Phòng ngủ</p>
                                        <h4>Tạo bảng màu dịu với ba sắc độ</h4>
                                        <p>Bắt đầu bằng nền sáng, thêm chất liệu trung tính và hoàn thiện bằng một điểm
                                            gỗ đậm.</p>
                                        <a class="journal-link" href="/products">Thử phối màu</a>
                                    </div>
                                </article>
                            </div>
                            <div class="col-md-6 col-lg-4">
                                <article class="journal-card">
                                    <div class="journal-media">
                                        <img src="https://images.unsplash.com/photo-1484101403633-562f891dc89a?auto=format&amp;fit=crop&amp;w=900&amp;q=80"
                                            alt="Workspace inspiration" loading="lazy">
                                    </div>
                                    <div class="journal-body">
                                        <p class="journal-tag">Góc làm việc</p>
                                        <h4>Thiết kế khu làm việc hybrid</h4>
                                        <p>Khây giấu dây, ghế thoáng khí và kệ module giúp bàn gọn gàng khi họp online.
                                        </p>
                                        <a class="journal-link" href="/products">Xem gợi ý</a>
                                    </div>
                                </article>
                            </div>
                        </div>
                    </section>

                    <section class="container-fluid testimonial home-testimonial py-5 bg-light">
                        <div class="container py-5">
                            <div class="row g-4 align-items-center mb-4">
                                <div class="col-12 text-lg-start text-center">
                                    <p class="eyebrow text-uppercase text-secondary mb-2">Khách hàng chia sẻ</p>
                                    <h2 class="mb-0">Được tin dùng bởi gia đình yêu thẩm mỹ</h2>
                                </div>
                            </div>
                            <div class="testimonial-carousel owl-carousel">
                                <div class="testimonial-card bg-white p-4 h-100">
                                    <p class="testimonial-quote mb-4">“Tủ module giấu gọn toàn bộ đồ chơi mà vẫn thanh
                                        thoát. Lắp đặt chưa tới
                                        20 phút.”</p>
                                    <div class="testimonial-author d-flex align-items-center gap-3">
                                        <div class="author-ring">LT</div>
                                        <div>
                                            <h6 class="mb-0">Lan Trần</h6>
                                            <small class="text-muted">TP. Hồ Chí Minh</small>
                                        </div>
                                    </div>
                                </div>
                                <div class="testimonial-card bg-white p-4 h-100">
                                    <p class="testimonial-quote mb-4">“Đặt dịch vụ styling, đội ngũ gửi bản dựng 3D cho
                                        cả căn hộ trong 48 giờ -
                                        quá ấn tượng.”</p>
                                    <div class="testimonial-author d-flex align-items-center gap-3">
                                        <div class="author-ring">QB</div>
                                        <div>
                                            <h6 class="mb-0">Quang Bùi</h6>
                                            <small class="text-muted">Hà Nội</small>
                                        </div>
                                    </div>
                                </div>
                                <div class="testimonial-card bg-white p-4 h-100">
                                    <p class="testimonial-quote mb-4">“Sofa giống hệt hình chụp, đệm mềm nhưng vẫn đủ
                                        cứng để làm việc thoải mái
                                        cả ngày.”</p>
                                    <div class="testimonial-author d-flex align-items-center gap-3">
                                        <div class="author-ring">MN</div>
                                        <div>
                                            <h6 class="mb-0">Minh Nguyễn</h6>
                                            <small class="text-muted">Đà Nẵng</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <section class="container-fluid home-cta py-5">
                        <div class="container py-5">
                            <div class="cta-card">
                                <div class="cta-copy">
                                    <p class="eyebrow text-uppercase mb-2 text-secondary">Cần góp ý phối đồ?</p>
                                    <h2>Đặt lịch tư vấn bố trí miễn phí với stylist của chúng tôi.</h2>
                                    <p class="mb-0 text-muted">Gửi kích thước phòng và bảng moodboard - chúng tôi phản
                                        hồi bản thiết kế mua
                                        sắm trong 48 giờ.</p>
                                </div>
                                <div class="cta-actions">
                                    <a class="btn btn-outline-secondary rounded-pill px-4" href="/products">Xem gói
                                        combo</a>
                                    <a class="btn btn-primary rounded-pill px-4" href="mailto:hello@furniture.store">Lên
                                        kế hoạch cho tôi</a>
                                </div>
                            </div>
                        </div>
                    </section>

                    <jsp:include page="../layout/feature.jsp" />
                    <jsp:include page="../layout/footer.jsp" />

                    <a href="#" class="btn btn-primary border-3 border-primary rounded-circle back-to-top"><i
                            class="fa fa-arrow-up"></i></a>

                    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script src="/client/lib/easing/easing.min.js"></script>
                    <script src="/client/lib/waypoints/waypoints.min.js"></script>
                    <script src="/client/lib/lightbox/js/lightbox.min.js"></script>
                    <script src="/client/lib/owlcarousel/owl.carousel.min.js"></script>
                    <script src="/client/js/main.js"></script>
                    <script src="/client/js/effects.js"></script>
                    <script src="/client/js/cart_common.js"></script>
                    <script src="/client/js/cart_fly.js"></script>
                    <script
                        src="https://cdnjs.cloudflare.com/ajax/libs/jquery-toast-plugin/1.3.2/jquery.toast.min.js"></script>

                    <!-- Toast Container - Đặt ở góc dưới bên phải -->
                    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 100001;">
                        <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true"
                            style="z-index: 100002;">
                            <div class="toast-header bg-success text-white">
                                <i class="fas fa-check-circle me-2"></i>
                                <strong class="me-auto">Thành công</strong>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"
                                    aria-label="Close"></button>
                            </div>
                            <div class="toast-body">
                                Đã thêm sản phẩm vào giỏ hàng thành công!
                            </div>
                        </div>
                    </div>

                    <script>
                        // Hàm hiển thị toast thông báo thành công
                        function showSuccessToast() {
                            const toastElement = document.getElementById('successToast');
                            if (!toastElement) {
                                console.error('Toast element not found');
                                // Fallback: sử dụng alert nếu toast không tìm thấy
                                alert('Đã thêm sản phẩm vào giỏ hàng thành công!');
                                return;
                            }

                            try {
                                // Kiểm tra xem Bootstrap Toast có sẵn không
                                if (typeof bootstrap !== 'undefined' && bootstrap.Toast) {
                                    const toast = new bootstrap.Toast(toastElement, {
                                        autohide: true,
                                        delay: 3000
                                    });
                                    toast.show();
                                } else {
                                    // Fallback: hiển thị toast bằng cách thêm class show
                                    toastElement.classList.add('show');
                                    setTimeout(() => {
                                        toastElement.classList.remove('show');
                                    }, 3000);
                                }
                            } catch (error) {
                                console.error('Error showing toast:', error);
                                // Fallback: sử dụng alert
                                alert('Đã thêm sản phẩm vào giỏ hàng thành công!');
                            }
                        }

                        // Hàm cập nhật số lượng sản phẩm trong header
                        function updateCartCount(newCount) {
                            const cartCountElements = document.querySelectorAll('[data-cart-count]');
                            cartCountElements.forEach(el => {
                                el.textContent = newCount;
                            });
                        }

                        // Hàm xử lý form submit bằng AJAX
                        function setupAddToCartForm(form) {
                            form.addEventListener('submit', function (e) {
                                e.preventDefault();

                                const formAction = form.getAttribute('action');
                                if (!formAction) {
                                    console.error('Form action not found');
                                    alert('Có lỗi xảy ra. Vui lòng thử lại!');
                                    return;
                                }

                                const productIdMatch = formAction.match(/\/add-product-to-cart\/(\d+)/);
                                if (!productIdMatch || !productIdMatch[1]) {
                                    console.error('Product ID not found in form action:', formAction);
                                    alert('Có lỗi xảy ra. Không tìm thấy ID sản phẩm!');
                                    return;
                                }

                                const productId = productIdMatch[1];

                                // Disable button để tránh double click
                                const submitButton = form.querySelector('button[type="submit"]');
                                if (!submitButton) {
                                    console.error('Submit button not found');
                                    return;
                                }

                                const originalText = submitButton.innerHTML;

                                // Lấy CSRF token và header name từ meta tags (ưu tiên) hoặc form input
                                const csrfMeta = document.querySelector('meta[name="_csrf"]');
                                const csrfInput = form.querySelector('input[type="hidden"][name*="_csrf"]');
                                const csrfToken = csrfMeta ? csrfMeta.content : (csrfInput ? csrfInput.value : '');

                                if (!csrfToken) {
                                    console.error('CSRF token not found');
                                    alert('Có lỗi xảy ra. Vui lòng tải lại trang và thử lại!');
                                    submitButton.disabled = false;
                                    submitButton.innerHTML = originalText;
                                    return;
                                }

                                const csrfHeaderName = document.querySelector('meta[name="_csrf_header"]')?.content || 'X-CSRF-TOKEN';
                                submitButton.disabled = true;
                                submitButton.innerHTML = '<i class="fa fa-spinner fa-spin me-2"></i>Đang thêm...';

                                // Gọi API
                                const headers = {
                                    'Content-Type': 'application/json',
                                    'X-Requested-With': 'XMLHttpRequest'
                                };
                                headers[csrfHeaderName] = csrfToken;

                                fetch('/api/add-product-to-cart', {
                                    method: 'POST',
                                    headers: headers,
                                    body: JSON.stringify({
                                        productId: parseInt(productId),
                                        quantity: 1
                                    })
                                })
                                    .then(response => {
                                        console.log('Response status:', response.status);

                                        if (!response.ok) {
                                            return response.text().then(text => {
                                                throw new Error(`HTTP ${response.status}: ${text || 'Unknown error'}`);
                                            });
                                        }
                                        return response.json();
                                    })
                                    .then(data => {
                                        // Hiển thị thông báo thành công
                                        showSuccessToast();

                                        // Cập nhật số lượng trong giỏ hàng
                                        updateCartCount(data);

                                        // Restore button
                                        submitButton.disabled = false;
                                        submitButton.innerHTML = originalText;
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);

                                        // Hiển thị thông báo lỗi
                                        let errorMessage = 'Có lỗi xảy ra khi thêm sản phẩm vào giỏ hàng. Vui lòng thử lại!';

                                        if (error.message.includes('401')) {
                                            errorMessage = 'Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng!';
                                        } else if (error.message.includes('403')) {
                                            errorMessage = 'Bạn không có quyền thực hiện thao tác này!';
                                        }

                                        alert(errorMessage);

                                        // Restore button
                                        submitButton.disabled = false;
                                        submitButton.innerHTML = originalText;
                                    });
                            });
                        }

                        // Ẩn spinner ngay lập tức khi script chạy (trước DOMContentLoaded)
                        (function () {
                            const spinner = document.getElementById('spinner');
                            if (spinner) {
                                spinner.classList.remove('show');
                                spinner.style.pointerEvents = 'none';
                                spinner.style.opacity = '0';
                                spinner.style.visibility = 'hidden';
                            }
                        })();

                        // Xử lý form submit bằng AJAX khi trang load
                        document.addEventListener('DOMContentLoaded', function () {
                            // Đảm bảo spinner được ẩn ngay lập tức
                            const spinner = document.getElementById('spinner');
                            if (spinner) {
                                spinner.classList.remove('show');
                                spinner.style.pointerEvents = 'none';
                                spinner.style.opacity = '0';
                                spinner.style.visibility = 'hidden';
                            }

                            // Đảm bảo các link trong header có thể click được
                            const cartLink = document.querySelector('a[href="/cart"]');
                            const userLink = document.querySelector('#dropdownMenuLink, a[href="#"]');
                            if (cartLink) {
                                cartLink.style.pointerEvents = 'auto';
                                cartLink.style.cursor = 'pointer';
                                cartLink.style.zIndex = '1000';
                            }
                            if (userLink) {
                                userLink.style.pointerEvents = 'auto';
                                userLink.style.cursor = 'pointer';
                                userLink.style.zIndex = '1000';
                            }

                            // Xử lý tất cả form "Add to cart" có sẵn trong trang
                            document.querySelectorAll('form.add-to-cart-form').forEach(form => {
                                setupAddToCartForm(form);
                            });
                        });

                        // Ẩn spinner ngay khi window load xong (fallback)
                        window.addEventListener('load', function () {
                            const spinner = document.getElementById('spinner');
                            if (spinner) {
                                spinner.classList.remove('show');
                                spinner.style.pointerEvents = 'none';
                                spinner.style.opacity = '0';
                                spinner.style.visibility = 'hidden';
                            }

                            // Đảm bảo các link trong header có thể click được
                            const cartLink = document.querySelector('a[href="/cart"]');
                            const userLink = document.querySelector('#dropdownMenuLink, a[href="#"]');
                            if (cartLink) {
                                cartLink.style.pointerEvents = 'auto';
                                cartLink.style.cursor = 'pointer';
                                cartLink.style.zIndex = '1000';
                            }
                            if (userLink) {
                                userLink.style.pointerEvents = 'auto';
                                userLink.style.cursor = 'pointer';
                                userLink.style.zIndex = '1000';
                            }
                        });
                    </script>
                </body>

                </html>
