#!/usr/bin/env bash
set -Eeuo pipefail

apply=0
if [[ "${1:-}" == "--apply" ]]; then apply=1; shift; fi
[[ $# -gt 0 ]] || { printf 'Usage: %s [--apply] FILE...\n' "$0" >&2; exit 2; }

for target in "$@"; do
    [[ -f "$target" && ! -L "$target" ]] || { printf 'skip non-regular-file: %s\n' "$target" >&2; continue; }
    bom=0; crlf=0
    [[ "$(LC_ALL=C head -c 3 -- "$target" | od -An -tx1 | tr -d ' \n')" == "efbbbf" ]] && bom=1
    LC_ALL=C grep -q $'\r$' -- "$target" && crlf=1 || true
    printf '%s bom=%s crlf=%s mode=%s\n' "$target" "$bom" "$crlf" "$([[ -x "$target" ]] && printf executable || printf data)"
    (( apply == 1 && (bom == 1 || crlf == 1) )) || continue
    backup="$target.backup.$(date -u +%Y%m%dT%H%M%SZ)"
    cp -p -- "$target" "$backup"
    tmp="$(mktemp --tmpdir="$(dirname -- "$target")" .text-repair.XXXXXX)"
    LC_ALL=C sed -e $'1s/^\xEF\xBB\xBF//' -e $'s/\r$//' -- "$target" >"$tmp"
    chmod --reference="$target" "$tmp"
    mv -- "$tmp" "$target"
    if head -n 1 -- "$target" | grep -q '^#!'; then chmod u+x -- "$target"; fi
    printf 'repaired=%s backup=%s\n' "$target" "$backup"
done
