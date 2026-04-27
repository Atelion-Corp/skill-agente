---
name: area-mkt
description: Marketing area mini-orchestrator — routes marketing requests to specialized sub-agents (researcher, copy, SEO, CRO, growth, strategy) with minimal context packets. Use when super-orquestador routes to area M, or when marketing tasks need multiple skills coordinated.
license: MIT
---

# area-mkt — Marketing Area Orchestrator

Mini-orquestador del área de marketing. Coordina sub-agentes con contexto mínimo.

## Sub-agentes del área

| Sub-agente | Skills | Rol |
|------------|--------|-----|
| `mkt-researcher` | mkt-base | Investigar mercado, audiencia, competencia |
| `mkt-copy-agent` | mkt-copy | Copy web, emails, social, ads, cold outreach |
| `mkt-seo-agent` | mkt-seo | SEO técnico, on-page, GEO, schema, keywords |
| `mkt-cro-agent` | mkt-cro | Optimizar conversión, flows, formularios, paywall |
| `mkt-growth-agent` | mkt-growth | Churn, referral, community, lead magnets, PLG |
| `mkt-strategy-agent` | mkt-pipeline | Estrategia, GTM, lanzamiento |

## Routing rápido

```
"escribe copy/email/anuncio/cold email" → mkt-copy-agent
"SEO, rankings, keywords, schema" → mkt-seo-agent
"mejorar conversión, CRO, landing" → mkt-cro-agent
"retención, churn, referral, growth" → mkt-growth-agent
"estrategia, go-to-market, lanzamiento" → mkt-strategy-agent
"investiga competencia/mercado/audiencia" → mkt-researcher
ELSE sin contexto de producto → mkt-researcher (mkt-base) primero
```

## Verificar contexto base antes de delegar

Antes de activar cualquier sub-agente:

```json
{ "product": "?", "audience": "?", "usp": "?" }
```

Si falta → activar `mkt-researcher` con `mkt-base` para construirlo.

## Paquete de contexto (area-mkt → sub-agente)

```json
{
  "req": "email de onboarding para trial",
  "skill": "mkt-copy",
  "base": { "product": "...", "audience": "...", "usp": "..." },
  "specific": { "type": "email", "stage": "onboarding", "goal": "activación" },
  "bp": ["BP-M-001", "BP-M-002"],
  "budget": 400
}
```

## Flujo

```
Input recibido
    │
    ▼
1. ¿Existe mkt-context.json? → No → activar mkt-researcher primero
    │
    ▼
2. Detectar tipo → asignar sub-agente
    │
    ▼
3. Enviar paquete mínimo (≤300 tokens) al sub-agente
    │
    ▼
4. Recibir resultado → consolidar → responder
    │
    ▼
5. Activar resultado-save al finalizar
```

## Límites

- Máx 4 sub-agentes por tarea
- Budget por sub-agente: ≤300 tokens de contexto
- Compartir mkt-context.json comprimido entre todos

## Output

- Entregable de marketing (copy, plan SEO, análisis CRO, etc.)
- Métricas esperadas cuando aplica
- Próximos pasos accionables
