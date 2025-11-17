<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
                <meta name="description" content="Login to Furniture Store" />
                <meta name="author" content="" />
                <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
                <title>Login - FURNITURE STORE</title>
                <link rel="preload" as="image" href="/images/background/background_image_for_login.jpg">
                <link
                    href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="../css/auth-common.css">
                <link rel="stylesheet" href="../css/login.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
                <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>                
            </head>

            <body>
            
                <div class="wrapper ${param.register != null ? 'active' : ''}">
                    <!-- Login -->
                    <div class="form-box login">
                        <h2>Login</h2>
                        <form method="post" action="/login">
                            <div class="input-box">
                                <span class="icon"><ion-icon name="mail"></ion-icon></span>
                                <input type="email" name="username" required placeholder=" " />
                                <label>Email</label>
                            </div>
                            <div class="input-box">
                                <span class="icon"><ion-icon name="lock-closed"></ion-icon></span>
                                <input type="password" name="password" required placeholder=" " />
                                <label>Password</label>
                            </div>

                            <c:if test="${param.error != null}">
                                <div class="error-message">Invalid email or password.</div>
                            </c:if>

                            <c:if test="${param.logout != null}">
                                <div class="success-message">Logout Success</div>
                            </c:if>

                            <c:if test="${param.resetSuccess != null}">
                                <div class="success-message">Password reset successfully! You can now login.</div>
                            </c:if>

                            <c:if test="${param.registerSuccess != null}">
                                <div class="success-message">Registration successful! You can now login.</div>
                            </c:if>

                            <c:if test="${param.error1 != null}">
                                <div class="error-message">${fn:escapeXml(param.error1)}</div>
                            </c:if>

                            <div class="remember">
                                <label><input type="checkbox" name="remember-me">Remember me</label>
                            <a href="${pageContext.request.contextPath}/forgot-password" class="small-link">Forgot password?</a>
                            </div>

                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                            <button type="submit" class="btn-form">
                                <span>Login</span>
                            </button>

                            <div class="login-register">
                                <p>Don't have an account? <a href="/register">Register</a></p>
                            </div>
                        </form>
                        <div class="oauth-divider">HOẶC</div>
                        
                        <a href="/oauth2/authorization/google" class="google-login-btn">
                            <i class="fa-brands fa-google"></i>
                            Đăng nhập với Google
                        </a>
                    </div>

                    <!-- Register -->
                    <div class="form-box register">
                        <h2>Registration</h2>
                        <p style="text-align: center; color: #555; margin-bottom: 20px;">
                            Already have an account? <a href="/login" style="color: var(--accent-color);">Login here</a>
                        </p>
                    </div>
                </div>
            </body>

            </html>