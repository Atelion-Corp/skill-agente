---
name: skill-pipeline
description: Orquestador de etapas para proyectos de diseño y documentación técnica interna. Valida progreso por fase, aplica normativa de seguridad de credenciales y estandariza documentación profesional por secciones.
license: MIT
---

# skill-pipeline — Orquestador de Etapas

Skill maestro que guía al usuario por fases para diseño web y documentación interna. Valida que cada etapa esté completa antes de avanzar, consulta el contexto guardado en `proyecto_resultado_skill`, y decide qué skill activar.

## Normativa obligatoria (siempre activa)

1. Seguridad de credenciales:
- Nunca exponer secretos reales en salidas, ejemplos, docs o commits.
- Reemplazar datos sensibles con placeholders (`<api-key>`, `<token-mask>`, `<domain-mask>`, `<admin-user>`).
- Prohibido publicar: passwords, API keys, JWTs, cookies, cadenas de conexión, private keys, IPs internas no enmascaradas.
- Si el usuario comparte credenciales, resumir sin repetirlas textualmente.

2. Estandar documental interno:
- Toda documentación debe usar una plantilla estándar y profesional.
- Separar claramente:
  a) Resumen ejecutivo / explicativo de procesos.
  b) Procedimientos operativos paso a paso.
  c) Sección técnica de código/configuración/ejemplos.
- Incluir alcance, responsabilidades, prerequisitos, riesgos, controles, rollback y checklist.

3. Trazabilidad:
- Cada documento debe indicar última actualización y responsable.
- Toda norma nueva debe reflejarse en índice maestro y runbook correspondiente.

## Cuándo usar

- "empieza un proyecto de diseño", "guíame por el proceso"
- "valida mi etapa", "estoy en la fase X, qué sigue"
- "simplifica — qué debo decidir ahora"
- "monitorea la documentación", "estandariza docs", "aplica normativa interna"
- Al inicio de cualquier proyecto que use los skills de diseño de este plugin

## Modos del pipeline

```
[A. DISEÑO] [B. DOCUMENTACIÓN]
```

### A) Modo Diseño

```
[1. BRIEF] → [2. ANÁLISIS] → [3. TIER] → [4. STACK] → [5. DISEÑO] → [6. SAVE]
```

| Etapa | Skill activado | Entregable |
|-------|---------------|------------|
| 1. BRIEF | (intake directo) | `brief.md` en resultado |
| 2. ANÁLISIS | `ui-style-hunter` | `design-tokens.json` + tier detectado |
| 3. TIER | (decisión guiada) | tier confirmado (eco/medio/pro/premium/corporate/3d/video/images) |
| 4. STACK | `arch-validator` | checklist de arquitectura validada |
| 5. DISEÑO | `design-<tier>` | componentes implementados |
| 6. SAVE | `resultado-save` | todo guardado en `proyecto_resultado_skill` |

### B) Modo Documentación Interna

```
[1. ALCANCE] → [2. INVENTARIO] → [3. NORMA] → [4. ESTRUCTURA] → [5. REDACCIÓN] → [6. VALIDACIÓN] → [7. SAVE]
```

| Etapa | Objetivo | Entregable |
|-------|----------|------------|
| 1. ALCANCE | Definir qué repos/sistemas se documentan | `scope.md` |
| 2. INVENTARIO | Levantar artefactos, servicios y procesos | `inventory.md` |
| 3. NORMA | Aplicar política de credenciales y clasificación de datos | `security-policy.md` |
| 4. ESTRUCTURA | Crear índice y plantilla estándar | `doc-template.md` + `README` actualizado |
| 5. REDACCIÓN | Completar docs por dominio (ops, arquitectura, negocio, código) | archivos `*.md` |
| 6. VALIDACIÓN | Revisar completitud, coherencia y redacción profesional | `quality-checklist.md` |
| 7. SAVE | Persistir contexto y estado para retomabilidad | `pipeline-status.json` |

## Workflow (Documento)

### 0. Detectar modo

Si el usuario menciona documentación, normas internas, manuales o gobernanza:
- activar **Modo Documentación** automáticamente.

### 1. Etapa ALCANCE

Preguntar una sola cosa a la vez:
1. "¿Qué repositorios y áreas debemos cubrir en esta iteración?"

### 2. Etapa INVENTARIO

Recolectar para cada repo:
- propósito, stack, servicios, puertos, dependencias, estado de despliegue.
- entorno (POC, dev, prod) y owner responsable.

### 3. Etapa NORMA (seguridad)

Aplicar controles obligatorios:
- redacción de secretos en ejemplos.
- bloqueo de contenidos sensibles.
- evidencia de cumplimiento (checklist de sanitización).

### 4. Etapa ESTRUCTURA (plantilla única)

Toda documentación debe usar el orden:
1. Resumen Ejecutivo
2. Objetivo y Alcance
3. Arquitectura / Contexto
4. Procedimiento Paso a Paso
5. Operación y Monitoreo
6. Sección Técnica de Código / Configuración
7. Seguridad y Cumplimiento
8. Troubleshooting y Rollback
9. Checklist de Validación
10. Historial de Cambios

### 5. Etapa REDACCIÓN

Redactar con tono profesional interno:
- lenguaje claro, operativo y auditable.
- incluir tablas, convenciones y criterios de aceptación.
- si falta información, usar texto genérico marcado como `(editar sección: <codigo>)`.

### 6. Etapa VALIDACIÓN

Validar:
- completitud por plantilla.
- consistencia con naming conventions.
- ausencia de credenciales/secretos.
- claridad de pasos y responsables.

## Workflow (Diseño)

