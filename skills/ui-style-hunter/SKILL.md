---
name: ui-style-hunter
description: Busca y adapta estilos, recursos, stacks y patrones visuales de sitios de referencia para diseño UI web. Usar cuando el usuario quiere copiar, inspirarse, o analizar el diseño de un sitio.
license: MIT
---

# ui-style-hunter — Cazador de Estilos UI

Analiza sitios de referencia, extrae su stack técnico, paleta, tipografía, componentes, y genera un design token file o guía de implementación adaptada al proyecto actual.

## Cuándo usar

- "busca estilos como X", "quiero algo similar a Y", "copia el look de Z"
- "qué stack usa este sitio", "analiza el diseño de esta URL"
- "dame los colores / fuentes / componentes de referencia"
- Usuario pega una URL y pide replicar o inspirarse en ella

## Workflow

### 1. Intake de referencia

Pedir al usuario:
- URL(s) de referencia (1–3 sitios)
- Elemento específico a cazar: paleta, tipografía, layout, componentes, animaciones, o todo
- Stack del proyecto destino (ej: Next.js + TailwindCSS, React + CSS Modules, vanilla)

### 2. Análisis del sitio de referencia

Para cada URL, usar `WebFetch` para inspeccionar el HTML/CSS visible:
- **Stack detectado**: frameworks en `<script>`, meta tags, class prefixes (`tw-`, `chakra-`, etc.)
- **Paleta**: colores dominantes en CSS variables, inline styles, Tailwind config
- **Tipografía**: font-family stack, Google Fonts `<link>`, variantes de peso
- **Layout**: sistema de grid (CSS Grid / Flexbox / columnas), breakpoints
- **Componentes clave**: navbar, hero, cards, CTAs, footer — estructura HTML
- **Animaciones**: librerías (Framer Motion, GSAP, AOS, CSS transitions)
- **Iconos**: Lucide, Heroicons, Font Awesome, custom SVGs

### 3. Clasificar el tier de diseño

Mapear la referencia a un tier:
| Tier | Señales |
|------|---------|
| eco | Paleta neutra, sin JS extra, CSS puro, bajo impacto |
| medio | Tailwind + shadcn, componentes estándar, animaciones sutiles |
| pro | Custom design system, micro-interacciones, tipografía premium |
| premium | Scroll storytelling, glassmorphism, partículas, video hero |
| corporate | Estructura formal, colores corporativos, grids densos |
| 3d | Three.js / R3F / Spline embeds, perspectiva, WebGL |
| graph | Force-directed 3D, neuronas, conocimiento, Obsidian-like |
| anime | Animaciones complejas, Anime.js, stagger, SVG morphing |
| scroll | Lenis, GSAP scroll, parallax, scroll storytelling |
| video | Video hero, scroll-driven video, Remotion |

### Patrones Seesaw.website

Seesaw es una galería curada de diseño de alta calidad. Si la referencia es de este estilo:

```
Señales Seesaw:
  - Visual-first: imagen o ilustración domina el 60-80% del viewport
  - Tipografía editorial: serif grande + sans-serif cuerpo
  - Paleta reducida: máx 3 colores, mucho blanco/negro
  - Grid asimétrico o irregular
  - Animaciones de hover sofisticadas (reveal, clip-path, mask)
  - Portfolio / branding / identidad visual

Stack típico:
  Next.js + CSS Modules o Tailwind (minimal config)
  GSAP para hover reveals
  next/image con object-fit: cover
  Sin frameworks UI (shadcn/Radix raramente)
```

### Patrones UIverse.io

UIverse es una librería de componentes CSS/Tailwind open-source. Si busca componentes específicos:

```
Componentes frecuentes:
  - Scroll suave: Lenis + GSAP ScrollTrigger
  - Cards con hover 3D: perspective + transform
  - Botones con efectos: ripple, magnetic, fill
  - Loaders: CSS animation puro
  - Inputs con floating labels

Stack típico:
  CSS puro o Tailwind
  Sin JS (componentes CSS only)
  Cuando hay JS: GSAP o Motion
```

### 4. Generar design tokens

Crear `design-tokens.json` (o `tailwind.config.js` extend) con:
```json
{
  "colors": { "primary": "#...", "surface": "#..." },
  "fonts": { "heading": "...", "body": "..." },
  "spacing": { "section": "..." },
  "radius": { "card": "..." },
  "shadows": { "card": "..." }
}
```

### 5. Generar guía de implementación

Producir un bloque Markdown con:
- Stack recomendado para replicar el look
- Componentes a instalar (`npx shadcn@latest add ...`, npm packages)
- Snippet CSS/Tailwind del componente principal detectado
- 3 "gotchas" de implementación específicos del estilo analizado

## Output

- `design-tokens.json` — tokens listos para importar
- Guía Markdown con stack, componentes, snippets
- Tier clasificado → recomendación de usar skill `design-<tier>`

## Notas

- Si la URL falla con WebFetch, pedir screenshot o descripción manual
- No inventar colores exactos si no se pueden leer del HTML — reportar "no detectado"
- Priorizar tokens que el stack destino puede consumir nativamente
