---
name: deployment-checklist
description: Deployment readiness, release validation, rollback planning, and post-deploy verification checklist.
---

# Deployment Checklist

Use this skill when preparing, reviewing, or validating a deployment.

## Pre-Deploy

- Identify the exact service, environment, version, and change scope.
- Confirm required secrets, config, migrations, and external dependencies.
- Check for backwards-incompatible changes and rollout order requirements.
- Confirm tests, linting, build, and smoke checks appropriate to the change.
- Identify user-visible impact and expected downtime, if any.

## Rollback

- Define the rollback command or manual recovery path.
- Identify data migrations that are not safely reversible.
- Confirm backups or snapshots for stateful systems.
- Document what signal triggers rollback.

## Post-Deploy

- Check service status and logs.
- Run health checks or smoke tests.
- Verify critical user paths.
- Watch metrics or error reports long enough to catch delayed failures.

Return blockers first, then recommended verification steps.
