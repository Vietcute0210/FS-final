<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="form"
uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <meta name="description" content="Reset Password - FURNITURE STORE" />
    <meta name="author" content="" />
    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
    <title>Reset Password - FURNITURE STORE</title>
    <link
      rel="preload"
      as="image"
      href="/images/background/background_image_for_login.jpg"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800;900&display=swap"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="../css/resetPassword.css" />
    <link rel="stylesheet" href="../css/auth-common.css" />
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
      <div class="form-box">
        <h2>🔐 Reset Password</h2>
        <p class="form-subtitle">Please enter your new password.</p>

        <c:if test="${not empty errorMessage}">
          <div class="alert alert-error">
            <ion-icon name="alert-circle"></ion-icon>
            ${errorMessage}
          </div>
        </c:if>

        <form:form
          method="post"
          action="${pageContext.request.contextPath}/reset-password"
          modelAttribute="resetPasswordDTO"
        >
          <!-- Token được gửi qua hidden field của Spring Form -->
          <form:hidden path="token" />

          <div class="input-box">
            <span class="icon" onclick="togglePassword('newPassword')">
              <ion-icon name="eye" id="toggleNewPassword"></ion-icon>
            </span>
            <form:input
              path="newPassword"
              type="password"
              id="newPassword"
              required="required"
            />
            <label>New Password</label>
          </div>

          <div class="input-box">
            <span class="icon" onclick="togglePassword('confirmPassword')">
              <ion-icon name="eye" id="toggleConfirmPassword"></ion-icon>
            </span>
            <form:input
              path="confirmPassword"
              type="password"
              id="confirmPassword"
              required="required"
            />
            <label>Confirm Password</label>
          </div>

          <div class="password-strength">
            <strong>Password Requirements:</strong>
            <ul id="password-requirements">
              <li id="req-length" class="invalid">
                <ion-icon name="close-circle"></ion-icon> Minimum 6 characters
              </li>
              <li id="req-lowercase" class="invalid">
                <ion-icon name="close-circle"></ion-icon> At least one lowercase
                letter
              </li>
              <li id="req-uppercase" class="invalid">
                <ion-icon name="close-circle"></ion-icon> At least one uppercase
                letter
              </li>
              <li id="req-number" class="invalid">
                <ion-icon name="close-circle"></ion-icon> At least one number
              </li>
            </ul>
          </div>

          <button type="submit" class="btn-submit">
            <ion-icon
              name="lock-closed"
              style="vertical-align: middle; margin-right: 5px"
            ></ion-icon>
            Reset Password
          </button>
        </form:form>

        <div class="back-to-login">
          <ion-icon name="arrow-back" style="vertical-align: middle"></ion-icon>
          <a href="${pageContext.request.contextPath}/login">Back to login</a>
        </div>
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

      const passwordInput = document.getElementById("newPassword");
      const reqLength = document.getElementById("req-length");
      const reqLowercase = document.getElementById("req-lowercase");
      const reqUppercase = document.getElementById("req-uppercase");
      const reqNumber = document.getElementById("req-number");

      passwordInput.addEventListener("input", function () {
        const password = this.value;

        if (password.length >= 6) {
          reqLength.classList.remove("invalid");
          reqLength.classList.add("valid");
          reqLength
            .querySelector("ion-icon")
            .setAttribute("name", "checkmark-circle");
        } else {
          reqLength.classList.remove("valid");
          reqLength.classList.add("invalid");
          reqLength
            .querySelector("ion-icon")
            .setAttribute("name", "close-circle");
        }

        if (/[a-z]/.test(password)) {
          reqLowercase.classList.remove("invalid");
          reqLowercase.classList.add("valid");
          reqLowercase
            .querySelector("ion-icon")
            .setAttribute("name", "checkmark-circle");
        } else {
          reqLowercase.classList.remove("valid");
          reqLowercase.classList.add("invalid");
          reqLowercase
            .querySelector("ion-icon")
            .setAttribute("name", "close-circle");
        }

        if (/[A-Z]/.test(password)) {
          reqUppercase.classList.remove("invalid");
          reqUppercase.classList.add("valid");
          reqUppercase
            .querySelector("ion-icon")
            .setAttribute("name", "checkmark-circle");
        } else {
          reqUppercase.classList.remove("valid");
          reqUppercase.classList.add("invalid");
          reqUppercase
            .querySelector("ion-icon")
            .setAttribute("name", "close-circle");
        }

        if (/[0-9]/.test(password)) {
          reqNumber.classList.remove("invalid");
          reqNumber.classList.add("valid");
          reqNumber
            .querySelector("ion-icon")
            .setAttribute("name", "checkmark-circle");
        } else {
          reqNumber.classList.remove("valid");
          reqNumber.classList.add("invalid");
          reqNumber
            .querySelector("ion-icon")
            .setAttribute("name", "close-circle");
        }
      });

      // Form validation on submit
      document.querySelector("form").addEventListener("submit", function (e) {
        const newPassword = document.getElementById("newPassword").value;
        const confirmPassword =
          document.getElementById("confirmPassword").value;

        // Check if passwords match
        if (newPassword !== confirmPassword) {
          e.preventDefault();
          alert("Passwords do not match. Please try again.");
          return false;
        }

        if (newPassword.length < 6) {
          e.preventDefault();
          alert("Password must be at least 6 characters long.");
          return false;
        }

        if (!/[a-z]/.test(newPassword)) {
          e.preventDefault();
          alert("Password must contain at least one lowercase letter.");
          return false;
        }

        if (!/[A-Z]/.test(newPassword)) {
          e.preventDefault();
          alert("Password must contain at least one uppercase letter.");
          return false;
        }

        if (!/[0-9]/.test(newPassword)) {
          e.preventDefault();
          alert("Password must contain at least one number.");
          return false;
        }
      });
    </script>
  </body>
</html>
