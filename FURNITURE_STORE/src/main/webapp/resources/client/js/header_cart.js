(function () {
  function initUserMenu() {
    const root = document.querySelector("[data-user-menu]");
    if (!root) {
      return;
    }
    const trigger = root.querySelector("[data-user-trigger]");
    const panel = root.querySelector("[data-user-panel]");
    if (!trigger || !panel) {
      return;
    }

    let hideTimer;

    const open = () => {
      clearTimeout(hideTimer);
      root.classList.add("is-open");
      trigger.setAttribute("aria-expanded", "true");
    };

    const close = () => {
      hideTimer = setTimeout(() => {
        root.classList.remove("is-open");
        trigger.setAttribute("aria-expanded", "false");
      }, 120);
    };

    trigger.addEventListener("mouseenter", open);
    trigger.addEventListener("focus", open);
    root.addEventListener("mouseleave", close);
    trigger.addEventListener("blur", close);

    trigger.addEventListener("click", (event) => {
      event.preventDefault();
      if (root.classList.contains("is-open")) {
        root.classList.remove("is-open");
        trigger.setAttribute("aria-expanded", "false");
      } else {
        open();
      }
    });

    document.addEventListener("click", (event) => {
      if (!root.contains(event.target)) {
        root.classList.remove("is-open");
        trigger.setAttribute("aria-expanded", "false");
      }
    });
  }

  const PLACEHOLDER_IMAGE =
    "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='120' viewBox='0 0 120 120'%3E%3Crect width='120' height='120' rx='18' ry='18' fill='%23f1f5f9'/%3E%3Cpath d='M36 66h48M36 54h48M36 42h48' stroke='%2394a3b8' stroke-width='6' stroke-linecap='round'/%3E%3C/svg%3E";

  function updateCartBadgeValue(value) {
    const parsed = typeof value === "number" ? value : parseInt(value, 10);
    const safeValue = Number.isFinite(parsed) && parsed >= 0 ? parsed : 0;
    document
      .querySelectorAll("[data-mini-cart-count]")
      .forEach((badge) => (badge.textContent = safeValue));
  }

  function initMiniCart() {
    const root = document.querySelector("[data-mini-cart]");
    if (!root) {
      return;
    }
    const trigger = root.querySelector("[data-mini-cart-trigger]");
    const panel = root.querySelector("[data-mini-cart-panel]");
    const body = root.querySelector("[data-mini-cart-body]");
    const totalLabel = root.querySelector("[data-mini-cart-total]");
    const fetchUrl = root.getAttribute("data-fetch-url");
    if (!trigger || !panel || !body || !fetchUrl) {
      return;
    }

    let hideTimer;
    let isOpen = false;
    let hasLoaded = false;
    let isLoading = false;
    const currencyFormatter = new Intl.NumberFormat("vi-VN", {
      style: "currency",
      currency: "VND",
      maximumFractionDigits: 0,
    });

    function openPanel() {
      clearTimeout(hideTimer);
      root.classList.add("is-open");
      trigger.setAttribute("aria-expanded", "true");
      isOpen = true;
      if (!hasLoaded) {
        fetchMiniCart();
      }
    }

    function closePanel() {
      hideTimer = setTimeout(() => {
        root.classList.remove("is-open");
        trigger.setAttribute("aria-expanded", "false");
        isOpen = false;
      }, 140);
    }

    trigger.addEventListener("mouseenter", openPanel);
    trigger.addEventListener("focus", openPanel);
    root.addEventListener("mouseleave", closePanel);
    trigger.addEventListener("blur", closePanel);

    trigger.addEventListener("click", (event) => {
      event.preventDefault();
      if (isOpen) {
        root.classList.remove("is-open");
        trigger.setAttribute("aria-expanded", "false");
        isOpen = false;
      } else {
        openPanel();
      }
    });

    document.addEventListener("click", (event) => {
      if (!root.contains(event.target)) {
        root.classList.remove("is-open");
        trigger.setAttribute("aria-expanded", "false");
        isOpen = false;
      }
    });

    function setState(message, modifier) {
      const modifiers = {
        loading: "mini-cart-panel__loading",
        error: "mini-cart-panel__error",
        empty: "mini-cart-panel__empty",
      };
      const cls = modifiers[modifier] || modifiers.empty;
      body.innerHTML = `<p class="${cls}">${message}</p>`;
      if (totalLabel) {
        totalLabel.textContent = "";
      }
      updateCartBadgeValue(0);
    }

    function computeTotalQuantity(items) {
      if (!Array.isArray(items) || !items.length) {
        return 0;
      }
      return items.reduce((sum, item) => {
        const qty = item && Number(item.quantity);
        return sum + (Number.isFinite(qty) && qty > 0 ? qty : 0);
      }, 0);
    }

    function normalizePayload(data) {
      if (Array.isArray(data)) {
        return {
          items: data,
          totalQuantity: computeTotalQuantity(data),
        };
      }
      if (data && Array.isArray(data.items)) {
        const parsedTotal =
          typeof data.totalQuantity === "number" &&
          Number.isFinite(data.totalQuantity)
            ? data.totalQuantity
            : computeTotalQuantity(data.items);
        return {
          items: data.items,
          totalQuantity: parsedTotal,
        };
      }
      return { items: [], totalQuantity: 0 };
    }

    function renderItems(items, totalQuantity) {
      if (!Array.isArray(items) || !items.length) {
        setState("Chưa có sản phẩm trong giỏ hàng", "empty");
        return;
      }
      body.innerHTML = items
        .map((item) => {
          const image = item.image
            ? `/images/product/${item.image}`
            : PLACEHOLDER_IMAGE;
          const name = item.name || "Sản phẩm";
          const quantity = item.quantity || 1;
          const price = currencyFormatter.format(item.price || 0);
          return `
            <div class="mini-cart-item">
                <div class="mini-cart-item__thumb">
                    <img src="${image}" alt="${name}" />
                </div>
                <div class="mini-cart-item__info">
                    <div class="mini-cart-item__name">${name}</div>
                    <div class="mini-cart-item__meta">
                        <span>x${quantity}</span>
                        <strong>${price}</strong>
                    </div>
                </div>
            </div>
          `;
        })
        .join("");
      if (totalLabel) {
        const count =
          Number.isFinite(totalQuantity) && totalQuantity > 0
            ? totalQuantity
            : items.length;
        totalLabel.textContent = `${count} sản phẩm`;
      }
      updateCartBadgeValue(totalQuantity);
    }

    function fetchMiniCart() {
      if (isLoading) {
        return;
      }
      isLoading = true;
      setState("Đang tải giỏ hàng...", "loading");
      fetch(fetchUrl, {
        headers: {
          Accept: "application/json",
        },
        credentials: "same-origin",
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
          }
          return response.json();
        })
        .then((data) => {
          hasLoaded = true;
          const payload = normalizePayload(data);
          renderItems(payload.items, payload.totalQuantity);
        })
        .catch(() => {
          setState("Không tải được dữ liệu giỏ hàng", "error");
        })
        .finally(() => {
          isLoading = false;
        });
    }

    document.addEventListener("cart:refresh", () => {
      hasLoaded = false;
      fetchMiniCart();
    });
  }

  initUserMenu();
  initMiniCart();
})();
