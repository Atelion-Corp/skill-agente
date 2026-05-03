# AGENTS.md — Skill Agente (Atelion)

## 1) Proposito del repositorio
Este repositorio (skill_agente) forma parte del ecosistema interno de Atelion. Este contexto aplica para Claude Code, Codex y OpenCode.

## 2) Estandar tecnico y de arquitectura
La documentacion tecnica debe mantener lenguaje profesional interno, trazabilidad de cambios y secciones explicativas de codigo, procesos y flujos de datos.

## 3) Normas duras de API y puertos
La ruta base oficial es /api/.
No se permite usar /api/v1/ ni otros versionados en la ruta base.
No cambiar puertos canonicos sin aprobacion tecnica explicita y registro en documentacion.

## 4) Regla de despliegue y proxy
Para produccion, usar Nginx principal en host/servidor y enrutar por dominio hacia puertos de contenedores.
No duplicar Nginx dentro de cada proyecto para publicacion principal, salvo excepcion aprobada.

## 5) Seguridad de datos y credenciales
Nunca exponer credenciales, tokens, secretos o llaves en codigo, docs, logs o ejemplos.
Las URLs de servicio pueden documentarse cuando sea necesario para operacion.
Usar placeholders para secretos (`<SECRET>`, `<TOKEN>`, `<PASSWORD>`).

## 6) Estandar de documentacion
Cada documento principal debe incluir:
Resumen ejecutivo, stack visual, flujo de datos/procesos, guia paso a paso de despliegue, checklist operativo y seccion de seguridad.

## 7) Convencion de naming de repos
Repos desplegables en Colossus usan prefijo `server-<producto>`.
Repos `poc-*` son pruebas temporales y, al validarse, deben migrar a un nuevo repo `server-<proyecto>`.

## 8) Flujo de trabajo para agentes IA
Antes de cambiar codigo o infraestructura, validar impacto en API, puertos, seguridad y despliegue.
Registrar cambios relevantes en README/runbook/contexto para mantener continuidad operativa.

### 8.1) Modelo skill -> agente -> subagente
- Skill define el metodo.
- Agente ejecuta el objetivo.
- Subagente ejecuta una parte concreta, acotada y medible.

### 8.2) Regla de orquestacion paralela
- Solo paralelizar tareas independientes.
- Cada subagente debe tener entrada, salida esperada y limite claro.
- Consolidar resultados en una unica respuesta final.
- Evitar duplicar analisis entre subagentes.

### 8.3) Paquete minimo para delegacion
- `objetivo`
- `alcance`
- `input`
- `criterios de aceptacion`
- `riesgos a vigilar`
- `formato de salida`

### 8.4) Roles base recomendados
- `@css-color-agent`: cambios o busqueda de estilo/CSS.
- `@perf-agent`: impacto de performance.
- `@security-agent`: riesgos de seguridad.
- `@qa-agent`: validacion funcional y regresion.
- `@docs-agent`: actualizacion de documentacion.

## 9) Definicion de terminado
Un cambio se considera completo cuando: implementacion aplicada, documentacion alineada, validacion basica ejecutada y normas duras respetadas.

---

# Guía Operativa Multi-Agente v2.0

Guía para usar los skills como sistema de sub-agentes expertos en Claude Code, Codex y OpenCode.

## Principios

- Mantener cambios pequeños y verificables.
- Leer primero `README.md` y luego el `SKILL.md` específico.
- No asumir stack: confirmar desde contexto del usuario.
- Preferir ejecución por fases: diagnóstico → implementación → validación.
- Sub-agentes son expertos con identidad: respetan su persona, reglas y métricas de éxito.

## Compatibilidad

- Claude Code: usa `.claude-plugin/plugin.json`.
- Codex: usa `.codex-plugin/plugin.json`.
- OpenCode/otros: consumir `skills/*/SKILL.md` directamente (fallback estándar).

---

## Jerarquía de Agentes v2.0

```
super-orquestador (master)
    │
    ├── area-design [D]          → design-eco/medio/pro/premium/corporate
    │   (Design Lead)              + design-3d/graph/anime/uiverse/images/video/remotion
    │
    ├── area-mkt [M]             → mkt-base/copy/seo/cro/growth
    │   (Marketing Lead)
    │
    ├── area-eng [E]             → eng-backend (Marco)
    │   (Engineering Lead)         eng-frontend (Valentina)
    │                              eng-devops (Tomás)
    │                              eng-security (Lena)
    │                              eng-database (Carlos)
    │                              eng-qa (Sofía)
    │
    ├── area-product [P]         → product-manager (Ana)
    │   (Product Lead)             product-analyst (Luis)
    │
    ├── area-ops [O]             → ops-pm (Elena)
    │   (Operations Lead)          ops-strategy (Rodrigo)
    │
    └── area-data [DA]           → data-analyst (Camila)
        (Data Lead)
```

