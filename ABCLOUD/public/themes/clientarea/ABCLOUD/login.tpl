{if $ErrorMsg}
	{include file="error/alert" value="$ErrorMsg"}
{/if}

{if $SuccessMsg}
	{include file="error/notifications" value="$SuccessMsg"}
{/if}

<script src="/themes/clientarea/ABCLOUD/assets/js/crypto-js.min.js?v=3.0.0" type="text/javascript"></script>
<script src="/themes/clientarea/ABCLOUD/assets/js/public.js?v=3.0.0" type="text/javascript"></script>
<link href="/themes/clientarea/ABCLOUD/assets/css/auth.css?v=3.0.0" rel="stylesheet" type="text/css" />
<script src="/themes/clientarea/ABCLOUD/assets/js/auth.js?v=3.0.0" type="text/javascript"></script>

<script type="text/javascript">
	var mk = '{$Setting.msfntk}';
</script>

<div class="abcloud-auth-wrap">
	<!-- Fixed Brand Logo -->
	<a href="{$Setting.web_jump_url}" class="abcloud-auth-logo-link"><img class="abcloud-auth-logo" src="{$Setting.web_logo}" alt="{$Setting.company_name}" />
	</a>

	<!-- Main Auth Container -->
	<div class="abcloud-auth-container">
		<!-- Left Brand Panel (APE WELCOME) -->
		<div class="abcloud-auth-back">
			<div class="abcloud-back-line1"></div>
			<div class="abcloud-back-line2"></div>
			<div class="abcloud-back-line3"></div>
			<div class="abcloud-back-content">
				<div class="abcloud-text-welcome">WELCOME</div>
				<div class="abcloud-text-title">安全 · 稳定 · 高效</div>
				<div class="abcloud-text-desc">一站式在线业务交易与云计算服务平台，随时随地触达您的关键数字资产。</div>
			</div>
		</div>

		<!-- Right Login Panel -->
		<div class="abcloud-auth-form-panel">
			<div class="abcloud-form-header">
				<h2 class="abcloud-form-title">{$Lang.sign_in}</h2>
				<div class="abcloud-form-switch">
					{$Lang.no_account_yet}
					<a href="/register">{$Lang.register_now}</a>
				</div>
			</div>

			<!-- Tabs -->
			<div class="abcloud-auth-tabs">
				{if $Login.allow_login_phone==1}
					<button type="button" class="abcloud-auth-tab-btn {if $Get.action=="phone" || $Get.action=="phone_code" || !$Get.action}active{/if}" id="tab-phone" onclick="switchAuthTab('phone', this)">
						<i class="bx bx-mobile-alt mr-1"></i>{$Lang.mobile_login}
					</button>
				{/if}

				{if $Login.allow_login_email}
					<button type="button" class="abcloud-auth-tab-btn {if ($Login.allow_login_phone==0 && $Login.allow_login_email == 1 && $Login.allow_id == 0) || $Get.action=="email"}active{/if}" id="tab-email" onclick="switchAuthTab('email', this)">
						<i class="bx bx-envelope mr-1"></i>{$Lang.email_login}
					</button>
				{/if}

				{if $Login.allow_login_email==0 && $Login.allow_id==1}
					<button type="button" class="abcloud-auth-tab-btn {if ($Login.allow_login_phone==0 && $Login.allow_id == 1)}active{/if}" id="tab-id" onclick="switchAuthTab('email', this)">
						<i class="bx bx-user mr-1"></i>{$Lang.id_login}
					</button>
				{/if}
			</div>

			<!-- Tab Contents -->
			<div class="abcloud-tab-content">
				<!-- Phone Login Form -->
				{if $Login.allow_login_phone}
					<div id="phone" class="abcloud-tab-pane {if $Get.action=="phone" || $Get.action=="phone_code" || !$Get.action}active{/if}" style="{if $Get.action=="phone" || $Get.action=="phone_code" || !$Get.action}display:block;{else}display:none;{/if}">
						<form method="post" action="/login?action=phone" onsubmit="return encryptPass('phonePwdInp', 'phonePwdEnc');">
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="phoneInp">{$Lang.phone_number}</label>
								<div class="abcloud-phone-group">
									{if $Login.allow_login_register_sms_global==1}
										<select class="abcloud-phone-code-select" name="phone_code" id="phoneCodeSel">
											{foreach $SmsCountry as $list}
												<option value="{$list.phone_code}" {if $list.phone_code=="+86"}selected{/if}>
													{$list.link}
												</option>
											{/foreach}
										</select>
									{/if}
									<input type="text" class="abcloud-input-field" id="phoneInp" name="phone" value="{$Post.phone}" placeholder="{$Lang.please_enter_your_mobile_phone_number}" required autocomplete="tel">
								</div>
							</div>

							<!-- Password Input -->
							<div class="abcloud-form-group allow_login_phone_captcha">
								<label class="abcloud-form-label" for="phonePwdInp">{$Lang.password}</label>
								<div class="abcloud-password-wrapper">
									<input type="password" class="abcloud-input-field" id="phonePwdInp" name="password" placeholder="{$Lang.please_enter_password}" autocomplete="current-password">
									<button type="button" class="abcloud-pwd-toggle-btn" onclick="togglePwdVisibility('phonePwdInp', this)" aria-label="显示/隐藏密码">
										<i class="bx bx-show"></i>
									</button>
								</div>
							</div>

							<!-- Captcha for Phone Password -->
							{if $Login.allow_login_phone_captcha==1 && $Login.is_captcha==1}
								<div class="abcloud-form-group allow_login_phone_captcha">
									{include file="includes/verify" type="allow_login_phone_captcha" positon="top"}
								</div>
							{/if}

							<!-- Captcha for Phone Code -->
							{if $Login.allow_login_code_captcha==1 && $Login.is_captcha==1}
								<div class="abcloud-form-group allow_login_code_captcha" style="display:none;">
									{include file="includes/verify" type="allow_login_code_captcha" positon="top"}
								</div>
							{/if}

							<!-- SMS Code Input -->
							<div class="abcloud-form-group allow_login_code_captcha" style="display:none;">
								<label class="abcloud-form-label" for="phoneCodeInp">{$Lang.verification_code}</label>
								<div class="abcloud-code-group">
									<input type="text" class="abcloud-input-field" id="phoneCodeInp" name="code" value="{$Post.code}" placeholder="{$Lang.please_enter_code}">
									<button class="abcloud-code-btn" type="button" onclick="getCode(this, 'login_send', 'allow_login_code_captcha')">{$Lang.get_code}</button>
								</div>
							</div>

							<!-- Mode Switch & Forget Password -->
							<div class="abcloud-form-meta">
								<div class="pointer" onclick="phoneCheck(this, 'allow_login_phone_captcha')" {if $Get.action=="phone_code"}style="display:none;"{/if}>
									<i class="bx bx-message-square-dots mr-1"></i>{$Lang.verification_code_login}
								</div>
								<div class="pointer" onclick="phoneCheck(this, 'allow_login_code_captcha')" {if $Get.action!="phone_code"}style="display:none;"{/if}>
									<i class="bx bx-key mr-1"></i>{$Lang.password_login}
								</div>
								<a href="/pwreset">{$Lang.forget_the_password}</a>
							</div>

							<!-- Submit Buttons (Direct child of form for Geetest compatibility) -->
							{if $Login.second_verify_action_home_login==1}
									<button class="abcloud-submit-btn allow_login_phone_captcha mt-2" type="button" onclick="loginBefore('phone');">
									<i class="bx bx-log-in"></i>{$Lang.sign_in}
								</button>
								<button class="abcloud-submit-btn allow_login_code_captcha mt-2" type="submit" style="display:none;">
									<i class="bx bx-log-in"></i>{$Lang.sign_in}
								</button>
							{else/}
								<button class="abcloud-submit-btn mt-2" type="submit">
									<i class="bx bx-log-in"></i>{$Lang.sign_in}
								</button>
							{/if}
						</form>
					</div>
				{/if}

				<!-- Email Login Form -->
				{if $Login.allow_login_email || $Login.allow_id}
					<div id="email" class="abcloud-tab-pane {if ($Login.allow_login_phone==0 && ($Login.allow_login_email == 1 || $Login.allow_id == 1)) || $Get.action=="email"}active{/if}" style="{if ($Login.allow_login_phone==0 && ($Login.allow_login_email == 1 || $Login.allow_id == 1)) || $Get.action=="email"}display:block;{else}display:none;{/if}">
						<form method="post" action="/login?action=email" onsubmit="return encryptPass('emailPwdInp', 'emailPwdEnc');">
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="emailInp">{if $Login.allow_login_email}{$Lang.mailbox}{else}ID{/if}</label>
								<input type="text" class="abcloud-input-field" id="emailInp" name="email" value="{$Post.email}" placeholder="{$Lang.please_enter_your}{if $Login.allow_login_email}{$Lang.mailbox}{if $Login.allow_id==1}{$Lang.ors}{/if}{/if}{if $Login.allow_id==1}ID{/if}" required autocomplete="username">
							</div>

							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="emailPwdInp">{$Lang.password}</label>
								<div class="abcloud-password-wrapper">
									<input type="password" class="abcloud-input-field" id="emailPwdInp" name="password" placeholder="{$Lang.please_enter_password}" required autocomplete="current-password">
									<button type="button" class="abcloud-pwd-toggle-btn" onclick="togglePwdVisibility('emailPwdInp', this)" aria-label="显示/隐藏密码">
										<i class="bx bx-show"></i>
									</button>
								</div>
							</div>

							{if $Login.allow_login_email_captcha==1 && $Login.is_captcha==1}
								<div class="abcloud-form-group">
									{include file="includes/verify" type="allow_login_email_captcha" positon="top"}
								</div>
							{/if}

							<div class="abcloud-form-meta">
								<span></span>
								<a href="/pwreset">{$Lang.forget_the_password}</a>
							</div>

							<!-- Submit Button (Direct child of form) -->
							{if $Login.second_verify_action_home_login==1}
									<button class="abcloud-submit-btn mt-2" type="button" onclick="loginBefore('email');">
									<i class="bx bx-log-in"></i>{$Lang.sign_in}
								</button>
							{else/}
								<button class="abcloud-submit-btn mt-2" type="submit">
									<i class="bx bx-log-in"></i>{$Lang.sign_in}
								</button>
							{/if}
						</form>
					</div>
				{/if}
			</div>

			<!-- OAuth Third-party Login -->
			{if $Oauth}
				<div class="abcloud-oauth-section">
					<div class="abcloud-oauth-divider">
						<span>{$Lang.use_other_login}</span>
					</div>
					<ul class="abcloud-oauth-list">
						{foreach $Oauth as $list}
							<li class="abcloud-oauth-item">
								<a href="{$list.url}" title="快捷登录" target="_blank">
									{$list.img}
								</a>
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}
		</div>
	</div>

	<!-- Frosted Glass Bottom Footer -->
	<footer class="abcloud-auth-footer">
		<span>&copy; {$Setting.company_name} 版权所有</span>
		{if $Setting.login_footer}
			<span class="abcloud-footer-divider">|</span>
			<span>{$Setting.login_footer}</span>
		{/if}
	</footer>
