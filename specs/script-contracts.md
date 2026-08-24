# Bootstrap, Run, Stop, Status, Train, and Benchmark Scripts

Projects should expose a predictable command surface. Names may vary, but behavior must remain clear.

## Standard contract

| Command | Required behavior |
|---|---|
| `bootstrap` | Install/check dependencies, create required directories, initialize state, migrate safely, and verify readiness |
| `run` | Start foreground development operation with visible logs |
| `start` | Start background/service operation idempotently |
| `stop` | Stop only the resolved project process/service and succeed if already stopped |
| `status` | Report running state, PID/service state, health, version, and active data path without secrets |
| `test` | Run deterministic syntax and behavior checks |
| `train` | Start or resume training from durable state; never silently reset |
| `bench` | Measure actual performance with warmup, repetitions, units, and environment facts |
| `repair` | Diagnose first, back up material files, apply a bounded fix, and verify |

## Script rules

- Use `set -Eeuo pipefail` for Bash unless a documented compatibility reason prevents it.
- Resolve the script directory; do not assume the caller's working directory.
- Detect required privilege. Do not insert `sudo` when scripts are explicitly root-operated.
- Re-running bootstrap must be safe and must not destroy existing state.
- Network/package-manager steps are separate from local initialization steps.
- Never print secrets, full environment dumps, or connection strings.
- Validate exact targets before stop, kill, move, replace, or delete operations.
- Use marker/schema versions for migrations; do not infer completion from partial output files.
- Always print the current phase before a long scan, download, compile, migration, or training operation.

## Final handoff

Documentation must give exact commands for clean install, start, stop, status, test, recovery, and—when present—train and benchmark. Do not make the operator reverse-engineer script order.
