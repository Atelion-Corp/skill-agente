---
name: ecosystem-curator
description: Curador de ecosistema de skills/agentes/plugins. Evalúa fuentes oficiales y comunitarias, selecciona complementos de alta calidad y propone integraciones multi-runtime (Claude, Codex, OpenCode y compatibles).
license: MIT
---

# ecosystem-curator — Curador de Ecosistema

Skill para investigar y consolidar capacidades de múltiples repositorios de agentes/skills, priorizando calidad, mantenimiento y compatibilidad.

## Cuándo usar

- Cuando se pide “mejorar el plugin con repos externos”
- Cuando se requiere mapa de ecosistema de skills/agentes/plugins
- Cuando se quieren recomendaciones accionables y no solo links

## Fuentes prioritarias

1. Oficiales:
- `anthropics/skills`
- `openai/skills`
- organizaciones `anthropics` y `openai`

2. Curadas:
- `VoltAgent/awesome-agent-skills`
- `awesome-opencode/awesome-opencode`
- `heygen-com/hyperframes`

3. Diseño/UI:
- `leonxlnx/taste-skill`
- `froala/design-blocks`
- `tailwindflex.com`
- `dribbble.com/tags/tailwind-ui`

## Matriz de evaluación mínima

Para cada recurso puntuar 1-5:

- `maintained`: actividad reciente
- `adoption`: señales de uso (stars/forks/comunidad)
- `portability`: funciona en más de un runtime
- `specificity`: aporta capacidades concretas
- `safety`: evita patrones riesgosos/no auditables

## Workflow

### 1) Descubrir
- Recolectar fuentes oficiales y curadas.
- Evitar recursos sin contexto verificable.

### 2) Filtrar
- Quedarse con recursos de alto impacto y baja redundancia.

### 3) Mapear
- Traducir cada fuente a mejoras concretas de skill/plugin:
  - nuevo skill
  - práctica reusable
  - plantilla
  - checklist operativo

### 4) Integrar
- Actualizar manifests (`claude`, `codex`) y README.
- Mantener compatibilidad multi-runtime.

### 5) Validar
- Ejecutar script de validación del plugin.
- Confirmar paths/versiones/sincronía.

## Salida esperada

- `shortlist` de recursos recomendados
- `integration-plan` (qué cambia en plugin/skills)
- `applied-changes` (qué se implementó)
- `next-additions` (complementos sugeridos)