---

## Directorio de Personas (Sub-Agentes Expertos)

| Persona | Skill | Área | Expertise Principal |
|---------|-------|------|---------------------|
| **Marco** | `eng-backend` | E | Django 5.2 + DRF + PostgreSQL + JWT |
| **Valentina** | `eng-frontend` | E | Next.js 15 + TypeScript + Tailwind + TanStack |
| **Tomás** | `eng-devops` | E | Docker + GitHub Actions + Nginx + SSL |
| **Lena** | `eng-security` | E | OWASP Top 10 + secrets audit + auth hardening |
| **Carlos** | `eng-database` | E | PostgreSQL modeling + query optimization + Redis |
| **Sofía** | `eng-qa` | E | pytest + jest + Playwright E2E |
| **Ana** | `product-manager` | P | Roadmaps + PRDs + OKRs + RICE |
| **Luis** | `product-analyst` | P | Métricas + funnel + A/B tests + SQL |
| **Elena** | `ops-pm` | O | Agile/Scrum + sprint planning + retrospectivas |
| **Rodrigo** | `ops-strategy` | O | GTM + unit economics + competitive analysis |
| **Camila** | `data-analyst` | DA | SQL avanzado + pandas + KPIs + visualización |

---

## Template de Sub-Agente v2.0

Todos los skills usan este frontmatter estándar:

```yaml
---
name: skill-slug
description: descripción + cuándo usar
license: MIT
agent_type: sub-agent | area-lead | orchestrator | utility
domain: engineering | design | marketing | product | ops | data
area_code: E | D | M | P | O | DA
persona:
  name: "Nombre"
  role: "Job Title"
  style: "Cómo comunica"
  traits: ["trait1", "trait2"]
success_metrics:
  - "KPI 1"
  - "KPI 2"
---
```

Secciones obligatorias en cada skill:
1. `## Identidad` — persona, misión, expertise
2. `## Cuándo Activar` — triggers específicos
3. `## Reglas y Restricciones` — OBLIGATORIO + FORBIDDEN
4. `## Workflow` — pasos numerados
5. `## Entregables` — outputs con ejemplos de código
6. `## Métricas de Éxito` — KPIs verificables
7. `## Context Packet` — formato de entrada del area-lead
8. `## Integración` — dependencias y continuación

---

## Flujo de Contexto

```
super-orquestador → area-lead (≤500 tokens)
area-lead → sub-agente (≤200 tokens)
sub-agente → respuesta (≤300 tokens + código)
```

### Context Packet estándar (orchestrator → area-lead)

```json
{
  "v": 2,
  "req": "<solicitud ≤30 tokens>",
  "area": "E",
  "proj": "nombre-proyecto",
  "ctx": { "<datos críticos de decisión>" },
  "bp": ["BP-E-001"],
  "budget": 300,
  "api": "gemini|groq|null"
}
```

---

## Flujos Recomendados por Caso de Uso

### Feature completa (full-stack)

```
super-orquestador → area-eng
  → Carlos (eng-database): schema + índices
  → Marco (eng-backend): API + tests unitarios
  → Valentina (eng-frontend): UI + TanStack Query
  → Sofía (eng-qa): suite de tests E2E
  → Tomás (eng-devops): CI pipeline
```

### Lanzamiento de producto

```
super-orquestador → area-product + area-ops + area-mkt
  Ana (product-manager): PRD + criterios de éxito
  Rodrigo (ops-strategy): GTM + unit economics
  Elena (ops-pm): sprint planning del lanzamiento
```

### Análisis de negocio

```
super-orquestador → area-data + area-product
  Camila (data-analyst): SQL + visualización
  Luis (product-analyst): interpretación + A/B design
  Ana (product-manager): decisiones de producto
```

---

## Checklist antes de cerrar

- ¿Criterios funcionales cumplidos?
- ¿Instrucciones reproducibles sin contexto de esta sesión?
- ¿Outputs guardados en `resultado-save`?
- ¿Sub-agentes usaron sus métricas de éxito para validar?
- ¿Se actualizaron docs/manifiestos si aplica?
- ¿Normas duras de API/puertos/credenciales respetadas?
