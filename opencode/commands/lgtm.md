---
description: Complete an approved PR with safety checks, squash merge, base-repo fast-forward, and manager cleanup handoff.
agent: build
---

Complete the approved PR for the current task session:

`$ARGUMENTS`

Requirements:

1. Treat invoking `/lgtm` as explicit user approval to merge.
2. Inspect the current git branch and `git status --short`. If the worktree is dirty, stop and ask whether to commit, discard, or continue later.
3. Determine the repo name from the current worktree path under `/workspace/home/worktrees/<repo-name>/...` and the corresponding base repo at `/workspace/home/repos/<repo-name>`.
4. Identify the target PR. Prefer the explicit PR number or URL from `$ARGUMENTS` when provided; otherwise use the PR associated with the current branch.
5. Confirm the PR is open, the head branch matches the current branch unless the user explicitly targeted a different PR, and the merge target is clearly reported before merging.
6. Fetch the latest remote state and inspect PR status with `gh`.
7. Require green `gh pr checks` before merge.
8. Preferred behavior when checks are failing or missing: fix the issue, push updates, and ask for reapproval instead of merging immediately.
9. If the user explicitly authorizes proceeding despite failing or missing checks, clearly report that risk and only then continue.
10. If the PR is not mergeable, has unresolved review concerns, or approval/check state is ambiguous, stop and ask one short clarifying question.
11. Merge with squash using `gh pr merge --squash --delete-branch`.
12. In the base repo at `/workspace/home/repos/<repo-name>`, update local `main` with fetch plus `git merge --ff-only origin/main`. Do not reset, rebase, or force-update local `main`.
13. After merge, hand off local task cleanup with `/data/.config/opencode/bin/request-session-cleanup.sh` and include context that the PR was squash-merged, the remote branch was deleted, and base-repo `main` was fast-forwarded.
14. Do not delete the current worktree, local branch, or current OpenCode session directly from this task session.
15. Reply with the PR merged state, check status outcome, base-repo `main` update result, and the manager-session cleanup handoff result.
