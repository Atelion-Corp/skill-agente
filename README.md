# skill-agente

Plugin de Claude Code con skills para diseño web, marketing, desarrollo, orquestación multi-agente y gestión de contexto.

## Arquitectura multi-agente

```
Usuario
  │
  ▼
super-orquestador  ← cerebro maestro, contexto mínimo
  │
  ├── area-design   → researcher, generator, animator, 3d, media, validator, saver
  ├── area-mkt      → researcher, copy, seo, cro, growth, strategy
  └── (dev, auto, test, data, finance — próximos)
```

Cada nivel pasa paquetes de contexto mínimo (≤500 tokens orchestrator→area, ≤200 area→sub-agente).

---

## Skills disponibles (44 total)

### Orquestación

| Skill | Área |
|-------|------|
| `super-orquestador` | Master orchestrator multi-área, API keys gratuitas, BP DB, modos (`simple/normal/desarrollo-monitoreo/pro`) y monitoreo por input |
| `super-cerebro` | Estrategia técnica, arquitectura, roadmap |
| `super-realce-ia` | Aceleración IA con API key externa |
| `agent-context` | Context engineering: capacidad efectiva, paquetes mínimos |
| `area-design` | Design area mini-orchestrator |
| `area-mkt` | Marketing area mini-orchestrator |

### Pipelines

| Skill | Área |
|-------|------|
| `skill-pipeline` | Diseño web: brief → análisis → tier → stack → diseño → save |
| `mkt-pipeline` | Marketing: brief → contexto → estrategia → contenido → SEO → CRO → growth |
| `dev-pipeline` | Dev: scaffold → docker → migrate → test → seed |
| `resultado-save` | Persistir outputs en `proyecto_resultado_skill/` |

### Análisis

| Skill | Descripción |
|-------|-------------|
| `ui-style-hunter` | Analiza referencias: stack, paleta, tier (incluye Seesaw + UIverse patterns) |
| `arch-validator` | Valida arquitectura Django+Next.js+Docker |

### Diseño — tiers

| Skill | Tier |
|-------|------|
| `design-eco` | Natural, orgánico, verde, CSS puro |
| `design-medio` | SaaS estándar, shadcn/ui, animaciones sutiles |
| `design-pro` | Agencia, dark mode, micro-interacciones |
| `design-premium` | Luxury, scroll storytelling, Lenis, cursor magnético |
| `design-corporate` | B2B, formal, navy/gris, serif headers |

### Diseño — técnicas

| Skill | Tecnología |
|-------|-----------|
| `design-3d` | Three.js / React Three Fiber / Spline |
| `design-graph` | 3D neuron graph (Obsidian-style), react-force-graph-3d, d3-force |
| `design-anime` | Anime.js: stagger, timeline, spring, SVG morphing |
| `design-uiverse` | Lenis + GSAP: smooth scroll, parallax, horizontal scroll |
| `design-images` | Galerías, masonry, lightbox, next/image |
| `design-video` | Video hero, player custom, scroll-driven |
| `design-remotion` | Video programático React: MP4/GIF, interpolate, spring |
| `design-tinymce` | Editores WYSIWYG: TinyMCE, Tiptap, Editor.js |

### Marketing

| Skill | Descripción |
|-------|-------------|
| `mkt-base` | Contexto base: producto, ICP, USP, voz de marca |
| `mkt-copy` | Copywriting: landing, email, cold outreach, social, ads |
| `mkt-seo` | SEO técnico, on-page, E-E-A-T, schema, GEO (AI search) |
| `mkt-cro` | CRO: landing, signup flow, onboarding, forms, paywall |
| `mkt-growth` | Growth: churn, referral, lead magnets, PLG |

### Dev

| Skill | Descripción |
|-------|-------------|
| `dev-scaffold` | Scaffold Django+Next.js+Docker |
| `dev-dockerize` | Dockerizar proyecto |
| `dev-docker-ops` | Operaciones Docker (compose, logs, exec) |
| `dev-ports` | Gestión de puertos |
| `dev-migrate` | Migraciones Django |
| `dev-env` | Variables de entorno |
| `dev-test` | Tests |
| `dev-seed` | Seed de datos |

### Herramientas

