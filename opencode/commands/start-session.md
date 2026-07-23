---
description: Create a new worktree-backed OpenCode session from a natural-language request and record it in /workspace/home/SESSIONS.md.
agent: build
---

Create a new OpenCode session for this request:

`$ARGUMENTS`

Requirements:

1. Inspect `/workspace/home/repos` and choose the best repo for the request.
2. If the repo choice is ambiguous after inspection, ask one short clarification question and stop.
3. Create a concise session title in Title Case.
4. Create a lowercase kebab-case worktree name, usually `<repo-name>-<topic>`.
5. Run `/data/.config/opencode/bin/start-session.sh` with the repo name, worktree name, session title, and the full request.
6. Confirm the session was added to `/workspace/home/SESSIONS.md`.
7. Reply with the session title, repo name, worktree path, session ID, and session URL.

Do not modify unrelated sessions.
