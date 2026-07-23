---
name: incident-triage
description: Incident triage, outage debugging, service health investigation, and recovery coordination.
---

# Incident Triage

Use this skill for outages, broken services, degraded behavior, or urgent production debugging.

## First Principles

- Stabilize before optimizing.
- Preserve evidence and avoid destructive commands unless explicitly approved.
- Identify blast radius, user impact, start time, and recent changes.
- Prefer read-only diagnostics first.

## Triage Flow

1. Clarify the affected service, symptoms, environment, and urgency.
2. Check service status, recent logs, health endpoints, and recent deployments.
3. Form hypotheses and test them one at a time.
4. Recommend the safest mitigation first.
5. Record follow-up actions once service is stable.

## Output

- Current status.
- Most likely cause.
- Evidence.
- Immediate mitigation.
- Follow-up prevention work.
