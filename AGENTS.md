# OpenBand 5 research worktrees

This repository contains protocol notes and Python laboratory tools. The current
research client primarily targets WHOOP 4.0. Offline checks do not prove WHOOP 5.0
compatibility or physiological accuracy.

## Setup and checks

- Run `bash scripts/setup.sh`. It uses host Python 3 and uv, syncs the pinned
  platform-specific dependencies into this checkout's `.venv`, then checks
  imports and runs `research_playground.py selftest`. The Amp setup delegates to
  the same entry point. Setup never connects to a band.
- Run `.venv/bin/python research_playground.py selftest` after protocol changes.
  It checks framing and reassembly; it does not cover every decoded field.
- Keep `requirements.in` direct dependency pins and regenerate the platform lock
  with `uv pip compile --universal requirements.in -o requirements.txt` when
  intentionally updating dependencies.
- Import `t3.json` actions for each T3 project/environment. Setup runs on worktree
  creation and waits before the agent starts. Check is manual. A source file
  alone does not activate the actions.

## Parallel and machine boundaries

- Use separate branches and worktrees. Each owns its `.venv`, captures and output.
  Transfer commits between machines rather than mirroring an active checkout.
- Offline decode and selftest can run on macOS or Linux. Bluetooth and serial
  commands require the adapter or charger on the execution host; SSH does not
  forward them. Only one process may own a band or serial device at a time.
- Keep original captures and databases outside Git under the owner's private lab
  directory, such as `~/Library/Application Support/OpenBand5Lab` on macOS.
  Never add personal health data to fixtures or send it to hosted checks.
- `decode_events.py` reads `/tmp/events.json`. Do not run it against another
  task's capture. The setup/check actions do not create or read that file.
- Firmware flags, erase commands and forced optical modes need explicit device
  work authorization. Keep existing command guards and upstream MIT notices.
