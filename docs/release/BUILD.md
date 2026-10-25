# Release build (E6-T3)

## Version

Release **1.0.0** (`versionCode` **1**) — from [`pubspec.yaml`](../../pubspec.yaml):

```yaml
version: 1.0.0+1
```

## Prerequisites

- [`android/key.properties`](../../android/key.properties) pointing at your upload keystore (E6-T2).
- Flutter stable, Android SDK.

## Build

```bash
./scripts/build_release.sh
```

This runs `scripts/verify_task.sh`, then `flutter build appbundle --release` with **R8** (Flutter default for release).

## Artifact

| File | Purpose |
|------|---------|
| `build/app/outputs/bundle/release/app-release.aab` | Gradle output |
| `dist/prompt-vault-1.0.0+1.aab` | Copy for Play Console upload (gitignored) |

Upload the `dist/` copy in **Internal testing** (E6-T6).

## Smoke after minify

Install a release build on a device or emulator:

```bash
flutter build apk --release
flutter install --release
```

Exercise library, editor, runner, and offline mode before promoting tracks.
