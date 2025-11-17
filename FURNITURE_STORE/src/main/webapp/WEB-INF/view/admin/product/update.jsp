<%@page contentType="text/html" pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="form"
uri="http://www.springframework.org/tags/form" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />
    <meta name="description" content="Furniture Store" />
    <meta name="author" content="Furniture Store" />
    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
    <title>Update Product - Furniture Store</title>
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="/css/custom.css" rel="stylesheet" />
    <link href="/css/admin.css" rel="stylesheet" />
    <link href="/css/admin-product-media.css" rel="stylesheet" />
    <script
      src="https://use.fontawesome.com/releases/v6.3.0/js/all.js"
      crossorigin="anonymous"
    ></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <script>
      $(document).ready(() => {
        const mediaInput = $("#mediaFiles");
        const mediaList = $("#mediaFilesList");
        const mediaMessage = $("#mediaFilesMessage");
        const maxFiles = 5;

        if (!mediaInput.length) {
          return;
        }

        const renderFiles = (files) => {
          mediaList.empty();
          files.slice(0, maxFiles).forEach((file) => {
            const badge = `<span class="badge bg-secondary me-1 mb-1">${file.name}</span>`;
            mediaList.append(badge);
          });
          if (files.length > maxFiles) {
            mediaMessage.text(`Chỉ sử dụng ${maxFiles} file đầu tiên.`);
          } else {
            mediaMessage.text("");
          }
        };

        mediaInput.on("change", () => {
          const files = Array.from(mediaInput[0].files || []);
          renderFiles(files);
        });
      });
    </script>
  </head>

  <body class="sb-nav-fixed">
    <jsp:include page="../layout/header.jsp" />

    <div id="layoutSidenav">
      <jsp:include page="../layout/sidebar.jsp" />
      <div id="layoutSidenav_content">
        <main>
          <div class="container-fluid px-4">
            <h1 class="mt-4">Products</h1>
            <div class="mb-3">
              <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                  <li class="breadcrumb-item">
                    <a href="/admin">Dashboard</a>
                  </li>
                  <li class="breadcrumb-item">
                    <a href="/admin/product">Product</a>
                  </li>
                  <li class="breadcrumb-item active" aria-current="page">
                    Update
                  </li>
                </ol>
              </nav>
            </div>
          </div>
          <div class="container mt-5">
            <div class="row">
              <div class="col-md-6 col-12 mx-auto">
                <h3>Update a product</h3>
                <hr />
                <form:form
                  method="post"
                  action="/admin/product/update/${newProduct.id}"
                  class="row"
                  enctype="multipart/form-data"
                  modelAttribute="newProduct"
                >
                  <c:set var="errorName">
                    <form:errors path="name" cssClass="invalid-feedback" />
                  </c:set>
                  <c:set var="errorPrice">
                    <form:errors path="price" cssClass="invalid-feedback" />
                  </c:set>
                  <c:set var="errorDetailDesc">
                    <form:errors
                      path="detailDesc"
                      cssClass="invalid-feedback"
                    />
                  </c:set>
                  <c:set var="errorShortDesc">
                    <form:errors path="shortDesc" cssClass="invalid-feedback" />
                  </c:set>
                  <c:set var="errorQuantity">
                    <form:errors path="quantity" cssClass="invalid-feedback" />
                  </c:set>

                  <div class="mb-3" style="display: none">
                    <label class="form-label">Id:</label>
                    <form:input type="text" class="form-control" path="id" />
                  </div>

                  <div class="mb-3 col-12 col-md-6">
                    <label class="form-label">Name:</label>
                    <form:input
                      type="text"
                      class="form-control ${not empty errorName ? 'is-invalid' : ''}"
                      path="name"
                    />
                    ${errorName}
                  </div>
                  <div class="mb-3 col-12 col-md-6">
                    <label class="form-label">Price:</label>
                    <form:input
                      type="number"
                      class="form-control ${not empty errorPrice ? 'is-invalid' : ''}"
                      path="price"
                    />
                    ${errorPrice}
                  </div>
                  <div class="mb-3 col-12">
                    <label class="form-label">Detail description:</label>
                    <form:textarea
                      type="text"
                      class="form-control ${not empty errorDetailDesc ? 'is-invalid' : ''}"
                      path="detailDesc"
                    />
                    ${errorDetailDesc}
                  </div>
                  <div class="mb-3 col-12 col-md-6">
                    <label class="form-label">Short description:</label>
                    <form:input
                      type="text"
                      class="form-control ${not empty errorShortDesc ? 'is-invalid' : ''}"
                      path="shortDesc"
                    />
                    ${errorShortDesc}
                  </div>
                  <div class="mb-3 col-12 col-md-6">
                    <label class="form-label">Quantity:</label>
                    <form:input
                      type="number"
                      class="form-control ${not empty errorQuantity ? 'is-invalid' : ''}"
                      path="quantity"
                    />
                    ${errorQuantity}
                  </div>

                  <div class="mb-3 col-12 col-md-6">
                    <label class="form-label">Factory:</label>
                    <form:select class="form-select" path="factory">
                      <form:option value="CTY1">CTY1</form:option>
                      <form:option value="CTY2">CTY2</form:option>
                      <form:option value="CTY3">CTY3</form:option>
                      <form:option value="CTY4">CTY4</form:option>
                    </form:select>
                  </div>
                  <div class="mb-3 col-12 col-md-6">
                    <label class="form-label">Target:</label>
                    <form:select class="form-select" path="target">
                      <form:option value="LOAI1">LOAI1</form:option>
                      <form:option value="LOAI2">LOAI2</form:option>
                      <form:option value="LOAI3">LOAI3</form:option>
                    </form:select>
                  </div>
                  <div class="mb-3 col-12">
                    <label class="form-label d-block"
                      >Image/Video (max 5)</label
                    >
                    <div id="mediaManager" class="media-manager">
                      <div class="media-manager-header">
                        <span class="media-manager-title">Media gallery</span>
                        <button
                          type="button"
                          id="mediaManagerAdd"
                          class="btn btn-success btn-sm"
                        >
                          Add new
                        </button>
                      </div>
                      <div class="media-manager-list"></div>
                      <div class="media-manager-empty">
                        No files yet. Click "Add new" to start.
                      </div>
                      <div class="media-manager-limit" style="display: none">
                        Only up to 5 files are supported.
                      </div>
                    </div>
                    <small class="form-text text-muted">
                      Supported formats: JPG, PNG, GIF, MP4, WebM. Selected
                      files show in a row you can change or delete before
                      submit.
                    </small>
                  </div>

                  <c:if test="${not empty newProduct.medias}">
                    <div class="mb-3 col-12">
                      <p class="fw-semibold mb-2">Hình/Video hiện có:</p>
                      <div class="d-flex flex-wrap gap-2">
                        <c:forEach var="media" items="${newProduct.medias}">
                          <div
                            class="border rounded p-2 text-center"
                            style="width: 90px; height: 90px; overflow: hidden"
                          >
                            <c:choose>
                              <c:when
                                test="${media.mediaType.name() == 'VIDEO'}"
                              >
                                <i
                                  class="fa fa-play-circle fa-2x text-warning"
                                ></i>
                                <small>Video</small>
                              </c:when>
                              <c:otherwise>
                                <img
                                  class="img-fluid"
                                  src="/images/product/${newProduct.id}/${media.fileName}"
                                  alt="${newProduct.name} gallery"
                                  onerror="this.onerror=null; this.src='/images/product/${media.fileName}';"
                                  style="min-height: 100%; object-fit: cover"
                                />
                              </c:otherwise>
                            </c:choose>
                          </div>
                        </c:forEach>
                      </div>
                    </div>
                  </c:if>
                  <div class="col-12 mb-5">
                    <button type="submit" class="btn btn-warning">
                      Update
                    </button>
                  </div>
                </form:form>
              </div>
            </div>
          </div>
        </main>
        <jsp:include page="../layout/footer.jsp" />
      </div>
    </div>
    <script
      src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
      crossorigin="anonymous"
    ></script>
    <script src="js/scripts.js"></script>
    <script src="/js/admin-product-media.js"></script>
    <script src="js/admin.js"></script>
  </body>
</html>
