{if $ErrorMsg}{include file="themes/clientarea/default/error/alert.tpl" value="$ErrorMsg"}{/if}
{if $SuccessMsg}{include file="themes/clientarea/default/error/notifications.tpl" value="$SuccessMsg"}{/if}

<script src="/themes/clientarea/default/assets/js/public.js?v={$Ver}"></script>
<link href="/themes/clientarea/codex_framework/assets_custom/login.css?v={$Ver}-cf-login-refined-8" rel="stylesheet" type="text/css">
<script>var mk = '{$Setting.msfntk}';</script>

<main class="cf-auth-shell cf-login-shell">
  <section class="cf-auth-context" aria-label="服务入口">
    <a class="cf-auth-context-brand" href="{$Setting.web_jump_url}">
      {if $Setting.web_logo}<img src="{$Setting.web_logo}" alt="{$Setting.company_name}">{else/}<img src="/upload/logo.png" alt="{$Setting.company_name}">{/if}
    </a>
  </section>

  <section class="cf-auth-panel">
    <div class="cf-login-panel-topline">
      <a href="{$Setting.web_jump_url}"><i class="bx bx-left-arrow-alt" aria-hidden="true"></i><span>返回官网</span></a>
      <span class="cf-login-secure"><i aria-hidden="true"></i>安全登录</span>
    </div>
    <div class="cf-auth-panel-inner">
      {if $Setting.login_header}<div class="cf-auth-custom">{$Setting.login_header}</div>{/if}
      <a class="cf-auth-mobile-brand" href="{$Setting.web_jump_url}">
        {if $Setting.web_logo}<img src="{$Setting.web_logo}" alt="{$Setting.company_name}">{else/}<img src="/upload/logo.png" alt="{$Setting.company_name}">{/if}
      </a>

      <header class="cf-auth-heading">
        <span>ACCOUNT ACCESS</span>
        <h2>欢迎回来</h2>
      </header>

      <ul class="cf-auth-tabs nav" role="tablist">
        {if $Login.allow_login_phone==1}
        <li class="nav-item">
          <a class="nav-link {if $Get.action=='phone' || $Get.action=='phone_code' || !$Get.action}active{/if}" data-toggle="tab" href="#phone" role="tab" id="tab-phone"><i class="bx bx-mobile-alt" aria-hidden="true"></i>{$Lang.mobile_login}</a>
        </li>
        {/if}
        {if $Login.allow_login_email || $Login.allow_id}
        <li class="nav-item">
          <a class="nav-link {if ($Login.allow_login_phone==0 && ($Login.allow_login_email==1 || $Login.allow_id==1)) || $Get.action=='email'}active{/if}" data-toggle="tab" href="#email" role="tab" id="tab-email">
            <i class="bx bx-envelope" aria-hidden="true"></i>{if $Login.allow_login_email}{$Lang.email_login}{else/}{$Lang.id_login}{/if}
          </a>
        </li>
        {/if}
      </ul>

      <div class="tab-content cf-auth-tab-content">
        {if $Login.allow_login_email || $Login.allow_id}
        <div id="email" class="tab-pane {if ($Login.allow_login_phone==0 && ($Login.allow_login_email==1 || $Login.allow_id==1)) || $Get.action=='email'}active{/if}" role="tabpanel">
          <form method="post" action="{$Setting.system_url}/login?action=email">
            <div class="form-group">
              <label for="emailInp">{if $Login.allow_login_email}{$Lang.mailbox}{if $Login.allow_id==1} / ID{/if}{else/}ID{/if}</label>
              <div class="cf-auth-input">
                <i class="bx bx-envelope" aria-hidden="true"></i>
                <input type="text" class="form-control" id="emailInp" name="email" value="{$Post.email}" autocomplete="username" placeholder="请输入邮箱地址或客户 ID" required>
              </div>
            </div>
            <div class="form-group">
              <label for="emailPwdInp">{$Lang.password}</label>
              <div class="cf-auth-input">
                <i class="bx bx-lock-alt" aria-hidden="true"></i>
                <input type="password" class="form-control" id="emailPwdInp" name="password" autocomplete="current-password" placeholder="{$Lang.please_enter_password}" required>
                <button type="button" class="cf-password-toggle" data-password-toggle aria-controls="emailPwdInp" aria-pressed="false" aria-label="显示密码"><i class="bx bx-show"></i></button>
              </div>
            </div>
            {if $Login.allow_login_email_captcha==1 && $Login.is_captcha==1}
              {include file="themes/clientarea/default/includes/verify.tpl" type="allow_login_email_captcha" positon="top"}
            {/if}
            <div class="cf-auth-form-meta">
              <a href="{$Setting.system_url}/pwreset">{$Lang.forget_the_password}</a>
            </div>
            {if $Login.second_verify_action_home_login==1}
            <button class="btn cf-auth-submit" type="button" onclick="loginBefore('email');"><i class="bx bx-log-in"></i>{$Lang.sign_in}</button>
            {else/}
            <button class="btn cf-auth-submit" type="submit"><i class="bx bx-log-in"></i>{$Lang.sign_in}</button>
            {/if}
          </form>
        </div>
        {/if}

        {if $Login.allow_login_phone}
        <div id="phone" class="tab-pane {if $Get.action=='phone' || $Get.action=='phone_code' || !$Get.action}active{/if}" role="tabpanel">
          <form method="post" action="{$Setting.system_url}/login?action=phone">
            <div class="form-group">
              <label for="phoneInp">{$Lang.phone_number}</label>
              <div class="input-group cf-phone-input">
                {if $Login.allow_login_register_sms_global==1}
                <div class="input-group-prepend">
                  <select class="form-control" name="phone_code" id="phoneCodeSel">
                    {foreach $SmsCountry as $list}<option value="{$list.phone_code}" {if $list.phone_code=='+86'}selected{/if}>{$list.link}</option>{/foreach}
                  </select>
                </div>
                {/if}
                <input type="text" class="form-control" id="phoneInp" name="phone" value="{$Post.phone}" autocomplete="tel" placeholder="{$Lang.please_enter_your_mobile_phone_number}" required>
              </div>
            </div>
            <div class="form-group allow_login_phone_captcha">
              <label for="phonePwdInp">{$Lang.password}</label>
              <div class="cf-auth-input">
                <i class="bx bx-lock-alt" aria-hidden="true"></i>
                <input type="password" class="form-control" id="phonePwdInp" name="password" autocomplete="current-password" placeholder="{$Lang.please_enter_password}">
                <button type="button" class="cf-password-toggle" data-password-toggle aria-controls="phonePwdInp" aria-pressed="false" aria-label="显示密码"><i class="bx bx-show"></i></button>
              </div>
            </div>
            {if $Login.allow_login_phone_captcha==1 && $Login.is_captcha==1}
              {include file="themes/clientarea/default/includes/verify.tpl" type="allow_login_phone_captcha" positon="top"}
            {/if}
            {if $Login.allow_login_code_captcha==1 && $Login.is_captcha==1}
              {include file="themes/clientarea/default/includes/verify.tpl" type="allow_login_code_captcha" positon="top"}
            {/if}
            <div class="form-group allow_login_code_captcha">
              <label for="phoneCodeInp">{$Lang.verification_code}</label>
              <div class="input-group cf-code-input">
                <input type="text" class="form-control" id="phoneCodeInp" name="code" value="{$Post.code}" placeholder="{$Lang.please_enter_code}">
                <div class="input-group-append"><button class="btn" type="button" onclick="getCode(this,'login_send','allow_login_code_captcha')">{$Lang.get_code}</button></div>
              </div>
            </div>
            <div class="cf-auth-form-meta">
              <button type="button" onclick="phoneCheck(this,'allow_login_code_captcha')" class="cf-link-button allow_login_code_captcha">{$Lang.password_login}</button>
              <button type="button" onclick="phoneCheck(this,'allow_login_phone_captcha')" class="cf-link-button allow_login_phone_captcha">{$Lang.verification_code_login}</button>
              <a href="{$Setting.system_url}/pwreset">{$Lang.forget_the_password}</a>
            </div>
            {if $Login.second_verify_action_home_login==1}
            <button class="btn cf-auth-submit allow_login_phone_captcha" type="button" onclick="loginBefore('phone');"><i class="bx bx-log-in"></i>{$Lang.sign_in}</button>
            <button class="btn cf-auth-submit allow_login_code_captcha" type="submit"><i class="bx bx-log-in"></i>{$Lang.sign_in}</button>
            {else/}
            <button class="btn cf-auth-submit" type="submit"><i class="bx bx-log-in"></i>{$Lang.sign_in}</button>
            {/if}
          </form>
        </div>
        {/if}
      </div>

      {if $Oauth}
      <div class="cf-auth-oauth">
        <span>{$Lang.use_other_login}</span>
        <div>{foreach $Oauth as $list}<a href="{$list.url}" target="_blank" rel="noopener">{$list.img}</a>{/foreach}</div>
      </div>
      {/if}

      <p class="cf-auth-switch">{$Lang.no_account_yet} <a href="{$Setting.system_url}/register">{$Lang.register_now}</a></p>
      <p class="cf-auth-legal">登录即同意 <a href="{$Setting.web_tos_url}" target="_blank" rel="noopener">服务条款</a> 与 <a href="{$Setting.web_privacy_url}" target="_blank" rel="noopener">隐私政策</a></p>
      {if $Setting.login_footer}<div class="cf-auth-custom">{$Setting.login_footer}</div>{/if}
    </div>
  </section>
