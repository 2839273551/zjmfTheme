(function ($) {
  'use strict';

  if (!$) return;

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

    $(document).on('ajaxSend.codexConfigure', function (_event, _xhr, settings) {
      if (settings.url && settings.url.indexOf('action=ordersummary') !== -1) {
        $('.configoption_total').addClass('is-loading').attr('aria-busy', 'true');
      }
    });

    $(document).on('ajaxComplete.codexConfigure', function (_event, _xhr, settings) {
      if (settings.url && settings.url.indexOf('action=ordersummary') !== -1) {
        $('.configoption_total').removeClass('is-loading').removeAttr('aria-busy');
      }
    });
  });
})(window.jQuery);
