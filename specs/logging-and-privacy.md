# Logging, Privacy, and Public Artifacts

## Action logs

Record meaningful state changes and result-producing actions:

- create/update/delete operations;
- configuration changes without secret values;
- job start, completion, cancellation, and failure;
- migration and repair actions;
- externally received results that materially change state.

Do not record routine page views, every navigation click, full request bodies, passwords, tokens, model secrets, wallet material, or private prompts.

## Structured event fields

- UTC timestamp;
- event name;
- actor class or local process role, not unnecessary identity;
- target type and safe identifier;
- outcome;
- bounded reason/error code;
- correlation/job identifier;
- version/schema where relevant.

## Redaction

Redact before persistence or external AI processing. Cover at minimum credential assignments, bearer tokens, URLs with credentials, private keys/seed material, access tokens, IP addresses where unnecessary, user-specific absolute paths, and private account identifiers.

Redaction is defense in depth. Synthetic fixtures and a deny-pattern scan are still required before publishing examples.

## Public output

- Ordinary users receive the requested data and safe status, not raw server configuration.
- Admin diagnostics are separately authorized and still redact secrets.
- Example logs are synthetic or publicly reproducible and labeled as such.
- Do not publish private datasets, model weights without license verification, internal prompts, or proprietary source excerpts.
