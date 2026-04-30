---
name: dev-env
description: Setup y gestión de variables de entorno para proyectos Django+Next.js+Docker — crear .env, .env.example, validar variables requeridas, generar secrets. Usar al iniciar proyecto o cuando falta configuración de entorno.
license: MIT
---

# dev-env — Variables de Entorno

Gestiona la configuración de entorno para el stack Django + Next.js + Docker. Desde el `.env` inicial hasta validación en producción.

## Cuándo usar

- "configurar variables de entorno"
- "qué variables necesita el proyecto"
- "generar SECRET_KEY"
- "el proyecto no arranca por variables faltantes"
- "separar config de dev y prod"

## Estructura de archivos .env

```
proyecto/
  .env                    ← variables reales (NO en git)
  .env.example            ← plantilla con keys vacías (SÍ en git)
  .env.test               ← para correr tests (opcional)
  backend/
    .env.local            ← overrides locales backend (opcional)
  frontend/
    .env.local            ← overrides locales Next.js (opcional)
```

## .env.example completo (stack Django + Next.js + Docker)

```env
# =============================================================
# DJANGO
# =============================================================
SECRET_KEY=django-insecure-REPLACE-WITH-50-CHAR-RANDOM-STRING
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1,0.0.0.0

# =============================================================
# BASE DE DATOS
# =============================================================
POSTGRES_DB=proyecto_db
POSTGRES_USER=proyecto_user
POSTGRES_PASSWORD=CHANGE_THIS_PASSWORD
DATABASE_URL=postgres://proyecto_user:CHANGE_THIS_PASSWORD@db:5432/proyecto_db

# =============================================================
# REDIS / CACHE
# =============================================================
REDIS_URL=redis://redis:6379/0
CACHE_URL=redis://redis:6379/1

# =============================================================
# NEXT.JS (FRONTEND)
# =============================================================
# URL que usa el BROWSER para llamar al backend
NEXT_PUBLIC_API_URL=http://localhost:8000/v1
# URL que usa el servidor Next.js (SSR) para llamar al backend
API_URL=http://backend:8000/v1

# =============================================================
# EMAIL (OPCIONAL)
# =============================================================
EMAIL_BACKEND=django.core.mail.backends.console.EmailBackend
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=
EMAIL_HOST_PASSWORD=

# =============================================================
# ALMACENAMIENTO (OPCIONAL — GCS)
# =============================================================
GCS_BUCKET_NAME=
GOOGLE_APPLICATION_CREDENTIALS=

# =============================================================
# CELERY (OPCIONAL)
# =============================================================
CELERY_BROKER_URL=redis://redis:6379/0
CELERY_RESULT_BACKEND=redis://redis:6379/0

# =============================================================
# CORS / SEGURIDAD
# =============================================================
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
```

## Generar SECRET_KEY Django

```python
# Desde Python
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"

# O con secrets (sin Django)
python -c "import secrets; print(secrets.token_urlsafe(50))"
```

## Cargar variables en Django

```python
# config/settings/base.py
import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent.parent

# Variables críticas — fallback solo para dev
SECRET_KEY = os.environ['SECRET_KEY']  # sin default → falla si falta
DEBUG = os.environ.get('DEBUG', 'False') == 'True'
ALLOWED_HOSTS = os.environ.get('ALLOWED_HOSTS', 'localhost').split(',')

# DB via dj-database-url
import dj_database_url
DATABASES = {
    'default': dj_database_url.config(
        default=f"sqlite:///{BASE_DIR / 'db.sqlite3'}"
    )
}

# Redis
REDIS_URL = os.environ.get('REDIS_URL', 'redis://localhost:6379/0')

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.redis.RedisCache',
        'LOCATION': os.environ.get('CACHE_URL', 'redis://localhost:6379/1'),
    }
}
```

## Validar variables requeridas al arrancar

```python
# config/settings/base.py — agregar al final
REQUIRED_ENV_VARS = [
    'SECRET_KEY',
    'POSTGRES_DB',
    'POSTGRES_USER',
    'POSTGRES_PASSWORD',
]

missing = [var for var in REQUIRED_ENV_VARS if not os.environ.get(var)]
if missing:
    raise EnvironmentError(
        f"Variables de entorno requeridas faltantes: {', '.join(missing)}\n"
        "Copiar .env.example a .env y completar los valores."
    )
```

## Settings por entorno

```python
# config/settings/dev.py
from .base import *

DEBUG = True
ALLOWED_HOSTS = ['*']

# Email en consola en dev
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# Debug toolbar
INSTALLED_APPS += ['debug_toolbar']
MIDDLEWARE = ['debug_toolbar.middleware.DebugToolbarMiddleware'] + MIDDLEWARE
```

```python
# config/settings/prod.py
from .base import *

DEBUG = False

# Seguridad
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_HSTS_SECONDS = 31536000

# Static files
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'
```

## Variables en Next.js

```typescript
// src/lib/env.ts — validar en build time
const requiredEnvVars = [
  'NEXT_PUBLIC_API_URL',
] as const

for (const key of requiredEnvVars) {
  if (!process.env[key]) {
    throw new Error(`Variable de entorno requerida: ${key}`)
  }
}

export const env = {
  apiUrl: process.env.NEXT_PUBLIC_API_URL!,
  // Para server-side (no exponer al browser):
  internalApiUrl: process.env.API_URL || process.env.NEXT_PUBLIC_API_URL!,
}
```

Reglas Next.js:
- `NEXT_PUBLIC_*` → visible en el browser (cuidado con secrets)
- Sin prefijo → solo servidor (SSR, API routes)

## Variables en Docker Compose

```yaml
# Forma 1: env_file (recomendado)
services:
  backend:
    env_file:
      - .env

# Forma 2: variables explícitas (para overrides)
  backend:
    env_file:
      - .env
    environment:
      DATABASE_URL: postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
```

## Comandos útiles

```bash
# Copiar ejemplo y editar
cp .env.example .env
nano .env   # o code .env

# Ver variables activas dentro del contenedor
docker compose exec backend env | grep -E "SECRET|DB|REDIS" | sort

# Verificar que Django carga bien el entorno
docker compose exec backend python manage.py check

# Ver qué settings usa Django
docker compose exec backend python -c "import django; django.setup(); from django.conf import settings; print(settings.DATABASES)"
```

## Gitignore (verificar que esté)

```gitignore
# Entorno
.env
.env.local
.env.*.local
!.env.example
!.env.test.example

# Nunca
*.pem
*.key
credentials.json
service-account.json
```

## Output

- `.env.example` completo para el proyecto
- `.env` local listo para usar
- Settings Django validando variables al arrancar
- Gitignore actualizado

## Notas

- Nunca `os.environ.get('SECRET_KEY', 'default-insecure')` en prod — fallar explícitamente
- `NEXT_PUBLIC_*` se embebe en el bundle JS — no poner secrets ahí
- En GCP Cloud Run: variables van en la config del servicio, no en `.env`
- Separar `dev.py` y `prod.py` evita accidentes de configuración en deploy

