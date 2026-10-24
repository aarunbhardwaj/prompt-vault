# PromptVault

Local-first Flutter app for saving AI prompts, filling `{{variables}}`, and copying to the clipboard.

## Docs

- [idea.md](idea.md) — product and stack
- [EPICS.md](EPICS.md) — backlog and DoR/DoD
- [AGENTS.md](AGENTS.md) — Cursor Agent SDLC
- [docs/AUTOMATION.md](docs/AUTOMATION.md) — how to run automated task flow
- [docs/GITHUB_SETUP.md](docs/GITHUB_SETUP.md) — branch protection and auto-merge

## Android

| Field | Value |
|-------|-------|
| Application ID | `com.drarun.prompt_vault` |
| minSdk | 23 |

## Development

```bash
flutter pub get
# Code generation (freezed / json_serializable):
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
./scripts/verify_task.sh
```

## Agent kickoff

```text
@AGENTS.md Run PromptVault SDLC: execute current task or pick next from EPICS; stop only if blocked or human gate.
```
