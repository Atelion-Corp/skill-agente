---
name: stack-guardian
description: Validates and enforces production best practices for architecture, multitenancy, security, deployment, and observability. Logs context for AI and emits correction plans.
license: MIT
---

# stack-guardian

Use this skill when applying or reviewing changes in server projects that must follow a professional production baseline.

## Baseline controls

1. Monolith-modular architecture with decoupled frontend.
2. Multi-tenant isolation and tenant-aware routing.
3. Production runbook controls (TLS, headers, backups, DB restrictions).
4. Secret handling discipline (inventory without values + rotation policy).
5. Structured observability and deploy validation.

## Workflow

1. Run structural validation (`stack-guardian-validator.ps1`).
2. If drifts are found, generate correction plan.
3. If safe fixes are possible, apply only non-destructive autofixes.
4. Persist AI context and validation logs per project.
5. Re-run validation and emit final status.

## Output format

- `status`
- `drifts`
- `autofixes_applied`
- `risks_remaining`
- `next_actions`
