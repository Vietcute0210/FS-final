<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="utf-8" />
                    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
                    <meta name="description" content="Furniture Store" />
                    <meta name="author" content="Furniture Store" />
                    <link rel="icon" type="image/png" href="/images/logo/logo_icon.png" />
                    <title>${user.fullName} - Furniture Store</title>
                    <link href="/css/styles.css" rel="stylesheet" />
                    <link href="/css/custom.css" rel="stylesheet" />
                    <link href="/css/admin.css" rel="stylesheet" />
                    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js"
                        crossorigin="anonymous"></script>

                    <script>
                        $(document).ready(() => {
                            const avatarFile = $("#avatarFile");
                            avatarFile.change(function (e) {
                                const imgURL = URL.createObjectURL(e.target.files[0]);
                                $("#avatarPreview").attr("src", imgURL);
                                $("#avatarPreview").css({ display: "block" });
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
                                    <h1 class="mt-4">Users</h1>
                                    <div class="mb-3">
                                        <nav aria-label="breadcrumb">
                                            <ol class="breadcrumb">
                                                <li class="breadcrumb-item">
                                                    <a href="/admin">Dashboard</a>
                                                </li>
                                                <li class="breadcrumb-item">
                                                    <a href="/admin/user">User</a>
                                                </li>
                                                <li class="breadcrumb-item active" aria-current="page">
                                                    View detail
                                                </li>
                                            </ol>
                                        </nav>
                                    </div>
                                </div>
                                <div class="container mt-5">
                                    <div class="row">
                                        <div class="col-12 mx-auto">
                                            <div class="d-flex justify-content-between">
                                                <h3>User Details with id = ${id}</h3>
                                            </div>
                                            <hr />
                                            <div class="card" style="width: 60%">
                                                <img src="/images/avatar/${user.avatar}" alt="avatar-preview" />
                                                <div class="card-header">User Information</div>
                                                <ul class="list-group list-group-flush">
                                                    <li class="list-group-item">ID : ${id}</li>
                                                    <li class="list-group-item">Email : ${user.email}</li>
                                                    <li class="list-group-item">FullName : ${user.fullName}</li>
                                                    <li class="list-group-item">Address : ${user.address}</li>
                                                    <li class="list-group-item">Role : ${user.role.name}</li>
                                                </ul>
                                            </div>
                                            <a href="/admin/user" class="btn btn-success">BACK</a>
                                        </div>
                                    </div>
                                </div>
                            </main>
                            <jsp:include page="../layout/footer.jsp" />
                        </div>
                    </div>
                    <jsp:include page="../layout/footer.jsp" />

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
                        crossorigin="anonymous"></script>
                    <script src="/js/scripts.js"></script>
                    <script src="/js/admin.js"></script>
                </body>

                </html>