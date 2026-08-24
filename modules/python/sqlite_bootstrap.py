"""Transactional, callable SQLite migration primitive."""

from __future__ import annotations

from collections.abc import Callable, Sequence
from dataclasses import dataclass
from pathlib import Path
import sqlite3


@dataclass(frozen=True, slots=True)
class Migration:
    """One ordered migration. Versions must be contiguous positive integers."""

    version: int
    name: str
    apply: Callable[[sqlite3.Connection], None]


def connect_database(path: str | Path, *, timeout_seconds: float = 5.0) -> sqlite3.Connection:
    """Open a local SQLite database with foreign keys, WAL, and a bounded busy timeout."""
    if not 0.1 <= timeout_seconds <= 60:
        raise ValueError("timeout_seconds must be between 0.1 and 60")
    target = Path(path)
    target.parent.mkdir(parents=True, exist_ok=True)
    connection = sqlite3.connect(target, timeout=timeout_seconds, isolation_level=None)
    connection.execute("PRAGMA foreign_keys = ON")
    connection.execute(f"PRAGMA busy_timeout = {int(timeout_seconds * 1000)}")
    connection.execute("PRAGMA journal_mode = WAL")
    connection.execute(
        "CREATE TABLE IF NOT EXISTS schema_migrations ("
        "version INTEGER PRIMARY KEY CHECK(version > 0), "
        "name TEXT NOT NULL, applied_utc TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP)"
    )
    return connection


def apply_migrations(connection: sqlite3.Connection, migrations: Sequence[Migration]) -> int:
    """Apply unapplied migrations one transaction at a time and return the final version."""
    versions = [migration.version for migration in migrations]
    if versions != list(range(1, len(migrations) + 1)):
        raise ValueError("migration versions must be contiguous starting at 1")
    applied = [int(row[0]) for row in connection.execute("SELECT version FROM schema_migrations ORDER BY version")]
    current = applied[-1] if applied else 0
    if applied != list(range(1, current + 1)):
        raise ValueError("database migration history is not contiguous")
    if current > len(migrations):
        raise ValueError("database schema is newer than this migration set")
    for migration in migrations[current:]:
        connection.execute("BEGIN IMMEDIATE")
        try:
            migration.apply(connection)
            connection.execute(
                "INSERT INTO schema_migrations(version, name) VALUES (?, ?)",
                (migration.version, migration.name),
            )
            connection.commit()
        except Exception:
            connection.rollback()
            raise
        current = migration.version
    return current
