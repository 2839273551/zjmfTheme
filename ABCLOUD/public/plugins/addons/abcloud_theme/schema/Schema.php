<?php
namespace addons\abcloud_theme\schema;

use think\Db;

class Schema
{
    const VERSION = '1.0.0';
    const TABLES = [
        'carousel', 'feature', 'topnav', 'footernav', 'web_module', 'popup',
        'config', 'operation_log', 'resource'
    ];

    public static function ensure()
    {
        $prefix = (string) Db::getConfig('prefix');
        if (!preg_match('/^[A-Za-z0-9_]*$/', $prefix)) {
            throw new \RuntimeException('数据库表前缀格式不正确');
        }
        $sql = [
            'carousel' => "CREATE TABLE IF NOT EXISTS `{$prefix}abcloud_carousel` (`id` int unsigned NOT NULL AUTO_INCREMENT,`title` varchar(255) NOT NULL,`description` text,`media_type` varchar(16) NOT NULL DEFAULT 'image',`media_url` varchar(500) NOT NULL,`mobile_image_url` varchar(500) DEFAULT NULL,`desktop_image_url` varchar(500) DEFAULT NULL,`poster_url` varchar(500) DEFAULT NULL,`link_url` varchar(500) DEFAULT NULL,`label_text` varchar(100) DEFAULT NULL,`label_badge` varchar(50) DEFAULT NULL,`button_text` varchar(50) DEFAULT NULL,`sort_order` int NOT NULL DEFAULT 0,`status` tinyint NOT NULL DEFAULT 1,`time_limit` tinyint NOT NULL DEFAULT 0,`pc_theme` varchar(16) NOT NULL DEFAULT 'black',`mobile_theme` varchar(16) NOT NULL DEFAULT 'black',`text_visible` tinyint NOT NULL DEFAULT 1,`jump_type` varchar(16) NOT NULL DEFAULT 'custom',`jump_url` varchar(500) DEFAULT NULL,`new_tab` tinyint NOT NULL DEFAULT 0,`created_at` datetime NOT NULL,`updated_at` datetime DEFAULT NULL,PRIMARY KEY (`id`),KEY `idx_status_sort` (`status`,`sort_order`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            'feature' => "CREATE TABLE IF NOT EXISTS `{$prefix}abcloud_feature` (`id` int unsigned NOT NULL AUTO_INCREMENT,`title` varchar(100) NOT NULL,`description` varchar(255) DEFAULT NULL,`icon_url` varchar(500) NOT NULL,`link_url` varchar(500) NOT NULL,`sort_order` int NOT NULL DEFAULT 0,`status` tinyint NOT NULL DEFAULT 1,`created_at` datetime NOT NULL,`updated_at` datetime DEFAULT NULL,PRIMARY KEY (`id`),KEY `idx_status_sort` (`status`,`sort_order`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            'topnav' => "CREATE TABLE IF NOT EXISTS `{$prefix}abcloud_topnav` (`id` int unsigned NOT NULL AUTO_INCREMENT,`title` varchar(100) NOT NULL,`link_url` varchar(500) DEFAULT NULL,`parent_id` int NOT NULL DEFAULT 0,`sort_order` int NOT NULL DEFAULT 0,`status` tinyint NOT NULL DEFAULT 1,`menu_type` varchar(20) NOT NULL DEFAULT 'route',`recommended_tags` varchar(200) DEFAULT NULL,`menu_desc` varchar(500) DEFAULT NULL,`created_at` datetime NOT NULL,`updated_at` datetime DEFAULT NULL,PRIMARY KEY (`id`),KEY `idx_parent_status_sort` (`parent_id`,`status`,`sort_order`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            'footernav' => "CREATE TABLE IF NOT EXISTS `{$prefix}abcloud_footernav` (`id` int unsigned NOT NULL AUTO_INCREMENT,`category` varchar(50) NOT NULL,`title` varchar(100) NOT NULL,`description` varchar(255) DEFAULT NULL,`link_url` varchar(500) DEFAULT NULL,`icon_url` varchar(500) DEFAULT NULL,`sort_order` int NOT NULL DEFAULT 0,`status` tinyint NOT NULL DEFAULT 1,`created_at` datetime NOT NULL,`updated_at` datetime DEFAULT NULL,PRIMARY KEY (`id`),KEY `idx_category_status_sort` (`category`,`status`,`sort_order`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            'web_module' => "CREATE TABLE IF NOT EXISTS `{$prefix}abcloud_web_module` (`id` int unsigned NOT NULL AUTO_INCREMENT,`category` varchar(50) NOT NULL,`title` varchar(200) NOT NULL,`description` text,`link_url` varchar(500) DEFAULT NULL,`icon_url` varchar(500) DEFAULT NULL,`image_url` varchar(500) DEFAULT NULL,`sort_order` int NOT NULL DEFAULT 0,`status` tinyint NOT NULL DEFAULT 1,`created_at` datetime NOT NULL,`updated_at` datetime DEFAULT NULL,PRIMARY KEY (`id`),KEY `idx_category_status_sort` (`category`,`status`,`sort_order`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            'popup' => "CREATE TABLE IF NOT EXISTS `{$prefix}abcloud_popup` (`id` int unsigned NOT NULL AUTO_INCREMENT,`title` varchar(255) NOT NULL,`content` mediumtext,`link_url` varchar(500) DEFAULT NULL,`button_text` varchar(50) DEFAULT NULL,`show_type` varchar(16) NOT NULL DEFAULT 'always',`sort_order` int NOT NULL DEFAULT 0,`status` tinyint NOT NULL DEFAULT 1,`created_at` datetime NOT NULL,`updated_at` datetime DEFAULT NULL,PRIMARY KEY (`id`),KEY `idx_status` (`status`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            'config' => "CREATE TABLE IF NOT EXISTS `{$prefix}abcloud_config` (`id` int unsigned NOT NULL AUTO_INCREMENT,`key` varchar(100) NOT NULL,`value` text,`updated_at` datetime DEFAULT NULL,PRIMARY KEY (`id`),UNIQUE KEY `uk_key` (`key`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            'operation_log' => "CREATE TABLE IF NOT EXISTS `{$prefix}abcloud_operation_log` (`id` int unsigned NOT NULL AUTO_INCREMENT,`admin_id` int DEFAULT NULL,`admin_name` varchar(100) DEFAULT NULL,`action` varchar(50) NOT NULL,`module` varchar(50) DEFAULT NULL,`detail` text,`ip` varchar(50) DEFAULT NULL,`user_agent` varchar(500) DEFAULT NULL,`created_at` datetime NOT NULL,PRIMARY KEY (`id`),KEY `idx_created_at` (`created_at`),KEY `idx_module` (`module`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            'resource' => "CREATE TABLE IF NOT EXISTS `{$prefix}abcloud_resource` (`id` int unsigned NOT NULL AUTO_INCREMENT,`parent_id` int NOT NULL DEFAULT 0,`name` varchar(255) NOT NULL,`kind` varchar(16) NOT NULL DEFAULT 'file',`path` varchar(500) DEFAULT NULL,`mime` varchar(120) DEFAULT NULL,`size` bigint unsigned NOT NULL DEFAULT 0,`created_at` datetime NOT NULL,`updated_at` datetime DEFAULT NULL,PRIMARY KEY (`id`),KEY `idx_parent` (`parent_id`),UNIQUE KEY `uk_path` (`path`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
        ];
        foreach ($sql as $statement) Db::execute($statement);
        $version = Db::name('abcloud_config')->where('key', '__schema_version')->find();
        if (!$version) Db::name('abcloud_config')->insert(['key' => '__schema_version', 'value' => self::VERSION, 'updated_at' => date('Y-m-d H:i:s')]);
        return true;
    }
}
