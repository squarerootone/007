---
name: session-manager
description: Start session, close session, worktree, SESSIONS.md. Use when the user wants a new OpenCode session created from a repo in /workspace/home/repos, recorded in /workspace/home/SESSIONS.md, or removed from that list when complete.
---

# Session Manager

Use this skill for the shared OpenCode session registry at `/workspace/home/SESSIONS.md`.

## Paths

- Repos: `/workspace/home/repos`
- Worktrees: `/workspace/home/worktrees`
- Session registry: `/workspace/home/SESSIONS.md`
- Helper script: `/data/.config/opencode/bin/start-session.sh`

## Start A Session

When the user wants a new session:

1. Inspect `/workspace/home/repos` and choose the best matching repo.
2. Create a short human-readable session title.
3. Create a worktree slug as lowercase kebab-case, usually `<repo-name>-<topic>`.
4. Run:

```bash
/data/.config/opencode/bin/start-session.sh <repo-name> <worktree-name> <session-title> <prompt>
```

5. Return the chosen repo, worktree path, session ID, and session URL.

If multiple repos are plausible after inspection, ask one short clarification question instead of guessing.

## Close A Session

When the user says a session is complete:

1. Read `/workspace/home/SESSIONS.md`.
2. Find the matching entry by session ID, URL, or title.
3. Remove that session block from the markdown list.
4. Do not delete the git worktree unless the user explicitly asks.

If the user asks to delete the OpenCode session too, run `opencode session delete <sessionID>`.

## Registry Format

Each active session should be stored as:

```markdown
- `ses_...` - Session Title
  https://opencode.example.com/server/.../session/ses_...
```

Keep the file simple and append new sessions to the active list.
