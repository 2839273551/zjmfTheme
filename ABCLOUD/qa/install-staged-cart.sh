#!/usr/bin/env bash
set -Eeuo pipefail

site=/www/wwwroot/idc.yunxnet.cn
release="$1"
backup="$site/.codex-backups/$release"
stage="$site/.codex-staging/$release"
manifest="$backup/cart-theme-manifest.txt"
cart_theme="public/themes/cart/ABCLOUD"
installed=0

rollback() {
  trap - ERR
  if (( installed == 0 )); then return; fi
  if [[ -d "$site/$cart_theme" ]]; then
    rm -rf "$site/$cart_theme"
  fi
  (cd "$site" && php think clear)
  echo 'release-rollback-complete' >&2
}
trap rollback ERR

[[ -d "$backup" && -d "$stage" && -f "$manifest" ]]
(cd "$stage" && sha256sum -c "$manifest" >/dev/null)
installed=1

install -d -o www -g www -m 0755 "$site/$cart_theme"

while read -r expected rel; do
  rel=${rel%$'\r'}
  [[ "$expected" =~ ^[0-9a-f]{64}$ ]]
  case "$rel" in
    public/themes/cart/ABCLOUD/*) ;;
    *) echo "out-of-scope path: $rel" >&2; false ;;
  esac
  [[ -f "$stage/$rel" && ! -L "$stage/$rel" ]]
  directory=$(dirname "$site/$rel")
  if [[ ! -d "$directory" ]]; then
    install -d -o www -g www -m 0755 "$directory"
  fi
  install -o www -g www -m 0644 "$stage/$rel" "$site/$rel"
  [[ "$(sha256sum "$site/$rel" | cut -d' ' -f1)" == "$expected" ]]
done < "$manifest"

(cd "$site" && sha256sum -c "$manifest" >/dev/null && php think clear)
echo 'cart-theme-files-installed-and-verified'
