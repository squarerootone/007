---
description: Create or recreate the durable OpenCode Session Manager session in /workspace/home.
agent: build
---

Bootstrap the durable Session Manager session:

`$ARGUMENTS`

Requirements:

1. Run `/data/.config/opencode/bin/bootstrap-session-manager.sh` with any provided arguments, such as `--force`.
2. Confirm the manager session is recorded in the `Manager session` section of `/workspace/home/SESSIONS.md`.
3. Reply with the manager session ID, manager session URL, and registry path.

Use `--force` only when replacing an unusable manager session or re-bootstrapping a new server.
