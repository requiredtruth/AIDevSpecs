# Common Error Playbook

Diagnose first. Apply the narrowest verified repair. Never run every fix blindly.

## Shell script fails immediately

Symptoms: `bad interpreter`, `$'\r': command not found`, unexpected token, permission denied.

Checks:

```bash
file SCRIPT.sh
sed -n '1,3l' SCRIPT.sh
bash -n SCRIPT.sh
```

Repairs:

- remove UTF-8 BOM and CRLF safely;
- restore the intended shebang;
- set executable permission only for actual executable scripts;
- run shell files with `bash` and PHP files with `php`—do not feed one language to the other.

Use `modules/bash/repair-text-files.sh` for a dry-run-first bounded repair.

## Literal patch marker not found

- Resolve the project root from the script location.
- Inspect the actual file before patching.
- Use fixed-string matching (`grep -F`) for literal markers.
- Refuse zero or multiple ambiguous matches.
- Back up the exact target, apply once, then run syntax and behavior checks.
- Never silently skip a required patch during an active install.

## PHP page is blank

- Run `php -l` on changed files.
- Inspect web-server and PHP process-manager logs.
- Verify the configured socket/version matches the running service.
- Check directory traversal and database-directory write permissions.
- Confirm the request reaches the intended entry point.
- Return structured errors in development without exposing them publicly.

## Button does nothing

- Confirm the control exists once and is not covered/disabled unexpectedly.
- Verify the event handler fires.
- Inspect browser console and network request.
- Validate server route, authorization, CSRF, payload, database mutation, response, and visible refresh.
- Add an end-to-end regression test; a DOM-only check is insufficient.

## SQLite cannot open or is locked

- Resolve the actual database and parent directory.
- Verify service-user traversal and write permissions.
- Enable a bounded busy timeout and use short transactions.
- Check for long transactions or multiple ad-hoc connection modes.
- Do not “fix” with world-writable permissions.

## Service starts then disappears

- Run foreground mode first.
- Check exit status and service-manager journal.
- Validate config paths, ports, data permissions, and dependency readiness.
- Detect stale PID files without killing an unrelated reused PID.
- Add a readiness check separate from process existence.

## Import or initial scan is unexpectedly slow

- Show discovery progress before completion of the scan.
- Profile hashing, compression, database commits, and index rewrites separately.
- Batch commits and avoid full-index serialization per item.
- Bound parallelism to storage and memory capacity.
- Preserve resumable checkpoints and measure with representative data.

## Model loads but generation never begins

- Surface queue state, backend process state, model-load phase, and prompt submission separately.
- Capture bounded streaming server output in a dedicated diagnostic view.
- Validate model architecture, context/batch settings, memory availability, endpoint route, and request schema.
- Do not mark a job active solely because the UI button was pressed.
