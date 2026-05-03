# Runbook de Ejecución Completa (One Command)

## Objetivo

Ejecutar un ciclo completo operativo:

1. Copia de seguridad desde servidor a PC.
2. Validación individual/global de apps.
3. Aplicación de política de puertos en copia local.
4. Inventario de secretos (metadatos).
5. Validaciones de `stack-guardian`.
6. Render visual de estado operativo.
7. Validación de plugin y contratos.
8. Opcional: acciones remotas (rename + archive/stop dev-test).

## Comando

```powershell
pwsh -File "C:\Users\diego\Documents\Propio\skill_agente\scripts\run-full-ops-cycle.ps1" -HostName "192.168.1.82" -UserName "diego-admin"
```

Con cambios remotos:

```powershell
pwsh -File "C:\Users\diego\Documents\Propio\skill_agente\scripts\run-full-ops-cycle.ps1" -HostName "192.168.1.82" -UserName "diego-admin" -ApplyRemoteChanges
```

## Salidas clave

- `proyecto_resultado_skill/proyectos/server_diagnostic/apps-validation-report.json`
- `proyecto_resultado_skill/proyectos/server_diagnostic/ops-overview.html`
- `proyecto_resultado_skill/proyectos/server_diagnostic/secrets-inventory.csv`
- `proyecto_resultado_skill/proyectos/*/stack-guardian-report-*.json`

## Nota de seguridad

- No guarda contraseñas.
- No imprime valores de secretos.
- Si hay cambios remotos (`-ApplyRemoteChanges`), ejecutar con aprobación explícita.

