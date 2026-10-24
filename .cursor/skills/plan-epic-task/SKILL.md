---
name: plan-epic-task
description: >-
  Produce an approved per-task implementation plan before coding. Use Plan mode
  in Cursor when available; write .cursor/plans/tasks/<ID>.plan.md; update
  sprint-state planStatus. Required before implement-epic-task.
---

# Plan epic task

Every EPICS task gets a **written plan** before application code. This prevents dangling partial work and scope drift.

## When to run

- After **next-epic-task** sets `currentTask` and `currentBranch`.
- Before **implement-epic-task** (hard gate).

## Steps

1. Read `currentTask` from [.cursor/sprint-state.json](../../../.cursor/sprint-state.json).
2. Copy [docs/TASK_PLAN_TEMPLATE.md](../../../docs/TASK_PLAN_TEMPLATE.md) to  
   `.cursor/plans/tasks/<TASK-ID>.plan.md` (example: `E1-T4.plan.md`).
3. **Use Cursor Plan mode** when the product supports it:
   - Switch to **Plan** (not Agent) for research and plan authoring only.
   - Gather context: EPICS section, [idea.md](../../../idea.md), relevant `lib/` files.
   - Output the filled task plan markdown; do **not** edit app code in Plan mode.
4. Fill the plan: files, steps, test plan, DoD mapping, open questions.
5. Update sprint-state:
   - `planFile`: `.cursor/plans/tasks/<ID>.plan.md`
   - `planStatus`: `draft` while writing; `approved` only when open questions are empty **or** user said to proceed.
6. If open questions exist, set `blocked` or ask the user; stop until resolved.

## Approval rules

| Situation | Action |
|-----------|--------|
| Open questions empty, plan complete | Set `planStatus: "approved"` |
| User confirms plan in chat | Set `planStatus: "approved"` |
| Ambiguous product/architecture choice | Ask user; keep `draft` |

## Verify gate

```bash
python3 scripts/check_plan_gate.py
```

Exit 0 only when `planStatus` is `approved` and `planFile` exists.

## First commit on task branch (recommended)

Commit only the plan file:

`git commit -m "E1-T4: task plan"`

Then run **implement-epic-task**.
