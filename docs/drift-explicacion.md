# Qué significa "drift de arquitectura"

Cuando dije "drift" me refiero a que proyectos parecidos se despliegan con diferencias no controladas, por ejemplo:

- puertos distintos sin regla global
- políticas de restart distintas
- imágenes/base tags distintas
- servicios expuestos en un proyecto y cerrados en otro
- salud/healthchecks presentes en uno y ausentes en otro

## Por qué importa

- sube el riesgo de incidentes
- dificulta soporte operativo
- complica escalar nuevas apps
- hace más lento auditar seguridad

## Solución profesional

1. Definir una plantilla base de `docker-compose.prod.yml`.
2. Aplicar reglas centralizadas (puertos, healthchecks, logs, restart).
3. Validar en CI antes de deploy.
4. Permitir excepciones solo documentadas.

