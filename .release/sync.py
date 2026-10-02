import sys
import hashlib
import shutil
from pathlib import Path

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

release_dir = Path(__file__).resolve().parent
repo_dir = release_dir / 'zjmfTheme'
workspace = release_dir.parent

mappings = [
    (repo_dir / 'web', workspace / 'ABCLOUD/public/themes/web/ABCLOUD'),
    (repo_dir / 'cart', workspace / 'ABCLOUD/public/themes/cart/ABCLOUD'),
    (repo_dir / 'clientarea', workspace / 'ABCLOUD/public/themes/clientarea/ABCLOUD'),
    (repo_dir / 'plugins/abcloud_theme', workspace / 'ABCLOUD/public/plugins/addons/abcloud_theme'),
    (repo_dir / 'plugins/geetest_captcha', workspace / 'ABCLOUD/public/plugins/addons/geetest_captcha'),
]

def file_hash(p: Path) -> str:
    return hashlib.sha256(p.read_bytes()).hexdigest()

def check_status():
    differences = []
    for git_root, ab_root in mappings:
        # Check files in ABCLOUD
        if ab_root.exists():
            for ab_file in ab_root.rglob('*'):
                if not ab_file.is_file():
                    continue
                rel = ab_file.relative_to(ab_root)
                git_file = git_root / rel
                if not git_file.exists():
                    differences.append(('ABCLOUD_NEW', ab_file, git_file))
                elif file_hash(ab_file) != file_hash(git_file):
                    differences.append(('MODIFIED', ab_file, git_file))
        # Check files only in git
        if git_root.exists():
            for git_file in git_root.rglob('*'):
                if not git_file.is_file():
                    continue
                rel = git_file.relative_to(git_root)
                ab_file = ab_root / rel
                if not ab_file.exists():
                    differences.append(('GIT_ONLY', ab_file, git_file))
    return differences

def sync_to_git():
    diffs = check_status()
    if not diffs:
        print("[sync] ABCLOUD 与 Git 仓库 zjmfTheme 代码完全一致，无须同步。")
        return
    count = 0
    for diff_type, ab_file, git_file in diffs:
        if diff_type in ('ABCLOUD_NEW', 'MODIFIED'):
            git_file.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(ab_file, git_file)
            print(f"[to-git] {diff_type}: {git_file.relative_to(repo_dir)}")
            count += 1
        elif diff_type == 'GIT_ONLY':
            print(f"[warning] 仅在 Git 仓库存在的文件: {git_file.relative_to(repo_dir)}")
    print(f"[sync] 成功同步 {count} 个文件至 Git 仓库 (.release/zjmfTheme)。")

def sync_to_abcloud():
    diffs = check_status()
    if not diffs:
        print("[sync] ABCLOUD 与 Git 仓库 zjmfTheme 代码完全一致，无须同步。")
        return
    count = 0
    for diff_type, ab_file, git_file in diffs:
        if diff_type in ('GIT_ONLY', 'MODIFIED'):
            ab_file.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(git_file, ab_file)
            print(f"[to-abcloud] {diff_type}: {ab_file.relative_to(workspace)}")
            count += 1
        elif diff_type == 'ABCLOUD_NEW':
            print(f"[warning] 仅在 ABCLOUD 存在的文件: {ab_file.relative_to(workspace)}")
    print(f"[sync] 成功同步 {count} 个文件至 ABCLOUD。")

if __name__ == '__main__':
    cmd = sys.argv[1] if len(sys.argv) > 1 else 'status'
    if cmd == 'status':
        diffs = check_status()
        if not diffs:
            print("[status] ABCLOUD 与 Git 仓库 zjmfTheme 状态完全一致 (100% 同步)。")
        else:
            print(f"[status] 发现 {len(diffs)} 处差异：")
            for diff_type, ab_file, git_file in diffs:
                print(f"  - [{diff_type}] AB: {ab_file.relative_to(workspace)} <-> GIT: {git_file.relative_to(repo_dir)}")
    elif cmd == 'to-git':
        sync_to_git()
    elif cmd == 'to-abcloud':
        sync_to_abcloud()
    else:
        print("Usage: python .release/sync.py [status | to-git | to-abcloud]")
