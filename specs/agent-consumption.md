# Coding-Agent Consumption Contract

## Before work

1. Read `SOURCE_PROFILE.md` for privacy and provenance boundaries.
2. Read the target repository's specification and current state files.
3. Select only relevant files from `SPEC_INDEX.md`.
4. Inspect real code, tests, issues, and dirty changes.
5. Write or update acceptance criteria before implementation when scope is large.

## During work

- Keep one substantive objective current.
- Preserve unrelated changes.
- Use modules as reviewed primitives, not mandatory architecture.
- Adapt placeholders explicitly; never deploy examples unchanged.
- Record blockers and exact safe partial state.
- Send status before a long build, download, test, or migration.

## Before completion

- Run the relevant acceptance checklist.
- Inspect the complete diff.
- Search for secrets, personal identifiers, placeholders, and private source references.
- Verify bootstrap/run/stop/status paths when applicable.
- Report only merged/shipped changes and measured results.

## Conflict resolution

Project-specific explicit requirements override general defaults. Safety, privacy, proprietary boundaries, and preservation of user-owned work remain mandatory. When two preferences genuinely conflict and current scope does not resolve them, record the conflict rather than inventing a choice.
