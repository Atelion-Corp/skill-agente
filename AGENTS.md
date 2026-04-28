# Skill Agente

Guía operativa multi-agente para usar este repo en Claude, Codex, OpenCode y agentes similares.

## Principios
- Mantener cambios pequeños y verificables.
- Leer primero `README.md` y luego el `SKILL.md` específico.
- No asumir stack: confirmar desde contexto del usuario.
- Preferir ejecución por fases: diagnóstico -> implementación -> validación.

## Compatibilidad
- Claude Code: usa `.claude-plugin/plugin.json`.
- Codex: usa `.codex-plugin/plugin.json`.
- OpenCode/u otros: consumir `skills/*/SKILL.md` directamente (fallback estándar).

## Flujo recomendado
1. Detectar objetivo y área (`D`, `M`, `V`, `S`, etc.).
2. Cargar solo skills relevantes (evitar sobrecargar contexto).
3. Ejecutar con criterios de éxito explícitos.
4. Validar salida con checklist de calidad.

## Checklist mínimo antes de cerrar
- ¿Se cumplieron criterios funcionales?
- ¿Hay instrucciones reproducibles?
- ¿Se evitó acoplamiento a un único runtime?
- ¿Se actualizaron docs/manifiestos si aplica?