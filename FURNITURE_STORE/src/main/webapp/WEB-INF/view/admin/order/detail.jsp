<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8" />
                    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
                    <meta name="description" content=" - Dự án FURNITURE STORE" />
                    <meta name="author" content="" />
                    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
                    <title>Detail Order - FURNITURE STORE</title>
                    <link href="/css/styles.css" rel="stylesheet" />
                    <link href="/css/custom.css" rel="stylesheet" />
                    <link href="/css/admin.css" rel="stylesheet" />
                    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js"
                        crossorigin="anonymous"></script>

                    <script>
                        $(document).ready(() => {
                            const productFile = $("#productFile");
                            productFile.change(function (e) {
                                // JQuery có thể can thiệp vào html và css như cách dùng hàm attr và css phía dưới
                                // ban đầu mình để display là : none ở trong phần img ở dòng 89
                                // nhưng sau khi up ảnh mình sửa display lại được thành block để hiển thị ảnh
                                const imgURL = URL.createObjectURL(e.target.files[0]);
                                $("#productPreview").attr("src", imgURL);
                                $("#productPreview").css({ "display": "block" });
                            });
                        });
                    </script>
                </head>

                <body class="sb-nav-fixed">
                    <jsp:include page="../layout/header.jsp" />

                    <div id="layoutSidenav">
                        <jsp:include page="../layout/sidebar.jsp" />
                        <div id="layoutSidenav_content">
                            <div class="container-fluid px-4">
                                <h1 class="mt-4">Orders</h1>
                                <div class="mb-3">
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                                            <li class="breadcrumb-item"><a href="/admin/order">Order</a></li>
                                            <li class="breadcrumb-item active" aria-current="page">
                                                View detail
                                            </li>
                                        </ol>
                                    </nav>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <h3>Order detail with id = ${id}</h3>
                                </div>
                                <hr />
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle order-detail-table">
                                        <thead>
                                            <tr>
                                                <th scope="col">Sản phẩm</th>
                                                <th scope="col">Tên</th>
                                                <th scope="col">Giá cả</th>
                                                <th scope="col">Số lượng</th>
                                                <th scope="col">Thành tiền</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty orderDetails}">
                                                <tr>
                                                    <td colspan="6">
                                                        Không có sản phẩm trong giỏ hàng
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:forEach var="orderDetail" items="${orderDetails}">
                                                <tr>
                                                    <th scope="row">
                                                        <div class="d-flex align-items-center">
                                                            <img src="/images/product/${orderDetail.product.image}"
                                                                class="img-fluid me-5 rounded-circle"
                                                                style="width: 80px; height: 80px;" alt="">
                                                        </div>
                                                    </th>
                                                    <td>
                                                        <p class="mb-0 mt-4">
                                                            <a href="/product/${orderDetail.product.id}"
                                                                target="_blank">
                                                                ${orderDetail.product.name}
                                                            </a>
                                                        </p>
                                                    </td>
                                                    <td>
                                                        <p class="mb-0 mt-4">
                                                            <fmt:formatNumber type="number"
                                                                value="${orderDetail.price}" /> đ
                                                        </p>
                                                    </td>
                                                    <td>
                                                        <p class="mb-0 mt-4">
                                                            ${orderDetail.quantity}
                                                        </p>
                                                    </td>
                                                    <td>
                                                        <p class="mb-0 mt-4">
                                                            <fmt:formatNumber type="number"
                                                                value="${orderDetail.price * orderDetail.quantity}" /> đ
                                                        </p>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            </main>
                            <jsp:include page="../layout/footer.jsp" />
                        </div>
                    </div>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
                        crossorigin="anonymous"></script>
                    <script src="/js/main.js"></script>
                    <script src="js/admin.js"></script>
                </body>

                </html>