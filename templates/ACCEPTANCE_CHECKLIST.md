# Acceptance Checklist

## Scope and preservation

- [ ] Requested outcome works end-to-end.
- [ ] Existing features and unrelated changes are preserved.
- [ ] No placeholders, dead controls, fake data, or silent skips remain.

## Operation

- [ ] Clean bootstrap is documented and verified.
- [ ] Run/start, stop, and status commands reflect real state.
- [ ] Long operations expose truthful progress before expensive work.
- [ ] Restart/resume behavior is verified where applicable.

## Data

- [ ] Schema versions and migrations are idempotent.
- [ ] Writes are atomic/transactional at the material boundary.
- [ ] Concurrency and retries are bounded.
- [ ] Backup and restore behavior is documented for material changes.

## Tests

- [ ] Syntax and unit tests pass.
- [ ] Integration and requested workflow tests pass.
- [ ] Invalid, boundary, interruption, and permission cases are covered.
- [ ] Build/package artifact works from a clean target.

## Privacy and handoff

- [ ] Secrets, identifiers, private paths, and proprietary source were not published.
- [ ] Logs and examples are synthetic/sanitized.
- [ ] Complete diff was inspected.
- [ ] Report states measured results and honest limitations only.
