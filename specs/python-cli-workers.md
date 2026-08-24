# Python CLIs, Workers, and Local Services

## CLI contract

- Support `--help` and return documented exit codes.
- Send machine-readable primary output to stdout and errors/status to stderr.
- Use `0` for success, a documented nonzero code for a meaningful negative result, and `2` for invalid input when appropriate.
- Accept `-` for stdin when streaming input is useful.
- Bound line length, batch size, worker count, retries, and timeouts.
- Make JSON output stable and sorted when used in tests or pipelines.

## Worker contract

- Persist job identity, state, input digest, attempt count, timestamps, and last bounded error.
- Claim work atomically; do not let two workers process one job accidentally.
- Retry only classified transient failures with a bounded backoff.
- Validation, permission, schema, and deterministic computation failures do not retry forever.
- Cancellation is explicit and observable.
- Shutdown checkpoints active work before process exit when the task supports resumption.

## Packaging

- Prefer the standard library for small utilities.
- Declare the minimum Python version and runtime dependencies in `pyproject.toml`.
- Keep imports side-effect free.
- Expose core logic as typed functions separate from CLI parsing.
- Public functions need concise docstrings stating inputs, bounds, outputs, and exceptions.

## Local services

- Bind to loopback by default.
- Expose readiness separately from liveness.
- Stream progress for long work and preserve a final status record.
- Never serialize secrets, full environment contents, or private prompts into job results.
