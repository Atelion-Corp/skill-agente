---
name: mkt-cro
description: Conversion Rate Optimization — audit and improve landing pages, signup flows, onboarding, forms, popups, and paywall upgrades. Use when user wants to improve conversion rates, reduce drop-off, optimize CTAs, analyze funnel performance, or get A/B test ideas.
license: MIT
---

# mkt-cro — Conversion Rate Optimization

Optimizar tasas de conversión: páginas, flows de signup, onboarding, formularios, paywalls.

## Cuándo usar

- "mejorar conversión", "reducir abandono"
- "optimizar landing / CTA / formulario"
- "analizar el funnel", "por qué no convierten"
- "ideas de A/B test", "paywall optimization"

## Requiere

- `mkt-base` activo (producto + ICP)
- URL o descripción del elemento a optimizar

## Tipos de CRO

### 1. Landing Page — auditoría 5 puntos

```
HERO:
  □ Headline aclara en 5 seg qué es y para quién
  □ CTA visible sin scroll (above the fold)
  □ Sin jerga técnica

SOCIAL PROOF:
  □ Testimonios con nombre + cargo + empresa
  □ Números reales ("3,400+ equipos", "+47% conversión")

FRICCIÓN:
  □ Formulario ≤3 campos en primera vista
  □ Privacy note visible

BENEFICIOS:
  □ Outcomes del cliente, no features del producto

CTA FINAL:
  □ CTA repetido + alternativa de bajo compromiso
```

### 2. Signup Flow

```
- Pedir datos mínimos en paso 1 (email + password only)
- Progress indicator visible
- Social login como alternativa (reduce fricción 40-60%)
- Exit intent: capturar antes de abandonar
```

### 3. Onboarding — llegar al aha moment rápido

```
□ ¿Cuál es el aha moment? ¿Cuántos pasos antes de llegar?
□ Tooltips contextuales (no tutorial en video al inicio)
□ Empty states con acción clara (no pantalla vacía)
□ Email de activación a las 24h si no usaron el producto
```

### 4. Formularios

```
- Inline validation (no esperar submit)
- Labels arriba del campo, no dentro (placeholder ≠ label)
- Autocompletar: autocomplete="email" / "name"
- Submit: verbo de acción + beneficio ("Crear cuenta gratis")
- Error: qué pasó + cómo solucionarlo
```

### 5. Paywall / Upgrade

```
TIMING:
  □ Mostrar cuando el usuario ya experimentó valor
  □ Avisar antes de llegar al límite (no solo al bloqueo)

COPY:
  □ Loss aversion: qué pierden si NO actualizan
  □ CTA principal: plan de mayor conversión (no el más caro)
  □ Garantía o trial reduce fricción

FRICCIÓN BAJA:
  □ Alternativa de bajo compromiso en el modal
  □ Chat de soporte accesible desde el paywall
```

## Output por tipo

| Tipo | Output |
|------|--------|
| Landing audit | Issues priorizados (Critical/High/Medium) + recomendaciones |
| Flow | Puntos de mejora por paso |
| Copy | Copy reescrito con principios CRO |
| A/B test | Hipótesis + variante + métrica a medir |
| Paywall | Copy + estructura del modal |
