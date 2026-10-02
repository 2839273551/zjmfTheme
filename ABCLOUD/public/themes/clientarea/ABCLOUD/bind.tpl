{if $ErrorMsg}
	{include file="error/alert" value="$ErrorMsg"}
{/if}

{if $SuccessMsg}
	{include file="error/notifications" value="$SuccessMsg" url="/clientarea"}
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
				<div class="abcloud-text-title">账号绑定与授权</div>
				<div class="abcloud-text-desc">完成手机或邮箱绑定，以便后续使用第三方账号一键快捷免密登录。</div>
			</div>
		</div>

		<!-- Right Bind Panel -->
		<div class="abcloud-auth-form-panel">
			<div class="abcloud-form-header">
				<h2 class="abcloud-form-title">绑定账号</h2>
				<div class="abcloud-form-switch">
					已有账号？
					<a href="/login">直接登录</a>
				</div>
			</div>

			<!-- Tabs -->
			<div class="abcloud-auth-tabs">
				{if $CallbackInfo == 0 || $CallbackInfo == 2}
					<button type="button" class="abcloud-auth-tab-btn active" id="tab-email" onclick="switchAuthTab('email', this)">
						<i class="bx bx-envelope mr-1"></i>{$Lang.mailbox_binding}
					</button>
				{/if}

				{if $CallbackInfo == 0 || $CallbackInfo == 1}
					<button type="button" class="abcloud-auth-tab-btn {if $CallbackInfo == 1}active{/if}" id="tab-phone" onclick="switchAuthTab('phone', this)">
						<i class="bx bx-mobile-alt mr-1"></i>{$Lang.mobile_phone_binding}
					</button>
				{/if}
			</div>

			<!-- Tab Contents -->
			<div class="abcloud-tab-content">
				{if $CallbackInfo == 0 || $CallbackInfo == 2}
					<div id="email" class="abcloud-tab-pane active" style="display:block;">
						<form method="post" action="/bind?action=email">
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="emailInp">{$Lang.mailbox}</label>
								<input type="email" class="abcloud-input-field" id="emailInp" name="email" placeholder="{$Lang.please_input_email}" required autocomplete="email">
							</div>

							{if $Verify.allow_register_email_captcha==1}
								<div class="abcloud-form-group">
									{include file="includes/verify" type="allow_register_email_captcha" positon="top"}
								</div>
							{/if}

							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="code">{$Lang.verification_code}</label>
								<div class="abcloud-code-group">
									<input type="text" class="abcloud-input-field" id="code" name="code" placeholder="{$Lang.please_enter_code}" required>
									<button class="abcloud-code-btn" type="button" onclick="getCode(this, 'oauth/bind_email_send', 'allow_register_email_captcha')">{$Lang.get_code}</button>
								</div>
							</div>

							<div class="mt-4">
								<button class="abcloud-submit-btn" type="submit">
									<i class="bx bx-link"></i>{$Lang.submit}
								</button>
							</div>
						</form>
					</div>
				{/if}

				{if $CallbackInfo == 0 || $CallbackInfo == 1}
					<div id="phone" class="abcloud-tab-pane {if $CallbackInfo == 1}active{/if}" style="{if $CallbackInfo == 1}display:block;{else}display:none;{/if}">
						<form method="post" action="/bind?action=phone">
							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="phoneInp">{$Lang.phone_number}</label>
								<div class="abcloud-phone-group">
									{if $Bind.allow_login_register_sms_global==1}
										<select class="abcloud-phone-code-select" name="phone_code" id="phoneCodeSel">
											{foreach $SmsCountry as $list}
												<option value="{$list.phone_code}" {if $list.phone_code=="+86"}selected{/if}>
													{$list.link}
												</option>
											{/foreach}
										</select>
									{/if}
									<input type="text" class="abcloud-input-field" id="phoneInp" name="phone" placeholder="{$Lang.please_enter_your_mobile_phone_number}" required autocomplete="tel">
								</div>
							</div>

							{if $Verify.allow_register_phone_captcha==1}
								<div class="abcloud-form-group">
									{include file="includes/verify" type="allow_register_phone_captcha" positon="top"}
								</div>
							{/if}

							<div class="abcloud-form-group">
								<label class="abcloud-form-label" for="codePhone">{$Lang.verification_code}</label>
								<div class="abcloud-code-group">
									<input type="text" class="abcloud-input-field" id="codePhone" name="code" placeholder="{$Lang.please_enter_code}" required>
									<button class="abcloud-code-btn" type="button" onclick="getCode(this, 'oauth/bind_phone_send', 'allow_register_phone_captcha')">{$Lang.get_code}</button>
								</div>
							</div>

							<div class="mt-4">
								<button class="abcloud-submit-btn" type="submit">
									<i class="bx bx-link"></i>{$Lang.submit}
								</button>
							</div>
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
