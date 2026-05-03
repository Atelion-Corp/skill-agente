# Permisos por Agente (RBAC Operativo)

## Roles disponibles

- `agent-dev`: crea/modifica solo dev.
- `agent-prod`: modifica solo productivo.
- `agent-ops`: infraestructura, monitoreo, backup.
- `agent-security`: auditoría y secretos.
- `agent-docs`: documentación/reportes.

## Fuente de verdad

- Política: `config/agent-permissions-policy.json`
- Validador: `scripts/authorize-agent-action.ps1`
- Ejecutor con guardia + auditoría: `scripts/invoke-agent-guarded-task.ps1`

## Ejemplos

Permitir (dev):

```powershell
pwsh -File .\scripts\authorize-agent-action.ps1 -Role agent-dev -Action modify -TargetPath "/opt/apps/project/docker-compose.yml"
```

Bloquear (dev en prod):

```powershell
pwsh -File .\scripts\authorize-agent-action.ps1 -Role agent-dev -Action modify -TargetPath "/opt/apps/server-atelion-project/docker-compose.prod.yml"
```

Ejecución guardada en auditoría:

```powershell
pwsh -File .\scripts\invoke-agent-guarded-task.ps1 -Role agent-ops -Action validate -TargetPath "/opt/colossus/skill_agente/scripts/validate-all-apps.ps1" -Command "pwsh -File .\scripts\validate-all-apps.ps1 -AppsRoot /opt/apps -OutputDir /opt/colossus/skill_agente/proyecto_resultado_skill/proyectos/server_diagnostic"
```

## Auditoría

Todas las decisiones allow/deny quedan en:

- `proyecto_resultado_skill/proyectos/server_diagnostic/agent-permissions-audit.jsonl`

