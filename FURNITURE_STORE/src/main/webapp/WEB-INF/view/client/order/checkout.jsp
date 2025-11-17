<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
                <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="utf-8">
                    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
                    <title>Thanh toán - Furniture Store</title>
                    <meta content="width=device-width, initial-scale=1.0" name="viewport">

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
                </head>

                <body>
                    <jsp:include page="../layout/header.jsp" />

                    <!-- Checkout -->
                    <div class="container-fluid py-5">
                        <div class="container py-5 checkout-section">
                            <h1 class="mb-4 checkout-page-title">Thanh toán đơn hàng</h1>
                            <c:choose>
                                <c:when test="${not empty error}">
                                    <c:set var="checkoutError" value="${error}" />
                                </c:when>
                                <c:when test="${not empty param.error}">
                                    <c:set var="checkoutError" value="${param.error}" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="checkoutError" value="" />
                                </c:otherwise>
                            </c:choose>
                            
                            <c:set var="checkoutErrorDetails" value="${errorDetails}" />
                            <c:set var="hasErrorDetails" value="false" />
                            <c:if test="${not empty checkoutErrorDetails}">
                                <c:set var="errorDetailsSize" value="${fn:length(checkoutErrorDetails)}" />
                                <c:if test="${errorDetailsSize gt 0}">
                                    <c:set var="hasErrorDetails" value="true" />
                                </c:if>
                            </c:if>
                            
                            <!-- Đảm bảo totalPrice không null (controller đã đảm bảo, nhưng để an toàn) -->
                            <c:if test="${empty totalPrice}">
                                <c:set var="totalPrice" value="0" />
                            </c:if>
                            
                            <!-- Hiển thị error nếu có errorDetails hoặc error message -->
                            <!-- Nếu có errorDetails, hiển thị bảng chi tiết ngay trong JSP (fallback nếu JS không chạy) -->
                            <c:if test="${hasErrorDetails}">
                                <div class="alert alert-danger alert-dismissible fade show mb-4 checkout-alert" role="alert">
                                    <div class="d-flex align-items-center mb-3">
                                        <strong class="me-2"><i class="fas fa-exclamation-triangle me-2"></i>Thông báo:</strong>
                                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                                    </div>
                                    <p class="mb-3">Có một số sản phẩm không đủ số lượng trong kho:</p>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-sm table-hover mb-0">
                                            <thead class="table-light">
                                                <tr>
                                                    <th style="width: 5%;">STT</th>
                                                    <th style="width: 40%;">Tên sản phẩm</th>
                                                    <th style="width: 15%;" class="text-center">Số lượng yêu cầu</th>
                                                    <th style="width: 15%;" class="text-center">Số lượng còn lại</th>
                                                    <th style="width: 25%;" class="text-center">Thông báo</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="errorDetail" items="${checkoutErrorDetails}" varStatus="status">
                                                    <tr>
                                                        <td class="text-center">${status.index + 1}</td>
                                                        <td><strong><c:out value="${errorDetail.productName}" /></strong></td>
                                                        <td class="text-center"><span class="badge bg-warning text-dark">${errorDetail.requestedQuantity}</span></td>
                                                        <td class="text-center"><span class="badge bg-danger">${errorDetail.availableQuantity}</span></td>
                                                        <td class="text-center"><small class="text-danger"><c:out value="${errorDetail.message}" /></small></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </c:if>
                            <!-- Nếu không có errorDetails, chỉ hiển thị error message chung -->
                            <c:if test="${not hasErrorDetails and not empty checkoutError}">
                                <div class="alert alert-danger alert-dismissible fade show mb-4 checkout-alert" role="alert">
                                    <div class="d-flex align-items-center mb-3">
                                        <strong class="me-2"><i class="fas fa-exclamation-triangle me-2"></i>Thông báo:</strong>
                                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                                    </div>
                                    <p class="mb-0"><c:out value="${checkoutError}" /></p>
                                </div>
                            </c:if>
                            <form action="/order/place-order" method="post" id="checkoutForm">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <input type="hidden" name="totalPrice" value="${totalPrice}" data-cart-total-field />

                                <div class="row g-5 align-items-start">
                                    <!-- Thông tin người nhận -->
                                    <div class="col-md-12 col-lg-6 col-xl-6 checkout-form-column">
                                        <div class="checkout-card checkout-form-card">
                                            <div class="checkout-card__head">
                                                <span class="checkout-card__icon">
                                                    <i class="fas fa-address-card"></i>
                                                </span>
                                                <div>
                                                    <p class="checkout-card__eyebrow">Thông tin nhận hàng</p>
                                                    <h3 class="checkout-card__title">Chi tiết người nhận</h3>
                                                </div>
                                            </div>
                                            <div class="row g-4">
                                                <div class="col-12 col-lg-6">
                                                    <div class="form-item w-100">
                                                        <label class="form-label my-3">Họ và tên<sup>*</sup></label>
                                                        <input type="text" class="form-control" name="receiverName"
                                                            required>
                                                    </div>
                                                </div>
                                                <div class="col-12 col-lg-6">
                                                    <div class="form-item w-100">
                                                        <label class="form-label my-3">Số điện thoại<sup>*</sup></label>
                                                        <input type="tel" class="form-control" name="receiverPhone"
                                                            required>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-item">
                                                <label class="form-label my-3">Địa chỉ<sup>*</sup></label>
                                                <input type="text" class="form-control" name="receiverAddress" required>
                                            </div>
                                            <div class="form-item">
                                                <label class="form-label my-3">Ghi chú</label>
                                                <textarea class="form-control" name="note" rows="3"
                                                    placeholder="Ví dụ: Giao sau 18h, gọi trước khi đến..."></textarea>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Thông tin đơn hàng & thanh toán -->
                                    <div class="col-md-12 col-lg-6 col-xl-6">
                                        <div class="checkout-card checkout-summary-card">
                                            <div class="checkout-card__head">
                                                <span class="checkout-card__icon checkout-card__icon--accent">
                                                    <i class="fas fa-shopping-basket"></i>
                                                </span>
                                                <div>
                                                    <p class="checkout-card__eyebrow">Đơn hàng của bạn</p>
                                                    <h3 class="checkout-card__title">Sản phẩm & thanh toán</h3>
                                                </div>
                                            </div>
                                            <!-- Thông tin đơn hàng -->
                                            <div class="table-responsive checkout-summary-table-wrapper">
                                                <c:choose>
                                                    <c:when test="${not empty cartDetails}">
                                                        <table class="table checkout-summary-table">
                                                            <thead>
                                                                <tr>
                                                                    <th scope="col">Sản phẩm</th>
                                                                    <th scope="col">Tên</th>
                                                                    <th scope="col">Giá</th>
                                                                    <th scope="col">Số lượng</th>
                                                                    <th scope="col">Tổng</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="cartDetail" items="${cartDetails}">
                                                                    <tr>
                                                                        <th scope="row">
                                                                            <div class="d-flex align-items-center">
                                                                                <img src="/images/product/${cartDetail.product.image}"
                                                                                    class="img-fluid me-3 rounded-3"
                                                                                    style="width: 70px; height: 70px;" alt="">
                                                                            </div>
                                                                        </th>
                                                                        <td>
                                                                            <p class="mb-0">${cartDetail.product.name}</p>
                                                                        </td>
                                                                        <td>
                                                                            <p class="mb-0">
                                                                                <span data-checkout-unit-price="true"
                                                                                    data-cart-detail-id="${cartDetail.id}"
                                                                                    data-cart-detail-price="${cartDetail.price}">
                                                                                    <fmt:formatNumber type="number"
                                                                                        value="${cartDetail.price}" />
                                                                                </span>
                                                                                đ
                                                                            </p>
                                                                        </td>
                                                                        <td>
                                                                            <p class="mb-0">
                                                                                <span data-checkout-quantity="true"
                                                                                    data-cart-detail-id="${cartDetail.id}">
                                                                                    ${cartDetail.quantity}
                                                                                </span>
                                                                            </p>
                                                                        </td>
                                                                        <td>
                                                                            <p class="mb-0 cart-price-accent"
                                                                                data-cart-detail-id="${cartDetail.id}">
                                                                                <fmt:formatNumber type="number"
                                                                                    value="${cartDetail.price * cartDetail.quantity}" />
                                                                                đ
                                                                            </p>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                                <tr class="checkout-summary-total">
                                                                    <th scope="row"></th>
                                                                    <td></td>
                                                                    <td></td>
                                                                    <td>
                                                                        <p class="mb-0 text-dark">Tổng tiền</p>
                                                                    </td>
                                                                    <td>
                                                                        <div class="py-3 border-bottom border-top">
                                                                            <p class="mb-0 cart-total-accent" id="totalPrice"
                                                                                data-cart-total-price="true">
                                                                                <fmt:formatNumber type="number"
                                                                                    value="${totalPrice}" /> đ
                                                                            </p>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="alert alert-warning mb-0" role="alert">
                                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                                            Giỏ hàng của bạn đang trống. Vui lòng quay lại giỏ hàng để thêm sản phẩm.
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <!-- Phương thức thanh toán -->
                                            <div class="checkout-payment">
                                                <p class="checkout-payment__title">Phương thức thanh toán</p>

                                                <div class="payment-option">
                                                    <input type="radio" class="payment-option__input" id="paymentCOD"
                                                        name="paymentMethod" value="COD" checked>
                                                    <label class="payment-option__label" for="paymentCOD">
                                                        <span class="payment-option__icon">
                                                            <i class="fas fa-truck-moving"></i>
                                                        </span>
                                                        <span class="payment-option__content">
                                                            <strong>Thanh toán khi nhận hàng (COD)</strong>
                                                            <small>Kiểm tra sản phẩm trước khi thanh toán.</small>
                                                        </span>
                                                    </label>
                                                </div>

                                                <div class="payment-option">
                                                    <input type="radio" class="payment-option__input" id="paymentVNPay"
                                                        name="paymentMethod" value="VNPAY">
                                                    <label class="payment-option__label" for="paymentVNPay">
                                                        <span class="payment-option__icon payment-option__icon--accent">
                                                            <img src="/client/img/vnpay-logo.png" alt="VNPay"
                                                                class="payment-option__logo">
                                                        </span>
                                                        <span class="payment-option__content">
                                                            <strong>Thanh toán qua VNPay</strong>
                                                            <small>Giao dịch bảo mật, xác nhận tức thì.</small>
                                                        </span>
                                                    </label>
                                                </div>

                                                <c:choose>
                                                    <c:when test="${empty cartDetails}">
                                                        <button type="submit" class="btn checkout-submit-btn w-100 text-uppercase" disabled>
                                                            Đặt hàng
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="submit" class="btn checkout-submit-btn w-100 text-uppercase">
                                                            Đặt hàng
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    <!-- Checkout -->

                    <jsp:include page="../layout/footer.jsp" />

                    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
                    <script src="/client/js/main.js"></script>
                    <script src="/client/js/effects.js"></script>
                    <script src="/client/js/cart.js"></script>

                    <!-- Lưu errorDetails vào data attribute nếu có -->
                    <c:if test="${hasErrorDetails}">
                        <script type="application/json" id="errorDetailsData">
                            [
                                <c:forEach var="errorDetail" items="${checkoutErrorDetails}" varStatus="status">
                                {
                                    "productId": ${errorDetail.productId},
                                    "productName": "<c:out value="${errorDetail.productName}" escapeXml="true" />",
                                    "requestedQuantity": ${errorDetail.requestedQuantity},
                                    "availableQuantity": ${errorDetail.availableQuantity},
                                    "message": "<c:out value="${errorDetail.message}" escapeXml="true" />"
                                }<c:if test="${!status.last}">,</c:if>
                                </c:forEach>
                            ]
                        </script>
                        <input type="hidden" id="errorMessageData" value="<c:out value="${checkoutError}" escapeXml="true" />" />
                    </c:if>

                    <script>
                        // Hàm hiển thị thông báo lỗi với bảng chi tiết
                        function showErrorAlert(errorDetails, generalMessage) {
                            // Xóa alert cũ nếu có
                            const oldAlert = document.querySelector('.checkout-alert');
                            if (oldAlert) {
                                oldAlert.remove();
                            }
                            
                            // Tạo container cho alert
                            const alertDiv = document.createElement('div');
                            alertDiv.className = 'alert alert-danger alert-dismissible fade show mb-4 checkout-alert';
                            alertDiv.setAttribute('role', 'alert');
                            
                            let html = '<div class="d-flex align-items-center mb-3">';
                            html += '<strong class="me-2"><i class="fas fa-exclamation-triangle me-2"></i>Thông báo:</strong>';
                            html += '<button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>';
                            html += '</div>';
                            
                            // Nếu có errorDetails, hiển thị bảng chi tiết
                            if (errorDetails && errorDetails.length > 0) {
                                html += '<p class="mb-3">Có một số sản phẩm không đủ số lượng trong kho:</p>';
                                html += '<div class="table-responsive">';
                                html += '<table class="table table-bordered table-sm table-hover mb-0">';
                                html += '<thead class="table-light">';
                                html += '<tr>';
                                html += '<th style="width: 5%;">STT</th>';
                                html += '<th style="width: 40%;">Tên sản phẩm</th>';
                                html += '<th style="width: 15%;" class="text-center">Số lượng yêu cầu</th>';
                                html += '<th style="width: 15%;" class="text-center">Số lượng còn lại</th>';
                                html += '<th style="width: 25%;" class="text-center">Thông báo</th>';
                                html += '</tr>';
                                html += '</thead>';
                                html += '<tbody>';
                                
                                errorDetails.forEach((item, index) => {
                                    html += '<tr>';
                                    html += `<td class="text-center">${index + 1}</td>`;
                                    html += `<td><strong>${item.productName || 'N/A'}</strong></td>`;
                                    html += `<td class="text-center"><span class="badge bg-warning text-dark">${item.requestedQuantity || 0}</span></td>`;
                                    html += `<td class="text-center"><span class="badge bg-danger">${item.availableQuantity || 0}</span></td>`;
                                    html += `<td class="text-center"><small class="text-danger">${item.message || 'Không đủ hàng'}</small></td>`;
                                    html += '</tr>';
                                });
                                
                                html += '</tbody>';
                                html += '</table>';
                                html += '</div>';
                            } else {
                                // Hiển thị message chung nếu không có errorDetails
                                html += `<p class="mb-0">${generalMessage || 'Không đủ hàng để đặt đơn hàng'}</p>`;
                            }
                            
                            alertDiv.innerHTML = html;
                            
                            // Thêm alert mới vào đầu form
                            const form = document.getElementById('checkoutForm');
                            form.insertBefore(alertDiv, form.firstChild);
                            
                            // Scroll đến alert
                            alertDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        }

                        // Kiểm tra nếu có errorDetails từ flash attribute (khi redirect từ place-order)
                        // Chỉ hiển thị bằng JS nếu chưa có alert trong JSP (để tránh duplicate)
                        (function() {
                            // Kiểm tra xem đã có alert từ JSP chưa
                            const existingAlert = document.querySelector('.checkout-alert');
                            if (existingAlert) {
                                // Đã có alert từ JSP, không cần hiển thị lại bằng JS
                                // Chỉ scroll đến alert để người dùng thấy
                                existingAlert.scrollIntoView({ behavior: 'smooth', block: 'center' });
                                return;
                            }

                            // Nếu chưa có alert, thử hiển thị bằng JS (fallback)
                            const errorDetailsScript = document.getElementById('errorDetailsData');
                            const errorMessageInput = document.getElementById('errorMessageData');
                            if (errorDetailsScript && errorMessageInput) {
                                try {
                                    const errorDetailsFromServer = JSON.parse(errorDetailsScript.textContent);
                                    const errorMessage = errorMessageInput.value;
                                    if (errorDetailsFromServer && errorDetailsFromServer.length > 0) {
                                        showErrorAlert(errorDetailsFromServer, errorMessage || 'Không đủ hàng để đặt đơn hàng');
                                    }
                                } catch (e) {
                                    console.error('Error parsing errorDetails:', e);
                                }
                            }
                        })();

                        const checkoutForm = document.getElementById('checkoutForm');
                        let allowSubmit = false; // Flag để cho phép submit

                        checkoutForm.addEventListener('submit', function (e) {
                            // Nếu đã được phép submit (sau khi kiểm tra stock thành công)
                            if (allowSubmit) {
                                allowSubmit = false; // Reset flag
                                return; // Cho phép submit bình thường
                            }

                            e.preventDefault();

                            const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
                            const submitButton = this.querySelector('button[type="submit"]');
                            
                            // Disable button để tránh double submit
                            submitButton.disabled = true;
                            submitButton.textContent = 'Đang xử lý...';

                            if (paymentMethod === 'VNPAY') {
                                // Thanh toán VNPay - đã có kiểm tra stock trong backend
                                const formData = new FormData(this);

                                fetch('/order/create-vnpay', {
                                    method: 'POST',
                                    body: formData
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success === 'true') {
                                            window.location.href = data.paymentUrl;
                                        } else {
                                            // VNPay có thể trả về errorDetails hoặc chỉ message
                                            const errorDetails = data.errorDetails || [];
                                            showErrorAlert(errorDetails, data.message || 'Có lỗi xảy ra khi tạo đơn hàng');
                                            submitButton.disabled = false;
                                            submitButton.textContent = 'Đặt hàng';
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        showErrorAlert([], 'Có lỗi xảy ra, vui lòng thử lại!');
                                        submitButton.disabled = false;
                                        submitButton.textContent = 'Đặt hàng';
                                    });
                            } else {
                                // Thanh toán COD: Kiểm tra stock trước khi submit
                                const formData = new FormData(this);
                                
                                // Gửi request kiểm tra stock
                                fetch('/order/check-stock', {
                                    method: 'POST',
                                    body: formData
                                })
                                    .then(response => response.json())
                                    .then(data => {
                                        if (data.success === true) {
                                            // Stock đủ, cho phép submit
                                            allowSubmit = true;
                                            submitButton.disabled = false;
                                            submitButton.textContent = 'Đặt hàng';
                                            checkoutForm.submit();
                                        } else {
                                            // Stock không đủ, hiển thị lỗi với bảng chi tiết
                                            const errorDetails = data.errorDetails || [];
                                            showErrorAlert(errorDetails, data.message || 'Không đủ hàng để đặt đơn hàng');
                                            submitButton.disabled = false;
                                            submitButton.textContent = 'Đặt hàng';
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        showErrorAlert([], 'Có lỗi xảy ra khi kiểm tra tồn kho, vui lòng thử lại!');
                                        submitButton.disabled = false;
                                        submitButton.textContent = 'Đặt hàng';
                                    });
                            }
                        });
                    </script>
                </body>

                </html>