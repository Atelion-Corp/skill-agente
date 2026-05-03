# Modelo de Datos Operacional (sin secretos)

## Entidades recomendadas

### `projects`

- `id`
- `name`
- `repo_name`
- `environment` (`prod|dev|test`)
- `status`
- `created_at`
- `updated_at`

### `deployments`

- `id`
- `project_id`
- `version_ref`
- `started_at`
- `finished_at`
- `status`
- `rollback_executed`
- `operator`

### `validations`

- `id`
- `project_id`
- `scope` (`individual|global`)
- `severity_counts` (json)
- `status`
- `report_path`
- `created_at`

### `agent_runs`

- `id`
- `agent_name`
- `project_id`
- `action`
- `status`
- `duration_ms`
- `warnings_count`
- `created_at`

### `resource_snapshots`

- `id`
- `cpu_percent`
- `ram_percent`
- `disk_percent`
- `docker_containers_up`
- `created_at`

### `secret_inventory` (metadata only)

- `id`
- `project_id`
- `secret_key`
- `owner`
- `tenant`
- `rotation_days`
- `last_rotated_at`

No almacenar valores de secretos en esta base.

