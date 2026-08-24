# Engineering Doctrine

## Required behavior

1. **Inspect before editing.** Read the tree, entry points, configuration, tests, current state, and dirty changes.
2. **Preserve before improving.** Existing working behavior and unrelated edits are user-owned.
3. **Patch narrowly.** Prefer a small complete change with clear boundaries over architectural churn.
4. **Trace the whole path.** A button is not complete until UI event, request, validation, persistence, response, and visible result all work.
5. **Use durable state.** Long tasks, migrations, imports, and queues survive interruption and resume explicitly.
6. **Verify, then claim.** Run the actual syntax, tests, build, startup, health, and representative workflow checks.
7. **Report facts.** Separate shipped behavior, measured results, limitations, and remaining work.
8. **Keep operation local-first.** Do not introduce paid cloud or public dependencies when an in-process or self-hosted implementation is reasonable.

## Completion definition

A feature is `DONE` only when:

- the requested workflow works end-to-end;
- malformed input and important failure paths behave deliberately;
- data and existing behavior are preserved;
- startup and recovery instructions are accurate;
- tests exercise the changed boundary;
- output does not expose secrets or internal configuration;
- the complete diff has been inspected.

## Prohibited shortcuts

- empty scaffolds or placeholder handlers;
- UI controls with no wired action;
- fake benchmark, demo, progress, user, revenue, or success data;
- swallowing errors to make a command appear successful;
- destructive repair without exact target resolution and recovery notes;
- rewrites used to avoid understanding existing code;
- “works” claims based only on code appearance.
