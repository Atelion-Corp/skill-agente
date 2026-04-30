---
name: dev-ports
description: Configura y diagnostica puertos en proyectos Django+Next.js+Docker — mapeo de servicios, CORS, proxy nginx, puertos en conflicto. Usar cuando hay problemas de conexión entre servicios o con el exterior.
license: MIT
---

# dev-ports — Puertos, CORS y Conectividad

Gestiona la configuración de puertos y red para el stack Django + Next.js + Docker. Cubre desde el mapeo básico de puertos hasta la configuración de Nginx como proxy reverso.

## Cuándo usar

- "qué puertos necesito habilitar"
- "CORS error en el frontend"
- "el puerto 8000 ya está en uso"
- "quiero acceder al proyecto desde otra máquina en la red"
- "configurar nginx como proxy"
- "el frontend no puede llamar al backend"

## Puertos del stack

| Servicio | Puerto interno | Puerto host (dev) |
|----------|---------------|-------------------|
| PostgreSQL | 5432 | 5432 |
| Redis | 6379 | 6379 |
| Django | 8000 | 8000 |
| Next.js | 3000 | 3000 |
| Nginx (prod) | 80 / 443 | 80 / 443 |

## Diagnosticar puerto en uso

```bash
# Ver qué proceso usa el puerto
netstat -tlnp | grep 8000         # Linux
ss -tlnp | grep 8000              # Linux (moderno)
lsof -i :8000                     # macOS/Linux
Get-NetTCPConnection -LocalPort 8000  # Windows PowerShell

# Matar proceso en el puerto (Linux/macOS)
kill -9 $(lsof -t -i:8000)

# Cambiar puerto en docker-compose.yml si hay conflicto
# ports: "8001:8000"  ← host:container
```

## Configurar CORS en Django

Instalar:
```bash
pip install django-cors-headers
# Agregar a requirements/base.txt
```

`config/settings/base.py`:
```python
INSTALLED_APPS = [
    ...
    'corsheaders',
    ...
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',  # ← debe ir PRIMERO
    'django.middleware.common.CommonMiddleware',
    ...
]

# Dev: permitir localhost del frontend
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
]

# Prod: dominio real
# CORS_ALLOWED_ORIGINS = ["https://app.midominio.com"]

# Si necesitás enviar cookies/tokens
CORS_ALLOW_CREDENTIALS = True

# Para JWT en headers (más común que cookies)
CORS_ALLOW_HEADERS = [
    "accept",
    "authorization",
    "content-type",
    "x-csrftoken",
]
```

## Exponer puertos en Docker Compose

```yaml
# docker-compose.yml

services:
  backend:
    ports:
      - "8000:8000"       # host:container

  frontend:
    ports:
      - "3000:3000"

  db:
    ports:
      - "5432:5432"       # solo en dev — no exponer en prod

  redis:
    ports:
      - "6379:6379"       # solo en dev
```

Acceder desde red local (otra PC en la misma WiFi):
```yaml
  backend:
    ports:
      - "0.0.0.0:8000:8000"   # escucha en todas las interfaces
```

## Variables de entorno según contexto

```bash
# Para el browser del cliente (Next.js side):
NEXT_PUBLIC_API_URL=http://localhost:8000/v1

# Para el servidor Next.js dentro de Docker (SSR):
API_URL=http://backend:8000/v1

# El nombre "backend" es el nombre del servicio en docker-compose.yml
```

## Nginx como proxy reverso (producción)

```nginx
# nginx/nginx.conf

upstream backend {
    server backend:8000;
}

upstream frontend {
    server frontend:3000;
}

server {
    listen 80;
    server_name midominio.com;

    # Frontend → Next.js
    location / {
        proxy_pass http://frontend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    # API → Django
    location /api/ {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Static / media Django
    location /static/ {
        alias /app/staticfiles/;
    }

    location /media/ {
        alias /app/mediafiles/;
    }
}
```

Agregar servicio en `docker-compose.yml`:
```yaml
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf:ro
      - static_volume:/app/staticfiles
    depends_on:
      - backend
      - frontend
```

## Verificar conectividad entre servicios

```bash
# Desde el contenedor backend, ¿puede llegar a la DB?
docker compose exec backend python -c "
import psycopg2, os
conn = psycopg2.connect(os.environ['DATABASE_URL'])
print('DB OK')
conn.close()
"

# ¿Puede llegar a Redis?
docker compose exec backend python -c "
import redis, os
r = redis.from_url(os.environ['REDIS_URL'])
print('Redis OK:', r.ping())
"

# Desde frontend, ¿puede llegar al backend?
docker compose exec frontend wget -qO- http://backend:8000/api/ | head -20

# Ver red interna de docker compose
docker network inspect $(docker compose ps -q backend | head -1 | xargs docker inspect --format='{{range .NetworkSettings.Networks}}{{.NetworkID}}{{end}}') | python -m json.tool | grep -A5 "Containers"
```

## Habilitar puertos en GCP (Cloud Run / firewall)

```bash
# Cloud Run expone automáticamente en el puerto 8080 — configurar en Dockerfile
ENV PORT=8080
EXPOSE 8080
CMD exec gunicorn --bind :$PORT config.wsgi:application

# VPC / Firewall rule para permitir tráfico externo en puerto custom
gcloud compute firewall-rules create allow-8000 \
  --allow tcp:8000 \
  --source-ranges 0.0.0.0/0 \
  --description "Allow port 8000"
```

## Output

- Diagnóstico del problema de conectividad
- Configuración CORS correcta
- Puertos mapeados y verificados
- Nginx config si aplica

## Notas

- CORS es un problema del BROWSER — si usás Postman/curl y funciona, es CORS
- Dentro de Docker, los servicios se hablan por nombre de servicio, no `localhost`
- En producción: NO exponer puertos de DB y Redis directamente — solo nginx/8080
- `CORS_ALLOWED_ORIGINS` debe tener el origen EXACTO (con protocolo y puerto)


