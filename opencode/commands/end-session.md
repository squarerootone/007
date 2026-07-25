---
description: Hand off completed session cleanup to the durable Session Manager.
agent: build
---

Hand off this completed session to the Session Manager for cleanup:

`$ARGUMENTS`

Requirements:

1. Read `/workspace/home/SESSIONS.md` and find the `Manager session` entry.
2. If this is not the manager session, do not delete this session or its current worktree directly.
3. Run `/data/.config/opencode/bin/request-session-cleanup.sh` with the target session ID, URL, or title and any user-provided cleanup instructions. If no target is provided, run the helper without a target so it infers the current session from the current directory.
4. Reply with the manager session ID and tell the user to complete final deletion from the manager session.
5. If this is the manager session, inspect the target task session, git worktree, branch, dirty state, and registry entry before cleanup.
6. From the manager session only, remove the target worktree/local branch when safe or explicitly approved, remove the target entry from `/workspace/home/SESSIONS.md`, report the cleanup result, and ask before deleting the target OpenCode session.

Deleting an OpenCode session with `opencode session delete <sessionID>` must be the final destructive step.
Never delete the Session Manager session unless the user explicitly asks to replace or remove the manager.
