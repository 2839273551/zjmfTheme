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

if (!function_exists('renderShuidcSpecs')) {
    function renderShuidcSpecs($descHtml) {
        if (strpos((string)$descHtml, 'config-row') !== false) {
            return (string)$descHtml;
        }

        $raw = str_ireplace(['<br>', '<br/>', '<br />', '</li>', '</p>'], "\n", (string)$descHtml);
        $raw = strip_tags($raw);
        $lines = array_filter(array_map('trim', explode("\n", $raw)));
        if (empty($lines)) {
            return '<div class="config-row"><div class="config-label">配置</div><div class="config-value">详见下单配置项</div></div>';
        }

        $icons = [
            'cpu' => ['bg' => '#f3e8ff', 'stroke' => '#7c3aed', 'svg' => '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#7c3aed" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="2"></rect><rect x="9" y="9" width="6" height="6"></rect><line x1="9" y1="1" x2="9" y2="4"></line><line x1="15" y1="1" x2="15" y2="4"></line><line x1="9" y1="20" x2="9" y2="23"></line><line x1="15" y1="20" x2="15" y2="23"></line><line x1="20" y1="9" x2="23" y2="9"></line><line x1="20" y1="14" x2="23" y2="14"></line><line x1="1" y1="9" x2="4" y2="9"></line><line x1="1" y1="14" x2="4" y2="14"></line></svg>'],
            'ram' => ['bg' => '#ecfdf5', 'stroke' => '#059669', 'svg' => '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#059669" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="2" width="20" height="8" rx="2"></rect><rect x="2" y="14" width="20" height="8" rx="2" ry="2"></rect><line x1="6" y1="6" x2="6.01" y2="6"></line><line x1="6" y1="18" x2="6.01" y2="18"></line></svg>'],
            'disk' => ['bg' => '#f1f5f9', 'stroke' => '#475569', 'svg' => '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#475569" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><ellipse cx="12" cy="5" rx="9" ry="3"></ellipse><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"></path><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"></path></svg>'],
            'bandwidth' => ['bg' => '#eff6ff', 'stroke' => '#2563eb', 'svg' => '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#2563eb" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 16 12 12 8 16"></polyline><line x1="12" y1="12" x2="12" y2="21"></line><path d="M20.39 18.39A5 5 0 0 0 18 9h-1.26A8 8 0 1 0 3 16.3"></path></svg>'],
            'defense' => ['bg' => '#fff7ed', 'stroke' => '#ea580c', 'svg' => '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#ea580c" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>'],
            'ip' => ['bg' => '#f0fdf4', 'stroke' => '#16a34a', 'svg' => '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#16a34a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"></polyline></svg>'],
            'privilege' => ['bg' => '#fef3c7', 'stroke' => '#d97706', 'svg' => '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#d97706" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>'],
            'other' => ['bg' => '#eef2ff', 'stroke' => '#4f46e5', 'svg' => '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#4f46e5" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>']
        ];

        $parsed = [];
        $cpuModel = '';
        $cpuCores = '';

        foreach ($lines as $line) {
            $rawK = '';
            $rawV = '';
            if (preg_match('/^([^：:\s]{1,10})[：:]\s*(.*)$/u', $line, $m)) {
                $rawK = trim($m[1]);
                $rawV = trim($m[2]);
            } else {
                $parts = preg_split('/\s+/u', $line, 2);
                $rawK = isset($parts[0]) ? $parts[0] : '';
                $rawV = isset($parts[1]) ? $parts[1] : '';
            }

            if (mb_strpos($rawK, '核心内存') !== false && preg_match('/(\d+核(?:心)?)\s*(\d+[GgMmBb]+)/u', $rawV, $cm)) {
                $cpuCores = $cm[1];
                $parsed[] = ['cat' => 'ram', 'label' => '内存', 'bold' => $cm[2], 'detail' => ''];
                continue;
            }

            if (preg_match('/(处理器|cpu型号)/i', $rawK)) {
                $cpuModel = $rawV;
                continue;
            }

            if (preg_match('/^(cpu|核心)$/i', $rawK)) {
                if (preg_match('/^(\d+核(?:心)?)\s*(.*)$/u', $rawV, $cm)) {
                    $cpuCores = $cm[1];
                    if ($cm[2]) $cpuModel = $cm[2];
                } else {
                    $cpuCores = $rawV;
                }
                continue;
            }

            $cat = 'other';
            $label = mb_substr($rawK, 0, 4);

            if (preg_match('/(内存|ram)/i', $rawK)) {
                $cat = 'ram'; $label = '内存';
            } elseif (preg_match('/(系统盘|硬盘|固态|盘|存储)/i', $rawK)) {
                $cat = 'disk'; $label = '系统盘';
            } elseif (preg_match('/(带宽|宽带|流量|mbps|上下行|网络)/i', $rawK)) {
                $cat = 'bandwidth'; $label = '带宽';
            } elseif (preg_match('/(防御|高防|防护|ddos)/i', $rawK)) {
                $cat = 'defense'; $label = '防御';
            } elseif (preg_match('/(ip|端口)/i', $rawK)) {
                $cat = 'ip'; $label = 'IP数';
            } elseif (preg_match('/(说明|尊享|特色|线路|系统|备案|赠送|备注)/i', $rawK)) {
                $cat = 'privilege'; $label = '备注';
            }

            $valBold = $rawV;
            $valDetail = '';
            if (preg_match('/^([A-Za-z0-9\/\.\-\+]+(?:核心?|G|M|T|Mbps|个|GB|TB)?|[^\s\[\(]+)\s*(.*)$/u', $rawV, $vm)) {
                $valBold = trim($vm[1]);
                $valDetail = trim($vm[2]);
            }

            $parsed[] = ['cat' => $cat, 'label' => $label, 'bold' => $valBold, 'detail' => $valDetail];
        }

        $items = [];
        if ($cpuCores || $cpuModel) {
            $items[] = [
                'cat' => 'cpu',
                'label' => 'CPU',
                'bold' => $cpuCores ?: $cpuModel,
                'detail' => $cpuCores ? $cpuModel : ''
            ];
        }

        foreach ($parsed as $p) {
            $items[] = $p;
        }

        $html = '<div style="display:flex;flex-direction:column;gap:10px;font-size:13.5px;padding:3px 0;">';
        foreach ($items as $item) {
            $cat = $item['cat'];
            $iconDef = isset($icons[$cat]) ? $icons[$cat] : $icons['other'];
            if ($cat === 'privilege') {
                $fullNote = trim($item['bold'] . ' ' . $item['detail']);
                $html .= '<div class="config-row">';
                $html .= '<div class="config-icon" style="background:' . $iconDef['bg'] . ';">' . $iconDef['svg'] . '</div>';
                $html .= '<div class="config-label">' . htmlspecialchars($item['label'], ENT_QUOTES, 'UTF-8') . '</div>';
                $html .= '<div class="config-value"><span class="config-value-privilege">' . htmlspecialchars($fullNote, ENT_QUOTES, 'UTF-8') . '</span></div>';
                $html .= '</div>';
                continue;
            }
            $html .= '<div class="config-row">';
            $html .= '<div class="config-icon" style="background:' . $iconDef['bg'] . ';">' . $iconDef['svg'] . '</div>';
            $html .= '<div class="config-label">' . htmlspecialchars($item['label'], ENT_QUOTES, 'UTF-8') . '</div>';
            $html .= '<div class="config-value"><strong class="config-value-bold">' . htmlspecialchars($item['bold'], ENT_QUOTES, 'UTF-8') . '</strong>';
            if ($item['detail'] !== '') {
                $html .= ' <span class="config-note">' . htmlspecialchars($item['detail'], ENT_QUOTES, 'UTF-8') . '</span>';
            }
            $html .= '</div></div>';
        }
        $html .= '</div>';

        return $html;
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
    <link rel="stylesheet" href="/themes/cart/ABCLOUD/assets/css/cscart.css?v=3.0.19">
    <link rel="stylesheet" href="/themes/cart/ABCLOUD/assets/css/goodsList.css?v=3.0.19">
    <link rel="stylesheet" href="/themes/cart/ABCLOUD/assets/css/cart-custom.css?v=3.0.19">

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
    <div id="cartPageProgressBar" class="cart-top-progress-bar"></div>
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
                        {php}
                          $isCartLoggedIn = !empty($Userinfo['user']['id']) || !empty($Userinfo['id']) || !empty($userInfo['id']);
                        {/php}
                        <a href="{$setting.web_url|default=''}/knowledgebase">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                            文档中心
                        </a>
                        <span style="margin: 0 8px; display: flex; align-items: center; height: 60px;">|</span>
                        <a href="{$setting.web_url|default=''}/clientarea">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
                            控制台
                        </a>
                        {if !$isCartLoggedIn}
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
                    {if !$isCartLoggedIn}
                    <a href="{$setting.web_url|default=''}/register" class="public-entry-reg" id="apeRegBtn"><img src="/themes/cart/ABCLOUD/static/ape/icon/zctb.png" alt="" width="18" height="18">快速注册</a>
                    {/if}
                </div>
                <div class="public-header-right-m-nav">
                    <div class="public-header-right-m-nav-btn" data-title="user" id="apeMobileUserBtn" role="button" tabindex="0" aria-controls="apeMobileUserPanel" aria-expanded="false">
                        <img src="/themes/cart/ABCLOUD/static/ape/icon/grzx.png" alt="个人中心" width="28" height="28">
                    </div>
                    <div class="ape-mobile-user-panel" id="apeMobileUserPanel">
                        {if $isCartLoggedIn}
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
