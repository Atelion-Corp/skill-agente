# skill-agente

Plugin de Claude Code con skills para diseño web completo — desde análisis de referencias hasta implementación por tier, con orquestación de pipeline y guardado de resultados.

## Skills disponibles

### Orquestación

| Skill | Comando | Descripción |
|-------|---------|-------------|
| skill-pipeline | `/skill-pipeline` | Guía el proyecto por etapas: brief → análisis → tier → stack → diseño → save |
| resultado-save | `/resultado-save` | Persiste todos los outputs en `proyecto_resultado_skill/` |
| skill-creator | `/skill-creator` | Genera nuevos SKILL.md para este u otros plugins |

### Análisis y validación

| Skill | Comando | Descripción |
|-------|---------|-------------|
| ui-style-hunter | `/ui-style-hunter` | Analiza sitios de referencia — stack, paleta, tipografía, tier |
| arch-validator | `/arch-validator` | Valida arquitectura contra patrón Django+Next.js+Docker |

### Diseño por tier

| Skill | Comando | Tier |
|-------|---------|------|
| design-eco | `/design-eco` | Natural, orgánico, performance-first, mínimo JS |
| design-medio | `/design-medio` | SaaS estándar, shadcn/ui, animaciones sutiles |
| design-pro | `/design-pro` | Agencia, dark mode, micro-interacciones, design system |
| design-premium | `/design-premium` | Luxury, scroll storytelling, Framer Motion, Lenis |
| design-corporate | `/design-corporate` | B2B, formal, autoridad, grids densos |
| design-3d | `/design-3d` | Three.js / React Three Fiber / Spline |
| design-images | `/design-images` | Galerías, portfolios, lightbox, art direction |
| design-video | `/design-video` | Video background, player custom, scroll-driven |

## Repositorio de resultados

Todos los outputs se guardan en:
```
C:\Users\diego\Documents\Propio\proyecto_resultado_skill\
```

Estructura:
```
proyecto_resultado_skill/
├── proyectos/<nombre>/    — brief, tokens, componentes, estado del pipeline
├── stacks/               — stacks canónicos por tier
├── recursos/             — fuentes, imágenes, componentes catalogados
├── tokens/               — design tokens por proyecto
└── INDEX.md             — índice maestro
```

## Flujo recomendado

```
/skill-pipeline → guía todo el proceso automáticamente
```

O manual:
```
1. /ui-style-hunter    — analizar referencias
2. /design-<tier>      — implementar diseño
3. /arch-validator     — validar arquitectura
4. /resultado-save     — guardar todo
```

## Instalación

En Claude Code, abre **Manage Plugins** y agrega este directorio como plugin local.

## Estructura

```
skill_agente/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── skills/
│   ├── skill-creator/SKILL.md
│   ├── skill-pipeline/SKILL.md
│   ├── resultado-save/SKILL.md
│   ├── ui-style-hunter/SKILL.md
│   ├── arch-validator/SKILL.md
│   ├── design-3d/SKILL.md
│   ├── design-images/SKILL.md
│   ├── design-video/SKILL.md
│   ├── design-corporate/SKILL.md
│   ├── design-premium/SKILL.md
│   ├── design-eco/SKILL.md
│   ├── design-medio/SKILL.md
│   └── design-pro/SKILL.md
└── README.md
```
