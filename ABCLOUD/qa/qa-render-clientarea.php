<?php
if (PHP_SAPI !== 'cli' && ($_SERVER["REMOTE_ADDR"] ?? "") !== "127.0.0.1") {
    http_response_code(403);
    exit("403");
}
define('APP_DEBUG', false);
define('URL_ROUTE_MUST', false);
define('CMF_ROOT', dirname(__DIR__) . '/');
define('CMF_DATA', CMF_ROOT . 'data/');
define('DOWN_PATH', CMF_ROOT . 'downloads/');
define('DOWN_PATH1', CMF_ROOT . 'public/downloads/');
define('TICKET_DOWN_PATH', DOWN_PATH . 'ticket/');
define('SUPPORT_DOWN_PATH', DOWN_PATH1 . 'support/');
define('DATABASE_DOWN_PATH', DOWN_PATH . 'database/');
define('UPLOAD_PATH', CMF_ROOT . 'uploads/');
define('UPLOAD_DEFAULT', UPLOAD_PATH . 'common/default/');
define('APP_PATH', CMF_ROOT . 'app/');
define('WEB_ROOT', __DIR__ . '/');
define('VIEW_TEMPLATE_SUFFIX', 'tpl');
define('VIEW_TEMPLATE_DIRECTORY', 'clientarea');
define('VIEW_TEMPLATE_WEBSITE', true);
define('VIEW_TEMPLATE_ADMIN', false);
define('VIEW_TEMPLATE_HOME_PLUGINS', false);
define('VIEW_TEMPLATE_ADMIN_PLUGINS', false);

$_SERVER['HTTP_HOST'] = '66.yunxnet.cn';
$_SERVER['SERVER_PORT'] = '443';
$_SERVER['REQUEST_SCHEME'] = 'https';

require CMF_ROOT . "vendor/thinkphp/base.php";

$app = \think\Container::get("app", [APP_PATH]);
$app->initialize();

$config = require CMF_ROOT . "app/config/database.php";
$pdo = new PDO("mysql:host=" . $config["hostname"] . ";dbname=" . $config["database"], $config["username"], $config["password"]);
$news = $pdo->query("SELECT id, title, push_time FROM shd_news_menu WHERE hidden = 0 ORDER BY id DESC LIMIT 5")->fetchAll(PDO::FETCH_ASSOC);

$groups = [
    ["id" => 20, "groupname" => "香港CN2特价1区", "count" => 1],
    ["id" => 42, "groupname" => "香港CN2特价2区", "count" => 2],
    ["id" => 10, "groupname" => "美国高防云", "count" => 1]
];

$vars = [
    "Title" => "会员中心控制台",
    "TplName" => "clientarea",
    "Ver" => "202609291930",
    "Setting" => [
        "company_name" => "云信网络",
        "web_logo" => "/upload/logo.png",
        "web_jump_url" => "https://66.yunxnet.cn",
        "unread_num" => 2,
        "certifi_open" => 1,
    ],
    "Userinfo" => [
        "user" => [
            "id" => 1,
            "username" => "崔康毅",
            "email" => "2839273551@qq.com",
            "phonenumber" => "13273184758",
            "certifi" => ["status" => 1]
        ]
    ],
    "ClientArea" => [
        "index" => [
            "client" => ["credit" => "￥1280.00"],
            "invoice_unpaid" => "￥0.00",
            "intotal" => "￥3680.00",
            "ticket_count" => 1,
            "order_count" => 0,
            "host" => 4,
            "allow_recharge" => "1",
            "host_nav" => $groups,
            "news" => $news
        ]
    ],
    "Nav" => [
        ["name" => "控制台首页", "url" => "/clientarea", "fa_icon" => "bx bx-home-circle"],
        ["name" => "云服务器", "url" => "/service", "fa_icon" => "bx bx-server", "child" => [
            ["name" => "我的云服务器", "url" => "/service"],
            ["name" => "订购服务器", "url" => "/cart"]
        ]],
        ["name" => "财务中心", "url" => "/billing", "fa_icon" => "bx bx-wallet", "child" => [
            ["name" => "财务账单", "url" => "/billing"],
            ["name" => "在线充值", "url" => "/addfunds"],
            ["name" => "交易记录", "url" => "/transaction"]
        ]],
        ["name" => "工单客服", "url" => "/supporttickets", "fa_icon" => "bx bx-support", "child" => [
            ["name" => "我的工单", "url" => "/supporttickets"],
            ["name" => "提交工单", "url" => "/submitticket"]
        ]],
        ["name" => "安全中心", "url" => "/security", "fa_icon" => "bx bx-shield-quarter"],
        ["name" => "实名认证", "url" => "/verified", "fa_icon" => "bx bx-id-card"]
    ]
];

$view = $app->view;
$header = $view->fetch(CMF_ROOT . "public/themes/clientarea/ABCLOUD/header.tpl", $vars);
$body = $view->fetch(CMF_ROOT . "public/themes/clientarea/ABCLOUD/clientarea.tpl", $vars);
$footer = $view->fetch(CMF_ROOT . "public/themes/clientarea/ABCLOUD/footer.tpl", $vars);

echo $header . $body . $footer;
