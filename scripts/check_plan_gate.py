#!/usr/bin/env python3
"""Exit 0 when current task has an approved plan file (SDLC gate before implement)."""

from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STATE_PATH = ROOT / ".cursor" / "sprint-state.json"


def main() -> int:
    if not STATE_PATH.exists():
        print("check_plan_gate: missing sprint-state.json", file=sys.stderr)
        return 1

    state = json.loads(STATE_PATH.read_text(encoding="utf-8"))
    status = state.get("planStatus")
    plan_file = state.get("planFile")

    if status != "approved":
        print(
            f"check_plan_gate: planStatus is {status!r}, need 'approved'",
            file=sys.stderr,
        )
        return 1

    if not plan_file:
        print("check_plan_gate: planFile not set", file=sys.stderr)
        return 1

    path = ROOT / plan_file
    if not path.is_file():
        print(f"check_plan_gate: missing {plan_file}", file=sys.stderr)
        return 1

    print(f"check_plan_gate: OK ({plan_file})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
