#!/usr/bin/env python3
"""Pick next EPICS task from sprint-state and dependency graph."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STATE_PATH = ROOT / ".cursor" / "sprint-state.json"

# Task order for deterministic pick among ready tasks.
TASK_ORDER = [
    "E0-T1", "E0-T2", "E0-T3", "E0-T4", "E0-T5",
    "E1-T1", "E1-T2", "E1-T3", "E1-T4", "E1-T5",
    "E2-T1", "E2-T2", "E2-T3", "E2-T4", "E2-T5",
    "E3-T1", "E3-T2", "E3-T3", "E3-T4",
    "E4-T1", "E4-T2", "E4-T3", "E4-T4",
    "E5-T1", "E5-T2", "E5-T3",
    "E6-T1", "E6-T2", "E6-T4", "E6-T5", "E6-T3",
    "E6-T6", "E6-T7", "E6-T8",
]

# EPICS dependency map (E6-T3 waits for feature epics complete).
DEPS: dict[str, list[str]] = {
    "E0-T1": [],
    "E0-T2": ["E0-T1"],
    "E0-T3": ["E0-T1"],
    "E0-T4": ["E0-T2", "E0-T3"],
    "E0-T5": ["E0-T4"],
    "E1-T1": ["E0-T2"],
    "E1-T2": ["E1-T1"],
    "E1-T3": ["E1-T2"],
    "E1-T4": ["E1-T3"],
    "E1-T5": ["E1-T3"],
    "E2-T1": ["E1-T4", "E0-T4"],
    "E2-T2": ["E2-T1"],
    "E2-T3": ["E2-T1"],
    "E2-T4": ["E2-T1"],
    "E2-T5": ["E2-T2", "E2-T3"],
    "E3-T1": ["E1-T4", "E0-T4"],
    "E3-T2": ["E0-T3"],
    "E3-T3": ["E3-T1", "E3-T2"],
    "E3-T4": ["E3-T1"],
    "E4-T1": ["E3-T2", "E1-T4", "E0-T4"],
    "E4-T2": ["E4-T1"],
    "E4-T3": ["E4-T2"],
    "E4-T4": ["E4-T3"],
    "E5-T1": ["E1-T1"],
    "E5-T2": ["E5-T1", "E1-T3"],
    "E5-T3": ["E5-T2"],
    "E6-T1": ["E0-T1"],
    "E6-T2": ["E0-T1"],
    "E6-T4": [],
    "E6-T5": ["E6-T1"],
    "E6-T3": ["E6-T2", "E2-T5", "E3-T4", "E4-T4", "E5-T3"],
    "E6-T6": ["E6-T3", "E6-T5"],
    "E6-T7": ["E6-T6"],
    "E6-T8": ["E6-T7"],
}

HUMAN_GATE_TASKS = {"E6-T2", "E6-T6", "E6-T7"}


def load_state() -> dict:
    if not STATE_PATH.exists():
        return {"completedTasks": [], "humanGate": False}
    with STATE_PATH.open(encoding="utf-8") as f:
        return json.load(f)


def ready(task_id: str, completed: set[str]) -> bool:
    return all(dep in completed for dep in DEPS.get(task_id, []))


def pick_next(completed: set[str]) -> str | None:
    for task_id in TASK_ORDER:
        if task_id in completed:
            continue
        if ready(task_id, completed):
            return task_id
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description="EPICS task picker")
    parser.add_argument("--pick", action="store_true", help="Print next ready task ID")
    parser.add_argument("--deps", metavar="ID", help="Print dependencies for task")
    parser.add_argument("--json", action="store_true", help="JSON output for --pick")
    args = parser.parse_args()

    if args.deps:
        deps = DEPS.get(args.deps)
        if deps is None:
            print(f"Unknown task: {args.deps}", file=sys.stderr)
            return 1
        print(" ".join(deps) if deps else "(none)")
        return 0

    state = load_state()
    completed = set(state.get("completedTasks") or [])
    current = state.get("currentTask")

    if args.pick:
        if current and current not in completed:
            task = current
        else:
            task = pick_next(completed)
        if task is None:
            print("NONE")
            return 0
        if args.json:
            payload = {
                "taskId": task,
                "humanGateRequired": task in HUMAN_GATE_TASKS
                and not state.get("humanGate"),
                "deps": DEPS.get(task, []),
            }
            print(json.dumps(payload))
        else:
            print(task)
        return 0

    parser.print_help()
    return 0


if __name__ == "__main__":
    sys.exit(main())
