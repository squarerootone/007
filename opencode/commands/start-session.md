---
description: Create a new worktree-backed OpenCode session from a natural-language request and record it in /workspace/home/SESSIONS.md.
agent: build
---

Create a new OpenCode session for this request:

`$ARGUMENTS`

Requirements:

1. Inspect `/workspace/home/repos` and choose the best repo for the request.
2. If the repo choice is ambiguous after inspection, ask one short clarification question and stop.
3. Create one lowercase kebab-case topic slug without the repo name, such as `<topic>`.
4. Run `/data/.config/opencode/bin/start-session.sh` with the repo name, topic slug, and the request context. The script creates the worktree under `/workspace/home/worktrees/<repo-name>/<topic-slug>`, uses `feat/<topic-slug>` for the branch, and derives the Title Case session title from the topic slug.
5. Confirm the session was added to `/workspace/home/SESSIONS.md`.
6. Reply with the session title, repo name, worktree path, branch name, session ID, and session URL.

The helper sends only a minimal `READY` bootstrap prompt to the new session. The user must send the first real task prompt in that new session.
Task sessions are recorded under `Current active sessions`. Do not replace the `Manager session` section.
Do not modify unrelated sessions.