</div>

{if $Login.second_verify_action_home_login==1}
	<!-- Second Verification Modal -->
	<div class="modal fade" id="secondVerifyModal" tabindex="-1" role="dialog" aria-labelledby="secondVerifyModal" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content" style="border-radius: 10px; overflow: hidden; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.15);">
				<div class="modal-header" style="background: #f8fafc; border-bottom: 1px solid #e2e8f0;">
					<h5 class="modal-title font-weight-bold" style="color: #0f172a; font-size: 16px;">{$Lang.secondary_verification}</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body p-4">
					<form>
						<input type="hidden" value="{$Token}" />
						<input type="hidden" value="closed" name="action" />
						<div class="form-group row mb-4">
							<label class="col-sm-3 col-form-label text-right font-weight-500">{$Lang.verification_method}</label>
							<div class="col-sm-9">
								<select class="form-control" name="type" id="secondVerifyType"></select>
							</div>
						</div>
						<div class="form-group row mb-0">
							<label class="col-sm-3 col-form-label text-right font-weight-500">{$Lang.verification_code}</label>
							<div class="col-sm-9">
								<div class="input-group">
									<input type="text" name="code" id="secondVerifyCode" class="form-control" placeholder="{$Lang.please_enter_code}" style="height: 42px;" />
									<div class="input-group-append" style="height: 42px;">
										<button class="btn btn-primary" type="button" onclick="getCode(this,'login/second_verify_send')" style="line-height: 26px;">{$Lang.get_code}</button>
									</div>
								</div>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer" style="background: #f8fafc; border-top: 1px solid #e2e8f0;">
					<button type="button" class="btn btn-outline-secondary" data-dismiss="modal">{$Lang.cancel}</button>
					<button type="button" class="btn btn-primary" id="secondVerifySubmit">{$Lang.determine}</button>
				</div>
			</div>
		</div>
	</div>
{/if}

<script type="text/javascript">
	{if $Get.action=="phone_code"}
		phoneCheck("", "allow_login_phone_captcha");
	{else/}
		phoneCheck("", "allow_login_code_captcha");
	{/if}
</script>
