<?php
if (PHP_SAPI !== 'cli') exit(2);

$c = require '/www/wwwroot/idc.yunxnet.cn/app/config/database.php';
$pdo = new PDO("mysql:host=" . $c['hostname'] . ";dbname=" . $c['database'], $c['username'], $c['password'], [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
]);

// 1. Update shd_abcloud_config
$defaults = [
    "carousel_height" => "600px",
    "switch_effect" => "default",
    "carousel_speed" => "5000",
    "progress_height" => "42px",
    "progress_bar" => "4px",
    "video_zoom" => "35px",
    "error_image" => "/plugins/addons/abcloud_theme/assets/img/404.png",
    "site_name" => "云信网络",
    "site_keywords" => "云计算,云服务器,服务器租用,高防服务器,数据中心",
    "site_description" => "云信网络专注于提供高可用云计算、弹性云服务器及全球基础设施解决方案。",
    "service_phone" => "13273184758",
    "service_email" => "company@email.com",
    "company_intro" => "云信网络是一家专注于企业级云计算服务与数字化基础设施的高新技术企业。",
    "official_website_logo" => "/upload/logo.png",
    "managed_carousel" => "1",
    "managed_feature" => "1",
    "managed_topnav" => "1",
    "managed_footernav" => "1",
    "managed_popup" => "1",
    "managed_web_module" => "1"
];

foreach ($defaults as $k => $v) {
    $stmt = $pdo->prepare("SELECT count(*) FROM shd_abcloud_config WHERE `key` = ?");
    $stmt->execute([$k]);
    if ($stmt->fetchColumn() == 0) {
        $ins = $pdo->prepare("INSERT INTO shd_abcloud_config (`key`, `value`, `updated_at`) VALUES (?, ?, NOW())");
        $ins->execute([$k, $v]);
    } else {
        $up = $pdo->prepare("UPDATE shd_abcloud_config SET `value` = ?, `updated_at` = NOW() WHERE `key` = ? AND (`value` = '' OR `value` IS NULL)");
        $up->execute([$v, $k]);
    }
}
echo "Config updated.\n";

// 2. Features
if ($pdo->query("SELECT count(*) FROM shd_abcloud_feature")->fetchColumn() == 0) {
    $ins = $pdo->prepare("INSERT INTO shd_abcloud_feature (title, description, icon_url, link_url, sort_order, status, created_at) VALUES (?, ?, ?, ?, ?, 1, NOW())");
    $ins->execute(['轮播图管理', '管理首页轮播图内容', '/themes/web/ABCLOUD/static/ape/upload/icon/1.png', '/', 1]);
    $ins->execute(['快捷入口', '管理首页快捷入口', '/themes/web/ABCLOUD/static/ape/upload/icon/2.png', '/', 2]);
    $ins->execute(['导航管理', '管理顶部和底部导航', '/themes/web/ABCLOUD/static/ape/upload/icon/3.png', '/', 3]);
    $ins->execute(['弹窗通知', '管理弹窗通知内容', '/themes/web/ABCLOUD/static/ape/upload/icon/4.png', '/', 4]);
    $ins->execute(['资源库', '管理网站资源文件', '/themes/web/ABCLOUD/static/ape/upload/icon/5.png', '/', 5]);
    echo "Features seeded: 5\n";
}

