<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="form"
uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <meta name="description" content="Register for Furniture Store" />
    <meta name="author" content="" />
    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
    <title>Register - FURNITURE STORE</title>
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
    <link rel="stylesheet" href="../css/register.css" />
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
    <div class="wrapper">
      <div class="form-box register">
        <h2>Registration</h2>
        <form method="post" action="/register">
          <div class="name-row">
            <div class="input-box">
              <span class="icon"><ion-icon name="person"></ion-icon></span>
              <input
                type="text"
                name="firstName"
                required
                placeholder=" "
                value="${registerUser.firstName != null ? registerUser.firstName : ''}"
                class="${not empty errorFirstName ? 'is-invalid' : ''}"
              />
              <label>First Name</label>
            </div>
            <div class="input-box">
              <span class="icon"><ion-icon name="people"></ion-icon></span>
              <input
                type="text"
                name="lastName"
                required
                placeholder=" "
                value="${registerUser.lastName != null ? registerUser.lastName : ''}"
                class="${not empty errorLastName ? 'is-invalid' : ''}"
              />
              <label>Last Name</label>
            </div>
          </div>

          <c:if test="${not empty errorFirstName}">
            <div class="error-message">${errorFirstName}</div>
          </c:if>
          <c:if test="${not empty errorLastName}">
            <div class="error-message">${errorLastName}</div>
          </c:if>

          <div class="input-box">
            <span class="icon"><ion-icon name="mail"></ion-icon></span>
            <input
              type="email"
              name="email"
              required
              placeholder=" "
              value="${registerUser.email != null ? registerUser.email : ''}"
              class="${not empty errorEmail ? 'is-invalid' : ''}"
            />
            <label>Email</label>
          </div>
          <c:if test="${not empty errorEmail}">
            <div class="error-message">${errorEmail}</div>
          </c:if>

          <div class="input-box">
            <span class="icon" onclick="togglePassword('password')">
              <ion-icon name="eye" id="togglePassword"></ion-icon>
            </span>
            <input
              type="password"
              name="password"
              id="password"
              required
              placeholder=" "
              class="${not empty errorPassword ? 'is-invalid' : ''}"
            />
            <label>Password</label>
          </div>
          <c:if test="${not empty errorPassword}">
            <div class="error-message">${errorPassword}</div>
          </c:if>

          <div class="input-box">
            <span class="icon" onclick="togglePassword('confirmPassword')">
              <ion-icon name="eye" id="toggleConfirmPassword"></ion-icon>
            </span>
            <input
              type="password"
              name="confirmPassword"
              id="confirmPassword"
              required
              placeholder=" "
            />
            <label>Confirm Password</label>
          </div>

          <input
            type="hidden"
            name="${_csrf.parameterName}"
            value="${_csrf.token}"
          />

          <button type="submit" class="btn-form">
            <span>Register</span>
          </button>

          <div class="login-register">
            <p>Already have an account? <a href="/login">Login</a></p>
          </div>
        </form>
      </div>
    </div>

    <script>
      function togglePassword(fieldId) {
        const field = document.getElementById(fieldId);
        const icon = document.getElementById(
          "toggle" + fieldId.charAt(0).toUpperCase() + fieldId.slice(1)
        );

        if (field.type === "password") {
          field.type = "text";
          icon.setAttribute("name", "eye-off");
        } else {
          field.type = "password";
          icon.setAttribute("name", "eye");
        }
      }
    </script>
  </body>
</html>
