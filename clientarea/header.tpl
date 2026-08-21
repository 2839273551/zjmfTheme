<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <title>{$Title} | {$Setting.company_name}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="{$Setting.web_seo_desc}">
  <meta name="keywords" content="{$Setting.web_seo_keywords}">
  <meta name="author" content="{$Setting.company_name}">

  {include file="themes/clientarea/default/includes/head.tpl"}
  <link href="/themes/clientarea/codex_framework/custom.css?v={$Ver}-1.0.0" rel="stylesheet" type="text/css">
  <script>
    var setting_web_url = '{$Setting.system_url}';
    var language = {:json_encode($_LANG)};
  </script>
  {php}$hooks=hook('client_area_head_output');{/php}
  {if $hooks}
    {foreach $hooks as $item}{$item}{/foreach}
  {/if}
</head>
<body class="{if $TplName == 'login' || $TplName == 'register' || $TplName == 'pwreset' || $TplName == 'bind' || $TplName == 'loginaccesstoken'}cf-auth-page cf-page-{$TplName}{else/}cf-app-page{/if}" data-sidebar="light">
  {if $TplName != 'login' && $TplName != 'register' && $TplName != 'pwreset' && $TplName != 'bind' && $TplName != 'loginaccesstoken'}
  <header id="page-topbar" class="cf-topbar">
    <div class="navbar-header">
      <div class="cf-topbar-start">
        <div class="navbar-brand-box">
          <a class="cf-app-brand" href="{$Setting.web_jump_url}" aria-label="{$Setting.company_name}首页">
            {if $Setting.web_logo_home}
            <img src="{$Setting.web_logo_home}" alt="{$Setting.company_name}">
            {else/}
            <img src="/upload/logo.png" alt="{$Setting.company_name}">
            {/if}
          </a>
        </div>
        <button type="button" class="cf-icon-button" id="vertical-menu-btn" aria-label="展开或收起导航">
          <i class="bx bx-menu" aria-hidden="true"></i>
        </button>
        <nav class="cf-top-links" aria-label="常用入口">
          <a href="{$Setting.system_url}/clientarea">总览</a>
          <a href="{$Setting.system_url}/cart">订购产品</a>
          <a href="{$Setting.system_url}/knowledgebase">文档中心</a>
          <a href="{$Setting.system_url}/supporttickets">提交工单</a>
          <a href="{$Setting.system_url}/billing">费用中心</a>
        </nav>
      </div>

      <div class="cf-topbar-actions">
        {if $Setting.allow_user_language}
        <div class="dropdown d-inline-block">
          <button type="button" class="cf-icon-button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" aria-label="切换语言">
            <img src="/upload/common/country/{$LanguageCheck.display_flag}.png" alt="" height="16">
          </button>
          <div class="dropdown-menu dropdown-menu-right">
            {php}
              $parse = parse_url(request()->url());
              $path = $parse['path'];
              $query = $parse['query'];
              $query = preg_replace('/&language=[a-zA-Z0-9_-]+/','',$query);
            {/php}
            {foreach $Language as $key=>$list}
            <a href="?{if $query}{$query}&{/if}language={$key}" class="dropdown-item notify-item language">
              <img src="/upload/common/country/{$list.display_flag}.png" alt="" class="mr-2" height="12">
              <span>{$list.display_name}</span>
            </a>
            {/foreach}
          </div>
        </div>
        {/if}

        <a class="cf-icon-button" href="{$Setting.system_url}/cart?action=viewcart" aria-label="查看购物车">
          <i class="bx bx-cart-alt" aria-hidden="true"></i>
        </a>
        <a class="cf-icon-button cf-message-button" href="{$Setting.system_url}/message" aria-label="消息中心">
          <i class="bx bx-bell" aria-hidden="true"></i>
          {if $Setting.unread_num != '0'}<span>{$Setting.unread_num}</span>{/if}
        </a>

        {if $Userinfo}
        <div class="dropdown d-inline-block">
          <button type="button" class="cf-account-trigger" id="page-header-user-dropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <span class="cf-account-avatar"><i class="bx bx-user" aria-hidden="true"></i></span>
            <span class="cf-account-copy">
              <strong>{$Userinfo.user.username}</strong>
              <small>ID {$Userinfo.user.id}</small>
            </span>
            <i class="bx bx-chevron-down" aria-hidden="true"></i>
          </button>
          <div class="dropdown-menu dropdown-menu-right cf-account-menu">
            <a class="dropdown-item" href="{$Setting.system_url}/details"><i class="bx bx-user"></i>{$Lang.personal_information}</a>
            <a class="dropdown-item" href="{$Setting.system_url}/security"><i class="bx bx-shield-quarter"></i>{$Lang.security_center}</a>
            <a class="dropdown-item" href="{$Setting.system_url}/message"><i class="bx bx-message-square-dots"></i>{$Lang.message_center}</a>
            {if $Setting.certifi_open==1}
            <a class="dropdown-item" href="{$Setting.system_url}/verified"><i class="bx bx-id-card"></i>{$Lang.real_name_authentications}</a>
            {/if}
            <div class="dropdown-divider"></div>
            <a class="dropdown-item text-danger" href="{$Setting.system_url}/logout"><i class="bx bx-log-out"></i>{$Lang.log_out}</a>
          </div>
        </div>
        {else/}
        <a class="cf-login-link" href="{$Setting.system_url}/login">{$Lang.please_login}</a>
        {/if}
      </div>
    </div>
  </header>

  {include file="themes/clientarea/default/includes/menu.tpl"}

  <div class="main-content">
    <div class="page-content">
      {if $TplName != 'clientarea'}
      {include file="themes/clientarea/default/includes/pageheader.tpl"}
      {/if}
      <div class="container-fluid">
  {/if}
