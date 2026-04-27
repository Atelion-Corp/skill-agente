---
name: ultrareview
description: Launch multi-agent cloud code review of current branch or a GitHub PR — delivers comprehensive review across security, architecture, performance, code quality, and test coverage. Use when user asks for "/ultrareview", deep pre-merge review, or multi-agent code review.
license: MIT
---

# ultrareview — Multi-Agent Cloud Review

Guía para usar `/ultrareview` — revisión profunda con múltiples agentes en la nube.

## IMPORTANTE

**ultrareview NO puede ser lanzado por Claude Code automáticamente.**

- Es un comando **del usuario** — billed, no gratuito
- Requiere repositorio git activo
- Claude no puede invocarlo: solo el usuario puede

## Cómo usar

### Branch local (sin GitHub remote necesario)

```
/ultrareview
```

Empaqueta el branch local y lo envía a revisión multi-agente en la nube.

### PR de GitHub

```
/ultrareview <número-de-PR>
```

Revisa el PR del repo GitHub activo. Necesita remote configurado.

## Qué revisa

| Área | Qué analiza |
|------|-------------|
| Seguridad | OWASP Top 10, inyección, XSS, auth, secrets |
| Arquitectura | Separación de concerns, acoplamiento, patrones |
| Performance | Complejidad, N+1, bundle size, queries |
| Calidad | Naming, duplicación, complejidad ciclomática |
| Tests | Cobertura, edge cases, mocks vs integración |
| Docs | API docs, comentarios, README |

## Prerequisitos

1. Estar dentro de un repositorio git (`git status` funciona)
2. Si no hay repo: `git init && git add . && git commit -m "init"`
3. Para `/ultrareview <PR#>`: GitHub remote configurado

## Si no está disponible

Alternativas sin ultrareview:

| Alternativa | Cuándo |
|-------------|--------|
| `/review` | Revisión local, 1 agente |
| `security-review` skill | Foco en seguridad |
| `arch-validator` skill | Validación de arquitectura |
| `dev-test` skill | Cobertura de tests |
