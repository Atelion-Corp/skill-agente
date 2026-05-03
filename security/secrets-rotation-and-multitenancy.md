# Secrets Inventory + Rotation (Professional Practice)

## Why inventory secrets without values

Professional teams maintain a secret inventory that stores:

- secret name/key
- owner team
- scope (project/tenant/environment)
- rotation policy (days)
- last rotation date
- dependent services

They do **not** store secret values in this inventory.

This gives traceability and compliance without exposing credentials.

## Recommended model for your server

1. Keep `.env` values out of git.
2. Build a metadata inventory file (names only).
3. Move runtime secret values to a secret manager.
4. Inject secrets at runtime for each stack.

## Docker self-hosted secret manager

For your scenario, a practical option is self-hosted Infisical with Docker Compose:

- encrypted secret storage
- tenant/project environments
- API-based retrieval
- auditable access

Reference:
- https://infisical.com/docs/self-hosting/deployment-options/docker-compose

## Multi-tenant isolation baseline

- one tenant namespace per client
- one env per stage (`prod`, `dev`, `test`)
- dedicated DB schema or dedicated DB per tenant for sensitive workloads
- tenant-specific encryption keys where possible
- strict RBAC:
  - ops-admin
  - tenant-admin
  - read-only auditor

## Rotation strategy

- classify secrets:
  - tier 0: DB root/admin tokens (rotate 30-60 days)
  - tier 1: service credentials and API keys (rotate 60-90 days)
  - tier 2: internal low-risk secrets (rotate 90-180 days)
- rotate in batches with rollback:
  1. create new credential
  2. update app config
  3. deploy
  4. health-check
  5. revoke old credential

## Minimum logging for security

- who accessed which secret metadata
- who rotated which secret and when
- deployment ID linked to secret version
- failed access attempts

