<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8" />
                    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
                    <title>${product.name} - FURNITURE STORE</title>
                    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                    <meta content="" name="keywords" />
                    <meta content="" name="description" />

                    <link rel="preconnect" href="https://fonts.googleapis.com" />
                    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                    <link
                        href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap"
                        rel="stylesheet" />

                    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css"
                        rel="stylesheet" />

                    <link href="/client/lib/lightbox/css/lightbox.min.css" rel="stylesheet" />
                    <link href="/client/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet" />
                    <link href="/client/css/bootstrap.min.css" rel="stylesheet" />

                    <link href="/client/css/style.css" rel="stylesheet" />
                    <link href="/client/css/override.css" rel="stylesheet" />
                    <link href="/client/css/effects.css" rel="stylesheet" />
                    <link href="/client/css/order.css" rel="stylesheet" />
                    <link href="/client/css/product_detail.css" rel="stylesheet" />
                    <meta name="_csrf" content="${_csrf.token}" />
                    <meta name="_csrf_header" content="${_csrf.headerName}" />

                    <link href="https://cdnjs.cloudflare.com/ajax/libs/jquery-toast-plugin/1.3.2/jquery.toast.min.css"
                        rel="stylesheet" />
                </head>

                <body>
                    <!-- Spinner Start -->
                    <div id="spinner"
                        class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50 d-flex align-items-center justify-content-center">
                        <div class="spinner-grow text-primary" role="status"></div>
                    </div>
                    <!-- Spinner End -->
                    <jsp:include page="../layout/header.jsp" />
                    <div class="container-fluid py-5 mt-5">
                        <div class="container py-5">
                            <div class="row g-4 mb-5">
                                <div>
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item"><a href="/">Home</a></li>
                                            <li class="breadcrumb-item active" aria-current="page">
                                                Chi Tiết Sản Phẩm
                                            </li>
                                        </ol>
                                    </nav>
                                </div>
                                <div class="col-lg-9 col-xl-9">
                                    <div class="row g-4">
                                        <div class="col-lg-6">
                                            <div class="product-media-gallery fade-up" data-autoplay="true"
                                                data-interval="2000">
                                                <button class="gallery-nav gallery-nav--prev" type="button"
                                                    aria-label="Xem nội dung trước">
                                                    <i class="fa fa-chevron-left"></i>
                                                </button>
                                                <div class="product-media-viewer">
                                                    <img src="/images/product/${product.image}"
                                                        class="product-media-viewer__image" alt="${product.name}" />
                                                    <video class="product-media-viewer__video" muted playsinline loop
                                                        controls></video>
                                                </div>
                                                <button class="gallery-nav gallery-nav--next" type="button"
                                                    aria-label="Xem nội dung kế tiếp">
                                                    <i class="fa fa-chevron-right"></i>
                                                </button>
                                                <div class="product-media-thumbs">
                                                    <c:choose>
                                                        <c:when test="${not empty product.medias}">
                                                            <c:forEach var="media" items="${product.medias}"
                                                                varStatus="status">
                                                                <button
                                                                    class="media-thumb ${status.first ? 'active' : ''}"
                                                                    type="button" data-media-type="${media.mediaType}"
                                                                    data-media-src="/images/product/${media.fileName}"
                                                                    aria-label="${media.mediaType.name() == 'VIDEO' ? 'Video' : 'Ảnh'}">
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${media.mediaType.name() == 'VIDEO'}">
                                                                            <span class="media-thumb__video-icon">
                                                                                <i class="fa fa-play"></i>
                                                                            </span>
                                                                            <small>Video demo</small>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <img src="/images/product/${media.fileName}"
                                                                                alt="${product.name} gallery thumbnail" />
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </button>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="media-thumb active" type="button"
                                                                data-media-type="image"
                                                                data-media-src="/images/product/${product.image}"
                                                                aria-label="Ảnh chính">
                                                                <img src="/images/product/${product.image}"
                                                                    alt="${product.name} gallery thumbnail" />
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                            </div>
                                        </div>
                                        <div class="col-lg-6">
                                            <h4 class="fw-bold mb-3">${product.name}</h4>
                                            <p class="mb-3">${product.factory}</p>
                                            <h5 class="fw-bold mb-3">
                                                <fmt:formatNumber type="number" value="${product.price}" /> đ
                                            </h5>
                                            <div class="d-flex mb-4">
                                                <i class="fa fa-star text-secondary"></i>
                                                <i class="fa fa-star text-secondary"></i>
                                                <i class="fa fa-star text-secondary"></i>
                                                <i class="fa fa-star text-secondary"></i>
                                                <i class="fa fa-star"></i>
                                            </div>
                                            <p class="mb-4">${product.shortDesc}</p>

                                            <c:set var="redirectBase" value="/product/${product.id}" />
                                            <c:if test="${not empty pageContext.request.requestURI}">
                                                <c:set var="redirectBase" value="${pageContext.request.requestURI}" />
                                            </c:if>
                                            <c:if test="${not empty requestScope['javax.servlet.forward.request_uri']}">
                                                <c:set var="redirectBase"
                                                    value="${requestScope['javax.servlet.forward.request_uri']}" />
                                            </c:if>
                                            <c:set var="redirectQuery" value="" />
                                            <c:if test="${not empty pageContext.request.queryString}">
                                                <c:set var="redirectQuery" value="${pageContext.request.queryString}" />
                                            </c:if>
                                            <c:if
                                                test="${not empty requestScope['javax.servlet.forward.query_string']}">
                                                <c:set var="redirectQuery"
                                                    value="${requestScope['javax.servlet.forward.query_string']}" />
                                            </c:if>
                                            <c:set var="resolvedRedirectUrl" value="${redirectBase}" />
                                            <c:if test="${not empty redirectQuery}">
                                                <c:set var="resolvedRedirectUrl"
                                                    value="${redirectBase}?${redirectQuery}" />
                                            </c:if>

                                            <form action="/add-product-to-cart/${product.id}" method="post"
                                                class="product-detail-cart-form d-flex flex-column align-items-start">
                                                <div class="input-group quantity mb-4" style="width: 120px">
                                                    <div class="input-group-btn">
                                                        <button type="button"
                                                            class="btn btn-sm btn-minus rounded-circle bg-light border">
                                                            <i class="fa fa-minus"></i>
                                                        </button>
                                                    </div>
                                                    <input type="text"
                                                        class="form-control form-control-sm text-center border-0"
                                                        value="1" data-cart-detail-index="0" inputmode="numeric"
                                                        autocomplete="off" />
                                                    <div class="input-group-btn">
                                                        <button type="button"
                                                            class="btn btn-sm btn-plus rounded-circle bg-light border">
                                                            <i class="fa fa-plus"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <input type="hidden" name="quantity" id="cartDetails0.quantity"
                                                    value="1" />
                                                <input type="hidden" name="redirectUrl"
                                                    value="${resolvedRedirectUrl}" />
                                                <button type="submit" data-product-id="${product.id}"
                                                    class="btnAddToCartDetail btn border border-secondary rounded-pill px-4 py-2 mb-4 text-primary">
                                                    <i class="fa fa-shopping-bag me-2 text-primary"></i>
                                                    Add to cart
                                                </button>
                                            </form>
                                        </div>
                                        <div class="col-lg-12">
                                            <nav>
                                                <div class="nav nav-tabs mb-3">
                                                    <button class="nav-link active border-white border-bottom-0"
                                                        type="button" role="tab" id="nav-about-tab" data-bs-toggle="tab"
                                                        data-bs-target="#nav-about" aria-controls="nav-about"
                                                        aria-selected="true">
                                                        Description
                                                    </button>
                                                </div>
                                            </nav>
                                            <div class="tab-content mb-5">
                                                <div class="tab-pane active" id="nav-about" role="tabpanel"
                                                    aria-labelledby="nav-about-tab">
                                                    <p>${product.detailDesc}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-3 col-xl-3">
                                    <aside class="recommended-sidebar fade-up mt-4 mt-lg-0">
                                        <div class="recommended-sidebar__card">
                                            <p class="recommended-sidebar__tag">
                                                <i class="fa fa-gift"></i>
                                                Ưu đãi độc quyền
                                            </p>
                                            <ul class="recommended-sidebar__list">
                                                <li>Voucher 50K cho đơn từ 499K</li>
                                                <li>Freeship nội thành trong 24h</li>
                                                <li>Giảm thêm 5% khi mua combo</li>
                                            </ul>
                                            <button class="recommended-sidebar__btn">Lấy mã ưu đãi</button>
                                        </div>
                                        <div class="recommended-sidebar__card">
                                            <p class="recommended-sidebar__title">
                                                <i class="fa fa-store"></i>
                                                Thông tin shop
                                            </p>
                                            <div class="recommended-sidebar__meta">
                                                <span>
                                                    Nhà cung cấp:
                                                    <b>
                                                        <c:out
                                                            value="${empty product.factory ? 'FURNITURE STORE' : product.factory}" />
                                                    </b>
                                                </span>
                                                <span>Đã bán: ${product.sold}+</span>
                                                <span>Đánh giá: 4.9/5 (1.2k+ lượt)</span>
                                            </div>
                                            <div class="recommended-sidebar__policies">
                                                <span><i class="fa fa-shield-alt"></i> Bảo hành 12 tháng</span>
                                                <span><i class="fa fa-undo"></i> Đổi trả trong 7 ngày</span>
                                                <span><i class="fa fa-headset"></i> Tư vấn 24/7</span>
                                            </div>
                                        </div>
                                        <div class="recommended-sidebar__card recommended-sidebar__card--highlight">
                                            <p>Liên hệ ngay để được tư vấn miễn phí:</p>
                                            <a href="tel:0123456789" class="recommended-sidebar__hotline">
                                                <i class="fa fa-phone"></i>
                                                0123 456 789
                                            </a>
                                            <small>Hoặc chat với shop để nhận báo giá nhanh.</small>
                                        </div>
                                    </aside>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-12">
                                    <div class="recommended-products fade-up mt-4 mt-lg-5">
                                        <div class="recommended-products__header">
                                            <p class="recommended-products__eyebrow">
                                                Sản phẩm khác của shop
                                            </p>
                                            <div class="recommended-products__title">
                                                <h4>Gợi ý dành riêng cho bạn</h4>
                                                <span>Chia sẻ vài món cùng danh mục/giá</span>
                                            </div>
                                        </div>
                                        <c:choose>
                                            <c:when test="${not empty recommendations}">
                                                <div class="recommended-grid">
                                                    <c:forEach var="item" items="${recommendations}">
                                                        <a class="recommended-card" href="/product/${item.id}"
                                                            aria-label="${item.name}">
                                                            <div class="recommended-card__media">
                                                                <img src="/images/product/${item.image}"
                                                                    alt="${item.name}" />
                                                                <span class="recommended-card__tag">Gợi ý</span>
                                                                <span class="recommended-card__rating">
                                                                    <i class="fa fa-star"></i>
                                                                    4.9
                                                                </span>
                                                            </div>
                                                            <div class="recommended-card__body">
                                                                <p class="recommended-card__name">${item.name}</p>
                                                                <p class="recommended-card__factory">
                                                                    ${item.factory}
                                                                </p>
                                                                <p class="recommended-card__price">
                                                                    <fmt:formatNumber type="number"
                                                                        value="${item.price}" />
                                                                    đ
                                                                </p>
                                                                <div class="recommended-card__meta">
                                                                    <span>Đã bán ${item.sold}+ </span>
                                                                    <span class="dot"></span>
                                                                    <span>
                                                                        <c:out
                                                                            value="${empty item.target ? 'Sản phẩm hot' : item.target}" />
                                                                    </span>
                                                                </div>
                                                            </div>
                                                        </a>
                                                    </c:forEach>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="recommended-empty">
                                                    <i class="fa fa-store"></i>
                                                    <p>Shop đang chuẩn bị thêm gợi ý cho sản phẩm này.</p>
                                                    <span>Quay lại sau để xem thêm nhé!</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

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
                    <script src="/client/js/product_detail.js"></script>

                    <script
                        src="https://cdnjs.cloudflare.com/ajax/libs/jquery-toast-plugin/1.3.2/jquery.toast.min.js"></script>
                </body>

                </html>