<!DOCTYPE html>
<html lang="zh-CN">

<head>
	<meta charset="utf-8" />
	<title>{$Title} | {$Setting.company_name}</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta content="{$Setting.web_seo_desc}" name="description" />
	<meta content="{$Setting.web_seo_keywords}" name="keywords" />
	<meta content="{$Setting.company_name}" name="author" />

	{include file="includes/head"}
	<script>
		var setting_web_url = '{$Setting.web_jump_url}';
		var language = {:json_encode($_LANG)};
	</script>

	<!-- ABCLOUD Clientarea Unified Styles -->
	<link href="/themes/clientarea/ABCLOUD/assets/css/clientarea.css?v=3.0.0" rel="stylesheet" type="text/css" />

	{php}$hooks=hook('client_area_head_output');{/php}
	{if $hooks}
		{foreach $hooks as $item}
			{$item}
		{/foreach}
	{/if}
</head>

<body data-sidebar="light">
	{if $TplName != 'login' && $TplName != 'register' && $TplName != 'pwreset' && $TplName != 'bind' && $TplName != 'loginaccesstoken'}
		<header id="page-topbar">
			<div class="navbar-header">
				<div class="d-flex align-items-center">
					<!-- Brand Logo -->
					<div class="navbar-brand-box">
						<a href="{$Setting.web_jump_url}" class="logo">
							<img src="{$Setting.web_logo}" alt="{$Setting.company_name}" height="32" style="object-fit: contain;">
						</a>
					</div>

					<button type="button" class="btn btn-sm px-3 font-size-16 header-item waves-effect" id="vertical-menu-btn" aria-label="切换侧边栏">
						<i class="fa fa-fw fa-bars"></i>
					</button>
				</div>

				<div class="d-flex align-items-center">
					<!-- Cart Link -->
					<div class="dropdown d-inline-block ml-2">
						<a href="/cart" class="btn header-item noti-icon waves-effect" title="选购大厅">
							<i class="bx bx-cart-alt"></i>
						</a>
					</div>

					<!-- Notifications -->
					<div class="dropdown d-inline-block ml-1">
						<a href="/message" class="btn header-item noti-icon waves-effect" title="消息中心">
							<i class="bx bx-bell {if $Setting.unread_num}bx-tada{/if}"></i>
							{if $Setting.unread_num != '0'}
								<span class="badge badge-danger badge-pill">{$Setting.unread_num}</span>
							{/if}
						</a>
					</div>

					<!-- User Profile Capsule -->
					{if $Userinfo}
						<div class="dropdown d-inline-block ml-2">
							<button type="button" class="btn header-item waves-effect d-inline-flex align-items-center abcloud-top-user-btn"
								id="page-header-user-dropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								<div class="abcloud-avatar-sm">
									{if preg_match("/^[0-9]*[A-Za-z]+$/is", substr($Userinfo.user.username,0,1))}
										{$Userinfo.user.username|substr=0,1|upper}
									{elseif preg_match("/^[\x7f-\xff]*$/", substr($Userinfo.user.username,0,3))}
										{$Userinfo.user.username|substr=0,3}
									{else}
										{$Userinfo.user.username|substr=0,1|upper}
									{/if}
								</div>
								<span class="d-none d-xl-inline-block font-weight-500" style="color: #334155;">{$Userinfo.user.username}</span>
								<i class="mdi mdi-chevron-down d-none d-xl-inline-block text-muted"></i>
							</button>
							<div class="dropdown-menu dropdown-menu-right" style="border-radius: 8px; border: 1px solid #e2e8f0; box-shadow: 0 10px 25px rgba(0,0,0,0.08);">
								<a class="dropdown-item py-2" href="/details">
									<i class="bx bxs-user-detail font-size-16 align-middle mr-2 text-primary"></i>
									<span>{$Lang.personal_information}</span>
								</a>
								<a class="dropdown-item py-2" href="/security">
									<i class="bx bx-shield-quarter font-size-16 align-middle mr-2 text-primary"></i>
									<span>{$Lang.security_center}</span>
								</a>
								<a class="dropdown-item py-2" href="/message">
									<i class="bx bx-bell font-size-16 align-middle mr-2 text-primary"></i>
									<span>{$Lang.message_center}</span>
								</a>
								{if $Setting.certifi_open==1}
									<a class="dropdown-item py-2" href="/verified">
										<i class="bx bxs-id-card font-size-16 align-middle mr-2 text-primary"></i>
										<span>{$Lang.real_name_authentications}</span>
									</a>
								{/if}
								<div class="dropdown-divider"></div>
								<a class="dropdown-item py-2 text-danger" href="/logout">
									<i class="bx bx-power-off font-size-16 align-middle mr-2 text-danger"></i>
									<span>{$Lang.log_out}</span>
								</a>
							</div>
						</div>
					{else}
						<div class="d-flex align-items-center ml-2">
							<a href="/login" class="btn btn-sm btn-primary px-3">{$Lang.please_login}</a>
						</div>
					{/if}
				</div>
			</div>
		</header>

		{include file="includes/menu"}

		<div class="main-content">
			<div class="page-content">
				{if $TplName != 'clientarea'}
					{include file="includes/pageheader"}
				{/if}
				<div class="container-fluid">
	{/if}
