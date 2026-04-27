---
name: dev-migrate
description: Workflow completo de migraciones Django — crear, aplicar, inspeccionar, resetear y resolver conflictos. Usar cuando se trabaja con modelos Django y cambios de schema de base de datos.
license: MIT
---

# dev-migrate — Migraciones Django

Todo lo relacionado con el sistema de migraciones de Django. Desde crear una migración hasta resolver conflictos y hacer rollback.

## Cuándo usar

- "aplicar migraciones", "correr migrate"
- "creé un modelo nuevo, necesito migración"
- "migración falla", "conflicto de migraciones"
- "resetear la DB", "volver a migración anterior"
- "ver estado de migraciones"

## Comandos base

### Con Docker (recomendado)
```bash
docker compose exec backend python manage.py <comando>
```

### Sin Docker
```bash
cd backend/
python manage.py <comando>
```

## Flujo estándar: nuevo modelo o cambio de campo

```bash
# 1. Detectar cambios (no aplica, solo muestra)
python manage.py makemigrations --check --dry-run

# 2. Crear migración
python manage.py makemigrations nombre_app

# 3. Ver qué hará la migración antes de aplicar
python manage.py sqlmigrate nombre_app 0003

# 4. Aplicar
python manage.py migrate

# 5. Verificar
python manage.py showmigrations nombre_app
```

## Inspeccionar estado

```bash
# Ver todas las migraciones y si están aplicadas ([X] = aplicada)
python manage.py showmigrations

# Solo una app
python manage.py showmigrations usuarios

# Ver SQL que generaría una migración
python manage.py sqlmigrate usuarios 0002_add_phone_field

# Ver migraciones pendientes
python manage.py migrate --check  # retorna exit code != 0 si hay pendientes
```

## Crear migraciones avanzadas

```bash
# Migración vacía (para lógica personalizada)
python manage.py makemigrations --empty nombre_app --name fix_legacy_data

# Migración para todas las apps que tengan cambios
python manage.py makemigrations

# Migración con nombre descriptivo
python manage.py makemigrations nombre_app --name agregar_campo_activo
```

### Migración de datos (RunPython)

```python
# apps/usuarios/migrations/0005_populate_display_name.py
from django.db import migrations

def populate_display_name(apps, schema_editor):
    User = apps.get_model('usuarios', 'User')
    for user in User.objects.filter(display_name=''):
        user.display_name = f"{user.first_name} {user.last_name}".strip()
        user.save()

def reverse_populate(apps, schema_editor):
    pass  # no reversible

class Migration(migrations.Migration):
    dependencies = [('usuarios', '0004_add_display_name')]

    operations = [
        migrations.RunPython(populate_display_name, reverse_populate),
    ]
```

## Problemas frecuentes y soluciones

### "tabla ya existe" (primera migración contra DB existente)

```bash
python manage.py migrate --fake-initial
```

### "migración ya aplicada" (migración en código pero no en DB)

```bash
# Marcar como aplicada sin ejecutar SQL
python manage.py migrate nombre_app 0003 --fake
```

### Conflicto de migraciones (dos ramas de desarrollo)

```bash
# Django detecta el conflicto
python manage.py showmigrations  # muestra dos "heads"

# Resolver: crear migración de merge
python manage.py makemigrations --merge --name merge_rama_feat
python manage.py migrate
```

### Resetear una app específica

```bash
# Desaplicar todas las migraciones de una app
python manage.py migrate nombre_app zero

# Volver a una migración específica
python manage.py migrate nombre_app 0002

# Luego reaplicar
python manage.py migrate
```

### Reset total de la DB (dev only)

```bash
# Con Docker: borrar volumen y recrear
docker compose down -v
docker compose up -d db
docker compose exec backend python manage.py migrate
docker compose exec backend python manage.py createsuperuser
```

```bash
# Sin Docker: borrar SQLite y recrear
rm db.sqlite3
python manage.py migrate
python manage.py createsuperuser
```

### Error de migración a mitad de camino

```bash
# 1. Ver qué pasó
python manage.py showmigrations nombre_app

# 2. Si la migración quedó "corrupta", desaplicar
python manage.py migrate nombre_app 000X_migración_anterior

# 3. Corregir el código del modelo o la migración

# 4. Regenerar y reaplicar
python manage.py makemigrations nombre_app
python manage.py migrate
```

## Migraciones en CI/CD

```bash
# Verificar que no hay migraciones pendientes de generar (detecta si alguien cambió modelos sin migrar)
python manage.py makemigrations --check

# Aplicar en deploy antes de levantar el servidor
python manage.py migrate --no-input
```

Ejemplo en `docker-compose.yml`:
```yaml
backend:
  command: >
    sh -c "python manage.py migrate --no-input &&
           python manage.py runserver 0.0.0.0:8000"
```

## Output

- Migraciones creadas y/o aplicadas
- Diagnóstico del problema si hay error
- Estado final verificado con `showmigrations`

## Notas

- Nunca editar migraciones ya aplicadas en producción
- Siempre commitear las migraciones junto con los cambios de modelo
- `makemigrations --check` en CI evita que alguien olvide generar la migración
- Para Django + PostgreSQL en Docker: las migraciones SQLite no son 100% equivalentes — siempre probar contra PostgreSQL
