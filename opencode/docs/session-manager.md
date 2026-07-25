# Session Manager Workflow

The Session Manager is a durable OpenCode control-plane session that runs from `/workspace/home`. It owns session registry repair, cleanup handoffs, and destructive worktree cleanup for task sessions.

## Why It Exists

Task sessions usually run from git worktrees under `/workspace/home/worktrees/<repo>/<topic>`. If a task session deletes itself or deletes its own current worktree, it can be interrupted before removing its registry entry or reporting the result.

The manager session avoids that race by running from a stable directory and cleaning up other sessions from outside their worktrees.

## Bootstrap

Create or recreate the manager after starting a new OpenCode server:

```bash
/data/.config/opencode/bin/bootstrap-session-manager.sh
```

You can also use the slash command:

```text
/bootstrap-session-manager
```

If an old manager is registered but unusable, create a replacement:

```bash
/data/.config/opencode/bin/bootstrap-session-manager.sh --force
```

Or:

```text
/bootstrap-session-manager --force
```

The script creates `/workspace/home/SESSIONS.md` if it is missing and records the manager in the `Manager session` section.

Required environment:

```bash
OPENCODE_SESSION_PUBLIC_URL=https://your-public-opencode-url
```

Optional environment:

```bash
OPENCODE_SESSION_SERVER_URL=http://127.0.0.1:4096
OPENCODE_SESSION_MODEL=openai/gpt-5.5
OPENCODE_SESSION_AGENT=build
```

## Registry Shape

`/workspace/home/SESSIONS.md` should contain one manager session and zero or more task sessions:

```markdown
# OpenCode Sessions

Manager session:
- `ses_...` - Session Manager
  https://...

Current active sessions:
- `ses_...` - Task Title
  https://...
```

## Starting Task Sessions

Start worktree-backed sessions with `/start-session` or the helper script:

```bash
/data/.config/opencode/bin/start-session.sh <repo-name> <topic-slug> "<prompt>"
```

Task sessions are registered under `Current active sessions`.
The helper treats the prompt as launcher context only. It sends only a minimal `READY` bootstrap prompt to the new session, and the user sends the first real task prompt after opening the returned session URL.

## Ending Task Sessions

Do not make a task session delete itself or its own worktree. Hand cleanup to the manager instead:

```bash
/data/.config/opencode/bin/request-session-cleanup.sh <session-id-or-title> "optional context"
```

From inside a task session, the target can be omitted and the helper will infer the session from the current directory:

```bash
/data/.config/opencode/bin/request-session-cleanup.sh
```

The manager should:

1. Inspect the target session registry entry.
2. Determine the target worktree and branch.
3. Check git status, branch merge/push state, and whether other sessions reference the same worktree.
4. Stop and ask if cleanup is unsafe.
5. Remove the worktree and local branch only when safety checks pass; if cleanup is dirty, unmerged, ambiguous, or otherwise unsafe, ask for explicit approval in the manager session.
6. Remove the task session from `SESSIONS.md`.
7. Report the cleanup result.
8. Ask before deleting the target OpenCode session.

Deleting the target OpenCode session must be the final destructive step.

## Completing PRs

When a task session is ready to merge an approved PR, use `/lgtm` from that task session.

The PR completion flow should:

1. Treat `/lgtm` as explicit user approval.
2. Require green GitHub checks before merge unless the user explicitly approves a bypass.
3. Prefer fixing failing checks, pushing updates, and requesting reapproval instead of merging immediately.
4. Squash merge the PR and delete the remote branch.
5. Fast-forward local `main` in the base repo under `/workspace/home/repos/<repo>`.
6. Hand worktree, branch, registry, and session cleanup back to the Session Manager with `request-session-cleanup.sh`.

The task session must not delete its own current worktree during PR completion.

## Recovery

If `SESSIONS.md` is lost, run:

```bash
/data/.config/opencode/bin/bootstrap-session-manager.sh
```

Then recreate task-session entries from `opencode session list --format json --max-count 200` as needed.

If a task session is already deleted but its worktree remains, open the manager session and ask it to inspect `/workspace/home/worktrees` and clean stale worktrees after git safety checks.
