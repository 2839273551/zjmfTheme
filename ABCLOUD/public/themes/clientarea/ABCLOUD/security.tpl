<link href="/themes/clientarea/ABCLOUD/assets/css/details.css?v=3.0.0" rel="stylesheet" />
{include file="includes/modal"}
<div id="abcloudSecurityData" hidden data-phone="{$Userinfo.user.phonenumber|htmlentities}" data-email="{$Userinfo.user.email|htmlentities}" data-phone-code="{$Userinfo.user.phone_code|default='+86'|htmlentities}" data-phone-verified="{$BindPhoneChange|intval}" data-email-verified="{$BindEmailChange|intval}" data-has-password="{if $Userinfo.user.is_password}1{else}0{/if}" data-sms-enabled="{if $Userinfo.shd_allow_sms_send}1{else}0{/if}" data-email-enabled="{if $Userinfo.shd_allow_email_send}1{else}0{/if}"></div>
<div class="abcloud-profile-container">
  <div class="abcloud-profile-card">
    <div class="abcloud-profile-header-title abcloud-security-heading"><span><i class="bx bx-shield-quarter text-primary"></i> 安全中心与密钥凭证</span><a href="/details" class="btn btn-sm btn-outline-primary">返回个人资料</a></div>
    <div class="abcloud-security-banner">
      <i class="bx bxs-check-shield text-primary"></i>
      <div><strong>账户安全设置</strong><p>建议定期更新密码并绑定安全手机与邮箱，确保业务操作与资产安全。</p></div>
      {if $Userinfo.allow_second_verify}<span class="badge badge-primary">二次验证{if $Userinfo.user.second_verify}已开启{else}未开启{/if}</span>{/if}
    </div>
    <div class="abcloud-security-grid">
      <div class="abcloud-security-tile"><i class="bx bx-key text-primary"></i><div><strong>登录密码</strong><p>{if $Userinfo.user.is_password}已设置登录密码，建议定期更换{else}尚未设置登录密码{/if}</p></div><button type="button" class="btn btn-sm btn-outline-primary" onclick="openPasswordModal();">{if $Userinfo.user.is_password}修改密码{else}设置密码{/if}</button></div>
      <div class="abcloud-security-tile"><i class="bx bx-mobile-alt text-success"></i><div><strong>安全手机</strong><p>{if $Userinfo.user.phonenumber}已绑定：{$Userinfo.user.phonenumber|substr=0,3|htmlentities}****{$Userinfo.user.phonenumber|substr=-4|htmlentities}{else}未绑定手机号{/if}</p></div>{if $Userinfo.shd_allow_sms_send}<button type="button" class="btn btn-sm btn-outline-primary" onclick="openPhoneModal();">{if $Userinfo.user.phonenumber}更换手机{else}立即绑定{/if}</button>{else}<span class="text-muted">短信未开启</span>{/if}</div>
      <div class="abcloud-security-tile"><i class="bx bx-envelope text-info"></i><div><strong>安全邮箱</strong><p>{if $Userinfo.user.email}已绑定：{$Userinfo.user.email|htmlentities}{else}未绑定邮箱{/if}</p></div>{if $Userinfo.shd_allow_email_send}<button type="button" class="btn btn-sm btn-outline-primary" onclick="openEmailModal();">{if $Userinfo.user.email}更换邮箱{else}立即绑定{/if}</button>{else}<span class="text-muted">邮件未开启</span>{/if}</div>
      {if $Setting.certifi_open==1}<div class="abcloud-security-tile"><i class="bx bx-id-card text-warning"></i><div><strong>实名认证</strong><p>{if $Userinfo.user.certifi.status==1}已通过实名认证{else}查看认证状态并提交材料{/if}</p></div><a href="/verified" class="btn btn-sm btn-outline-primary">管理认证</a></div>{/if}
    </div>
    <div class="abcloud-security-api"><div><strong>开发者 API 管理</strong><p>管理 API 接口、访问凭证与 IP 白名单。</p></div>{if $Userinfo.allow_resource_api}<a href="/apimanage" class="btn btn-primary">进入 API 管理</a>{else}<span class="text-muted">当前账户未开放 API 功能</span>{/if}</div>
    <a href="/systemlog" class="abcloud-tab-item"><i class="bx bx-history"></i> 查看账户操作日志</a>
  </div>
</div>
<div class="modal fade abcloud-modal" id="modalPassword" tabindex="-1" role="dialog" aria-labelledby="passwordTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document"><div class="modal-content">
    <div class="modal-header"><h5 class="modal-title" id="passwordTitle">{if $Userinfo.user.is_password}修改登录密码{else}设置登录密码{/if}</h5><button type="button" class="close" data-dismiss="modal" aria-label="关闭"><span aria-hidden="true">&times;</span></button></div>
    <div class="modal-body"><form id="formPwd" onsubmit="doSubmitPassword(); return false;">
      {if $Userinfo.user.is_password}<div class="form-group"><label class="abcloud-form-label" for="oldPassword">原登录密码</label><input type="password" class="abcloud-form-control" id="oldPassword" autocomplete="current-password" /></div>{/if}
      <div class="form-group"><label class="abcloud-form-label" for="newPassword">新登录密码</label><input type="password" class="abcloud-form-control" id="newPassword" autocomplete="new-password" /></div>
      <div class="form-group"><label class="abcloud-form-label" for="renewPassword">确认新密码</label><input type="password" class="abcloud-form-control" id="renewPassword" autocomplete="new-password" /></div>
      {if $Verify.allow_resetpwd_captcha==1&&$Userinfo.user.is_password}{include file="includes/verify" type="allow_resetpwd_captcha"}
      {elseif $Verify.allow_setpwd_captcha==1&&!$Userinfo.user.is_password}{include file="includes/verify" type="allow_setpwd_captcha"}{/if}
      <button type="submit" class="btn btn-primary" id="btnSubmitPwd">确认修改</button>
    </form><p class="text-muted mt-3">修改成功后请重新登录。<a href="/pwreset">忘记原密码？</a></p></div>
    <div class="modal-footer"><button type="button" class="btn btn-light" data-dismiss="modal">取消</button></div>
  </div></div>
