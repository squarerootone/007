#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  request-session-cleanup.sh [target-session-id-or-title] [context...]

Sends a cleanup handoff request to the registered Session Manager session.
Run this from a task session when the user asks to end/clean up the session.

Environment overrides:
  OPENCODE_SESSION_SERVER_URL  default: http://127.0.0.1:4096
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

target="${1:-}"
if [[ $# -gt 0 ]]; then
  shift
fi
context="$*"

home_dir="/workspace/home"
sessions_file="${home_dir}/SESSIONS.md"
server_url="${OPENCODE_SESSION_SERVER_URL:-http://127.0.0.1:4096}"

manager_id="$(python3 - "$sessions_file" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
if not path.exists():
    raise SystemExit("SESSIONS.md does not exist. Bootstrap the manager first.")

content = path.read_text()
match = re.search(r"Manager session:\n- `(ses_[^`]+)` - Session Manager", content)
if not match:
    raise SystemExit("No Session Manager is registered. Run bootstrap-session-manager.sh first.")
print(match.group(1))
PY
)"

if [[ -z "$target" ]]; then
  current_dir="$(pwd -P)"
  sessions_json="$(opencode session list --format json --max-count 200)"
  target="$(python3 - "$current_dir" "$sessions_json" <<'PY'
import json
import sys

current_dir = sys.argv[1]
sessions = json.loads(sys.argv[2])
candidates = [item for item in sessions if item.get("directory") == current_dir]
candidates.sort(key=lambda item: item.get("updated", item.get("created", 0)), reverse=True)
if candidates:
    print(candidates[0]["id"])
PY
)"
  if [[ -z "$target" ]]; then
    printf 'Could not infer current session from directory: %s\n' "$current_dir" >&2
    printf 'Pass a session ID, URL, or title explicitly.\n' >&2
    exit 1
  fi
fi

message="Clean up target session ${target}. Operate as the Session Manager from /workspace/home. Inspect /workspace/home/SESSIONS.md, identify the session, check its worktree and git branch safety, clean the worktree/local branch only when safety checks pass. If cleanup is dirty, unmerged, ambiguous, or otherwise unsafe, stop and ask for explicit approval in the manager session; do not treat this handoff message as unsafe-cleanup approval. Remove the task session from the registry after cleanup, report the result, and ask for confirmation before deleting the target OpenCode session. Never delete the Session Manager session."
if [[ -n "$context" ]]; then
  message="${message} Additional context: ${context}"
fi

opencode run \
  --attach "$server_url" \
  --session "$manager_id" \
  --dir "$home_dir" \
  "$message"

printf 'cleanup_request_sent_to=%s\n' "$manager_id"
