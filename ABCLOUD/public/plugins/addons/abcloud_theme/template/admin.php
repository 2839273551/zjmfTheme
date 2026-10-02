<?php
if (!isset($context) || !is_array($context)) { http_response_code(404); exit; }
$e = static function ($value) { return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8'); };
$j = static function ($value) { return str_replace(['<','>','&'], ['\\u003C','\\u003E','\\u0026'], json_encode($value, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)); };
$page = $context['page'];
$pageNames = [
    'dashboard'=>'控制台','carousel'=>'轮播图管理','feature'=>'快捷入口管理','topnav'=>'顶部导航管理',
    'footernav'=>'底部导航管理','web_module'=>'通用模块','popup'=>'弹窗通知管理','config'=>'网站配置',
    'carousel_global'=>'轮播图全局设置','resources'=>'资源库管理','operation_log'=>'操作日志'
];
$actionNames = ['add'=>'新增','update'=>'修改','delete'=>'删除','sort'=>'排序'];
$moduleNames = [
    'carousel'=>'轮播图','feature'=>'快捷入口','topnav'=>'顶部导航','footernav'=>'底部导航',
    'web_module'=>'通用模块','popup'=>'弹窗通知','config'=>'网站配置','carousel_global'=>'轮播图全局设置',
    'resources'=>'资源库','upload'=>'资源上传','operation_log'=>'操作日志'
];
$formatDetail = static function ($log) use ($actionNames, $moduleNames) {
    $detail = $log['detail'] ?? '';
    if (!is_string($detail) || $detail === '') return '';
    $trimmed = trim($detail);
    if (($trimmed[0] ?? '') !== '{' && ($trimmed[0] ?? '') !== '[') return $trimmed;
    $data = json_decode($trimmed, true);
    if (!is_array($data)) return $trimmed;
    $cfgMap = [
        'switch_effect'=>'切换特效','carousel_speed'=>'轮播播放间隔','carousel_height'=>'轮播图高度',
        'progress_height'=>'进度条高度','progress_bar'=>'进度条粗细','video_zoom'=>'视频放大尺寸',
        'error_image'=>'异常占位图','site_name'=>'网站名称','site_keywords'=>'网站关键词',
        'site_description'=>'网站描述','service_phone'=>'客服电话','service_email'=>'客服邮箱',
        'company_intro'=>'公司简介','official_website_logo'=>'官网标志图片'
    ];
    $mod = (string)($log['module'] ?? '');
    $act = (string)($log['action'] ?? '');
    $modName = $moduleNames[$mod] ?? $mod;
    $actName = $actionNames[$act] ?? $act;
    if (!empty($data['keys']) && is_array($data['keys'])) {
        $keys = array_values(array_filter($data['keys'], static function($k){
            return strpos($k, '__') !== 0 && strpos($k, 'managed_') !== 0;
        }));
        $mapped = array_map(static function($k) use ($cfgMap) { return $cfgMap[$k] ?? $k; }, $keys);
        if (empty($mapped)) return '保存配置项';
        $isGlobal = true;
        foreach ($keys as $k) {
            if (!in_array($k, ['switch_effect','carousel_speed','carousel_height','progress_height','progress_bar','video_zoom','error_image'], true)) {
                $isGlobal = false; break;
            }
        }
        if ($isGlobal) return '保存轮播全局设置（' . implode('、', $mapped) . '）';
        $isSite = true;
        foreach ($keys as $k) {
            if (!in_array($k, ['site_name','site_keywords','site_description','service_phone','service_email','company_intro','official_website_logo'], true)) {
                $isSite = false; break;
            }
        }
        if ($isSite) return '保存网站基本配置（' . implode('、', $mapped) . '）';
        return '保存配置项（' . implode('、', $mapped) . '）';
    }
    if ($act === 'upload' || $mod === 'upload' || (!empty($data['name']) && $act === 'add' && empty($data['kind']))) {
        return '上传文件：' . ($data['name'] ?? ('编号 ' . ($data['id'] ?? '')));
    }
    if (($data['kind'] ?? '') === 'dir' && $act === 'add') {
        return '新建文件夹：' . ($data['name'] ?? ('编号 ' . ($data['id'] ?? '')));
    }
    if ($act === 'update' && $mod === 'resources' && !empty($data['name'])) {
        return '重命名资源为：' . $data['name'] . (!empty($data['id']) ? '（编号: ' . $data['id'] . '）' : '');
    }
    if (!empty($data['ids']) && is_array($data['ids'])) {
        return '批量删除' . $modName . '（编号: ' . implode(', ', $data['ids']) . '）';
    }
    if (isset($data['id'])) {
        $title = !empty($data['title']) ? '“' . $data['title'] . '”' : '';
        if ($act === 'add') return '新增' . $modName . ($title ? '：' . $title : '') . '（编号: ' . $data['id'] . '）';
        if ($act === 'update') return '修改' . $modName . ($title ? '：' . $title : '') . '（编号: ' . $data['id'] . '）';
        if ($act === 'delete') return '删除' . $modName . ($title ? '：' . $title : '') . '（编号: ' . $data['id'] . '）';
        return $actName . $modName . '（编号: ' . $data['id'] . '）';
    }
    if (isset($data['parent_id'])) {
        return ((int)$data['parent_id'] === 0) ? '调整顶级导航显示顺序' : ('调整子导航显示顺序（父级编号: ' . $data['parent_id'] . '）');
    }
    return $trimmed;
};
$navUrl = static function ($target) use ($context) {
    $url = $context['pageUrl'];
    return $url . (strpos($url, '?') === false ? '?' : '&') . http_build_query(['page' => $target]);
};
$module = $page === 'carousel_global' ? 'carousel_global' : $page;
$items = $context['items'];
$configs = $context['configMap'];
$rows = $context['logs'];
$isPicker = $context['picker'];
$pickerField = preg_replace('/[^a-zA-Z0-9_-]/', '', (string)($_GET['field'] ?? 'media')) ?: 'media';
?>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title><?= $e($pageNames[$page] ?? 'ABCLOUD 管理后台') ?></title>
    <link rel="stylesheet" href="<?= $e($context['assetUrl']) ?>/css/admin.css">
    <style>
        .layout>.main{min-width:0;max-width:100%}
        .plugin-mobile-menu{display:none;border:0;background:transparent;color:#fff;font-size:22px;cursor:pointer;width:36px;height:36px}
        .plugin-menu-backdrop{display:none}
        @media(max-width:768px){.plugin-mobile-menu{display:inline-flex;align-items:center;justify-content:center}.plugin-menu-open .sidebar{width:240px;overflow-y:auto;z-index:201}.plugin-menu-open .plugin-menu-backdrop{display:block;position:fixed;inset:48px 0 0;background:rgba(0,0,0,.35);z-index:200}}
        @media(max-width:560px){.top-header{padding:0 10px;gap:4px}.top-header-left{min-width:0;flex:1;gap:4px}.header-logo.plugin-brand{min-width:0;gap:5px}.header-logo.plugin-brand img{width:20px;height:20px}.top-header-left .logo-text{font-size:13px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.header-version,.header-tools,.user-name{display:none}.top-header-right{flex:none;gap:0}.user-dropdown{padding:2px}.user-avatar{width:28px;height:28px}.plugin-mobile-menu{width:30px;flex:none}}
        .plugin-brand{display:flex;align-items:center;gap:9px;font-weight:600}.plugin-brand img{width:25px;height:25px;object-fit:contain}
        .top-header-right{display:flex;align-items:center;gap:12px}
        .header-tools{display:flex;align-items:center;gap:6px}
        .tool-btn{background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.16);color:rgba(255,255,255,.9);cursor:pointer;width:32px;height:32px;padding:0;display:inline-flex;align-items:center;justify-content:center;border-radius:4px;transition:all .2s ease}
        .tool-btn svg{width:16px;height:16px;color:rgba(255,255,255,.9);stroke:rgba(255,255,255,.9)}
        .tool-btn:hover{background:rgba(255,255,255,.22);border-color:rgba(255,255,255,.35);color:#fff}
        .tool-btn:hover svg{color:#fff;stroke:#fff}
        .user-dropdown{display:flex;align-items:center;gap:8px;padding:4px 10px;border-radius:16px;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.14)}
        .user-avatar{width:24px;height:24px;border-radius:50%;background:#409eff;color:#fff;display:flex;align-items:center;justify-content:center;overflow:hidden;flex-shrink:0}
        .user-avatar svg{width:14px;height:14px;fill:#ffffff}
        .user-name{color:#ffffff;font-size:13px;font-weight:500}
        .header-version{color:rgba(255,255,255,.7);font-size:12px}
        .sidebar{width:200px;background:#001529;position:fixed;top:48px;bottom:0;left:0;overflow-y:auto;z-index:100;box-shadow:2px 0 8px rgba(0,0,0,.12)}
        .sidebar-menu{list-style:none;padding:8px 0;margin:0}
        .sidebar-menu li{margin:3px 8px}
        .sidebar-menu a{display:flex;align-items:center;gap:10px;padding:10px 12px;color:rgba(255,255,255,.7);text-decoration:none;font-size:14px;border-radius:6px;white-space:nowrap;transition:all .2s ease}
        .sidebar-menu a .menu-icon{width:18px;height:18px;display:inline-flex;align-items:center;justify-content:center;flex-shrink:0}
        .sidebar-menu a .menu-icon svg{width:16px;height:16px;color:rgba(255,255,255,.7);stroke:currentColor;fill:none;transition:color .2s}
        .sidebar-menu a:hover{color:#fff;background:rgba(255,255,255,.08)}
        .sidebar-menu a:hover .menu-icon svg{color:#fff}
        .sidebar-menu a.submenu-toggle.has-active-child{color:#fff;background:rgba(255,255,255,.06);font-weight:500}
        .sidebar-menu a.submenu-toggle.has-active-child .menu-icon svg{color:#409eff}
        .sidebar-menu a.active:not(.submenu-toggle){color:#fff!important;background:#1890ff!important;font-weight:500;box-shadow:0 2px 8px rgba(24,144,255,.4)}
        .sidebar-menu a.active:not(.submenu-toggle) .menu-icon svg{color:#fff!important}
        .sidebar-menu .submenu{list-style:none;padding:4px 0 4px 6px;margin:2px 0;background:rgba(0,0,0,.18);border-radius:6px;display:none}
        .sidebar-menu .submenu.show{display:block}
        .sidebar-menu .submenu li{margin:2px 0}
        .sidebar-menu .submenu a{padding:8px 12px 8px 30px;font-size:13px;color:rgba(255,255,255,.65);border-radius:4px}
        .sidebar-menu .submenu a:hover{color:#fff;background:rgba(255,255,255,.08)}
        .sidebar-menu .submenu a.active{color:#fff!important;background:#1890ff!important;box-shadow:0 2px 6px rgba(24,144,255,.35)}
        .sidebar-menu .submenu-arrow{margin-left:auto;display:inline-flex;align-items:center;transition:transform .25s ease;color:rgba(255,255,255,.5)}
        .sidebar-menu .has-submenu.open .submenu-arrow{transform:rotate(180deg)}
        .tab-bar{background:#fff;padding:14px 20px;border-bottom:1px solid #ebeef5;margin-bottom:20px;border-radius:6px;box-shadow:0 1px 3px rgba(0,0,0,.02)}
        .page-title{font-size:16px;font-weight:600;color:#1f2d3d;display:flex;align-items:center;gap:8px}
        .page-title::before{content:'';display:inline-block;width:4px;height:16px;background:#409eff;border-radius:2px}
        .plugin-card{background:#fff;border:1px solid #e4e7ed;border-radius:8px;padding:24px 28px;box-shadow:0 2px 12px 0 rgba(0,0,0,.04)}
        .plugin-card h2{margin:0 0 16px;color:#303133;font-size:18px}
        .plugin-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:16px}
        .plugin-stat{padding:18px;background:#fff;border:1px solid #ebeef5;border-radius:6px}
        .plugin-stat b{font-size:26px;color:#303133;display:block;margin-top:6px}
        .plugin-stat span{color:#909399;font-size:13px}
        .plugin-table{width:100%;border-collapse:collapse;background:#fff}
        .plugin-table th,.plugin-table td{padding:12px 14px;border-bottom:1px solid #ebeef5;text-align:left;font-size:13px;vertical-align:middle}
        .plugin-table th{background:#f8f9fb;color:#606266;font-weight:600}
        .plugin-table td img{width:72px;height:42px;object-fit:cover;border-radius:4px;background:#f5f7fa}
        .plugin-actions{display:flex;gap:12px;align-items:center;margin-top:24px;padding-top:20px;border-top:1px solid #f0f2f5;padding-left:156px}
        .plugin-actions button,.plugin-toolbar button{border:0;border-radius:4px;padding:8px 18px;cursor:pointer;background:#409eff;color:#fff;font-weight:500;font-size:14px;transition:all .2s ease;box-shadow:0 2px 6px rgba(64,158,255,.25)}
        .plugin-actions button:hover,.plugin-toolbar button:hover{background:#66b1ff;box-shadow:0 4px 12px rgba(64,158,255,.35)}
        .plugin-actions button.danger{background:#f56c6c;box-shadow:0 2px 6px rgba(245,108,108,.25)}
        .plugin-actions button.danger:hover{background:#f78989}
        .plugin-actions button.muted{background:#f4f4f5;color:#909399;border:1px solid #dcdfe6;box-shadow:none}
        .plugin-actions button.muted:hover{background:#e9e9eb;color:#606266}
        .plugin-toolbar{display:flex;justify-content:space-between;gap:12px;align-items:center;margin-bottom:16px;flex-wrap:wrap}
        .plugin-toolbar .left,.plugin-toolbar .right{display:flex;gap:8px;align-items:center;flex-wrap:wrap}
        .plugin-input,.plugin-select,.plugin-textarea{box-sizing:border-box;border:1px solid #dcdfe6;border-radius:4px;padding:8px 12px;min-height:36px;color:#303133;background:#fff;font-size:14px;transition:all .2s ease;max-width:520px}
        .plugin-input:hover,.plugin-select:hover,.plugin-textarea:hover{border-color:#c0c4cc}
        .plugin-input:focus,.plugin-select:focus,.plugin-textarea:focus{border-color:#409eff;box-shadow:0 0 0 2px rgba(64,158,255,.15);outline:none}
        .plugin-textarea{width:100%;max-width:600px;min-height:100px;resize:vertical;line-height:1.6}
        .plugin-field{display:grid;grid-template-columns:140px minmax(0,1fr);gap:16px;align-items:start;margin-bottom:18px;padding-bottom:16px;border-bottom:1px solid #f2f3f5}
        .plugin-field:last-child{border-bottom:none;padding-bottom:0}
        .plugin-field>label{color:#4e5969;font-size:14px;font-weight:500;text-align:right;padding-top:8px;white-space:nowrap}
        .plugin-field small,.plugin-field-hint{display:block;color:#909399;font-size:12px;margin-top:6px;line-height:1.5}
        .plugin-switch{display:flex;gap:8px;align-items:center;padding-top:8px}
        .plugin-empty{text-align:center;color:#909399;padding:55px 20px}
        .plugin-modal{position:fixed;inset:0;background:rgba(0,0,0,.45);display:none;align-items:center;justify-content:center;z-index:20000;padding:20px}
        .plugin-modal.open{display:flex}
        .plugin-dialog{background:#fff;border-radius:7px;width:min(760px,100%);max-height:90vh;overflow:auto;box-shadow:0 10px 30px rgba(0,0,0,.18)}
        .plugin-dialog-head{display:flex;justify-content:space-between;align-items:center;padding:16px 20px;border-bottom:1px solid #ebeef5;font-weight:600}
        .plugin-dialog-body{padding:20px}
        .plugin-dialog-foot{padding:14px 20px;border-top:1px solid #ebeef5;text-align:right}
        .plugin-dialog-foot button{margin-left:8px}
        .resource-picker .layout{min-height:100vh}
        .picker-close{float:right;color:#909399;cursor:pointer}
        .plugin-rich{min-height:180px;border:1px solid #dcdfe6;border-radius:4px;padding:10px;line-height:1.7}
        .plugin-tree{margin:0;padding:0;list-style:none}
        .plugin-tree li{padding:7px 8px;border-bottom:1px solid #f5f5f5}
        .plugin-tree li.child{padding-left:28px}
        .plugin-note{font-size:12px;color:#909399}
        .plugin-chip{display:inline-block;padding:2px 8px;border-radius:12px;background:#ecf5ff;color:#409eff;font-size:12px}
        .plugin-chip.off{background:#fef0f0;color:#f56c6c}
        @media(max-width:900px){.plugin-grid{grid-template-columns:repeat(2,minmax(0,1fr))}.plugin-field{grid-template-columns:1fr;gap:4px}.plugin-field>label{text-align:left;padding-top:0}.plugin-actions{padding-left:0}.plugin-table{min-width:760px}.plugin-card{overflow:auto}.content-box{overflow-x:auto}}
        @media(max-width:560px){.plugin-grid{grid-template-columns:1fr}.plugin-toolbar{align-items:stretch}.plugin-toolbar .left,.plugin-toolbar .right{width:100%}.plugin-toolbar button,.plugin-toolbar .plugin-input{flex:1}.plugin-dialog-body{padding:14px}}
    </style>
</head>
<body class="<?= $isPicker ? 'resource-picker' : '' ?>">
<div class="top-header">
    <div class="top-header-left"><button class="plugin-mobile-menu" id="pluginMenuToggle" type="button" aria-label="打开管理菜单" aria-expanded="false">☰</button><div class="header-logo plugin-brand"><img src="<?= $e($context['assetUrl']) ?>/img/APE.png" alt="ABCLOUD"><span class="logo-text">ABCLOUD 主题管理</span></div><div class="header-version"><?= $e(date('Y年n月j日')) ?></div></div>
    <div class="top-header-right"><div class="header-tools"><button class="tool-btn" type="button" title="刷新页面" onclick="location.reload()"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M23 4v6h-6"></path><path d="M1 20v-6h6"></path><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg></button><button class="tool-btn" type="button" title="切换全屏" onclick="document.documentElement.requestFullscreen&&document.documentElement.requestFullscreen()"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3"></path></svg></button></div><div class="user-dropdown"><div class="user-avatar" title="当前登录管理员"><svg viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg></div><span class="user-name"><?= $e($context['adminName']) ?></span></div></div>
</div>
<?php if ($isPicker): ?>
<div class="layout"><div class="main" style="margin-left:0;width:100%"><div class="content-box"><div class="plugin-toolbar"><div><b>资源库选择器</b><span class="plugin-note">点击资源即可返回原表单</span></div><a class="layui-btn layui-btn-sm" href="javascript:window.close()">关闭</a></div><div id="resourcePickerRoot"></div></div></div></div>
<?php else: ?>
<div class="layout">
    <div class="plugin-menu-backdrop" id="pluginMenuBackdrop"></div>
    <div class="sidebar"><ul class="sidebar-menu">
        <li><a href="<?= $e($navUrl('dashboard')) ?>" class="<?= $page==='dashboard'?'active':'' ?>"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><rect x="3" y="3" width="7" height="7" rx="1"></rect><rect x="14" y="3" width="7" height="7" rx="1"></rect><rect x="14" y="14" width="7" height="7" rx="1"></rect><rect x="3" y="14" width="7" height="7" rx="1"></rect></svg></span><span class="menu-title">控制台</span></a></li>
        <li class="has-submenu open"><a href="javascript:;" class="submenu-toggle <?= in_array($page,['carousel','carousel_global'],true)?'has-active-child':'' ?>"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><rect x="2" y="3" width="20" height="14" rx="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg></span><span class="menu-title">轮播图管理</span><span class="submenu-arrow"><svg viewBox="0 0 24 24" width="12" height="12" stroke="currentColor" stroke-width="2.5" fill="none"><polyline points="6 9 12 15 18 9"></polyline></svg></span></a><ul class="submenu show"><li><a class="<?= $page==='carousel'?'active':'' ?>" href="<?= $e($navUrl('carousel')) ?>">轮播图列表</a></li><li><a class="<?= $page==='carousel_global'?'active':'' ?>" href="<?= $e($navUrl('carousel_global')) ?>">全局设置</a></li></ul></li>
        <li><a href="<?= $e($navUrl('feature')) ?>" class="<?= $page==='feature'?'active':'' ?>"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg></span><span class="menu-title">快捷入口管理</span></a></li>
        <li><a href="<?= $e($navUrl('topnav')) ?>" class="<?= $page==='topnav'?'active':'' ?>"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg></span><span class="menu-title">顶部导航管理</span></a></li>
        <li><a href="<?= $e($navUrl('footernav')) ?>" class="<?= $page==='footernav'?'active':'' ?>"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><rect x="3" y="3" width="18" height="18" rx="2"></rect><line x1="3" y1="15" x2="21" y2="15"></line></svg></span><span class="menu-title">底部导航管理</span></a></li>
        <li><a href="<?= $e($navUrl('web_module')) ?>" class="<?= $page==='web_module'?'active':'' ?>"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path><polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline><line x1="12" y1="22.08" x2="12" y2="12"></line></svg></span><span class="menu-title">通用模块</span></a></li>
        <li><a href="<?= $e($navUrl('popup')) ?>" class="<?= $page==='popup'?'active':'' ?>"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg></span><span class="menu-title">弹窗通知管理</span></a></li>
        <li><a href="<?= $e($navUrl('resources')) ?>" class="<?= $page==='resources'?'active':'' ?>"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"></path></svg></span><span class="menu-title">资源库管理</span></a></li>
        <li><a href="<?= $e($navUrl('config')) ?>" class="<?= $page==='config'?'active':'' ?>"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg></span><span class="menu-title">网站配置</span></a></li>
        <li><a href="<?= $e($navUrl('operation_log')) ?>" class="<?= $page==='operation_log'?'active':'' ?>"><span class="menu-icon"><svg viewBox="0 0 24 24" width="16" height="16" stroke="currentColor" stroke-width="2" fill="none"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg></span><span class="menu-title">操作日志</span></a></li>
    </ul></div>
    <div class="main"><div class="tab-bar"><span class="page-title"><?= $e($pageNames[$page] ?? '') ?></span></div><div class="content-box">
<?php if ($page === 'dashboard'): ?>
        <div class="plugin-card" style="margin-bottom:18px"><h2>欢迎回来，<?= $e($context['adminName']) ?>！</h2></div>
        <div class="plugin-grid"><?php foreach ([['carousel','轮播图'],['feature','快捷入口'],['topnav','顶部导航'],['resources','资源文件'],['popup','弹窗通知'],['web_module','通用模块'],['footernav','底部导航'],['operation_log','操作日志']] as $stat): ?><div class="plugin-stat"><span><?= $e($stat[1]) ?></span><b><?= (int)($context['counts'][$stat[0]] ?? ($stat[0]==='operation_log'?$context['logTotal']:0)) ?></b></div><?php endforeach; ?></div>
        <div class="plugin-card" style="margin-top:18px"><h2>最近操作</h2><?php if (!$rows): ?><div class="plugin-empty">暂无操作记录</div><?php else: ?><table class="plugin-table"><thead><tr><th>时间</th><th>操作人</th><th>动作</th><th>模块</th><th>详情</th></tr></thead><tbody><?php foreach (array_slice($rows,0,8) as $log): ?><tr><td><?= $e($log['created_at']??'') ?></td><td><?= $e($log['admin_name']??'系统') ?></td><td><?= $e($actionNames[$log['action']??''] ?? ($log['action']??'')) ?></td><td><?= $e($moduleNames[$log['module']??''] ?? ($log['module']??'')) ?></td><td><?= $e($formatDetail($log)) ?></td></tr><?php endforeach; ?></tbody></table><?php endif; ?></div>
<?php elseif ($page === 'config' || $page === 'carousel_global'): ?>
        <div class="plugin-card"><div id="configForm"></div><div class="plugin-actions"><button onclick="PluginAdmin.saveConfig()">保存修改</button><button class="muted" onclick="location.reload()">重置</button></div></div>
<?php elseif ($page === 'resources'): ?>
        <div class="plugin-card"><div class="plugin-toolbar"><div class="left"><button onclick="PluginAdmin.createDir()">新建文件夹</button><button onclick="PluginAdmin.openUpload()">上传文件</button><button onclick="PluginAdmin.openRemote()" style="background:#67c23a">远程上传</button></div><div class="right"><input class="plugin-input" id="resourceSearch" placeholder="文件名搜索" oninput="PluginAdmin.renderResources()"></div></div><div id="resourceRoot"></div></div>
<?php elseif ($page === 'operation_log'): ?>
        <div class="plugin-card"><div class="plugin-toolbar"><div class="left"><span class="plugin-note">共 <?= (int)$context['logTotal'] ?> 条</span></div><div class="right"><input class="plugin-input" id="logSearch" placeholder="搜索操作人/IP/详情" oninput="PluginAdmin.renderLogs()"></div></div><div id="logRoot"></div></div>
<?php else: ?>
        <div class="plugin-card"><div class="plugin-toolbar"><div class="left"><button onclick="PluginAdmin.openEditor()">新增<?= $e($pageNames[$page] ?? '记录') ?></button><span class="plugin-note">保留原 APE 字段与操作</span></div><div class="right"><input class="plugin-input" id="itemSearch" placeholder="搜索标题/分类" oninput="PluginAdmin.renderItems()"></div></div><div id="itemsRoot"></div></div>
<?php endif; ?>
    </div></div>
</div>
<?php endif; ?>
<div id="pluginModal" class="plugin-modal"><div class="plugin-dialog"><div class="plugin-dialog-head"><span id="pluginModalTitle"></span><span class="picker-close" onclick="PluginAdmin.closeModal()">×</span></div><div class="plugin-dialog-body" id="pluginModalBody"></div><div class="plugin-dialog-foot"><button class="layui-btn layui-btn-primary" onclick="PluginAdmin.closeModal()">取消</button><button class="layui-btn" onclick="PluginAdmin.submitModal()">保存</button></div></div></div>
<script>
window.PLUGIN_CONTEXT = {page:<?= $j($page) ?>,module:<?= $j($module) ?>,items:<?= $j($items) ?>,configs:<?= $j($configs) ?>,logs:<?= $j($rows) ?>,csrf:<?= $j($context['csrfToken']) ?>,pageUrl:<?= $j($context['pageUrl']) ?>,apiUrl:<?= $j($context['apiUrl']) ?>,assetUrl:<?= $j($context['assetUrl']) ?>,publicUrl:<?= $j($context['publicUrl']) ?>,picker:<?= $isPicker?'true':'false' ?>,pickerField:<?= $j($pickerField) ?>};
window.BASE_URL=window.PLUGIN_CONTEXT.pageUrl; window.PAGE_URL=window.PLUGIN_CONTEXT.pageUrl; window.API_URL=window.PLUGIN_CONTEXT.apiUrl; window.CSRF_TOKEN=window.PLUGIN_CONTEXT.csrf;
</script>
<script src="<?= $e($context['assetUrl']) ?>/js/plugin-admin.js?v=1.0.1"></script>
</body></html>