// 3. Topnav
if ($pdo->query("SELECT count(*) FROM shd_abcloud_topnav")->fetchColumn() == 0) {
    $ins = $pdo->prepare("INSERT INTO shd_abcloud_topnav (title, link_url, parent_id, sort_order, status, menu_type, recommended_tags, menu_desc, created_at) VALUES (?, ?, ?, ?, 1, ?, ?, ?, NOW())");
    $ins->execute(['首页', '/', 0, 1, 'route', null, null]);
    $ins->execute(['产品与服务', '/', 0, 2, 'product', '["HOT"]', null]);
    $ins->execute(['解决方案', '#industry-solutions', 0, 3, 'solution', null, null]);
    $nav3 = $pdo->lastInsertId();
    $ins->execute(['生态合作', '#partner-container', 0, 4, 'mega', null, null]);
    $nav4 = $pdo->lastInsertId();
    $ins->execute(['应用市场', '#cloud-market', 0, 5, 'mega', '["NEW"]', null]);
    $nav5 = $pdo->lastInsertId();
    $ins->execute(['支持与服务', '#support', 0, 6, 'mega', null, null]);
    $nav6 = $pdo->lastInsertId();
    $ins->execute(['关于我们', '#why-choose-us', 0, 7, 'mega', null, null]);
    $nav7 = $pdo->lastInsertId();

    // 解决方案下二级分类
    $ins->execute(['行业解决方案', '#industry-solutions', $nav3, 1, 'route', null, null]);
    $sub3_1 = $pdo->lastInsertId();
    $ins->execute(['通用解决方案', '#industry-solutions', $nav3, 2, 'route', null, null]);
    $sub3_2 = $pdo->lastInsertId();

    $ins->execute(['企业级网站', '#industry-solutions', $sub3_1, 1, 'route', null, '助您打造专业、高效的品牌官网']);
    $ins->execute(['游戏云', '#industry-solutions', $sub3_1, 2, 'route', null, '高效稳定的游戏云，提升玩家体验']);
    $ins->execute(['移动云', '#industry-solutions', $sub3_1, 3, 'route', null, '一站式移动云，助力企业无缝拓展']);
    $ins->execute(['电商云', '#industry-solutions', $sub3_1, 4, 'route', null, '轻松打造线上商城，实现数字化经营']);

    $ins->execute(['云存储方案', '#industry-solutions', $sub3_2, 1, 'route', null, '海量云存储服务，数据安全按需付费']);
    $ins->execute(['CDN加速方案', '#industry-solutions', $sub3_2, 2, 'route', null, '全球CDN加速，提升访问速度降低延迟']);

    // 生态合作
    $ins->execute(['合作伙伴', '#partner-container', $nav4, 1, 'route', null, null]);
    $sub4_1 = $pdo->lastInsertId();
    $ins->execute(['代理推广', '/', $nav4, 2, 'route', null, null]);
    $sub4_2 = $pdo->lastInsertId();
    $ins->execute(['百站赞助公益计划', '/', $sub4_1, 1, 'route', null, '赞助百个站点服务器资源']);
    $ins->execute(['技术合作伙伴', '/', $sub4_1, 2, 'route', null, '共同发展，实现互利共赢']);
    $ins->execute(['推广返利', '/', $sub4_2, 1, 'route', null, '享受推广优惠，轻松赚取额外收益']);

    // 应用市场
    $ins->execute(['操作系统', '#cloud-market', $nav5, 1, 'route', null, null]);
    $sub5_1 = $pdo->lastInsertId();
    $ins->execute(['应用软件', '#cloud-market', $nav5, 2, 'route', null, null]);
    $sub5_2 = $pdo->lastInsertId();
    $ins->execute(['Linux系统', '#cloud-market', $sub5_1, 1, 'route', null, '主流Linux发行版，一键秒级部署']);
    $ins->execute(['Windows系统', '#cloud-market', $sub5_1, 2, 'route', null, 'Windows Server正版镜像，稳定可靠']);
    $ins->execute(['宝塔面板', '#cloud-market', $sub5_2, 1, 'route', null, '强大的服务器运维管理面板']);

    // 支持与服务
    $ins->execute(['帮助中心', '#support', $nav6, 1, 'route', null, null]);
    $sub6_1 = $pdo->lastInsertId();
    $ins->execute(['服务支持', '#support', $nav6, 2, 'route', null, null]);
    $sub6_2 = $pdo->lastInsertId();
    $ins->execute(['帮助文档', '/knowledgebaseview?id=1', $sub6_1, 1, 'route', null, '详细的使用指南和常见问题解答']);
    $ins->execute(['最新公告', '/news/list?parent_id=2', $sub6_1, 2, 'route', null, '系统维护与活动通知']);
    $ins->execute(['提交工单', '/supporttickets', $sub6_2, 1, 'route', null, '遇到技术或业务问题快速响应']);
    $ins->execute(['在线客服', '/', $sub6_2, 2, 'route', null, '全天候客服咨询与技术支持']);

    // 关于我们
    $ins->execute(['公司介绍', '#why-choose-us', $nav7, 1, 'route', null, null]);
    $sub7_1 = $pdo->lastInsertId();
    $ins->execute(['新闻动态', '/news/list?parent_id=1', $nav7, 2, 'route', null, null]);
    $sub7_2 = $pdo->lastInsertId();
    $ins->execute(['公司简介', '#why-choose-us', $sub7_1, 1, 'route', null, '了解我们的团队与使命']);
    $ins->execute(['行业新闻', '/news/list?parent_id=1', $sub7_2, 1, 'route', null, '云计算行业动态']);
    echo "Topnav seeded: 25 items\n";
}

