---
name: resultado-save
description: Guarda y organiza todos los resultados de los skills de diseño en C:\Users\diego\Documents\Propio\proyecto_resultado_skill\. Persiste briefs, tokens, stacks, componentes, imágenes y recursos de forma ordenada.
license: MIT
---

# resultado-save — Guardado de Resultados

Persiste todos los outputs de los skills del plugin `skill-agente` en el repositorio central `proyecto_resultado_skill`. Mantiene un índice navegable de proyectos, tokens, recursos, y stacks.

## Directorio base

```
C:\Users\diego\Documents\Propio\proyecto_resultado_skill\
```

## Estructura del repositorio de resultados

```
proyecto_resultado_skill/
├── proyectos/
│   └── <nombre-proyecto>/
│       ├── brief.md                — intake del proyecto
│       ├── pipeline-status.json   — estado actual del pipeline
│       ├── design-tokens.json     — tokens de ui-style-hunter
│       ├── arch-report.md         — reporte de arch-validator
│       ├── componentes/           — código de componentes generados
│       │   ├── Hero.tsx
│       │   ├── FeaturesGrid.tsx
│       │   └── ...
│       └── recursos/              — links, fuentes, paletas usadas
├── stacks/
│   └── <tipo>.md                  — stack canónico por tier de diseño
├── recursos/
│   ├── fuentes.md                 — catálogo de fuentes por tier
│   ├── iconos.md                  — librerías de iconos por tier
│   ├── imagenes.md                — fuentes de imágenes gratuitas
│   └── componentes.md             — libs de componentes disponibles
├── tokens/
│   └── <proyecto>.json            — design tokens por proyecto
└── INDEX.md                       — índice maestro de proyectos
```

## Cuándo usar

- Al finalizar cualquier skill del pipeline → guardar output
- "guarda esto", "persiste los resultados", "guarda el proyecto"
- Al pausar un proyecto para retomarlo después
- Para guardar una referencia visual, stack, o recurso encontrado

## Workflow

### 1. Detectar qué guardar

Identificar el tipo de contenido:
- Brief → `proyectos/<nombre>/brief.md`
- Design tokens → `proyectos/<nombre>/design-tokens.json` + `tokens/<nombre>.json`
- Arch report → `proyectos/<nombre>/arch-report.md`
- Componente → `proyectos/<nombre>/componentes/<Nombre>.tsx`
- Stack → `stacks/<tier>.md`
- Recurso (fuente/imagen/lib) → `recursos/<tipo>.md`
- Pipeline status → `proyectos/<nombre>/pipeline-status.json`

### 2. Crear directorio del proyecto si no existe

```
proyecto_resultado_skill/proyectos/<nombre-proyecto>/
proyecto_resultado_skill/proyectos/<nombre-proyecto>/componentes/
proyecto_resultado_skill/proyectos/<nombre-proyecto>/recursos/
```

### 3. Guardar brief.md

```markdown
# Brief — <Nombre Proyecto>

**Fecha:** <fecha>
**Tier:** <eco|medio|pro|premium|corporate|3d|images|video>
**Stack:** Next.js 15 + TailwindCSS + ...

## Descripción
<qué hace el sitio y para quién>

## CTA Principal
<acción principal del sitio>

## Referencias
- <URL 1>
- <URL 2>

## Notas
<cualquier restricción o preferencia especial>
```

### 4. Guardar pipeline-status.json

```json
{
  "proyecto": "<nombre>",
  "tier": "<tier>",
  "etapa_actual": "<BRIEF|ANALISIS|TIER|STACK|DISENO|SAVE>",
  "etapas_completadas": ["BRIEF", "ANALISIS"],
  "fecha_inicio": "<ISO date>",
  "fecha_ultima_actualizacion": "<ISO date>",
  "notas": "<contexto para retomar>"
}
```

### 5. Guardar componentes generados

Guardar cada componente de código en `componentes/<Nombre>.tsx` con:
- Comentario en línea 1: `// Tier: <tier> | Proyecto: <nombre> | Generado: <fecha>`
- El código limpio del skill de diseño

### 6. Guardar stack canónico por tier

Si es la primera vez que se usa un tier → guardar en `stacks/<tier>.md`:

```markdown
# Stack — <Tier>

**Última actualización:** <fecha>

## Dependencias npm
\`\`\`bash
npm install ...
\`\`\`

## Configuración Tailwind
...

## Estructura de carpetas
...
```

### 7. Actualizar INDEX.md

Al guardar cualquier proyecto nuevo → agregar línea al índice:

```markdown
| <nombre> | <tier> | <fecha> | <etapa actual> | [Ver](proyectos/<nombre>/brief.md) |
```

### 8. Guardar recursos globales

Cuando ui-style-hunter encuentra recursos reutilizables → agregar a `recursos/`:

**fuentes.md** — una entrada por fuente nueva encontrada
**imagenes.md** — fuentes de stock gratuitas descubiertas
**componentes.md** — librerías de componentes con su tier recomendado

## Output

- Archivos guardados en `proyecto_resultado_skill/`
- Confirmación: lista de archivos creados/actualizados
- INDEX.md actualizado

## Notas

- Nunca sobreescribir `brief.md` sin preguntar — puede tener notas manuales
- `pipeline-status.json` sí sobreescribir siempre — es estado volátil
- Componentes: si ya existe uno con mismo nombre, crear `<Nombre>-v2.tsx`
- INDEX.md: mantener ordenado por fecha descendente (más reciente arriba)
