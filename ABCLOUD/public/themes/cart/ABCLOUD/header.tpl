{php}
if (!function_exists('parseGroupName')) {
    function parseGroupName($rawName, $isLarge = false) {
        $prefix = '';
        $clean = $rawName;
        if (strpos($rawName, '|') !== false) {
            $parts = explode('|', $rawName, 2);
            $prefix = strtolower(trim($parts[0]));
            $clean = trim($parts[1]);
        }

        $flags = [
            'hk' => $isLarge ? 'flag_hk.png' : 'flagsm_hk.png',
            'cn' => $isLarge ? 'flag_cn.png' : 'flagsm_cn.png',
            'us' => $isLarge ? 'flag_us.png' : 'flagsm_us.png',
            'jp' => $isLarge ? 'flag_jp.png' : 'flagsm_jp.png',
            'kr' => $isLarge ? 'flag_kr.png' : 'flagsm_kr.png',
            'sg' => $isLarge ? 'flag_sg.png' : 'flagsm_sg.png',
            'tw' => $isLarge ? 'flag_tw.png' : 'flagsm_tw.png',
            'de' => $isLarge ? 'flag_de.png' : 'flagsm_de.png',
            'uk' => $isLarge ? 'flag_gb.png' : 'flagsm_gb.png',
            'gb' => $isLarge ? 'flag_gb.png' : 'flagsm_gb.png',
            'fr' => $isLarge ? 'flag_fr.png' : 'flagsm_fr.png',
            'ru' => $isLarge ? 'flag_ru.png' : 'flagsm_ru.png',
            'nl' => $isLarge ? 'flag_nl.png' : 'flagsm_nl.png',
            'au' => $isLarge ? 'flag_au.png' : 'flagsm_au.png',
            'ca' => 'flagsm_ca.png',
        ];

        $iconHtml = '';
        if (isset($flags[$prefix])) {
            $cls = $isLarge ? 'cart-flag-lg' : 'cart-flag-sm';
            $iconHtml = '<img src="/themes/cart/ABCLOUD/assets/icon/' . $flags[$prefix] . '" alt="' . $prefix . '" class="' . $cls . '"> ';
        } elseif ($prefix === 'fwq') {
            $iconHtml = '<svg class="cart-category-icon-sm" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width:16px!important;height:16px!important;min-width:16px!important;max-width:16px!important;flex-shrink:0;vertical-align:-2px;margin-right:6px;display:inline-block;"><rect x="2" y="2" width="20" height="8" rx="2" ry="2"></rect><rect x="2" y="14" width="20" height="8" rx="2" ry="2"></rect><line x1="6" y1="6" x2="6.01" y2="6"></line><line x1="6" y1="18" x2="6.01" y2="18"></line></svg>';
        } elseif ($prefix === 'duli') {
            $iconHtml = '<svg class="cart-category-icon-sm" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width:16px!important;height:16px!important;min-width:16px!important;max-width:16px!important;flex-shrink:0;vertical-align:-2px;margin-right:6px;display:inline-block;"><rect x="4" y="4" width="16" height="16" rx="2" ry="2"></rect><rect x="9" y="9" width="6" height="6"></rect><line x1="9" y1="1" x2="9" y2="4"></line><line x1="15" y1="1" x2="15" y2="4"></line><line x1="9" y1="20" x2="9" y2="23"></line><line x1="15" y1="20" x2="15" y2="23"></line><line x1="20" y1="9" x2="23" y2="9"></line><line x1="20" y1="14" x2="23" y2="14"></line><line x1="1" y1="9" x2="4" y2="9"></line><line x1="1" y1="14" x2="4" y2="14"></line></svg>';
        } elseif ($prefix === 'cdn') {
            $iconHtml = '<svg class="cart-category-icon-sm" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="width:16px!important;height:16px!important;min-width:16px!important;max-width:16px!important;flex-shrink:0;vertical-align:-2px;margin-right:6px;display:inline-block;"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>';
        }

        return [
            'prefix' => $prefix,
            'icon' => $iconHtml,
            'name' => $clean,
            'full' => $iconHtml . htmlspecialchars($clean, ENT_QUOTES, 'UTF-8')
        ];
    }
}
{/php}
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="description" content="{$setting.company_profile|default=''}">
    <meta name="keywords" content="{$setting.web_seo_keywords|default=''}">
    <title>[title] - {if !empty($Setting.company_name)}{$Setting.company_name|htmlspecialchars}{else/}{$setting.company_name|default='ABCLOUD'|htmlspecialchars}{/if}</title>
    <link rel="icon" href="/themes/cart/ABCLOUD/static/ape/upload/logo.png" type="image/png">
    <!-- 基础样式库 -->
    <link href="/themes/cart/ABCLOUD/static/ape/css/bootstrap.min.css?v=3.0.0" rel="stylesheet">
    <link rel="stylesheet" href="/themes/cart/ABCLOUD/static/ape/css/common.css?v=3.0.0">
    <link rel="stylesheet" href="/themes/cart/ABCLOUD/static/ape/css/public.css?v=3.0.0">
    <!-- APE 原版购物车样式 -->
    <link rel="stylesheet" href="/themes/cart/ABCLOUD/assets/css/cscart.css?v=3.0.0">
    <link rel="stylesheet" href="/themes/cart/ABCLOUD/assets/css/goodsList.css?v=3.0.0">
    <link rel="stylesheet" href="/themes/cart/ABCLOUD/assets/css/cart-custom.css?v=3.0.0">

    <style>
        .ape-skip-link { position: absolute; top: -9999px; left: -9999px; }
        .ape-skip-link:focus { top: 0; left: 0; z-index: 99999; background: #1a56db; color: #fff; padding: 8px 16px; }
        .ape-user-box { position: relative; display: inline-flex; align-items: center; }
        .ape-user-btn { display: flex; align-items: center; gap: 8px; padding: 6px 12px; cursor: pointer; border-radius: 20px; transition: background 0.2s; }
        .ape-user-btn:hover { background: rgba(0, 0, 0, 0.04); }
        .ape-user-avatar { width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; overflow: hidden; flex-shrink: 0; background: #409eff; }
        .ape-user-avatar img { width: 100%; height: 100%; object-fit: cover; border-radius: 50%; }
        .ape-user-name { font-size: 14px; color: #333; max-width: 100px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
        .ape-user-arrow { color: #999; transition: transform 0.3s; }
        .ape-user-box.active .ape-user-arrow { transform: rotate(180deg); }
        .ape-user-panel { display: none; position: absolute; top: calc(100% + 8px); right: 0; min-width: 200px; background: #fff; border-radius: 8px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12); padding: 8px 0; z-index: 9999; }
        .ape-user-box.active .ape-user-panel { display: block; }
        .ape-user-panel-item { display: flex; align-items: center; gap: 10px; padding: 10px 16px; font-size: 14px; color: #333; cursor: pointer; transition: background 0.2s; text-decoration: none; }
        .ape-user-panel-item:hover { background: #f5f7fa; color: #1a56db; }
        .ape-user-panel-item svg { flex-shrink: 0; color: #606266; }
        .ape-panel-logout, .ape-panel-logout svg { color: #f56c6c !important; }
        .ape-login-group { display: flex; align-items: center; height: 60px; white-space: nowrap; }
        .ape-mobile-user-panel { display: none; position: absolute; top: 100%; right: 0; min-width: 220px; background: #fff; border-radius: 8px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12); padding: 12px 16px; z-index: 9999; margin-top: 8px; }
        .ape-mobile-user-panel.active { display: flex; gap: 12px; }
        .ape-mobile-user-panel a { flex: 1; padding: 8px 12px; text-align: center; text-decoration: none; border: 1px solid #d9d9d9; border-radius: 4px; color: #333; }
        .ape-mobile-user-panel a:last-child { color: #fff; background: #1a6dd4; border-color: #1a6dd4; }
    </style>
</head>
<body class="cscart-list-body aimax-cart-shell" data-header-context="cart">
    <a class="ape-skip-link" href="#cart-content">跳到主要内容</a>

    <!-- 顶部导航 -->
    <header class="public-header" style="top: 0;">
        <div class="wrap">
            <div class="public-header-left">
                <a class="public-logo" href="{$setting.web_url|default='/'}">
                    <img id="apeSiteLogo" src="{if !empty($Setting.web_logo)}{$Setting.web_logo|htmlspecialchars}{elseif !empty($setting.web_logo)/}{$setting.web_logo|htmlspecialchars}{elseif !empty($setting.logo_url)/}{$setting.logo_url|htmlspecialchars}{else/}/themes/cart/ABCLOUD/static/ape/upload/logo.png{/if}" alt="{if !empty($Setting.company_name)}{$Setting.company_name|htmlspecialchars}{else/}{$setting.company_name|default='ABCLOUD'|htmlspecialchars}{/if}" style="height: 40px; width: auto; object-fit: contain; display: block;" />
                </a>
                <ul class="public-nav" id="publicNav">
                    <li><a href="{$setting.web_url|default='/'}" class="nav-parent">首页</a></li>
                    <li><a href="{$setting.web_url|default=''}/cart" class="nav-parent active">产品与服务</a></li>
                    <li><a href="{$setting.web_url|default='/'}#industry-solutions" class="nav-parent">解决方案</a></li>
                    <li><a href="{$setting.web_url|default=''}/knowledgebase" class="nav-parent">帮助文档</a></li>
                    <li><a href="{$setting.web_url|default=''}/clientarea" class="nav-parent">控制台</a></li>
                </ul>
            </div>

            <div class="public-header-right">
                <div class="public-header-right-nav">
                    <form class="public-header-search" role="search" action="{$setting.web_url|default=''}/knowledgebase" method="get">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                        <input type="search" name="keywords" class="public-search-input" aria-label="搜索产品或文档" placeholder="搜索产品/文档">
                    </form>
                    <div class="public-entry-nav">
                        <a href="{$setting.web_url|default=''}/knowledgebase">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                            文档中心
                        </a>
                        <span style="margin: 0 8px; display: flex; align-items: center; height: 60px;">|</span>
                        <a href="{$setting.web_url|default=''}/clientarea">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                            控制台
                        </a>
                        {if !$Userinfo && !$userInfo}
                        <span class="ape-login-group" id="apeLoginGroup">
                            <span class="ape-login-divider" style="margin: 0 8px; display: flex; align-items: center; height: 60px;">|</span>
                            <a href="{$setting.web_url|default=''}/login" id="apeLoginBtn">登录</a>
                        </span>
                        {else/}
                        <div class="ape-user-box" id="apeUserBox" data-auth-state="authenticated">
                            <div class="ape-user-btn" id="apeUserBtn">
                                <span class="ape-user-avatar" id="apeAvatar"><img src="/themes/cart/ABCLOUD/static/ape/icon/grzx.png" alt="头像" id="apeAvatarImg"></span>
                                <span class="ape-user-name" id="apeDisplayName">{if !empty($Userinfo.username)}{$Userinfo.username}{elseif !empty($userInfo.username) /}{$userInfo.username}{else/}用户中心{/if}</span>
                                <svg class="ape-user-arrow" xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                            </div>
                            <div class="ape-user-panel" id="apeUserPanel">
                                <a class="ape-user-panel-item" href="{$setting.web_url|default=''}/clientarea">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg>
                                    <span>用户中心</span>
                                </a>
                                <a class="ape-user-panel-item" href="{$setting.web_url|default=''}/clientarea">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2L2 7l10 5 10-5-10-5z"></path><path d="M2 17l10 5 10-5"></path><path d="M2 12l10 5 10-5"></path></svg>
                                    <span>余额充值</span>
                                </a>
                                <a class="ape-user-panel-item ape-panel-logout" id="apeLogoutBtn" href="{$setting.web_url|default=''}/logout">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" y1="12" x2="9" y2="12"></line></svg>
                                    <span>退出登录</span>
                                </a>
                            </div>
                        </div>
                        {/if}
                    </div>
                    {if !$Userinfo && !$userInfo}
                    <a href="{$setting.web_url|default=''}/register" class="public-entry-reg" id="apeRegBtn"><img src="/themes/cart/ABCLOUD/static/ape/icon/zctb.png" alt="" width="18" height="18">快速注册</a>
                    {/if}
                </div>
                <div class="public-header-right-m-nav">
                    <div class="public-header-right-m-nav-btn" data-title="user" id="apeMobileUserBtn" role="button" tabindex="0" aria-controls="apeMobileUserPanel" aria-expanded="false">
                        <img src="/themes/cart/ABCLOUD/static/ape/icon/grzx.png" alt="个人中心" width="28" height="28">
                    </div>
                    <div class="ape-mobile-user-panel" id="apeMobileUserPanel">
                        {if $Userinfo || $userInfo}
                        <a href="{$setting.web_url|default=''}/clientarea">个人中心</a><a href="{$setting.web_url|default=''}/logout">退出</a>
                        {else/}
                        <a href="{$setting.web_url|default=''}/login">登录</a><a href="{$setting.web_url|default=''}/register">注册</a>
                        {/if}
                    </div>
                    <div class="public-header-right-m-nav-btn hamburger" data-title="menu" role="button" tabindex="0" aria-label="切换菜单" aria-expanded="false">
                        <div class="hamburger__line"></div>
                        <div class="hamburger__line"></div>
                        <div class="hamburger__line"></div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <!-- 手机端全局菜单抽屉 -->
    <div class="mobile-menu-overlay" id="mobileMenuOverlay">
        <div class="mobile-menu-container">
            <div class="mobile-menu-left">
                <ul class="mobile-menu-list">
                    <li class="mobile-menu-item"><a href="{$setting.web_url|default='/'}" class="mobile-menu-link">首页</a></li>
                    <li class="mobile-menu-item"><a href="{$setting.web_url|default=''}/cart" class="mobile-menu-link active">产品与服务</a></li>
                    <li class="mobile-menu-item"><a href="{$setting.web_url|default=''}/knowledgebase" class="mobile-menu-link">帮助文档</a></li>
                    <li class="mobile-menu-item"><a href="{$setting.web_url|default=''}/clientarea" class="mobile-menu-link">控制台</a></li>
                </ul>
            </div>
            <div class="mobile-menu-right"></div>
        </div>
    </div>
