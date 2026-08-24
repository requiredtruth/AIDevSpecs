# Copyable Modules

These are small reference primitives, not a framework. Copy only what a project needs and adapt documented placeholders.

| Module | Purpose | Verification |
|---|---|---|
| `bash/bootstrap.sh` | Idempotent local project-directory and state bootstrap | `bash -n`, integration test |
| `bash/process-control.sh` | Exact PID/start-time checked start/stop/status wrapper | `bash -n`, integration test |
| `bash/repair-text-files.sh` | Dry-run-first BOM/CRLF/shebang repair for exact files | `bash -n`, integration test |
| `python/atomic_state.py` | Atomic JSON state load/save with optional schema version | unit tests |
| `python/sqlite_bootstrap.py` | Transactional callable SQLite migrations | unit tests |
| `php/sqlite_bootstrap.php` | PDO SQLite initialization and callable migrations | `php -l` |
| `php/json_response.php` | Small safe JSON response/error helpers | `php -l` |
| `sql/sqlite_pragmas.sql` | Recommended local SQLite pragmas and migration table | documentation fixture |

Modules deliberately contain no hostnames, accounts, production paths, credentials, telemetry, or external service calls.
