#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f pubspec.yaml ]]; then
  echo "verify_task: no pubspec.yaml — skip Flutter gates (docs/planning tasks only)."
  exit 0
fi

echo "Running flutter pub get..."
flutter pub get

if grep -qE 'build_runner|freezed' pubspec.yaml 2>/dev/null; then
  if grep -q 'build_runner' pubspec.yaml; then
    echo "Running build_runner..."
    dart run build_runner build --delete-conflicting-outputs
  fi
fi

echo "Running flutter analyze..."
flutter analyze

echo "Running flutter test..."
flutter test

echo "verify_task: OK"
