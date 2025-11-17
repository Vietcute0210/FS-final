<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="form"
uri="http://www.springframework.org/tags/form" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
    <title>View Profile</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3"
      crossorigin="anonymous"
    />
    <link rel="stylesheet" href="../css/viewprofile.css" />
  </head>

  <body class="profile-wallpaper">
    <section class="d-flex justify-content-center align-items-center">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-lg-8">
            <div class="card">
              <div class="card-body">
                <div class="row align-items-center">
                  <!-- Avatar column -->
                  <div class="col-lg-4 text-center mb-4 mb-lg-0">
                    <img
                      src="/images/avatar/${user.avatar}"
                      alt=""
                      class="profile-img"
                    />
                  </div>
                  <!-- Info and actions -->
                  <div class="col-lg-8 profile-info">
                    <h1 class="profile-name">${user.fullName}</h1>
                    <ul class="profile-details list-unstyled mt-3">
                      <li><span>Email:</span> ${user.email}</li>
                      <li><span>Số điện thoại:</span> ${user.phone}</li>
                      <li><span>Địa chỉ:</span> ${user.address}</li>
                      <li><span>Vai trò:</span> ${user.role.name}</li>
                    </ul>
                    <!-- Action buttons in a flex container for proper alignment -->
                    <div class="button-group d-flex flex-wrap gap-3 mt-4">
                      <a
                        class="btn btn-secondary"
                        href="/update-profile/${user.id}"
                        >Cập nhật</a
                      >
                      <a class="btn btn-primary" href="/">Trở lại trang chủ</a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/client/js/profile.js"></script>
  </body>
</html>
