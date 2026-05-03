# Admin UI/UX Operaciones (Solo Admin)

## Módulos obligatorios

1. **Recursos del servidor**
   - CPU, RAM, swap, disco por partición.
   - crecimiento de almacenamiento por día/semana/mes.

2. **Docker**
   - contenedores activos/detenidos.
   - health status y reinicios.
   - acción manual: subir proyecto Docker, validar compose, desplegar.

3. **Aplicaciones**
   - validación individual por app.
   - validación global del stack.
   - estado de puertos según política.

4. **Archivado inteligente**
   - cola de archivos a mover a tier_30d/tier_180d.
   - estado de compresión/cifrado.
   - ejecución manual y programada.

5. **Agentes**
   - historial de ejecuciones.
   - validaciones antes de implementar cambios.
   - resultados de autocorrección segura.

6. **Seguridad**
   - inventario de secretos (solo metadata).
   - estado de rotaciones.
   - auditoría de acciones admin.

## Restricción de acceso

- Solo rol `admin`.
- Toda acción sensible requiere confirmación explícita.
- Log inmutable de auditoría.

## Endpoints sugeridos (backend admin)

- `GET /admin/metrics/host`
- `GET /admin/metrics/docker`
- `GET /admin/apps/validation`
- `POST /admin/apps/validate`
- `POST /admin/apps/deploy`
- `POST /admin/archive/lifecycle/run`
- `GET /admin/archive/lifecycle/report`
- `GET /admin/agents/runs`
- `GET /admin/security/secrets-inventory`

