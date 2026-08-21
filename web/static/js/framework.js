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

  if (!toggle || !navigation) {
    return;
  }

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
})();
