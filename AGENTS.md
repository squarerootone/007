# 007 Harness Instructions

This repo stores reusable AI harness configuration.

This repository is public and intended to be open source. Treat all contents as publishable public material.

## Rules

- Keep shared skills model-agnostic and tool-agnostic where possible.
- Put OpenCode-specific config in `opencode/`.
- Put Claude Code-specific adapters in `claude/`.
- Put Codex-specific adapters in `codex/`.
- Avoid secrets, API keys, live tokens, auth files, caches, and `node_modules`.
- Do not commit private business context, customer information, internal infrastructure details, private URLs, private SOPs, or organization-specific operational knowledge.
- Prefer short always-loaded instructions and longer on-demand skills.
- Put private or business-specific AI instructions in a separate private harness layer.

## Skill Authoring

- Use minimal frontmatter: `name` and `description`.
- Make `description` specific enough for implicit invocation.
- Avoid provider names, tool call names, and vendor-only frontmatter in shared skills.
- Put long reference material under `references/` inside the skill.
