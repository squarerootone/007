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
