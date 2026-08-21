{if $ErrorMsg}{include file="themes/clientarea/default/error/alert.tpl" value="$ErrorMsg"}{/if}
{if $SuccessMsg}{include file="themes/clientarea/default/error/notifications.tpl" value="$SuccessMsg"}{/if}

<script src="/themes/clientarea/default/assets/js/public.js?v={$Ver}"></script>
<link href="/themes/clientarea/codex_framework/assets_custom/login.css?v={$Ver}-cf-login-refined-8" rel="stylesheet" type="text/css">
<script>var mk = '{$Setting.msfntk}';</script>

<main class="cf-auth-shell cf-login-shell cf-auth-shell-scroll">
  <section class="cf-auth-context" aria-label="注册说明">
    <a class="cf-auth-context-brand" href="{$Setting.web_jump_url}">
      {if $Setting.web_logo}<img src="{$Setting.web_logo}" alt="{$Setting.company_name}">{else/}<img src="/upload/logo.png" alt="{$Setting.company_name}">{/if}
    </a>
    <div class="cf-auth-context-copy">
      <span>CREATE ACCOUNT</span>
      <h1>创建 {$Setting.company_name} 账户</h1>
      <p>新用户注册</p>
    </div>
    <nav class="cf-auth-context-links" aria-label="快捷入口"><a href="{$Setting.web_jump_url}">官网首页</a><a href="{$Setting.system_url}/cart">产品中心</a><a href="{$Setting.system_url}/knowledgebase">帮助文档</a></nav>
  </section>

  <section class="cf-auth-panel">
    <div class="cf-login-panel-topline">
      <a href="{$Setting.web_jump_url}"><i class="bx bx-left-arrow-alt" aria-hidden="true"></i><span>返回官网</span></a>
      <span class="cf-login-secure"><i aria-hidden="true"></i>安全注册</span>
    </div>
    <div class="cf-auth-panel-inner">
      {if $Setting.login_header}<div class="cf-auth-custom">{$Setting.login_header}</div>{/if}
      <a class="cf-auth-mobile-brand" href="{$Setting.web_jump_url}">
        {if $Setting.web_logo}<img src="{$Setting.web_logo}" alt="{$Setting.company_name}">{else/}<img src="/upload/logo.png" alt="{$Setting.company_name}">{/if}
      </a>
      <header class="cf-auth-heading"><span>新用户注册</span><h2>创建账户</h2><p>验证联系方式后即可进入用户中心。</p></header>

      <ul class="cf-auth-tabs nav" role="tablist">
        {if $Register.allow_register_phone}<li class="nav-item"><a class="nav-link {if $Get.action=='phone' || !$Get.action}active{/if}" data-toggle="tab" href="#phone" role="tab">{$Lang.mobile_registration}</a></li>{/if}
        {if $Register.allow_register_email}<li class="nav-item"><a class="nav-link {if ($Register.allow_register_email && !$Register.allow_register_phone) || $Get.action=='email'}active{/if}" data-toggle="tab" href="#email" role="tab">{$Lang.email_registration}</a></li>{/if}
      </ul>

      <div class="tab-content cf-auth-tab-content">
        {if $Register.allow_register_email}
        <div id="email" class="tab-pane {if ($Register.allow_register_email && !$Register.allow_register_phone) || $Get.action=='email'}active{/if}" role="tabpanel">
          <form class="needs-validation" novalidate method="post" action="{$Setting.system_url}/register?action=email" onsubmit="return beforeSubmit(this);">
            <div class="form-group"><label for="emailInp">{$Lang.mailbox}</label><div class="cf-auth-input"><i class="bx bx-envelope"></i><input type="email" class="form-control" id="emailInp" name="email" placeholder="{$Lang.please_input_email}" value="{$Post.email}" autocomplete="email" required></div></div>
            {if $Verify.allow_register_email_captcha==1}{include file="themes/clientarea/default/includes/verify.tpl" type="allow_register_email_captcha" positon="top"}{/if}
            {if $Register.allow_email_register_code==1}
            <div class="form-group"><label for="emailRegisterCode">{$Lang.verification_code}</label><div class="input-group cf-code-input"><input type="text" class="form-control" id="emailRegisterCode" name="code" placeholder="{$Lang.please_enter_code}" value="{$Post.code}" required><div class="input-group-append"><button class="btn" type="button" onclick="getCode(this,'register_email_send','allow_register_email_captcha')">{$Lang.get_code}</button></div></div></div>
            {/if}
            <div class="form-group"><label for="phonePwd">{$Lang.password}</label><div class="cf-auth-input"><i class="bx bx-lock-alt"></i><input type="password" class="form-control" name="password" id="phonePwd" placeholder="{$Lang.please_enter_password}" autocomplete="new-password" required><button type="button" class="cf-password-toggle" data-password-toggle aria-controls="phonePwd" aria-pressed="false" aria-label="显示密码"><i class="bx bx-show"></i></button></div></div>
            <div class="form-group"><label for="phonePwdCheck">{$Lang.confirm_password}</label><div class="cf-auth-input"><i class="bx bx-lock-alt"></i><input type="password" class="form-control" name="checkPassword" id="phonePwdCheck" placeholder="{$Lang.please_password_again}" autocomplete="new-password" required><button type="button" class="cf-password-toggle" data-password-toggle aria-controls="phonePwdCheck" aria-pressed="false" aria-label="显示密码"><i class="bx bx-show"></i></button></div></div>

            {foreach $Register.login_register_custom_require as $custom}
            <div class="form-group"><label for="{$custom.name}">{$Register[login_register_custom_require_list][$custom.name]}</label><input type="{if $custom.name=='password'}password{else}text{/if}" class="form-control" name="{$custom.name}" id="{$custom.name}" value="{$Post[$custom.name]}"></div>
            {/foreach}
            {foreach $Register.fields as $k=>$list}
            <div class="form-group cf-custom-field"><label for="field-email-{$list.id}">{$list.fieldname}</label>
              {if $list.fieldtype=='dropdown'}<select id="field-email-{$list.id}" name="fields[{$list.id}]" class="form-control">{foreach $list.dropdown_option as $key=>$val}<option value="{$key}" {if(isset($_fields[$key]))}selected{/if}>{$val}</option>{/foreach}</select>
              {elseif $list.fieldtype=='password'}<input id="field-email-{$list.id}" name="fields[{$list.id}]" type="password" {if(isset($_fields[$list['id']]))}value="{$_fields[$list['id']]}"{/if} class="form-control">
              {elseif $list.fieldtype=='text' || $list.fieldtype=='link'}<input id="field-email-{$list.id}" name="fields[{$list.id}]" type="text" class="form-control" {if(isset($_fields[$list['id']]))}value="{$_fields[$list['id']]}"{/if}>
              {elseif $list.fieldtype=='tickbox'}<label class="cf-inline-check"><input id="field-email-{$list.id}" type="checkbox" name="fields[{$list.id}]" {if(isset($_fields[$list['id']]))}checked{/if}><span>{$list.fieldname}</span></label>
              {elseif $list.fieldtype=='textarea'}<textarea id="field-email-{$list.id}" name="fields[{$list.id}]" rows="4" class="form-control">{if(isset($_fields[$list['id']]))}{$_fields[$list['id']]}{/if}</textarea>{/if}
            </div>
            {/foreach}
            {if $setsaler=='2'}<div class="form-group"><label for="emailSaleId">{$Lang.sales_representative}</label><select name="sale_id" id="emailSaleId" class="form-control"><option value="0">{$Lang.nothing}</option>{foreach $saler as $list}<option value="{$list.id}" {if $list.id==$Post.id}selected{/if}>{$list.user_nickname}</option>{/foreach}</select></div>{/if}
            <button class="btn cf-auth-submit" type="submit"><i class="bx bx-user-plus"></i>{$Lang.register}</button>
          </form>
        </div>
        {/if}

        {if $Register.allow_register_phone}
        <div id="phone" class="tab-pane {if $Get.action=='phone' || !$Get.action}active{/if}" role="tabpanel">
          <form class="needs-validation" novalidate method="post" action="{$Setting.system_url}/register?action=phone" onsubmit="return beforeSubmit(this);">
            <div class="form-group"><label for="phoneInp">{$Lang.phone_number}</label><div class="input-group cf-phone-input">{if $Register.allow_login_register_sms_global==1}<div class="input-group-prepend"><select class="form-control" name="phone_code" id="phoneCodeSel">{foreach $SmsCountry as $list}<option value="{$list.phone_code}" {if $list.phone_code=='+86'}selected{/if}>{$list.link}</option>{/foreach}</select></div>{/if}<input type="text" class="form-control" id="phoneInp" name="phone" placeholder="{$Lang.please_enter_your_mobile_phone_number}" value="{$Post.phone}" autocomplete="tel" required></div></div>
            {if $Verify.allow_register_phone_captcha==1}{include file="themes/clientarea/default/includes/verify.tpl" type="allow_register_phone_captcha" positon="top"}{/if}
            <div class="form-group"><label for="phoneRegisterCode">{$Lang.verification_code}</label><div class="input-group cf-code-input"><input type="text" class="form-control" id="phoneRegisterCode" name="code" placeholder="{$Lang.please_enter_code}" value="{$Post.code}" required><div class="input-group-append"><button class="btn" type="button" onclick="getCode(this,'register_phone_send','allow_register_phone_captcha')">{$Lang.get_code}</button></div></div></div>
            <div class="form-group"><label for="emailPwd">{$Lang.password}</label><div class="cf-auth-input"><i class="bx bx-lock-alt"></i><input type="password" class="form-control" name="password" id="emailPwd" placeholder="{$Lang.please_enter_password}" autocomplete="new-password" required><button type="button" class="cf-password-toggle" data-password-toggle aria-controls="emailPwd" aria-pressed="false" aria-label="显示密码"><i class="bx bx-show"></i></button></div></div>
            <div class="form-group"><label for="emailPwdCheck">{$Lang.confirm_password}</label><div class="cf-auth-input"><i class="bx bx-lock-alt"></i><input type="password" class="form-control" name="checkPassword" id="emailPwdCheck" placeholder="{$Lang.please_password_again}" autocomplete="new-password" required><button type="button" class="cf-password-toggle" data-password-toggle aria-controls="emailPwdCheck" aria-pressed="false" aria-label="显示密码"><i class="bx bx-show"></i></button></div></div>

            {foreach $Register.login_register_custom_require as $custom}
            <div class="form-group"><label for="{$custom.name}">{$Register[login_register_custom_require_list][$custom.name]}</label><input type="{if $custom.name=='password'}password{else}text{/if}" class="form-control" name="{$custom.name}" id="{$custom.name}" value="{$Post[$custom.name]}"></div>
            {/foreach}
            {foreach $Register.fields as $k=>$list}
            <div class="form-group cf-custom-field"><label for="field-phone-{$list.id}">{$list.fieldname}</label>
              {if $list.fieldtype=='dropdown'}<select id="field-phone-{$list.id}" name="fields[{$list.id}]" class="form-control">{foreach $list.dropdown_option as $key=>$val}<option value="{$key}" {if(isset($_fields[$key]))}selected{/if}>{$val}</option>{/foreach}</select>
              {elseif $list.fieldtype=='password'}<input id="field-phone-{$list.id}" name="fields[{$list.id}]" type="password" {if(isset($_fields[$list['id']]))}value="{$_fields[$list['id']]}"{/if} class="form-control">
              {elseif $list.fieldtype=='text' || $list.fieldtype=='link'}<input id="field-phone-{$list.id}" name="fields[{$list.id}]" type="text" class="form-control" {if(isset($_fields[$list['id']]))}value="{$_fields[$list['id']]}"{/if}>
              {elseif $list.fieldtype=='tickbox'}<label class="cf-inline-check"><input id="field-phone-{$list.id}" type="checkbox" name="fields[{$list.id}]" {if(isset($_fields[$list['id']]))}checked{/if}><span>{$list.fieldname}</span></label>
              {elseif $list.fieldtype=='textarea'}<textarea id="field-phone-{$list.id}" name="fields[{$list.id}]" rows="4" class="form-control">{if(isset($_fields[$list['id']]))}{$_fields[$list['id']]}{/if}</textarea>{/if}
            </div>
            {/foreach}
            {if $setsaler=='2'}<div class="form-group"><label for="phoneSaleId">{$Lang.sales_representative}</label><select name="sale_id" id="phoneSaleId" class="form-control"><option value="0">{$Lang.nothing}</option>{foreach $saler as $list}<option value="{$list.id}" {if $Post.sale_id==$list.id}selected{/if}>{$list.user_nickname}</option>{/foreach}</select></div>{/if}
            <button class="btn cf-auth-submit" type="submit"><i class="bx bx-user-plus"></i>{$Lang.register}</button>
          </form>
        </div>
        {/if}
      </div>

      <label class="cf-auth-agreement" for="agreePrivacy"><input type="checkbox" id="agreePrivacy"><span>{$Lang.have_read_agree} <a href="{$Setting.web_tos_url}" target="_blank" rel="noopener">{$Lang.terms_service}</a> {$Lang.ands} <a href="{$Setting.web_privacy_url}" target="_blank" rel="noopener">{$Lang.privacy_policy}</a></span></label>
      <p class="cf-auth-switch">{$Lang.there_already_account} <a href="{$Setting.system_url}/login">{$Lang.sign_in}</a></p>
      {if $Setting.login_footer}<div class="cf-auth-custom">{$Setting.login_footer}</div>{/if}
    </div>
  </section>
</main>

<script>
  function beforeSubmit(form) {
    if (!form.reportValidity()) {
      return false;
    }
    if (!document.getElementById('agreePrivacy').checked) {
      toastr.error('{$Lang.check_privacy}');
      return false;
    }
    return true;
  }
</script>
