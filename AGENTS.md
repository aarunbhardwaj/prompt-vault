# PromptVault — Agent SDLC

You are implementing **PromptVault** using agile, single-task increments. Follow this file before writing application code.

## Sources of truth

| File | Role |
|------|------|
| [EPICS.md](EPICS.md) | Backlog, DoR/DoD, acceptance criteria per task ID |
| [.cursor/sprint-state.json](.cursor/sprint-state.json) | Current task, completed tasks, blockers, human gates |
| [idea.md](idea.md) | Product vision and Flutter stack |

## Session startup

1. Read `.cursor/sprint-state.json`.
2. If `blocked` is non-null, stop and tell the user the blocker; do not implement until cleared.
3. If `currentTask` is null, run skill **next-epic-task** (or `python3 scripts/next_task.py --pick`) and set `currentTask` + `currentBranch`.
4. Open the matching section in **EPICS.md** for DoR and acceptance criteria.
5. Confirm DoR (dependencies in `completedTasks`). If not ready, pick another task or stop.

## One task at a time

- Work **exactly one** task ID per branch and PR.
- Branch: `task/<ID>-<kebab-slug>` (example: `task/E0-T1-flutter-create`).
- Commit prefix: `E0-T1: <imperative summary>`.
- Do not start E7 or out-of-scope features from EPICS.
- Minimize diff scope; match architecture in [idea.md](idea.md).

## Human gates (`humanGate: true`)

Stop and ask the user before implementing when:

- `.cursor/sprint-state.json` has `"humanGate": true`, or
- Task is **E6-T2** (release signing / keystore), **E6-T6** (Play internal test upload), or **E6-T7** (production rollout), unless the user already set `humanGate: true` to proceed.

For **E6-T4** (privacy policy URL), pause if no hosted URL exists yet.

## Implementation loop

1. Checkout or create `currentBranch` from latest `main`.
2. Follow skill **implement-epic-task** for the active ID.
3. Before PR, run skill **verify-epic-dod** (`scripts/verify_task.sh` when Flutter exists).
4. Run skill **task-pr-workflow** (push, open PR, enable auto-merge when policy allows).
5. If CI fails, use the **autopilot** skill (personal) on that PR until green or blocked.
6. After merge: append task ID to `completedTasks`, set `currentTask` to null, clear `currentBranch`, commit sprint-state on `main` if needed.

## Pull request body template

```markdown
## Task
<ID> — <title from EPICS>

## EPICS acceptance
- [ ] … (copy bullets from EPICS for this task)

## Verification
- [ ] `flutter analyze` (if applicable)
- [ ] `flutter test` (if applicable)
- [ ] Manual check on Android (if UI)

## Test plan
<how you verified>
```

## Subagents

- **explore**: codebase search, file discovery.
- Do not run Bugbot unless the user asks.
- **autopilot**: only when a task PR has failing required checks or unresolved review threads.

## Default kickoff prompt

> Run PromptVault SDLC: execute `currentTask` from sprint-state or pick the next ready EPICS task; implement, verify DoD, open PR; stop only if blocked or human gate.

## Chaining tasks

After finishing a session with a merged PR, continue with the next task per **next-epic-task** unless the user said to stop.
