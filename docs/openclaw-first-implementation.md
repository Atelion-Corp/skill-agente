# OpenClaw-First Implementation Guide

This document defines the runtime baseline for `skill_agente` using OpenClaw as the only execution runtime for agents.

## Runtime baseline

- Runtime owner: OpenClaw
- Skill source of truth: `./skills`
- Workspace bootstrap files: `AGENTS.md`, `SOUL.md`, `TOOLS.md`
- Security defaults:
  - least-privilege credentials
  - command allowlist for remote execution
  - timeout per execution step
  - audit logs for each skill run

## Standard lifecycle

1. Intake request through orchestrator skill.
2. Resolve skill contract from `contracts/skills-contracts.json`.
3. Execute with OpenClaw runtime profile (`config/openclaw-runtime.json`).
4. Persist run metadata in `proyecto_resultado_skill/proyectos/<project_id>/`.
5. Trigger Hermes checkpoint report on phase boundaries.

## Hermes checkpoints

Hermes is required at:

- end of infrastructure discovery
- end of architecture normalization
- before deployment approval

Each checkpoint must emit:

- architecture drift summary
- risk summary
- prioritized remediation actions
- documentation update note

## Deployment quality gate

No deployment is allowed unless all gates pass:

- contracts validated
- command allowlist matched
- pre-deploy checks passed
- post-deploy smoke checks passed
- rollback path documented

