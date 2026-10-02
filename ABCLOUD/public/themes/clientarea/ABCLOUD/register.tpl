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
	<a href="{$Setting.web_jump_url}" class="abcloud-auth-logo-link">
		<img class="abcloud-auth-logo" src="{$Setting.web_logo}" alt="{$Setting.company_name}" />
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
				<div class="abcloud-text-title">开启全新云端体验</div>
				<div class="abcloud-text-desc">快速注册您的业务专属账户，轻松管理高可用、高弹性的云上基础设施。</div>
			</div>
		</div>

		<!-- Right Register Panel -->
		<div class="abcloud-auth-form-panel">
			<div class="abcloud-form-header">
				<h2 class="abcloud-form-title">{$Lang.register}</h2>
				<div class="abcloud-form-switch">
					已有账号？
					<a href="/login">直接登录</a>
				</div>
			</div>

			<!-- Tabs -->
			<div class="abcloud-auth-tabs">
				{if $Register.allow_register_phone}
					<button type="button" class="abcloud-auth-tab-btn {if $Get.action=="phone" || !$Get.action}active{/if}" id="tab-phone" onclick="switchAuthTab('phone', this)">
						<i class="bx bx-mobile-alt mr-1"></i>{$Lang.mobile_registration}
					</button>
				{/if}

				{if $Register.allow_register_email}
					<button type="button" class="abcloud-auth-tab-btn {if ($Register.allow_register_email && !$Register.allow_register_phone) || $Get.action=="email"}active{/if}" id="tab-email" onclick="switchAuthTab('email', this)">
						<i class="bx bx-envelope mr-1"></i>{$Lang.email_registration}
					</button>
				{/if}
			</div>

			<!-- Tab Contents -->
			<div class="abcloud-tab-content">
				<!-- Phone Register Form -->
				{if $Register.allow_register_phone}
					<div id="phone" class="abcloud-tab-pane {if $Get.action=="phone" || !$Get.action}active{/if}" style="{if $Get.action=="phone" || !$Get.action}display:block;{else}display:none;{/if}">
						<form class="needs-validation" method="post" action="/register?action=phone" onsubmit="return (encryptPass('phonePwd', 'phonePwdEnc') && encryptPass('phonePwdCheck', 'phonePwdCheckEnc'));">
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

							<!-- Captcha -->
							{if $Verify.allow_register_phone_captcha==1}
								<div class="abcloud-form-group">
									{include file="includes/verify" type="allow_register_phone_captcha" positon="top"}
								</div>
							{/if}

							<!-- SMS Code -->
							{if $Register.allow_phone_register_code==1}
								<div class="abcloud-form-group">
									<label class="abcloud-form-label" for="code">{$Lang.verification_code}</label>
									<div class="abcloud-code-group">
										<input type="text" class="abcloud-input-field" id="code" name="code" value="{$Post.code}" placeholder="{$Lang.please_enter_code}" required>
										<button class="abcloud-code-btn" type="button" onclick="getCode(this, 'register_phone_send', 'allow_register_phone_captcha')">{$Lang.get_code}</button>
									</div>
								</div>
							{/if}

							<!-- Password -->
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="phonePwd">{$Lang.password}</label>
								<div class="abcloud-password-wrapper">
									<input type="password" class="abcloud-input-field" name="password" id="phonePwd" placeholder="{$Lang.please_enter_password}" required autocomplete="new-password">
									<button type="button" class="abcloud-pwd-toggle-btn" onclick="togglePwdVisibility('phonePwd', this)" aria-label="显示/隐藏密码">
										<i class="bx bx-show"></i>
									</button>
								</div>
							</div>

							<!-- Confirm Password -->
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="phonePwdCheck">{$Lang.confirm_password}</label>
								<div class="abcloud-password-wrapper">
									<input type="password" class="abcloud-input-field" name="checkPassword" id="phonePwdCheck" placeholder="{$Lang.please_password_again}" required autocomplete="new-password">
									<button type="button" class="abcloud-pwd-toggle-btn" onclick="togglePwdVisibility('phonePwdCheck', this)" aria-label="显示/隐藏密码">
										<i class="bx bx-show"></i>
									</button>
								</div>
							</div>

							<!-- Agreement -->
							<div class="abcloud-form-meta">
								<label class="abcloud-checkbox-label">
									<input type="checkbox" id="phoneAgreementCheck" required checked>
									<span>我已阅读并同意 <a href="{$Setting.web_jump_url}" target="_blank">《服务协议》</a> 与 <a href="{$Setting.web_jump_url}" target="_blank">《隐私条款》</a></span>
								</label>
							</div>

							<!-- Submit Button (Direct child of form for Geetest compatibility) -->
							<button class="abcloud-submit-btn mt-2" type="submit">
								<i class="bx bx-user-plus"></i>{$Lang.register}
							</button>
						</form>
					</div>
				{/if}

				<!-- Email Register Form -->
				{if $Register.allow_register_email}
					<div id="email" class="abcloud-tab-pane {if ($Register.allow_register_email && !$Register.allow_register_phone) || $Get.action=="email"}active{/if}" style="{if ($Register.allow_register_email && !$Register.allow_register_phone) || $Get.action=="email"}display:block;{else}display:none;{/if}">
						<form class="needs-validation" method="post" action="/register?action=email" onsubmit="return (encryptPass('emailPwd', 'emailPwdEnc') && encryptPass('emailPwdCheck', 'emailPwdCheckEnc'));">
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="emailInp">{$Lang.mailbox}</label>
								<input type="email" class="abcloud-input-field" id="emailInp" name="email" value="{$Post.email}" placeholder="{$Lang.please_input_email}" required autocomplete="email">
							</div>

							<!-- Captcha -->
							{if $Verify.allow_register_email_captcha==1}
								<div class="abcloud-form-group">
									{include file="includes/verify" type="allow_register_email_captcha" positon="top"}
								</div>
							{/if}

							<!-- Email Code -->
							{if $Register.allow_email_register_code==1}
								<div class="abcloud-form-group">
									<label class="abcloud-form-label" for="emailCode">{$Lang.verification_code}</label>
									<div class="abcloud-code-group">
										<input type="text" class="abcloud-input-field" id="emailCode" name="code" value="{$Post.code}" placeholder="{$Lang.please_enter_code}" required>
										<button class="abcloud-code-btn" type="button" onclick="getCode(this, 'register_email_send', 'allow_register_email_captcha')">{$Lang.get_code}</button>
									</div>
								</div>
							{/if}

							<!-- Password -->
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="emailPwd">{$Lang.password}</label>
								<div class="abcloud-password-wrapper">
									<input type="password" class="abcloud-input-field" name="password" id="emailPwd" placeholder="{$Lang.please_enter_password}" required autocomplete="new-password">
									<button type="button" class="abcloud-pwd-toggle-btn" onclick="togglePwdVisibility('emailPwd', this)" aria-label="显示/隐藏密码">
										<i class="bx bx-show"></i>
									</button>
								</div>
							</div>

							<!-- Confirm Password -->
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="emailPwdCheck">{$Lang.confirm_password}</label>
								<div class="abcloud-password-wrapper">
									<input type="password" class="abcloud-input-field" name="checkPassword" id="emailPwdCheck" placeholder="{$Lang.please_password_again}" required autocomplete="new-password">
									<button type="button" class="abcloud-pwd-toggle-btn" onclick="togglePwdVisibility('emailPwdCheck', this)" aria-label="显示/隐藏密码">
										<i class="bx bx-show"></i>
									</button>
								</div>
							</div>

							<!-- Agreement -->
							<div class="abcloud-form-meta">
								<label class="abcloud-checkbox-label">
									<input type="checkbox" id="emailAgreementCheck" required checked>
									<span>我已阅读并同意 <a href="{$Setting.web_jump_url}" target="_blank">《服务协议》</a> 与 <a href="{$Setting.web_jump_url}" target="_blank">《隐私条款》</a></span>
								</label>
							</div>

							<!-- Submit Button (Direct child of form for Geetest compatibility) -->
							<button class="abcloud-submit-btn mt-2" type="submit">
								<i class="bx bx-user-plus"></i>{$Lang.register}
							</button>
						</form>
					</div>
				{/if}
			</div>
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
