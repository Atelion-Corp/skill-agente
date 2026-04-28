---
name: design-graph
description: Implement interactive 3D knowledge graphs with neuron-like connections — Obsidian-style force-directed visualization using react-force-graph-3d, d3-force-3d, or Three.js. Use when user wants to visualize relationships, knowledge maps, neuron networks, node connections in 3D, documentation graphs, or activity connection maps.
license: MIT
---

# design-graph — 3D Neuron Graph (Obsidian-style)

Grafos interactivos 3D con conexiones tipo neuronas. Inspirado en Graph View de Obsidian y patrones de:
- `ras0q/obsidian-graph-banner` (graph contextual en cabecera)
- `natefrisch01/Graph-Link-Types` (tipado semántico de links)

## Cuándo usar

- "grafo de conocimiento", "nodos y conexiones", "tipo Obsidian"
- "red neuronal visual", "mapa conceptual 3D", "grafo de actividades"
- "force-directed graph", "conexiones interactivas", "documentación en grafo"

## Stack recomendado

| Caso | Librería |
|------|----------|
| React (rápido) | `react-force-graph-3d` |
| React (control total) | `@react-three/fiber` + `d3-force-3d` |
| >1K nodos | `react-force-graph-3d` con WebGL (default) |
| 2D ligero | `react-force-graph-2d` |

```bash
npm install react-force-graph-3d
```

## Implementación base

```tsx
import ForceGraph3D from 'react-force-graph-3d'
import { useRef, useEffect } from 'react'

interface Node { id: string; name: string; group?: string; val?: number }
interface Link { source: string; target: string; value?: number }

const data = {
  nodes: [
    { id: 'n1', name: 'Diseño', group: 'core', val: 8 },
    { id: 'n2', name: 'Anime.js', group: 'tool', val: 4 },
    { id: 'n3', name: 'Three.js', group: 'tool', val: 5 },
    { id: 'n4', name: 'Componentes', group: 'doc', val: 3 },
  ],
  links: [
    { source: 'n1', target: 'n2' },
    { source: 'n1', target: 'n3' },
    { source: 'n1', target: 'n4' },
  ]
}

export function NeuronGraph() {
  const fgRef = useRef<any>()

  useEffect(() => {
    fgRef.current?.cameraPosition({ x: 0, y: 0, z: 300 })
  }, [])

  return (
    <ForceGraph3D
      ref={fgRef}
      graphData={data}
      backgroundColor="#0a0a0a"
      nodeVal={node => (node as Node).val ?? 3}
      nodeColor={node => {
        const n = node as Node
        const colors: Record<string, string> = {
          core: '#7c3aed', tool: '#4ade80', doc: '#0ea5e9', tag: '#f59e0b'
        }
        return colors[n.group ?? 'doc'] ?? '#888'
      }}
      nodeLabel={(node) => (node as Node).name}
      nodeOpacity={0.9}
      linkColor={() => 'rgba(255,255,255,0.15)'}
      linkWidth={link => ((link as Link).value ?? 1) * 0.5}
      linkOpacity={0.5}
      onNodeClick={(node) => {
        const n = node as any
        fgRef.current?.cameraPosition(
          { x: n.x, y: n.y, z: n.z + 80 }, node, 1000
        )
      }}
      d3AlphaDecay={0.02}
      d3VelocityDecay={0.3}
    />
  )
}
```

## Physics tipo Obsidian

```tsx
useEffect(() => {
  const fg = fgRef.current
  if (!fg) return
  fg.d3Force('charge').strength(-120)   // repulsión entre nodos
  fg.d3Force('link').distance(60)        // distancia de links
  fg.d3Force('center').strength(0.05)    // fuerza hacia centro
}, [])
```

## Tipado semántico de enlaces (Graph-Link-Types pattern)

Al construir los links, incluir `linkType` (ej: `related`, `depends_on`, `blocks`) y mapear color/label por tipo.

```ts
const LINK_COLORS: Record<string, string> = {
  related: '#60a5fa',
  depends_on: '#f59e0b',
  blocks: '#ef4444'
}
```

## Nodos custom (glow neuronal)

```tsx
import * as THREE from 'three'

nodeThreeObject={(node) => {
  const n = node as Node
  const size = Math.sqrt(n.val ?? 3) * 2
  const sphere = new THREE.Mesh(
    new THREE.SphereGeometry(size),
    new THREE.MeshPhongMaterial({
      color: n.group === 'core' ? 0x7c3aed : 0x4ade80,
      emissive: n.group === 'core' ? 0x3b0764 : 0x14532d,
      shininess: 100,
      transparent: true,
      opacity: 0.9
    })
  )
  return sphere
}}
```

## Colores por tipo de nodo

```ts
const NODE_COLORS = {
  doc:     '#7c3aed',  // violeta — documentos/skills
  tag:     '#0ea5e9',  // azul — etiquetas/categorías
  project: '#f59e0b',  // ámbar — proyectos
  task:    '#4ade80',  // verde — tareas/actividades
  core:    '#ef4444',  // rojo — nodo central
}
```

## Construir grafo desde datos propios

```ts
// Documentación/actividades como neuronas
interface DocNode {
  id: string
  name: string
  type: 'doc' | 'tag' | 'project' | 'task'
  backlinks: number  // → tamaño del nodo
}

function buildGraph(docs: DocNode[], links: {from: string, to: string}[]) {
  return {
    nodes: docs.map(d => ({
      id: d.id,
      name: d.name,
      group: d.type,
      val: Math.max(2, d.backlinks)
    })),
    links: links.map(l => ({ source: l.from, target: l.to }))
  }
}
```

## Sidebar de info del nodo (patrón Obsidian)

```tsx
const [selected, setSelected] = useState<Node | null>(null)

onNodeClick={(node) => setSelected(node as Node)}

// Sidebar:
{selected && (
  <div className="absolute right-0 top-0 w-72 bg-zinc-900 p-4 h-full">
    <h2 className="text-white font-bold">{selected.name}</h2>
    <p className="text-zinc-400 text-sm">{selected.group}</p>
  </div>
)}
```

## Banner contextual (obsidian-graph-banner pattern)

Para documentación o dashboards, agregar mini-grafo en cabecera (2D o snapshot) y expandir a 3D al interactuar. Esto mejora orientación sin saturar la vista principal.

## Alternativa 2D (simple)

```bash
npm install react-force-graph-2d  # mismo API, sin WebGL, para ≤500 nodos
```

## Performance

- `react-force-graph-3d` usa WebGL por default → soporta miles de nodos
- Para SSR (Next.js): import dinámico con `ssr: false`

```tsx
const ForceGraph3D = dynamic(() => import('react-force-graph-3d'), { ssr: false })
```
