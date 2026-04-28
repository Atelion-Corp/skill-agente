# External references integrated

Last validated: 2026-04-28

## Included repos

0. https://github.com/anthropics
- Referencia de skills oficiales y prácticas de estructura SKILL.md.

0. https://github.com/openai
- Referencia de skills oficiales y compatibilidad con workflows modernos de agentes.

1. https://github.com/heygen-com/hyperframes
- Multi-agent compatibility pattern via separate plugin manifests (`.claude-plugin`, `.codex-plugin`, `.cursor-plugin`).
- Agent-first workflow and deterministic output model for generated assets.

2. https://github.com/ras0q/obsidian-graph-banner
- Context-first graph UX pattern: small/local graph in header before full exploration.

3. https://github.com/natefrisch01/Graph-Link-Types
- Semantic link typing pattern (`related`, `depends_on`, etc.) for graph readability.

4. https://github.com/VoltAgent/awesome-agent-skills
- Catálogo curado multi-runtime para acelerar discovery de skills de calidad.

5. https://github.com/awesome-opencode/awesome-opencode
- Referencias enfocadas en OpenCode y tooling compatible.

6. https://github.com/leonxlnx/taste-skill
- Patrón de "taste"/criterio para elevar consistencia de decisiones de diseño.

7. https://github.com/froala/design-blocks
- Bloques UI reutilizables como insumo para prototipos rápidos.

## How they were applied here
- Added Codex manifest: `.codex-plugin/plugin.json`.
- Added graph UX/semantics best practices in `bp/practices.json`.
- Updated `skills/design-graph/SKILL.md` with typed-link and contextual-banner guidance.
- Added release validation script: `scripts/validate-plugin.ps1`.
- Added ecosystem curation skill: `skills/ecosystem-curator/SKILL.md`.
- Added Tailwind UI discovery skill: `skills/tailwind-ui-hunter/SKILL.md`.
