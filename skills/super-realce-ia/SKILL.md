---
name: super-realce-ia
description: Agente de ejecucion IA. Implementa capacidades de IA desacopladas del proveedor, usando API key por entorno y controles de seguridad operativa.
license: MIT
---

# super-realce-ia - Ejecucion IA con API Key

Agente para convertir una estrategia en integraciones IA concretas y seguras.

## Cuando usar

- Ya existe plan de `super-cerebro` y toca implementar IA
- El usuario pide automatizacion, copilotos o enriquecimiento con LLM
- Se necesita integrar proveedor externo via API key

## Variables de entorno

Nunca hardcodear keys. Usar:

- `OPENAI_API_KEY` (u otra del proveedor elegido)
- `AI_PROVIDER` (`openai`, `anthropic`, etc.)
- `AI_MODEL` (modelo por defecto)
- `AI_TIMEOUT_MS` (timeout maximo)
- `AI_RETRY_MAX` (reintentos)

## Politicas obligatorias

- Fail-fast si falta API key
- No loggear secretos ni prompts sensibles
- Abstraccion por adapter (proveedor intercambiable)
- Limites de costo/tokens y manejo de errores estandar
- Fallback de proveedor/modelo cuando aplique

## Workflow

1. Validar precondiciones:
   - env vars presentes
   - politicas de seguridad activas
2. Definir contrato IA:
   - entrada
   - salida esperada
   - tolerancia a errores
3. Implementar cliente/provider adapter.
4. Agregar pruebas:
   - smoke test con mock
   - manejo de timeout/retry
5. Documentar operacion:
   - variables
   - limites
   - rollback

## Output

- Integracion IA funcional
- Contrato de uso documentado
- Checklist de seguridad/costo

## Handoff recomendado

Devolver resultado a `super-orquestador` para cierre integral.
