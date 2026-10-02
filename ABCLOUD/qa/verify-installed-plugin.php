<?php
// Read-only native installation check on 121. Never prints configuration values.
if (PHP_SAPI !== 'cli') exit(2);
$config = require '/www/wwwroot/idc.yunxnet.cn/app/config/database.php';
$prefix = (string) ($config['prefix'] ?? '');
if (!preg_match('/^[A-Za-z0-9_]+$/', $prefix)) exit(2);
$dsn = 'mysql:host=' . $config['hostname'] . ';port=' . (int) ($config['hostport'] ?? 3306)
    . ';dbname=' . $config['database'] . ';charset=utf8mb4';
$pdo = new PDO($dsn, $config['username'], $config['password'], [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
$tables = $pdo->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN);
$expected = ['carousel', 'feature', 'topnav', 'footernav', 'web_module', 'popup', 'config', 'operation_log', 'resource'];
foreach ($expected as $name) {
    $table = $prefix . 'abcloud_' . $name;
    if (!in_array($table, $tables, true)) {
        fwrite(STDERR, "missing table: $table\n");
        exit(1);
    }
    $count = (int) $pdo->query("SELECT COUNT(*) FROM `$table`")->fetchColumn();
    echo "$table rows=$count\n";
}
$statement = $pdo->prepare("SELECT COUNT(*) FROM `{$prefix}plugin` WHERE `name` = ? AND `status` = 1");
$statement->execute(['AbcloudTheme']);
$installed = (int) $statement->fetchColumn();
echo "enabled-plugin-record=$installed\n";
if ($installed !== 1) exit(1);

foreach (['menu', 'auth_rule', 'hook_plugin'] as $name) {
    $table = $prefix . $name;
    if (!in_array($table, $tables, true)) continue;
    $count = 0;
    foreach ($pdo->query("SELECT * FROM `$table`", PDO::FETCH_ASSOC) as $row) {
        foreach ($row as $value) {
            if (is_scalar($value) && stripos((string) $value, 'AbcloudTheme') !== false) {
                $count++;
                break;
            }
        }
    }
    echo "$table plugin-related-rows=$count\n";
}
