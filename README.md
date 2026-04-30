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
- API base oficial: `/v1/`.
- Prohibido cualquier prefijo `/api`.
- Puertos canonicos no se alteran sin aprobacion tecnica.
- Credenciales siempre enmascaradas en documentacion.


## Regla Operativa De Puertos
- No improvisar puertos ni cambiar secuencias definidas.
- Mantener puertos establecidos por proyecto y entorno.
- Cualquier cambio requiere aprobacion tecnica explicita.

## Regla De Proxy
- Nginx principal corre en el servidor (host), no dentro de Docker para publicacion principal.
- El servidor redirige dominios a puertos Docker segun servicio.

