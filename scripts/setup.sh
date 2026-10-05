#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."
for tool in python3 uv; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Missing $tool. Install Python 3 and uv before running setup; see README.md." >&2
    exit 1
  fi
done
python3 --version
uv --version
if [[ ! -x .venv/bin/python ]]; then
  uv venv --no-python-downloads --python "$(command -v python3)" .venv
fi
uv pip sync --python .venv/bin/python requirements.txt
.venv/bin/python -c 'import bleak, serial'
.venv/bin/python research_playground.py selftest
