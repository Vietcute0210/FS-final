<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="form"
uri="http://www.springframework.org/tags/form" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Change Password</title>
    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
    <link
      rel="preload"
      as="image"
      href="/images/background/background_image_for_login.jpg"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3"
      crossorigin="anonymous"
    />
    <link rel="stylesheet" href="../css/changePassword.css" />
  </head>

  <body>
    <div class="container d-flex justify-content-center align-items-center">
      <div class="col-lg-6">
        <div class="card">
          <div class="card-header">
            <h3>Đổi mật khẩu</h3>
          </div>
          <div class="card-body">
            <form:form
              method="post"
              action="/change-password"
              modelAttribute="changePasswordDTO"
            >
              <form:hidden path="userId" />
              <div class="mb-3">
                <label class="form-label">Mật khẩu hiện tại</label>
                <form:input
                  type="password"
                  class="form-control"
                  path="oldPassword"
                  placeholder="Vui lòng nhập mật khẩu hiện tại"
                />
                <c:if test="${not empty errorOldPassword}">
                  <div class="error mt-2">${errorOldPassword}</div>
                </c:if>
              </div>
              <div class="mb-3">
                <label class="form-label">Mật khẩu mới</label>
                <form:input
                  type="password"
                  class="form-control"
                  path="newPassword"
                  placeholder="Vui lòng nhập mật khẩu mới"
                />
                <c:if test="${not empty errorNewpassword}">
                  <div class="error mt-2">${errorNewPassword}</div>
                </c:if>
              </div>
              <div class="text-center">
                <button type="submit" class="btn btn-primary btn-block">
                  Đổi mật khẩu
                </button>
              </div>
            </form:form>
          </div>
        </div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
