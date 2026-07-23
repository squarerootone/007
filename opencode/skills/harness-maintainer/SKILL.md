---
name: harness-maintainer
description: Maintain the 007 AI harness repo, shared skills, OpenCode config, Claude/Codex adapters, and cross-tool portability.
---

# Harness Maintainer

Use this skill when editing the `007` harness repository or designing shared AI tool configuration.

## Rules

- Keep shared skill content portable Markdown with minimal frontmatter.
- Put tool-specific features in that tool's folder.
- Avoid committing runtime state, caches, auth files, dependency directories, or secrets.
- Prefer symlinks for reused skill directories when a tool can consume the same file shape.
- Validate OpenCode config against `https://opencode.ai/config.json` when adding new config fields.

## OpenCode Shape

- Global instructions: `opencode/AGENTS.md`.
- Config: `opencode/opencode.json`.
- Agents: `opencode/agents/*.md`.
- Commands: `opencode/commands/*.md`.
- Skills: `opencode/skills/<name>/SKILL.md`.

OpenCode must be restarted after config, command, agent, or skill changes.
