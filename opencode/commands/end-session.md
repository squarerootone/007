---
description: Remove a completed OpenCode session from /workspace/home/SESSIONS.md and delete it from OpenCode.
agent: build
---

Mark this session as complete and remove it from `/workspace/home/SESSIONS.md`:

`$ARGUMENTS`

Requirements:

1. Read `/workspace/home/SESSIONS.md`.
2. Match the target session by session ID, URL, or title.
3. Delete the session from OpenCode using `opencode session delete <sessionID>`.
4. Remove that session entry from the markdown list.
5. Reply with the removed session title and ID.

Do not delete the git worktree unless the user explicitly asks for that too.
