<?php
// Prints table and column names only; no account records or credentials.
if (PHP_SAPI !== 'cli') exit(2);
$config = require '/www/wwwroot/idc.yunxnet.cn/app/config/database.php';
$dsn = 'mysql:host=' . $config['hostname'] . ';port=' . (int) ($config['hostport'] ?? 3306)
    . ';dbname=' . $config['database'] . ';charset=utf8mb4';
$pdo = new PDO($dsn, $config['username'], $config['password'], [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
foreach ($pdo->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN) as $table) {
    if (!preg_match('/(?:admin|user)/i', $table)) continue;
    if (!preg_match('/^[A-Za-z0-9_]+$/', $table)) continue;
    $columns = [];
    foreach ($pdo->query("SHOW COLUMNS FROM `$table`")->fetchAll(PDO::FETCH_ASSOC) as $column) $columns[] = $column['Field'];
    echo $table . ': ' . implode(', ', $columns) . "\n";
}
