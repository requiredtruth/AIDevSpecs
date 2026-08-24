# PHP and SQLite Web Applications

## Default stack

- PHP with SQLite is preferred for compact self-hosted applications.
- The database must initialize automatically on first valid application load or through bootstrap.
- Use PDO, prepared statements, transactions, foreign keys, and a busy timeout.
- Keep deployment FTP/copy friendly when the target is simple hosting.
- A single-page implementation is acceptable when portability requires it, but internal functions must remain separated by responsibility.

## Database bootstrap

1. Resolve a writable data directory outside publicly served static assets when possible.
2. Create the directory with explicit permissions; never make it world-writable as a default fix.
3. Open SQLite with exception mode.
4. Enable `foreign_keys`, `busy_timeout`, and WAL where the environment supports it.
5. Create a schema-version table and apply ordered idempotent migrations in a transaction.
6. Verify read/write operation before reporting readiness.

## Request and UI contract

- Every button must have a real handler and a tested end-to-end path.
- Mutations use POST/PUT/PATCH/DELETE semantics, CSRF protection for sessions, validation, and structured errors.
- Authentication and authorization are separate checks.
- Non-admin users see results and allowed actions, not secrets, service configuration, or raw server status.
- Activity logs record changes and meaningful result-producing actions—not page views or every click.
- Mobile layout is a first-class acceptance target: readable controls, no horizontal overflow, and usable progress/status displays.

## Blank-page diagnostics

- Run `php -l` on every changed PHP file.
- Inspect the web-server error log and PHP-FPM log.
- Verify the configured FPM socket/version matches the running service.
- Confirm the application can traverse parent directories and write only its intended data path.
- Temporarily enable safe development error display only in a non-public environment; never leave it enabled in production.
