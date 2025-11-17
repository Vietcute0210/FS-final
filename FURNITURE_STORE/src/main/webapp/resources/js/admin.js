// admin.js
// Theme chung cho admin: User / Product / Order
// - Thêm .admin-card cho khối chính (form, list, delete)
// - Làm đẹp card detail
// - Highlight lỗi validation
// - Preview ảnh (create / update)

(function ($) {
  "use strict";

  $(function () {
    // 1. Tìm các khối chính trong mọi trang admin
    var $mainCards = $(
      // trong container mt-5
      '.sb-nav-fixed #layoutSidenav_content main .mt-5 .row > [class*="col-"].mx-auto,' +
        // trong container chuẩn
        '.sb-nav-fixed #layoutSidenav_content main .container .row > [class*="col-"].mx-auto,' +
        // trong container-fluid (order, product delete,...)
        '.sb-nav-fixed #layoutSidenav_content main .container-fluid .row > [class*="col-"].mx-auto'
    );

    $mainCards.addClass("admin-card");

    // 2. Card detail: card đứng riêng, không nằm trong bảng
    var $detailCards = $(
      ".sb-nav-fixed #layoutSidenav_content main .card"
    ).filter(function () {
      var $card = $(this);
      if ($card.closest("table").length) return false;
      // Ưu tiên card có ảnh hoặc list-group => kiểu detail
      return $card.find("img").length || $card.find(".list-group").length;
    });

    $detailCards.addClass("admin-detail-card");

    // 3. Nút BACK (cho user / product / order)
    $('a[class*="btn"]').each(function () {
      var $btn = $(this);
      var href = $btn.attr("href") || "";
      if (!href.startsWith("/admin/")) return;

      // các trang list chung: /admin/user, /admin/product, /admin/order
      if (
        href === "/admin/user" ||
        href === "/admin/product" ||
        href === "/admin/order"
      ) {
        $btn.addClass("admin-back-btn");
      }
    });

    // 4. Group có lỗi validation (.invalid-feedback) => thêm .admin-has-error
    $(".admin-card")
      .find(".invalid-feedback")
      .each(function () {
        var $feedback = $(this);
        var $group = $feedback.closest(
          ".mb-3, .mb-4, .mb-2, .col-12, .col-md-6"
        );
        $group.addClass("admin-has-error");
      });

    // 5. Preview ảnh cho form create / update
    function bindPreview(inputSelector, imgSelector) {
      var $input = $(inputSelector);
      var $img = $(imgSelector);

      if (!$input.length || !$img.length) {
        return;
      }

      $img.addClass("admin-preview");

      var currentSrc = $img.attr("src");
      if (currentSrc && currentSrc.trim() !== "") {
        $img.show();
      }

      $input.on("change", function (e) {
        var file = e.target.files && e.target.files[0];
        if (!file) return;

        var url = URL.createObjectURL(file);
        $img.attr("src", url).show();
      });
    }

    // Product create
    bindPreview("#productFile", "#productPreview");
    // Product update
    bindPreview("#avatarFile", "#avatarPreview");

    // Nếu sau này có thêm user/order dùng id khác, chỉ cần thêm:
    // bindPreview("#userAvatarFile", "#userAvatarPreview");
    // bindPreview("#orderImageFile", "#orderImagePreview");
  });
})(jQuery);
