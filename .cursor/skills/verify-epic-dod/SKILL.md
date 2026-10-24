---
name: verify-epic-dod
description: >-
  Run PromptVault quality gates before opening a task PR — flutter analyze and
  test per EPICS global DoD.
---

# Verify epic DoD

Satisfy global Definition of Done in [EPICS.md](../../../EPICS.md) before any PR.

## Steps

1. From repo root, run:

   ```bash
   ./scripts/verify_task.sh
   ```

2. If `pubspec.yaml` is missing (pre–E0-T1), skip Flutter commands and verify only planning/docs changes for that task.
3. If the script fails, fix issues and re-run until green.
4. Confirm no unreferenced `TODO` comments in changed files.

## Manual checks (when EPICS says so)

- UI tasks: quick run on Android emulator or device.
- Release tasks: only when `humanGate` is true.

## Fail closed

Do not run **task-pr-workflow** until this skill’s commands pass (or task explicitly has no Flutter yet).
