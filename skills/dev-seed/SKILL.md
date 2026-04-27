---
name: dev-seed
description: Poblar datos iniciales para proyectos Django — fixtures, management commands, Factory Boy, createsuperuser. Usar cuando se necesitan datos de prueba o datos iniciales de producción.
license: MIT
---

# dev-seed — Datos Iniciales y Fixtures

Estrategias para poblar la base de datos de un proyecto Django con datos de prueba o datos iniciales reales.

## Cuándo usar

- "necesito datos de prueba"
- "poblar la DB con datos iniciales"
- "crear superusuario"
- "cargar fixtures"
- "datos iniciales para producción (ej: categorías, roles)"

## Superusuario

```bash
# Interactivo
docker compose exec backend python manage.py createsuperuser

# No interactivo (para CI/scripts)
docker compose exec backend python manage.py createsuperuser \
  --email admin@proyecto.com \
  --username admin \
  --noinput
  
# Después asignar password
docker compose exec backend python manage.py shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
u = User.objects.get(email='admin@proyecto.com')
u.set_password('admin123')
u.save()
print('Password set')
"
```

## Fixtures JSON

### Crear fixture desde datos existentes

```bash
# Exportar todos los datos de una app
docker compose exec backend python manage.py dumpdata nombre_app --indent 2 > fixtures/nombre_app.json

# Solo un modelo
docker compose exec backend python manage.py dumpdata nombre_app.Proyecto --indent 2 > fixtures/proyectos.json

# Excluir modelos de auth por seguridad
docker compose exec backend python manage.py dumpdata --exclude auth.permission --exclude contenttypes --indent 2 > fixtures/initial_data.json
```

### Cargar fixtures

```bash
docker compose exec backend python manage.py loaddata fixtures/nombre_app.json
```

### Fixture de ejemplo (roles/categorías — datos estáticos)

```json
[
  {
    "model": "nombre_app.Categoria",
    "pk": 1,
    "fields": {
      "nombre": "Tecnología",
      "slug": "tecnologia",
      "activo": true
    }
  },
  {
    "model": "nombre_app.Categoria",
    "pk": 2,
    "fields": {
      "nombre": "Finanzas",
      "slug": "finanzas",
      "activo": true
    }
  }
]
```

### Cargar fixture automáticamente al hacer migrate

```python
# apps/nombre_app/apps.py
from django.apps import AppConfig

class NombreAppConfig(AppConfig):
    name = 'apps.nombre_app'

    def ready(self):
        pass  # No usar ready() para fixtures

# En su lugar, usar post_migrate signal:
# O mejor: management command propio (ver abajo)
```

## Management Command personalizado

### Seed de desarrollo (datos de prueba)

```python
# apps/nombre_app/management/commands/seed_dev.py
from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from apps.proyectos.models import Proyecto

User = get_user_model()


class Command(BaseCommand):
    help = 'Poblar DB con datos de desarrollo'

    def add_arguments(self, parser):
        parser.add_argument('--reset', action='store_true', help='Borrar datos existentes primero')

    def handle(self, *args, **options):
        if options['reset']:
            self.stdout.write('Borrando datos existentes...')
            Proyecto.objects.all().delete()
            User.objects.filter(is_superuser=False).delete()

        self.stdout.write('Creando usuarios de prueba...')
        users = []
        for i in range(1, 4):
            user, created = User.objects.get_or_create(
                email=f'user{i}@dev.com',
                defaults={
                    'first_name': f'Usuario',
                    'last_name': f'{i}',
                    'is_active': True,
                }
            )
            if created:
                user.set_password('dev123')
                user.save()
            users.append(user)
            self.stdout.write(f'  ✓ {user.email}')

        self.stdout.write('Creando proyectos de prueba...')
        nombres = ['Proyecto Alpha', 'Proyecto Beta', 'Proyecto Gamma', 'Proyecto Delta']
        for i, nombre in enumerate(nombres):
            p, created = Proyecto.objects.get_or_create(
                nombre=nombre,
                defaults={
                    'descripcion': f'Descripción de {nombre}',
                    'creado_por': users[i % len(users)],
                    'activo': True,
                }
            )
            if created:
                self.stdout.write(f'  ✓ {p.nombre}')

        self.stdout.write(self.style.SUCCESS('✅ Seed completado'))
        self.stdout.write(f'   Usuarios: user1@dev.com, user2@dev.com, user3@dev.com (pass: dev123)')
```

```bash
docker compose exec backend python manage.py seed_dev
docker compose exec backend python manage.py seed_dev --reset  # borra y recrea
```

### Seed de producción (datos estáticos requeridos)

```python
# apps/configuracion/management/commands/seed_prod.py
from django.core.management.base import BaseCommand
from apps.configuracion.models import Rol, Categoria

ROLES_INICIALES = [
    {'nombre': 'Administrador', 'permisos': 'all'},
    {'nombre': 'Editor', 'permisos': 'edit'},
    {'nombre': 'Viewer', 'permisos': 'read'},
]

class Command(BaseCommand):
    help = 'Datos estáticos requeridos para producción (idempotente)'

    def handle(self, *args, **options):
        for rol_data in ROLES_INICIALES:
            Rol.objects.get_or_create(
                nombre=rol_data['nombre'],
                defaults=rol_data
            )
        self.stdout.write(self.style.SUCCESS('Roles iniciales OK'))
```

### Integrar seed_prod en el deploy

```yaml
# docker-compose.yml
backend:
  command: >
    sh -c "python manage.py migrate --no-input &&
           python manage.py seed_prod &&
           python manage.py runserver 0.0.0.0:8000"
```

## Seed con Factory Boy (tests + dev)

```python
# apps/proyectos/tests/factories.py
import factory
from faker import Faker

fake = Faker('es_CL')

class ProyectoFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = 'proyectos.Proyecto'

    nombre = factory.LazyFunction(lambda: fake.company())
    descripcion = factory.LazyFunction(lambda: fake.paragraph(nb_sentences=3))
    activo = True
    creado_por = factory.SubFactory('apps.usuarios.tests.factories.UserFactory')
```

Usar desde management command:

```python
# En seed_dev.py
from apps.proyectos.tests.factories import ProyectoFactory, UserFactory

# Crear 10 usuarios y 30 proyectos distribuidos
users = UserFactory.create_batch(10)
for user in users:
    ProyectoFactory.create_batch(3, creado_por=user)
```

## Output

- DB poblada con datos listos para usar
- Credenciales de usuarios de prueba impresas en consola
- Management command reutilizable para el equipo

## Notas

- `get_or_create` hace el seed idempotente — correr múltiples veces no duplica
- Fixtures JSON = datos estáticos simples; management commands = lógica compleja
- `seed_prod` solo datos estáticos requeridos — nunca datos sensibles
- `seed_dev` nunca en producción — proteger con `if settings.DEBUG`
- Passwords de dev hardcodeados en el command están bien (es dev) — no en fixtures
