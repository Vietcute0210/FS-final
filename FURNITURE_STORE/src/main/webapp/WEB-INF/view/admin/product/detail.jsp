<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                    <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="utf-8" />
                        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
                        <meta name="description" content="Furniture Store" />
                        <meta name="author" content="Furniture Store" />
                        <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
                        <title>${product.name} - Furniture Store</title>
                        <link href="/css/styles.css" rel="stylesheet" />
                        <link href="/css/custom.css" rel="stylesheet" />
                        <link href="/css/admin.css" rel="stylesheet" />
                        <link href="/css/admin-product-media.css" rel="stylesheet" />
                        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js"
                            crossorigin="anonymous"></script>
                    </head>

                    <body class="sb-nav-fixed">
                        <jsp:include page="../layout/header.jsp" />

                        <div id="layoutSidenav">
                            <jsp:include page="../layout/sidebar.jsp" />
                            <div id="layoutSidenav_content">
                                <main>
                                    <div class="container-fluid px-4">
                                        <h1 class="mt-4">Products</h1>
                                        <div class="mb-3">
                                            <nav aria-label="breadcrumb">
                                                <ol class="breadcrumb">
                                                    <li class="breadcrumb-item">
                                                        <a href="/admin">Dashboard</a>
                                                    </li>
                                                    <li class="breadcrumb-item">
                                                        <a href="/admin/product">Product</a>
                                                    </li>
                                                    <li class="breadcrumb-item active" aria-current="page">
                                                        View detail
                                                    </li>
                                                </ol>
                                            </nav>
                                        </div>
                                    </div>
                                    <div class="container mt-5">
                                        <div class="row">
                                            <div class="col-12 mx-auto">
                                                <div class="d-flex justify-content-between">
                                                    <h3>Product Details with id = ${id}</h3>
                                                </div>
                                                <hr />
                                                <div class="card w-100">
                                                    <div class="card-header">Media Gallery</div>
                                                    <div class="card-body">
                                                        <c:set var="mediaCount" value="${fn:length(product.medias)}" />
                                                        <div class="detail-media-grid">
                                                            <c:forEach var="media" items="${product.medias}"
                                                                varStatus="mediaStatus">
                                                                <c:if test="${mediaStatus.index < 5}">
                                                                    <c:url
                                                                        value="/images/product/${product.id}/${media.fileName}"
                                                                        var="mediaUrl" />
                                                                    <div class="detail-media-card">
                                                                        <div class="media-thumb">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${media.mediaType == 'VIDEO'}">
                                                                                    <video src="${mediaUrl}" controls
                                                                                        playsinline
                                                                                        preload="metadata"></video>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <img src="${mediaUrl}"
                                                                                        alt="${media.fileName}"
                                                                                        onerror="this.onerror=null; this.src='/images/product/${media.fileName}';" />
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                        <div class="media-info">
                                                                            <span
                                                                                class="media-label">${media.fileName}</span>
                                                                            <span
                                                                                class="media-type">${media.mediaType}</span>
                                                                        </div>
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                            <c:if test="${mediaCount < 5}">
                                                                <c:forEach begin="1" end="${5 - mediaCount}"
                                                                    varStatus="fillStatus">
                                                                    <div
                                                                        class="detail-media-card detail-media-card--empty">
                                                                        <div class="media-thumb">
                                                                            <i class="fas fa-photo-video"></i>
                                                                        </div>
                                                                        <div class="media-info">
                                                                            <span class="media-label">Empty slot</span>
                                                                            <span class="media-type">Slot ${mediaCount +
                                                                                fillStatus.index + 1}</span>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                    <div class="card-header">Product Information</div>
                                                    <ul class="list-group list-group-flush">
                                                        <li class="list-group-item">ID : ${product.id}</li>
                                                        <li class="list-group-item">Name : ${product.name}</li>
                                                        <li class="list-group-item">Price : ${product.price}</li>
                                                    </ul>
                                                </div>
                                                <a href="/admin/product" class="btn btn-success">BACK</a>
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