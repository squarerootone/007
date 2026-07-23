# 007

Shared AI harness configuration for Squarerootone tools.

This repository is public and intended to be open source. Only commit generic harness configuration, reusable public workflows, and non-sensitive instructions. Do not commit private business context, customer information, internal infrastructure details, secrets, tokens, private URLs, or company-specific SOPs that should not be public.

## Layout

- `opencode/` - OpenCode global config, agents, commands, skills, and helper scripts. Mount this directory to `~/.config/opencode` or the container's `/data/.config/opencode`.
- `claude/` - Claude Code adapters and symlinks for reusable content.
- `codex/` - Codex adapters and symlinks for reusable content.

Keep portable workflow knowledge in skills. Keep tool-specific permissions, MCP, agents, and commands inside each tool folder.

Business-specific or private instructions should live in a separate private layer, not in this repository.

## OpenCode Container Mount

For the hosted OpenCode container, clone this repo to:

```text
/workspace/home/repos/007
```

The infrastructure repo mounts:

```text
/workspace/home/repos/007/opencode -> /data/.config/opencode
```

OpenCode must be restarted after changes to config, agents, commands, or skills.
