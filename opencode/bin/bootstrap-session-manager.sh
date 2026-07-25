#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  bootstrap-session-manager.sh [--force]

Creates or recreates the durable OpenCode Session Manager session in
/workspace/home and records it in /workspace/home/SESSIONS.md.

Use this after bootstrapping a new OpenCode server or if SESSIONS.md was lost.

Environment overrides:
  OPENCODE_SESSION_SERVER_URL  default: http://127.0.0.1:4096
  OPENCODE_SESSION_PUBLIC_URL  required public server URL
  OPENCODE_SESSION_MODEL       default: openai/gpt-5.5
  OPENCODE_SESSION_AGENT       default: build
EOF
}

force=0
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "${1:-}" == "--force" ]]; then
  force=1
  shift
fi

if [[ $# -ne 0 ]]; then
  usage >&2
  exit 1
fi

home_dir="/workspace/home"
sessions_file="${home_dir}/SESSIONS.md"
server_url="${OPENCODE_SESSION_SERVER_URL:-http://127.0.0.1:4096}"
public_url="${OPENCODE_SESSION_PUBLIC_URL:-}"
model="${OPENCODE_SESSION_MODEL:-openai/gpt-5.5}"
agent="${OPENCODE_SESSION_AGENT:-build}"
session_title="Session Manager"

if [[ -z "$public_url" ]]; then
  printf 'OPENCODE_SESSION_PUBLIC_URL must be set to the public OpenCode server URL.\n' >&2
  exit 1
fi

existing_manager_id="$(python3 - "$sessions_file" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
if not path.exists():
    raise SystemExit(0)

content = path.read_text()
match = re.search(r"Manager session:\n- `(ses_[^`]+)` - Session Manager", content)
if match:
    print(match.group(1))
PY
)"

if [[ -n "$existing_manager_id" && "$force" -eq 0 ]]; then
  printf 'Session Manager already registered: %s\n' "$existing_manager_id"
  printf 'Use --force to create and register a replacement manager session.\n'
  exit 0
fi

before_json="$(cd "$home_dir" && opencode session list --format json --max-count 200 2>/dev/null || printf '[]')"

session_id=""
if [[ "$force" -eq 0 ]]; then
  session_id="$({
    python3 - "$before_json" "$home_dir" "$session_title" <<'PY'
import json
import sys

sessions = json.loads(sys.argv[1])
directory = sys.argv[2]
title = sys.argv[3]

candidates = [
    item for item in sessions
    if item.get("directory") == directory and item.get("title") == title
]
candidates.sort(key=lambda item: item.get("created", 0), reverse=True)
if candidates:
    print(candidates[0]["id"])
PY
  } || true)"
fi

prompt='Session Manager initialized in /workspace/home. Reply exactly: READY'

if [[ -z "$session_id" ]]; then
  opencode run \
    --attach "$server_url" \
    --dir "$home_dir" \
    --share \
    --title "$session_title" \
    --agent "$agent" \
    --model "$model" \
    "$prompt" >/dev/null 2>&1 || true

  after_json="$(cd "$home_dir" && opencode session list --format json --max-count 200)"

  session_id="$({
    python3 - "$before_json" "$after_json" "$home_dir" "$session_title" <<'PY'
import json
import sys

before = json.loads(sys.argv[1])
after = json.loads(sys.argv[2])
directory = sys.argv[3]
title = sys.argv[4]

before_ids = {item["id"] for item in before}
candidates = [
    item for item in after
    if item["id"] not in before_ids
    and item.get("directory") == directory
    and item.get("title") == title
]

if not candidates:
    candidates = [
        item for item in after
        if item.get("directory") == directory and item.get("title") == title
    ]

candidates.sort(key=lambda item: item.get("created", 0), reverse=True)
if candidates:
    print(candidates[0]["id"])
PY
  } || true)"
fi

if [[ -z "$session_id" ]]; then
  printf 'Could not determine the Session Manager session ID.\n' >&2
  exit 1
fi

server_token="$(printf '%s' "$public_url" | base64 | tr -d '\n=')"
session_url="${public_url}/server/${server_token}/session/${session_id}"

python3 - "$sessions_file" "$session_id" "$session_title" "$session_url" "$existing_manager_id" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
session_id = sys.argv[2]
title = sys.argv[3]
url = sys.argv[4]
old_id = sys.argv[5]

entry = f"Manager session:\n- `{session_id}` - {title}\n  {url}\n\n"
default_body = (
    "# OpenCode Sessions\n\n"
    "Active session URLs live here so they can be retrieved from another device.\n\n"
    "Rules:\n"
    "- Keep exactly one manager session in the Manager session section.\n"
    "- Add a new task session URL when a worktree-backed session starts.\n"
    "- Remove a task session URL when that session is completed.\n\n"
    "Current active sessions:\n"
)

if path.exists():
    content = path.read_text()
else:
    content = default_body

if "# OpenCode Sessions" not in content:
    content = default_body
else:
    content = content.replace(
        "Rules:\n"
        "- Add a new session URL when a session starts.\n"
        "- Remove the session URL when that session is completed.\n",
        "Rules:\n"
        "- Keep exactly one manager session in the Manager session section.\n"
        "- Add a new task session URL when a worktree-backed session starts.\n"
        "- Remove a task session URL when that session is completed.\n",
    )

content = re.sub(
    r"Manager session:\n- `ses_[^`]+` - Session Manager\n  \S+\n\n?",
    "",
    content,
)
content = content.replace("# OpenCode Sessions\n\n", f"# OpenCode Sessions\n\n{entry}", 1)

if "Current active sessions:\n" not in content:
    if not content.endswith("\n"):
        content += "\n"
    content += "\nCurrent active sessions:\n"

if old_id and old_id != session_id:
    content = content.replace(old_id, f"{old_id} (replaced by {session_id})")

path.write_text(content)
PY

printf 'manager_session_id=%s\n' "$session_id"
printf 'manager_session_url=%s\n' "$session_url"
printf 'sessions_file=%s\n' "$sessions_file"
