# AutoSkills Alignment (midudev/autoskills)

## Objetivo
Adoptar practicas de `autoskills` sin reemplazar el runtime actual ni romper MCP/conectores existentes.

## Practicas incorporadas
1. Seleccion curada de skills por contexto del proyecto.
2. Evitar instalacion directa desde fuentes no auditadas en runtime.
3. Verificacion de integridad por hash para artefactos de skills.
4. Registro lock de estado instalado (`skills-lock.json`).
5. Instalacion incremental: solo lo necesario para el stack activo.

## Politica para este repo
- `skills/*` sigue siendo source-of-truth local.
- `contracts/skills-contracts.json` define catalogo y metadata operativa.
- `skills-lock.json` registra estado de bundle para trazabilidad.
- Cualquier skill externa debe pasar por `ecosystem-curator` antes de adoptarse.

## Flujo recomendado de adopcion
1. Detectar necesidad por stack/problema.
2. Evaluar skill candidata (mantenimiento, seguridad, portabilidad).
3. Importar de forma curada (no directa en runtime productivo).
4. Validar manifests y contratos.
5. Registrar cambios en docs y lock.

## Referencia
- Repo base: https://github.com/midudev/autoskills
- Commit de referencia observado: `df77e04af1c608f4f829270ae720f4c6dd260112`
