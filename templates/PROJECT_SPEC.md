# [PROJECT] Specification

## Outcome

[One observable result, not a slogan.]

## Users and environment

- Primary workflow: [workflow]
- Supported operating systems/runtimes: [versions]
- Resource constraints: [CPU/RAM/storage/network]
- Local/offline behavior: [required/optional/not applicable]

## Inputs

| Input | Type/format | Bounds | Validation failure |
|---|---|---|---|
| [name] | [type] | [bounds] | [error] |

## Outputs

| Output | Schema/format | Destination | Durability |
|---|---|---|---|
| [name] | [schema] | [stdout/file/API/UI] | [ephemeral/durable] |

## Commands

| Command | Contract | Exit/readiness evidence |
|---|---|---|
| bootstrap | [idempotent clean install] | [evidence] |
| run/start | [foreground/background] | [evidence] |
| stop | [exact target] | [evidence] |
| status | [fields] | [evidence] |
| test | [checks] | [evidence] |

## State model

[States, transitions, persistence, restart behavior, schema version, migration path.]

## Security and privacy

[Secret sources, redaction, authorization, exposed interfaces, prohibited data.]

## Failure behavior

| Failure | Classification | Retry/recovery | User-visible result |
|---|---|---|---|
| [failure] | [transient/permanent] | [behavior] | [message/status] |

## Acceptance criteria

- [ ] [End-to-end workflow]
- [ ] [Invalid/boundary behavior]
- [ ] [Restart/resume/migration]
- [ ] [Performance/resource measurement]
- [ ] [Privacy scan]
- [ ] [Clean install/package verification]

## Explicit non-goals

- [non-goal]
