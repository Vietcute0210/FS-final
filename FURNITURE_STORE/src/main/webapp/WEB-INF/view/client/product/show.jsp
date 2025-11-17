<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8">
                    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
                    <title> Sản Phẩm - FURNITURE STORE</title>
                    <meta content="width=device-width, initial-scale=1.0" name="viewport">
                    <meta content="" name="keywords">
                    <meta content="" name="description">
                    <meta name="_csrf" content="${_csrf.token}" />
                    <meta name="_csrf_header" content="${_csrf.headerName}" />
                    <meta name="_csrf_parameter" content="${_csrf.parameterName}" />
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
                    <link href="/client/css/product_detail.css" rel="stylesheet">

                    <style>
                        .page-link.disabled {
                            color: var(--bs-pagination-disabled-color);
                            pointer-events: none;
                            background-color: var(--bs-pagination-disabled-bg);
                        }
                    </style>
                </head>

                <body>
                    <!-- Spinner Start -->
                    <div id="spinner"
                        class="show w-100 vh-100 bg-white position-fixed translate-middle top-50 start-50  d-flex align-items-center justify-content-center">
                        <div class="spinner-grow text-primary" role="status"></div>
                    </div>
                    <!-- Spinner End -->

                    <jsp:include page="../layout/header.jsp" />

                    <!-- Single Product Start -->
                    <div class="container-fluid py-5 mt-5">
                        <div class="container py-5">
                            <div class="row g-4 mb-5">
                                <div>
                                    <nav aria-label="breadcrumb">
                                        <ol class="breadcrumb">
                                            <li class="breadcrumb-item"><a href="/">Home</a></li>
                                            <li class="breadcrumb-item active" aria-current="page">Danh Sách Sản Phẩm
                                            </li>
                                        </ol>
                                    </nav>
                                </div>
                                <div class="row g-4 fruite">

                                    <!-- Bên trái -->
                                    <div class="col-12 col-md-4">
                                        <div class="row g-4">

                                            <!-- factoryFilter -->
                                            <div class="col-12 filter-section" id="factoryFilter">
                                                <div class="mb-2"><b>Hãng sản xuất</b></div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="factory-1"
                                                        value="FACTORY1">
                                                    <label class="form-check-label" for="factory-1">FACTORY1</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="factory-2"
                                                        value="FACTORY2">
                                                    <label class="form-check-label" for="factory-2">FACTORY2</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="checkbox" id="factory-3"
                                                        value="FACTORY3">
                                                    <label class="form-check-label" for="factory-3">FACTORY3</label>
                                                </div>

                                            </div>
                                            <!--  -->

                                            <!-- targetFilter -->
                                            <div class="col-12 filter-section" id="targetFilter">
                                                <div class="mb-2"><b>Phân loại</b></div>
                                                <div class="filter-grid filter-grid--target">
                                                    <label class="filter-option" for="target-1">
                                                        <input class="form-check-input" type="checkbox" id="target-1"
                                                            value="GAMING">
                                                        <span>Ghế</span>
                                                    </label>
                                                    <label class="filter-option" for="target-2">
                                                        <input class="form-check-input" type="checkbox" id="target-2"
                                                            value="SINHVIEN-VANPHONG">
                                                        <span>Bàn</span>
                                                    </label>
                                                    <label class="filter-option" for="target-3">
                                                        <input class="form-check-input" type="checkbox" id="target-3"
                                                            value="THIET-KE-DO-HOA">
                                                        <span>Giường</span>
                                                    </label>
                                                    <label class="filter-option" for="target-4">
                                                        <input class="form-check-input" type="checkbox" id="target-4"
                                                            value="MONG-NHE">
                                                        <span>Tủ</span>
                                                    </label>
                                                    <label class="filter-option" for="target-5">
                                                        <input class="form-check-input" type="checkbox" id="target-5"
                                                            value="DOANH-NHAN">
                                                        <span>Kệ</span>
                                                    </label>
                                                    <label class="filter-option" for="target-6">
                                                        <input class="form-check-input" type="checkbox" id="target-6"
                                                            value="KHAC">
                                                        <span>Khác</span>
                                                    </label>
                                                </div>
                                            </div>
                                            <!--  -->

                                            <!-- priceFilter -->
                                            <div class="col-12 filter-section" id="priceFilter">
                                                <div class="mb-2"><b>Mức giá</b></div>
                                                <div class="filter-grid filter-grid--price">
                                                    <label class="filter-option" for="price-2">
                                                        <input class="form-check-input" type="checkbox" id="price-2"
                                                            value="duoi-10-trieu">
                                                        <span>Dưới 10 triệu</span>
                                                    </label>
                                                    <label class="filter-option" for="price-3">
                                                        <input class="form-check-input" type="checkbox" id="price-3"
                                                            value="10-15-trieu">
                                                        <span>Từ 10 - 15 triệu</span>
                                                    </label>
                                                    <label class="filter-option" for="price-4">
                                                        <input class="form-check-input" type="checkbox" id="price-4"
                                                            value="15-20-trieu">
                                                        <span>Từ 15 - 20 triệu</span>
                                                    </label>
                                                    <label class="filter-option" for="price-5">
                                                        <input class="form-check-input" type="checkbox" id="price-5"
                                                            value="tren-20-trieu">
                                                        <span>Trên 20 triệu</span>
                                                    </label>
                                                </div>
                                            </div>
                                            <!--  -->

                                            <!-- Sort theo tiêu chí -->
                                            <div class="col-12">
                                                <div class="mb-2"><b>Sắp xếp</b></div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" id="sort-1"
                                                        value="gia-tang-dan" name="radio-sort">
                                                    <label class="form-check-label" for="sort-1">Giá tăng dần</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" id="sort-2"
                                                        value="gia-giam-dan" name="radio-sort">
                                                    <label class="form-check-label" for="sort-2">Giá giảm dần</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" id="sort-3" checked
                                                        value="gia-nothing" name="radio-sort">
                                                    <label class="form-check-label" for="sort-3">Không sắp xếp</label>
                                                </div>

                                            </div>

                                            <div class="col-12">
                                                <button
                                                    class="btn border-secondary rounded-pill px-4 py-3 text-primary text-uppercase mb-4"
                                                    id="btnFilter">
                                                    Lọc Sản Phẩm
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- bên phải -->
                                    <div class="col-12 col-md-8 text-center">
                                        <!-- Search -->
                                        <div class="filter-search">
                                            <input type="text" id="searchInput"
                                                class="form-control filter-search__input"
                                                placeholder="Tìm kiếm sản phẩm...">
                                        </div>
                                        <!-- Products -->
                                        <div class="row g-4" id="productsContainer">
                                            <c:if test="${totalPages == 0}">
                                                <div class="col-12">Không tìm thấy sản phẩm</div>
                                            </c:if>
                                            <c:forEach var="product" items="${products}">
                                                <div class="col-md-6 col-lg-4 product-item">
                                                    <div class="rounded position-relative fruite-item">
                                                        <div class="fruite-img">
                                                            <img src="/images/product/${product.image}"
                                                                class="img-fluid w-100 rounded-top" alt="">
                                                        </div>
                                                        <div class="text-white bg-secondary px-3 py-1 rounded position-absolute"
                                                            style="top: 10px; left: 10px;">
                                                            Sản phẩm
                                                        </div>
                                                        <div
                                                            class="p-4 border border-secondary border-top-0 rounded-bottom">
                                                            <h4 style="font-size: 15px;" class="product-name">
                                                                <a href="/product/${product.id}">
                                                                    ${product.name}
                                                                </a>
                                                            </h4>
                                                            <p style="font-size: 13px;">
                                                                ${product.shortDesc}
                                                            </p>
                                                            <!-- Số lượng còn tồn kho -->
                                                            <p style="font-size: 13px;">
                                                                Chỉ còn: <span
                                                                    class="text-success fw-bold">${product.stockQuantity}
                                                                    sản phẩm</span>
                                                            </p>
                                                            <div
                                                                class="d-flex flex-lg-wrap justify-content-center flex-column">
                                                                <p style="font-size: 15px; text-align: center; width: 100%;"
                                                                    class="text-dark fw-bold mb-3">
                                                                    <fmt:formatNumber type="number"
                                                                        value="${product.price}" /> đ
                                                                </p>
                                                                <form action="/add-product-to-cart/${product.id}"
                                                                    method="post">
                                                                    <input type="hidden" name="${_csrf.parameterName}"
                                                                        value="${_csrf.token}" />
                                                                    <button
                                                                        class="mx-auto btn border border-secondary rounded-pill px-3 text-primary">
                                                                        <i
                                                                            class="fa fa-shopping-bag me-2 text-primary"></i>
                                                                        Add to cart
                                                                    </button>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <!-- Pagination -->
                                        <c:if test="${totalPages > 0}">
                                            <div class="pagination d-flex justify-content-center mt-5">
                                                <li class="page-item">
                                                    <a class="${1 eq currentPage ? 'disabled page-link' : 'page-link'}"
                                                        href="/products?page=${currentPage - 1}${queryString}"
                                                        aria-label="Previous">
                                                        <span aria-hidden="true">&laquo;</span>
                                                    </a>
                                                </li>
                                                <c:forEach begin="0" end="${totalPages - 1}" varStatus="loop">
                                                    <li class="page-item">
                                                        <a class="${(loop.index + 1) eq currentPage ? 'active page-link' : 'page-link'}"
                                                            href="/products?page=${loop.index + 1}${queryString}">
                                                            ${loop.index + 1}
                                                        </a>
                                                    </li>
                                                </c:forEach>
                                                <li class="page-item">
                                                    <a class="${totalPages eq currentPage ? 'disabled page-link' : 'page-link'}"
                                                        href="/products?page=${currentPage + 1}${queryString}"
                                                        aria-label="Next">
                                                        <span aria-hidden="true">&raquo;</span>
                                                    </a>
                                                </li>
                                            </div>
                                        </c:if>
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
                    <script src="/client/js/product_filter.js"></script>
                    <script>
                        document.addEventListener('DOMContentLoaded', function () {
                            const searchInput = document.getElementById('searchInput');
                            const productsContainer = document.getElementById('productsContainer');

                            searchInput.addEventListener('input', function (e) {
                                const searchTerm = e.target.value.trim();

                                if (searchTerm === '') {
                                    location.reload();
                                    return;
                                }

                                // Gọi API search (không lowercase để search chính xác hơn)
                                console.log('Searching for:', searchTerm);
                                
                                if (!productsContainer) {
                                    console.error('productsContainer not found!');
                                    return;
                                }
                                
                                // Hiển thị loading
                                productsContainer.innerHTML = '<div class="col-12 text-center mt-5"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Đang tìm kiếm...</span></div></div>';
                                
                                fetch('/search?keyword=' + encodeURIComponent(searchTerm))
                                    .then(response => {
                                        console.log('Response status:', response.status);
                                        console.log('Response ok:', response.ok);
                                        console.log('Content-Type:', response.headers.get('Content-Type'));
                                        
                                        if (!response.ok) {
                                            throw new Error('HTTP ' + response.status + ': ' + response.statusText);
                                        }
                                        
                                        return response.json();
                                    })
                                    .then(data => {
                                        console.log('Response data:', data);
                                        console.log('Data type:', typeof data);
                                        console.log('Is array:', Array.isArray(data));
                                        
                                        // Kiểm tra nếu response có error flag
                                        if (data && data.error) {
                                            throw new Error(data.message || 'Có lỗi xảy ra');
                                        }
                                        
                                        // Ẩn phân trang
                                        const paginationItems = document.querySelectorAll('.pagination li');
                                        paginationItems.forEach(item => {
                                            item.style.display = 'none';
                                        });

                                        // Xóa toàn bộ nội dung container
                                        productsContainer.innerHTML = '';

                                        // Kiểm tra nếu products là array
                                        const productList = Array.isArray(data) ? data : (data && data.products ? data.products : []);
                                        console.log('Product list to display:', productList);
                                        console.log('Product list length:', productList ? productList.length : 0);
                                        
                                        // Hiển thị kết quả tìm kiếm
                                        if (!productList || productList.length === 0) {
                                            console.log('No products found');
                                            productsContainer.innerHTML = '<div class="col-12 text-center mt-5">Không tìm thấy sản phẩm nào</div>';
                                        } else {
                                            console.log('Displaying', productList.length, 'products');
                                            // Lấy CSRF token từ meta tag
                                            const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
                                            const csrfParamName = document.querySelector('meta[name="_csrf_parameter"]')?.getAttribute('content') || '_csrf';
                                            
                                            productList.forEach((product, index) => {
                                                console.log('Processing product', index + 1, ':', product);
                                                const formattedPrice = new Intl.NumberFormat('vi-VN').format(product.price || 0);
                                                const stockQuantity = product.stockQuantity || 0;
                                                const productHtml = '<div class="col-md-6 col-lg-4 product-item">' +
                                                    '<div class="rounded position-relative fruite-item">' +
                                                    '<div class="fruite-img">' +
                                                    '<img src="/images/product/' + (product.image || '') + '" class="img-fluid w-100 rounded-top" alt="">' +
                                                    '</div>' +
                                                    '<div class="text-white bg-secondary px-3 py-1 rounded position-absolute" style="top: 10px; left: 10px;">Sản phẩm</div>' +
                                                    '<div class="p-4 border border-secondary border-top-0 rounded-bottom">' +
                                                    '<h4 style="font-size: 15px;" class="product-name">' +
                                                    '<a href="/product/' + product.id + '">' + (product.name || '') + '</a>' +
                                                    '</h4>' +
                                                    '<p style="font-size: 13px;">' + (product.shortDesc || '') + '</p>' +
                                                    '<p style="font-size: 13px;">Chỉ còn: <span class="text-success fw-bold">' + stockQuantity + ' sản phẩm</span></p>' +
                                                    '<div class="d-flex flex-lg-wrap justify-content-center flex-column">' +
                                                    '<p style="font-size: 15px; text-align: center; width: 100%;" class="text-dark fw-bold mb-3">' +
                                                    formattedPrice + ' đ</p>' +
                                                    '<form action="/add-product-to-cart/' + product.id + '" method="post">' +
                                                    '<input type="hidden" name="' + csrfParamName + '" value="' + (csrfToken || '') + '" />' +
                                                    '<button type="submit" class="mx-auto btn border border-secondary rounded-pill px-3 text-primary">' +
                                                    '<i class="fa fa-shopping-bag me-2 text-primary"></i>Add to cart' +
                                                    '</button>' +
                                                    '</form>' +
                                                    '</div>' +
                                                    '</div>' +
                                                    '</div>' +
                                                    '</div>';

                                                productsContainer.insertAdjacentHTML('beforeend', productHtml);
                                                const insertedElement = productsContainer.lastElementChild;
                                                if (insertedElement) {
                                                    insertedElement.classList.add('product-card-visible');
                                                    insertedElement.style.setProperty('--card-delay', `${index * 70}ms`);
                                                }
                                            });
                                            
                                            console.log('Finished displaying products. Container innerHTML length:', productsContainer.innerHTML.length);
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error searching:', error);
                                        console.error('Error stack:', error.stack);
                                        if (productsContainer) {
                                            productsContainer.innerHTML = '<div class="col-12 text-center mt-5 text-danger">Lỗi tìm kiếm sản phẩm: ' + (error.message || 'Không thể kết nối đến server') + '</div>';
                                        }
                                    });
                            });
                        });
                    </script>
                </body>

                </html>