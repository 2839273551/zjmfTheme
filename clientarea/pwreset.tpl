{if $ErrorMsg}{include file="themes/clientarea/default/error/alert.tpl" value="$ErrorMsg"}{/if}
{if $SuccessMsg}{include file="themes/clientarea/default/error/notifications.tpl" value="$SuccessMsg" url="{$Setting.system_url}/clientarea"}{/if}

<script src="/themes/clientarea/default/assets/js/public.js?v={$Ver}"></script>
<link href="/themes/clientarea/codex_framework/assets_custom/login.css?v={$Ver}-1.0.0" rel="stylesheet" type="text/css">
<script>var mk = '{$Setting.msfntk}';</script>

<main class="cf-auth-shell cf-login-shell cf-auth-shell-scroll">
  <section class="cf-auth-context" aria-label="账户安全说明">
    <a class="cf-auth-context-brand" href="{$Setting.web_jump_url}">
      {if $Setting.web_logo}<img src="{$Setting.web_logo}" alt="{$Setting.company_name}">{else/}<img src="/upload/logo.png" alt="{$Setting.company_name}">{/if}
    </a>
    <div class="cf-auth-context-copy">
      <span>ACCOUNT RECOVERY</span>
      <h1>账户密码重置</h1>
      <p>安全验证</p>
    </div>
    <nav class="cf-auth-context-links" aria-label="快捷入口"><a href="{$Setting.web_jump_url}">官网首页</a><a href="{$Setting.system_url}/cart">产品中心</a><a href="{$Setting.system_url}/knowledgebase">帮助文档</a></nav>
  </section>

  <section class="cf-auth-panel">
    <div class="cf-login-panel-topline">
      <a href="{$Setting.web_jump_url}"><i class="bx bx-left-arrow-alt" aria-hidden="true"></i><span>返回官网</span></a>
      <span class="cf-login-secure"><i aria-hidden="true"></i>安全验证</span>
    </div>
    <div class="cf-auth-panel-inner">
      {if $Setting.login_header}<div class="cf-auth-custom">{$Setting.login_header}</div>{/if}
      <a class="cf-auth-mobile-brand" href="{$Setting.web_jump_url}">
        {if $Setting.web_logo}<img src="{$Setting.web_logo}" alt="{$Setting.company_name}">{else/}<img src="/upload/logo.png" alt="{$Setting.company_name}">{/if}
      </a>
      <header class="cf-auth-heading"><span>账户安全</span><h2>重置密码</h2><p>选择已绑定的联系方式完成身份验证。</p></header>

      <ul class="cf-auth-tabs nav" role="tablist">
        {if $Pwreset.allow_login_phone}<li class="nav-item"><a class="nav-link {if $Get.action=='phone' || !$Get.action}active{/if}" data-toggle="tab" href="#phone" role="tab">{$Lang.mobile_phone_retrieval}</a></li>{/if}
        {if $Pwreset.allow_login_email}<li class="nav-item"><a class="nav-link {if ($Pwreset.allow_login_email && !$Pwreset.allow_login_phone) || $Get.action=='email'}active{/if}" data-toggle="tab" href="#email" role="tab">{$Lang.email_retrieval}</a></li>{/if}
      </ul>

      <div class="tab-content cf-auth-tab-content">
        {if $Pwreset.allow_login_email}
        <div id="email" class="tab-pane {if ($Pwreset.allow_login_email && !$Pwreset.allow_login_phone) || $Get.action=='email'}active{/if}" role="tabpanel">
          <form method="post" action="{$Setting.system_url}/pwreset?action=email">
            <div class="form-group"><label for="emailInp">{$Lang.mailbox}</label><div class="cf-auth-input"><i class="bx bx-envelope"></i><input type="email" class="form-control" id="emailInp" name="email" placeholder="{$Lang.please_input_email}" autocomplete="email" required></div></div>
            {if $Verify.allow_email_forgetpwd_captcha==1}{include file="themes/clientarea/default/includes/verify.tpl" type="allow_email_forgetpwd_captcha" positon="top"}{/if}
            <div class="form-group"><label for="emailResetCode">{$Lang.verification_code}</label><div class="input-group cf-code-input"><input type="text" class="form-control" id="emailResetCode" name="code" placeholder="{$Lang.please_enter_code}" required><div class="input-group-append"><button class="btn" type="button" onclick="getCode(this,'reset_email_send','allow_email_forgetpwd_captcha')">{$Lang.get_code}</button></div></div></div>
            <div class="form-group"><label for="emailPwd">{$Lang.password}</label><div class="cf-auth-input"><i class="bx bx-lock-alt"></i><input type="password" class="form-control" name="password" id="emailPwd" placeholder="{$Lang.please_enter_password}" autocomplete="new-password" required><button type="button" class="cf-password-toggle" data-password-toggle aria-controls="emailPwd" aria-pressed="false" aria-label="显示密码"><i class="bx bx-show"></i></button></div></div>
            <div class="form-group"><label for="emailPwdCheck">{$Lang.confirm_password}</label><div class="cf-auth-input"><i class="bx bx-lock-alt"></i><input type="password" class="form-control" name="checkPassword" id="emailPwdCheck" placeholder="{$Lang.please_password_again}" autocomplete="new-password" required><button type="button" class="cf-password-toggle" data-password-toggle aria-controls="emailPwdCheck" aria-pressed="false" aria-label="显示密码"><i class="bx bx-show"></i></button></div></div>
            <button class="btn cf-auth-submit" type="submit"><i class="bx bx-key"></i>{$Lang.reset}</button>
          </form>
        </div>
        {/if}

        {if $Pwreset.allow_login_phone}
        <div id="phone" class="tab-pane {if $Get.action=='phone' || !$Get.action}active{/if}" role="tabpanel">
          <form method="post" action="{$Setting.system_url}/pwreset?action=phone">
            <div class="form-group"><label for="phoneInp">{$Lang.phone_number}</label><div class="input-group cf-phone-input">{if $Pwreset.allow_login_register_sms_global==1}<div class="input-group-prepend"><select class="form-control" name="phone_code" id="phoneCodeSel">{foreach $SmsCountry as $list}<option value="{$list.phone_code}" {if $list.phone_code=='+86'}selected{/if}>{$list.link}</option>{/foreach}</select></div>{/if}<input type="text" class="form-control" id="phoneInp" name="phone" placeholder="{$Lang.please_enter_your_mobile_phone_number}" autocomplete="tel" required></div></div>
            {if $Verify.allow_phone_forgetpwd_captcha==1}{include file="themes/clientarea/default/includes/verify.tpl" type="allow_phone_forgetpwd_captcha" positon="top"}{/if}
            <div class="form-group"><label for="phoneResetCode">{$Lang.verification_code}</label><div class="input-group cf-code-input"><input type="text" class="form-control" id="phoneResetCode" name="code" placeholder="{$Lang.please_enter_code}" required><div class="input-group-append"><button class="btn" type="button" onclick="getCode(this,'reset_phone_send','allow_phone_forgetpwd_captcha')">{$Lang.get_code}</button></div></div></div>
            <div class="form-group"><label for="phonePwd">{$Lang.password}</label><div class="cf-auth-input"><i class="bx bx-lock-alt"></i><input type="password" class="form-control" name="password" id="phonePwd" placeholder="{$Lang.please_enter_password}" autocomplete="new-password" required><button type="button" class="cf-password-toggle" data-password-toggle aria-controls="phonePwd" aria-pressed="false" aria-label="显示密码"><i class="bx bx-show"></i></button></div></div>
            <div class="form-group"><label for="phonePwdCheck">{$Lang.confirm_password}</label><div class="cf-auth-input"><i class="bx bx-lock-alt"></i><input type="password" class="form-control" name="checkPassword" id="phonePwdCheck" placeholder="{$Lang.please_password_again}" autocomplete="new-password" required><button type="button" class="cf-password-toggle" data-password-toggle aria-controls="phonePwdCheck" aria-pressed="false" aria-label="显示密码"><i class="bx bx-show"></i></button></div></div>
            <button class="btn cf-auth-submit" type="submit"><i class="bx bx-key"></i>{$Lang.reset}</button>
          </form>
        </div>
        {/if}
      </div>

      <p class="cf-auth-switch">{$Lang.there_already_account} <a href="{$Setting.system_url}/login">{$Lang.sign_in}</a></p>
      <p class="cf-auth-legal">没有收到验证码时，请确认联系方式已绑定并检查垃圾邮件。</p>
      {if $Setting.login_footer}<div class="cf-auth-custom">{$Setting.login_footer}</div>{/if}
    </div>
  </section>
</main>
