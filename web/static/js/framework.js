(function () {
  "use strict";

  var reducedMotion = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  var pageBody = document.body;
  var homeContent = document.querySelector("[data-home-content]");
  var transitionPage = pageBody && (
    pageBody.classList.contains("cloud-cart-page") ||
    pageBody.classList.contains("cloud-web-home")
  );

  if (transitionPage && !reducedMotion) {
    window.addEventListener("pageshow", function () {
      pageBody.classList.remove("is-page-leaving");
      if (homeContent) {
        homeContent.setAttribute("aria-busy", "false");
      }
    });

    document.addEventListener("click", function (event) {
      if (
        event.defaultPrevented ||
        event.button !== 0 ||
        event.metaKey ||
        event.ctrlKey ||
        event.shiftKey ||
        event.altKey ||
        pageBody.classList.contains("is-page-leaving")
      ) {
        return;
      }

      var link = event.target.closest("a[href]");
      if (!link || link.hasAttribute("download") || link.hasAttribute("data-no-page-transition")) {
        return;
      }

      var target = link.getAttribute("target");
      var rawHref = link.getAttribute("href");
      if ((target && target !== "_self") || !rawHref || rawHref.charAt(0) === "#") {
        return;
      }

      var targetUrl = new URL(link.href, window.location.href);
      if (targetUrl.origin !== window.location.origin || !/^https?:$/.test(targetUrl.protocol)) {
        return;
      }

      if (targetUrl.href === window.location.href) {
        return;
      }

      if (
        targetUrl.pathname === window.location.pathname &&
        targetUrl.search === window.location.search &&
        targetUrl.hash
      ) {
        return;
      }

      event.preventDefault();
      pageBody.classList.add("is-page-leaving");
      if (homeContent) {
        homeContent.setAttribute("aria-busy", "true");
      }
      window.setTimeout(function () {
        window.location.assign(targetUrl.href);
      }, 130);
    });
  }

  var toggle = document.querySelector("[data-nav-toggle]");
  var navigation = document.querySelector("[data-navigation]");

  if (toggle && navigation) {
    function closeNavigation() {
      toggle.setAttribute("aria-expanded", "false");
      navigation.classList.remove("is-open");
    }

    toggle.addEventListener("click", function () {
      var expanded = toggle.getAttribute("aria-expanded") === "true";
      toggle.setAttribute("aria-expanded", expanded ? "false" : "true");
      navigation.classList.toggle("is-open", !expanded);
    });

    navigation.addEventListener("click", function (event) {
      if (event.target.closest("a")) {
        closeNavigation();
      }
    });

    document.addEventListener("keydown", function (event) {
      if (event.key === "Escape") {
        closeNavigation();
      }
    });

    window.addEventListener("resize", function () {
      if (window.innerWidth > 980) {
        closeNavigation();
      }
    });
  }

  var carousel = document.querySelector("[data-carousel]");

  if (carousel) {
    var slides = Array.prototype.slice.call(carousel.querySelectorAll("[data-slide]"));
    var carouselTabs = Array.prototype.slice.call(carousel.querySelectorAll("[data-carousel-tab]"));
    var previousButton = carousel.querySelector("[data-carousel-prev]");
    var nextButton = carousel.querySelector("[data-carousel-next]");
    var activeSlide = 0;
    var carouselTimer = null;
    var touchStartX = 0;

    function showSlide(index, focusTab) {
      activeSlide = (index + slides.length) % slides.length;

      slides.forEach(function (slide, slideIndex) {
        var selected = slideIndex === activeSlide;
        slide.classList.toggle("is-active", selected);
        slide.setAttribute("aria-hidden", selected ? "false" : "true");
      });

      carouselTabs.forEach(function (tab, tabIndex) {
        var selected = tabIndex === activeSlide;
        tab.classList.toggle("is-active", selected);
        tab.setAttribute("aria-selected", selected ? "true" : "false");
        tab.setAttribute("tabindex", selected ? "0" : "-1");
      });

      if (focusTab && carouselTabs[activeSlide]) {
        carouselTabs[activeSlide].focus();
      }
    }

    function stopCarousel() {
      if (carouselTimer) {
        window.clearInterval(carouselTimer);
        carouselTimer = null;
      }
    }

    function startCarousel() {
      stopCarousel();
      if (!reducedMotion && slides.length > 1 && !document.hidden) {
        carouselTimer = window.setInterval(function () {
          showSlide(activeSlide + 1, false);
        }, 6500);
      }
    }

    carouselTabs.forEach(function (tab, tabIndex) {
      tab.addEventListener("click", function () {
        showSlide(tabIndex, false);
        startCarousel();
      });

      tab.addEventListener("keydown", function (event) {
        if (event.key === "ArrowRight" || event.key === "ArrowLeft") {
          event.preventDefault();
          showSlide(activeSlide + (event.key === "ArrowRight" ? 1 : -1), true);
          startCarousel();
        }
      });
    });

    if (previousButton) {
      previousButton.addEventListener("click", function () {
        showSlide(activeSlide - 1, false);
        startCarousel();
      });
    }

    if (nextButton) {
      nextButton.addEventListener("click", function () {
        showSlide(activeSlide + 1, false);
        startCarousel();
      });
    }

    carousel.addEventListener("mouseenter", stopCarousel);
    carousel.addEventListener("mouseleave", startCarousel);
    carousel.addEventListener("focusin", stopCarousel);
    carousel.addEventListener("focusout", function (event) {
      if (!carousel.contains(event.relatedTarget)) {
        startCarousel();
      }
    });
    carousel.addEventListener("touchstart", function (event) {
      touchStartX = event.changedTouches[0].clientX;
      stopCarousel();
    }, { passive: true });
    carousel.addEventListener("touchend", function (event) {
      var distance = event.changedTouches[0].clientX - touchStartX;
      if (Math.abs(distance) > 48) {
        showSlide(activeSlide + (distance < 0 ? 1 : -1), false);
      }
      startCarousel();
    }, { passive: true });
    document.addEventListener("visibilitychange", function () {
      if (document.hidden) {
        stopCarousel();
      } else {
        startCarousel();
      }
    });

    showSlide(0, false);
    startCarousel();
  }

  var productTabs = Array.prototype.slice.call(document.querySelectorAll("[data-product-tab]"));
  var productPanels = Array.prototype.slice.call(document.querySelectorAll("[data-product-panel]"));

  function selectProduct(productName, focusTab) {
    productTabs.forEach(function (tab) {
      var selected = tab.getAttribute("data-product-tab") === productName;
      tab.classList.toggle("is-active", selected);
      tab.setAttribute("aria-selected", selected ? "true" : "false");
      tab.setAttribute("tabindex", selected ? "0" : "-1");
      if (selected && focusTab) {
        tab.focus();
      }
    });

    productPanels.forEach(function (panel) {
      var selected = panel.getAttribute("data-product-panel") === productName;
      panel.classList.toggle("is-active", selected);
      panel.hidden = !selected;
    });
  }

  productTabs.forEach(function (tab, tabIndex) {
    tab.addEventListener("click", function () {
      selectProduct(tab.getAttribute("data-product-tab"), false);
    });

    tab.addEventListener("keydown", function (event) {
      if (event.key !== "ArrowRight" && event.key !== "ArrowLeft" && event.key !== "ArrowDown" && event.key !== "ArrowUp") {
        return;
      }

      event.preventDefault();
      var direction = event.key === "ArrowRight" || event.key === "ArrowDown" ? 1 : -1;
      var nextIndex = (tabIndex + direction + productTabs.length) % productTabs.length;
      selectProduct(productTabs[nextIndex].getAttribute("data-product-tab"), true);
    });
  });

  var revealItems = Array.prototype.slice.call(document.querySelectorAll("[data-reveal]"));

  if (reducedMotion || !("IntersectionObserver" in window)) {
    revealItems.forEach(function (item) {
      item.classList.add("is-revealed");
    });
  } else {
    var revealObserver = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-revealed");
          revealObserver.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12 });

    pageBody.classList.add("has-reveal");
    revealItems.forEach(function (item) {
      revealObserver.observe(item);
    });
  }
})();
