---
name: skill-pipeline
description: Orquestador de etapas para proyectos de diseño web. Valida progreso por fase, consulta contexto acumulado, simplifica decisiones, y decide qué skill activar a continuación. Usar para guiar proyectos complejos de inicio a fin.
license: MIT
---

# skill-pipeline — Orquestador de Etapas

Skill maestro que guía al usuario por las fases de un proyecto de diseño web. Valida que cada etapa esté completa antes de avanzar, consulta el contexto guardado en `proyecto_resultado_skill`, y decide qué skill del plugin activar.

## Cuándo usar

- "empieza un proyecto de diseño", "guíame por el proceso"
- "valida mi etapa", "estoy en la fase X, qué sigue"
- "simplifica — qué debo decidir ahora"
- Al inicio de cualquier proyecto que use los skills de diseño de este plugin

## Etapas del pipeline

```
[1. BRIEF] → [2. ANÁLISIS] → [3. TIER] → [4. STACK] → [5. DISEÑO] → [6. SAVE]
```

| Etapa | Skill activado | Entregable |
|-------|---------------|------------|
| 1. BRIEF | (intake directo) | `brief.md` en resultado |
| 2. ANÁLISIS | `ui-style-hunter` | `design-tokens.json` + tier detectado |
| 3. TIER | (decisión guiada) | tier confirmado (eco/medio/pro/premium/corporate/3d/video/images) |
| 4. STACK | `arch-validator` | checklist de arquitectura validada |
| 5. DISEÑO | `design-<tier>` | componentes implementados |
| 6. SAVE | `resultado-save` | todo guardado en `proyecto_resultado_skill` |

## Workflow

### 1. Detectar etapa actual

Al activarse, preguntar:
> "¿Estás empezando un proyecto nuevo o retomando uno?"

Si nuevo → empezar desde BRIEF.
Si retomando → leer `proyecto_resultado_skill/proyectos/<nombre>/pipeline-status.json` y detectar dónde quedó.

### 2. Etapa BRIEF — recolectar contexto base

Preguntar en orden (no todos de golpe — esperar respuesta antes de seguir):

1. "¿Cuál es el nombre del proyecto?"
2. "¿Qué hace el sitio y para quién?"
3. "¿Tienes referencias visuales? (URLs, imágenes, descripción)"
4. "¿Cuál es el CTA principal del sitio?"
5. "¿Tienes stack definido o empezamos desde cero?"

Guardar respuestas en memoria de sesión. Al finalizar → activar `resultado-save` para crear `brief.md`.

### 3. Etapa ANÁLISIS — activar ui-style-hunter

Si el usuario dio URLs de referencia:
> "Voy a analizar las referencias con `ui-style-hunter`. Dame un momento."

Activar mentalmente el workflow de ui-style-hunter con las URLs del brief.
Output: tier detectado + design tokens.

### 4. Etapa TIER — confirmar con el usuario

Presentar opciones simplificadas:

```
Basado en el análisis, tu proyecto encaja mejor en:

  ● ECO        — natural, orgánico, verde, performance-first
  ● MEDIO      — SaaS estándar, moderno, shadcn/ui
  ● PRO        — agencia, dark mode, micro-interacciones
  ● PREMIUM    — luxury, scroll storytelling, alta estética
  ● CORPORATE  — empresa, B2B, autoridad, formal
  ● 3D         — Three.js / R3F / Spline
  ● GRAFO      — red neuronal, conocimiento, Obsidian-style 3D
  ● ANIME      — animaciones complejas, Anime.js, stagger, SVG morphing
  ● SCROLL     — Lenis + GSAP, parallax, scroll physics (UIverse)
  ● IMÁGENES   — galería, portfolio, image-heavy
  ● VIDEO      — background video, player, scroll-driven
  ● REMOTION   — video programático con código (MP4/GIF)
  ● EDITOR     — rich text editor, WYSIWYG, TinyMCE/Tiptap

¿Confirmas [TIER DETECTADO] o prefieres otro?
```

### 5. Etapa STACK — validar arquitectura

Si el proyecto tiene código existente → activar `arch-validator`.
Si es nuevo → recomendar el stack del tier:
- Medio/Pro/Premium/Corporate/Eco: Next.js 15 + TailwindCSS + shadcn/ui
- 3D: + @react-three/fiber + drei
- Grafo: + react-force-graph-3d + d3-force-3d
- Anime: + animejs
- Scroll: + @studio-freight/lenis + gsap
- Video: + react-player
- Remotion: + remotion + @remotion/player
- Imágenes: next/image + yet-another-react-lightbox
- Editor: + @tiptap/react + @tiptap/starter-kit (o @tinymce/tinymce-react)

### 6. Etapa DISEÑO — activar skill correcto

Activar el skill correspondiente con el contexto acumulado:
- brief del proyecto
- design tokens del análisis
- stack validado

| Tier | Skill |
|------|-------|
| eco/medio/pro/premium/corporate | `design-<tier>` |
| 3d | `design-3d` |
| grafo | `design-graph` |
| anime | `design-anime` |
| scroll | `design-uiverse` |
| imágenes | `design-images` |
| video | `design-video` |
| remotion | `design-remotion` |
| editor | `design-tinymce` |

### 7. Etapa SAVE — activar resultado-save

Al finalizar componentes → activar `resultado-save` para persistir todo.

### Comandos de control del pipeline

El usuario puede en cualquier momento:
- "¿en qué etapa estoy?" → mostrar pipeline con la etapa actual marcada
- "simplifica" → resumir en 1 oración qué hay que decidir ahora
- "¿qué falta?" → listar etapas pendientes
- "saltear a [etapa]" → avanzar sin validar (advertir qué se pierde)
- "guardar y pausar" → activar resultado-save y dejar todo guardado para retomar

## Output

El pipeline no produce archivos directamente — orquesta los otros skills. Su output final es el proyecto completo en `proyecto_resultado_skill`.

## Notas

- Hacer UNA pregunta a la vez en BRIEF — no bombardear con formulario
- "simplifica" = detectar la decisión bloqueante y presentarla en ≤3 opciones
- Si el usuario ya tiene contexto claro, saltear preguntas ya respondidas
- Pipeline status se guarda en `proyecto_resultado_skill/proyectos/<nombre>/pipeline-status.json`
