#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  start-session.sh <repo-name> <topic-slug> <prompt...>

Creates a git worktree under /workspace/home/worktrees, starts a new OpenCode
session against the local server in that worktree, and appends the session URL
to /workspace/home/SESSIONS.md.

The topic slug is used under /workspace/home/worktrees/<repo-name>/, the branch
is created as feat/<topic-slug>, and the title is derived from the topic slug.

Environment overrides:
  OPENCODE_SESSION_SERVER_URL  default: http://127.0.0.1:4096
  OPENCODE_SESSION_PUBLIC_URL  required public server URL
  OPENCODE_SESSION_MODEL       default: openai/gpt-5.4
  OPENCODE_SESSION_AGENT       default: build
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 3 ]]; then
  usage >&2
  exit 1
fi

repo_name="$1"
topic_slug="$2"
shift 2
prompt="$*"

repos_dir="/workspace/home/repos"
worktrees_dir="/workspace/home/worktrees"
sessions_file="/workspace/home/SESSIONS.md"
server_url="${OPENCODE_SESSION_SERVER_URL:-http://127.0.0.1:4096}"
public_url="${OPENCODE_SESSION_PUBLIC_URL:-}"
model="${OPENCODE_SESSION_MODEL:-openai/gpt-5.4}"
agent="${OPENCODE_SESSION_AGENT:-build}"

repo_path="${repos_dir}/${repo_name}"
repo_worktrees_dir="${worktrees_dir}/${repo_name}"
worktree_path="${repo_worktrees_dir}/${topic_slug}"
branch_name="feat/${topic_slug}"
session_title="$(python3 - "$topic_slug" <<'PY'
import sys

print(sys.argv[1].replace('-', ' ').replace('_', ' ').title())
PY
)"

if [[ -z "$public_url" ]]; then
  printf 'OPENCODE_SESSION_PUBLIC_URL must be set to the public OpenCode server URL.\n' >&2
  exit 1
fi

if [[ ! -d "$repo_path/.git" ]]; then
  printf 'Repo not found: %s\n' "$repo_path" >&2
  exit 1
fi

if [[ -e "$worktree_path" ]]; then
  printf 'Worktree already exists: %s\n' "$worktree_path" >&2
  exit 1
fi

mkdir -p "$repo_worktrees_dir"
git -C "$repo_path" worktree add -b "$branch_name" "$worktree_path" >/dev/null

before_json="$(cd "$worktree_path" && opencode session list --format json --max-count 200 2>/dev/null || echo "[]")"

opencode run \
  --attach "$server_url" \
  --dir "$worktree_path" \
  --share \
  --title "$session_title" \
  --agent "$agent" \
  --model "$model" \
  "$prompt" >/dev/null 2>&1 || true

after_json="$(cd "$worktree_path" && opencode session list --format json --max-count 200)"

session_id="$({
  python3 - "$before_json" "$after_json" "$worktree_path" "$session_title" <<'PY'
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

if [[ -z "$session_id" ]]; then
  printf 'Created worktree, but could not determine the new session ID.\n' >&2
  exit 1
fi

server_token="$(printf '%s' "$public_url" | base64 | tr -d '\n=')"
session_url="${public_url}/server/${server_token}/session/${session_id}"

python3 - "$sessions_file" "$session_id" "$session_title" "$session_url" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
session_id = sys.argv[2]
title = sys.argv[3]
url = sys.argv[4]

entry = f"- `{session_id}` - {title}\n  {url}\n"

if path.exists():
    content = path.read_text()
else:
    content = (
        "# OpenCode Sessions\n\n"
        "Active session URLs live here so they can be retrieved from another device.\n\n"
        "Rules:\n"
        "- Add a new session URL when a session starts.\n"
        "- Remove the session URL when that session is completed.\n\n"
        "Current active sessions:\n"
    )

if session_id in content:
    print("already-recorded")
    raise SystemExit(0)

if not content.endswith("\n"):
    content += "\n"

if "Current active sessions:\n" not in content:
    content += "\nCurrent active sessions:\n"

content += entry
path.write_text(content)
print("recorded")
PY

printf 'repo=%s\n' "$repo_name"
printf 'worktree=%s\n' "$worktree_path"
printf 'branch=%s\n' "$branch_name"
printf 'session_id=%s\n' "$session_id"
printf 'session_url=%s\n' "$session_url"
