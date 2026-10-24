#!/usr/bin/env bash
# stop: optionally chain to the next SDLC task when not blocked.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
STATE="$ROOT/.cursor/sprint-state.json"

if [[ ! -f "$STATE" ]]; then
  exit 0
fi

python3 <<PY
import json
from pathlib import Path
state_path = Path("$STATE")
s = json.loads(state_path.read_text(encoding="utf-8"))
blocked = s.get("blocked")
if blocked:
    raise SystemExit(0)
msg = (
    "PromptVault SDLC: If the current task PR is merged, update sprint-state "
    "completedTasks, then run next-epic-task and implement the next ready EPICS "
    "task per AGENTS.md. Stop only for humanGate (E6 signing/store) or blockers."
)
print(json.dumps({"followup_message": msg}))
PY

exit 0
