# Runbook de Recarga Limpia en Colossus

Objetivo: simplificar, eliminar redundancias y volver a cargar toolkit limpio en servidor.

## 1) Reconciliar toolkit local

```powershell
pwsh -File "C:\Users\diego\Documents\Propio\skill_agente\scripts\reconcile-toolkit.ps1" -Root "C:\Users\diego\Documents\Propio\skill_agente" -PruneGenerated
```

## 2) Empaquetar y subir a colossus

Dry run:

```powershell
pwsh -File "C:\Users\diego\Documents\Propio\skill_agente\scripts\package-and-upload-colossus.ps1"
```

Aplicar:

```powershell
pwsh -File "C:\Users\diego\Documents\Propio\skill_agente\scripts\package-and-upload-colossus.ps1" -Apply
```

## 3) Validar en servidor

```bash
cd /opt/colossus/skill_agente
/usr/bin/pwsh -File ./scripts/validate-plugin.ps1
/usr/bin/pwsh -File ./scripts/docs-autocomplete.ps1 -ProjectId server_diagnostic -OutputDoc docs/estado-operativo-autocompletado.md
crontab -l
```

## 4) Verificar logs/reportes

```bash
tail -n 80 /var/log/colossus/docs_autocomplete.log
tail -n 80 /var/log/colossus/validate_apps.log
tail -n 80 /var/log/colossus/archive_lifecycle.log
ls -lah /opt/colossus/skill_agente/proyecto_resultado_skill/proyectos/server_diagnostic
```

