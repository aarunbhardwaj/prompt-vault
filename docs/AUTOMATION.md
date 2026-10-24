# PromptVault — Cursor automation

Local Agent SDLC with minimal human input. Orchestration hub: [AGENTS.md](../AGENTS.md).

## Quick start

1. Open this repo in Cursor **Agents** (not only Chat).
2. Ensure git remote exists and GitHub settings below are done (one-time).
3. Prompt:

   ```text
   @AGENTS.md Run PromptVault SDLC: execute current task or pick next from EPICS; stop only if blocked or human gate.
   ```

4. Optional continuous loop after each agent stop (local):

   ```text
   /loop 0m @AGENTS.md continue PromptVault task pipeline per sprint-state
   ```

## Sprint state

File: [.cursor/sprint-state.json](../.cursor/sprint-state.json) (source of truth).

| Field | Meaning |
|-------|---------|
| `currentTask` | Active EPICS ID (e.g. `E0-T1`) or `null` after merge |
| `currentBranch` | Git branch for this task |
| `completedTasks` | Merged task IDs |
| `blocked` | Non-null string pauses all work until cleared |
| `humanGate` | Must be `true` before E6 signing / store upload tasks |

Human mirror (optional): [SPRINT.md](SPRINT.md).

### Block / resume

```json
"blocked": "Waiting for Play Console access"
```

Clear with `"blocked": null` to resume.

## Skills (project)

| Skill | Path |
|-------|------|
| next-epic-task | `.cursor/skills/next-epic-task/SKILL.md` |
| implement-epic-task | `.cursor/skills/implement-epic-task/SKILL.md` |
| verify-epic-dod | `.cursor/skills/verify-epic-dod/SKILL.md` |
| task-pr-workflow | `.cursor/skills/task-pr-workflow/SKILL.md` |

## Hooks

Configured in [.cursor/hooks.json](../.cursor/hooks.json):

- **sessionStart** — injects current task context
- **afterFileEdit** — `dart format` on edited Dart files
- **beforeShellExecution** — blocks force-push to main and `git config` changes
- **stop** — suggests continuing SDLC when not blocked

Verify in Cursor: Settings → Hooks.

## Helper scripts

```bash
python3 scripts/next_task.py --pick      # next ready task ID
python3 scripts/next_task.py --deps E2-T1 # show dependencies
./scripts/verify_task.sh                 # analyze + test (requires pubspec.yaml)
```

## CI

Workflow: [.github/workflows/flutter_ci.yml](../.github/workflows/flutter_ci.yml)

Runs on PRs and pushes to `task/**` when `pubspec.yaml` exists.

## GitHub one-time setup

Do these in GitHub for the repository (Settings → General / Branches):

1. **Allow squash merging** (recommended for task PRs).
2. **Enable auto-merge** (Settings → General → Allow auto-merge).
3. **Branch protection on `main`**:
   - Require status check **Flutter CI** (or workflow job name `analyze_and_test`).
   - Require branches to be up to date before merging (optional but recommended).
4. **Do not** allow force-push to `main`.

Optional CLI (after `gh auth login` and repo exists):

```bash
gh repo edit --enable-auto-merge --enable-squash-merge
```

Branch protection often requires GitHub Pro or a public repo; if API fails, configure in the web UI using [GITHUB_SETUP.md](GITHUB_SETUP.md).

## Cursor workspace (recommended)

- **Auto-run**: In Cursor, allow the agent to run terminal commands for this workspace to reduce approval friction (you control this in Cursor settings).
- **Format on save**: Project [.vscode/settings.json](../.vscode/settings.json) enables Dart formatting.

## What stays manual

- Upload keystore creation and backup (E6-T2)
- Play Console production steps (E6-T6, E6-T7) unless `humanGate: true`
- Closed testing 12 testers × 14 days if Play Console requires it
- Product calls (app ID, final display name) if not already in EPICS

## Optional later

- Cursor **Cloud Agents** + subscription timers for CI watch
- Cursor **Automations** on git push (if you move off local-only Agent)
