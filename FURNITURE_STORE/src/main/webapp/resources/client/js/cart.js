// ============ Cập nhật giá tiền khi tăng/giảm số lượng ============ //
$(document).ready(function () {
  const QUANTITY_STORAGE_KEY = "furniture_store_cart_quantities";
  const SELECTION_STORAGE_KEY = "furniture_store_cart_selection";
  const CART_QUANTITY_ENDPOINT = "/api/update-cart-quantity";
  const CART_SYNC_ERROR_COOLDOWN = 1500;
  const CART_QUANTITY_INPUT_SELECTOR =
    "input[data-cart-detail-id][data-cart-detail-price]";
  let selectionStateMap = null;
  let lastQuantitySyncErrorAt = 0;
  let lastQuantitySyncErrorMessage = "";

  const currencyFormatter =
    typeof Intl !== "undefined" && Intl.NumberFormat
      ? new Intl.NumberFormat("vi-VN", { maximumFractionDigits: 0 })
      : null;

  // Currency formatter for VND
  function formatCurrency(number) {
    const amount = Number(number);
    const safeAmount = Number.isFinite(amount) ? amount : 0;
    if (currencyFormatter) {
      return `${currencyFormatter.format(safeAmount)} đ`;
    }
    const fallback =
      typeof safeAmount.toLocaleString === "function"
        ? safeAmount.toLocaleString("vi-VN")
        : String(safeAmount);
    return `${fallback} đ`;
  }

  function parsePrice(raw) {
    if (typeof raw === "number") {
      return Number.isFinite(raw) ? raw : 0;
    }
    if (raw === null || typeof raw === "undefined") return 0;

    const normalized = String(raw).trim();
    if (!normalized) return 0;

    // Keep digits, decimal separators, +/- signs and scientific notation markers.
    const sanitized = normalized.replace(/[^0-9+.\-eE]/g, "");
    const direct = Number(sanitized);
    if (Number.isFinite(direct)) {
      return direct;
    }

    // Fallback: strip everything except digits and minus sign (handles formatted strings)
    const digitsOnly = normalized.replace(/[^\d-]/g, "");
    const fallback = parseInt(digitsOnly, 10);
    return Number.isFinite(fallback) ? fallback : 0;
  }

  function sanitizeQuantity(value) {
    const parsed = parseInt(value, 10);
    if (!Number.isFinite(parsed) || parsed < 1) {
      return 1;
    }
    return parsed;
  }

  function getSelectionMap() {
    if (!selectionStateMap) {
      selectionStateMap = loadSavedSelections();
    }
    return selectionStateMap;
  }

  function loadSavedSelections() {
    try {
      const raw = localStorage.getItem(SELECTION_STORAGE_KEY);
      return raw ? JSON.parse(raw) : {};
    } catch (e) {
      console.warn("Failed to parse saved cart selections", e);
      return {};
    }
  }

  function persistSelectionMap(map) {
    try {
      localStorage.setItem(SELECTION_STORAGE_KEY, JSON.stringify(map));
    } catch (e) {
      console.warn("Failed to save cart selections", e);
    }
  }

  function getSelectionState(id) {
    if (typeof id === "undefined") {
      return true;
    }
    const map = getSelectionMap();
    const key = String(id);
    if (!Object.prototype.hasOwnProperty.call(map, key)) {
      map[key] = true;
      persistSelectionMap(map);
    }
    return !!map[key];
  }

  function setSelectionState(id, selected) {
    if (typeof id === "undefined") return;
    const map = getSelectionMap();
    map[String(id)] = !!selected;
    persistSelectionMap(map);
  }

  function clearSavedSelections() {
    try {
      localStorage.removeItem(SELECTION_STORAGE_KEY);
    } catch (e) {
      /* ignore */
    }
    selectionStateMap = {};
  }

  function updateRowVisualState(cartDetailId, isSelected) {
    const row = $(`[data-cart-row-id='${cartDetailId}']`);
    if (row.length) {
      row.toggleClass("cart-row--muted", !isSelected);
    }
  }

  function updateLineItemSubtotalDisplay(input, qty, highlight) {
    if (!input || !input.length) return;
    const pricePerItem = parsePrice(input.data("cart-detail-price")) || 0;
    const cartDetailId = input.data("cart-detail-id");
    const subtotal = Math.max(0, qty) * pricePerItem;
    const priceCells = $(`p[data-cart-detail-id='${cartDetailId}']`);
    if (priceCells.length) {
      priceCells.text(formatCurrency(subtotal));
      if (highlight) {
        priceCells.addClass("highlight");
        setTimeout(() => priceCells.removeClass("highlight"), 500);
      }
    }
    updateCheckoutQuantityDisplay(cartDetailId, qty);
  }

  function applyQuantityChange(input, qty, options = {}) {
    if (!input || !input.length) return 0;

    const sanitized = sanitizeQuantity(qty);
    const previous = parseInt(input.val(), 10) || 0;
    if (!options.force && previous === sanitized) {
      return sanitized;
    }

    input.val(sanitized);
    syncHiddenQuantity(input, sanitized);
    updateLineItemSubtotalDisplay(input, sanitized, options.highlight);

    if (options.save !== false) {
      saveQuantity(input.data("cart-detail-id"), sanitized);
    }

    updateTotal();

    if (options.sync !== false) {
      syncQuantityWithServer(input.data("cart-detail-id"), sanitized);
    }

    return sanitized;
  }

  function syncQuantityWithServer(cartDetailId, qty) {
    if (typeof cartDetailId === "undefined") {
      return;
    }
    requestCartQuantityUpdate(cartDetailId, qty);
  }

  function requestCartQuantityUpdate(cartDetailId, quantity) {
    const parsedId = Number(cartDetailId);
    const safeId = Number.isFinite(parsedId) ? parsedId : cartDetailId;
    const payload = {
      cartDetailId: safeId,
      quantity: sanitizeQuantity(quantity),
    };
    const csrf = resolveCsrfHeadersSafe();
    const headers = {
      "Content-Type": "application/json",
    };
    if (csrf) {
      headers[csrf.header] = csrf.token;
    }

    const handlePayload = (data) => {
      if (!data) {
        return;
      }
      if (data.success === false) {
        notifyQuantitySyncError(data.message || "Không thể cập nhật giỏ hàng");
        return;
      }
      applyServerTotals(safeId, data);
    };

    if (typeof window.fetch === "function") {
      window
        .fetch(CART_QUANTITY_ENDPOINT, {
          method: "POST",
          headers,
          credentials: "same-origin",
          body: JSON.stringify(payload),
        })
        .then((response) => {
          if (!response.ok) {
            return response.text().then((text) => {
              throw new Error(text || "Không thể cập nhật giỏ hàng");
            });
          }
          return response.json().catch(() => ({}));
        })
        .then(handlePayload)
        .catch((error) => {
          notifyQuantitySyncError(error);
        });
      return;
    }

    if (window.$ && typeof window.$.ajax === "function") {
      window.$
        .ajax({
          url: CART_QUANTITY_ENDPOINT,
          method: "POST",
          headers,
          data: JSON.stringify(payload),
          contentType: "application/json",
        })
        .done(handlePayload)
        .fail((xhr) => {
          const message =
            (xhr && xhr.responseText) || "Không thể cập nhật giỏ hàng";
          notifyQuantitySyncError(message);
        });
    }
  }

  function resolveCsrfHeadersSafe() {
    if (
      window.CartCommon &&
      typeof window.CartCommon.resolveCsrfHeaders === "function"
    ) {
      const cached = window.CartCommon.resolveCsrfHeaders();
      if (cached) {
        return cached;
      }
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
    return { token, header };
  }

  function applyServerTotals(cartDetailId, payload) {
    if (!payload) {
      return;
    }

    if (
      typeof payload.subtotal === "number" &&
      Number.isFinite(payload.subtotal)
    ) {
      const priceCells = $(`p[data-cart-detail-id='${cartDetailId}']`);
      if (priceCells.length) {
        priceCells.text(formatCurrency(payload.subtotal));
      }
    }

    if (
      typeof payload.totalPrice === "number" &&
      Number.isFinite(payload.totalPrice)
    ) {
      $("[data-cart-total-price]").text(formatCurrency(payload.totalPrice));
      const totalField = $("[data-cart-total-field]");
      if (totalField.length) {
        totalField.val(payload.totalPrice);
      }
    }

    if (
      payload.cartCount != null &&
      window.CartCommon &&
      typeof window.CartCommon.updateCartBadge === "function"
    ) {
      window.CartCommon.updateCartBadge(payload.cartCount);
    }
  }

  function notifyQuantitySyncError(error) {
    const fallbackMessage =
      "Không thể cập nhật số lượng. Vui lòng thử lại trong giây lát.";
    const message =
      typeof error === "string" && error
        ? error
        : error && error.message
        ? error.message
        : fallbackMessage;

    const now = Date.now();
    if (
      message === lastQuantitySyncErrorMessage &&
      now - lastQuantitySyncErrorAt < CART_SYNC_ERROR_COOLDOWN
    ) {
      console.error("Cart quantity sync error:", error);
      return;
    }

    lastQuantitySyncErrorMessage = message;
    lastQuantitySyncErrorAt = now;
    console.error("Cart quantity sync error:", error);

    if (
      window.CartCommon &&
      typeof window.CartCommon.showToast === "function"
    ) {
      window.CartCommon.showToast("Lỗi giỏ hàng", message, "error");
    }
  }

  function syncSelectAllCheckboxState() {
    const selectAll = $("[data-cart-select-all]");
    if (!selectAll.length) return;
    const checkboxes = $("[data-cart-select]");
    if (!checkboxes.length) {
      selectAll.prop("checked", false).prop("indeterminate", false);
      return;
    }
    const checkedCount = checkboxes.filter(":checked").length;
    selectAll.prop(
      "checked",
      checkedCount > 0 && checkedCount === checkboxes.length
    );
    selectAll.prop(
      "indeterminate",
      checkedCount > 0 && checkedCount < checkboxes.length
    );
  }

  function getSelectedIdsFromCheckboxes() {
    return $("[data-cart-select]")
      .filter(":checked")
      .map(function () {
        return $(this).data("cart-detail-id");
      })
      .get();
  }

  function updateSelectedIdsField() {
    const target = $("#selectedCartDetailIdsField");
    if (!target.length) return;
    const ids = getSelectedIdsFromCheckboxes();
    target.val(ids.join(","));
  }

  function applySavedSelections() {
    const checkboxes = $("[data-cart-select]");
    if (!checkboxes.length) return;
    checkboxes.each(function () {
      const checkbox = $(this);
      const id = checkbox.data("cart-detail-id");
      const isSelected = getSelectionState(id);
      checkbox.prop("checked", isSelected);
      updateRowVisualState(id, isSelected);
    });
    syncSelectAllCheckboxState();
    updateSelectedIdsField();
  }

  function shouldIncludeCartItem(cartDetailId) {
    if (typeof cartDetailId === "undefined") {
      return true;
    }
    const checkbox = $(
      `[data-cart-select][data-cart-detail-id='${cartDetailId}']`
    );
    if (checkbox.length) {
      return checkbox.is(":checked");
    }
    return getSelectionState(cartDetailId);
  }

  // Compute cart total using raw quantity/price data for accuracy
  function updateTotal() {
    let total = 0;
    const cartInputs = $(CART_QUANTITY_INPUT_SELECTOR);
    if (cartInputs.length) {
      cartInputs.each(function () {
        const cartDetailId = $(this).data("cart-detail-id");
        if (!shouldIncludeCartItem(cartDetailId)) {
          return;
        }
        const qty = parseInt($(this).val(), 10) || 0;
        const pricePerItem = parsePrice($(this).data("cart-detail-price"));
        total += qty * pricePerItem;
      });
    } else {
      const checkoutItems = $(
        "[data-checkout-unit-price][data-cart-detail-id]"
      );
      checkoutItems.each(function () {
        const cartDetailId = $(this).data("cart-detail-id");
        if (!shouldIncludeCartItem(cartDetailId)) {
          return;
        }
        const pricePerItem = getCheckoutUnitPrice(cartDetailId);
        const qty =
          parseInt(
            $(
              `[data-checkout-quantity][data-cart-detail-id='${cartDetailId}']`
            ).text(),
            10
          ) || 0;
        total += pricePerItem * qty;
      });
    }
    $("[data-cart-total-price]").text(formatCurrency(total));

    const totalField = $("[data-cart-total-field]");
    if (totalField.length) {
      totalField.val(total);
    }
  }

  function syncHiddenQuantity(input, qty) {
    if (!input || !input.length) return;
    const index = input.data("cart-detail-index");
    if (typeof index === "undefined") return;
    const hiddenQty = $(`input[name='cartDetails[${index}].quantity']`);
    if (hiddenQty.length) {
      hiddenQty.val(qty);
    }
  }

  function getCheckoutUnitPrice(cartDetailId) {
    const unitPriceEl = $(
      `[data-checkout-unit-price][data-cart-detail-id='${cartDetailId}']`
    );
    if (!unitPriceEl.length) return 0;
    const raw =
      unitPriceEl.data("cart-detail-price") ||
      unitPriceEl.attr("data-cart-detail-price");
    return parsePrice(raw);
  }

  function updateCheckoutQuantityDisplay(cartDetailId, qty) {
    const quantityEl = $(
      `[data-checkout-quantity][data-cart-detail-id='${cartDetailId}']`
    );
    if (quantityEl.length) {
      quantityEl.text(qty);
    }
  }

  function refreshCartDisplayFromCurrentValues() {
    const visibleInputs = $(CART_QUANTITY_INPUT_SELECTOR);
    if (visibleInputs.length) {
      visibleInputs.each(function () {
        const input = $(this);
        const qty = parseInt(input.val(), 10) || 0;
        updateLineItemSubtotalDisplay(input, qty);
      });
    } else {
      const checkoutItems = $(
        "[data-checkout-unit-price][data-cart-detail-id]"
      );
      checkoutItems.each(function () {
        const unitPriceEl = $(this);
        const cartDetailId = unitPriceEl.data("cart-detail-id");
        const pricePerItem = getCheckoutUnitPrice(cartDetailId);
        const qtyText = $(
          `[data-checkout-quantity][data-cart-detail-id='${cartDetailId}']`
        ).text();
        const qty = parseInt(qtyText, 10) || 0;
        if (pricePerItem) {
          const subtotal = pricePerItem * qty;
          $(`p[data-cart-detail-id='${cartDetailId}']`).text(
            formatCurrency(subtotal)
          );
        }
      });
    }
    updateTotal();
  }

  function loadSavedQuantities() {
    try {
      const raw = localStorage.getItem(QUANTITY_STORAGE_KEY);
      return raw ? JSON.parse(raw) : {};
    } catch (e) {
      console.warn("Failed to parse saved cart quantities", e);
      return {};
    }
  }

  function saveQuantitiesMap(map) {
    try {
      localStorage.setItem(QUANTITY_STORAGE_KEY, JSON.stringify(map));
    } catch (e) {
      console.warn("Failed to save cart quantities", e);
    }
  }

  function saveQuantity(id, qty) {
    if (typeof id === "undefined") return;
    const map = loadSavedQuantities();
    map[id] = qty;
    saveQuantitiesMap(map);
  }

  function clearSavedQuantities() {
    try {
      localStorage.removeItem(QUANTITY_STORAGE_KEY);
    } catch (e) {
      /* ignore */
    }
    clearSavedSelections();
  }

  // Áp dụng các giá trị đã lưu (nếu có) lên DOM khi load trang
  function applySavedQuantities() {
    const map = loadSavedQuantities();
    Object.keys(map).forEach((id) => {
      const qty = parseInt(map[id], 10);
      if (!isFinite(qty)) return;

      const quantitySelectorForId = `${CART_QUANTITY_INPUT_SELECTOR}[data-cart-detail-id='${id}']`;
      const visibleInput = $(quantitySelectorForId);
      if (visibleInput.length) {
        visibleInput.val(qty);
        syncHiddenQuantity(visibleInput, qty);
        updateLineItemSubtotalDisplay(visibleInput, qty);
      } else {
        const pricePerItem = getCheckoutUnitPrice(id);
        if (pricePerItem) {
          const totalForItem = pricePerItem * qty;
          $(`p[data-cart-detail-id='${id}']`).text(
            formatCurrency(totalForItem)
          );
        }
        updateCheckoutQuantityDisplay(id, qty);
      }
    });
    updateTotal();
  }

  function bindSelectionEvents() {
    $("[data-cart-select]")
      .off("change.cartSelect")
      .on("change.cartSelect", function () {
        const checkbox = $(this);
        const id = checkbox.data("cart-detail-id");
        const isSelected = checkbox.is(":checked");
        setSelectionState(id, isSelected);
        updateRowVisualState(id, isSelected);
        syncSelectAllCheckboxState();
        updateSelectedIdsField();
        updateTotal();
      });

    $("[data-cart-select-all]")
      .off("change.cartSelectAll")
      .on("change.cartSelectAll", function () {
        const shouldSelect = $(this).is(":checked");
        const checkboxes = $("[data-cart-select]");
        checkboxes.each(function () {
          const checkbox = $(this);
          const id = checkbox.data("cart-detail-id");
          checkbox.prop("checked", shouldSelect);
          setSelectionState(id, shouldSelect);
          updateRowVisualState(id, shouldSelect);
        });
        syncSelectAllCheckboxState();
        updateSelectedIdsField();
        updateTotal();
      });

    const cartForm = $("#cartSelectionForm");
    if (cartForm.length) {
      cartForm.off("submit.cartSelect").on("submit.cartSelect", function (e) {
        const selectedIds = getSelectedIdsFromCheckboxes();
        if (!selectedIds.length) {
          e.preventDefault();
          alert("Vui lòng chọn ít nhất một sản phẩm để thanh toán.");
          return false;
        }
        $("#selectedCartDetailIdsField").val(selectedIds.join(","));
        return true;
      });
    }
  }

  // Khi bấm nút cộng
  $(".btn-plus")
    .off("click")
    .on("click", function () {
      const input = $(this)
        .closest(".quantity")
        .find(CART_QUANTITY_INPUT_SELECTOR);
      if (!input.length) {
        return;
      }
      const currentValue = sanitizeQuantity(input.val());
      applyQuantityChange(input, currentValue + 1, {
        highlight: true,
      });
    });

  // Khi bấm nút trừ
  $(".btn-minus")
    .off("click")
    .on("click", function () {
      const input = $(this)
        .closest(".quantity")
        .find(CART_QUANTITY_INPUT_SELECTOR);
      if (!input.length) {
        return;
      }
      const currentValue = sanitizeQuantity(input.val());
      if (currentValue <= 1) {
        return;
      }
      applyQuantityChange(input, currentValue - 1);
    });

  $(CART_QUANTITY_INPUT_SELECTOR)
    .off("change.cartQuantity blur.cartQuantity")
    .on("change.cartQuantity blur.cartQuantity", function () {
      const input = $(this);
      const nextValue = sanitizeQuantity(input.val());
      applyQuantityChange(input, nextValue, {
        highlight: true,
        force: true,
      });
    });

  // Áp dụng các trạng thái đã lưu ngay khi trang load xong
  applySavedSelections();
  applySavedQuantities();
  refreshCartDisplayFromCurrentValues();
  bindSelectionEvents();

  // Khi submit checkout form, xóa localStorage (vì server sẽ xử lý theo dữ liệu server side)
  $(
    "form[action='/order/create'], form[action='/order/place-order'], #checkoutForm"
  ).on("submit", function () {
    clearSavedQuantities();
  });
});
