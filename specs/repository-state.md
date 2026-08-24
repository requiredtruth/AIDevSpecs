# Repository and Work-State Contract

Use explicit state files when a project spans multiple turns, agents, or autonomous runs.

## Recommended files

- `PROJECT_SPEC.md` — stable scope, invariants, interfaces, and acceptance criteria.
- `TODO.md` — ordered unstarted work.
- `CURRENT.md` — exactly one active objective, current evidence, and next command.
- `BLOCKED.md` — blockers, required authority/input, and safe partial state.
- `DONE.md` — factual completed items with test or commit evidence.
- `state.json` — optional machine-readable equivalent.
- `results.tsv` — optional append-only measurements with units and environment fields.

## State transitions

```text
TODO -> CURRENT -> DONE
           |
           +-> BLOCKED -> CURRENT
```

- Move an item to `CURRENT` before implementation.
- Only one substantive objective is current unless independent parallel work is explicitly authorized.
- Move to `DONE` only with acceptance evidence.
- A blocker records what is missing; it does not erase partial work.
- On restart, read `PROJECT_SPEC.md`, `CURRENT.md`, and repository status before acting.

## Append-only facts

Logs and result files should record:

- UTC timestamp;
- operation or measurement;
- input version or commit;
- environment facts relevant to interpretation;
- exact outcome and units;
- failure reason when incomplete.

Do not record routine views, secret values, or projected outcomes.
