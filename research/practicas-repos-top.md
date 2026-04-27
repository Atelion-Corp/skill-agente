# Practicas Open Source de Repos Top

Fecha de extraccion: 2026-04-27

Repos usados:
- https://github.com/tldraw/tldraw
- https://github.com/TanStack/query
- https://github.com/vuetifyjs/vuetify
- https://www.repoverse.space/trending

## Practicas detectadas

1. Arquitectura extensible por primitivas
- tldraw prioriza primitives (shapes, tools, bindings, UI components) para que terceros extiendan sin tocar el core.
- Regla para skills: disenar capacidades en modulos pequenos, no flujos monoliticos.

2. Documentacion-first y starter kits
- tldraw y vuetify muestran docs, ejemplos y scaffolding en primera capa.
- Regla para skills: cada skill debe declarar "cuando usar", "workflow", "output" y comandos de arranque.

3. Comunidad con canales bien delimitados
- TanStack y Vuetify separan dudas (discussions/chat) de bugs (issues), evitando ruido.
- Regla para skills: en triage, enrutar preguntas generales a discovery y solo abrir tareas de implementacion con criterio tecnico.

4. Contribucion guiada con politicas claras
- TanStack exige setup reproducible (pnpm/corepack/nvm), tests desde root y cambios de docs.
- tldraw explicita su politica temporal de PR externas.
- Regla para skills: definir precondiciones del entorno, politica de contribucion y criterio de aceptacion.

5. Monorepo con herramientas de consistencia
- TanStack usa Nx y cambios centralizados desde raiz.
- Regla para skills: ejecutar validaciones desde root, estandarizar scripts y evitar comandos locales inconsistentes por subcarpeta.

6. Release management automatizado
- TanStack usa Changesets y workflow de publicacion.
- Regla para skills: toda mejora relevante debe incluir impacto de versionado/changelog.

7. Multi-framework y multi-runtime
- TanStack soporta React/Vue/Svelte/Solid; Vuetify facilita Vite/Nuxt/Laravel/CDN.
- Regla para skills: prompts y salidas deben ser framework-agnostic cuando sea posible, y declarar adaptadores.

8. Rendimiento y DX como requisito
- Vuetify destaca tree-shaking y soporte de bundlers modernos.
- Regla para skills: medir costo (latencia/token/build time) antes de agregar complejidad.

9. Integracion IA como capa, no acoplamiento duro
- tldraw expone AI integrations sobre primitives del canvas.
- Regla para skills: `super-realce-ia` debe abstraer proveedor y usar API key via env vars, sin hardcode.

10. Senales de tendencia para priorizar
- `repoverse.space/trending` se usa como senal para detectar practicas emergentes y toolchains que ganan adopcion.
- Regla para skills: revisar tendencias periodicamente y ajustar prompts/plantillas cada ciclo.

## Checklist operativo para nuevos skills

- Definir scope pequeno y extensible.
- Declarar entradas/salidas y contrato de calidad.
- Incluir pruebas de humo y rollback.
- Versionar cambios de comportamiento.
- Documentar riesgos y decisiones.
