---
name: dev-pipeline
description: Orquestador de operaciones de desarrollo para stack Django+Next.js+Docker. Detecta qué tarea de dev se necesita y activa el skill correcto. Usar cuando el usuario dice "quiero hacer X en el proyecto" sin saber qué skill invocar.
license: MIT
---

# dev-pipeline — Orquestador de Desarrollo

Skill maestro para operaciones de desarrollo en proyectos Django + Next.js + Docker. Clasifica la intención del usuario y delega al skill especializado correcto.

## Cuándo usar

- "quiero dockerizar mi proyecto"
- "cómo levanto el entorno", "docker no arranca"
- "necesito migraciones", "nueva app Django"
- "qué puertos necesito abrir", "CORS no funciona"
- "configurar variables de entorno"
- "correr tests", "poblar datos de prueba"
- "deployar a producción"
- Cualquier tarea de dev sin skill explícito

## Mapa de intenciones → skills

| Intención detectada | Skill |
|---------------------|-------|
| Agregar Docker a proyecto sin Docker | `dev-dockerize` |
| Operar Docker (up/down/logs/exec/rebuild) | `dev-docker-ops` |
| Puertos, CORS, nginx, red entre servicios | `dev-ports` |
| Migraciones Django (make/apply/reset) | `dev-migrate` |
| Nueva app Django / endpoint DRF / página Next.js | `dev-scaffold` |
| Variables de entorno, `.env`, secrets | `dev-env` |
| Tests (pytest, jest, playwright) | `dev-test` |
| Fixtures, datos iniciales, superusuario | `dev-seed` |
| Deploy GCP / GitLab CI | `dev-deploy` |

## Workflow

### 1. Detectar tarea

Leer el mensaje del usuario y clasificar en una de las categorías del mapa.

Si ambiguo, preguntar en 1 línea: "¿Estás agregando Docker por primera vez o querés operar uno ya existente?"

### 2. Detectar contexto del proyecto

Verificar rápidamente:
```bash
ls docker-compose.yml Dockerfile 2>/dev/null && echo "Docker exists"
ls manage.py 2>/dev/null && echo "Django root detected"
ls package.json 2>/dev/null && echo "Node detected"
```

Ajustar el skill recomendado según lo encontrado:
- Sin `docker-compose.yml` → `dev-dockerize` antes que `dev-docker-ops`
- Sin `manage.py` visible → preguntar ruta del backend
- Sin `.env` → `dev-env` primero

### 3. Activar skill

Anunciar: "Voy a usar `[skill-name]` para esto."

Seguir el workflow del skill elegido con el contexto ya detectado.

### 4. Encadenar si hay múltiples pasos

Ejemplo — proyecto nuevo sin Docker y sin env:
```
1. dev-env    → crear .env.example con todas las variables
2. dev-dockerize → generar Dockerfile + docker-compose.yml
3. dev-docker-ops → levantar y verificar
```

Mostrar el plan encadenado antes de ejecutar. Pedir confirmación si >2 pasos.

## Stack de referencia

```
backend/
  Dockerfile
  requirements/base.txt, dev.txt, prod.txt
  config/settings/base.py, dev.py, prod.py
  manage.py

frontend/
  Dockerfile
  package.json
  next.config.ts

docker-compose.yml          ← raíz del proyecto
docker-compose.override.yml ← overrides de dev (opcional)
.env                        ← nunca en git
.env.example                ← sí en git
```

## Output

- Tarea de dev completada con el skill especializado
- Contexto del proyecto detectado y preservado para el siguiente skill si se encadena

## Notas

- Siempre verificar si Docker está corriendo antes de `dev-docker-ops`
- Si el usuario dice "no tengo Docker instalado" → redirigir a instalación manual (fuera del scope de los skills)
- Para proyectos en producción activa → advertir antes de cualquier `down` o migración destructiva
