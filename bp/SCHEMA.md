---
name: bp-schema
type: reference
---

# Best Practices DB — Schema

Referencia del esquema de `practices.json`.

## Estructura

```json
{
  "v": 1,
  "areas": { "<código>": "<nombre>" },
  "sub_areas": { "<área>": ["<sa1>", "<sa2>"] },
  "practices": [ { ...BP } ]
}
```

## Registro BP

```json
{
  "id": "BP-{AREA}-{NNN}",
  "a": "<área>",
  "sa": "<sub_area>",
  "rule": "<regla compacta ≤120 chars>",
  "why": "<razón ≤150 chars>",
  "tags": ["<TAG1>", "<TAG2>"]
}
```

## Áreas

| Código | Área |
|--------|------|
| `D` | Diseño |
| `M` | Marketing |
| `V` | Dev |
| `A` | Auto |
| `T` | Testing |
| `DA` | Datos |
| `F` | Finanzas |
| `S` | Skills |
| `*` | Global (aplica a todas) |

## Sub-áreas Diseño

| Código | Significado |
|--------|-------------|
| `UI` | UI general |
| `3D` | Three.js / R3F / Spline |
| `ANI` | Anime.js / animaciones |
| `GAL` | Imágenes / galería |
| `VID` | Video |
| `GRF` | Grafo 3D neuronal |
| `SCR` | Scroll / Lenis / GSAP |
| `RMT` | Remotion |
| `EDT` | Editores texto |

## Sub-áreas Marketing

| Código | Significado |
|--------|-------------|
| `CPY` | Copywriting |
| `SEO` | SEO / GEO |
| `CRO` | Conversión |
| `GRW` | Growth / retención |
| `STR` | Estrategia |

## Tags comunes

`UI`, `TYPO`, `COLOR`, `ANI`, `PERF`, `UX`, `GRF`, `SCR`, `3D`, `RMT`, `EDT`,
`CPY`, `SEO`, `GEO`, `CRO`, `GRW`, `REF`, `CTX`, `ARCH`, `DX`, `SEESAW`

## Búsqueda rápida

```
Por área:    practices.filter(p => p.a === 'D')
Por sub:     practices.filter(p => p.sa === 'ANI')
Por tags:    practices.filter(p => p.tags.includes('PERF'))
Por ID:      practices.find(p => p.id === 'BP-D-004')
```

## Convención de IDs

```
BP-{AREA}-{NNN}   → área específica
BP-C-{NNN}        → contexto/arquitectura (global)
```

## Agregar nueva práctica

1. Incrementar NNN del área
2. Verificar que no existe una regla similar (evitar duplicados)
3. `rule` ≤120 chars, `why` ≤150 chars
4. Tags: mínimo 1 funcional + 1 de área
