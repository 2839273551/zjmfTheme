(function () {
  "use strict";

  var categoryPanel = document.querySelector("[data-category-panel]");
  var categoryToggle = document.querySelector("[data-category-toggle]");
  var categoryClose = document.querySelector("[data-category-close]");
  var categoryOverlay = document.querySelector("[data-category-overlay]");
  var searchInput = document.querySelector("[data-product-search]");
  var productCards = Array.prototype.slice.call(document.querySelectorAll("[data-product-card]"));
  var searchEmpty = document.querySelector("[data-search-empty]");

  function setCategoryOpen(open) {
    if (!categoryPanel || !categoryToggle || !categoryOverlay) {
      return;
    }

    categoryPanel.classList.toggle("is-open", open);
    categoryOverlay.classList.toggle("is-open", open);
    categoryToggle.setAttribute("aria-expanded", open ? "true" : "false");
    document.body.classList.toggle("store-menu-open", open);
  }

  if (categoryToggle) {
    categoryToggle.addEventListener("click", function () {
      setCategoryOpen(categoryToggle.getAttribute("aria-expanded") !== "true");
    });
  }

  if (categoryClose) {
    categoryClose.addEventListener("click", function () {
      setCategoryOpen(false);
    });
  }

  if (categoryOverlay) {
    categoryOverlay.addEventListener("click", function () {
      setCategoryOpen(false);
    });
  }

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
      setCategoryOpen(false);
    }
  });

  if (searchInput && productCards.length) {
    searchInput.addEventListener("input", function () {
      var keyword = searchInput.value.trim().toLocaleLowerCase();
      var visibleCount = 0;

      productCards.forEach(function (card) {
        var matches = !keyword || card.textContent.toLocaleLowerCase().indexOf(keyword) !== -1;
        card.hidden = !matches;
        if (matches) {
          visibleCount += 1;
        }
      });

      if (searchEmpty) {
        searchEmpty.hidden = visibleCount !== 0;
      }
    });
  }

  window.addEventListener("resize", function () {
    if (window.innerWidth > 900) {
      setCategoryOpen(false);
    }
  });
})();
