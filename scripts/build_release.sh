#!/usr/bin/env bash
# E6-T3: Build signed release App Bundle and copy to dist/ for Play upload.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f android/key.properties ]]; then
  echo "build_release: missing android/key.properties (see android/key.properties.example)" >&2
  exit 1
fi

bash scripts/verify_task.sh

VERSION="$(grep '^version:' pubspec.yaml | sed 's/version: //' | tr -d ' ')"
OUT_AAB="build/app/outputs/bundle/release/app-release.aab"
DIST_DIR="$ROOT/dist"
DIST_AAB="$DIST_DIR/prompt-vault-${VERSION}.aab"

flutter build appbundle --release

mkdir -p "$DIST_DIR"
cp "$OUT_AAB" "$DIST_AAB"
echo "build_release: OK → $DIST_AAB"
