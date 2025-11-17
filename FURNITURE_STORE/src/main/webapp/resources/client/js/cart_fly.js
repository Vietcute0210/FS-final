(function () {
  const FORM_ACTION_PREFIX = "/add-product-to-cart";
  const DUR_TO_CENTER = 500;
  const PAUSE_AT_CENTER = 100;
  const DUR_TO_CART = 1000;
  const FORM_ID_REGEX = /\/add-product-to-cart\/(\d+)/;

  const $ = (s, r = document) => r.querySelector(s);
  const clamp = (v, a, b) => Math.min(b, Math.max(a, v));
  const lerp = (a, b, t) => a + (b - a) * t;

  function qBezier(p0, p1, p2, t) {
    const u = 1 - t;
    return {
      x: u * u * p0.x + 2 * u * t * p1.x + t * t * p2.x,
      y: u * u * p0.y + 2 * u * t * p1.y + t * t * p2.y,
    };
  }

  function findCartIcon() {
    return (
      $(".container-fluid.fixed-top .fa-shopping-bag") || $(".fa-shopping-bag")
    );
  }

  function findCartBadge() {
    const icon = findCartIcon();
    const a = icon && icon.closest("a");
    return a
      ? a.querySelector(".position-absolute.bg-secondary, .bg-secondary")
      : null;
  }

  function nearestProductImage(el) {
    if (!el || typeof el.closest !== "function") {
      return null;
    }
    const root =
      el.closest(
        ".fruite-item, .fruite-img, .product, .card, [data-product]"
      ) || el.closest("div,li,section,article");
    return root ? root.querySelector("img") : null;
  }

  function resolveFormQuantity(form) {
    if (!form) return 1;
    const source =
      form.querySelector('input[name="quantity"]') ||
      form.querySelector("[data-cart-detail-index]");
    if (!source) return 1;
    const parsed = parseInt(source.value, 10);
    return Number.isFinite(parsed) && parsed > 0 ? parsed : 1;
  }

  function applyQuantityToForm(form, quantity) {
    if (!form) return;
    const qtyInput = form.querySelector('input[name="quantity"]');
    if (qtyInput) {
      qtyInput.value = quantity;
    }
    const displayInput = form.querySelector("[data-cart-detail-index]");
    if (displayInput) {
      displayInput.value = quantity;
    }
  }

  function isAddToCartForm(form) {
    if (!form || form.nodeName !== "FORM") return false;
    const action = form.getAttribute("action") || "";
    return action.startsWith(FORM_ACTION_PREFIX);
  }

  function resolveProductId(form, trigger) {
    if (!form) return null;
    const dataId =
      (trigger &&
        trigger.getAttribute &&
        trigger.getAttribute("data-product-id")) ||
      form.getAttribute("data-product-id");
    if (dataId) {
      const parsed = parseInt(dataId, 10);
      if (Number.isFinite(parsed) && parsed > 0) {
        return parsed;
      }
    }
    const hidden = form.querySelector('input[name="productId"]');
    if (hidden && hidden.value) {
      const parsed = parseInt(hidden.value, 10);
      if (Number.isFinite(parsed) && parsed > 0) {
        return parsed;
      }
    }
    const action = form.getAttribute("action") || "";
    const match = action.match(FORM_ID_REGEX);
    if (match && match[1]) {
      const parsed = parseInt(match[1], 10);
      if (Number.isFinite(parsed) && parsed > 0) {
        return parsed;
      }
    }
    return null;
  }

  function setButtonLoading(button, isLoading) {
    if (!button) return;
    if (isLoading) {
      if (!button.dataset.cartOriginalHtml) {
        button.dataset.cartOriginalHtml = button.innerHTML;
      }
      if ("disabled" in button) {
        button.disabled = true;
      } else {
        button.setAttribute("aria-disabled", "true");
      }
      button.innerHTML =
        '<i class="fa fa-spinner fa-spin me-2"></i>Dang them...';
    } else {
      if ("disabled" in button) {
        button.disabled = false;
      } else {
        button.removeAttribute("aria-disabled");
      }
      if (button.dataset.cartOriginalHtml) {
        button.innerHTML = button.dataset.cartOriginalHtml;
        delete button.dataset.cartOriginalHtml;
      }
    }
  }

  function resolveCsrfHeaders() {
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
    return { token, header };
  }

  async function requestAddToCart({ productId, quantity }) {
    if (
      window.CartCommon &&
      typeof window.CartCommon.addToCart === "function"
    ) {
      return window.CartCommon.addToCart({ productId, quantity });
    }
    const headers = {
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest",
    };
    const csrf = resolveCsrfHeaders();
    if (csrf) {
      headers[csrf.header] = csrf.token;
    }
    const response = await fetch("/api/add-product-to-cart", {
      method: "POST",
      headers,
      credentials: "same-origin",
      body: JSON.stringify({ productId, quantity }),
    });
    if (response.status === 401 || response.status === 403) {
      const error = new Error("unauthorized");
      error.cartHandled = true;
      window.location.href = "/login";
      throw error;
    }
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }
    const sum = await response.json();
    if (
      window.CartCommon &&
      typeof window.CartCommon.updateCartBadge === "function"
    ) {
      window.CartCommon.updateCartBadge(sum);
      document.dispatchEvent(
        new CustomEvent("cart:refresh", { detail: { sum } })
      );
    }
    return sum;
  }

  function fireToast(heading, text, icon) {
    if (
      window.CartCommon &&
      typeof window.CartCommon.showToast === "function"
    ) {
      window.CartCommon.showToast(heading, text, icon);
      return;
    }
    if (window.$ && typeof window.$.toast === "function") {
      window.$.toast({
        heading,
        text,
        icon: icon || "success",
        showHideTransition: "slide",
        position: "bottom-right",
      });
      return;
    }
    if (icon === "error") {
      console.error(`[${heading}] ${text}`);
    } else {
      console.log(`[${heading}] ${text}`);
    }
  }

  function notifySuccess(quantity) {
    const heading = "Đã thêm vào giỏ hàng";
    const text =
      quantity > 1
        ? `Đã thêm ${quantity} sản phẩm vào giỏ hàng.`
        : "Sản phẩm đã được thêm vào giỏ hàng.";
    fireToast(heading, text, "success");
  }

  function notifyError(message) {
    fireToast("Không thể thêm sản phẩm", message, "error");
  }

  function handleAddError(error) {
    if (error && error.cartHandled) {
      return;
    }
    let message = "Không thể thêm sản phẩm vào giỏ hàng. Vui lòng thử lại sau.";
    if (error && typeof error.message === "string") {
      if (error.message.includes("401") || error.message === "unauthorized") {
        message = "Vui lòng đăng nhập để tiếp tục mua sắm.";
      } else if (error.message.includes("403")) {
        message = "Bạn không có quyền thực hiện thao tác này.";
      }
    }
    notifyError(message);
  }

  function injectStyles() {
    if ($("#cart-fly-styles")) return;
    const css = `
      .fly-clone{position:fixed;z-index:3000;pointer-events:none;border-radius:50%;object-fit:cover;
        box-shadow:0 12px 28px rgba(0,0,0,.22);will-change:transform,opacity}
      .cart-bump{transform-origin:center;transition:transform .28s ease;transform:scale(1.12) rotate(-6deg)}
      .cart-plus-anim{position:fixed;z-index:3500;pointer-events:none;font-weight:600;color:#fff;background:#ff4d4f;
        padding:4px 7px;border-radius:12px;font-size:12px;opacity:0;transform:translateY(0) scale(.85);
        transition:transform .6s cubic-bezier(.22,.61,.36,1),opacity .6s}
    `;
    const s = document.createElement("style");
    s.id = "cart-fly-styles";
    s.textContent = css;
    document.head.appendChild(s);
  }

  function flyToCart(startEl, imgUrl, quantity, done) {
    const cart = findCartIcon();
    if (!cart) {
      done && done();
      return;
    }
    const added = Number.isFinite(quantity) && quantity > 0 ? quantity : 1;
    injectStyles();

    const baseEl = startEl || cart;
    const r0 = baseEl.getBoundingClientRect();
    const clone = document.createElement("img");
    clone.src = imgUrl;
    clone.alt = "";
    clone.className = "fly-clone";
    const base = clamp(
      Math.min(r0.width, r0.height) * 1.1,
      80,
      window.innerHeight * 0.22
    );

    Object.assign(clone.style, {
      left: `${r0.left + r0.width / 2 - base / 2}px`,
      top: `${r0.top + r0.height / 2 - base / 2}px`,
      width: `${base}px`,
      height: `${base}px`,
      opacity: "0.95",
      transition: `transform ${DUR_TO_CENTER}ms cubic-bezier(.23,1,.32,1),opacity ${DUR_TO_CENTER}ms`,
    });
    document.body.appendChild(clone);

    const cx = window.innerWidth / 2;
    const cy = window.innerHeight * 0.4;
    requestAnimationFrame(() => {
      const tx = cx - (r0.left + r0.width / 2);
      const ty = cy - (r0.top + r0.height / 2);
      clone.style.transform = `translate(${tx}px, ${ty}px) scale(.8)`;
    });

    setTimeout(() => {
      const rC = cart.getBoundingClientRect();
      const p0 = { x: cx, y: cy };
      const p2 = { x: rC.left + rC.width / 2, y: rC.top + rC.height / 2 };
      const mid = { x: (p0.x + p2.x) / 2, y: (p0.y + p2.y) / 2 };
      const dx = p2.x - p0.x;
      const dy = p2.y - p0.y;
      const len = Math.hypot(dx, dy) || 1;
      const nx = -dy / len;
      const ny = dx / len;
      const bend = clamp(len * 0.35, 120, 260);
      const p1 = {
        x: mid.x + nx * bend,
        y: mid.y + ny * bend - Math.abs(bend * 0.25),
      };

      const t0 = performance.now();
      const endScale = 0.18;

      function step(now) {
        const t = clamp((now - t0) / DUR_TO_CART, 0, 1);
        const e = t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
        const pt = qBezier(p0, p1, p2, e);
        const s = lerp(1, endScale, e);
        clone.style.transition = "none";
        clone.style.transform = `translate(${
          pt.x - (r0.left + r0.width / 2)
        }px, ${pt.y - (r0.top + r0.height / 2)}px) scale(${s})`;
        clone.style.opacity = String(lerp(0.95, 0.35, e));
        if (t < 1) requestAnimationFrame(step);
        else finish();
      }

      function finish() {
        clone.remove();
        cart.classList.add("cart-bump");
        setTimeout(() => cart.classList.remove("cart-bump"), 420);
        const badge = findCartBadge();
        if (badge) {
          const n =
            parseInt((badge.textContent || "0").replace(/\D/g, "")) || 0;
          badge.textContent = String(n + added);
        } else {
          const plus = document.createElement("div");
          plus.className = "cart-plus-anim";
          plus.textContent = `+${added}`;
          document.body.appendChild(plus);
          const rc = cart.getBoundingClientRect();
          plus.style.left = `${rc.left + rc.width / 2 - 18}px`;
          plus.style.top = `${rc.top + rc.height / 2 - 12}px`;
          requestAnimationFrame(() => {
            plus.style.opacity = "1";
            plus.style.transform = "translateY(-18px) scale(1)";
          });
          setTimeout(() => {
            plus.style.opacity = "0";
            plus.style.transform = "translateY(-32px) scale(.8)";
            setTimeout(() => plus.remove(), 520);
          }, 520);
        }
        done && done();
      }

      requestAnimationFrame(step);
    }, DUR_TO_CENTER + PAUSE_AT_CENTER);
  }

  function onCartFormSubmit(event) {
    const form = event.target;
    if (!(form instanceof HTMLFormElement)) {
      return;
    }
    if (!isAddToCartForm(form)) {
      return;
    }
    event.preventDefault();
    if (form.dataset.cartPending === "true") {
      return;
    }

    const submitter =
      event.submitter ||
      form.querySelector('button[type="submit"]') ||
      form.querySelector("button") ||
      form;
    const submitButton = submitter && submitter !== form ? submitter : null;
    const productId = resolveProductId(form, submitButton || form);
    if (!productId) {
      form.submit();
      return;
    }
    const quantity = resolveFormQuantity(form);
    applyQuantityToForm(form, quantity);
    form.dataset.cartPending = "true";

    const productImg =
      (submitButton && nearestProductImage(submitButton)) ||
      nearestProductImage(form);
    const imgSrc =
      (productImg && (productImg.currentSrc || productImg.src)) || "";

    setButtonLoading(submitButton, true);

    const finalize = () => {
      delete form.dataset.cartPending;
      setButtonLoading(submitButton, false);
    };

    const performAdd = () =>
      requestAddToCart({ productId, quantity })
        .then(() => notifySuccess(quantity))
        .catch((error) => handleAddError(error))
        .finally(finalize);

    if (imgSrc) {
      flyToCart(
        productImg || submitButton || form,
        imgSrc,
        quantity,
        performAdd
      );
    } else {
      performAdd();
    }
  }

  const attach = () =>
    document.addEventListener("submit", onCartFormSubmit, true);

  document.readyState === "loading"
    ? document.addEventListener("DOMContentLoaded", attach)
    : attach();
})();
