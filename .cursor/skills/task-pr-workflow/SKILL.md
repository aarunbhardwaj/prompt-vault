---
name: task-pr-workflow
description: >-
  Push task branch, open GitHub PR with EPICS checklist, enable auto-merge when
  CI is expected to pass.
---

# Task PR workflow

Open a PR for the current EPICS task after DoD verification.

## Preconditions

- **verify-epic-dod** passed (or docs-only task with no Flutter).
- On `currentBranch` from [.cursor/sprint-state.json](../../../.cursor/sprint-state.json).
- All changes committed.

## Steps

1. Push:

   ```bash
   git push -u origin HEAD
   ```

2. Create PR (use task ID in title):

   ```bash
   gh pr create --title "E0-T1: Create Flutter project" --body-file - <<'EOF'
   ## Task
   E0-T1 — Create Flutter project

   ## EPICS acceptance
   - [ ] (paste from EPICS)

   ## Verification
   - [ ] flutter analyze
   - [ ] flutter test

   ## Test plan
   ...
   EOF
   ```

   Adjust title/body for the active task.

3. Enable auto-merge when squash merge is allowed:

   ```bash
   gh pr merge --auto --squash
   ```

4. Watch checks:

   ```bash
   gh pr checks --watch
   ```

5. If checks fail, use the **autopilot** skill on this PR; do not merge manually unless auto-merge is unavailable.

## After merge

1. Checkout `main` and pull.
2. Append task ID to `completedTasks` in sprint-state; set `currentTask` and `currentBranch` to null.
3. Commit sprint-state update on `main` if your workflow keeps state on main (recommended).
4. Run **next-epic-task** to continue.

## Do not

- Force-push to `main`.
- Merge E6 signing/store tasks without `humanGate`.
