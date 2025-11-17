<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <meta name="description" content="Error - FURNITURE STORE" />
    <meta name="author" content="" />
    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
    <title>Error - FURNITURE STORE</title>
    <link
      rel="preload"
      as="image"
      href="/images/background/background_image_for_login.jpg"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="../css/auth-common.css" />
    <link rel="stylesheet" href="../css/resetPasswordError.css" />
    <script
      type="module"
      src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"
    ></script>
    <script
      nomodule
      src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"
    ></script>
  </head>

  <body>
    <div class="error-container">
      <div class="error-icon">
        <ion-icon name="alert-circle"></ion-icon>
      </div>

      <h1>⚠️ Invalid Link</h1>

      <p class="error-message">
        <c:choose>
          <c:when test="${not empty errorMessage}"> ${errorMessage} </c:when>
          <c:otherwise>
            The password reset link is invalid or has expired. Please request a
            new link.
          </c:otherwise>
        </c:choose>
      </p>

      <div class="button-group">
        <a
          href="${pageContext.request.contextPath}/forgot-password"
          class="btn btn-primary"
        >
          <ion-icon name="mail"></ion-icon>
          Request New Link
        </a>
        <a
          href="${pageContext.request.contextPath}/login"
          class="btn btn-secondary"
        >
          <ion-icon name="log-in"></ion-icon>
          Login
        </a>
      </div>
    </div>
  </body>
</html>
