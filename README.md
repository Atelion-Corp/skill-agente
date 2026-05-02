# skill-agente

![Orchestrator](https://img.shields.io/badge/Orchestrator-Multi--Agent-0F172A?style=for-the-badge)
![Design](https://img.shields.io/badge/Area-Design-2563EB?style=for-the-badge)
![Marketing](https://img.shields.io/badge/Area-Marketing-16A34A?style=for-the-badge)
![Engineering](https://img.shields.io/badge/Area-Engineering-DC2626?style=for-the-badge)
![Runtime](https://img.shields.io/badge/Runtime-OpenClaw%20First-9333EA?style=for-the-badge)

Plugin de skills multi-agente para Claude, Codex y OpenClaw-first runtimes.

## Arquitectura multi-agente v2.0

```
Usuario
  │
  ▼
super-orquestador  ← master orchestrator, contexto mínimo, 4 modos
  │
  ├── area-design [D]    → design-eco/medio/pro/premium/corporate + 3d/anime/uiverse/images/video
  ├── area-mkt [M]       → mkt-base/copy/seo/cro/growth
  ├── area-eng [E]       → Marco (backend) · Valentina (frontend) · Tomás (devops)
  │                         Lena (security) · Carlos (database) · Sofía (qa)
  ├── area-product [P]   → Ana (product-manager) · Luis (product-analyst)
  ├── area-ops [O]       → Elena (ops-pm) · Rodrigo (ops-strategy)
  └── area-data [DA]     → Camila (data-analyst)
```

Sub-agentes son **expertos con identidad** — cada uno tiene persona, reglas FORBIDDEN explícitas y métricas de éxito verificables.

## Normas Duras
- API base oficial: `/api/`.
- Prohibido usar `/api/v1/` o cualquier versionado en la ruta base API.
- Puertos canonicos no se alteran sin aprobacion tecnica.
- Credenciales siempre enmascaradas en documentacion.

## Regla Operativa De Puertos
- No improvisar puertos ni cambiar secuencias definidas.
- Mantener puertos establecidos por proyecto y entorno.
- Cualquier cambio requiere aprobacion tecnica explicita.

## Regla De Proxy
- Nginx principal corre en el servidor (host), no dentro de Docker para publicacion principal.
- El servidor redirige dominios a puertos Docker segun servicio.

## OpenClaw-first baseline

- Runtime único: OpenClaw.
- Contratos de skills: `contracts/skills-contracts.json`.
- Allowlist SSH: `config/ssh-command-allowlist.txt`.
- Política operativa: `docs/openclaw-first-implementation.md`.
- Skills nuevas: `openclaw-runtime`, `deploy-guardian`

## Compatibilidad de runtimes

- Claude Code: `.claude-plugin/plugin.json`
- Codex: `.codex-plugin/plugin.json`
- OpenClaw: runtime principal usando `config/openclaw-runtime.json`
- Otros agentes: carga directa de `skills/*/SKILL.md` + `AGENTS.md`

## Skills disponibles (62 total)

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
| `hermes-agent-loop` | Auto-mejora continua controlada (plan → run → review → learn → update) |
| `ecosystem-curator` | Curador de ecosistema: evalua skills/plugins externos y propone integraciones seguras |

### Análisis

| Skill | Descripción |
|-------|-------------|
| `ui-style-hunter` | Analiza referencias: stack, paleta, tier (incluye Seesaw + UIverse patterns) |
| `tailwind-ui-hunter` | Discovery y filtro de bloques Tailwind UI (TailwindFlex/Dribbble/Froala/Flowbite/shadcn) |
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

### Engineering — Sub-Agentes Expertos [E]

| Skill | Persona | Expertise |
|-------|---------|-----------|
| `area-eng` | Engineering Lead | Mini-orquestador: clasifica y delega a eng-* |
| `eng-backend` | Marco | Django 5.2 + DRF + PostgreSQL + Redis + JWT |
| `eng-frontend` | Valentina | Next.js 15 + TypeScript + Tailwind + TanStack Query |
| `eng-devops` | Tomás | Docker + GitHub Actions + Nginx + SSL + monitoring |
| `eng-security` | Lena | OWASP Top 10 + secrets audit + auth hardening |
| `eng-database` | Carlos | PostgreSQL schema + indexing + query optimization + Redis |
| `eng-qa` | Sofía | pytest + jest + Playwright E2E + coverage strategy |

### Product [P]

| Skill | Persona | Expertise |
|-------|---------|-----------|
| `area-product` | Product Lead | Mini-orquestador: clasifica y delega a product-* |
| `product-manager` | Ana | Roadmaps + PRDs + user stories + OKRs + RICE |
| `product-analyst` | Luis | Métricas + funnel + A/B tests + SQL + dashboards |

### Operations & Management [O]

| Skill | Persona | Expertise |
|-------|---------|-----------|
| `area-ops` | Operations Lead | Mini-orquestador: clasifica y delega a ops-* |
| `ops-pm` | Elena | Agile/Scrum + sprint planning + retrospectivas |
| `ops-strategy` | Rodrigo | GTM + unit economics + competitive analysis |

### Data & Analytics [DA]

| Skill | Persona | Expertise |
|-------|---------|-----------|
| `area-data` | Data Lead | Mini-orquestador: clasifica y delega a data-* |
| `data-analyst` | Camila | SQL avanzado + pandas + KPIs + visualización + retención |

### Dev (legacy pipeline) [V]

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

### Feature completa (full-stack)

```
/super-orquestador → area-eng
  → Carlos (eng-database): schema + índices
  → Marco (eng-backend): API + tests unitarios
  → Valentina (eng-frontend): UI + TanStack Query
  → Sofía (eng-qa): suite de tests E2E
  → Tomás (eng-devops): CI pipeline
```

### Lanzamiento de producto

```
/super-orquestador → area-product + area-ops + area-mkt
  Ana (product-manager): PRD + criterios de éxito
  Rodrigo (ops-strategy): GTM + unit economics
  Elena (ops-pm): sprint planning del lanzamiento
  mkt-copy + mkt-seo: mensajes + optimización
```

### Análisis de negocio

```
/super-orquestador → area-data + area-product
  Camila (data-analyst): SQL + visualización
  Luis (product-analyst): interpretación + A/B design
  Ana (product-manager): decisiones de producto
```

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
modo pro                     → discovery profundo + planificacion + ingestion extendida
```

### Operacion multiusuario

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

### Claude Code
- **Manage Plugins** → agregar este directorio como plugin local.

### Codex
- Cargar plugin desde `.codex-plugin/plugin.json`.

### OpenCode / otros
- Importar skills desde `skills/` y usar `AGENTS.md` como guía operacional.

### OpenClaw
- Usar `config/openclaw-runtime.json` como perfil base del runtime.

## Validación antes de subir

```powershell
pwsh -File scripts/validate-plugin.ps1
```

## Auto-mejora Hermes

```powershell
pwsh -File scripts/hermes-autoupgrade.ps1 -ProjectId "skill_agente" -Goal "mejorar calidad del plugin" -Apply
```

---

## Estructura de directorios

```
skill_agente/
├── README.md
├── AGENTS.md
├── bp/
│   ├── practices.json
│   └── SCHEMA.md
└── skills/
    ├── super-orquestador/   ← master orchestrator
    ├── super-cerebro/
    ├── super-realce-ia/
    ├── agent-context/
    ├── area-design/         ← design area lead
    ├── area-mkt/            ← marketing area lead
    ├── area-eng/            ← engineering area lead (v2)
    ├── area-product/        ← product area lead (v2)
    ├── area-ops/            ← operations area lead (v2)
    ├── area-data/           ← data area lead (v2)
    ├── eng-backend/         ← Marco: Django+DRF expert (v2)
    ├── eng-frontend/        ← Valentina: Next.js expert (v2)
    ├── eng-devops/          ← Tomás: Docker+CI/CD expert (v2)
    ├── eng-security/        ← Lena: OWASP security expert (v2)
    ├── eng-database/        ← Carlos: PostgreSQL architect (v2)
    ├── eng-qa/              ← Sofía: QA/test engineer (v2)
    ├── product-manager/     ← Ana: PM expert (v2)
    ├── product-analyst/     ← Luis: product analytics (v2)
    ├── ops-pm/              ← Elena: Scrum master (v2)
    ├── ops-strategy/        ← Rodrigo: business strategy (v2)
    ├── data-analyst/        ← Camila: data analyst (v2)
    ├── skill-pipeline/
    ├── mkt-pipeline/
    ├── dev-pipeline/
    ├── resultado-save/
    ├── skill-creator/
    ├── ultrareview/
    ├── ui-style-hunter/
    ├── arch-validator/
    ├── design-eco/
    ├── design-medio/
    ├── design-pro/
    ├── design-premium/
    ├── design-corporate/
    ├── design-3d/
    ├── design-graph/
    ├── design-anime/
    ├── design-uiverse/
    ├── design-images/
    ├── design-video/
    ├── design-remotion/
    ├── design-tinymce/
    ├── mkt-base/
    ├── mkt-copy/
    ├── mkt-seo/
    ├── mkt-cro/
    ├── mkt-growth/
    └── dev-*/               (scaffold, docker, migrate, test, seed, env, ports)
```
