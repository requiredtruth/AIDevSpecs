# Android and Termux Applications

## Native application defaults

- Prefer a native Android application when deep background work, notifications, storage, or orientation control matters.
- Avoid legacy hybrid wrappers unless the requirement explicitly favors a web wrapper.
- Provide both a usable APK and source/build instructions when delivery requires installation.
- Use an application-owned or user-selected document directory for durable models and generated assets.

## Background work

- Long jobs use a foreground service or platform-appropriate scheduled work.
- Persistent notification shows active work, progress, pause/stop action, and failure state.
- Process death must not mark unfinished work complete.
- Reopening the app reconstructs queue and progress from durable state.

## Mobile UI acceptance

- Controls remain usable in portrait and landscape.
- Orientation changes preserve job and form state.
- Provide an explicit orientation control only when the application workflow benefits from it.
- Avoid repeated auto-scrolling that prevents reading streamed output.
- Large lists and generated assets load incrementally.
- Core offline behavior is verified on a constrained device profile, not only an emulator.

## Termux tooling

- Scripts use the Termux prefix and package manager rather than assuming desktop Linux paths.
- Detect Android storage permission and document user action without requesting credentials.
- Service scripts print the resolved port, process state, and connection command using placeholders.
- Idempotent reruns back up configuration before bounded edits.
