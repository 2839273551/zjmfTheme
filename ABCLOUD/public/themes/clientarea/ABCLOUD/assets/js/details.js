(function (window, $) {
  'use strict';
  var account = document.getElementById('abcloudSecurityData');
  var phoneStep = 1;
  var emailStep = 1;
  function value(selector) { return String($(selector).val() || '').trim(); }
  function state(name) { return account ? account.getAttribute('data-' + name) || '' : ''; }
  function error(message) {
    if (window.toastr) window.toastr.error(message);
    else window.alert(message);
  }
  function success(message) {
    if (window.toastr) window.toastr.success(message);
    else window.alert(message);
  }
  function request(url, method, data, button, done) {
    var control = $(button);
    if (control.prop('disabled')) return;
    control.prop('disabled', true);
    $.ajax({url: url, type: method, data: data, dataType: 'json', timeout: 20000})
      .done(function (response) {
        if (response && String(response.status) === '200') done(response);
        else error(response && response.msg || '操作未成功，请检查输入后重试。');
      })
      .fail(function () { error('请求失败，未确认操作成功，请稍后重试。'); })
      .always(function () {
        if (!control.data('counting')) control.prop('disabled', false);
      });
  }
  function captchaData(selector) {
    var data = {};
    $(selector).find('[name="captcha"], [name="captcha_token"], [name="captcha_randstr"]').each(function () {
      if (!this.disabled) data[this.name] = this.value;
    });
    return data;
  }
  function countDown(button) {
    var control = $(button);
    var remaining = 60;
    var original = control.text();
    control.data('counting', true).prop('disabled', true).text(remaining + '秒后重试');
    var timer = window.setInterval(function () {
      remaining -= 1;
      if (remaining > 0) control.text(remaining + '秒后重试');
      else {
        window.clearInterval(timer);
        control.removeData('counting').prop('disabled', false).text(original);
      }
    }, 1000);
  }
  function finish(response) {
    success(response.msg || '操作成功');
    window.location.reload();
  }
  window.handleAvatarError = function (element) {
    var replacement = document.createElement('span');
    replacement.className = 'abcloud-avatar-text';
    replacement.textContent = element.getAttribute('data-fallback') || 'U';
    if (element.parentNode) element.parentNode.replaceChild(replacement, element);
  };
  window.openPasswordModal = function () {
    $('#formPwd')[0].reset();
    $('#modalPassword').modal('show');
  };
  window.openPhoneModal = function () {
    phoneStep = state('phone') && state('phone-verified') !== '1' ? 1 : 2;
    $('#phoneStep1').toggle(phoneStep === 1);
    $('#phoneStep2').toggle(phoneStep === 2);
    $('#oldPhoneCode, #newPhoneCode').val('');
    $('#btnSubmitPhone').text(phoneStep === 1 ? '验证原手机' : '确认绑定');
    $('#modalPhone').modal('show');
  };
  window.openEmailModal = function () {
    emailStep = state('email') && state('email-verified') !== '1' ? 1 : 2;
    $('#emailStep1').show();
    $('#emailStep2').hide();
    $('#oldEmailCode, #newEmailCode').val('');
    $('#btnSubmitEmail').text(emailStep === 1 ? '验证原邮箱' : '确认绑定');
    $('#emailStep1').toggle(emailStep === 1);
    $('#emailStep2').toggle(emailStep === 2);
    $('#modalEmail').modal('show');
  };
  window.sendVerificationCode = function (action, button) {
    var phone = action.indexOf('phone_') === 0;
    var old = action.slice(-3) === 'old';
    var bound = !!state(phone ? 'phone' : 'email');
    var target = old ? state(phone ? 'phone' : 'email') : value(phone ? '#newPhoneNumber' : '#newEmailAddress');
    if (!target) return error(phone ? '请输入手机号码' : '请输入邮箱地址');
    var data = captchaData(phone ? '#phoneStep' + (old ? 1 : 2) : '#emailStep' + (old ? 1 : 2));
    var url;
    if (phone) {
      data.phone_code = old ? state('phone-code') : value('#newPhoneCountryCode');
      data[bound ? 'tel' : 'phone'] = target;
      url = bound ? '/bind_phone_code' : '/bind_phone';
    } else {
      data.email = target;
      url = bound ? '/change_email' : '/bind_email';
    }
    if (bound) data.type = old ? 1 : 2;
    request(url, phone && bound ? 'GET' : 'POST', data, button, function (response) {
      success(response.msg || '验证码已发送');
      countDown(button);
    });
  };
  window.doSubmitPhone = function () {
    var bound = !!state('phone');
    var data = {
      phone_code: phoneStep === 1 ? state('phone-code') : value('#newPhoneCountryCode'),
      code: value(phoneStep === 1 ? '#oldPhoneCode' : '#newPhoneCode')
    };
    data[bound ? 'tel' : 'phone'] = phoneStep === 1 ? state('phone') : value('#newPhoneNumber');
    if (!data.code || !(data.tel || data.phone)) return error('请填写手机号和验证码');
    if (bound) data.type = phoneStep;
    request(bound ? '/bind_phone_change' : '/bind_phone_handle', 'POST', data, '#btnSubmitPhone', function (response) {
      if (bound && phoneStep === 1) {
        phoneStep = 2;
        $('#phoneStep1').hide();
        $('#phoneStep2').show();
        $('#btnSubmitPhone').text('确认绑定');
        success(response.msg || '原手机验证成功');
      } else finish(response);
    });
  };
  window.doSubmitEmail = function () {
    var bound = !!state('email');
    var data = {
      email: emailStep === 1 ? state('email') : value('#newEmailAddress'),
      code: value(emailStep === 1 ? '#oldEmailCode' : '#newEmailCode')
    };
    if (!data.email || !data.code) return error('请填写邮箱和验证码');
    if (bound) data.type = emailStep;
    request(bound ? '/change_email_handle' : '/bind_email_handle', 'POST', data, '#btnSubmitEmail', function (response) {
      if (bound && emailStep === 1) {
        emailStep = 2;
        $('#emailStep1').hide();
        $('#emailStep2').show();
        $('#btnSubmitEmail').text('确认绑定');
        success(response.msg || '原邮箱验证成功');
      } else finish(response);
    });
  };
  window.doSubmitPassword = function () {
    var data = captchaData('#formPwd');
    data.flag = state('has-password') === '1' ? 1 : 2;
    data.old_password = $('#oldPassword').val() || '';
    data.password = $('#newPassword').val() || '';
    data.re_password = $('#renewPassword').val() || '';
    if ((data.flag === 1 && !data.old_password) || !data.password) return error('请填写密码');
    if (data.password !== data.re_password) return error('两次输入的新密码不一致');
    function submit(type, code) {
      if (code) data.code = code;
      request('/modify_password', 'POST', data, '#btnSubmitPwd', function (response) {
        success(response.msg || '密码修改成功，请重新登录');
        window.location.assign('/login');
      });
    }
    if (typeof window.isNeedSecond !== 'function') return error('安全验证组件未加载，请刷新页面后重试。');
    if (window.isNeedSecond('modify_password')) {
      if (typeof window.getSecondModal !== 'function') return error('二次验证组件未加载，请刷新页面后重试。');
      $('#modalPassword').modal('hide');
      window.getSecondModal('modify_password', submit);
    } else submit();
  };
  $(function () {
    if (!account) return;
    if (window.location.hash === '#password') window.openPasswordModal();
    if (window.location.hash === '#phone' && state('sms-enabled') === '1') window.openPhoneModal();
    if (window.location.hash === '#email' && state('email-enabled') === '1') window.openEmailModal();
  });
})(window, window.jQuery || window.$);
