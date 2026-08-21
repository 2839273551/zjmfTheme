<?php
/**
 * 数据库配置示例。
 *
 * 部署时复制为 database.php 并填写真实值。database.php 已被 Git 忽略，
 * 禁止将生产数据库信息或 authcode 提交到版本库。
 */

return [
    'type'              => 'mysql',
    'hostname'          => '127.0.0.1',
    'database'          => 'your_database',
    'username'          => 'your_database_user',
    'password'          => 'replace_with_a_secret',
    'hostport'          => '3306',
    'charset'           => 'utf8',
    'prefix'            => 'shd_',
    'authcode'          => 'replace_with_a_unique_random_value',
    'admin_application' => 'admin',
];

