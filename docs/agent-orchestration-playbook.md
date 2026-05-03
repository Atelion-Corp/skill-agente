# Agent Orchestration Playbook

## Objetivo
Estandarizar como operar skills, agentes y subagentes en Claude, Codex y OpenCode manteniendo MCP/conectores, seguridad y trazabilidad.

## Definiciones
- `Skill`: receta reusable.
- `Agente`: ejecutor del objetivo principal.
- `Subagente`: ejecutor de una tarea especializada.
- `Orquestador`: clasifica, delega, coordina y consolida.

## Flujo base
1. Clasificar la solicitud.
2. Dividir en tareas.
3. Separar tareas independientes (paralelo) y dependientes (serie).
4. Delegar con paquete minimo.
5. Consolidar resultados.
6. Registrar decisiones y riesgos.

## Paquete minimo de delegacion
- `objetivo`: que debe lograr.
- `alcance`: que si y que no.
- `entrada`: archivos, contexto, restricciones.
- `salida esperada`: formato exacto.
- `criterio de aceptacion`: como validar.
- `riesgos`: performance, seguridad, regresion.

## Patrón de paralelo recomendado
Caso tipico frontend:
- `@css-color-agent`: localizar/actualizar colores en CSS.
- `@perf-agent`: revisar costo de render, bundle, paint.
- `@security-agent`: validar sanitizacion, secretos, headers.

Regla: si `@perf-agent` y `@security-agent` dependen del cambio final de CSS, primero corre `@css-color-agent`, luego valida en paralelo perf+security.

## MCP y conectores
- Mantener uso de MCP para contexto estructurado (repo, PR, issues, logs).
- No reemplazar conectores con scraping manual si ya existe conector oficial.
- Registrar en salida final que conector se uso y para que.

## Checklist rapido
- Objetivo claro por subagente.
- Sin solapamiento de responsabilidades.
- Criterios de aceptacion definidos.
- Consolidacion unica.
- Documentacion actualizada.
