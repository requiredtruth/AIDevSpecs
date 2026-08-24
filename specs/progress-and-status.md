# Progress, Status, and Visual Feedback

## Rule

If an operation can take long enough for a user to wonder whether it is stuck, status must appear before the expensive phase begins and remain accurate until completion or failure.

## Required phases

Typical long operations expose:

1. discovering/counting work;
2. validating inputs;
3. downloading or reading;
4. processing/training/migrating;
5. writing/committing;
6. verifying;
7. complete, failed, cancelled, or blocked.

The initial directory scan is itself a progress phase. Do not leave a blank interface while counting a large tree.

## Progress fields

- phase and human-readable status;
- completed units and known total;
- indeterminate state when total is honestly unknown;
- elapsed time;
- measured rate with units;
- current bounded item label;
- cancellation state;
- final success/failure summary.

Never fake linear progress. When totals change, state that discovery updated the total.

## UI behavior

- Keep the last meaningful status visible after completion.
- Errors include a safe actionable message and an error identifier, not a raw secret-bearing trace.
- Streaming views do not force-scroll when the user has scrolled away from the bottom.
- Buttons reflect actual state: disabled while invalid, stop only while running, resume only when resumable.
- Notifications link to the specific completed or failed job.
