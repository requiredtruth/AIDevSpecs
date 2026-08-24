"""Small atomic JSON state helpers using only the Python standard library."""

from __future__ import annotations

import json
import os
from pathlib import Path
import tempfile
from typing import Any


class StateError(ValueError):
    """Raised when persisted state is absent, malformed, or version-incompatible."""


def load_state(path: str | Path, *, expected_schema: int | None = None) -> dict[str, Any]:
    """Load one JSON object and optionally enforce an exact positive schema version."""
    target = Path(path)
    try:
        value = json.loads(target.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise StateError(f"cannot load state: {exc}") from exc
    if not isinstance(value, dict):
        raise StateError("state root must be an object")
    if expected_schema is not None:
        if expected_schema < 1:
            raise ValueError("expected_schema must be positive")
        if value.get("schema_version") != expected_schema:
            raise StateError("state schema version mismatch")
    return value


def save_state(path: str | Path, value: dict[str, Any], *, mode: int = 0o640) -> None:
    """Atomically save a JSON object beside its target and sync the containing directory."""
    if not isinstance(value, dict):
        raise TypeError("state must be an object")
    target = Path(path)
    target.parent.mkdir(parents=True, exist_ok=True)
    payload = json.dumps(value, indent=2, sort_keys=True, ensure_ascii=False) + "\n"
    temporary: str | None = None
    try:
        descriptor, temporary = tempfile.mkstemp(prefix=f".{target.name}.", dir=target.parent)
        with os.fdopen(descriptor, "w", encoding="utf-8") as handle:
            handle.write(payload)
            handle.flush()
            os.fsync(handle.fileno())
        os.chmod(temporary, mode)
        os.replace(temporary, target)
        temporary = None
        directory = os.open(target.parent, os.O_RDONLY)
        try:
            os.fsync(directory)
        finally:
            os.close(directory)
    finally:
        if temporary is not None:
            try:
                os.unlink(temporary)
            except FileNotFoundError:
                pass
