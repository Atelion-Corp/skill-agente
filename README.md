# skill-agente

![Orchestrator](https://img.shields.io/badge/Orchestrator-Multi--Agent-0F172A?style=for-the-badge)
![Design](https://img.shields.io/badge/Area-Design-2563EB?style=for-the-badge)
![Marketing](https://img.shields.io/badge/Area-Marketing-16A34A?style=for-the-badge)
![Runtime](https://img.shields.io/badge/Runtime-OpenClaw%20First-9333EA?style=for-the-badge)

Plugin de skills multi-agente para Claude, Codex y OpenClaw-first runtimes.

## Flujograma Visual
```text
Usuario -> super-orquestador -> (area-design / area-mkt / dev-pipeline) -> resultado-save
```

## Normas Duras
- API base oficial: `/api/v1/`.
- Prohibido `/api/vq/`.
- Puertos canonicos no se alteran sin aprobacion tecnica.
- Credenciales siempre enmascaradas en documentacion.
