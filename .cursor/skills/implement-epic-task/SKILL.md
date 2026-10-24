---
name: implement-epic-task
description: >-
  Implement the current EPICS task for PromptVault — DoR check, acceptance
  criteria, minimal scope. Use when currentTask is set in sprint-state.
---

# Implement epic task

Implement exactly one task from [EPICS.md](../../../EPICS.md).

## Steps

1. Read `currentTask` from [.cursor/sprint-state.json](../../../.cursor/sprint-state.json).
2. Find the task section in EPICS (e.g. `### E0-T1 —`).
3. **DoR** — confirm every dependency listed in EPICS is in `completedTasks`. If not, run **next-epic-task** instead.
4. Ensure git branch matches `currentBranch` (create from `main` if needed).
5. Implement only what acceptance criteria require; follow [idea.md](../../../idea.md) and `.cursor/rules/`.
6. Do not open a PR until **verify-epic-dod** passes.

## Commit discipline

- Prefix commits with `E0-T1:` (use actual ID).
- One logical commit is fine for small tasks; split if review clarity helps.

## When done coding

Hand off to **verify-epic-dod**, then **task-pr-workflow**.
