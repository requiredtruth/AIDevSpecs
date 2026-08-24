#!/usr/bin/env sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
command -v python3 >/dev/null 2>&1 || { echo "python3 is required" >&2; exit 1; }
(cd "$ROOT" && python3 -m compileall -q tests && python3 -m unittest discover -s tests -v)
echo "AIDevSpecs verification passed"
