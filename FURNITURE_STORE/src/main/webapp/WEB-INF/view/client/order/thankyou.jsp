<!-- thankyou.jsp version giữ nguyên cấu trúc gốc, chỉ thêm class để dễ style -->
<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib prefix="form"
uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
    <title>Đơn hàng - FURNITURE STORE</title>

    <!-- CSS LIBRARIES -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;600&family=Raleway:wght@600;800&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://use.fontawesome.com/releases/v5.15.4/css/all.css"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css"
      rel="stylesheet"
    />
    <link href="/client/lib/lightbox/css/lightbox.min.css" rel="stylesheet" />
    <link
      href="/client/lib/owlcarousel/assets/owl.carousel.min.css"
      rel="stylesheet"
    />

    <!-- PROJECT CSS -->
    <link href="/client/css/bootstrap.min.css" rel="stylesheet" />
    <link href="/client/css/style.css" rel="stylesheet" />
    <link href="/client/css/thankyou.css" rel="stylesheet" />
    <!-- thêm file riêng cho hiệu ứng -->

    <link rel="icon" type="image/png" href="/client/img/logo.png" />
  </head>

  <body class="thankyou-page">
    <!-- Spinner -->
    <div
      id="spinner"
      class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50 d-flex align-items-center justify-content-center"
    >
      <div class="spinner-grow text-primary" role="status"></div>
    </div>

    <jsp:include page="../layout/header.jsp" />

    <c:set
      var="resolvedOrderId"
      value="${not empty param.orderId ? param.orderId : orderId}"
    />

    <!-- THANK YOU MAIN -->
    <div class="thankyou-container container">
      <div class="thankyou-box text-center">
        <div class="thankyou-icon">
          <i class="fas fa-check-circle"></i>
        </div>
        <h1 class="thankyou-title">Cảm ơn bạn đã đặt hàng!</h1>
        <p class="thankyou-message">
          Đơn hàng của bạn đang được xử lý. Furniture Store sẽ thông báo ngay
          khi bàn giao cho đơn vị vận chuyển.
        </p>
        <c:if test="${not empty resolvedOrderId}">
          <p class="thankyou-order-code">
            Mã đơn hàng: <strong>#${resolvedOrderId}</strong>
          </p>
        </c:if>
        <div class="thankyou-actions">
          <a
            href="/products"
            class="btn btn-primary rounded-pill px-4 py-3 continue-btn"
          >
            Tiếp tục mua sắm
          </a>
          <a
            href="/order-history"
            class="btn btn-outline-primary rounded-pill px-4 py-3 thankyou-secondary-btn"
          >
            Theo dõi đơn hàng
          </a>
        </div>
      </div>

      <div class="thankyou-meta-grid">
        <div class="thankyou-meta-card">
          <div class="thankyou-meta-icon">
            <i class="fas fa-box-open"></i>
          </div>
          <h3>Chuẩn bị đơn</h3>
          <p>Đơn hàng sẽ được đóng gói trong vòng 24 giờ làm việc.</p>
        </div>
        <div class="thankyou-meta-card">
          <div class="thankyou-meta-icon">
            <i class="fas fa-truck-loading"></i>
          </div>
          <h3>Vận chuyển</h3>
          <p>Thời gian giao hàng dự kiến 2-5 ngày tùy khu vực.</p>
        </div>
        <div class="thankyou-meta-card">
          <div class="thankyou-meta-icon">
            <i class="fas fa-headset"></i>
          </div>
          <h3>Hỗ trợ 24/7</h3>
          <p>Hotline 1900 636 789 luôn sẵn sàng đồng hành cùng bạn.</p>
        </div>
      </div>
    </div>

    <section class="thankyou-extra-info container">
      <div class="thankyou-extra-card">
        <h4>Ưu đãi dành riêng</h4>
        <p>
          Truy cập mục khuyến mãi mỗi ngày để nhận voucher độc quyền cho các
          dòng sản phẩm mới.
        </p>
      </div>
      <div class="thankyou-extra-card">
        <h4>Liên hệ nhanh</h4>
        <ul>
          <li>
            Email:
            <a href="mailto:support@furniturestore.vn"
              >support@furniturestore.vn</a
            >
          </li>
          <li>Hotline: <strong>1900 636 789</strong> (8:00 - 21:00)</li>
          <li>Zalo CSKH: <strong>@furniturestore.vn</strong></li>
        </ul>
      </div>
    </section>
    <jsp:include page="../layout/feature.jsp" />
    <jsp:include page="../layout/footer.jsp" />

    <a
      href="#"
      class="btn btn-primary border-3 border-primary rounded-circle back-to-top"
    >
      <i class="fa fa-arrow-up"></i>
    </a>

    <!-- JS LIBRARIES -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/client/lib/easing/easing.min.js"></script>
    <script src="/client/lib/waypoints/waypoints.min.js"></script>
    <script src="/client/lib/lightbox/js/lightbox.min.js"></script>
    <script src="/client/lib/owlcarousel/owl.carousel.min.js"></script>

    <!-- PROJECT JS -->
    <script src="/client/js/main.js"></script>
    <script src="/client/js/effects.js"></script>
    <script src="/client/js/thankyou.js"></script>
    <!-- thêm hiệu ứng riêng -->
  </body>
</html>
