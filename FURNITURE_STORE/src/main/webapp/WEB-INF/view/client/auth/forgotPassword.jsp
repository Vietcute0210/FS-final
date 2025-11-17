<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8" />
                <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
                <meta name="description" content="Forgot Password - FURNITURE STORE" />
                <meta name="author" content="" />
                <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
                <title>Forgot Password - FURNITURE STORE</title>
                <link rel="preload" as="image" href="/images/background/background_image_for_login.jpg">
                <link
                    href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="../css/auth-common.css">
                <link rel="stylesheet" href="../css/forgotPassword.css">
                <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script>
                <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>
                
            </head>

            <body>
                <div class="wrapper">
                    <div class="form-box">
                        <h2>🔑 Forgot Password</h2>
                        <p class="form-subtitle">
                            Enter your email address and we will send you instructions to reset your password.
                        </p>

                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success">
                                <ion-icon name="checkmark-circle"></ion-icon>
                                ${successMessage}
                            </div>
                        </c:if>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-error">
                                <ion-icon name="alert-circle"></ion-icon>
                                ${errorMessage}
                            </div>
                        </c:if>

                        <div class="info-box">
                            <ion-icon name="information-circle"></ion-icon>
                            <strong>Note:</strong> The password reset link will be valid for 24 hours and can only be
                            used once.
                        </div>

                        <form:form method="post" action="${pageContext.request.contextPath}/forgot-password"
                            modelAttribute="forgotPasswordDTO">

                            <div class="input-box">
                                <span class="icon">
                                    <ion-icon name="mail"></ion-icon>
                                </span>
                                <form:input path="email" type="email" required="required" />
                                <label>Email</label>
                            </div>
                            <form:errors path="email" cssClass="alert alert-error" />

                            <button type="submit" class="btn-submit">
                                <ion-icon name="send" style="vertical-align: middle; margin-right: 5px;"></ion-icon>
                                Send Request
                            </button>

                        </form:form>

                        <div class="back-to-login">
                            <ion-icon name="arrow-back" style="vertical-align: middle;"></ion-icon>
                            <a href="${pageContext.request.contextPath}/login">Back to login</a>
                        </div>
                    </div>
                </div>

                <script>
                    setTimeout(() => {
                        const alerts = document.querySelectorAll('.alert');
                        alerts.forEach(alert => {
                            alert.style.transition = 'opacity 0.5s';
                            alert.style.opacity = '0';
                            setTimeout(() => alert.remove(), 500);
                        });
                    }, 10000);
                </script>
            </body>

            </html>