from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import re
import sqlite3
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


def load_module(name: str, relative: str):
    spec = importlib.util.spec_from_file_location(name, ROOT / relative)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {relative}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


atomic_state = load_module("atomic_state", "modules/python/atomic_state.py")
sqlite_bootstrap = load_module("sqlite_bootstrap", "modules/python/sqlite_bootstrap.py")


class AtomicStateTests(unittest.TestCase):
    def test_round_trip_and_schema(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "nested" / "state.json"
            value = {"schema_version": 1, "status": "current"}
            atomic_state.save_state(target, value)
            self.assertEqual(atomic_state.load_state(target, expected_schema=1), value)
            self.assertEqual(target.stat().st_mode & 0o777, 0o640)

    def test_rejects_non_object(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "state.json"
            target.write_text("[]", encoding="utf-8")
            with self.assertRaisesRegex(atomic_state.StateError, "root"):
                atomic_state.load_state(target)


class SQLiteTests(unittest.TestCase):
    def test_migrations_are_idempotent(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            connection = sqlite_bootstrap.connect_database(Path(directory) / "data" / "app.sqlite")

            def first(db: sqlite3.Connection) -> None:
                db.execute("CREATE TABLE items(id INTEGER PRIMARY KEY, value TEXT NOT NULL)")

            migrations = [sqlite_bootstrap.Migration(1, "create-items", first)]
            self.assertEqual(sqlite_bootstrap.apply_migrations(connection, migrations), 1)
            self.assertEqual(sqlite_bootstrap.apply_migrations(connection, migrations), 1)
            self.assertEqual(connection.execute("PRAGMA foreign_keys").fetchone()[0], 1)
            connection.close()

    def test_failed_migration_rolls_back_marker(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            connection = sqlite_bootstrap.connect_database(Path(directory) / "app.sqlite")

            def broken(db: sqlite3.Connection) -> None:
                db.execute("CREATE TABLE partial(id INTEGER)")
                raise RuntimeError("synthetic failure")

            with self.assertRaisesRegex(RuntimeError, "synthetic"):
                sqlite_bootstrap.apply_migrations(connection, [sqlite_bootstrap.Migration(1, "broken", broken)])
            self.assertEqual(connection.execute("SELECT COUNT(*) FROM schema_migrations").fetchone()[0], 0)
            self.assertIsNone(connection.execute("SELECT name FROM sqlite_master WHERE name='partial'").fetchone())
            connection.close()


class CorpusTests(unittest.TestCase):
    def test_json_files_parse(self) -> None:
        for path in ROOT.rglob("*.json"):
            json.loads(path.read_text(encoding="utf-8"))

    def test_no_unresolved_template_in_specs(self) -> None:
        for path in (ROOT / "specs").glob("*.md"):
            self.assertNotIn("[TODO]", path.read_text(encoding="utf-8"), path.name)

    def test_relative_markdown_links_resolve(self) -> None:
        link_pattern = re.compile(r"\[[^]]+\]\(([^)#]+)(?:#[^)]+)?\)")
        for path in ROOT.rglob("*.md"):
            for target in link_pattern.findall(path.read_text(encoding="utf-8")):
                self.assertTrue((path.parent / target).resolve().is_file(), f"{path}: missing {target}")


if __name__ == "__main__":
    unittest.main()
