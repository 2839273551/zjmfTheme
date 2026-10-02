<?php
namespace addons\abcloud_theme;

use addons\abcloud_theme\schema\Schema;
use addons\abcloud_theme\logic\Repository;
use app\admin\lib\Plugin;

class AbcloudThemePlugin extends Plugin
{
    public $hasAdmin = true;
    public $info = [
        'name'=>'AbcloudTheme','title'=>'ABCLOUD 首页内容管理','description'=>'ABCLOUD 原生首页内容与资源管理插件','status'=>1,'author'=>'ABCLOUD','version'=>'1.0.1','module'=>'addons',
        'lang'=>['chinese'=>'ABCLOUD 首页内容管理','chinese_tw'=>'ABCLOUD 首頁內容管理','english'=>'ABCLOUD Theme Content']
    ];
    public function install(){ Schema::ensure(); Repository::seedDefaults(); return true; }
    public function uninstall(){ return true; }
}
