# AGENTS.md

## 1) Proposito del repositorio
Este repositorio (skill_agente) forma parte del ecosistema interno de Atelion. Este contexto aplica para Claude Code, Codex y OpenCode.

## 2) Estandar tecnico y de arquitectura
La documentacion tecnica debe mantener lenguaje profesional interno, trazabilidad de cambios y secciones explicativas de codigo, procesos y flujos de datos.

## 3) Normas duras de API y puertos
La ruta base oficial es /api/.
No se permite usar /api/v1/ ni otros versionados en la ruta base.
No cambiar puertos canonicos sin aprobacion tecnica explicita y registro en documentacion.

## 4) Regla de despliegue y proxy
Para produccion, usar Nginx principal en host/servidor y enrutar por dominio hacia puertos de contenedores.
No duplicar Nginx dentro de cada proyecto para publicacion principal, salvo excepcion aprobada.

## 5) Seguridad de datos y credenciales
Nunca exponer credenciales, tokens, secretos o llaves en codigo, docs, logs o ejemplos.
Las URLs de servicio pueden documentarse cuando sea necesario para operacion.
Usar placeholders para secretos (<SECRET>, <TOKEN>, <PASSWORD>).

## 6) Estandar de documentacion
Cada documento principal debe incluir:
Resumen ejecutivo, stack visual, flujo de datos/procesos, guia paso a paso de despliegue, checklist operativo y seccion de seguridad.

## 7) Convencion de naming de repos
Repos desplegables en Colossus usan prefijo server-<producto>.
Repos poc-* son pruebas temporales y, al validarse, deben migrar a un nuevo repo server-<proyecto>.

## 8) Flujo de trabajo para agentes IA
Antes de cambiar codigo o infraestructura, validar impacto en API, puertos, seguridad y despliegue.
Registrar cambios relevantes en README/runbook/contexto para mantener continuidad operativa.

## 9) Definicion de terminado
Un cambio se considera completo cuando: implementacion aplicada, documentacion alineada, validacion basica ejecutada y normas duras respetadas.
