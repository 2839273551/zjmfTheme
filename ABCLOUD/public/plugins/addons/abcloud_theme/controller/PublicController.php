<?php
namespace addons\abcloud_theme\controller;

use addons\abcloud_theme\logic\Repository;

class PublicController
{
    public function index()
    {
        $enabled = function($module){ return Repository::list($module, true); };
        $config = Repository::configMap();
        $managed = [];
        foreach (['carousel','feature','topnav','footernav','web_module','popup'] as $module) $managed[$module] = !empty($config['managed_'.$module]);
        return json(['code'=>0,'data'=>[
            'config'=>Repository::publicConfig($config),'topNav'=>$enabled('topnav'),'features'=>$enabled('feature'),'footerNav'=>$enabled('footernav'),'modules'=>$enabled('web_module'),'carousel'=>$enabled('carousel'),'popup'=>$enabled('popup'),'managed'=>$managed
        ]]);
    }
}
