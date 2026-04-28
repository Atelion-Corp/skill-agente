---
name: tailwind-ui-hunter
description: Descubre, evalua y adapta componentes y bloques Tailwind UI desde fuentes confiables (open source y marketplaces), priorizando consistencia visual, accesibilidad y compatibilidad multi-runtime.
license: MIT
---

# tailwind-ui-hunter

Skill para acelerar decisiones de UI con Tailwind sin caer en "copiar y pegar" sin criterio.

## Cuando usar

- Cuando se pide "buscar referencias Tailwind UI"
- Cuando se necesita shortlist de bloques/componentes para landing, dashboard o app
- Cuando hay que mantener estilo minimalista y rendimiento

## Fuentes base

- `tailwindflex.com`
- `dribbble.com/tags/tailwind-ui`
- `froala/design-blocks`
- `mcpmarket.com` (tools/skills relacionados con Tailwind)
- `aura.build/skills`
- Repos de componentes mantenidos (por ejemplo `shadcn-ui/ui`, `flowbite`)

## Reglas de seleccion

1. Priorizar componentes con codigo claro, accesible y editable.
2. Evitar dependencias pesadas para piezas simples.
3. Favorecer variantes que funcionen bien en desktop y mobile.
4. Mantener paleta y tipografia coherente con el proyecto.
5. Proponer maximo 3 opciones por bloque (hero, cards, pricing, etc.).

## Flujo

1. Definir bloque objetivo y restricciones de producto.
2. Armar shortlist de referencias (3-8 items) con pros/contras.
3. Recomendar implementacion concreta (estructura + clases clave).
4. Verificar rendimiento y accesibilidad basica.
5. Documentar por que se eligio esa opcion.

## Salida esperada

- `ui-shortlist.md` con enlaces y evaluacion breve
- `implementation-notes.md` con decisiones de adaptacion
- checklist de validacion (`responsive`, `a11y`, `perf`, `consistency`)
