#!/usr/bin/env bash
# beforeShellExecution: block destructive git operations.
set -euo pipefail

input="$(cat)"
command="$(python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('command',''))" <<< "$input" 2>/dev/null || true)"

if [[ -z "$command" ]]; then
  echo '{ "permission": "allow" }'
  exit 0
fi

if [[ "$command" =~ git[[:space:]]+config ]]; then
  echo '{
    "permission": "deny",
    "user_message": "git config changes are blocked by project policy.",
    "agent_message": "Do not modify git config. Use existing identity."
  }'
  exit 0
fi

if [[ "$command" =~ git[[:space:]]+push ]] && [[ "$command" =~ (--force|-f) ]] \
  && [[ "$command" =~ (main|master)([^a-zA-Z]|$) ]]; then
  echo '{
    "permission": "deny",
    "user_message": "Force push to main/master is not allowed.",
    "agent_message": "Push to a task/* branch and merge via PR."
  }'
  exit 0
fi

echo '{ "permission": "allow" }'
exit 0
