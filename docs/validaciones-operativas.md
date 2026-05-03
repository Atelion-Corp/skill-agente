# Validaciones Operativas: Individuales y Globales

## A. Validación individual por aplicación

### Entrada

- ruta de app
- entorno (`prod|dev|test`)
- política de puertos
- baseline de estructura

### Reglas

1. Existen archivos base:
   - `docker-compose.yml`
   - `docker-compose.prod.yml` (para prod)
   - `.env.example`
2. Backend/Frontend detectables.
3. Variables críticas presentes en `.env.example`.
4. Exposición de puertos acorde al entorno.
5. `restart` policy correcta.
6. Healthcheck disponible para servicios críticos.

### Salida

- `status`: pass/fail
- `findings`: lista con severidad
- `autofix`: cambios seguros aplicables
- `risk_score`: 0-100

---

## B. Validación global del stack

### Reglas

1. Docker Engine y Compose operativos.
2. Contenedores críticos levantados.
3. Política de puertos cumplida globalmente.
4. Recursos host dentro de umbrales.
5. Monitoreo y logging activos.
6. Backups recientes disponibles.

### Umbrales sugeridos

- CPU promedio 5m < 80%
- RAM usada < 85%
- Disco `/` < 80%
- restart loops = 0 en prod

---

## C. Frecuencias

- por deploy: validación individual + global
- cada 15 min: health y recursos
- diario: auditoría dev/test + archivado
- semanal: drift arquitectónico y cumplimiento baseline

---

## D. Evidencias

Guardar en:

- `proyecto_resultado_skill/proyectos/<project_id>/`
- reportes JSON por corrida
- logs de contexto IA (`ai-context-log.jsonl`)

