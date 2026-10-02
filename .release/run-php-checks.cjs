const fs = require('node:fs');
const path = require('node:path');
const {spawnSync} = require('node:child_process');
const root = path.join(__dirname, 'zjmfTheme');
const ssh = ['-i', 'C:/Users/28392/.ssh/id_121', '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes', '-o', 'ConnectTimeout=10', 'root@121.41.65.120'];
for (const suite of [
  {test: 'geetest-contract.php', plugin: 'geetest_captcha', global: 'geetest_plugin_sources', files: ['GeetestCaptchaPlugin.php', 'controller/AdminIndexController.php']},
  {test: 'abcloud-plugin.php', plugin: 'abcloud_theme', global: 'abcloud_plugin_sources', files: ['logic/Security.php', 'logic/Repository.php', 'schema/Schema.php', 'AbcloudThemePlugin.php', 'controller/PublicController.php']}
]) {
  const sources = {};
  for (const file of suite.files) sources[file] = fs.readFileSync(path.join(root, 'plugins', suite.plugin, file)).toString('base64');
  const input = `<?php namespace { $GLOBALS['${suite.global}'] = json_decode(base64_decode('${Buffer.from(JSON.stringify(sources)).toString('base64')}'), true); } ?>` + fs.readFileSync(path.join(root, 'tests', suite.test), 'utf8');
  const result = spawnSync('C:/Windows/System32/OpenSSH/ssh.exe', [...ssh, 'php'], {input, encoding: 'utf8', timeout: 45000});
  console.log(suite.test, result.status, result.stdout, result.stderr, result.error || '');
  if (result.status !== 0) process.exitCode = 1;
}
