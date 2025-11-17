document.addEventListener("DOMContentLoaded", () => {
  const fadeEls = document.querySelectorAll(".fade-up");
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) entry.target.classList.add("visible");
      });
    },
    { threshold: 0.2 }
  );
  fadeEls.forEach((el) => observer.observe(el));

  // Add to cart animation
  // const btn = document.querySelector(".btnAddToCartDetail");
  // if (btn) {
  //   btn.addEventListener("click", () => {
  //     $.toast({
  //       heading: "Đã thêm vào giỏ hàng",
  //       text: "Sản phẩm của bạn đã được thêm thành công!",
  //       showHideTransition: "slide",
  //       icon: "success",
  //       position: "bottom-right",
  //     });
  //   });
  // }

  const detailForm = document.querySelector(".product-detail-cart-form");
  if (detailForm) {
    const visibleInput = detailForm.querySelector("[data-cart-detail-index]");
    const hiddenInput = detailForm.querySelector('input[name="quantity"]');
    const quantityButtons = detailForm.querySelectorAll(".quantity button");

    const clampQuantity = (value) => {
      const parsed = parseInt(value, 10);
      if (!Number.isFinite(parsed) || parsed <= 0) {
        return 1;
      }
      return parsed;
    };

    const syncQuantity = () => {
      if (!visibleInput || !hiddenInput) return;
      const safeValue = clampQuantity(visibleInput.value);
      visibleInput.value = safeValue;
      hiddenInput.value = safeValue;
      return safeValue;
    };

    const queueSync = () => requestAnimationFrame(syncQuantity);

    if (visibleInput && hiddenInput) {
      visibleInput.addEventListener("input", queueSync);
      visibleInput.addEventListener("blur", syncQuantity);
      detailForm.addEventListener("submit", syncQuantity);
      quantityButtons.forEach((button) => {
        button.addEventListener("click", queueSync);
      });
    }
  }

  initProductMediaGallery();
});

function initProductMediaGallery() {
  const gallery = document.querySelector(".product-media-gallery");
  if (!gallery) return;

  const viewerImage = gallery.querySelector(".product-media-viewer__image");
  const viewerVideo = gallery.querySelector(".product-media-viewer__video");
  const thumbs = Array.from(gallery.querySelectorAll(".media-thumb"));
  const prevBtn = gallery.querySelector(".gallery-nav--prev");
  const nextBtn = gallery.querySelector(".gallery-nav--next");
  const interval = Number(gallery.dataset.interval || 0) || 2000;
  const shouldAutoplay = gallery.dataset.autoplay === "true";

  let currentIndex = 0;
  let autoplayTimer = null;

  const stopAutoplay = () => {
    if (!autoplayTimer) return;
    clearInterval(autoplayTimer);
    autoplayTimer = null;
  };

  const setActiveMedia = (index) => {
    if (!thumbs.length) return;
    currentIndex = (index + thumbs.length) % thumbs.length;
    thumbs.forEach((thumb, idx) =>
      thumb.classList.toggle("active", idx === currentIndex)
    );

    const targetThumb = thumbs[currentIndex];
    const mediaType = targetThumb.dataset.mediaType || "image";
    const mediaSrc = targetThumb.dataset.mediaSrc || "";

    if (mediaType === "video" && mediaSrc) {
      stopAutoplay();
      if (viewerImage) viewerImage.classList.add("is-hidden");
      if (viewerVideo) {
        viewerVideo.classList.add("is-active");
        viewerVideo.src = mediaSrc;
        viewerVideo.load();
        viewerVideo.currentTime = 0;
        viewerVideo.play().catch(() => {});
      }
      return;
    }

    if (viewerVideo) {
      viewerVideo.pause();
      viewerVideo.classList.remove("is-active");
      viewerVideo.removeAttribute("src");
      viewerVideo.load();
    }

    if (viewerImage) {
      viewerImage.classList.remove("is-hidden");
      if (mediaSrc) viewerImage.src = mediaSrc;
    }
  };

  const showNext = () => setActiveMedia(currentIndex + 1);
  const showPrev = () => setActiveMedia(currentIndex - 1);

  const startAutoplay = () => {
    if (!shouldAutoplay || thumbs.length <= 1) return;
    stopAutoplay();
    autoplayTimer = setInterval(() => {
      showNext();
    }, interval);
  };

  const restartAutoplay = () => {
    stopAutoplay();
    startAutoplay();
  };

  thumbs.forEach((thumb, idx) => {
    thumb.addEventListener("click", () => {
      setActiveMedia(idx);
      restartAutoplay();
    });
  });

  if (prevBtn)
    prevBtn.addEventListener("click", () => {
      showPrev();
      restartAutoplay();
    });

  if (nextBtn)
    nextBtn.addEventListener("click", () => {
      showNext();
      restartAutoplay();
    });

  gallery.addEventListener("mouseenter", stopAutoplay);
  gallery.addEventListener("mouseleave", startAutoplay);

  setActiveMedia(0);
  startAutoplay();
}
