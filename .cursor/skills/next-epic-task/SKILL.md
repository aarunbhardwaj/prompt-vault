---
name: next-epic-task
description: >-
  Pick the next ready EPICS task for PromptVault from sprint-state and
  dependency order. Use at session start or after a task PR merges.
---

# Next epic task

Select the next task from [EPICS.md](../../../EPICS.md) that is ready to implement.

## Steps

1. Read [.cursor/sprint-state.json](../../../.cursor/sprint-state.json).
2. If `blocked` is set, stop and report the blocker.
3. Run:

   ```bash
   python3 scripts/next_task.py --pick
   ```

4. Update sprint-state:
   - `currentTask` → chosen ID
   - `currentBranch` → `task/<ID>-<kebab-slug>`
   - `planFile` → null
   - `planStatus` → null (reset; planning starts fresh)
   - Do not add to `completedTasks` until PR is merged.

5. **Next step is always plan-epic-task**, not implement-epic-task.

## Human gate check

If the picked task is **E6-T2**, **E6-T6**, or **E6-T7** and `humanGate` is not `true`, stop and ask the user.

## Output

Report task ID, title, branch name, and: "Run **plan-epic-task** before coding."
