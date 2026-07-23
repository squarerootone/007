---
name: code-review
description: Review code, diffs, pull requests, or branches for correctness, regressions, security risks, and missing tests.
---

# Code Review

Use this skill when reviewing a change, pull request, branch, or diff.

## Review Priorities

1. Correctness bugs and behavioral regressions.
2. Security, privacy, authorization, and secret-handling risks.
3. Data loss, migration, concurrency, and rollback risks.
4. Missing or weak tests for changed behavior.
5. Maintainability issues that materially increase future risk.

## Output

- Put findings first, ordered by severity.
- Include file and line references where possible.
- Keep summaries short and secondary.
- If no findings are found, state that explicitly and mention residual risks or unverified areas.

Do not edit files unless the user explicitly asks for fixes.
