<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="form"
uri="http://www.springframework.org/tags/form" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
    <title>Password Changed Successfully</title>
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
    <link rel="stylesheet" href="../css/changePasswordSuccess.css" />
  </head>

  <body>
    <div class="container">
      <div class="card">
        <div class="success-icon">&#10003;</div>
        <h2 class="text-success mt-3">Thay đổi mật khẩu thành công!</h2>
        <p>
          Mật khẩu của bạn đã được cập nhật thành công. Bây giờ bạn có thể sử
          dụng mật khẩu mới.
        </p>
        <a href="/" class="btn btn-success">Trở về trang chủ</a>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
