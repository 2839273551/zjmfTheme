<?php
namespace addons\abcloud_theme\logic;

use think\Db;

class Repository
{
    const MAP = ['carousel'=>'carousel','feature'=>'feature','topnav'=>'topnav','footernav'=>'footernav','web_module'=>'web_module','popup'=>'popup'];
    const PUBLIC_CONFIG_KEYS = [
        'carousel_height', 'switch_effect', 'carousel_speed', 'progress_height',
        'progress_bar', 'video_zoom', 'error_image', 'site_name', 'site_keywords',
        'site_description', 'service_phone', 'service_email', 'company_intro', 'official_website_logo'
    ];
    public static function table($module)
    {
        if (!isset(self::MAP[$module])) throw new \InvalidArgumentException('模块不支持');
        return 'abcloud_' . self::MAP[$module];
    }
    public static function list($module, $enabled = false)
    {
        $query = Db::name(self::table($module));
        if ($enabled) $query->where('status', 1);
        if ($module === 'topnav') return $query->order('parent_id asc,sort_order asc,id asc')->select();
        if ($module === 'popup') return $query->order('id desc')->select();
        if ($module === 'footernav' || $module === 'web_module') return $query->order('category asc,sort_order asc,id asc')->select();
        return $query->order('sort_order asc,id asc')->select();
    }
    public static function item($module, $id)
    {
        return Db::name(self::table($module))->where('id', (int) $id)->find();
    }
    public static function save($module, $data, $id = 0)
    {
        $data['updated_at'] = date('Y-m-d H:i:s');
        if ($id) { Db::name(self::table($module))->where('id', (int) $id)->update($data); return (int) $id; }
        $data['created_at'] = date('Y-m-d H:i:s');
        return (int) Db::name(self::table($module))->insertGetId($data);
    }
    public static function delete($module, $id)
    {
        $id = (int) $id;
        if ($module === 'topnav') {
            $ids = self::descendants($id);
            $ids[] = $id;
            return Db::name(self::table($module))->whereIn('id', array_unique($ids))->delete();
        }
        return Db::name(self::table($module))->where('id', $id)->delete();
    }
    public static function descendants($id, $depth = 0)
    {
        if ($depth > 32) throw new \RuntimeException('导航树深度超过限制');
        $rows = Db::name('abcloud_topnav')->where('parent_id', (int) $id)->column('id');
        $result = [];
        foreach ($rows as $child) { $result[] = (int) $child; $result = array_merge($result, self::descendants($child, $depth + 1)); }
        return $result;
    }
    public static function configRows()
    {
        $rows = Db::name('abcloud_config')->order('key asc')->select();
        $result = [];
        foreach ($rows as $row) if (strpos($row['key'], '__') !== 0) $result[] = $row;
        return $result;
    }
    public static function configMap()
    {
        $map = [];
        foreach (self::configRows() as $row) $map[$row['key']] = $row['value'];
        return $map;
    }
    public static function publicConfig(array $config)
    {
        return array_intersect_key($config, array_fill_keys(self::PUBLIC_CONFIG_KEYS, true));
    }
    public static function resourceReferences($resources)
    {
        $paths = [];
        foreach ($resources as $resource) {
            if (($resource['kind'] ?? '') === 'file' && !empty($resource['path'])) $paths[] = rawurldecode($resource['path']);
        }
        if (!$paths) return false;
        $records = self::configRows();
        foreach (self::MAP as $module => $table) {
            foreach (self::list($module) as $row) $records[] = $row;
        }
        foreach ($records as $record) {
            foreach ($record as $value) {
                if (!is_string($value)) continue;
                $value = rawurldecode(html_entity_decode(str_replace('\\/', '/', $value), ENT_QUOTES, 'UTF-8'));
                foreach ($paths as $path) if (strpos($value, $path) !== false) return true;
            }
        }
        return false;
    }
    public static function setConfig($key, $value)
    {
        $key = trim((string) $key);
        if (!preg_match('/^[A-Za-z0-9_.-]{1,100}$/', $key)) throw new \InvalidArgumentException('配置键无效');
        $row = Db::name('abcloud_config')->where('key', $key)->find();
        if ($row) return Db::name('abcloud_config')->where('key', $key)->update(['value'=>(string)$value,'updated_at'=>date('Y-m-d H:i:s')]);
        return Db::name('abcloud_config')->insert(['key'=>$key,'value'=>(string)$value,'updated_at'=>date('Y-m-d H:i:s')]);
    }
    public static function counts()
    {
        $out = [];
        foreach (self::MAP as $module => $table) $out[$module] = (int) Db::name('abcloud_'.$table)->count();
        $out['resources'] = (int) Db::name('abcloud_resource')->count();
        return $out;
    }

