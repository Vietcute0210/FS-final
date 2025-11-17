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
                    <title>Update Order - </title>
                    <link href="/css/styles.css" rel="stylesheet" />
                    <link href="/css/custom.css" rel="stylesheet" />
                    <link href="/css/admin.css" rel="stylesheet" />
                    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js"
                        crossorigin="anonymous"></script>
                    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>


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
                                            <li class="breadcrumb-item active" aria-current="page">Update</li>
                                        </ol>
                                    </nav>
                                </div>

                                <div class="d-flex justify-content-between">
                                    <h3>Update an order</h3>
                                </div>
                                <hr />
                                <div class="row justify-content-center">
                                    <div class="col-12 col-xl-10 mx-auto admin-card admin-order-update">
                                        <form:form method="post" action="/admin/order/update" class="row"
                                            modelAttribute="newOrder">
                                            <div class="mb-3" style="display: none;">
                                                <label class="form-label">Id:</label>
                                                <form:input type="text" class="form-control" path="id" />
                                            </div>

                                            <div class="mb-3">
                                                <label>Order id = ${newOrder.id} </label>
                                                &nbsp; &nbsp; &nbsp; &nbsp;
                                                <label class="form-label">Price:
                                                    <fmt:formatNumber type="number" value="${newOrder.totalPrice}" /> đ
                                                </label>
                                            </div>

                                            <div class="mb-3 col-12 col-md-6">
                                                <label class="form-label">User:</label>
                                                <form:input type="text" class="form-control" disabled="true"
                                                    path="user.fullName" />
                                            </div>

                                            <div class="mb-3 col-12 col-md-6">
                                                <label class="form-label">Status:</label>
                                                <form:select class="form-select" path="status">
                                                    <form:option value="PENDING">PENDING</form:option>
                                                    <form:option value="SHIPPING">SHIPPING</form:option>
                                                    <form:option value="COMPLETE">COMPLETE</form:option>
                                                    <form:option value="CANCEL">CANCEL</form:option>
                                                </form:select>
                                            </div>

                                            <div class="col-12 mb-5">
                                                <button type="submit" class="btn btn-warning">Update</button>
                                            </div>
                                        </form:form>
                                    </div>
                                </div>
                            </div>
                            </main>
                            <jsp:include page="../layout/footer.jsp" />
                        </div>
                    </div>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
                        crossorigin="anonymous"></script>
                    <script src="/client/js/main.js"></script>
                    <script src="/js/admin.js"></script>
                </body>

                </html>