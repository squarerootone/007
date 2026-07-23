---
name: session-manager
description: Start session, close session, worktree, SESSIONS.md. Use when the user wants a new OpenCode session created from a repo in /workspace/home/repos, recorded in /workspace/home/SESSIONS.md, or removed from that list when complete.
---

# Session Manager

Use this skill for the shared OpenCode session registry at `/workspace/home/SESSIONS.md`.

## Paths

- Repos: `/workspace/home/repos`
- Worktrees: `/workspace/home/worktrees/<repo-name>/<topic-slug>`
- Session registry: `/workspace/home/SESSIONS.md`
- Helper script: `/data/.config/opencode/bin/start-session.sh`

## Commands

- Start sessions with `/start-session`; it owns repo selection, naming, worktree creation, and registry updates.
- End sessions with `/end-session`; it owns session deletion and registry cleanup.

## Naming

- Use one lowercase kebab-case topic slug without the repo name.
- The helper script creates worktrees under `/workspace/home/worktrees/<repo-name>/<topic-slug>`.
- Branch names use `feat/<topic-slug>` and session titles are derived from the topic slug in Title Case.

## Registry Format

Each active session should be stored as:

```markdown
- `ses_...` - Session Title
  https://opencode.example.com/server/.../session/ses_...
```

Keep the file simple and append new sessions to the active list.
