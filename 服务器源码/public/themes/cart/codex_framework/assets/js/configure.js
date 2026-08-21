(function ($) {
  'use strict';

  if (!$) return;

  var summaryRequestId = 0;
  var activeSummaryRequest = null;
  var summaryHtmlBeforeRequest = '';

  function isSummaryRequest(settings) {
    return settings.url && settings.url.indexOf('action=ordersummary') !== -1;
  }

  function setSummaryLoading() {
    var summary = $('.configoption_total');

    if (!summary.hasClass('is-loading')) {
      summaryHtmlBeforeRequest = summary.html() || '';
    }

    summary
      .find('.configure-summary-error')
      .remove();

    summary
      .removeClass('is-error')
      .addClass('is-loading')
      .attr({
        'aria-busy': 'true',
        'aria-live': 'polite',
        'aria-atomic': 'true'
      });

    $('#addToCartBtn,#addToCartBtnTwo').prop('disabled', true);
  }

  function finishSummaryLoading() {
    $('.configoption_total')
      .removeClass('is-loading is-error')
      .attr('aria-busy', 'false');
    $('#addToCartBtn,#addToCartBtnTwo').prop('disabled', false);
  }

  function showSummaryError() {
    var summary = $('.configoption_total');
    var errorHtml =
      '<div class="configure-summary-error" role="alert">' +
        '<strong>配置价格计算失败</strong>' +
        '<span>请检查网络连接后重新计算。</span>' +
        '<button type="button" class="configure-summary-retry" data-configure-summary-retry>重新计算</button>' +
      '</div>';

    summary
      .removeClass('is-loading')
      .addClass('is-error')
      .attr('aria-busy', 'false');
    $('#addToCartBtn,#addToCartBtnTwo').prop('disabled', true);

    if (summaryHtmlBeforeRequest) {
      summary.html(summaryHtmlBeforeRequest).prepend(errorHtml);
    } else {
      summary.prepend(errorHtml);
    }
  }

  $.ajaxPrefilter(function (options, _originalOptions, jqXHR) {
    if (!isSummaryRequest(options)) return;

    var previousRequest = activeSummaryRequest;
    var requestId = ++summaryRequestId;

    jqXHR.codexSummaryRequestId = requestId;
    activeSummaryRequest = jqXHR;
    setSummaryLoading();

    if (previousRequest && previousRequest.readyState !== 4) {
      previousRequest.abort('codex-replaced');
    }
  });

  $(document).on('ajaxSend.codexConfigure', function (_event, xhr, settings) {
    if (isSummaryRequest(settings) && xhr.codexSummaryRequestId == null) {
      var requestId = ++summaryRequestId;
      xhr.codexSummaryRequestId = requestId;
      activeSummaryRequest = xhr;
      setSummaryLoading();
    }
  });

  function updatePasswordToggleLabel() {
    var passwordInput = $('#password');
    var revealControl = $('.bx-show-alt');

    if (!passwordInput.length || !revealControl.length) return;

    revealControl.attr({
      role: 'button',
      tabindex: '0',
      'aria-label': passwordInput.attr('type') === 'password' ? '显示密码' : '隐藏密码',
      'data-label': passwordInput.attr('type') === 'password' ? '显示' : '隐藏'
    });
  }

  $(function () {
    var passwordInput = $('#password');
    var randomPasswordControl = $('.create_random_pass');

    if (passwordInput.length) {
      passwordInput.attr({
        type: 'password',
        autocomplete: 'new-password',
        spellcheck: 'false'
      });
      updatePasswordToggleLabel();
    }

    $('.bx-show-alt').on('click.codexConfigure', function () {
      window.setTimeout(updatePasswordToggleLabel, 0);
    }).on('keydown.codexConfigure', function (event) {
      if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault();
        this.click();
      }
    });

    randomPasswordControl.attr({
      role: 'button',
      tabindex: '0',
      'aria-label': '生成随机密码',
      'data-label': '随机'
    }).on('keydown.codexConfigure', function (event) {
      if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault();
        this.click();
      }
    });

    $(document).on('click.codexConfigure', '[data-configure-summary-retry]', function () {
      if (typeof window.configoption_ajax === 'function') {
        window.configoption_ajax();
      }
    });
  });

  $(document).on('ajaxSuccess.codexConfigure', function (_event, xhr, settings) {
    if (
      isSummaryRequest(settings) &&
      xhr.codexSummaryRequestId === summaryRequestId
    ) {
      finishSummaryLoading();
    }
  });

  $(document).on('ajaxError.codexConfigure', function (_event, xhr, settings, errorThrown) {
    if (
      !isSummaryRequest(settings) ||
      xhr.codexSummaryRequestId !== summaryRequestId ||
      errorThrown === 'abort' ||
      errorThrown === 'codex-replaced'
    ) {
      return;
    }

    showSummaryError();
  });

  $(document).on('ajaxComplete.codexConfigure', function (_event, xhr, settings) {
    if (
      isSummaryRequest(settings) &&
      xhr.codexSummaryRequestId === summaryRequestId
    ) {
      activeSummaryRequest = null;
    }
  });
})(window.jQuery);
