# GitHub setup checklist

One-time configuration for automated task PRs and auto-merge.

## Repository

- [ ] Remote `origin` points to GitHub
- [ ] Default branch is `main`
- [ ] `.github/workflows/flutter_ci.yml` present

## Merge settings

Path: **Settings → General → Pull Requests**

- [ ] Allow **squash** merging
- [ ] Allow **auto-merge**

## Branch protection

Path: **Settings → Branches → Add rule** for `main`

- [ ] Require a pull request before merging
- [ ] Require status checks to pass: **analyze_and_test** (Flutter CI job)
- [ ] Do not allow bypassing the above settings (recommended)
- [ ] Restrict force pushes (deny)

## Agent workflow

Per task:

1. Branch `task/<ID>-<slug>` from `main`
2. Push and open PR with template
3. `gh pr merge --auto --squash` when local DoD is met
4. Wait for CI green; auto-merge completes
5. Update `.cursor/sprint-state.json` on `main`

## Smoke test (first task)

After E0-T1 implementation:

```bash
git checkout -b task/E0-T1-flutter-create
# ... commits ...
git push -u origin HEAD
gh pr create --fill
gh pr merge --auto --squash
gh pr checks --watch
```

Confirm merge and CI on GitHub.

## Troubleshooting

| Issue | Action |
|-------|--------|
| Auto-merge disabled | Enable in repo settings |
| Required check missing | Push a commit with `pubspec.yaml` so CI runs once |
| `gh` not authenticated | `gh auth login` |
| Branch protection not available | Use manual merge until plan tier allows rules |
