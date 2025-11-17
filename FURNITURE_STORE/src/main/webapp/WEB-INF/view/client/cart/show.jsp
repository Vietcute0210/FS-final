<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
                <fmt:setLocale value="vi_VN" />

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8">
                    <title>Giỏ Hàng - FURNITURE STORE</title>
                    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
                    <meta content="width=device-width, initial-scale=1.0" name="viewport">
                    <meta content="" name="keywords">
                    <meta content="" name="description">
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
                    <link href="/client/css/order.css" rel="stylesheet">
                    <meta name="_csrf" content="${_csrf.token}" />
                    <meta name="_csrf_header" content="${_csrf.headerName}" />
                    <link href="https://cdnjs.cloudflare.com/ajax/libs/jquery-toast-plugin/1.3.2/jquery.toast.min.css"
                        rel="stylesheet">
                </head>

                <body>
                    <!-- Spinner Start -->
                    <div id="spinner"
                        class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50  d-flex align-items-center justify-content-center">
                        <div class="spinner-grow text-primary" role="status"></div>
                    </div>
                    <!-- Spinner End -->
                    <jsp:include page="../layout/header.jsp" />
                    <div class="container-fluid py-5 cart-page-wrapper">
                        <div class="container py-5 cart-page">
                            <div class="cart-hero">
                                <div>
                                    <p class="cart-hero__eyebrow">Giỏ hàng của bạn</p>
                                    <h1 class="cart-hero__title">Chi tiết giỏ hàng</h1>
                                    <p class="cart-hero__subtitle">
                                        Kiểm tra lại sản phẩm và số lượng trước khi tiến hành thanh toán.
                                    </p>
                                </div>
                                <nav aria-label="breadcrumb" class="cart-hero__breadcrumb">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item">
                                            <a href="/">
                                                Home
                                            </a>
                                        </li>
                                        <li class="breadcrumb-item active" aria-current="page">
                                            Chi tiết giỏ hàng
                                        </li>
                                    </ol>
                                </nav>
                            </div>
                            <div class="table-responsive cart-table-card">
                                <table class="table align-middle">
                                    <thead>
                                        <tr>
                                            <th scope="col" class="cart-select-column">
                                                <input type="checkbox" class="form-check-input" id="cartSelectAll"
                                                    data-cart-select-all aria-label="Chọn tất cả" />
                                            </th>
                                            <th scope="col">Sản phẩm</th>
                                            <th scope="col">Tên</th>
                                            <th scope="col">Giá cả</th>
                                            <th scope="col">Số lượng</th>
                                            <th scope="col">Thành tiền</th>
                                            <th scope="col">Xử lý</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:if test="${empty cartDetails}">
                                            <tr>
                                                <td colspan="7">
                                                    Không có sản phẩm trong giỏ hàng
                                                </td>
                                            </tr>
                                        </c:if>
                                        <c:forEach var="cartDetail" items="${cartDetails}" varStatus="status">
                                            <tr class="cart-row" data-cart-row-id="${cartDetail.id}">
                                                <td class="cart-select-cell">
                                                    <input type="checkbox" class="form-check-input" data-cart-select
                                                        data-cart-detail-id="${cartDetail.id}" value="${cartDetail.id}"
                                                        aria-label="Chọn sản phẩm" />
                                                </td>
                                                <th scope="row">
                                                    <div class="d-flex align-items-center">
                                                        <img src="/images/product/${cartDetail.product.image}"
                                                            class="img-fluid me-5 rounded-circle"
                                                            style="width: 80px; height: 80px;" alt="">
                                                    </div>
                                                </th>
                                                <td>
                                                    <p class="mb-0 mt-4">
                                                        <a href="/product/${cartDetail.product.id}" target="_blank">
                                                            ${cartDetail.product.name}
                                                        </a>
                                                    </p>
                                                </td>
                                                <td>
                                                    <p class="mb-0 mt-4">
                                                        <fmt:formatNumber type="number" value="${cartDetail.price}" />đ
                                                    </p>
                                                </td>
                                                <td>
                                                    <div class="input-group quantity mt-4" style="width: 100px;">
                                                        <div class="input-group-btn">
                                                            <button
                                                                class="btn btn-sm btn-minus rounded-circle bg-light border">
                                                                <i class="fa fa-minus"></i>
                                                            </button>
                                                        </div>
                                                        <input type="text"
                                                            class="form-control form-control-sm text-center border-0"
                                                            value="${cartDetail.quantity}"
                                                            data-cart-detail-id="${cartDetail.id}"
                                                            data-cart-detail-price="${cartDetail.price}"
                                                            data-cart-detail-index="${status.index}" />
                                                        <!-- data-cart-detail-id hay data-cart-detail-price là HTML Attribute , mình đang tự sinh ra 2 thuộc tính
                                                            để mình định danh cái đó và phục vụ cho việc thao tác trong JS
                                                              -->
                                                        <div class="input-group-btn">
                                                            <button
                                                                class="btn btn-sm btn-plus rounded-circle bg-light border">
                                                                <i class="fa fa-plus"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <p class="mb-0 mt-4 cart-price-accent"
                                                        data-cart-detail-id="${cartDetail.id}">
                                                        <fmt:formatNumber type="number"
                                                            value="${cartDetail.price * cartDetail.quantity}" /> đ
                                                    </p>
                                                </td>
                                                <td>
                                                    <!-- Ta dùng spring security , nên bắt buộc trong form phải chèn thêm 1 thẻ input của csrf token cho form như dưới -->

                                                    <!-- Đây là nút xử lý để xóa sản phẩm khỏi giỏ hàng -->
                                                    <form method="post" action="/delete-cart-product/${cartDetail.id}">
                                                        <input type="hidden" name="${_csrf.parameterName}"
                                                            value="${_csrf.token}" />
                                                        <button class="btn btn-md rounded-circle bg-light border mt-4">
                                                            <i class="fa fa-times text-danger"></i>
                                                        </button>
                                                    </form>
                                                    <!--  -->
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <c:if test="${not empty cartDetails}">
                                <div class="mt-5 row g-4 justify-content-start">
                                    <div class="col-12 col-md-8">
                                        <div class="cart-summary-card bg-light rounded">
                                            <div class="p-4">
                                                <h1 class="display-6 mb-4 order-summary-heading">
                                                    Thông Tin Đơn Hàng
                                                </h1>
                                                <div class="d-flex justify-content-between mb-4">
                                                    <h5 class="mb-0 me-4">Tạm tính:</h5>
                                                    <p class="mb-0" data-cart-total-price="${totalPrice}">
                                                        <fmt:formatNumber type="number" value="${totalPrice}" /> đ
                                                    </p>
                                                </div>
                                                <div class="d-flex justify-content-between">
                                                    <h5 class="mb-0 me-4">Phí vận chuyển</h5>
                                                    <div class="">
                                                        <p class="mb-0">0 đ</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div
                                                class="py-4 mb-4 border-top border-bottom d-flex justify-content-between">
                                                <h5 class="mb-0 ps-4 me-4">Tổng số tiền</h5>
                                                <p class="mb-0 pe-4 cart-total-accent"
                                                    data-cart-total-price="${totalPrice}">
                                                    <fmt:formatNumber type="number" value="${totalPrice}" /> đ
                                                </p>
                                            </div>
                                            <form:form action="/order/checkout" method="post" modelAttribute="cart"
                                                id="cartSelectionForm">
                                                <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                                <input type="hidden" name="selectedCartDetailIds"
                                                    id="selectedCartDetailIdsField" />
                                                <div style="display: none;">
                                                    <c:forEach var="cartDetail" items="${cart.cartDetails}"
                                                        varStatus="status">
                                                        <div class="mb-3">
                                                            <div class="form-group">
                                                                <label>Id:</label>
                                                                <form:input class="form-control" type="text"
                                                                    value="${cartDetail.id}"
                                                                    path="cartDetails[${status.index}].id" />
                                                            </div>
                                                            <div class="form-group">
                                                                <label>Quantity:</label>
                                                                <form:input class="form-control" type="text"
                                                                    value="${cartDetail.quantity}"
                                                                    path="cartDetails[${status.index}].quantity" />
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                                <button
                                                    class="btn border-secondary rounded-pill px-4 py-3 text-primary text-uppercase mb-4 ms-4">Xác
                                                    nhận thanh toán
                                                </button>
                                            </form:form>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
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
                    <script src="/client/js/cart.js"></script>

                    <script
                        src="https://cdnjs.cloudflare.com/ajax/libs/jquery-toast-plugin/1.3.2/jquery.toast.min.js"></script>

                </body>

                </html>