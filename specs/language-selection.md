# Language and Dependency Selection

Choose the smallest stack that completely satisfies the operating environment. Do not add a framework because it is fashionable or familiar.

## Bash

Use for:

- bootstrap and local orchestration;
- dependency and command checks;
- service wrappers and bounded repairs;
- pipelines around existing command-line tools.

Do not use Bash for complex JSON mutation, concurrent durable state, large parsers, or application business logic when Python/PHP is clearer and safer.

## Python

Use for:

- CLIs, workers, data processing, local APIs, AI/model integration, tests, and cross-platform logic;
- bounded concurrency and durable state machines;
- tasks requiring strict typing and structured JSON.

Prefer the standard library for small tools. Add dependencies only when they materially reduce risk or implementation size.

## PHP

Use for:

- copy-deployable self-hosted web applications;
- server-rendered or compact single-page control panels;
- SQLite-backed tools on ordinary web servers;
- JSON endpoints paired with simple browser interfaces.

Keep request routing, authorization, storage, and presentation logically separated even when delivery requires one physical PHP file.

## JavaScript

Use browser JavaScript for interaction, streaming updates, local validation, and visual status. Prefer progressive enhancement and native browser APIs. Do not introduce a frontend build system when plain HTML/CSS/JavaScript meets the requirements.

Every UI mutation must connect to a real backend operation and reconcile the visible state with the returned result.

## SQL and database choice

- SQLite is the default for one-host applications, local tools, queues, and moderate concurrency with short transactions.
- Use MariaDB/MySQL when multi-host access, existing operational requirements, or sustained concurrent writes justify a service database.
- Schema changes are migrations, never ad-hoc startup guesses.
- Queries use parameters; identifiers are allowlisted rather than interpolated.

## Avoidance defaults

- Avoid paid/public cloud dependencies when a local implementation is reasonable.
- Avoid container-only delivery for small native tools.
- Avoid hybrid mobile wrappers when native background execution and storage are core.
- Avoid framework bloat, generated boilerplate, and duplicated abstraction layers.
- Avoid silent fallbacks that change storage, model, endpoint, or security behavior.
