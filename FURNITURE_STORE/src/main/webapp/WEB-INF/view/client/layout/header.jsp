<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <link rel="stylesheet" href="/client/css/header_cart.css" />
                <div class="container-fluid fixed-top header-shell">
                    <div class="container px-0">
                        <nav class="navbar navbar-expand-xl header-navbar">
                            <a href="/" class="navbar-brand header-brand d-flex align-items-center"
                                aria-label="Furniture Store - Living Inspiration" title="Furniture Store">
                                <img src="/images/logo/logo_slogan.png" alt="Furniture Store logo with slogan"
                                    class="header-brand__image" loading="lazy" />
                            </a>
                            <button class="navbar-toggler header-toggler" type="button" data-bs-toggle="collapse"
                                data-bs-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false"
                                aria-label="Toggle navigation">
                                <span class="fa fa-bars"></span>
                            </button>
                            <div class="collapse navbar-collapse header-navbar__collapse" id="navbarCollapse">
                                <div class="navbar-nav header-nav ms-lg-4">
                                    <a href="/" class="nav-item nav-link active">Trang Chủ</a>
                                    <a href="/products" class="nav-item nav-link">Sản phẩm</a>
                                </div>
                                <div class="header-actions d-flex align-items-center ms-auto">
                                    <c:if test="${not empty pageContext.request.userPrincipal}">
                                        <c:set var="cartSum"
                                            value="${sessionScope.sum != null ? sessionScope.sum : (sessionScope.cartItemCount != null ? sessionScope.cartItemCount : 0)}" />
                                        <div class="header-cart" data-mini-cart data-fetch-url="/api/cart/preview">
                                            <button type="button" class="header-icon header-cart__btn"
                                                data-mini-cart-trigger aria-haspopup="true" aria-expanded="false"
                                                aria-label="Giỏ hàng">
                                                <i class="fa fa-shopping-bag"></i>
                                                <span class="header-badge" data-mini-cart-count>${cartSum}</span>
                                            </button>
                                            <div class="mini-cart-panel" data-mini-cart-panel>
                                                <div class="mini-cart-panel__head">
                                                    <span>Sản phẩm mới thêm</span>
                                                    <span class="mini-cart-panel__total" data-mini-cart-total></span>
                                                </div>
                                                <div class="mini-cart-panel__body" data-mini-cart-body>
                                                    <p class="mini-cart-panel__empty">Chưa có sản phẩm trong giỏ hàng
                                                    </p>
                                                </div>
                                                <div class="mini-cart-panel__footer">
                                                    <a href="/cart" class="btn btn-primary w-100 btn-sm">Xem giỏ
                                                        hàng</a>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="header-user ms-3" data-user-menu>
                                            <button type="button" class="header-icon header-user__btn" data-user-trigger
                                                aria-haspopup="true" aria-expanded="false" aria-label="Tài khoản">
                                                <i class="fas fa-user"></i>
                                            </button>
                                            <div class="header-user__panel" data-user-panel>
                                                <div class="header-user__avatar">
                                                    <img src="/images/avatar/${sessionScope.avatar}"
                                                        alt="avatar người dùng" />
                                                </div>
                                                <div class="header-user__name">
                                                    <c:out value="${sessionScope.fullName1}" />
                                                </div>
                                                <div class="header-user__links">
                                                    <% if (session.getAttribute("role") !=null &&
                                                        session.getAttribute("role").equals("ADMIN")) { %>
                                                        <a class="header-user__link" href="/admin">Trang quản trị</a>
                                                        <% } %>
                                                            <a class="header-user__link" href="/view-profile">Cập nhật
                                                                thông tin cá nhân</a>
                                                            <a class="header-user__link" href="/order-history">Lịch sử
                                                                mua hàng</a>
                                                            <a class="header-user__link" href="/change-password">Đổi mật
                                                                khẩu</a>
                                                            <form method="post" action="/logout"
                                                                class="header-user__logout">
                                                                <input type="hidden" name="${_csrf.parameterName}"
                                                                    value="${_csrf.token}" />
                                                                <button type="submit">Đăng xuất</button>
                                                            </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                    <c:if test="${empty pageContext.request.userPrincipal}">
                                        <a href="/login" class="btn btn-outline-primary header-login-btn">
                                            Đăng nhập
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </nav>
                    </div>
                </div>

                <script defer src="/client/js/header_cart.js"></script>
