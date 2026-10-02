#!/usr/bin/env bash
set -Eeuo pipefail

site=/www/wwwroot/idc.yunxnet.cn
release=abcloud-plugin-20260926-164007
backup="$site/.codex-backups/$release"
stage="$site/.codex-staging/$release"
manifest="$backup/release-manifest.txt"
plugin=public/plugins/addons/abcloud_theme
new_theme=public/themes/web/ABCLOUD/static/ape/js/plugin-content.js
old_files=(
  public/themes/web/ABCLOUD/index.html
  public/themes/web/ABCLOUD/VERSION
  public/themes/web/ABCLOUD/static/ape/js/carousel.js
  public/themes/web/ABCLOUD/static/ape/js/site-content.js
)
installed=0

rollback() {
  trap - ERR
  if (( installed == 0 )); then return; fi
  for rel in "${old_files[@]}"; do
    install -o www -g www -m 0644 "$backup/$rel" "$site/$rel"
  done
  if [[ -d "$site/$plugin" ]]; then
    mv "$site/$plugin" "$backup/rolled-back-new-plugin"
  fi
  if [[ -f "$site/$new_theme" ]]; then
    mv "$site/$new_theme" "$backup/rolled-back-plugin-content.js"
  fi
  (cd "$site" && php think clear)
  echo 'release-file-rollback-complete' >&2
}
trap rollback ERR

[[ -d "$backup" && -d "$stage" && -f "$manifest" ]]
[[ ! -e "$site/$plugin" && ! -e "$site/$new_theme" ]]
(cd "$stage" && sha256sum -c "$manifest" >/dev/null)
(cd "$site" && sha256sum -c "$backup/sha256-before.txt" >/dev/null)
installed=1
install -d -o www -g www -m 0755 "$site/$plugin" "$site/$plugin/assets"

while read -r expected rel; do
  rel=${rel%$'\r'}
  [[ "$expected" =~ ^[0-9a-f]{64}$ ]]
  case "$rel" in
    public/plugins/addons/abcloud_theme/*|public/themes/web/ABCLOUD/index.html|public/themes/web/ABCLOUD/VERSION|public/themes/web/ABCLOUD/static/ape/js/carousel.js|public/themes/web/ABCLOUD/static/ape/js/site-content.js|public/themes/web/ABCLOUD/static/ape/js/plugin-content.js) ;;
    *) echo "out-of-scope path: $rel" >&2; false ;;
  esac
  [[ -f "$stage/$rel" && ! -L "$stage/$rel" ]]
  directory=$(dirname "$site/$rel")
  if [[ "$rel" == "$plugin/"* && ! -d "$directory" ]]; then
    install -d -o www -g www -m 0755 "$directory"
  fi
  [[ -d "$directory" ]]
  installed=1
  install -o www -g www -m 0644 "$stage/$rel" "$site/$rel"
  [[ "$(sha256sum "$site/$rel" | cut -d' ' -f1)" == "$expected" ]]
done < "$manifest"

(cd "$site" && sha256sum -c "$manifest" >/dev/null && php think clear)
echo 'release-files-installed-and-verified'
