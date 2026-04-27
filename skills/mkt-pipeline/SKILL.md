---
name: mkt-pipeline
description: Marketing workflow orchestrator — guides from brief to execution across research, strategy, content, SEO, CRO, and growth. Use when starting a marketing project, campaign, or go-to-market, or when multiple marketing tasks need coordination.
license: MIT
---

# mkt-pipeline — Marketing Workflow Orchestrator

Orquestador del área de marketing. Guía desde brief hasta ejecución.

## Cuándo usar

- "empieza un proyecto de marketing"
- "necesito estrategia de go-to-market"
- "guíame por el proceso de marketing"
- "campaña de lanzamiento"

## Etapas

```
[1. BRIEF] → [2. CONTEXTO] → [3. ESTRATEGIA] → [4. CONTENIDO] → [5. SEO] → [6. CRO] → [7. GROWTH]
```

| Etapa | Skill | Output |
|-------|-------|--------|
| 1. BRIEF | (intake) | Objetivo, canales, plazo |
| 2. CONTEXTO | `mkt-base` | mkt-context.json |
| 3. ESTRATEGIA | (decisión guiada) | Plan por canales |
| 4. CONTENIDO | `mkt-copy` | Copy para cada canal |
| 5. SEO | `mkt-seo` | Optimizaciones + keywords |
| 6. CRO | `mkt-cro` | Landing + flows optimizados |
| 7. GROWTH | `mkt-growth` | Referral + retención |

## Workflow

### 1. Detectar etapa

"¿Estás empezando o retomando?"
- Nuevo → desde BRIEF
- Retomando → leer `pipeline-status.json`

### 2. BRIEF (3 preguntas máximo)

1. "¿Cuál es el objetivo? (adquirir / retener / lanzar feature / fundraising)"
2. "¿Plazo? (2 semanas / mes / quarter)"
3. "¿Canales disponibles? (SEO / email / paid / social / community)"

### 3. CONTEXTO — activar mkt-base

Si no existe `mkt-context.json` → ejecutar `mkt-base` intake.

### 4. Delegación por etapa

Activar skill de la etapa con contexto comprimido de la anterior.
No preguntar info ya capturada en mkt-context.json.

### 5. Comandos de control

- "¿en qué etapa estoy?" → mostrar pipeline con etapa marcada
- "simplifica" → qué decidir ahora en ≤3 opciones
- "¿qué falta?" → listar etapas pendientes
- "guardar y pausar" → resultado-save + dejar status guardado

## Output

Proyecto de marketing completo en:
```
proyecto_resultado_skill/proyectos/<nombre>/marketing/
├── mkt-context.json
├── strategy.md
├── copy/
├── seo-audit.md
└── pipeline-status.json
```
