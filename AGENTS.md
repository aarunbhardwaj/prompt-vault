# PromptVault — Agent SDLC

You are implementing **PromptVault** using agile, single-task increments: **Plan → Implement → Verify → PR**. Follow this file before writing application code.

## Sources of truth

| File | Role |
|------|------|
| [EPICS.md](EPICS.md) | Backlog, DoR/DoD, acceptance criteria per task ID |
| [.cursor/sprint-state.json](.cursor/sprint-state.json) | Current task, plan gate, completed tasks, blockers |
| [.cursor/plans/tasks/](.cursor/plans/tasks/) | Per-task implementation plans (required before code) |
| [idea.md](idea.md) | Product vision and Flutter stack |

## Session startup

1. Read `.cursor/sprint-state.json`.
2. If `blocked` is non-null, stop and report the blocker.
3. If `currentTask` is null, run **next-epic-task** (or `python3 scripts/next_task.py --pick`) and set `currentTask`, `currentBranch`, reset `planStatus` to `draft`.
4. Open the EPICS section for the active task.

## SDLC loop (every task)

```text
next-epic-task → plan-epic-task → [user/plan approve] → implement-epic-task
  → verify-epic-dod → task-pr-workflow → merge → update completedTasks
```

### 1. Plan (mandatory)

- Run skill **plan-epic-task**.
- Prefer **Cursor Plan mode** for research and plan writing; no app code in Plan mode.
- Artifact: `.cursor/plans/tasks/<TASK-ID>.plan.md` from [docs/TASK_PLAN_TEMPLATE.md](docs/TASK_PLAN_TEMPLATE.md).
- Set `planFile` and `planStatus` in sprint-state (`draft` → `approved`).
- Gate: `python3 scripts/check_plan_gate.py` must pass before implementation.

**Do not** edit Flutter/lib code until the plan is **approved** and the gate script passes.

### 2. Implement

- Checkout `currentBranch` from latest `main`.
- Run **implement-epic-task** (follow the approved plan file).
- One task ID per branch; commits prefixed `E0-T1:` etc.

### 3. Verify and ship

- **verify-epic-dod** (`scripts/verify_task.sh`).
- **task-pr-workflow** (push, PR, auto-merge when configured).
- **autopilot** only if CI or review threads block merge.

### 4. After merge

- Append task ID to `completedTasks`.
- Clear `currentTask`, `currentBranch`, `planFile`; set `planStatus` to null.
- Commit sprint-state on `main` if needed.

## Sprint-state plan fields

| Field | Values |
|-------|--------|
| `planFile` | Relative path, e.g. `.cursor/plans/tasks/E1-T4.plan.md` |
| `planStatus` | `null`, `draft`, or `approved` |

## Human gates (`humanGate: true`)

Stop before implement when:

- `humanGate` is true, or
- Task is **E6-T2**, **E6-T6**, or **E6-T7** (unless user cleared gate), or
- **E6-T4** without a privacy policy URL.

## Subagents

- **explore**: codebase search during **Plan** or Implement.
- No Bugbot unless the user asks.

## Default kickoff prompt

> Run PromptVault SDLC: pick or continue `currentTask`; if no approved plan, run plan-epic-task (Plan mode) first; then implement, verify, PR; stop only for blocked, human gate, or open plan questions.

## Chaining tasks

After merge, run **next-epic-task** then **plan-epic-task** before any new code.
