---
name: dev-dockerize
description: Agrega Docker a un proyecto Django+Next.js existente que no lo tiene. Genera Dockerfile para backend y frontend, docker-compose.yml completo con todos los servicios, y .env.example. Usar cuando el proyecto aún no tiene contenedores.
license: MIT
---

# dev-dockerize — Dockerizar Proyecto Django + Next.js

Genera la configuración completa de Docker para un proyecto Django + Next.js desde cero. Un solo comando y el proyecto queda listo para correr en contenedores.

## Cuándo usar

- "quiero dockerizar mi proyecto"
- "agregar Docker a un proyecto existente"
- "necesito un docker-compose"
- Proyecto que solo tiene `manage.py` y `package.json` sin Dockerfiles

## Workflow

### 1. Intake

Preguntar (si no se puede detectar del código):

```
1. ¿Cómo se llama el proyecto? (para nombres de imagen)
2. ¿Dónde está el backend Django? (ej: ./backend o ./aplicaciones/backend)
3. ¿Dónde está el frontend Next.js? (ej: ./frontend o ./aplicaciones/frontend)
4. ¿Usás Celery/workers? (para agregar servicio worker)
5. ¿Puerto del backend en dev? (default: 8000)
6. ¿Puerto del frontend en dev? (default: 3000)
```

### 2. Detectar estructura existente

```bash
# Detectar requirements
ls backend/requirements*.txt backend/requirements/

# Detectar si usa poetry/pipenv
ls backend/pyproject.toml backend/Pipfile

# Detectar versión de Python en uso
cat backend/runtime.txt 2>/dev/null || python --version
```

### 3. Generar Dockerfile del backend

```dockerfile
# backend/Dockerfile
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements/base.txt requirements/dev.txt ./requirements/
RUN pip install --no-cache-dir -r requirements/dev.txt

COPY . .

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

Variante producción (usa gunicorn):
```dockerfile
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "2"]
```

### 4. Generar Dockerfile del frontend

```dockerfile
# frontend/Dockerfile
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

FROM node:20-alpine AS dev
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev"]
```

Variante producción (multi-stage):
```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
EXPOSE 3000
CMD ["node", "server.js"]
```

### 5. Generar docker-compose.yml

```yaml
# docker-compose.yml (raíz del proyecto)
services:
  db:
    image: postgres:16-alpine
    volumes:
      - postgres_data:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    volumes:
      - ./backend:/app
    ports:
      - "8000:8000"
    env_file:
      - .env
    environment:
      DATABASE_URL: postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
      REDIS_URL: redis://redis:6379/0
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    command: python manage.py runserver 0.0.0.0:8000

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    volumes:
      - ./frontend:/app
      - /app/node_modules
    ports:
      - "3000:3000"
    env_file:
      - .env
    environment:
      NEXT_PUBLIC_API_URL: http://localhost:8000/api/v1
    depends_on:
      - backend

volumes:
  postgres_data:
```

Si el proyecto usa Celery, agregar servicio:
```yaml
  worker:
    build:
      context: ./backend
      dockerfile: Dockerfile
    volumes:
      - ./backend:/app
    env_file:
      - .env
    environment:
      DATABASE_URL: postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
      REDIS_URL: redis://redis:6379/0
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    command: celery -A config worker -l info
```

### 6. Generar .env.example

```env
# .env.example — copiar a .env y completar valores

# Django
SECRET_KEY=django-insecure-CHANGE-THIS-IN-PRODUCTION
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# PostgreSQL
POSTGRES_DB=proyecto_db
POSTGRES_USER=proyecto_user
POSTGRES_PASSWORD=CHANGE_THIS

# Redis
REDIS_URL=redis://redis:6379/0

# Frontend
NEXT_PUBLIC_API_URL=http://localhost:8000/api/v1

# Email (opcional)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_HOST_USER=
EMAIL_HOST_PASSWORD=
```

### 7. Generar .dockerignore

Para backend:
```
# backend/.dockerignore
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
.env
.env.*
*.sqlite3
.git
.pytest_cache/
staticfiles/
mediafiles/
node_modules/
```

Para frontend:
```
# frontend/.dockerignore
node_modules/
.next/
.env*
.git
*.md
```

### 8. Actualizar settings Django

En `config/settings/base.py`, asegurar:
```python
import os
import dj_database_url  # pip install dj-database-url

DATABASES = {
    'default': dj_database_url.config(
        default=os.environ.get('DATABASE_URL', 'sqlite:///db.sqlite3')
    )
}

REDIS_URL = os.environ.get('REDIS_URL', 'redis://localhost:6379/0')

ALLOWED_HOSTS = os.environ.get('ALLOWED_HOSTS', 'localhost').split(',')
```

### 9. Verificar levantada inicial

```bash
# Copiar env
cp .env.example .env

# Build y levantar
docker compose up --build -d

# Correr migraciones iniciales
docker compose exec backend python manage.py migrate

# Verificar servicios activos
docker compose ps
```

## Output

- `backend/Dockerfile`
- `frontend/Dockerfile`
- `docker-compose.yml` (raíz)
- `.env.example` (raíz)
- `backend/.dockerignore`
- `frontend/.dockerignore`
- Instrucciones de arranque inicial

## Notas

- `dj-database-url` debe estar en `requirements/base.txt`
- Volumen para `node_modules` evita sobreescribir el módulo del contenedor con el del host
- `depends_on: condition: service_healthy` asegura orden de arranque correcto
- Para producción: cambiar `command` a gunicorn y usar multi-stage build en frontend
