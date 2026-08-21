<section class="admin-main">
  <div class="container-fluid">
    <div class="page-container">
      <div class="card">
        <div class="card-body">
          <div class="card-title row align-items-center">
            <div class="col-lg-4 col-md-12">{$Title}</div>
            <div class="col-lg-8 col-md-12">
              {foreach $PluginsAdminMenu as $v}
                {if $v['custom']}
                  <a class="h5 ml-2" href="{$v.url}" target="_blank">{$v.name}</a>
                {else/}
                  <a class="h5 ml-2" href="{$v.url}">{$v.name}</a>
                {/if}
              {/foreach}
            </div>
          </div>

          <div id="geetest-config-feedback" class="alert d-none" role="alert"></div>

          <form id="geetest-config" class="mt-4" autocomplete="off">
            <div class="form-group row">
              <label class="col-sm-3 col-form-label" for="captcha-id">Captcha ID / API Key</label>
              <div class="col-sm-7">
                <input
                  id="captcha-id"
                  class="form-control"
                  type="text"
                  name="captcha_id"
                  maxlength="255"
                  value="{$Data.captcha_id|htmlspecialchars}"
                  required
                >
                <small class="form-text text-muted">从极验 GT4 后台复制，该值会下发到浏览器。</small>
              </div>
            </div>

            <div class="form-group row">
              <label class="col-sm-3 col-form-label" for="captcha-key">Captcha Key / 私钥</label>
              <div class="col-sm-7">
                <div class="input-group">
                  <input
                    id="captcha-key"
                    class="form-control"
                    type="password"
                    name="captcha_key"
                    maxlength="255"
                    value="{$Data.captcha_key|htmlspecialchars}"
                    required
                  >
                  <div class="input-group-append">
                    <button id="toggle-captcha-key" class="btn btn-outline-secondary" type="button" title="显示或隐藏私钥" aria-label="显示或隐藏私钥">
                      <i class="fas fa-eye" aria-hidden="true"></i>
                    </button>
                  </div>
                </div>
                <small class="form-text text-muted">仅用于服务端二次校验，不会发送给浏览器。</small>
              </div>
            </div>

            <div class="form-group row">
              <label class="col-sm-3 col-form-label" for="product">展现方式</label>
              <div class="col-sm-7">
                <select id="product" class="form-control" name="product">
                  <option value="bind" {if $Data.product == 'bind'}selected{/if}>隐藏触发（提交时唤起，推荐）</option>
                  <option value="popup" {if $Data.product == 'popup'}selected{/if}>弹出式</option>
                  <option value="float" {if $Data.product == 'float'}selected{/if}>浮动式</option>
                </select>
              </div>
            </div>

            <div class="form-group row">
              <label class="col-sm-3 col-form-label" for="risk-type">验证方式</label>
              <div class="col-sm-7">
                <select id="risk-type" class="form-control" name="risk_type">
                  <option value="auto" {if $Data.risk_type == 'auto'}selected{/if}>智能策略（由极验配置决定）</option>
                  <option value="slide" {if $Data.risk_type == 'slide'}selected{/if}>滑动拼图验证</option>
                  <option value="icon" {if $Data.risk_type == 'icon'}selected{/if}>图标点选验证</option>
                  <option value="ai" {if $Data.risk_type == 'ai'}selected{/if}>一点即过 / 无感验证</option>
                  <option value="word" {if $Data.risk_type == 'word'}selected{/if}>文字点选验证</option>
                  <option value="phrase" {if $Data.risk_type == 'phrase'}selected{/if}>字序点选验证</option>
                  <option value="match" {if $Data.risk_type == 'match'}selected{/if}>消消乐验证</option>
                  <option value="winlinze" {if $Data.risk_type == 'winlinze'}selected{/if}>五子棋验证</option>
                </select>
              </div>
            </div>

            <div class="form-group row">
              <span class="col-sm-3 col-form-label">启用页面</span>
              <div class="col-sm-7">
                <input type="hidden" name="enable_login" value="1">

                <div class="custom-control custom-switch mb-3">
                  <input id="enable-login" class="custom-control-input" type="checkbox" checked disabled>
                  <label class="custom-control-label" for="enable-login">登录页（强制开启）</label>
                </div>

                <div class="custom-control custom-switch mb-3">
                  <input id="enable-register" class="custom-control-input" type="checkbox" name="enable_register" value="1" {if $Data.enable_register == 1}checked{/if}>
                  <label class="custom-control-label" for="enable-register">注册页</label>
                </div>

                <div class="custom-control custom-switch">
                  <input id="enable-password" class="custom-control-input" type="checkbox" name="enable_password" value="1" {if $Data.enable_password == 1}checked{/if}>
                  <label class="custom-control-label" for="enable-password">修改密码与重置密码页</label>
                </div>
              </div>
            </div>

            <div class="form-group row mb-0">
              <div class="col-sm-7 offset-sm-3">
                <button id="save-geetest-config" class="btn btn-primary" type="submit">
                  <i class="fas fa-save mr-1" aria-hidden="true"></i>保存设置
                </button>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</section>

<script>
(function ($) {
  'use strict';

  var $form = $('#geetest-config');
  var $feedback = $('#geetest-config-feedback');
  var $saveButton = $('#save-geetest-config');
  var $keyInput = $('#captcha-key');
  var $keyIcon = $('#toggle-captcha-key i');

  $('#toggle-captcha-key').on('click', function () {
    var reveal = $keyInput.attr('type') === 'password';
    $keyInput.attr('type', reveal ? 'text' : 'password');
    $keyIcon.toggleClass('fa-eye', !reveal).toggleClass('fa-eye-slash', reveal);
  });

  $form.on('submit', function (event) {
    event.preventDefault();
    $feedback.addClass('d-none').removeClass('alert-success alert-danger');
    $saveButton.prop('disabled', true);

    $.ajax({
      url: "{:shd_addon_url('GeetestCaptcha://AdminIndex/submit')}",
      type: 'post',
      data: $form.serialize(),
      dataType: 'json'
    }).done(function (response) {
      var success = Number(response.code) === 200;
      $feedback
        .removeClass('d-none')
        .addClass(success ? 'alert-success' : 'alert-danger')
        .text(response.msg || (success ? '保存成功。' : '保存失败。'));
    }).fail(function () {
      $feedback
        .removeClass('d-none')
        .addClass('alert-danger')
        .text('请求失败，请检查网络后重试。');
    }).always(function () {
      $saveButton.prop('disabled', false);
    });
  });
})(window.jQuery);
</script>
