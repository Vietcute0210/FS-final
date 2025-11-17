<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8" />
                    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
                    <title>Cập nhật thông tin</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                        rel="stylesheet"
                        integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3"
                        crossorigin="anonymous" />
                    <!-- FontAwesome for icon buttons (e.g. edit avatar) -->
                    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.15.4/css/all.css"
                        integrity="sha384-dyZt1P5/hXaYcxgfslv6mSMo7UHPuE5VCrxL71/QiG3RZnKEI2JDh5fIrJGzEVCr"
                        crossorigin="anonymous" />
                    <!-- <link
      rel="stylesheet"
      href="https://unpkg.com/cropperjs/dist/cropper.min.css"
    /> -->
                    <link rel="stylesheet" href="../css/updateProfile.css" />
                </head>

                <body>
                    <section class="d-flex justify-content-center align-items-center">
                        <div class="container">
                            <div class="row justify-content-center">
                                <div class="col-lg-8 mb-4 mb-sm-5">
                                    <a href="/">
                                        <div class="row" style="
                  width: 15%;
                  margin-right: auto;
                  margin-left: auto;
                  margin-bottom: 70px;
                ">
                                            <img src="/images/logo/logo.png" alt="" />
                                        </div>
                                    </a>
                                    <div class="card border-0">
                                        <div class="card-body">
                                            <form:form method="post" action="/update-profile"
                                                modelAttribute="updateUser" enctype="multipart/form-data">
                                                <div class="row align-items-start">
                                                    <div class="col-lg-6 mb-4 mb-lg-0">
                                                        <!-- Custom avatar uploader: preview + edit icon. The hidden input is still bound for Spring -->
                                                        <div class="avatar-uploader-custom" id="avatarUploader">
                                                            <div class="uploader-frame">
                                                                <img class="avatar-preview" alt="" />
                                                                <button type="button" class="edit-avatar-btn">
                                                                    <i class="fas fa-pen"></i>
                                                                </button>
                                                            </div>
                                                            <div class="avatar-hint">
                                                                Tối đa <b>300KB</b> • Gợi ý <b>500×650px</b>
                                                            </div>
                                                            <div class="avatar-error"></div>
                                                            <input type="file" id="avatarFile"
                                                                accept=".png, .jpg, .jpeg" name="avatarFile"
                                                                data-current-url="/images/avatar/${updateUser.avatar}" />
                                                        </div>
                                                    </div>

                                                    <div class="col-lg-6 px-xl-10">
                                                        <div
                                                            class="d-lg-inline-block py-1-9 px-1-9 px-sm-6 mb-3 rounded">
                                                            <h3 class="h2 text-primary mb-0">${user.fullName}</h3>
                                                        </div>

                                                        <div class="mb-3" style="display: none">
                                                            <label class="form-label">Id: </label>
                                                            <form:input type="text" class="form-control" path="id" />
                                                            <!-- preserve current avatar filename so backend can fall back when no file uploaded -->
                                                            <form:input type="hidden" path="avatar" />
                                                        </div>

                                                        <div class="mb-3">
                                                            <label class="form-label">Email:</label>
                                                            <form:input type="email" class="form-control" path="email"
                                                                readonly="true" />
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">Số điện thoại :</label>
                                                            <form:input type="text" class="form-control" path="phone" />
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">Địa chỉ:</label>
                                                            <form:input type="text" class="form-control"
                                                                path="address" />
                                                        </div>

                                                        <button type="submit" class="btn btn-primary">
                                                            Cập nhật
                                                        </button>
                                                    </div>
                                                </div>
                                            </form:form>
                                        </div>
                                    </div>
                                    <!-- Modal cắt avatar -->
                                    <div class="avatar-crop-modal" id="avatarCropModal">
                                        <div class="avatar-crop-dialog">
                                            <h3 class="avatar-crop-title">Cắt ảnh đại diện</h3>
                                            <div class="avatar-crop-body">
                                                <img id="avatarCropImage" alt="Avatar để cắt" />
                                            </div>
                                            <div class="avatar-crop-actions">
                                                <button type="button" id="avatarCropCancel"
                                                    class="btn btn-outline-secondary btn-sm">
                                                    Hủy
                                                </button>
                                                <button type="button" id="avatarCropApply"
                                                    class="btn btn-success btn-sm">
                                                    Áp dụng
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                    <script src="/js/scripts.js"></script>
                    <script src="/client/js/profile.js"></script>
                    <script src="https://cdnjs.cloudflare.com/ajax/libs/cropperjs/1.6.1/cropper.min.js"></script>
                    <script src="/client/js/cropper_avatar.js"></script>
                </body>

                </html>