# OpenCode Harness

This directory is intended to be mounted as OpenCode's global config directory.

This directory is part of a public repository. Keep it generic and safe to publish. Use a separate private harness layer for business-specific instructions, skills, agents, commands, MCP config, and operational SOPs.

In the hosted container:

```text
/workspace/home/repos/007/opencode -> /data/.config/opencode
```

## Contents

- `AGENTS.md` - short global instructions loaded for every OpenCode session.
- `opencode.json` - global OpenCode config that should be safe across repos.
- `agents/` - reusable OpenCode subagents.
- `commands/` - slash commands.
- `skills/` - on-demand workflow knowledge.
- `bin/` - helper scripts used by commands and skills.

Do not commit runtime state, auth files, logs, caches, or dependency directories here.

## Session Manager

Use `/bootstrap-session-manager` or `/data/.config/opencode/bin/bootstrap-session-manager.sh` to create the durable manager session in `/workspace/home` after bootstrapping a new OpenCode server. See `docs/session-manager.md` for the full workflow.

## Pull Requests

Use `/pr` to publish the current task branch. The command treats invocation as approval to commit and push local changes, creates the PR with `gh pr create` when needed, updates the existing PR when one already exists for the branch, and reports the PR URL and next step.

Use `/lgtm` to complete an approved PR from a task session. The command treats `/lgtm` as explicit approval, requires green GitHub checks by default, uses squash merge with remote branch deletion, fast-forwards local `main` in the base repo under `/workspace/home/repos/<repo>`, and then hands local worktree and session cleanup to the Session Manager.
