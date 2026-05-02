# Quality Standards — skill-agente v2.0

Estándares de calidad para todos los skills, inspirados en autoskills (midudev) y agency-agents.

---

## Estructura obligatoria de todo SKILL.md

Todo skill debe seguir esta estructura de 5 fases (workflow-based, no lineal):

```markdown
## Fase 1 — Activación y Contexto [REQUERIDO]
Confirmar: ¿aplica este skill? ¿Hay contexto suficiente?
→ Si no aplica: indicar el skill correcto (handoff)
→ Éxito: proyecto/tarea comprendido, alcance confirmado

## Fase 2 — Análisis y Diagnóstico [REQUERIDO]
Revisar contexto existente, identificar gaps, confirmar supuestos
→ Éxito: problema/objetivo definido con criterios verificables

## Fase 3 — Ejecución Principal [REQUERIDO]
Implementar la función principal del skill
→ Éxito: outputs primarios entregados

## Fase 4 — Validación [REQUERIDO PARA PRODUCCIÓN, OPCIONAL PARA PoC]
Verificar contra métricas de éxito, detectar problemas
→ Éxito: todos los checks verdes

## Fase 5 — Handoff y Continuación [SIEMPRE]
Indicar qué skill activar a continuación y qué información pasar
→ Éxito: context packet preparado para el siguiente agente
```

---

## Niveles de Impacto en Reglas

Todas las reglas y restricciones deben clasificarse:

| Nivel | Significado | Consecuencia si no se sigue |
|-------|-------------|----------------------------|
| `🔴 CRÍTICO` | Nunca omitir | Bugs, pérdida de datos, security breach |
| `🟠 ALTO` | Importante, seguir siempre | Degradación significativa de calidad |
| `🟡 MEDIO` | Seguir salvo razón documentada | Sub-óptimo pero funcional |
| `🟢 BAJO` | Sugerencia de mejora | Mejora marginal |

Ejemplo:
```markdown
### Reglas y Restricciones

🔴 CRÍTICO — Nunca hardcodear secrets en código
🔴 CRÍTICO — Validar inputs en frontera del sistema (nunca confiar en cliente)
🟠 ALTO — Usar select_related/prefetch_related para evitar N+1
🟠 ALTO — Tests de permisos obligatorios en endpoints sensibles
🟡 MEDIO — Documentar propósito de índices no obvios
🟢 BAJO — Agregar docstring en ViewSets públicos
```

---

## Metadata de Triggers (cuándo activar / NO activar)

Todo skill debe declarar triggers explícitos:

```yaml
---
triggers:
  include:
    - "crear API endpoint"
    - "Django model + serializer"
    - "autenticación JWT"
  exclude:
    - "Gradle upgrades"
    - "React frontend"
    - "infra y deployment"
  handoff_to:
    - skill: eng-frontend
      when: "interfaz de usuario necesaria"
    - skill: eng-database
      when: "esquema complejo de base de datos"
  preferred_for:
    - "Django 5.2 + DRF"
    - "REST APIs con permisos por rol"
---
```

---

## Anti-patrones Explícitos

Todo skill debe incluir una sección de anti-patrones con ejemplos:

```markdown
## Anti-patrones — No hacer esto

### ❌ N+1 Query (CRÍTICO)
```python
# MAL: genera N queries
for order in Order.objects.all():
    print(order.user.email)  # N queries adicionales

# BIEN: 1 query con JOIN
for order in Order.objects.select_related('user').all():
    print(order.user.email)
```

### ❌ Secrets en código (CRÍTICO)
```python
# MAL
API_KEY = "sk-abc123..."

# BIEN
API_KEY = os.environ.get("API_KEY")
```
```

---

## AGENTS.md (Reglas AI-Optimizadas)

Cada skill puede tener un archivo `AGENTS.md` con reglas estructuradas para consumo por LLMs:

```markdown
---
rule: no-n-plus-one
title: Siempre usar select_related/prefetch_related
impact: HIGH
applies_to: eng-backend, eng-database
---

**Problema:** Queries N+1 degradan performance exponencialmente
**Trigger:** Acceso a relaciones ForeignKey/ManyToMany en loops

**ANTES (❌ no hacer):**
```python
orders = Order.objects.all()
for o in orders:
    print(o.user.email)  # N queries
```

**DESPUÉS (✅ hacer):**
```python
orders = Order.objects.select_related('user').all()
for o in orders:
    print(o.user.email)  # 1 query JOIN
```

**Excepciones:** Carga diferida intencional con lógica condicional documentada
```

---

## Criterios de Calidad por Skill

Un skill es de ALTA calidad si cumple todos estos criterios:

### Estructura (40%)
- [ ] Frontmatter completo (name, description, agent_type, domain, area_code, persona, success_metrics)
- [ ] 5 fases workflow documentadas
- [ ] Triggers include/exclude declarados
- [ ] Sección de anti-patrones con ejemplos código

### Contenido (40%)
- [ ] Reglas clasificadas por nivel de impacto (CRÍTICO/ALTO/MEDIO/BAJO)
- [ ] Ejemplos de código concretos (no pseudocódigo)
- [ ] Context packet documentado (cómo recibe trabajo del area-lead)
- [ ] Integración documentada (depende de / pasa a)
- [ ] MCPs recomendados listados

### Calidad de IA (20%)
- [ ] Persona con nombre, rol y estilo definidos
- [ ] Métricas de éxito verificables (no vagas)
- [ ] Handoff claro al siguiente skill
- [ ] No duplica funcionalidad de otro skill

---

## Detección de Conflictos entre Skills

Conflictos a evitar entre skills del mismo sistema:

| Tipo de conflicto | Descripción | Solución |
|-------------------|-------------|----------|
| **Overlap de dominio** | Dos skills hacen lo mismo | Definir boundary explícito con `exclude` |
| **Contradicción de reglas** | Dos skills tienen reglas opuestas | Unificar en BP o crear capa de decisión |
| **Cadena circular** | A → B → A | Refactorizar para extraer skill C |
| **Contexto perdido** | B no recibe lo que A necesita para continuar | Actualizar context packet de A |

### Matriz de compatibilidad (áreas)

| Area | Depende de | Pasa a | Conflictos conocidos |
|------|-----------|--------|---------------------|
| E (Engineering) | DA, F (datos/costos) | D (UI), M (mensajes) | Ninguno |
| P (Product) | DA (métricas) | E (implementación) | No reemplaza a E |
| F (Finance) | DA (datos) | O (estrategia) | No duplicar con DA |
| SA (Sales) | M (copy), F (pricing) | O (estrategia) | No duplicar con M |
| HR | O (headcount) | E (capacidad) | Ninguno |

---

## Referencias

Inspirado en:
- **autoskills** (midudev): workflow phases, impact-level rules, trigger metadata, AGENTS.md format
- **agency-agents** (msitarzewski): personality-driven agents, success metrics, multi-platform
- **remotion/skills**: FORBIDDEN patterns, constraint-based guidance, nested rules
- **caveman** (JuliusBrussee): composable skills, single-purpose focus, graceful degradation
