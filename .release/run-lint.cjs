const fs = require('node:fs');
const path = require('node:path');
const { spawnSync } = require('node:child_process');
const root = path.join(__dirname, 'zjmfTheme');
const sources = {};
function collect(folder) {
  for (const entry of fs.readdirSync(path.join(root, folder), { withFileTypes: true })) {
    const relative = folder + '/' + entry.name;
    if (entry.isDirectory()) collect(relative);
    else if (relative.endsWith('.php')) sources[relative] = fs.readFileSync(path.join(root, relative)).toString('base64');
  }
}
collect('plugins');
const payload = Buffer.from(JSON.stringify(sources)).toString('base64');
const input = `<?php
$files=json_decode(base64_decode('${payload}'),true);
$failed=[];
foreach($files as $name=>$source){
  $proc=proc_open(PHP_BINARY.' -l',[0=>['pipe','r'],1=>['pipe','w'],2=>['pipe','w']],$pipes);
  fwrite($pipes[0],base64_decode($source)); fclose($pipes[0]);
  $out=stream_get_contents($pipes[1]); fclose($pipes[1]);
  $err=stream_get_contents($pipes[2]); fclose($pipes[2]);
  if(proc_close($proc)!==0) $failed[$name]=$out.$err;
}
echo json_encode(['php'=>PHP_VERSION,'files'=>count($files),'failed'=>$failed]).PHP_EOL;
exit(count($failed)?1:0);`;
const result = spawnSync('C:/Windows/System32/OpenSSH/ssh.exe', ['-i', 'C:/Users/28392/.ssh/id_121', '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=yes', '-o', 'ConnectTimeout=10', 'root@121.41.65.120', 'php'], { input, encoding: 'utf8', timeout: 45000 });
console.log(result.status, result.stdout, result.stderr, result.error || '');
process.exitCode = result.status === 0 && /"files":14,"failed":\[\]/.test(result.stdout) ? 0 : 1;
