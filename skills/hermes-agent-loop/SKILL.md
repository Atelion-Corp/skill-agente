---
name: hermes-agent-loop
description: Skill de auto-mejora continua inspirado en Hermes Agent. Ejecuta ciclos de planificación, ejecución, revisión, aprendizaje y actualización con memoria persistente y mejoras incrementales seguras para agentes compatibles.
license: MIT
---

# hermes-agent-loop — Auto-Mejora Continua Controlada

Skill inspirado en patrones de `NousResearch/hermes-agent` para que un agente mejore su desempeño de forma iterativa, trazable y portable.

## Cuándo usar

- Cuando el usuario pide "que el agente se mejore solo"
- Cuando se requiere aprendizaje incremental entre sesiones
- Cuando hay tareas repetitivas y se quiere elevar calidad/velocidad en cada ciclo
- Cuando se quiere un bucle de mejora multi-runtime (Claude/Codex/OpenCode)

## Objetivo operativo

Aplicar un loop fijo por cada iteración:

1. `plan`
2. `run`
3. `review`
4. `learn`
5. `update`
6. `validate`
7. `log`

## Contrato de seguridad

- Nunca aplicar cambios destructivos sin autorización explícita.
- Las mejoras deben ser pequeñas, reversibles y medibles.
- Si una mejora no supera validación, revertir solo ese bloque y registrar causa.
- No modificar secretos ni credenciales.
- Limitar cada iteración a 1-3 cambios de alto impacto.

## Estado persistente recomendado

Guardar un estado simple por proyecto en:

`proyecto_resultado_skill/proyectos/<project_id>/hermes-loop-state.json`

Campos mínimos:

- `iteration`
- `last_goal`
- `last_changes`
- `metrics_before`
- `metrics_after`
- `delta`
- `next_hypothesis`
- `risk_notes`

## Workflow

### 1) Plan

- Definir objetivo concreto del ciclo (ej: reducir errores de vinculación).
- Definir 1-3 métricas de éxito.
- Definir hipótesis de mejora.

### 2) Run

- Ejecutar los cambios mínimos necesarios.
- Mantener alcance acotado.

### 3) Review

- Comparar estado antes/después con evidencia.
- Detectar regresiones funcionales.

### 4) Learn

- Sintetizar qué funcionó y qué no.
- Convertir aprendizaje en regla reusable.

### 5) Update

- Actualizar skill/documentación/checklists con la mejora validada.

### 6) Validate

- Correr validaciones disponibles (build/tests/scripts).
- Si falla, no promover aprendizaje al baseline.

### 7) Log

- Registrar iteración y resultado.
- Dejar siguiente hipótesis lista para próximo ciclo.

## Automatización recomendada

Ejecutar el loop con:

```powershell
pwsh -File scripts/hermes-autoupgrade.ps1 -ProjectId "skill_agente" -Goal "objetivo del ciclo" -Apply
```

Notas:
- `-Apply` corre validación (`scripts/validate-plugin.ps1`) dentro del ciclo.
- Sin `-Apply`, hace dry-run de planificación y registro.

## Salida esperada

- `decision` (qué se mejoró)
- `evidence` (cómo se validó)
- `impact` (métrica o resultado observable)
- `next_hypothesis` (siguiente mejora propuesta)

## Integración multi-IA

- Claude/Codex: registrar en manifiestos del plugin.
- OpenCode/otros: consumir `SKILL.md` directamente.
- Mantener lenguaje de instrucciones agnóstico del runtime.
