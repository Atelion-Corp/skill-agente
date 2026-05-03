# Arquitectura Técnica de Plataforma Privada de Agentes IA

## 1) Objetivo y principios

Arquitectura para operar múltiples aplicaciones y agentes IA en servidor privado con:

- aislamiento por tenant/cliente
- seguridad por defecto (least privilege)
- observabilidad completa
- despliegue reproducible
- trazabilidad operativa sin exponer credenciales

Principios:

1. Runtime único para agentes (OpenClaw-first).
2. Configuración declarativa (Docker Compose + contratos + políticas).
3. Separación clara entre producción y dev/test.
4. Todo cambio validado antes/después del deploy.

---

## 2) Capas arquitectónicas

### Control Plane

- Panel privado web.
- Gestión de proyectos, agentes, despliegues y validaciones.
- Control de acceso RBAC.
- Historial y auditoría de acciones.

### Execution Plane

- OpenClaw para orquestación y ejecución de agentes.
- Skills versionadas (`skills/*/SKILL.md`).
- Validadores automáticos (estructura, seguridad, puertos, health).

### Data Plane

- Base de plataforma (PostgreSQL recomendado) para:
  - inventario de apps
  - historial de despliegues
  - auditoría de ejecuciones
  - eventos de monitoreo
- Bases de negocio por app/tenant (idealmente separadas por schema o DB).

### Observability Plane

- Métricas: Prometheus + Node Exporter + cAdvisor.
- Logs: Loki + Promtail.
- Visualización: Grafana.
- Alertas operativas (CPU, RAM, disco, restart loops, errores 5xx).

---

## 3) Relación entre aplicaciones, Docker y bases de datos

### Patrón de aplicación desplegada

Cada app productiva debe tener:

- `docker-compose.prod.yml`
- `backend` (API)
- `frontend` (UI)
- `db` (PostgreSQL de app o endpoint externo)
- `redis` (cache/colas, no expuesto públicamente)
- `proxy` (nginx/traefik/caddy) cuando aplique

### Relación de datos

1. **DB de plataforma** (central):
   - metadatos de operación de agentes/plataforma
   - no almacenar secretos en texto plano
2. **DBs de aplicaciones**:
   - datos de negocio por app/tenant
3. **Secret Manager**:
   - valores de secretos (fuera de git y fuera de docs)

### Interconexión

- Contenedores por red Docker privada.
- Exposición externa mínima:
  - `80/443` para ingreso web
  - `22` restringido por IP/VPN/Tunnel
- DB/Redis internos sin exposición pública.

---

## 4) Políticas operativas obligatorias

### Puertos

- Prod: 3000, 3002, 3004...
- Dev/Test: 4000, 4002, 4004...
- Selección automática del menor puerto libre.

### Ciclo dev/test

- Apagado diario programado.
- Archivo de logs y snapshot antes de `down`.
- Reanudación posterior en el menor puerto libre.

### Seguridad

- Inventario de secretos sin valores.
- Rotación periódica por criticidad.
- RBAC por rol y por tenant.
- Auditoría de acciones administrativas.

### Nomenclatura recomendada de apps

- `server-<nombre-repo-github>` para producción.
- mantener un solo proyecto prod activo por dominio funcional.

---

## 5) Validaciones técnicas

### Validación individual por app

Checks mínimos:

1. Estructura esperada (`backend/frontend/docs/compose`).
2. `.env.example` con variables requeridas.
3. `docker-compose.prod.yml` con políticas de restart y exposición mínima.
4. healthchecks de servicios críticos.
5. rutas de logs y persistencia de datos.

### Validación global del servidor

Checks mínimos:

1. Estado Docker y contenedores.
2. Puertos escuchando vs política.
3. Recursos host (CPU/RAM/disco/swap).
4. Integridad de rutas `/opt/apps` y backups.
5. stack de monitoreo activo.

---

## 6) UI/UX visual de operación

### Vistas del panel

1. **Resumen servidor**:
   - CPU, RAM, disco, swap
   - procesos clave y uptime
2. **Docker**:
   - contenedores activos
   - reinicios recientes
   - health status
3. **Aplicaciones**:
   - estado por app (prod/dev/test)
   - puertos asignados
   - versión desplegada
4. **Validaciones**:
   - resultados por app
   - findings críticos/medios/bajos
5. **Logs y auditoría**:
   - búsqueda por app/fecha/severidad
6. **Recursos de almacenamiento**:
   - uso por volumen/carpeta
   - crecimiento por período

---

## 7) Gobernanza de cambios

Pipeline recomendado:

1. Backup local + backup remoto.
2. Validación pre-deploy.
3. Deploy controlado.
4. Smoke tests.
5. Validación post-deploy.
6. Rollback automático si falla health gate.

Ningún cambio de configuración crítica debe ejecutarse sin aprobación explícita.

