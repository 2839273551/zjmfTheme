
//获取验证码
var timer// 设置倒计时
function getCode (getCodeBtn, url, code_captcha) {
  var formdata
  if (!url) return false
  if ($(getCodeBtn).data("disabled")) return false
  if (url == "register_email_send") {
    if (!$('#emailInp').val().trim()) {
      return toastr.error('邮箱不能为空')
    }
    formdata = { mk: mk, email: $('#emailInp').val(), captcha: $('#captcha_allow_register_email_captcha').val() }
  } else if (url == "register_phone_send") {
    if (!$('#phoneInp').val().trim()) {
      return toastr.error('手机号不能为空')
    }
    formdata = { mk: mk, phone: $('#phoneInp').val(), phone_code: $('#phoneCodeSel').val(), captcha: $('#captcha_allow_register_phone_captcha').val() }
  } else if (url == "login_send") {
    if (!$('#phoneInp').val().trim()) {
      return toastr.error('手机号不能为空')
    }
    formdata = { mk: mk, phone: $('#phoneInp').val(), phone_code: $('#phoneCodeSel').val(), captcha: $('#captcha_allow_login_code_captcha').val() }
  } else if (url == "login/second_verify_send") {
    var secondVerifyType = $("#secondVerifyType").val()
    if (activeLoginType !== 'phone' && activeLoginType !== 'email') return false
    formdata = { action: "login", "username": $("#" + activeLoginType + " input[name='" + activeLoginType + "']").val(), "password": (window.readAuthPassword ? window.readAuthPassword(activeLoginType) : $("#" + activeLoginType + " input[name='password']").val()), type: secondVerifyType }
  } else if (url == "reset_phone_send") {
    formdata = { mk: mk, phone: $('#phoneInp').val(), phone_code: $('#phoneCodeSel').val(), captcha: $('#captcha_allow_phone_forgetpwd_captcha').val() }
  } else if (url == "reset_email_send") {
    formdata = { mk: mk, email: $('#emailInp').val(), captcha: $('#captcha_allow_email_forgetpwd_captcha').val() }
  } else if (url == "oauth/bind_phone_send") {
    formdata = { mk: mk, phone: $('#phoneInp').val(), phone_code: $('#phoneCodeSel').val(), captcha: $('#captcha_allow_register_phone_captcha').val() }
  } else if (url == "oauth/bind_email_send") {
    formdata = { mk: mk, email: $('#emailInp').val(), captcha: $('#captcha_allow_register_email_captcha').val() }
  }

  // 定验证码参数
  if ($('input[id="captcha_randstr_'+code_captcha+'"]').length){
    formdata.captcha_randstr = $('input[id="captcha_randstr_'+code_captcha+'"]').val()
  }
  if ($('input[id="captcha_token_'+code_captcha+'"]').length){
    formdata.captcha_token = $('input[id="captcha_token_'+code_captcha+'"]').val()
  }

  $(getCodeBtn).data("disabled", true)
  $.ajax({
    type: "POST",
    url: url,
    data: formdata,
    dataType: "json",
    timeout: 15000,
    success: function (res) {
      if (res.status !== 200) {
        $(getCodeBtn).text('获取验证码')
        clearInterval(timer)
        toastr.error(res.msg)
        if (code_captcha) getVerify(code_captcha)
        if ($('input[id="captcha_randstr_'+code_captcha+'"]').length) location.reload()
        $(getCodeBtn).removeData("disabled")
      } else {
        setCutdown(getCodeBtn)
        toastr.success(res.msg)
      }

    },
    error: function (e) {
      toastr.error('验证码发送失败，请重试')
      $(getCodeBtn).removeData('disabled').prop('disabled', false)
      if (code_captcha) getVerify(code_captcha)
      if ($('input[id="captcha_randstr_'+code_captcha+'"]').length) location.reload()
    }
  })
}
function setCutdown (getCodeBtn) {
  clearInterval(timer)
  var seconds = 60
  timer = setInterval(function () {
    if (seconds == 0) {
      $(getCodeBtn).text('获取验证码')
      $(getCodeBtn).removeAttr('disabled')
      $(getCodeBtn).removeData("disabled")
      clearInterval(timer)
      return
    }
    seconds--
    $(getCodeBtn).text(seconds + 's后重试')
    $(getCodeBtn).attr('disabled', 'disabled')
    $(getCodeBtn).data("disabled", true)
  }, 1000)
}
//二次验证模态框
var activeLoginType = 'email'
function loginBefore (loginType) {
  if (loginType !== 'phone' && loginType !== 'email') return
  activeLoginType = loginType
  var password = window.readAuthPassword ? window.readAuthPassword(loginType) : $("#" + loginType + " input[name='password']").val()
  $.ajax({
    url: "/login/second_verify_page", type: "GET", dataType: "json", timeout: 15000, cache: false,
    data: {username: $("#" + loginType + " input[name='" + loginType + "']").val(), password: password, captcha: $("#" + loginType + " input[name='captcha']").val()},
    success: function (response) {
      if (String(response.status) !== '200') return toastr.error(response.msg || '登录验证失败')
      var select = document.getElementById('secondVerifyType')
      select.replaceChildren()
      ;(response.data.allow_type || []).forEach(function (item) {
        var option = document.createElement('option')
        option.value = item.name
        option.textContent = item.name_zh + ':' + item.account
        select.appendChild(option)
      })
      $('#secondVerifyModal').modal('show')
    },
    error: function () { toastr.error('二次验证请求失败，请重试') }
  })
}
$(function () {
  $('#secondVerifySubmit').on('click', function () {
    var form = document.querySelector('#' + activeLoginType + ' form')
    if (!form) return
    ;['code', 'code_type'].forEach(function (name) {
      var input = form.querySelector('input[name="' + name + '"]')
      if (!input) {
        input = document.createElement('input')
        input.type = 'hidden'
        input.name = name
        form.appendChild(input)
      }
      input.value = document.getElementById(name === 'code' ? 'secondVerifyCode' : 'secondVerifyType').value
    })
    if (form.requestSubmit) form.requestSubmit()
    else {
      var event = document.createEvent('Event')
      event.initEvent('submit', true, true)
      if (form.dispatchEvent(event)) HTMLFormElement.prototype.submit.call(form)
    }
  })
})
//收验证码和密码切换

