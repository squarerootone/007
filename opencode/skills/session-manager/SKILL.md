---
name: session-manager
description: Start session, close session, worktree, SESSIONS.md. Use when the user wants a new OpenCode session created from a repo in /workspace/home/repos, recorded in /workspace/home/SESSIONS.md, or removed from that list when complete.
---

# Session Manager

Use this skill for the shared OpenCode session registry at `/workspace/home/SESSIONS.md`.
Use `/workspace/home` as the durable manager directory for cleanup orchestration.

## Paths

- Repos: `/workspace/home/repos`
- Worktrees: `/workspace/home/worktrees/<repo-name>/<topic-slug>`
- Session registry: `/workspace/home/SESSIONS.md`
- Start helper script: `/data/.config/opencode/bin/start-session.sh`
- Manager bootstrap script: `/data/.config/opencode/bin/bootstrap-session-manager.sh`
- Cleanup handoff script: `/data/.config/opencode/bin/request-session-cleanup.sh`
- Workflow docs: `/data/.config/opencode/docs/session-manager.md`

## Commands

- Bootstrap the durable manager session with `/bootstrap-session-manager` or `/data/.config/opencode/bin/bootstrap-session-manager.sh`.
- Start task sessions with `/start-session`; it owns repo selection, naming, worktree creation, and registry updates.
- End task sessions with `/end-session`; non-manager sessions hand cleanup to the manager instead of deleting themselves.
- Only the manager session should remove task worktrees, remove task registry entries, and delete task OpenCode sessions.
- Deleting a task OpenCode session must be the final destructive step after cleanup and reporting.

## Naming

- Use one lowercase kebab-case topic slug without the repo name.
- The helper script creates worktrees under `/workspace/home/worktrees/<repo-name>/<topic-slug>`.
- Branch names use `feat/<topic-slug>` and session titles are derived from the topic slug in Title Case.

## Registry Format

The manager session should be stored as:

```markdown
Manager session:
- `ses_...` - Session Manager
  https://opencode.example.com/server/.../session/ses_...
```

Each active task session should be stored as:

```markdown
- `ses_...` - Session Title
  https://opencode.example.com/server/.../session/ses_...
```

Keep the file simple and append new task sessions to the active list.
If the registry is missing, recreate it with `bootstrap-session-manager.sh` before starting task cleanup.