</div>
{if $Userinfo.shd_allow_sms_send}
<div class="modal fade abcloud-modal" id="modalPhone" tabindex="-1" role="dialog" aria-labelledby="phoneTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document"><div class="modal-content">
    <div class="modal-header"><h5 class="modal-title" id="phoneTitle">管理安全手机</h5><button type="button" class="close" data-dismiss="modal" aria-label="关闭"><span aria-hidden="true">&times;</span></button></div>
    <div class="modal-body"><form onsubmit="doSubmitPhone(); return false;">
      <div id="phoneStep1">
        <div class="form-group"><label class="abcloud-form-label">当前绑定手机</label><input class="abcloud-form-control" readonly value="{$Userinfo.user.phonenumber|htmlentities}" /></div>
        {if $Verify.allow_phone_bind_captcha==1}{include file="includes/verify" type="allow_phone_bind_captcha" id="abcloudPhoneOld"}{/if}
        <div class="form-group"><label class="abcloud-form-label" for="oldPhoneCode">原手机验证码</label><div class="abcloud-code-input-group"><input class="abcloud-form-control" id="oldPhoneCode" autocomplete="one-time-code" /><button type="button" class="abcloud-count-btn" id="btnSendOldPhone" onclick="sendVerificationCode('phone_old', this);">获取验证码</button></div></div>
      </div>
      <div id="phoneStep2" style="display:none;">
        <div class="form-group"><label class="abcloud-form-label" for="newPhoneNumber">新手机号码</label><div class="abcloud-phone-combine-group"><select class="abcloud-form-control" id="newPhoneCountryCode" aria-label="国际区号"><option value="+86">+86</option><option value="+852">+852</option><option value="+853">+853</option><option value="+886">+886</option><option value="+1">+1</option></select><input type="tel" class="abcloud-form-control" id="newPhoneNumber" /></div></div>
        {if $Verify.allow_phone_bind_captcha==1}{include file="includes/verify" type="allow_phone_bind_captcha" id="abcloudPhoneNew"}{/if}
        <div class="form-group"><label class="abcloud-form-label" for="newPhoneCode">新手机验证码</label><div class="abcloud-code-input-group"><input class="abcloud-form-control" id="newPhoneCode" autocomplete="one-time-code" /><button type="button" class="abcloud-count-btn" id="btnSendNewPhone" onclick="sendVerificationCode('phone_new', this);">获取验证码</button></div></div>
      </div>
      <button type="submit" class="btn btn-primary" id="btnSubmitPhone">验证原手机</button>
    </form></div>
    <div class="modal-footer"><button type="button" class="btn btn-light" data-dismiss="modal">取消</button></div>
  </div></div>
</div>
{/if}
{if $Userinfo.shd_allow_email_send}
<div class="modal fade abcloud-modal" id="modalEmail" tabindex="-1" role="dialog" aria-labelledby="emailTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document"><div class="modal-content">
    <div class="modal-header"><h5 class="modal-title" id="emailTitle">管理安全邮箱</h5><button type="button" class="close" data-dismiss="modal" aria-label="关闭"><span aria-hidden="true">&times;</span></button></div>
    <div class="modal-body"><form onsubmit="doSubmitEmail(); return false;">
      <div id="emailStep1">
        <div class="form-group"><label class="abcloud-form-label">当前绑定邮箱</label><input class="abcloud-form-control" readonly value="{$Userinfo.user.email|htmlentities}" /></div>
        {if $Verify.allow_email_bind_captcha==1}{include file="includes/verify" type="allow_email_bind_captcha" id="abcloudEmailOld"}{/if}
        <div class="form-group"><label class="abcloud-form-label" for="oldEmailCode">原邮箱验证码</label><div class="abcloud-code-input-group"><input class="abcloud-form-control" id="oldEmailCode" autocomplete="one-time-code" /><button type="button" class="abcloud-count-btn" id="btnSendOldEmail" onclick="sendVerificationCode('email_old', this);">获取验证码</button></div></div>
      </div>
      <div id="emailStep2" style="display:none;">
        <div class="form-group"><label class="abcloud-form-label" for="newEmailAddress">新邮箱地址</label><input type="email" class="abcloud-form-control" id="newEmailAddress" /></div>
        {if $Verify.allow_email_bind_captcha==1}{include file="includes/verify" type="allow_email_bind_captcha" id="abcloudEmailNew"}{/if}
        <div class="form-group"><label class="abcloud-form-label" for="newEmailCode">新邮箱验证码</label><div class="abcloud-code-input-group"><input class="abcloud-form-control" id="newEmailCode" autocomplete="one-time-code" /><button type="button" class="abcloud-count-btn" id="btnSendNewEmail" onclick="sendVerificationCode('email_new', this);">获取验证码</button></div></div>
      </div>
      <button type="submit" class="btn btn-primary" id="btnSubmitEmail">验证原邮箱</button>
    </form></div>
    <div class="modal-footer"><button type="button" class="btn btn-light" data-dismiss="modal">取消</button></div>
  </div></div>
</div>
{/if}
<script src="/themes/clientarea/ABCLOUD/assets/js/details.js?v=3.0.0"></script>
