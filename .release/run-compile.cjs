const fs = require('node:fs');
const path = require('node:path');
const {spawnSync} = require('node:child_process');
const root = path.join(__dirname, 'zjmfTheme');
const sources = {};
function collect(folder) {
  for (const entry of fs.readdirSync(path.join(root, folder), {withFileTypes: true})) {
    const relative = folder + '/' + entry.name;
    if (entry.isDirectory()) collect(relative);
    else if (/\.(tpl|html)$/.test(relative)) sources[relative] = fs.readFileSync(path.join(root, relative)).toString('base64');
  }
}
for (const end of ['web', 'cart', 'clientarea']) collect(end);
const input = `<?php $GLOBALS['theme_compile_sources'] = json_decode(base64_decode('${Buffer.from(JSON.stringify(sources)).toString('base64')}'), true); ?>` + fs.readFileSync(path.join(root, 'tests/compile-templates.php'), 'utf8');
const result = spawnSync('C:/Windows/System32/OpenSSH/ssh.exe', ['-i', 'C:/Users/28392/.ssh/id_121', '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes', '-o', 'ConnectTimeout=10', 'root@121.41.65.120', 'THINKPHP_BASE=/www/wwwroot/idc.yunxnet.cn/vendor/thinkphp/base.php php'], {input, encoding: 'utf8', timeout: 90000, maxBuffer: 2 ** 22});
console.log(result.status, result.stdout, result.stderr, result.error || '');
process.exitCode = result.status === 0 && /"failed": \[\]/.test(result.stdout) ? 0 : 1;
