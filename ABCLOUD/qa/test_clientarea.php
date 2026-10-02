<?php
if (($_SERVER["REMOTE_ADDR"] ?? "") !== "127.0.0.1") {
    http_response_code(403);
    exit("403");
}
define("APP_DEBUG", false);
define("URL_ROUTE_MUST", false);
define("CMF_ROOT", dirname(__DIR__) . "/");
define("CMF_DATA", CMF_ROOT . "data/");
define("DOWN_PATH", CMF_ROOT . "downloads/");
define("DOWN_PATH1", CMF_ROOT . "public/downloads/");
define("TICKET_DOWN_PATH", DOWN_PATH . "ticket/");
define("SUPPORT_DOWN_PATH", DOWN_PATH1 . "support/");
define("DATABASE_DOWN_PATH", DOWN_PATH . "database/");
define("UPLOAD_PATH", CMF_ROOT . "uploads/");
define("UPLOAD_DEFAULT", UPLOAD_PATH . "common/default/");
define("APP_PATH", CMF_ROOT . "app/");
define("WEB_ROOT", __DIR__ . "/");

require CMF_ROOT . "vendor/thinkphp/base.php";
$app = \think\Container::get("app", [APP_PATH]);
$app->initialize();

\think\facade\Session::init();
\think\facade\Session::set("uid", 1);
\think\facade\Session::set("userInfo", ["uid" => 1, "username" => "崔康毅", "phonenumber" => "13273184758"]);

try {
    $ctl = new \app\home\controller\ViewClientsController($app);
    $resp = $ctl->clientarea();
    if (is_object($resp) && method_exists($resp, "getContent")) {
        echo $resp->getContent();
    } else if (is_string($resp)) {
        echo $resp;
    } else {
        var_dump($resp);
    }
} catch (\Throwable $e) {
    echo "ERROR: " . $e->getMessage() . "\n" . $e->getTraceAsString();
}
