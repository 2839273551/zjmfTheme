(function ($) {
  "use strict";

  if (!$) {
    return;
  }

  var $sourceList = $("#sourceListBox");

  if (!$sourceList.length) {
    return;
  }

  function escapeHtml(value) {
    return $("<div>").text(value || "").html();
  }

  function loadResources() {
    var loadingText = $sourceList.data("loading") || "数据加载中";
    var errorText = $sourceList.data("error") || "资源列表加载失败，请稍后重试";

    $sourceList.attr("aria-busy", "true").html(
      '<div class="cf-loading-state">' + escapeHtml(loadingText) + "...</div>"
    );

    $.ajax({
      type: "GET",
      url: setting_web_url + "/clientarea",
      data: { action: "list" },
      success: function (html) {
        $sourceList.html(html);
      },
      error: function () {
        $sourceList.html(
          '<div class="cf-error-state"><span>' +
            escapeHtml(errorText) +
            '</span><button type="button" class="btn btn-sm btn-outline-primary" data-source-retry>重试</button></div>'
        );
      },
      complete: function () {
        $sourceList.attr("aria-busy", "false");
      }
    });
  }

  $(document).on("click", "[data-source-retry]", function () {
    loadResources();
  });

  $(loadResources);
  window.loadClientResources = loadResources;
})(window.jQuery);
