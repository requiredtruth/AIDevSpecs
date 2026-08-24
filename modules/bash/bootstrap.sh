#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
PROJECT_ROOT="${PROJECT_ROOT:-$(cd -- "$SCRIPT_DIR/../.." && pwd -P)}"
STATE_DIR="${STATE_DIR:-$PROJECT_ROOT/var/state}"
LOG_DIR="${LOG_DIR:-$PROJECT_ROOT/var/log}"
MODEL_DIR="${MODEL_DIR:-$PROJECT_ROOT/var/models}"
SCHEMA_VERSION="${SCHEMA_VERSION:-1}"

phase() { printf '\n[%s] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*"; }
fail() { printf 'bootstrap: %s\n' "$*" >&2; exit 2; }

[[ "$SCHEMA_VERSION" =~ ^[1-9][0-9]*$ ]] || fail "SCHEMA_VERSION must be a positive integer"

phase "Resolve local directories"
printf 'project_root=%s\nstate_dir=%s\nlog_dir=%s\nmodel_dir=%s\n' "$PROJECT_ROOT" "$STATE_DIR" "$LOG_DIR" "$MODEL_DIR"

phase "Create durable directories idempotently"
install -d -m 0750 -- "$STATE_DIR" "$LOG_DIR" "$MODEL_DIR"

VERSION_FILE="$STATE_DIR/schema-version"
if [[ -f "$VERSION_FILE" ]]; then
    current="$(<"$VERSION_FILE")"
    [[ "$current" == "$SCHEMA_VERSION" ]] || fail "schema migration required: found $current, expected $SCHEMA_VERSION"
else
    tmp="$(mktemp --tmpdir="$STATE_DIR" .schema-version.XXXXXX)"
    trap '[[ -n "${tmp:-}" && -e "$tmp" ]] && unlink -- "$tmp"' EXIT
    printf '%s\n' "$SCHEMA_VERSION" >"$tmp"
    chmod 0640 "$tmp"
    if ln -- "$tmp" "$VERSION_FILE"; then
        unlink -- "$tmp"
    else
        fail "schema version appeared concurrently; rerun bootstrap"
    fi
    tmp=""
fi

phase "Verify writable state"
probe="$(mktemp --tmpdir="$STATE_DIR" .write-test.XXXXXX)"
printf 'ok\n' >"$probe"
unlink -- "$probe"

phase "Ready"
