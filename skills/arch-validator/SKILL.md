---
name: arch-validator
description: Valida la arquitectura de un proyecto web contra el patrón probado Django+Next.js+Docker. Usar cuando el usuario quiere revisar si su estructura de proyecto es correcta o necesita ajustes.
license: MIT
---

# arch-validator — Validador de Arquitectura

Audita la estructura de un proyecto web y valida que siga el patrón arquitectónico probado en producción: Django 5.x + DRF + PostgreSQL + Redis en backend, Next.js 15 + TypeScript + TailwindCSS + shadcn/ui en frontend, Docker Compose para infra.

## Stack de referencia

Basado en la arquitectura validada de **Atelion Projects** (`C:\Users\diego\Documents\Propio\proyecto_gestion_agile\`):

| Capa | Tecnología |
|------|-----------|
| Backend | Django 5.2 + DRF + PostgreSQL + Redis |
| Frontend | Next.js 15 + TypeScript + TailwindCSS + shadcn/ui (Radix) |
| Auth | JWT (`access_token` + `refresh_token` en localStorage) |
| Infra | Docker Compose — `docker-compose.yml` en raíz |
| API | `/api/` prefijo, DRF ViewSets, endpoints RESTful |

## Cuándo usar

- "valida mi arquitectura", "está bien estructurado mi proyecto"
- "revisa si falta algo en la estructura de carpetas"
- Usuario comparte árbol de directorios y quiere feedback
- Antes de empezar a buildear un feature nuevo

## Workflow

### 1. Intake

Pedir o detectar:
- Árbol de directorios del proyecto (`find . -type f -name "*.py" | head -50`, `ls -R`)
- Stack declarado (si existe `requirements.txt`, `package.json`, `docker-compose.yml`)
- Tipo de proyecto: SaaS, landing, API pura, fullstack

### 2. Auditoría backend Django

Verificar contra checklist:
- [ ] Custom user model con email-based auth (`AbstractBaseUser` o `AbstractUser`)
- [ ] Apps separadas por dominio (`apps/usuarios/`, `apps/projects/`, etc.)
- [ ] `config/` con `settings/base.py` + `settings/dev.py` + `settings/prod.py`
- [ ] `config/urls.py` → include `config/api_urls.py`
- [ ] `requirements/base.txt` + `requirements/dev.txt` separados
- [ ] Migraciones generadas y en control de versiones
- [ ] `ALLOWED_HOSTS` y `SECRET_KEY` en variables de entorno

### 3. Auditoría frontend Next.js

Verificar:
- [ ] App Router (`src/app/`) — no Pages Router
- [ ] `src/lib/api.ts` con axios + JWT interceptors
- [ ] `src/types/index.ts` — todos los tipos TypeScript centralizados
- [ ] `src/components/layout/` — Sidebar, Header, ThemeProvider
- [ ] Páginas siguen patrón: list → detail → [id]/subpage
- [ ] `tailwind.config.js` con custom tokens si hay design system propio

### 4. Auditoría infra Docker

Verificar:
- [ ] `docker-compose.yml` en raíz con servicios: `db`, `redis`, `backend`, `frontend`
- [ ] `.env.example` con todas las variables requeridas
- [ ] Health checks en servicios críticos
- [ ] Volúmenes para persistencia de PostgreSQL

### 5. Antipatrones detectados

Reportar si se encuentra:
- `settings.py` único (sin split base/dev/prod) → riesgo en producción
- Secret keys hardcodeadas en código
- Pages Router en Next.js → migrar a App Router
- Auth con sessions Django en lugar de JWT → inconsistente con SPA
- Sin Docker → deploy inconsistente entre entornos

### 6. Reporte final

Producir tabla:
```
✅ PASS  |  ⚠️ WARN  |  ❌ FAIL
Backend:    X/7       Y/7       Z/7
Frontend:   X/6       Y/6       Z/6
Infra:      X/4       Y/4       Z/4
```

Listar cada ❌ con acción correctiva específica.

## Output

- Tabla de auditoría con PASS/WARN/FAIL por capa
- Lista de acciones correctivas ordenadas por prioridad
- Score global: Arquitectura Sólida / Necesita Ajustes / Refactorizar

## Notas

- WARN no bloquea desarrollo — es deuda técnica a resolver
- FAIL puede causar problemas en producción — corregir antes de deploy
- Si el proyecto usa stack diferente (FastAPI, Vue, etc.), validar principios (separación, env vars, Docker) en lugar de tecnologías exactas