### 1. Detectar etapa actual

Al activarse, preguntar:
> "¿Estás empezando un proyecto nuevo o retomando uno?"

Si nuevo → empezar desde BRIEF.
Si retomando → leer `proyecto_resultado_skill/proyectos/<nombre>/pipeline-status.json` y detectar dónde quedó.

### 2. Etapa BRIEF — recolectar contexto base

Preguntar en orden (no todos de golpe — esperar respuesta antes de seguir):

1. "¿Cuál es el nombre del proyecto?"
2. "¿Qué hace el sitio y para quién?"
3. "¿Tienes referencias visuales? (URLs, imágenes, descripción)"
4. "¿Cuál es el CTA principal del sitio?"
5. "¿Tienes stack definido o empezamos desde cero?"

Guardar respuestas en memoria de sesión. Al finalizar → activar `resultado-save` para crear `brief.md`.

### 3. Etapa ANÁLISIS — activar ui-style-hunter

Si el usuario dio URLs de referencia:
> "Voy a analizar las referencias con `ui-style-hunter`. Dame un momento."

Activar mentalmente el workflow de ui-style-hunter con las URLs del brief.
Output: tier detectado + design tokens.

### 4. Etapa TIER — confirmar con el usuario

Presentar opciones simplificadas:

```
Basado en el análisis, tu proyecto encaja mejor en:

  ● ECO        — natural, orgánico, verde, performance-first
  ● MEDIO      — SaaS estándar, moderno, shadcn/ui
  ● PRO        — agencia, dark mode, micro-interacciones
  ● PREMIUM    — luxury, scroll storytelling, alta estética
  ● CORPORATE  — empresa, B2B, autoridad, formal
  ● 3D         — Three.js / R3F / Spline
  ● GRAFO      — red neuronal, conocimiento, Obsidian-style 3D
  ● ANIME      — animaciones complejas, Anime.js, stagger, SVG morphing
  ● SCROLL     — Lenis + GSAP, parallax, scroll physics (UIverse)
  ● IMÁGENES   — galería, portfolio, image-heavy
  ● VIDEO      — background video, player, scroll-driven
  ● REMOTION   — video programático con código (MP4/GIF)
  ● EDITOR     — rich text editor, WYSIWYG, TinyMCE/Tiptap

¿Confirmas [TIER DETECTADO] o prefieres otro?
```

### 5. Etapa STACK — validar arquitectura

Si el proyecto tiene código existente → activar `arch-validator`.
Si es nuevo → recomendar el stack del tier:
- Medio/Pro/Premium/Corporate/Eco: Next.js 15 + TailwindCSS + shadcn/ui
- 3D: + @react-three/fiber + drei
- Grafo: + react-force-graph-3d + d3-force-3d
- Anime: + animejs
- Scroll: + @studio-freight/lenis + gsap
- Video: + react-player
- Remotion: + remotion + @remotion/player
- Imágenes: next/image + yet-another-react-lightbox
- Editor: + @tiptap/react + @tiptap/starter-kit (o @tinymce/tinymce-react)

### 6. Etapa DISEÑO — activar skill correcto

Activar el skill correspondiente con el contexto acumulado:
- brief del proyecto
- design tokens del análisis
- stack validado

| Tier | Skill |
|------|-------|
| eco/medio/pro/premium/corporate | `design-<tier>` |
| 3d | `design-3d` |
| grafo | `design-graph` |
| anime | `design-anime` |
| scroll | `design-uiverse` |
| imágenes | `design-images` |
| video | `design-video` |
| remotion | `design-remotion` |
| editor | `design-tinymce` |

### 7. Etapa SAVE — activar resultado-save

Al finalizar componentes → activar `resultado-save` para persistir todo.

### Comandos de control del pipeline

El usuario puede en cualquier momento:
- "¿en qué etapa estoy?" → mostrar pipeline con la etapa actual marcada
- "simplifica" → resumir en 1 oración qué hay que decidir ahora
- "¿qué falta?" → listar etapas pendientes
- "saltear a [etapa]" → avanzar sin validar (advertir qué se pierde)
- "guardar y pausar" → activar resultado-save y dejar todo guardado para retomar
- "audita credenciales" → correr revisión de sanitización documental
- "estandariza docs" → reformatear documentos al template oficial

## Output

El pipeline no produce archivos directamente — orquesta los otros skills. Su output final es el proyecto completo en `proyecto_resultado_skill`.

## Notas

- Hacer UNA pregunta a la vez en BRIEF/ALCANCE — no bombardear con formulario
- "simplifica" = detectar la decisión bloqueante y presentarla en ≤3 opciones
- Si el usuario ya tiene contexto claro, saltear preguntas ya respondidas
- Pipeline status se guarda en `proyecto_resultado_skill/proyectos/<nombre>/pipeline-status.json`

## Norma API y Puertos (Regla Dura)

Aplicable a toda documentacion y cambios operativos:

1. API base oficial: `/api/`.
- No usar ningun prefijo `/api`.
- Si aparece una variante, debe corregirse a `/api/`.

2. Puertos canonicos no se cambian sin RFC tecnico aprobado:
- Frontend principal: `3000` (dev alterno documentado: `4000` solo cuando aplique por proyecto).
- Backend principal: `8000`.
- Redis: `6379`.
- PostgreSQL: `5432`.

3. Toda documentacion debe reflejar los puertos reales del compose del proyecto.





4. Enrutamiento HTTP/HTTPS:
- No usar Nginx dentro de Docker para publicacion principal.
- Usar Nginx del servidor (host) para redirigir dominios a puertos Docker internos.


