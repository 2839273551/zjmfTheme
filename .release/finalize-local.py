import datetime
import hashlib
import json
import shutil
import subprocess
import zipfile
from pathlib import Path, PurePosixPath

release = Path(__file__).resolve().parent
repo = release / 'zjmfTheme'
workspace = release.parent
archive = repo / 'dist/ABCLOUD-3.0.0.zip'
digest = lambda content: hashlib.sha256(content).hexdigest()
prefixes = tuple(f'public/themes/{section}/ABCLOUD/' for section in ('web', 'cart', 'clientarea')) + ('public/plugins/addons/abcloud_theme/', 'public/plugins/addons/geetest_captcha/')
with zipfile.ZipFile(archive) as bundle:
    assert bundle.testzip() is None
    names = bundle.namelist()
    assert len(names) == len(set(names))
    manifest = json.loads(bundle.read('MANIFEST.json'))
    assert len(manifest) == 2571
    for item in manifest:
        name = item['path']
        assert name.startswith(prefixes) and '..' not in PurePosixPath(name).parts
        content = bundle.read(name)
        assert len(content) == item['bytes'] and digest(content) == item['sha256'], name
    expected = {item['path'] for item in manifest} | {'MANIFEST.json', 'docs/INSTALL.md', 'THIRD_PARTY_NOTICES.md', 'notices/APE-开源说明.txt'}
    assert set(names) == expected
archive_hash = digest(archive.read_bytes())
assert (archive.with_name(archive.name + '.sha256')).read_text().split()[0] == archive_hash
tracked = subprocess.check_output(['git', 'ls-files', '-z'], cwd=repo).decode('utf-8').split('\0')
tracked = [name for name in tracked if name]
assert 'README.md' not in tracked and 'docs/INSTALL.md' in tracked
for name in tracked:
    parts = PurePosixPath(name).parts
    assert not set(parts) & {'qa', 'reference', 'backups', '.release', '.git', 'node_modules'}, name
    assert parts[0] != 'dist', name
    assert not name.lower().endswith(('.pem', '.key', '.pfx', '.sql', '.sqlite')), name
    assert not any(part.startswith('.env') for part in parts), name
    assert (repo / name).stat().st_size < 100 * 1024 * 1024, name

stamp = datetime.datetime.now().strftime('%Y%m%d-%H%M%S')
backup = release / 'backups' / ('local-source-' + stamp)
mappings = [(repo / section, workspace / 'ABCLOUD/public/themes' / section / 'ABCLOUD') for section in ('web', 'cart', 'clientarea')]
mappings += [(repo / 'plugins' / plugin, workspace / 'ABCLOUD/public/plugins/addons' / plugin) for plugin in ('abcloud_theme', 'geetest_captcha')]
changes = []
for source_root, target_root in mappings:
    assert target_root.resolve().is_relative_to((workspace / 'ABCLOUD/public').resolve())
    for source in sorted(source_root.rglob('*')):
        if not source.is_file():
            continue
        assert not source.is_symlink(), str(source)
        target = target_root / source.relative_to(source_root)
        assert target.resolve().is_relative_to(target_root.resolve()) and not target.is_symlink()
        source_hash = digest(source.read_bytes())
        previous_hash = digest(target.read_bytes()) if target.is_file() else None
        if source_hash != previous_hash:
            relative = target.relative_to(workspace)
            if target.exists():
                saved = backup / relative
                saved.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(target, saved)
                assert digest(saved.read_bytes()) == previous_hash
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(source, target)
            changes.append({'path': relative.as_posix(), 'before': previous_hash, 'after': source_hash})
        assert digest(target.read_bytes()) == source_hash
backup.mkdir(parents=True, exist_ok=True)
(backup / 'manifest.json').write_text(json.dumps(changes, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps({'zip_files_verified': len(manifest), 'zip_sha256': archive_hash, 'tracked_files': len(tracked), 'local_files_synced': len(changes), 'existing_files_backed_up': sum(item['before'] is not None for item in changes), 'backup': str(backup)}, ensure_ascii=False))
