(function (window, document) {
  const CartCommon = {
    resolveCsrfHeaders,
    addToCart,
    updateCartBadge,
    showToast,
  };

  let cachedCsrf = null;

  function resolveCsrfHeaders() {
    if (cachedCsrf) {
      return cachedCsrf;
    }
    const tokenMeta = document.querySelector('meta[name="_csrf"]');
    const headerMeta = document.querySelector('meta[name="_csrf_header"]');
    if (!tokenMeta || !headerMeta) {
      return null;
    }
    const token = tokenMeta.getAttribute("content") || "";
    const header = headerMeta.getAttribute("content") || "";
    if (!token || !header) {
      return null;
    }
    cachedCsrf = { token, header };
    return cachedCsrf;
  }

  function updateCartBadge(sum) {
    const parsed = typeof sum === "number" ? sum : parseInt(sum, 10);
    const safeValue = Number.isFinite(parsed) && parsed >= 0 ? parsed : 0;
    const badges = document.querySelectorAll("[data-mini-cart-count]");
    badges.forEach((badge) => {
      badge.textContent = safeValue;
    });
  }

  async function addToCart({ productId, quantity = 1 } = {}) {
    if (!productId) {
      return Promise.reject(new Error("Missing productId"));
    }
    const csrf = resolveCsrfHeaders();
    const response = await fetch("/api/add-product-to-cart", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        ...(csrf ? { [csrf.header]: csrf.token } : {}),
      },
      credentials: "same-origin",
      body: JSON.stringify({
        productId,
        quantity,
      }),
    });

    if (response.status === 401 || response.status === 403) {
      showToast(
        "Can dang nhap",
        "Vui long dang nhap de tiep tuc mua sam.",
        "info"
      );
      const error = new Error("unauthorized");
      error.cartHandled = true;
      window.location.href = "/login";
      throw error;
    }

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const sum = await response.json();
    updateCartBadge(sum);
    document.dispatchEvent(
      new CustomEvent("cart:refresh", { detail: { sum } })
    );
    return sum;
  }

  function showToast(heading, text, icon = "success") {
    if (window.$ && typeof window.$.toast === "function") {
      window.$.toast({
        heading,
        text,
        showHideTransition: "slide",
        icon,
        position: "bottom-right",
      });
    } else {
      console.log(`[${icon}] ${heading}: ${text}`);
    }
  }

  window.CartCommon = Object.assign({}, window.CartCommon || {}, CartCommon);
})(window, document);
