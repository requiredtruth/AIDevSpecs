# Storage, Migrations, Deduplication, and Concurrency

## Durable storage

- Use atomic replace for small state files: write, flush, sync when needed, then rename within one filesystem.
- SQLite writes use transactions, foreign keys, and a busy timeout.
- Large binary assets are content-addressed or checksummed when deduplication matters.
- Indexes store normalized metadata and references; they do not duplicate material payloads unnecessarily.
- Repeated content may be represented by shared chunks or ranges only when restore behavior remains exact.

## Migration contract

- Every durable format carries a schema/version marker.
- Migrations are ordered, idempotent, and resumable.
- A marker advances only after verification succeeds.
- Existing data is backed up or migrated through a recoverable copy-on-write path before destructive replacement.
- The next normal operation may trigger migration, but it must show phase/progress and refuse unsafe partial states.
- Test migration from every supported prior version, not only a clean install.

## Concurrent work

- Lock the smallest material resource: project, job, database transaction, or index segment.
- Never hold a global lock during slow compression, network access, or model inference when a shorter commit lock works.
- Write owners and reference counts transactionally.
- Removing one project/job must not delete shared content still referenced elsewhere.
- Stale lock recovery checks process identity or lease expiry; it does not blindly remove lock files.

## Imports and scans

- Show discovery progress before the full scan finishes.
- Batch index updates instead of rewriting the entire index for each file.
- Hash/chunk work is bounded by configurable worker counts.
- Resume from verified markers after interruption.
- Final verification compares counts, sizes, and representative restores.
