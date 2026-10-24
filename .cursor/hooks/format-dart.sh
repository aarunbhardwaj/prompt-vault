#!/usr/bin/env bash
# afterFileEdit: format Dart files when the agent edits them.
set -euo pipefail

input="$(cat)"
file_path="$(python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('file_path',''))" <<< "$input" 2>/dev/null || true)"

if [[ -z "$file_path" ]]; then
  exit 0
fi

if [[ "$file_path" == *"/lib/"* && "$file_path" == *.dart ]]; then
  if command -v dart >/dev/null 2>&1; then
    dart format "$file_path" 2>/dev/null || true
  fi
fi

exit 0
