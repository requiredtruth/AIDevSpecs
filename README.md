# AI Development Specifications

A sanitized, reusable engineering reference for coding agents and humans. It turns recurring implementation requirements into executable repository contracts, acceptance checks, small copyable modules, and repair playbooks.

This corpus contains technical specifications only. It intentionally excludes attribution, identities, accounts, credentials, receiving addresses, private infrastructure, project-specific secrets, conversation excerpts, and proprietary implementations.

## Start here

1. Read [`SOURCE_PROFILE.md`](SOURCE_PROFILE.md) before adding material.
2. Select relevant requirements from [`SPEC_INDEX.md`](SPEC_INDEX.md).
3. Copy [`templates/PROJECT_SPEC.md`](templates/PROJECT_SPEC.md) into a project and resolve every bracketed field.
4. Use [`templates/ACCEPTANCE_CHECKLIST.md`](templates/ACCEPTANCE_CHECKLIST.md) before declaring completion.
5. Run the corpus checks:

```bash
python -m unittest discover -s tests -v
bash -n modules/bash/*.sh
php -l modules/php/sqlite_bootstrap.php
php -l modules/php/json_response.php
```

## Core contract

- Inspect the real repository before proposing changes.
- Preserve working features and unrelated user work.
- Prefer the smallest complete patch over a rewrite.
- Make local operation the default; external services must be optional and justified.
- Installation, start, stop, status, testing, and recovery must be explicit.
- Long work must expose progress before and during the expensive phase.
- Logs record meaningful actions and state changes, not routine page views.
- Migrations must be versioned, resumable, and idempotent.
- Claims require tests, command output, or directly inspected evidence.
- Deliver usable code, not placeholders, empty scaffolds, fake demos, or confidence statements.

## Layout

- `specs/` — normative engineering requirements organized by domain.
- `templates/` — project specification, state, acceptance, and repair templates.
- `modules/` — small copyable Bash, Python, PHP, and SQL primitives.
- `schemas/` — machine-readable state contracts.
- `tests/` — syntax, behavior, and privacy-boundary verification.

## Status vocabulary

Use `TODO`, `CURRENT`, `BLOCKED`, and `DONE` as explicit project states. `DONE` means acceptance evidence exists; it never means “probably works.”

## License

Apache-2.0. See `LICENSE`.


## Install and run

```sh
chmod +x install.sh run.sh
./install.sh
./run.sh --help
```
