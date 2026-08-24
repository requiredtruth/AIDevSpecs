#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$ROOT"

scan_files=()
while IFS= read -r file; do scan_files+=("$file"); done < <(find . -type f ! -path './.git/*' ! -path './LICENSE' -print | sort)

forbidden=(
    'bc1[ac-hj-np-z02-9]{20,}'
    '0x[0-9a-fA-F]{40}'
    '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
    'https?://'
    'BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY'
    'world.?forge'
)

for pattern in "${forbidden[@]}"; do
    if grep -EIni --binary-files=without-match -- "$pattern" "${scan_files[@]}"; then
        printf 'privacy scan failed for pattern: %s\n' "$pattern" >&2
        exit 1
    fi
done

printf 'privacy boundary scan: ok\n'
