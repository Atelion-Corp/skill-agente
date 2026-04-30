---
name: dev-docker-ops
description: Operaciones cotidianas de Docker Compose para proyectos Django+Next.js — levantar, bajar, rebuild, logs, exec, inspeccionar estado. Usar cuando el entorno Docker ya existe y se necesita operar.
license: MIT
---

# dev-docker-ops — Operaciones Docker Diarias

Referencia de comandos Docker Compose para el stack Django + Next.js. Cubre el 95% de las operaciones diarias de desarrollo.

## Cuándo usar

- "levantá el entorno", "docker compose up"
- "el contenedor no arranca", "rebuild backend"
- "quiero ver los logs", "entrar al contenedor"
- "limpiar todo y empezar de cero"
- "qué servicios están corriendo"

## Comandos esenciales

### Levantar / bajar

```bash
# Levantar todos los servicios en background
docker compose up -d

# Levantar con rebuild forzado (después de cambiar Dockerfile o requirements)
docker compose up -d --build

# Levantar solo algunos servicios
docker compose up -d db redis backend

# Bajar sin borrar volúmenes (datos persisten)
docker compose down

# Bajar y borrar volúmenes (reset total de datos)
docker compose down -v
```

### Ver estado y logs

```bash
# Estado de todos los servicios
docker compose ps

# Logs de un servicio (con follow)
docker compose logs -f backend
docker compose logs -f frontend
docker compose logs -f db

# Logs de todos en paralelo
docker compose logs -f

# Últimas N líneas
docker compose logs --tail=50 backend
```

### Entrar a un contenedor (exec)

```bash
# Shell en backend Django
docker compose exec backend bash
docker compose exec backend sh   # si no tiene bash

# Shell en frontend
docker compose exec frontend sh

# Shell en base de datos
docker compose exec db psql -U ${POSTGRES_USER} -d ${POSTGRES_DB}

# Comando puntual sin entrar
docker compose exec backend python manage.py shell
docker compose exec backend python manage.py showmigrations
docker compose exec frontend npm run lint
```

### Rebuild

```bash
# Rebuild solo un servicio (sin tirar otros)
docker compose up -d --build backend
docker compose up -d --build frontend

# Rebuild con no-cache (cuando hay problemas de capas)
docker compose build --no-cache backend

# Reiniciar servicio sin rebuild
docker compose restart backend
```

### Inspección y debug

```bash
# Ver IP y red de un contenedor
docker inspect $(docker compose ps -q backend) | grep IPAddress

# Ver variables de entorno activas en el contenedor
docker compose exec backend env | sort

# Ver puertos expuestos
docker compose port backend 8000

# Estadísticas de recursos (CPU/RAM)
docker stats

# Ver redes creadas
docker network ls | grep $(basename $(pwd))
```

## Flujos frecuentes

### "No arranca el backend"

```bash
# 1. Ver logs con contexto
docker compose logs --tail=30 backend

# 2. Si hay error de importación Python
docker compose exec backend python -c "import config"

# 3. Si hay error de DB connection — verificar que db esté healthy
docker compose ps db
docker compose logs db

# 4. Forzar recreación del contenedor
docker compose up -d --force-recreate backend
```

### "Cambié requirements.txt"

```bash
docker compose up -d --build backend
# O si querés solo el build:
docker compose build backend
docker compose up -d backend
```

### "Cambié package.json"

```bash
docker compose up -d --build frontend
```

### "Quiero reset total (borrar todo)"

```bash
docker compose down -v           # baja servicios y borra volúmenes
docker compose build --no-cache  # rebuild sin caché
docker compose up -d
docker compose exec backend python manage.py migrate
docker compose exec backend python manage.py createsuperuser
```

### "El frontend no ve el backend"

```bash
# En docker compose, el frontend debe usar el nombre del servicio, no localhost
# Verificar variable de entorno dentro del contenedor
docker compose exec frontend env | grep API

# La variable debería ser:
# NEXT_PUBLIC_API_URL=http://backend:8000/v1   ← dentro de docker
# NEXT_PUBLIC_API_URL=http://localhost:8000/v1 ← para el browser del host
```

## Variables de entorno en Docker

```bash
# Ver qué .env usa docker compose (default: .env en raíz)
docker compose config | grep -A3 "environment:"

# Pasar env var al vuelo (solo para ese run)
docker compose run --rm -e DEBUG=False backend python manage.py check --deploy
```

## Limpieza

```bash
# Borrar imágenes sin usar del proyecto
docker compose down --rmi local

# Limpieza general del sistema Docker (cuidado: afecta todos los proyectos)
docker system prune -f

# Ver tamaño de volúmenes
docker system df
```

## Output

- Entorno operativo o diagnóstico claro del problema
- Comando exacto para resolver el issue

## Notas

- `docker compose` (v2) vs `docker-compose` (v1) — usar la versión sin guión en proyectos modernos
- `--build` solo rebuilda si el Dockerfile o contexto cambió — para forzar usar `--no-cache`
- Los logs de Next.js en dev muestran HMR events normales — ignorar ruido de `router`

