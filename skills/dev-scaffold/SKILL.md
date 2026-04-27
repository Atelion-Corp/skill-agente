---
name: dev-scaffold
description: Scaffoldear nuevas apps Django, endpoints DRF, modelos, y páginas/componentes Next.js siguiendo el patrón del stack Atelion. Usar cuando se agrega funcionalidad nueva al proyecto.
license: MIT
---

# dev-scaffold — Scaffold de Apps y Features

Genera la estructura correcta para nuevas funcionalidades siguiendo el patrón Django + DRF + Next.js. Cero código basura — solo el esqueleto mínimo funcional.

## Cuándo usar

- "nueva app Django para gestionar X"
- "agregar endpoint para Y"
- "nueva página en Next.js"
- "modelo + serializer + viewset para Z"
- "nueva ruta API REST"

## Scaffold: nueva app Django

### 1. Crear la app

```bash
# Desde dentro del directorio backend (o con Docker)
docker compose exec backend python manage.py startapp nombre_app apps/nombre_app

# Estructura resultante:
# apps/nombre_app/
#   __init__.py
#   admin.py
#   apps.py
#   models.py
#   tests.py
#   views.py
#   migrations/
#     __init__.py
```

### 2. Registrar en settings

```python
# config/settings/base.py
INSTALLED_APPS = [
    ...
    'apps.nombre_app',
]
```

### 3. Actualizar AppConfig

```python
# apps/nombre_app/apps.py
from django.apps import AppConfig

class NombreAppConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.nombre_app'
    verbose_name = 'Nombre App'
```

### 4. Estructura completa de la app

Crear los archivos adicionales:

```
apps/nombre_app/
  __init__.py
  admin.py
  apps.py
  models.py
  serializers.py     ← nuevo
  views.py
  urls.py            ← nuevo
  permissions.py     ← nuevo (opcional)
  filters.py         ← nuevo (opcional)
  tests/
    __init__.py
    test_models.py
    test_views.py
  migrations/
    __init__.py
```

## Scaffold: modelo + serializer + viewset completo

### Modelo

```python
# apps/nombre_app/models.py
from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class Proyecto(models.Model):
    nombre = models.CharField(max_length=200)
    descripcion = models.TextField(blank=True)
    activo = models.BooleanField(default=True)
    creado_por = models.ForeignKey(
        User, on_delete=models.SET_NULL, null=True, related_name='proyectos'
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']
        verbose_name = 'Proyecto'
        verbose_name_plural = 'Proyectos'

    def __str__(self):
        return self.nombre
```

### Serializer

```python
# apps/nombre_app/serializers.py
from rest_framework import serializers
from .models import Proyecto


class ProyectoSerializer(serializers.ModelSerializer):
    creado_por_nombre = serializers.CharField(
        source='creado_por.get_full_name', read_only=True
    )

    class Meta:
        model = Proyecto
        fields = ['id', 'nombre', 'descripcion', 'activo', 'creado_por', 'creado_por_nombre', 'created_at', 'updated_at']
        read_only_fields = ['id', 'creado_por', 'created_at', 'updated_at']

    def create(self, validated_data):
        validated_data['creado_por'] = self.context['request'].user
        return super().create(validated_data)
```

### ViewSet

```python
# apps/nombre_app/views.py
from rest_framework import viewsets, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from .models import Proyecto
from .serializers import ProyectoSerializer


class ProyectoViewSet(viewsets.ModelViewSet):
    serializer_class = ProyectoSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Proyecto.objects.filter(
            creado_por=self.request.user,
            activo=True
        ).select_related('creado_por')

    # Acción custom: /api/v1/proyectos/{id}/archivar/
    @action(detail=True, methods=['post'])
    def archivar(self, request, pk=None):
        proyecto = self.get_object()
        proyecto.activo = False
        proyecto.save()
        return Response({'status': 'archivado'})
```

### URLs de la app

```python
# apps/nombre_app/urls.py
from rest_framework.routers import DefaultRouter
from .views import ProyectoViewSet

router = DefaultRouter()
router.register(r'proyectos', ProyectoViewSet, basename='proyecto')

urlpatterns = router.urls
```

### Registrar en API router principal

```python
# config/api_urls.py
from django.urls import path, include

urlpatterns = [
    path('auth/', include('apps.usuarios.urls')),
    path('', include('apps.nombre_app.urls')),  # ← agregar aquí
]
```

### Admin

```python
# apps/nombre_app/admin.py
from django.contrib import admin
from .models import Proyecto

@admin.register(Proyecto)
class ProyectoAdmin(admin.ModelAdmin):
    list_display = ['nombre', 'activo', 'creado_por', 'created_at']
    list_filter = ['activo']
    search_fields = ['nombre', 'descripcion']
    readonly_fields = ['created_at', 'updated_at']
```

### Migración

```bash
docker compose exec backend python manage.py makemigrations nombre_app
docker compose exec backend python manage.py migrate
```

## Scaffold: página Next.js (App Router)

### Estructura mínima

```
src/app/
  proyectos/
    page.tsx          ← lista
    [id]/
      page.tsx        ← detalle
      edit/
        page.tsx      ← formulario edición
  components/
    proyectos/
      ProyectoCard.tsx
      ProyectoForm.tsx
```

### Página de lista

```tsx
// src/app/proyectos/page.tsx
import { ProyectoCard } from '@/components/proyectos/ProyectoCard'
import { api } from '@/lib/api'

async function getProyectos() {
  const res = await api.get('/proyectos/')
  return res.data.results
}

export default async function ProyectosPage() {
  const proyectos = await getProyectos()

  return (
    <div className="container py-8">
      <h1 className="text-2xl font-bold mb-6">Proyectos</h1>
      <div className="grid gap-4">
        {proyectos.map((p: any) => (
          <ProyectoCard key={p.id} proyecto={p} />
        ))}
      </div>
    </div>
  )
}
```

### Tipos TypeScript

```typescript
// src/types/index.ts — agregar:
export interface Proyecto {
  id: number
  nombre: string
  descripcion: string
  activo: boolean
  creado_por: number
  creado_por_nombre: string
  created_at: string
  updated_at: string
}
```

## Checklist al terminar un scaffold

- [ ] `makemigrations` + `migrate` corridos
- [ ] Registrado en `INSTALLED_APPS`
- [ ] URLs incluidas en `config/api_urls.py`
- [ ] Endpoint verificado: `GET /api/v1/proyectos/`
- [ ] Admin registrado
- [ ] Tipos TypeScript actualizados
- [ ] Test esqueleto creado en `tests/`

## Output

- App Django completa: model + serializer + viewset + urls + admin
- Página Next.js con tipos
- Checkliat de integración completado

## Notas

- `select_related` y `prefetch_related` desde el principio — evita N+1 queries
- `read_only_fields` en serializer para campos que no debe editar el cliente
- `get_queryset` filtrado por usuario — nunca exponer datos de otros usuarios
- En Next.js: `async function getX()` en Server Component, hooks solo en Client Components
