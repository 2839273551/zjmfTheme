(function () {
  "use strict";

  var body = document.body;
  var reducedMotion = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  window.addEventListener("pageshow", function () {
    body.classList.remove("is-page-leaving");
  });

  if (!reducedMotion) {
    document.addEventListener("click", function (event) {
      if (event.defaultPrevented || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) {
        return;
      }

      var link = event.target.closest("a[href]");
      if (!link || link.hasAttribute("download") || link.hasAttribute("data-no-page-transition") || link.hasAttribute("data-toggle")) {
        return;
      }

      var rawHref = link.getAttribute("href");
      var target = link.getAttribute("target");
      if (!rawHref || rawHref.charAt(0) === "#" || /^javascript:/i.test(rawHref) || (target && target !== "_self")) {
        return;
      }

      if (
        body.classList.contains("cf-app-page") &&
        !link.closest("#page-topbar, .vertical-menu, .cf-dashboard, .cf-app-footer, .page-title-box")
      ) {
        return;
      }

      var targetUrl = new URL(link.href, window.location.href);
      if (targetUrl.origin !== window.location.origin || !/^https?:$/.test(targetUrl.protocol)) {
        return;
      }

      event.preventDefault();
      body.classList.add("is-page-leaving");
      window.setTimeout(function () {
        window.location.assign(targetUrl.href);
      }, 130);
    });
  }

  document.addEventListener("click", function (event) {
    var toggle = event.target.closest("[data-password-toggle]");
    if (!toggle) {
      return;
    }

    var input = document.getElementById(toggle.getAttribute("aria-controls"));
    if (!input) {
      return;
    }

    var show = input.type === "password";
    input.type = show ? "text" : "password";
    toggle.setAttribute("aria-pressed", show ? "true" : "false");
    toggle.setAttribute("aria-label", show ? "隐藏密码" : "显示密码");
    var icon = toggle.querySelector("i");
    if (icon) {
      icon.className = show ? "bx bx-hide" : "bx bx-show";
    }
  });

  if (document.documentElement.dataset.cfAuthFormsBound !== "true") {
    document.documentElement.dataset.cfAuthFormsBound = "true";
    document.addEventListener("submit", function (event) {
      var form = event.target;
      if (event.defaultPrevented || !form.closest(".cf-login-shell") || !form.checkValidity()) {
        return;
      }

      var submit = form.querySelector(".cf-auth-submit[type='submit']");
      if (!submit) {
        return;
      }

      submit.disabled = true;
      submit.setAttribute("aria-busy", "true");
      submit.classList.add("is-loading");
    });
  }

  var currentUrl = new URL(window.location.href);
  var currentLinkFound = false;

  document.querySelectorAll("#side-menu a[href]").forEach(function (link) {
    var rawHref = link.getAttribute("href");
    link.classList.remove("is-current");

    if (!rawHref || /^javascript:/i.test(rawHref) || currentLinkFound) {
      return;
    }

    var targetUrl = new URL(link.href, window.location.href);
    if (targetUrl.pathname === currentUrl.pathname && targetUrl.search === currentUrl.search) {
      link.classList.add("is-current");
      currentLinkFound = true;
    }
  });
})();
