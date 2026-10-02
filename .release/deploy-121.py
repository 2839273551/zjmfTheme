import datetime
import hashlib
import json
import os
import subprocess
import sys
from pathlib import Path

SSH_EXE = 'C:/Windows/System32/OpenSSH/ssh.exe'
SSH_KEY = 'C:/Users/28392/.ssh/id_121'
SSH_TARGET = 'root@121.41.65.120'

remote_deploy_script = """
import os
import sys
import shutil
import zipfile
import json
import hashlib
import subprocess
import pwd
import grp
from pathlib import Path
from datetime import datetime

site_root = Path('/www/wwwroot/idc.yunxnet.cn')
zip_path = Path('/tmp/ABCLOUD-3.0.0.zip')

assert site_root.exists(), 'Site root does not exist'
assert zip_path.exists(), 'Zip file does not exist'

stamp = datetime.now().strftime('%Y%m%d-%H%M%S')
release_id = f'upgrade-abcloud-3.0.0-{stamp}'
backup_root = site_root / f'.codex-backups/{release_id}'
staging_root = site_root / f'.codex-staging/{release_id}'

backup_root.mkdir(parents=True, exist_ok=True)
staging_root.mkdir(parents=True, exist_ok=True)

# 1. Unpack to staging
with zipfile.ZipFile(zip_path, 'r') as zf:
    zf.extractall(staging_root)

manifest_file = staging_root / 'MANIFEST.json'
assert manifest_file.exists(), 'MANIFEST.json missing in bundle'
manifest = json.loads(manifest_file.read_text(encoding='utf-8'))

allowed_prefixes = (
    'public/themes/web/ABCLOUD/',
    'public/themes/cart/ABCLOUD/',
    'public/themes/clientarea/ABCLOUD/',
    'public/plugins/addons/abcloud_theme/',
    'public/plugins/addons/geetest_captcha/'
)

def sha256_file(p):
    h = hashlib.sha256()
    with open(p, 'rb') as f:
        while True:
            chunk = f.read(65536)
            if not chunk:
                break
            h.update(chunk)
    return h.hexdigest()

# 2. Verify staging files
for item in manifest:
    rel = item['path']
    assert rel.startswith(allowed_prefixes), f'Illegal path prefix: {rel}'
    assert '..' not in rel, f'Path traversal attempt: {rel}'
    staged_file = staging_root / rel
    assert staged_file.exists(), f'Staged file missing: {rel}'
    actual_hash = sha256_file(staged_file)
    assert actual_hash == item['sha256'], f'Hash mismatch in staging: {rel}'

# 3. Backup existing files
before_hashes = {}
backed_up_count = 0
for item in manifest:
    rel = item['path']
    target_file = site_root / rel
    if target_file.is_file():
        cur_hash = sha256_file(target_file)
        before_hashes[rel] = cur_hash
        backup_file = backup_root / rel
        backup_file.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(target_file, backup_file)
        backed_up_count += 1

with open(backup_root / 'sha256-before.txt', 'w', encoding='utf-8') as f:
    for rel in sorted(before_hashes.keys()):
        h = before_hashes[rel]
        f.write(h + '  ' + rel + '\\n')

# 4. Install files
installed_count = 0
for item in manifest:
    rel = item['path']
    staged_file = staging_root / rel
    target_file = site_root / rel
    target_file.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(staged_file, target_file)
    installed_count += 1

# 5. Fix permissions for target directories and files
www_uid = pwd.getpwnam('www').pw_uid
www_gid = grp.getgrnam('www').gr_gid

for prefix in allowed_prefixes:
    d = site_root / prefix
    if not d.exists():
        continue
    os.chown(d, www_uid, www_gid)
    os.chmod(d, 0o755)
    for root, dirnames, filenames in os.walk(d):
        for dirname in dirnames:
            dp = os.path.join(root, dirname)
            os.chown(dp, www_uid, www_gid)
            os.chmod(dp, 0o755)
        for filename in filenames:
            fp = os.path.join(root, filename)
            os.chown(fp, www_uid, www_gid)
            os.chmod(fp, 0o644)

# 6. Verify installed files
for item in manifest:
    rel = item['path']
    target_file = site_root / rel
    assert target_file.is_file(), f'Installed file missing: {rel}'
    assert sha256_file(target_file) == item['sha256'], f'Installed hash mismatch: {rel}'

# 7. Verify user upload directory preserved
user_uploads = site_root / 'public/plugins/addons/abcloud_theme/assets/content'
assert user_uploads.exists(), 'User uploads directory missing'

# 8. Clear cache
proc = subprocess.run(['php', 'think', 'clear'], cwd=str(site_root), capture_output=True, text=True)

# 9. Clean temporary zip
if zip_path.exists():
    zip_path.unlink()

report = {
    'status': 'success',
    'release_id': release_id,
    'backup_dir': str(backup_root),
    'staging_dir': str(staging_root),
    'files_manifest': len(manifest),
    'files_backed_up': backed_up_count,
    'files_installed': installed_count,
    'cache_clear_stdout': proc.stdout.strip(),
    'cache_clear_stderr': proc.stderr.strip(),
}
print(json.dumps(report, ensure_ascii=False))
"""

def main():
    cmd = [
        SSH_EXE,
        '-i', SSH_KEY,
        '-o', 'BatchMode=yes',
        '-o', 'StrictHostKeyChecking=yes',
        '-o', 'ConnectTimeout=10',
        SSH_TARGET,
        'python3 -'
    ]
    proc = subprocess.run(
        cmd,
        input=remote_deploy_script,
        capture_output=True,
        text=True,
        encoding='utf-8'
    )
    if proc.returncode != 0:
        print('DEPLOY FAILED:', file=sys.stderr)
        print('STDERR:', proc.stderr, file=sys.stderr)
        print('STDOUT:', proc.stdout, file=sys.stderr)
        sys.exit(proc.returncode)

    print('DEPLOY SUCCESS:')
    print(proc.stdout)

if __name__ == '__main__':
    main()
