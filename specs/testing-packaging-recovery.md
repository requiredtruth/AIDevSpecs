# Testing, Packaging, Delivery, and Recovery

## Verification ladder

Run the applicable checks in this order:

1. syntax/parse checks;
2. unit tests for pure logic;
3. integration tests at storage/API boundaries;
4. end-to-end test of the requested user workflow;
5. build/package compilation;
6. clean-install/bootstrap test;
7. restart/resume and migration test;
8. privacy/secret scan;
9. complete diff inspection.

Do not stop at the first convenient green check.

## Test design

- Include valid, invalid, empty, boundary, duplicate, interrupted, and permission-denied cases where relevant.
- Reproduce reported failures before claiming a fix.
- A regression test should fail for the original bug and pass after repair.
- Deterministic examples use fixed clocks/seeds or record nondeterministic inputs.
- Benchmarks include warmup, repetitions, units, environment facts, and raw samples.

## Packaging

- Deliver the requested runnable artifact and source, not one in place of the other.
- Archive layout starts at the intended deployment root; avoid unexplained extra nesting.
- Include exact install/start/stop/status/test commands.
- Generated archives exclude caches, build products, databases with private data, credentials, and local model files unless explicitly licensed and requested.
- Verify the artifact by extracting/installing it into a clean temporary target.

## Backups and recovery

- Back up only material files that will change, with a timestamp or operation identifier.
- State where the backup is and how to restore it.
- Repairs validate exact targets and never operate on broad unresolved paths.
- After successful migration or an explicit cleanup request, remove obsolete backups only after confirming the replacement and recovery state.
- A partial failure leaves a marker and instructions rather than pretending rollback completed.
