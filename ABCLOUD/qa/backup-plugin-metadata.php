<?php
// Runs on the 121 test host from a private staging directory.
if (PHP_SAPI !== 'cli' || ($argc ?? 0) !== 2) {
    fwrite(STDERR, "usage: php backup-plugin-metadata.php BACKUP_DIR\n");
    exit(2);
}

$siteRoot = '/www/wwwroot/idc.yunxnet.cn';
$backupParent = realpath($siteRoot . '/.codex-backups');
$backupDir = realpath($argv[1]);
if (!$backupParent || !$backupDir || strpos($backupDir, $backupParent . DIRECTORY_SEPARATOR) !== 0) {
    fwrite(STDERR, "backup path is outside the approved directory\n");
    exit(2);
}

$config = require $siteRoot . '/app/config/database.php';
$prefix = (string) ($config['prefix'] ?? '');
if (!preg_match('/^[A-Za-z0-9_]+$/', $prefix)) {
    fwrite(STDERR, "invalid table prefix\n");
    exit(2);
}

$port = (int) ($config['hostport'] ?? 3306);
$dsn = 'mysql:host=' . $config['hostname'] . ';port=' . $port . ';dbname=' . $config['database'] . ';charset=utf8mb4';
$pdo = new PDO($dsn, $config['username'], $config['password'], [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
$existing = $pdo->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN);
$wanted = ['plugin', 'admin_menu', 'auth_rule', 'hook_plugin', 'menu', 'auth_access', 'abcloud_config'];
$tables = [];
foreach ($wanted as $name) {
    $table = $prefix . $name;
    if (in_array($table, $existing, true)) $tables[] = $table;
}
if (!$tables) {
    fwrite(STDERR, "no plugin metadata tables found\n");
    exit(1);
}
$command = [
    '/usr/bin/mysqldump', '--single-transaction', '--quick', '--skip-lock-tables', '--no-tablespaces',
    '--default-character-set=utf8mb4',
    '--host=' . $config['hostname'], '--port=' . $port,
    '--user=' . $config['username'], '--result-file=' . $backupDir . '/plugin-metadata.sql',
    $config['database'],
];
foreach ($tables as $table) $command[] = $table;

$environment = ['PATH' => getenv('PATH') ?: '/usr/bin:/bin', 'MYSQL_PWD' => (string) $config['password']];
$descriptors = [0 => ['pipe', 'r'], 1 => ['pipe', 'w'], 2 => ['pipe', 'w']];
$process = proc_open($command, $descriptors, $pipes, $siteRoot, $environment);
if (!is_resource($process)) {
    fwrite(STDERR, "mysqldump could not start\n");
    exit(1);
}
fclose($pipes[0]);
stream_get_contents($pipes[1]);
fclose($pipes[1]);
$error = trim(stream_get_contents($pipes[2]));
fclose($pipes[2]);
$code = proc_close($process);
$dump = $backupDir . '/plugin-metadata.sql';
if ($code !== 0 || !is_file($dump) || filesize($dump) === 0) {
    @unlink($dump);
    fwrite(STDERR, "mysqldump failed: " . $error . "\n");
    exit(1);
}
chmod($dump, 0600);
echo 'plugin-metadata-backup-ok tables=' . implode(',', $tables) . ' bytes=' . filesize($dump) . ' sha256=' . hash_file('sha256', $dump) . "\n";