// 4. Footernav
if ($pdo->query("SELECT count(*) FROM shd_abcloud_footernav")->fetchColumn() == 0) {
    $ins = $pdo->prepare("INSERT INTO shd_abcloud_footernav (category, title, description, link_url, sort_order, status, created_at) VALUES (?, ?, ?, ?, ?, 1, NOW())");
    $ins->execute(['服务指南', '安全中心', '安全防护', '/', 1]);
    $ins->execute(['服务指南', '实名认证', '账号认证', '/clientarea', 2]);
    $ins->execute(['服务指南', 'API管理', '开发者接口', '/clientarea', 3]);
    $ins->execute(['服务指南', '提交工单', '售后支持', '/supporttickets', 4]);
    $ins->execute(['服务指南', '服务条款', '用户协议', '/', 5]);

    $ins->execute(['账户服务', '个人资料', '个人信息', '/clientarea', 1]);
    $ins->execute(['账户服务', '我的产品', '服务器与服务', '/clientarea', 2]);
    $ins->execute(['账户服务', '财务账单', '账单与充值', '/clientarea', 3]);
    $ins->execute(['账户服务', '消费明细', '流水记录', '/clientarea', 4]);

    $ins->execute(['帮助中心', '新闻动态', '行业资讯', '/news/list?parent_id=1', 1]);
    $ins->execute(['帮助中心', '系统公告', '重要通知', '/news/list?parent_id=2', 2]);
    $ins->execute(['帮助中心', '知识库文档', '使用手册', '/knowledgebaseview?id=1', 3]);
    $ins->execute(['帮助中心', '新手指南', '快速上手', '/knowledgebaseview?id=2', 4]);

    $ins->execute(['关于我们', '公司简介', '关于平台', '#why-choose-us', 1]);
    $ins->execute(['关于我们', '联系我们', '客服支持', '/', 2]);
    $ins->execute(['关于我们', '资质荣誉', '企业认证', '/', 3]);
    $ins->execute(['关于我们', '合作伙伴', '生态共赢', '#partner-container', 4]);
    echo "Footernav seeded: 17 items\n";
}

// 5. Popup
if ($pdo->query("SELECT count(*) FROM shd_abcloud_popup")->fetchColumn() == 0) {
    $ins = $pdo->prepare("INSERT INTO shd_abcloud_popup (title, content, link_url, button_text, show_type, sort_order, status, created_at) VALUES (?, ?, ?, ?, 'once', 1, 1, NOW())");
    $ins->execute(['网站通知', '<p>尊敬的客户您好！</p><p>欢迎访问云信网络。我们为您提供稳定、高性能的云计算基础设施与全球网络服务。如遇任何系统操作或业务咨询疑问，可随时通过在线客服或提交工单与我们联系。</p>', '/supporttickets', '了解详情']);
    echo "Popup seeded: 1 item\n";
}

// 6. Web modules
if ($pdo->query("SELECT count(*) FROM shd_abcloud_web_module")->fetchColumn() == 0) {
    $ins = $pdo->prepare("INSERT INTO shd_abcloud_web_module (category, title, description, link_url, icon_url, image_url, sort_order, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, 1, NOW())");
    $ins->execute(['顶部公告', '系统公告', '欢迎访问云信网络！高可用服务器与云产品限时优惠活动正在进行中。', '', '', '', 1]);
    $ins->execute(['侧边导航', '客服机器人', '在线咨询', '', '', '/themes/web/ABCLOUD/static/ape/upload/jqr.gif', 1]);
    $ins->execute(['侧边导航', 'QQ客服', '2839273551', '', '', '', 2]);
    $ins->execute(['侧边导航', '工单服务', '售后问题提交工单，快速响应解决。', '/supporttickets', '', '', 3]);
    $ins->execute(['侧边导航', '微信客服', '扫码关注微信公众号', '', '', '/themes/web/ABCLOUD/static/ape/upload/local6626389782fe8.png', 4]);
    echo "Web modules seeded: 5 items\n";
}
echo "All seeding completed successfully.\n";
