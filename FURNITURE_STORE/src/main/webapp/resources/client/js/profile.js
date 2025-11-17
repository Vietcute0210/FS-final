(function () {
  // Maximum allowed file size (300 KB)
  const MAX_SIZE = 300 * 1024;
  // Allowed MIME types
  const ACCEPTED_TYPES = ["image/jpeg", "image/png", "image/webp"];

  function setupAvatarUploader(container) {
    const fileInput = container.querySelector('input[type="file"]');
    const previewImg = container.querySelector(".avatar-preview");
    const hintEl = container.querySelector(".avatar-hint");
    const errorEl = container.querySelector(".avatar-error");
    const editBtn = container.querySelector(".edit-avatar-btn");
    const frame = container.querySelector(".uploader-frame");

    if (!fileInput || !previewImg || !frame) return;

    // Show initial avatar if provided via data-current-url
    const initialUrl = fileInput.getAttribute("data-current-url");
    if (initialUrl) {
      previewImg.src = initialUrl;
      previewImg.style.display = "block";
    }

    // Trigger file selection when clicking on frame or edit button
    const openFilePicker = () => {
      fileInput.click();
    };
    frame.addEventListener("click", openFilePicker);
    if (editBtn) {
      editBtn.addEventListener("click", function (e) {
        e.preventDefault();
        e.stopPropagation();
        openFilePicker();
      });
    }

    // Handle file selection
    fileInput.addEventListener("change", function () {
      const file = fileInput.files && fileInput.files[0];
      if (!file) return;

      // Validate MIME type
      if (!ACCEPTED_TYPES.includes(file.type)) {
        if (errorEl) {
          errorEl.textContent = "Chỉ nhận hình JPG/PNG/WebP";
          errorEl.style.display = "block";
        }
        return;
      }

      // Validate file size
      if (file.size > MAX_SIZE) {
        if (errorEl) {
          const kb = Math.round(file.size / 1024);
          const maxKb = Math.round(MAX_SIZE / 1024);
          errorEl.textContent = `Ảnh quá lớn (${kb}KB) — tối đa ${maxKb}KB`;
          errorEl.style.display = "block";
        }
        return;
      }

      // Clear any previous error
      if (errorEl) errorEl.style.display = "none";

      // Preview the selected image
      const url = URL.createObjectURL(file);
      previewImg.src = url;
      previewImg.style.display = "block";
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    const uploaders = document.querySelectorAll(".avatar-uploader-custom");
    uploaders.forEach(setupAvatarUploader);
  });
})();
