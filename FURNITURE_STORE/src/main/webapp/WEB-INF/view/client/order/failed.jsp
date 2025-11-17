<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
    <title>Thanh toán thất bại - Furniture Store</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap"
        rel="stylesheet">

    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/client/css/bootstrap.min.css" rel="stylesheet">
    <link href="/client/css/style.css" rel="stylesheet">
    <link href="/client/css/override.css" rel="stylesheet">
    <link href="/client/css/effects.css" rel="stylesheet">
    <link href="/client/css/order.css" rel="stylesheet">
</head>

<body>
    <jsp:include page="../layout/header.jsp" />

    <div class="container-fluid py-5">
        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="checkout-card text-center">
                        <div class="checkout-card__head mb-4">
                            <span class="checkout-card__icon checkout-card__icon--accent" style="font-size: 4rem; color: #dc3545;">
                                <i class="fas fa-exclamation-circle"></i>
                            </span>
                            <h1 class="checkout-page-title mt-3 text-danger">Thanh toán thất bại!</h1>
                        </div>

                        <!-- Container để hiển thị error bằng JavaScript -->
                        <div id="errorContainer" class="mb-4">
                            <!-- Error sẽ được hiển thị bằng JavaScript -->
                        </div>

                        <div class="mt-4">
                            <a href="/cart" class="btn btn-primary rounded-pill py-3 px-5 me-3">
                                <i class="fas fa-shopping-cart me-2"></i>Quay lại giỏ hàng
                            </a>
                            <a href="/products" class="btn btn-outline-secondary rounded-pill py-3 px-5">
                                <i class="fas fa-store me-2"></i>Tiếp tục mua sắm
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../layout/footer.jsp" />

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/client/js/main.js"></script>
    <script src="/client/js/effects.js"></script>

    <!-- Lưu error và errorDetails vào JavaScript -->
    <c:choose>
        <c:when test="${not empty errorDetails}">
            <script type="application/json" id="errorData">
                {
                    "error": "<c:out value="${error}" escapeXml="false" />",
                    "errorDetails": [
                        <c:forEach var="errorDetail" items="${errorDetails}" varStatus="status">
                        {
                            "productId": ${errorDetail.productId},
                            "productName": "<c:out value="${errorDetail.productName}" escapeXml="false" />",
                            "requestedQuantity": ${errorDetail.requestedQuantity},
                            "availableQuantity": ${errorDetail.availableQuantity},
                            "message": "<c:out value="${errorDetail.message}" escapeXml="false" />"
                        }<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ]
                }
            </script>
        </c:when>
        <c:otherwise>
            <script type="application/json" id="errorData">
                {
                    "error": "<c:out value="${error}" escapeXml="false" />",
                    "errorDetails": []
                }
            </script>
        </c:otherwise>
    </c:choose>

    <script>
        (function() {
            // Hàm escape HTML để tránh XSS
            function escapeHtml(text) {
                if (!text) return '';
                const map = {
                    '&': '&amp;',
                    '<': '&lt;',
                    '>': '&gt;',
                    '"': '&quot;',
                    "'": '&#039;'
                };
                return String(text).replace(/[&<>"']/g, m => map[m]);
            }

            // Đọc error và errorDetails từ JSON
            const errorDataScript = document.getElementById('errorData');
            const errorContainer = document.getElementById('errorContainer');
            
            if (!errorDataScript) {
                // Nếu không có errorData, hiển thị thông báo mặc định
                errorContainer.innerHTML = 
                    '<div class="alert alert-danger" role="alert">' +
                    '<h5 class="alert-heading"><i class="fas fa-exclamation-triangle me-2"></i>Có lỗi xảy ra!</h5>' +
                    '<p class="mb-0">Đã có lỗi xảy ra trong quá trình thanh toán. Vui lòng thử lại sau.</p>' +
                    '</div>';
                return;
            }

            try {
                const errorData = JSON.parse(errorDataScript.textContent);
                let html = '';

                // Nếu có errorDetails và không rỗng, hiển thị bảng chi tiết
                if (errorData.errorDetails && Array.isArray(errorData.errorDetails) && errorData.errorDetails.length > 0) {
                    html += '<div class="alert alert-danger alert-dismissible fade show" role="alert">';
                    html += '<div class="d-flex align-items-center mb-3">';
                    html += '<strong class="me-2"><i class="fas fa-exclamation-triangle me-2"></i>Thông báo:</strong>';
                    html += '<button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>';
                    html += '</div>';
                    html += '<p class="mb-3">Có một số sản phẩm không đủ số lượng trong kho:</p>';
                    
                    // Bảng chi tiết
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
                    
                    errorData.errorDetails.forEach((item, index) => {
                        html += '<tr>';
                        html += `<td class="text-center">${index + 1}</td>`;
                        html += `<td><strong>${escapeHtml(item.productName || 'N/A')}</strong></td>`;
                        html += `<td class="text-center"><span class="badge bg-warning text-dark">${item.requestedQuantity || 0}</span></td>`;
                        html += `<td class="text-center"><span class="badge bg-danger">${item.availableQuantity || 0}</span></td>`;
                        html += `<td class="text-center"><small class="text-danger">${escapeHtml(item.message || 'Không đủ hàng')}</small></td>`;
                        html += '</tr>';
                    });
                    
                    html += '</tbody>';
                    html += '</table>';
                    html += '</div>';
                    html += '</div>';
                } else if (errorData.error && String(errorData.error).trim() !== '') {
                    // Nếu chỉ có error message, hiển thị alert đơn giản
                    html += '<div class="alert alert-danger alert-dismissible fade show" role="alert">';
                    html += '<div class="d-flex align-items-center mb-3">';
                    html += '<strong class="me-2"><i class="fas fa-exclamation-triangle me-2"></i>Thông báo:</strong>';
                    html += '<button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>';
                    html += '</div>';
                    html += `<p class="mb-0">${escapeHtml(errorData.error)}</p>`;
                    html += '</div>';
                } else {
                    // Thông báo mặc định
                    html += '<div class="alert alert-danger" role="alert">';
                    html += '<h5 class="alert-heading"><i class="fas fa-exclamation-triangle me-2"></i>Có lỗi xảy ra!</h5>';
                    html += '<p class="mb-0">Đã có lỗi xảy ra trong quá trình thanh toán. Vui lòng thử lại sau.</p>';
                    html += '</div>';
                }

                errorContainer.innerHTML = html;

                // Scroll đến error container
                errorContainer.scrollIntoView({ behavior: 'smooth', block: 'center' });

            } catch (e) {
                console.error('Error parsing error data:', e);
                // Hiển thị thông báo lỗi mặc định nếu parse JSON thất bại
                errorContainer.innerHTML = 
                    '<div class="alert alert-danger" role="alert">' +
                    '<h5 class="alert-heading"><i class="fas fa-exclamation-triangle me-2"></i>Có lỗi xảy ra!</h5>' +
                    '<p class="mb-0">Đã có lỗi xảy ra trong quá trình thanh toán. Vui lòng thử lại sau.</p>' +
                    '</div>';
            }
        })();
    </script>
</body>

</html>
