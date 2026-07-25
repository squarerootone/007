---
description: Create or reuse a pull request for the current task branch and report the next review step.
agent: build
---

Create a pull request for the current task session:

`$ARGUMENTS`

Requirements:

1. Treat invoking `/pr` as confirmation that local changes are ready to commit and push for PR creation or PR updates.
2. Inspect the current git branch and `git status --short`.
3. Determine the repo name from the current worktree path under `/workspace/home/worktrees/<repo-name>/...` and confirm the branch is not `main`.
4. If there are uncommitted changes, stage and commit them before pushing. Use a concise commit message that matches the repo style, and include any user-provided context from `$ARGUMENTS` when it helps produce a better title or message.
5. Check whether a PR already exists for the current branch.
6. Ensure the current branch is pushed to `origin`. If it is not pushed yet, push it first with upstream tracking. If a PR already exists for the branch, treat the push as updating that PR.
7. Prefer the repository default base branch unless the user explicitly requests a different base.
8. If no PR exists yet, build a concise PR title and body from the current branch context, recent commits, and the working change summary, then create the PR with `gh pr create`.
9. If a PR already exists, do not create a duplicate; report the existing PR URL and current status after pushing any new commits.
10. Reply with the PR number, title, URL, base branch, whether this invocation created the PR or updated an existing one, and any current check status that is already available.
11. Tell the user that `/lgtm` is the follow-up command once the PR is approved and checks are ready.
12. If PR creation or update is blocked by missing push permissions, ambiguous base branch selection, or missing required metadata, stop and ask one short clarifying question.