function phoneCheck (button, phone) {
  if (button) $(button).hide().siblings().show()
  if (phone == "allow_login_phone_captcha") {
    $("#phone form").attr("action", "/login?action=phone_code")
    $(".allow_login_phone_captcha").hide()
    $(".allow_login_phone_captcha input").attr("disabled", "disabled")
    $(".allow_login_code_captcha").show()
    $(".allow_login_code_captcha input").removeAttr("disabled")
  } else if (phone == "allow_login_code_captcha") {
    $("#phone form").attr("action", "/login?action=phone")
    $(".allow_login_code_captcha").hide()
    $(".allow_login_code_captcha input").attr("disabled", "disabled")
    $(".allow_login_phone_captcha").show()
    $(".allow_login_phone_captcha input").removeAttr("disabled")
  }
}

//获取验证码
function getVerify (type, id) {
  $.ajax({
    url: setting_web_url + '/verify',
    type: 'GET',
    xhrFields: { responseType: "arraybuffer" },
    data: { name: type },
    success (data) {
      var isCaptcha = false
      //转换图片数据
      var str = String.fromCharCode.apply(null, new Uint8Array(data))
      if (str.indexOf('400') !== -1) {
        isCaptcha = false
      } else {
        isCaptcha = true
        var imgUrl = 'data:image/png;base64,' + btoa(new Uint8Array(data).reduce((data, byte) => data + String.fromCharCode(byte), ''))
        $('#' + type).attr('src', imgUrl)
        $('#' + type + id).attr('src', imgUrl)
      }
    }
  })
}

function encrypt (str) {
  const key = CryptoJS.enc.Utf8.parse("idcsmart.finance")
  const iv = CryptoJS.enc.Utf8.parse("9311019310287172")
  var encrypted = CryptoJS.AES.encrypt(str, key, {
    mode: CryptoJS.mode.CBC,
    padding: CryptoJS.pad.Pkcs7,
    iv: iv,
  }).toString()
  return encrypted
}

function encryptPass (id) {
  let pwd = document.getElementById(id)
  pwd.value = encrypt(pwd.value)
  return true
}
