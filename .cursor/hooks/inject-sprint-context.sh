#!/usr/bin/env bash
# sessionStart: inject PromptVault sprint context for the agent.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
STATE="$ROOT/.cursor/sprint-state.json"

if [[ ! -f "$STATE" ]]; then
  echo '{"additional_context": "PromptVault: no sprint-state.json found. Read AGENTS.md and EPICS.md."}'
  exit 0
fi

python3 - <<'PY' "$STATE"
import json, sys
path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    s = json.load(f)
task = s.get("currentTask") or "(none — run next-epic-task)"
branch = s.get("currentBranch") or "(none)"
blocked = s.get("blocked")
done = ", ".join(s.get("completedTasks") or []) or "(none)"
gate = s.get("humanGate", False)
lines = [
    "PromptVault SDLC context (auto-injected):",
    f"- currentTask: {task}",
    f"- currentBranch: {branch}",
    f"- completedTasks: {done}",
    f"- humanGate: {gate}",
    "- Read AGENTS.md, EPICS.md, .cursor/sprint-state.json before coding.",
]
if blocked:
    lines.append(f"- BLOCKED: {blocked}")
ctx = "\n".join(lines)
print(json.dumps({"additional_context": ctx}))
PY

exit 0
