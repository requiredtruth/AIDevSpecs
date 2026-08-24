#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
    printf 'Usage:\n  %s start STATE_DIR -- COMMAND [ARGS...]\n  %s stop STATE_DIR\n  %s status STATE_DIR\n' "$0" "$0" "$0"
}

[[ $# -ge 2 ]] || { usage >&2; exit 2; }
action="$1"
state_dir="$2"
[[ "$state_dir" == /* ]] || { printf 'process-control: STATE_DIR must be absolute\n' >&2; exit 2; }
install -d -m 0750 -- "$state_dir"
pid_file="$state_dir/service.pid"
lock_file="$state_dir/service.lock"
log_file="$state_dir/service.log"

read_identity() {
    [[ -s "$pid_file" ]] || return 1
    pid="$(<"$pid_file")"
    [[ "$pid" =~ ^[1-9][0-9]*$ ]] || return 1
    kill -0 "$pid" 2>/dev/null || return 1
    exec {probe_fd}>"$lock_file"
    if flock -n "$probe_fd"; then
        flock -u "$probe_fd"
        exec {probe_fd}>&-
        return 1
    fi
    exec {probe_fd}>&-
    return 0
}

case "$action" in
    start)
        shift 2
        [[ "${1:-}" == "--" && $# -ge 2 ]] || { usage >&2; exit 2; }
        shift
        if read_identity; then
            printf 'running pid=%s\n' "$pid"
            exit 0
        fi
        unlink -- "$pid_file" 2>/dev/null || true
        command -v flock >/dev/null || { printf 'process-control: flock is required\n' >&2; exit 2; }
        # Acquire the lifetime lock and write the identity from inside the
        # background process. This avoids a parent-side PID/exec race.
        nohup bash -c '
            pid_file="$1"
            lock_file="$2"
            shift 2
            exec 9>"$lock_file"
            flock -n 9 || exit 73
            printf "%s\n" "$BASHPID" >"$pid_file"
            exec "$@"
        ' process-control "$pid_file" "$lock_file" "$@" >>"$log_file" 2>&1 &
        starter_pid=$!
        for _ in {1..30}; do
            read_identity && break
            kill -0 "$starter_pid" 2>/dev/null || break
            sleep 0.1
        done
        read_identity || { printf 'process-control: process exited during start; inspect %s\n' "$log_file" >&2; exit 1; }
        printf 'started pid=%s log=%s\n' "$pid" "$log_file"
        ;;
    stop)
        if ! read_identity; then
            printf 'stopped\n'
            exit 0
        fi
        kill -TERM "$pid"
        for _ in {1..100}; do
            read_identity || break
            sleep 0.1
        done
        if read_identity; then
            printf 'process-control: process did not stop after 10 seconds; no forced kill was sent\n' >&2
            exit 1
        fi
        unlink -- "$pid_file" 2>/dev/null || true
        printf 'stopped\n'
        ;;
    status)
        if read_identity; then printf 'running pid=%s log=%s\n' "$pid" "$log_file"; else printf 'stopped\n'; fi
        ;;
    *) usage >&2; exit 2 ;;
esac
