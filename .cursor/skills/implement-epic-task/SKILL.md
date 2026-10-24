---
name: implement-epic-task
description: >-
  Implement the current EPICS task after an approved task plan exists. Use only
  when planStatus is approved and check_plan_gate.py passes.
---

# Implement epic task

Implement exactly one task from [EPICS.md](../../../EPICS.md), following the approved plan file.

## Preconditions (hard gate)

```bash
python3 scripts/check_plan_gate.py
```

If this fails, run **plan-epic-task** first. **Do not write application code.**

## Steps

1. Read `currentTask` and open `planFile` from sprint-state.
2. **DoR** — dependencies in `completedTasks`.
3. Checkout `currentBranch` from latest `main`.
4. Implement only what the plan and EPICS acceptance criteria specify.
5. Do not open a PR until **verify-epic-dod** passes.

## Commit discipline

- Prefix: `E0-T1: <summary>` (use actual ID).
- Optional first commit on branch: task plan only (`E1-T4: task plan`).

## When done

**verify-epic-dod** → **task-pr-workflow**.
