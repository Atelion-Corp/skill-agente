# External references integrated

Last validated: 2026-04-28

## Included repos

1. https://github.com/heygen-com/hyperframes
- Multi-agent compatibility pattern via separate plugin manifests (`.claude-plugin`, `.codex-plugin`, `.cursor-plugin`).
- Agent-first workflow and deterministic output model for generated assets.

2. https://github.com/ras0q/obsidian-graph-banner
- Context-first graph UX pattern: small/local graph in header before full exploration.

3. https://github.com/natefrisch01/Graph-Link-Types
- Semantic link typing pattern (`related`, `depends_on`, etc.) for graph readability.

## How they were applied here
- Added Codex manifest: `.codex-plugin/plugin.json`.
- Added graph UX/semantics best practices in `bp/practices.json`.
- Updated `skills/design-graph/SKILL.md` with typed-link and contextual-banner guidance.
- Added release validation script: `scripts/validate-plugin.ps1`.