| Skill | Descripción |
|-------|-------------|
| `skill-creator` | Genera nuevos SKILL.md |
| `ultrareview` | Guía para `/ultrareview` multi-agent cloud review |

---

## Flujos recomendados

### Diseño web completo

```
/skill-pipeline → guía todo el proceso automáticamente
```

### Marketing completo

```
/mkt-pipeline → guía desde brief hasta growth
```

### Tarea compleja multi-área

```
/super-orquestador → clasifica y delega a areas con contexto mínimo
```

### Modos del orquestador

```
modo simple                  → corto, directo, minimo preguntas
modo normal                  → balance entre discovery y ejecucion
modo desarrollo-monitoreo    → ejecucion + acumulado de tokens/tiempo/agentes/skills por input
modo pro                     → discovery profundo + planificacion + ingestion extendida (imagenes/PDF/carpetas)
```

### Operacion multiusuario (nuevo)

- Identidad operacional por: `tenant_id`, `user_id`, `session_id`, `project_id`, `request_id`.
- Telemetria acumulada por input con trazabilidad por sesion/proyecto.
- Seleccion dinamica de modo segun complejidad/riesgo/carga.
- Plantillas listas:
  - `skills/super-orquestador/SESSION_STATE.template.json`
  - `skills/super-orquestador/MONITOR_ENTRY.template.json`

### Diseño puntual

```
/ui-style-hunter (analizar refs) → /design-<tier> → /resultado-save
```

### Animaciones

```
/design-anime        → stagger, timeline, spring, SVG morphing
/design-uiverse      → Lenis smooth scroll, parallax, GSAP
/design-graph        → 3D neuron graph (Obsidian-style)
```

---

## Best Practices DB

```
skill_agente/bp/
├── practices.json    — 30+ prácticas indexadas por área/tags
└── SCHEMA.md         — schema y convenciones de ID
```

Búsqueda rápida por área + tags. Cargada on-demand por los area orchestrators.

---

## Repositorio de resultados

```
proyecto_resultado_skill/
├── proyectos/<nombre>/
│   ├── brief.md
│   ├── pipeline-status.json
│   ├── design-tokens.json
│   ├── mkt-context.json
│   └── componentes/
├── stacks/
├── recursos/
└── INDEX.md
```

---

## Instalación

En Claude Code: **Manage Plugins** → agregar este directorio como plugin local.

---

## Estructura de directorios

```
skill_agente/
├── README.md
├── bp/
│   ├── practices.json
│   └── SCHEMA.md
├── research/
│   └── practicas-repos-top.md
└── skills/
    ├── super-orquestador/   ← master orchestrator (redesignado)
    ├── super-cerebro/
    ├── super-realce-ia/
    ├── agent-context/       ← context engineering (nuevo)
    ├── area-design/         ← design area lead (nuevo)
    ├── area-mkt/            ← marketing area lead (nuevo)
    ├── skill-pipeline/      ← mejorado (13 tiers)
    ├── mkt-pipeline/        ← nuevo
    ├── dev-pipeline/
    ├── resultado-save/
    ├── skill-creator/
    ├── ultrareview/         ← nuevo
    ├── ui-style-hunter/     ← mejorado (Seesaw + UIverse)
    ├── arch-validator/
    ├── design-eco/
    ├── design-medio/
    ├── design-pro/
    ├── design-premium/
    ├── design-corporate/
    ├── design-3d/           ← mejorado (referencia a design-graph)
    ├── design-graph/        ← nuevo (Obsidian-style 3D)
    ├── design-anime/        ← nuevo (Anime.js)
    ├── design-uiverse/      ← nuevo (Lenis + GSAP scroll)
    ├── design-images/
    ├── design-video/        ← mejorado (referencia a design-remotion)
    ├── design-remotion/     ← nuevo (Remotion video)
    ├── design-tinymce/      ← nuevo (TinyMCE / Tiptap)
    ├── mkt-base/            ← nuevo
    ├── mkt-copy/            ← nuevo
    ├── mkt-seo/             ← nuevo
    ├── mkt-cro/             ← nuevo
    ├── mkt-growth/          ← nuevo
    └── dev-*/               (scaffold, docker, migrate, test, seed, env, ports)
```
