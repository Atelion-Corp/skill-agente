---
name: mkt-base
description: Foundation context layer for all marketing skills — captures product, audience, USP, brand voice, and competitive positioning. Must be established before running mkt-copy, mkt-seo, mkt-cro, mkt-growth, or mkt-strategy. Use when starting marketing work or when marketing context is missing.
license: MIT
---

# mkt-base — Marketing Foundation Context

Capa base que todos los skills de marketing necesitan. Establece producto, audiencia, USP y voz de marca.

## Cuándo usar

- Inicio de cualquier trabajo de marketing
- Otro skill `mkt-*` pide contexto base
- "define el contexto de marketing del producto"
- "¿qué sabe el sistema del producto?"

## Intake (1 pregunta por vez)

```
1. ¿Qué hace el producto y para quién? (1-2 oraciones)
2. ¿Cuál es el cliente ideal? (cargo, tipo empresa, pain point)
3. ¿Cuál es el diferenciador vs competencia? (1 frase)
4. ¿Cuál es el CTA principal? (registrarse / demo / comprar)
5. ¿En qué etapa está? (early / growth / scale)
6. ¿Estilo de voz? (formal/casual, técnico/simple)
```

## Output: mkt-context.json

```json
{
  "v": 1,
  "product": {
    "name": "",
    "what": "descripción en 1 oración",
    "category": "SaaS|marketplace|ecomm|service|app",
    "stage": "early|growth|scale"
  },
  "audience": {
    "icp": "cargo + tipo empresa + pain point",
    "jtbd": []
  },
  "value": {
    "usp": "propuesta única ≤15 palabras",
    "benefits": [],
    "objections": []
  },
  "brand": {
    "voice": "formal|casual|técnico|simple|premium",
    "avoid": [],
    "cta": "acción principal"
  },
  "competition": {
    "main": [],
    "differentiators": []
  }
}
```

## Principios de copy (aplican en todos los skills mkt-*)

```
1. Clarity > cleverness — el lector entiende en 5 seg
2. Benefits > features — "ahorrás 3h/día" > "tiene automatización"
3. Active voice — "aumentás conversiones" > "son mejoradas"
4. Lenguaje del cliente, no jerga interna
5. CTA: [Verbo acción] + [Qué obtienen] + [Calificador opcional]
   ✓ "Empezá gratis — sin tarjeta"
   ✓ "Ver demo en 2 min"
   ✗ "Haz clic aquí" / "Enviar"
6. Evitar: "muy", "realmente", "básicamente", "solución robusta"
```

## Guardar

```
resultado-save → proyecto_resultado_skill/proyectos/<nombre>/mkt-context.json
```
