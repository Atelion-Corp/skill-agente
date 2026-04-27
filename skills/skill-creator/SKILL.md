---
name: skill-creator
description: Generador de nuevas SKILL.md para Claude Code plugins. Usar cuando el usuario quiere crear un nuevo skill personalizado para su plugin.
license: MIT
---

# skill-creator — Generador de Skills

Guía interactiva para crear una nueva `SKILL.md` lista para Claude Code.

## Cuándo usar

- Usuario dice "crea un nuevo skill", "quiero un skill para X", "agrega un skill que haga Y"
- Usuario quiere extender un plugin existente con nueva capacidad

## Intake — preguntar antes de generar

Hacer estas preguntas antes de generar:

1. **Nombre** del skill (slug kebab-case, ej: `ui-style-hunter`)
2. **Propósito** — qué hace en una oración
3. **Trigger** — cuándo debe activarse (comandos del usuario, patrones de lenguaje)
4. **Workflow** — pasos principales que ejecuta
5. **Herramientas** — qué tools usa (WebSearch, Bash, Read, Write, Edit, etc.)
6. **Output** — qué produce al final (archivos, código, reporte, etc.)
7. **Plugin destino** — dónde se guardará el SKILL.md

## Estructura de SKILL.md

```markdown
---
name: <slug-kebab>
description: <Una línea — qué hace y cuándo usarlo>
license: MIT
---

# <slug> — <Título humano>

<Párrafo de contexto: qué hace este skill y por qué existe>

## Cuándo usar

- <Trigger 1>
- <Trigger 2>

## Workflow

### 1. <Fase 1>
<Descripción y acciones>

### 2. <Fase 2>
<Descripción y acciones>

## Output

<Qué produce: archivos creados, código generado, reporte, etc.>

## Notas

- <Restricción o advertencia importante>
```

## Pasos de ejecución

### 1. Recolectar intake
Hacer las 7 preguntas del intake. No asumir respuestas.

### 2. Diseñar el workflow
Mapear los pasos lógicos del skill. Cada paso debe ser accionable por Claude.

### 3. Generar SKILL.md
Crear el archivo en `<plugin-destino>/skills/<nombre>/SKILL.md`.

### 4. Actualizar plugin.json
Agregar `"./skills/<nombre>"` al array `skills` en `.claude-plugin/plugin.json`.

### 5. Confirmar
Mostrar resumen: nombre, trigger, workflow en 3 bullets, archivo creado.

## Notas

- El `name` en frontmatter debe coincidir con el directorio del skill
- `description` es lo que Claude lee para decidir si activar el skill — ser específico
- Skills complejos: separar en fases claras con headers `###`
- Skills simples: un único bloque de pasos numerados
