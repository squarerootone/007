# Global OpenCode Instructions

These instructions apply to all OpenCode sessions in the shared container.

This public harness must only contain generic, publishable instructions. Do not add private business context, customer data, internal infrastructure details, private URLs, or sensitive SOPs here.

## Operating Style

- Inspect the codebase before editing.
- Prefer small, correct changes over broad rewrites.
- Do not modify secrets, auth files, production data, or generated artifacts unless explicitly asked.
- Preserve unrelated user changes in dirty worktrees.
- Run relevant verification after behavior changes when feasible.
- Explain blockers and verification gaps clearly.

## Context Strategy

- Use repository `AGENTS.md` files for repo-specific build, test, and architecture guidance.
- Use nested `AGENTS.md` files for subsystem-specific rules.
- Use skills for long workflows, checklists, and SOPs.
- Do not load large docs proactively unless the task needs them.

## Delegation

- Use read-only exploration subagents for broad codebase discovery.
- Use review subagents for risk-focused review before large or sensitive changes.
- Keep implementation changes in the primary working context unless the task is explicitly parallelizable.