</main>

{if $Login.second_verify_action_home_login==1}
<div class="modal fade" id="secondVerifyModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header"><h5 class="modal-title">{$Lang.secondary_verification}</h5><button type="button" class="close" data-dismiss="modal" aria-label="关闭"><span aria-hidden="true">&times;</span></button></div>
      <div class="modal-body">
        <form>
          <input type="hidden" value="{$Token}">
          <input type="hidden" value="closed" name="action">
          <div class="form-group row"><label class="col-sm-3 col-form-label text-right" for="secondVerifyType">{$Lang.verification_method}</label><div class="col-sm-8"><select class="form-control" name="type" id="secondVerifyType"></select></div></div>
          <div class="form-group row mb-0"><label class="col-sm-3 col-form-label text-right" for="secondVerifyCode">{$Lang.verification_code}</label><div class="col-sm-8"><div class="input-group"><input type="text" name="code" id="secondVerifyCode" class="form-control" placeholder="{$Lang.please_enter_code}"><div class="input-group-append" id="getCodeBox"><button class="btn btn-secondary" type="button" onclick="getCode(this,'login/second_verify_send')">{$Lang.get_code}</button></div></div></div></div>
        </form>
      </div>
      <div class="modal-footer"><button type="button" class="btn btn-outline-secondary" data-dismiss="modal">{$Lang.cancel}</button><button type="button" class="btn btn-primary" id="secondVerifySubmit">{$Lang.determine}</button></div>
    </div>
  </div>
</div>
{/if}

<script>
  {if $Get.action=='phone_code'}phoneCheck('', 'allow_login_phone_captcha');{else/}phoneCheck('', 'allow_login_code_captcha');{/if}
</script>
