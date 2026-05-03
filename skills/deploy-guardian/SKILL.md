---
name: deploy-guardian
description: Safe deployment agent workflow for pull, validation, server adaptation, smoke checks, and rollback readiness with full audit trail.
license: MIT
---

# deploy-guardian

Use this skill for controlled deployments to private servers.

## Workflow

1. Pull project branch/tag.
2. Run pre-deploy validations.
3. Validate runtime contracts and environment requirements.
4. Apply server adaptation checks (ports, volumes, env vars).
5. Execute deploy with timeout and logs.
6. Run smoke checks.
7. Emit rollback-ready report.

## Security rules

- Never run destructive cleanup unless explicitly approved.
- No secret values in logs or docs.
- Every command must be traceable in the run report.

## Output format

- `precheck_status`
- `deploy_status`
- `smoke_status`
- `rollback_readiness`
- `risk_notes`

