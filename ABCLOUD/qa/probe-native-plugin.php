<?php
// Read-only loader probe for the 121 test host. Does not install the plugin.
if (PHP_SAPI !== 'cli') exit(2);
define('APP_DEBUG', false);
define('CMF_ROOT', '/www/wwwroot/idc.yunxnet.cn/');
define('CMF_DATA', CMF_ROOT . 'data/');
define('WEB_ROOT', CMF_ROOT . 'public/');
define('APP_PATH', CMF_ROOT . 'app/');
define('RUNTIME_PATH', CMF_ROOT . 'data/runtime_cli/');
require CMF_ROOT . 'vendor/thinkphp/base.php';

try {
    \think\Container::get('app', [APP_PATH])->initialize();
    require_once CMF_ROOT . 'vendor/thinkcmf/cmf/src/common.php';
    require_once CMF_ROOT . 'vendor/thinkcmf/cmf/src/controller/BaseController.php';
    $pluginClass = 'addons\\abcloud_theme\\AbcloudThemePlugin';
    $adminClass = 'addons\\abcloud_theme\\controller\\AdminIndexController';
    $publicClass = 'addons\\abcloud_theme\\controller\\PublicController';
    foreach ([$pluginClass, $adminClass, $publicClass] as $class) {
        if (!class_exists($class)) throw new RuntimeException('class missing: ' . $class);
    }
    $plugin = new $pluginClass();
    if (!$plugin->checkInfo() || empty($plugin->hasAdmin)) throw new RuntimeException('plugin metadata rejected');
    if (!function_exists('shd_addon_url')) throw new RuntimeException('native URL helper missing');
    $url = shd_addon_url('AbcloudTheme://AdminIndex/index');
    if (!is_string($url) || strpos($url, '_plugin=') === false) throw new RuntimeException('native admin URL rejected');
    echo "native-plugin-loader-ok\n";
} catch (Throwable $error) {
    fwrite(STDERR, $error->getMessage() . "\n");
    exit(1);
}
