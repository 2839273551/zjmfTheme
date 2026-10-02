<?php
// Read-only metadata shape and aggregate counts, with no account values.
if (PHP_SAPI !== 'cli') exit(2);
$config = require '/www/wwwroot/idc.yunxnet.cn/app/config/database.php';
$prefix = (string) $config['prefix'];
if (!preg_match('/^[A-Za-z0-9_]+$/', $prefix)) exit(2);
$dsn = 'mysql:host=' . $config['hostname'] . ';port=' . (int) ($config['hostport'] ?? 3306)
    . ';dbname=' . $config['database'] . ';charset=utf8mb4';
$pdo = new PDO($dsn, $config['username'], $config['password'], [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
foreach (['plugin', 'menu', 'auth_rule'] as $suffix) {
    $table = $prefix . $suffix;
    $columns = [];
    foreach ($pdo->query("SHOW COLUMNS FROM `$table`", PDO::FETCH_ASSOC) as $row) $columns[] = $row['Field'];
    echo "$table columns=" . implode(',', $columns) . "\n";
}
$pluginTable = $prefix . 'plugin';
$names = $pdo->query("SELECT `name` FROM `$pluginTable` WHERE `status` = 1 LIMIT 20")->fetchAll(PDO::FETCH_COLUMN);
echo 'enabled-plugin-count=' . count($names) . "\n";
foreach (array_slice($names, 0, 8) as $name) {
    echo 'enabled-plugin=' . preg_replace('/[^A-Za-z0-9_]/', '', $name) . "\n";
}
$ruleTable = $prefix . 'auth_rule';
$query = $pdo->prepare("SELECT COUNT(*) FROM `$ruleTable` WHERE `app` = ?");
foreach (array_unique(array_merge(array_slice($names, 0, 8), ['AbcloudTheme', 'DemoStyle'])) as $name) {
    $query->execute(['plugin/' . $name]);
    echo 'auth-rule-count-for-' . preg_replace('/[^A-Za-z0-9_]/', '', $name) . '=' . (int) $query->fetchColumn() . "\n";
}
foreach ($pdo->query("SELECT `app`, COUNT(*) AS `n` FROM `$ruleTable` WHERE `app` LIKE 'plugin/%' GROUP BY `app` LIMIT 20", PDO::FETCH_ASSOC) as $row) {
    echo 'plugin-app=' . preg_replace('/[^A-Za-z0-9_\/-]/', '', $row['app']) . ' rules=' . (int) $row['n'] . "\n";
}
