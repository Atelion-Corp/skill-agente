# Contributing

## Branching
- Usar ramas cortas por cambio.
- Commits atómicos y mensajes claros.

## Quality Gate
Antes de PR ejecutar:

```powershell
pwsh -File scripts/validate-plugin.ps1
```

## Scope
- No romper compatibilidad entre manifiestos (`.claude-plugin` y `.codex-plugin`).
- Si agregas un skill, decláralo en ambos manifiestos.