    public static function seedDefaults()
    {
        Db::startTrans();
        try {
            if (Db::name('abcloud_config')->where('key', '__defaults_initialized')->find()) {
                Db::commit();
                return true;
            }
            $freshInstall = count(self::configRows()) === 0;
            foreach (self::counts() as $count) if ($count > 0) $freshInstall = false;
            if (Db::name('abcloud_operation_log')->count()) $freshInstall = false;
            self::setConfig('__defaults_initialized', '1');
            self::initializeDefaults($freshInstall);
            Db::commit();
            return true;
        } catch (\Throwable $error) {
            Db::rollback();
            throw $error;
        }
    }

    private static function initializeDefaults($freshInstall)
    {
        $defaultConfigs = [
            'carousel_height' => '600px',
            'switch_effect' => 'default',
            'carousel_speed' => '5000',
            'progress_height' => '42px',
            'progress_bar' => '4px',
            'video_zoom' => '35px',
            'error_image' => '/plugins/addons/abcloud_theme/assets/img/404.png',
            'site_name' => 'ABCLOUD',
            'site_keywords' => '云计算,云服务器,服务器租用,高防服务器,数据中心',
            'site_description' => '',
            'service_phone' => '',
            'service_email' => '',
            'company_intro' => '',
            'official_website_logo' => '',
            'managed_carousel' => '0',
            'managed_feature' => '1',
            'managed_topnav' => '1',
            'managed_footernav' => '1',
            'managed_popup' => '1',
            'managed_web_module' => '1'
        ];
        try {
            $sys = Db::name('configuration')->whereIn('setting', ['company_name','main_phone','company_email','logo_url_home'])->column('value', 'setting');
            if (!empty($sys['company_name'])) $defaultConfigs['site_name'] = $sys['company_name'];
            if (!empty($sys['main_phone'])) $defaultConfigs['service_phone'] = $sys['main_phone'];
            if (!empty($sys['company_email'])) $defaultConfigs['service_email'] = $sys['company_email'];
            if (!empty($sys['logo_url_home']) && Security::url($sys['logo_url_home']) !== null && strpos($sys['logo_url_home'], '/themes/') === false) $defaultConfigs['official_website_logo'] = $sys['logo_url_home'];
        } catch (\Throwable $e) {}

        if (!$freshInstall) {
            foreach (self::MAP as $module => $table) $defaultConfigs['managed_'.$module] = Db::name('abcloud_'.$table)->count() ? '1' : '0';
        }
        foreach ($defaultConfigs as $key => $value) {
            $row = Db::name('abcloud_config')->where('key', $key)->find();
            if (!$row) {
                Db::name('abcloud_config')->insert(['key' => $key, 'value' => (string)$value, 'updated_at' => date('Y-m-d H:i:s')]);
            }
        }
        if (!$freshInstall) return true;

        if ((int)Db::name('abcloud_feature')->count() === 0) {
            $now = date('Y-m-d H:i:s');
            Db::name('abcloud_feature')->insertAll([
                ['title'=>'云产品', 'description'=>'查看可购买的产品与服务', 'icon_url'=>'/plugins/addons/abcloud_theme/assets/img/feature-1.png', 'link_url'=>'/cart', 'sort_order'=>1, 'status'=>1, 'created_at'=>$now],
                ['title'=>'客户中心', 'description'=>'管理账户与服务', 'icon_url'=>'/plugins/addons/abcloud_theme/assets/img/feature-2.png', 'link_url'=>'/clientarea', 'sort_order'=>2, 'status'=>1, 'created_at'=>$now],
                ['title'=>'工单支持', 'description'=>'提交与查询服务工单', 'icon_url'=>'/plugins/addons/abcloud_theme/assets/img/feature-3.png', 'link_url'=>'/supporttickets', 'sort_order'=>3, 'status'=>1, 'created_at'=>$now],
                ['title'=>'账单管理', 'description'=>'查看账户账单', 'icon_url'=>'/plugins/addons/abcloud_theme/assets/img/feature-4.png', 'link_url'=>'/invoices', 'sort_order'=>4, 'status'=>1, 'created_at'=>$now],
                ['title'=>'账户安全', 'description'=>'管理账户安全设置', 'icon_url'=>'/plugins/addons/abcloud_theme/assets/img/feature-5.png', 'link_url'=>'/security', 'sort_order'=>5, 'status'=>1, 'created_at'=>$now]
            ]);
        }

        if ((int)Db::name('abcloud_topnav')->count() === 0) {
            $now = date('Y-m-d H:i:s');
            $nav1 = Db::name('abcloud_topnav')->insertGetId(['title'=>'首页', 'link_url'=>'/', 'parent_id'=>0, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'created_at'=>$now]);
            $nav2 = Db::name('abcloud_topnav')->insertGetId(['title'=>'产品与服务', 'link_url'=>'/', 'parent_id'=>0, 'sort_order'=>2, 'status'=>1, 'menu_type'=>'product', 'recommended_tags'=>'["HOT"]', 'created_at'=>$now]);
            $nav3 = Db::name('abcloud_topnav')->insertGetId(['title'=>'解决方案', 'link_url'=>'#industry-solutions', 'parent_id'=>0, 'sort_order'=>3, 'status'=>1, 'menu_type'=>'solution', 'created_at'=>$now]);
            $nav4 = Db::name('abcloud_topnav')->insertGetId(['title'=>'生态合作', 'link_url'=>'#partner-container', 'parent_id'=>0, 'sort_order'=>4, 'status'=>1, 'menu_type'=>'mega', 'created_at'=>$now]);
            $nav5 = Db::name('abcloud_topnav')->insertGetId(['title'=>'应用市场', 'link_url'=>'#cloud-market', 'parent_id'=>0, 'sort_order'=>5, 'status'=>1, 'menu_type'=>'mega', 'recommended_tags'=>'["NEW"]', 'created_at'=>$now]);
            $nav6 = Db::name('abcloud_topnav')->insertGetId(['title'=>'支持与服务', 'link_url'=>'#support', 'parent_id'=>0, 'sort_order'=>6, 'status'=>1, 'menu_type'=>'mega', 'created_at'=>$now]);
            $nav7 = Db::name('abcloud_topnav')->insertGetId(['title'=>'关于我们', 'link_url'=>'#why-choose-us', 'parent_id'=>0, 'sort_order'=>7, 'status'=>1, 'menu_type'=>'mega', 'created_at'=>$now]);

            $sub3_1 = Db::name('abcloud_topnav')->insertGetId(['title'=>'行业解决方案', 'link_url'=>'#industry-solutions', 'parent_id'=>$nav3, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'created_at'=>$now]);
            $sub3_2 = Db::name('abcloud_topnav')->insertGetId(['title'=>'通用解决方案', 'link_url'=>'#industry-solutions', 'parent_id'=>$nav3, 'sort_order'=>2, 'status'=>1, 'menu_type'=>'route', 'created_at'=>$now]);
            Db::name('abcloud_topnav')->insertAll([
                ['title'=>'企业级网站', 'link_url'=>'#industry-solutions', 'parent_id'=>$sub3_1, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'助您打造专业、高效的品牌官网', 'created_at'=>$now],
                ['title'=>'游戏云', 'link_url'=>'#industry-solutions', 'parent_id'=>$sub3_1, 'sort_order'=>2, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'高效稳定的游戏云，提升玩家体验', 'created_at'=>$now],
                ['title'=>'移动云', 'link_url'=>'#industry-solutions', 'parent_id'=>$sub3_1, 'sort_order'=>3, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'一站式移动云，助力企业无缝拓展', 'created_at'=>$now],
                ['title'=>'电商云', 'link_url'=>'#industry-solutions', 'parent_id'=>$sub3_1, 'sort_order'=>4, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'轻松打造线上商城，实现数字化经营', 'created_at'=>$now]
            ]);
            Db::name('abcloud_topnav')->insertAll([
                ['title'=>'云存储方案', 'link_url'=>'#industry-solutions', 'parent_id'=>$sub3_2, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'海量云存储服务，数据安全按需付费', 'created_at'=>$now],
                ['title'=>'CDN加速方案', 'link_url'=>'#industry-solutions', 'parent_id'=>$sub3_2, 'sort_order'=>2, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'全球CDN加速，提升访问速度降低延迟', 'created_at'=>$now]
            ]);

            $sub4_1 = Db::name('abcloud_topnav')->insertGetId(['title'=>'合作伙伴', 'link_url'=>'#partner-container', 'parent_id'=>$nav4, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'created_at'=>$now]);
            $sub4_2 = Db::name('abcloud_topnav')->insertGetId(['title'=>'代理推广', 'link_url'=>'/', 'parent_id'=>$nav4, 'sort_order'=>2, 'status'=>1, 'menu_type'=>'route', 'created_at'=>$now]);
            Db::name('abcloud_topnav')->insertAll([
                ['title'=>'百站赞助公益计划', 'link_url'=>'/', 'parent_id'=>$sub4_1, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'赞助百个站点服务器资源，支持开发者与站长', 'created_at'=>$now],
                ['title'=>'技术合作伙伴', 'link_url'=>'/', 'parent_id'=>$sub4_1, 'sort_order'=>2, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'共同发展，实现互利共赢', 'created_at'=>$now],
                ['title'=>'推广返利', 'link_url'=>'/', 'parent_id'=>$sub4_2, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'享受推广优惠，轻松赚取额外收益', 'created_at'=>$now]
            ]);

            $sub5_1 = Db::name('abcloud_topnav')->insertGetId(['title'=>'操作系统', 'link_url'=>'#cloud-market', 'parent_id'=>$nav5, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'created_at'=>$now]);
            $sub5_2 = Db::name('abcloud_topnav')->insertGetId(['title'=>'应用软件', 'link_url'=>'#cloud-market', 'parent_id'=>$nav5, 'sort_order'=>2, 'status'=>1, 'menu_type'=>'route', 'created_at'=>$now]);
            Db::name('abcloud_topnav')->insertAll([
                ['title'=>'Linux系统', 'link_url'=>'#cloud-market', 'parent_id'=>$sub5_1, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'主流Linux发行版，一键秒级部署', 'created_at'=>$now],
                ['title'=>'Windows系统', 'link_url'=>'#cloud-market', 'parent_id'=>$sub5_1, 'sort_order'=>2, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'Windows Server正版镜像，稳定可靠', 'created_at'=>$now],
                ['title'=>'宝塔面板', 'link_url'=>'#cloud-market', 'parent_id'=>$sub5_2, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'强大的服务器运维管理面板，简单易用', 'created_at'=>$now]
            ]);

            $sub6_1 = Db::name('abcloud_topnav')->insertGetId(['title'=>'帮助中心', 'link_url'=>'#support', 'parent_id'=>$nav6, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'created_at'=>$now]);
            $sub6_2 = Db::name('abcloud_topnav')->insertGetId(['title'=>'服务支持', 'link_url'=>'#support', 'parent_id'=>$nav6, 'sort_order'=>2, 'status'=>1, 'menu_type'=>'route', 'created_at'=>$now]);
            Db::name('abcloud_topnav')->insertAll([
                ['title'=>'帮助文档', 'link_url'=>'/knowledgebase', 'parent_id'=>$sub6_1, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'详细的使用指南和常见问题解答', 'created_at'=>$now],
                ['title'=>'最新公告', 'link_url'=>'/announcements', 'parent_id'=>$sub6_1, 'sort_order'=>2, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'系统维护与活动通知', 'created_at'=>$now],
                ['title'=>'提交工单', 'link_url'=>'/supporttickets', 'parent_id'=>$sub6_2, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'遇到技术或业务问题，提交工单快速响应', 'created_at'=>$now],
                ['title'=>'在线客服', 'link_url'=>'/', 'parent_id'=>$sub6_2, 'sort_order'=>2, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'全天候客服咨询与技术支持', 'created_at'=>$now]
            ]);

            $sub7_1 = Db::name('abcloud_topnav')->insertGetId(['title'=>'公司介绍', 'link_url'=>'#why-choose-us', 'parent_id'=>$nav7, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'created_at'=>$now]);
            $sub7_2 = Db::name('abcloud_topnav')->insertGetId(['title'=>'新闻动态', 'link_url'=>'/announcements', 'parent_id'=>$nav7, 'sort_order'=>2, 'status'=>1, 'menu_type'=>'route', 'created_at'=>$now]);
            Db::name('abcloud_topnav')->insertAll([
                ['title'=>'公司简介', 'link_url'=>'#why-choose-us', 'parent_id'=>$sub7_1, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'了解我们的团队、基础设施与使命', 'created_at'=>$now],
                ['title'=>'行业新闻', 'link_url'=>'/announcements', 'parent_id'=>$sub7_2, 'sort_order'=>1, 'status'=>1, 'menu_type'=>'route', 'menu_desc'=>'云计算与数据中心行业动态资讯', 'created_at'=>$now]
            ]);
        }

        if ((int)Db::name('abcloud_footernav')->count() === 0) {
            $now = date('Y-m-d H:i:s');
            Db::name('abcloud_footernav')->insertAll([
                ['category'=>'服务指南', 'title'=>'安全中心', 'description'=>'安全防护', 'link_url'=>'/', 'sort_order'=>1, 'status'=>1, 'created_at'=>$now],
                ['category'=>'服务指南', 'title'=>'实名认证', 'description'=>'账号认证', 'link_url'=>'/clientarea', 'sort_order'=>2, 'status'=>1, 'created_at'=>$now],
                ['category'=>'服务指南', 'title'=>'API管理', 'description'=>'开发者接口', 'link_url'=>'/clientarea', 'sort_order'=>3, 'status'=>1, 'created_at'=>$now],
                ['category'=>'服务指南', 'title'=>'提交工单', 'description'=>'售后支持', 'link_url'=>'/supporttickets', 'sort_order'=>4, 'status'=>1, 'created_at'=>$now],
                ['category'=>'服务指南', 'title'=>'服务条款', 'description'=>'用户协议', 'link_url'=>'/', 'sort_order'=>5, 'status'=>1, 'created_at'=>$now],
                ['category'=>'账户服务', 'title'=>'个人资料', 'description'=>'个人信息', 'link_url'=>'/clientarea', 'sort_order'=>1, 'status'=>1, 'created_at'=>$now],
                ['category'=>'账户服务', 'title'=>'我的产品', 'description'=>'服务器与服务', 'link_url'=>'/clientarea', 'sort_order'=>2, 'status'=>1, 'created_at'=>$now],
                ['category'=>'账户服务', 'title'=>'财务账单', 'description'=>'账单与充值', 'link_url'=>'/clientarea', 'sort_order'=>3, 'status'=>1, 'created_at'=>$now],
                ['category'=>'账户服务', 'title'=>'消费明细', 'description'=>'流水记录', 'link_url'=>'/clientarea', 'sort_order'=>4, 'status'=>1, 'created_at'=>$now],
                ['category'=>'帮助中心', 'title'=>'新闻动态', 'description'=>'行业资讯', 'link_url'=>'/announcements', 'sort_order'=>1, 'status'=>1, 'created_at'=>$now],
                ['category'=>'帮助中心', 'title'=>'系统公告', 'description'=>'重要通知', 'link_url'=>'/announcements', 'sort_order'=>2, 'status'=>1, 'created_at'=>$now],
                ['category'=>'帮助中心', 'title'=>'知识库文档', 'description'=>'使用手册', 'link_url'=>'/knowledgebase', 'sort_order'=>3, 'status'=>1, 'created_at'=>$now],
                ['category'=>'帮助中心', 'title'=>'常见问题', 'description'=>'解答汇总', 'link_url'=>'/knowledgebase', 'sort_order'=>4, 'status'=>1, 'created_at'=>$now],
                ['category'=>'关于我们', 'title'=>'公司简介', 'description'=>'关于平台', 'link_url'=>'#why-choose-us', 'sort_order'=>1, 'status'=>1, 'created_at'=>$now],
                ['category'=>'关于我们', 'title'=>'联系我们', 'description'=>'客服支持', 'link_url'=>'/', 'sort_order'=>2, 'status'=>1, 'created_at'=>$now],
                ['category'=>'关于我们', 'title'=>'资质荣誉', 'description'=>'企业认证', 'link_url'=>'/', 'sort_order'=>3, 'status'=>1, 'created_at'=>$now],
                ['category'=>'关于我们', 'title'=>'合作伙伴', 'description'=>'生态共赢', 'link_url'=>'#partner-container', 'sort_order'=>4, 'status'=>1, 'created_at'=>$now]
            ]);
        }

        if ((int)Db::name('abcloud_popup')->count() === 0) {
            $now = date('Y-m-d H:i:s');
            Db::name('abcloud_popup')->insert([
                'title' => '网站通知',
                'content' => '<p>欢迎访问本站。如需服务支持，请提交工单联系我们。</p>',
                'link_url' => '/supporttickets',
                'button_text' => '了解详情',
                'show_type' => 'once',
                'sort_order' => 1,
                'status' => 0,
                'created_at' => $now
            ]);
        }

        if ((int)Db::name('abcloud_web_module')->count() === 0) {
            $now = date('Y-m-d H:i:s');
            Db::name('abcloud_web_module')->insertAll([
                ['category'=>'顶部公告', 'title'=>'系统公告', 'description'=>'欢迎访问本站。', 'link_url'=>'', 'icon_url'=>'', 'image_url'=>'', 'sort_order'=>1, 'status'=>0, 'created_at'=>$now],
                ['category'=>'侧边导航', 'title'=>'客服机器人', 'description'=>'在线咨询', 'link_url'=>'', 'icon_url'=>'', 'image_url'=>'/plugins/addons/abcloud_theme/assets/img/service.gif', 'sort_order'=>1, 'status'=>0, 'created_at'=>$now],
                ['category'=>'侧边导航', 'title'=>'QQ客服', 'description'=>'', 'link_url'=>'', 'icon_url'=>'', 'image_url'=>'', 'sort_order'=>2, 'status'=>0, 'created_at'=>$now],
                ['category'=>'侧边导航', 'title'=>'工单服务', 'description'=>'售后问题提交工单，快速响应解决。', 'link_url'=>'/supporttickets', 'icon_url'=>'', 'image_url'=>'', 'sort_order'=>3, 'status'=>1, 'created_at'=>$now],
                ['category'=>'侧边导航', 'title'=>'微信客服', 'description'=>'', 'link_url'=>'', 'icon_url'=>'', 'image_url'=>'', 'sort_order'=>4, 'status'=>0, 'created_at'=>$now]
            ]);
        }
        return true;
    }
}
