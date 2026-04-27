---
name: agent-context
description: Apply context engineering principles to multi-agent systems — optimize token usage, prevent context degradation, design minimal context packets for sub-agents, manage effective capacity. Use when designing multi-agent workflows, debugging agent performance degradation, or optimizing token costs.
license: MIT
---

# agent-context — Context Engineering

Principios y patrones para gestión óptima de contexto en sistemas multi-agente.

## Cuándo usar

- Diseñando arquitectura multi-agente
- "reduce el contexto del agente", "por qué degrada"
- Optimizando costo de tokens
- Antes de pasar contexto entre orchestrator y sub-agentes

## Principios críticos

### Capacidad efectiva = 60-70% del nominal

```
Modelo 200K → efectivo: 120K-140K
Modelo 100K → efectivo: 60K-70K
```

Degradación empieza antes del límite oficial.

### Posición = recall

| Posición | Recall |
|----------|--------|
| Inicio + Final | 85-95% |
| Medio | 76-82% |

→ Instrucciones críticas: inicio o final. Nunca al medio.

### Overhead de herramientas

```
10 tools × 500-800 tokens = 5K-8K tokens pre-mensaje
Tool output se expande 2-3x al serializarse
```

→ Limitar tools por agente. 1 rol = herramientas específicas.

### Historial crece silenciosamente

```
20-30 iteraciones → historial = 70-80% del contexto
```

→ Comprimir al 70% de utilización. Reemplazar outputs con resúmenes.

## Paquete de contexto mínimo

### Orchestrator → Area Lead (≤500 tokens)

```json
{
  "v": 1,
  "req": "<solicitud ≤30 tokens>",
  "area": "D",
  "proj": "nombre-proyecto",
  "ctx": { "<solo datos de decisión>" },
  "bp": ["BP-D-001", "BP-D-004"],
  "budget": 300,
  "api": "gemini|groq|null"
}
```

### Area Lead → Sub-agente (≤200 tokens)

```json
{
  "req": "hero section premium",
  "skill": "design-premium",
  "ctx": { "tier": "premium", "font": "Playfair", "color": "#0a0a0a" },
  "bp": ["BP-D-003"],
  "budget": 200
}
```

### Sub-agente → Resultado (≤300 tokens)

```json
{
  "ok": true,
  "skill": "design-premium",
  "out": "componentes/hero.tsx",
  "summary": "Hero con scroll storytelling, cursor magnético, Lenis",
  "tokens": 1847
}
```

## Estrategias de compresión

| Técnica | Cuándo aplicar |
|---------|---------------|
| Progressive disclosure | Cargar detalles solo si el agente los solicita |
| File anchors | Enviar path/ID en lugar de contenido completo |
| Summary replacement | Reemplazar tool output procesado con resumen |
| Compaction | Al 70% de utilización → comprimir historial |

## Economía multi-agente

| Config | Costo relativo |
|--------|---------------|
| 1 agente | 1x |
| Supervisor + 1 worker | ~15x |
| Supervisor + 5 workers | ~50x |
| Peer-to-peer (sin supervisor) | 3-8x |

→ Justificar cada nivel. Supervisor agrega valor solo con coordinación compleja.
→ Máx 5 workers por supervisor antes de bottleneck.

## Anti-patrones

```
✗ Telephone game: info degrada en cada resumen intermediario
✗ Instrucciones críticas al medio del contexto
✗ Tools genéricas: 1 agente = 1 rol = tools específicas
✗ State via message-passing: usar persistent storage
✗ Sycophantic consensus: agentes tienden a acordar, no a corregir
```

## State compartido (correcto)

```
✗ A → msg → B → msg → C (degradación acumulada)
✓ A → escribe en storage → B lee → C lee (sin degradación)
```
