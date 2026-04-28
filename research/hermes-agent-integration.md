# Hermes Agent Integration

Source used: https://github.com/NousResearch/hermes-agent
Validated date: 2026-04-28

## Adopted patterns

1. Closed-loop improvement: plan -> run -> review -> learn -> update.
2. Persistent operational memory for cross-session continuity.
3. Runtime-agnostic behavior for CLI and messaging-style agents.
4. Safe iteration rules: small reversible changes + validation gates.

## Applied in skill_agente

- New skill: `skills/hermes-agent-loop/SKILL.md`.
- Manifest sync: `.claude-plugin/plugin.json` + `.codex-plugin/plugin.json`.
- Version bump to `1.4.0`.
- Automation script: `scripts/hermes-autoupgrade.ps1`.
- Persistent state/log location:
  - `proyecto_resultado_skill/proyectos/<project_id>/hermes-loop-state.json`
  - `proyecto_resultado_skill/proyectos/<project_id>/hermes-loop-log.md`
