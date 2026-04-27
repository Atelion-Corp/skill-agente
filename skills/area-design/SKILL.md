---
name: area-design
description: Design area mini-orchestrator — classifies design requests and routes to the right sub-agents (researcher, generator, animator, 3D/graph, media, validator, saver) with minimal context packets. Use when super-orquestador routes to area D, or when a design task needs multiple skills coordinated.
license: MIT
---

# area-design — Design Area Orchestrator

Mini-orquestador del área de diseño. Clasifica solicitudes y delega a sub-agentes con contexto mínimo.

## Sub-agentes del área

| Sub-agente | Skills | Rol |
|------------|--------|-----|
| `design-researcher` | ui-style-hunter | Analizar referencias, detectar tier, design tokens |
| `design-generator` | design-eco/medio/pro/premium/corporate | Generar componentes por tier |
| `design-animator` | design-anime, design-uiverse | Animaciones, scroll physics, Lenis |
| `design-3d-agent` | design-3d, design-graph | 3D escenas, grafos neuronales |
| `design-media` | design-images, design-video, design-remotion | Imágenes, video, motion graphics |
| `design-validator` | arch-validator | Validar arquitectura del diseño |
| `design-saver` | resultado-save | Persistir outputs |

## Routing rápido

```
"referencia", "inspírate en", "analiza URL" → design-researcher
"anima", "transición", "hover", "stagger" → design-animator
"scroll suave", "Lenis", "parallax" → design-animator (design-uiverse)
"3D", "three.js", "R3F", "Spline" → design-3d-agent
"grafo", "neuronas", "conexiones", "Obsidian" → design-3d-agent (design-graph)
"video", "MP4", "GIF", "remotion" → design-media
"valida", "arquitectura", "chequea stack" → design-validator
"guarda", "exporta", "salva" → design-saver
ELSE → design-generator (activar design-researcher si no hay tier)
```

## Paquete de contexto (area-design → sub-agente)

```json
{
  "req": "hero section premium",
  "skill": "design-premium",
  "ctx": {
    "tier": "premium",
    "stack": "Next.js+Tailwind",
    "tokens": { "font": "Playfair Display", "color": "#0a0a0a", "accent": "#c9a96e" }
  },
  "bp": ["BP-D-001", "BP-D-003"],
  "budget": 300
}
```

## Flujo de routing

```
Input recibido del super-orquestador o usuario
    │
    ▼
1. Detectar tipo → asignar sub-agente
    │
    ▼
2. ¿Hay tier definido?
    ├── Sí → enviar a generator con contexto
    └── No → activar design-researcher primero
    │
    ▼
3. Enviar paquete mínimo (≤200 tokens) al sub-agente
    │
    ▼
4. Recibir resultado → consolidar → responder
    │
    ▼
5. Si hay más pasos → activar siguiente sub-agente
    │
    ▼
6. Activar design-saver al finalizar
```

## Cascada por complejidad

```
Simple (1 cosa):     1 sub-agente → 1 skill
Media:               researcher → generator → saver
Compleja:            researcher → generator → animator → validator → saver
```

## Límites

- Máx 5 sub-agentes por tarea (más → dividir en subtareas)
- Budget por sub-agente: ≤200 tokens de contexto
- No repetir análisis entre sub-agentes (compartir ctx comprimido)
- No invocar validator en prototipos rápidos (solo en producción)

## Output

- Artefactos de diseño generados (paths)
- Estado de cada sub-agente activado
- Tier y design tokens usados
- Próximos pasos recomendados
