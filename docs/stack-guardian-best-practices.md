# Stack Guardian Best Practices Baseline

Source extracted from production-grade project references in your server copy:
- `docs/architecture.md`
- `docs/production-server-runbook.md`
- `docs/multitenancy.md`
- `docs/rbac.md`

## Practices incorporated

1. Monolithic modular backend + decoupled frontend.
2. Multi-tenant model with tenant-aware routing and data isolation.
3. Production runbook discipline:
   - TLS and security headers
   - DB not publicly exposed
   - backups and restore procedures
4. Secret discipline:
   - `.env` excluded from versioning
   - metadata inventory without secret values
   - rotation policy by risk tier
5. Deploy validation gates before and after release.
6. Observability baseline with logs and service metrics.

## Agent behavior derived from these practices

- Validate structural paths before deployment.
- Validate compose and production runtime controls.
- Record findings and context in project logs.
- Apply only safe autofixes (documentation placeholders, non-destructive scaffolding).
- Refuse destructive auto-changes without explicit approval.
