---
name: dev-test
description: Correr y escribir tests para el stack Django+Next.js — pytest para backend, Jest/Playwright para frontend, setup de CI. Usar cuando se agrega funcionalidad nueva o se quiere verificar que todo funciona.
license: MIT
---

# dev-test — Testing Backend y Frontend

Cubre el ciclo completo de tests para el stack Django + Next.js + Docker.

## Cuándo usar

- "correr los tests", "pasar el test suite"
- "escribir test para este endpoint"
- "coverage del backend"
- "test de integración"
- "agregar tests al CI"

## Backend — pytest + Django

### Setup

```bash
# requirements/dev.txt
pytest
pytest-django
pytest-cov
factory-boy
faker
```

```ini
# backend/pytest.ini
[pytest]
DJANGO_SETTINGS_MODULE = config.settings.dev
python_files = test_*.py *_test.py
python_classes = Test*
python_functions = test_*
addopts = -v --tb=short
```

### Correr tests

```bash
# Todos los tests
docker compose exec backend pytest

# Una app
docker compose exec backend pytest apps/usuarios/

# Un archivo
docker compose exec backend pytest apps/usuarios/tests/test_views.py

# Un test específico
docker compose exec backend pytest apps/usuarios/tests/test_views.py::TestLoginView::test_login_success

# Con coverage
docker compose exec backend pytest --cov=apps --cov-report=term-missing

# Solo tests marcados como fast
docker compose exec backend pytest -m fast
```

### Estructura de tests

```
apps/nombre_app/
  tests/
    __init__.py
    test_models.py
    test_serializers.py
    test_views.py
    factories.py
```

### Test de endpoint DRF

```python
# apps/proyectos/tests/test_views.py
import pytest
from rest_framework.test import APIClient
from .factories import UserFactory, ProyectoFactory

@pytest.fixture
def client():
    return APIClient()

@pytest.fixture
def user(db):
    return UserFactory()

@pytest.fixture
def authenticated_client(client, user):
    client.force_authenticate(user=user)
    return client


@pytest.mark.django_db
class TestProyectoViewSet:

    def test_list_only_own_projects(self, authenticated_client, user):
        ProyectoFactory(creado_por=user)
        ProyectoFactory()  # de otro usuario

        response = authenticated_client.get('/api/proyectos/')

        assert response.status_code == 200
        assert len(response.data['results']) == 1

    def test_create_project(self, authenticated_client):
        payload = {'nombre': 'Mi Proyecto', 'descripcion': 'Descripción'}

        response = authenticated_client.post('/api/proyectos/', payload)

        assert response.status_code == 201
        assert response.data['nombre'] == 'Mi Proyecto'

    def test_unauthenticated_returns_401(self, client):
        response = client.get('/api/proyectos/')
        assert response.status_code == 401
```

### Factory Boy

```python
# apps/proyectos/tests/factories.py
import factory
from django.contrib.auth import get_user_model
from apps.proyectos.models import Proyecto

User = get_user_model()


class UserFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = User

    email = factory.Sequence(lambda n: f'user{n}@test.com')
    first_name = factory.Faker('first_name')
    last_name = factory.Faker('last_name')
    is_active = True

    @classmethod
    def _create(cls, model_class, *args, **kwargs):
        return model_class.objects.create_user(*args, **kwargs)


class ProyectoFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Proyecto

    nombre = factory.Faker('company')
    descripcion = factory.Faker('text', max_nb_chars=200)
    activo = True
    creado_por = factory.SubFactory(UserFactory)
```

### Test de modelo

```python
# apps/proyectos/tests/test_models.py
import pytest
from .factories import ProyectoFactory

@pytest.mark.django_db
class TestProyectoModel:

    def test_str_returns_nombre(self):
        p = ProyectoFactory(nombre='Mi Proyecto')
        assert str(p) == 'Mi Proyecto'

    def test_activo_default_true(self):
        p = ProyectoFactory()
        assert p.activo is True

    def test_ordering_by_created_at_desc(self):
        p1 = ProyectoFactory()
        p2 = ProyectoFactory()
        proyectos = list(type(p1).objects.all())
        assert proyectos[0] == p2  # más reciente primero
```

## Frontend — Jest + Testing Library

### Setup

```bash
# next.config.ts — Jest ya viene configurado en Next.js
npm install --save-dev jest @testing-library/react @testing-library/jest-dom jest-environment-jsdom
```

```json
// package.json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage"
  }
}
```

### Correr tests

```bash
# Todos
docker compose exec frontend npm test

# Con watch (dev)
docker compose exec frontend npm run test:watch

# Coverage
docker compose exec frontend npm run test:coverage -- --watchAll=false
```

### Test de componente

```tsx
// src/components/proyectos/__tests__/ProyectoCard.test.tsx
import { render, screen } from '@testing-library/react'
import { ProyectoCard } from '../ProyectoCard'

const mockProyecto = {
  id: 1,
  nombre: 'Mi Proyecto',
  descripcion: 'Descripción del proyecto',
  activo: true,
}

describe('ProyectoCard', () => {
  it('muestra el nombre del proyecto', () => {
    render(<ProyectoCard proyecto={mockProyecto} />)
    expect(screen.getByText('Mi Proyecto')).toBeInTheDocument()
  })

  it('no se muestra si está inactivo', () => {
    render(<ProyectoCard proyecto={{ ...mockProyecto, activo: false }} />)
    expect(screen.queryByText('Mi Proyecto')).not.toBeInTheDocument()
  })
})
```

## CI/CD — GitLab

```yaml
# .gitlab-ci.yml
test-backend:
  stage: test
  image: python:3.12-slim
  services:
    - postgres:16-alpine
  variables:
    POSTGRES_DB: test_db
    POSTGRES_USER: test_user
    POSTGRES_PASSWORD: test_pass
    DATABASE_URL: postgres://test_user:test_pass@postgres/test_db
    SECRET_KEY: test-secret-key-only-for-ci
    DEBUG: "True"
  script:
    - cd backend
    - pip install -r requirements/dev.txt
    - pytest --cov=apps --cov-report=term-missing
  coverage: '/TOTAL.*\s+(\d+%)$/'

test-frontend:
  stage: test
  image: node:20-alpine
  script:
    - cd frontend
    - npm ci
    - npm run test:coverage -- --watchAll=false
```

## Output

- Tests corriendo y pasando
- Coverage report
- Test nuevo escrito para el feature/bug

## Notas

- `@pytest.mark.django_db` necesario para cualquier test que toque la DB
- `force_authenticate` es más rápido que simular login real en tests de API
- Factories > fixtures fijas — más flexibles y maintainables
- En Next.js: testar lógica y componentes, no implementación (getByRole > getByTestId)


