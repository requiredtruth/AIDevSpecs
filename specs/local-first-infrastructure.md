# Local-First Infrastructure

## Defaults

- Prefer a self-hosted process, local database, filesystem queue, or system service over a paid cloud dependency.
- External APIs are adapters, not the only operating mode, unless the product fundamentally requires them.
- Provide explicit host, port, data directory, and resource-limit configuration through documented environment variables or config files.
- Bind to loopback by default. Binding to all interfaces requires an explicit operator choice and an authentication/network warning.
- Health endpoints expose readiness and version, not secrets, server internals, or full configuration.

## Services and workers

- Foreground mode is mandatory for diagnostics and process supervisors.
- Background mode uses a PID file or service manager with stale-state detection.
- Queues persist job state: queued, active, completed, failed, cancelled.
- A restart resumes or explicitly requeues interrupted work; it must not silently lose it.
- Backpressure and concurrency bounds are configuration, not unbounded thread creation.
- Shutdown stops accepting work, completes or checkpoints active work, then exits within a bounded timeout.

## Containers and isolation

- Do not add containers merely as packaging fashion.
- Prefer native/local operation for small tools.
- When isolation is required, document the reason, resource limits, persistent volumes, network exposure, and non-container fallback when feasible.
- Lightweight system containers are preferred for long-lived local workers when they fit the deployment environment.

## APIs

- Prefer small REST/JSON or OpenAI-compatible surfaces when interoperability matters.
- Version response schemas and return structured errors.
- Streaming APIs must emit heartbeat/status information and a terminal completion/error event.
- Never expose admin configuration to ordinary data consumers.
