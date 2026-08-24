#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
TEST_ROOT="$(mktemp -d)"
trap '[[ -d "$TEST_ROOT" ]] && find "$TEST_ROOT" -depth -delete' EXIT

PROJECT_ROOT="$TEST_ROOT/project" bash "$ROOT/modules/bash/bootstrap.sh" >/dev/null
test "$(<"$TEST_ROOT/project/var/state/schema-version")" = "1"
PROJECT_ROOT="$TEST_ROOT/project" bash "$ROOT/modules/bash/bootstrap.sh" >/dev/null

sample="$TEST_ROOT/sample.sh"
printf '\357\273\277#!/usr/bin/env bash\r\nprintf "ok\\n"\r\n' >"$sample"
bash "$ROOT/modules/bash/repair-text-files.sh" "$sample" | grep -F 'bom=1 crlf=1' >/dev/null
bash "$ROOT/modules/bash/repair-text-files.sh" --apply "$sample" >/dev/null
bash -n "$sample"
test -x "$sample"
! LC_ALL=C grep -q $'\r' "$sample"

state="$TEST_ROOT/service"
bash "$ROOT/modules/bash/process-control.sh" start "$state" -- bash -c 'while :; do sleep 1; done' >/dev/null
bash "$ROOT/modules/bash/process-control.sh" status "$state" | grep -F 'running pid=' >/dev/null
bash "$ROOT/modules/bash/process-control.sh" stop "$state" | grep -F 'stopped' >/dev/null
bash "$ROOT/modules/bash/process-control.sh" status "$state" | grep -Fx 'stopped' >/dev/null

printf 'shell module integration: ok\n'
