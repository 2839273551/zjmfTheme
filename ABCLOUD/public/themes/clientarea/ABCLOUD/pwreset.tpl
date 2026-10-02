{if $ErrorMsg}
	{include file="error/alert" value="$ErrorMsg"}
{/if}

{if $SuccessMsg}
	{include file="error/notifications" value="$SuccessMsg" url="/login"}
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
				<div class="abcloud-text-title">重置您的访问密码</div>
				<div class="abcloud-text-desc">通过已绑定的手机号或安全邮箱快速验证身份并重设密码，保护您的账户资产。</div>
			</div>
		</div>

		<!-- Right Reset Panel -->
		<div class="abcloud-auth-form-panel">
			<div class="abcloud-form-header">
				<h2 class="abcloud-form-title">{$Lang.forget_the_password}</h2>
				<div class="abcloud-form-switch">
					记起密码？
					<a href="/login">返回登录</a>
				</div>
			</div>

			<!-- Tabs -->
			<div class="abcloud-auth-tabs">
				{if $Pwreset.allow_login_phone}
					<button type="button" class="abcloud-auth-tab-btn active" id="tab-phone" onclick="switchAuthTab('phone', this)">
						<i class="bx bx-mobile-alt mr-1"></i>{$Lang.mobile_phone_retrieval}
					</button>
				{/if}

				{if $Pwreset.allow_login_email}
					<button type="button" class="abcloud-auth-tab-btn {if !$Pwreset.allow_login_phone}active{/if}" id="tab-email" onclick="switchAuthTab('email', this)">
						<i class="bx bx-envelope mr-1"></i>{$Lang.email_retrieval}
					</button>
				{/if}
			</div>

			<!-- Tab Contents -->
			<div class="abcloud-tab-content">
				<!-- Phone Reset Form -->
				{if $Pwreset.allow_login_phone}
					<div id="phone" class="abcloud-tab-pane active" style="display:block;">
						<form class="needs-validation" method="post" action="/pwreset?action=phone">
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
							{if $Verify.allow_phone_forgetpwd_captcha==1}
								<div class="abcloud-form-group">
									{include file="includes/verify" type="allow_phone_forgetpwd_captcha" positon="top"}
								</div>
							{/if}

							<!-- SMS Code -->
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="code">{$Lang.verification_code}</label>
								<div class="abcloud-code-group">
									<input type="text" class="abcloud-input-field" id="code" name="code" value="{$Post.code}" placeholder="{$Lang.please_enter_code}" required>
									<button class="abcloud-code-btn" type="button" onclick="getCode(this, 'reset_phone_send', 'allow_phone_forgetpwd_captcha')">{$Lang.get_code}</button>
								</div>
							</div>

							<!-- New Password -->
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="phonePwd">{$Lang.new_password}</label>
								<div class="abcloud-password-wrapper">
									<input type="password" class="abcloud-input-field" name="password" id="phonePwd" placeholder="{$Lang.please_enter_new_password}" required autocomplete="new-password">
									<button type="button" class="abcloud-pwd-toggle-btn" onclick="togglePwdVisibility('phonePwd', this)" aria-label="显示/隐藏密码">
										<i class="bx bx-show"></i>
									</button>
								</div>
							</div>

							<!-- Confirm New Password -->
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="phonePwdCheck">{$Lang.confirm_password}</label>
								<div class="abcloud-password-wrapper">
									<input type="password" class="abcloud-input-field" name="checkPassword" id="phonePwdCheck" placeholder="{$Lang.please_password_again}" required autocomplete="new-password">
									<button type="button" class="abcloud-pwd-toggle-btn" onclick="togglePwdVisibility('phonePwdCheck', this)" aria-label="显示/隐藏密码">
										<i class="bx bx-show"></i>
									</button>
								</div>
							</div>

							<!-- Submit Button (Direct child of form) -->
							<button class="abcloud-submit-btn mt-3" type="submit">
								<i class="bx bx-check-circle"></i>{$Lang.determine}
							</button>
						</form>
					</div>
				{/if}

				<!-- Email Reset Form -->
				{if $Pwreset.allow_login_email}
					<div id="email" class="abcloud-tab-pane {if !$Pwreset.allow_login_phone}active{/if}" style="{if !$Pwreset.allow_login_phone}display:block;{else}display:none;{/if}">
						<form class="needs-validation" method="post" action="/pwreset?action=email">
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="emailInp">{$Lang.mailbox}</label>
								<input type="email" class="abcloud-input-field" id="emailInp" name="email" value="{$Post.email}" placeholder="{$Lang.please_input_email}" required autocomplete="email">
							</div>

							<!-- Captcha -->
							{if $Verify.allow_email_forgetpwd_captcha==1}
								<div class="abcloud-form-group">
									{include file="includes/verify" type="allow_email_forgetpwd_captcha" positon="top"}
								</div>
							{/if}

							<!-- Email Code -->
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="emailCode">{$Lang.verification_code}</label>
								<div class="abcloud-code-group">
									<input type="text" class="abcloud-input-field" id="emailCode" name="code" value="{$Post.code}" placeholder="{$Lang.please_enter_code}" required>
									<button class="abcloud-code-btn" type="button" onclick="getCode(this, 'reset_email_send', 'allow_email_forgetpwd_captcha')">{$Lang.get_code}</button>
								</div>
							</div>

							<!-- New Password -->
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="emailPwd">{$Lang.new_password}</label>
								<div class="abcloud-password-wrapper">
									<input type="password" class="abcloud-input-field" name="password" id="emailPwd" placeholder="{$Lang.please_enter_new_password}" required autocomplete="new-password">
									<button type="button" class="abcloud-pwd-toggle-btn" onclick="togglePwdVisibility('emailPwd', this)" aria-label="显示/隐藏密码">
										<i class="bx bx-show"></i>
									</button>
								</div>
							</div>

							<!-- Confirm New Password -->
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="emailPwdCheck">{$Lang.confirm_password}</label>
								<div class="abcloud-password-wrapper">
									<input type="password" class="abcloud-input-field" name="checkPassword" id="emailPwdCheck" placeholder="{$Lang.please_password_again}" required autocomplete="new-password">
									<button type="button" class="abcloud-pwd-toggle-btn" onclick="togglePwdVisibility('emailPwdCheck', this)" aria-label="显示/隐藏密码">
										<i class="bx bx-show"></i>
									</button>
								</div>
							</div>

							<!-- Submit Button (Direct child of form) -->
							<button class="abcloud-submit-btn mt-3" type="submit">
								<i class="bx bx-check-circle"></i>{$Lang.determine}
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
