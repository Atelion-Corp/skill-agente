---
name: design-3d
description: Guía para implementar elementos 3D interactivos en páginas web usando Three.js, React Three Fiber, o Spline. Usar cuando el usuario quiere efectos 3D, modelos, o escenas tridimensionales en su sitio.
license: MIT
---

# design-3d — Diseño Web con 3D

Workflow para integrar elementos 3D en páginas web: modelos GLTF, escenas Three.js, embeds de Spline, o React Three Fiber con efectos visuales avanzados.

## Cuándo usar

- "quiero un fondo 3d", "agrega un modelo 3d", "efecto 3d en el hero"
- "usa three.js", "react three fiber", "spline embed"
- Usuario quiere partículas 3D, terrain, objetos rotantes, product viewers

## Stacks disponibles

| Opción | Cuándo usar | Complejidad |
|--------|-------------|-------------|
| **Spline embed** | Modelo ya diseñado, solo embed | ★☆☆ |
| **Three.js vanilla** | Control total, no React | ★★☆ |
| **React Three Fiber (R3F)** | Proyecto React/Next.js | ★★★ |
| **CSS 3D transforms** | Efectos sutiles sin WebGL | ★☆☆ |

## Workflow

### 1. Intake

Preguntar:
- Stack del proyecto (React/Next.js vs vanilla)
- Tipo de 3D: modelo de producto, fondo abstracto, partículas, texto 3D, escena interactiva
- Fuente del modelo: Spline URL, archivo GLTF propio, generado en código
- Rendimiento objetivo: ¿mobile-first? ¿performance crítica?

### 2. Setup de dependencias

**React Three Fiber (R3F) — recomendado para Next.js:**
```bash
npm install three @react-three/fiber @react-three/drei
npm install -D @types/three
```

**Three.js vanilla:**
```bash
npm install three
npm install -D @types/three
```

**Spline (embed):**
```bash
npm install @splinetool/react-spline @splinetool/runtime
```

### 3. Implementación base

**R3F — Hero con modelo rotante:**
```tsx
'use client'
import { Canvas } from '@react-three/fiber'
import { OrbitControls, useGLTF, Float, Environment } from '@react-three/drei'
import { Suspense } from 'react'

function Model({ url }: { url: string }) {
  const { scene } = useGLTF(url)
  return <primitive object={scene} />
}

export function Hero3D() {
  return (
    <div className="h-screen w-full">
      <Canvas camera={{ position: [0, 0, 5], fov: 45 }}>
        <ambientLight intensity={0.5} />
        <directionalLight position={[10, 10, 5]} intensity={1} />
        <Environment preset="city" />
        <Suspense fallback={null}>
          <Float speed={1.5} rotationIntensity={0.5}>
            <Model url="/model.glb" />
          </Float>
        </Suspense>
        <OrbitControls enableZoom={false} />
      </Canvas>
    </div>
  )
}
```

**Spline embed (más simple):**
```tsx
'use client'
import Spline from '@splinetool/react-spline'

export function SplineHero() {
  return (
    <div className="h-screen w-full">
      <Spline scene="https://prod.spline.design/YOUR_SCENE_ID/scene.splinecode" />
    </div>
  )
}
```

### 4. Optimización de rendimiento

- `loading="lazy"` para Canvas fuera del viewport
- `dpr={[1, 1.5]}` en Canvas — limitar pixel ratio en mobile
- `frameloop="demand"` si la escena es estática
- Comprimir GLTF con `gltf-pipeline` o `glTF-Transform`
- Fallback imagen estática para dispositivos sin WebGL:
```tsx
const supportsWebGL = typeof window !== 'undefined' && !!window.WebGLRenderingContext
```

### 5. Accesibilidad y fallback

```tsx
<div aria-label="Visualización 3D decorativa" role="img">
  {supportsWebGL ? <Canvas>...</Canvas> : <img src="/hero-fallback.png" alt="Hero" />}
</div>
```

## Output

- Componente 3D funcional en el stack del proyecto
- Dependencias instaladas
- Fallback para mobile/no-WebGL
- Recomendación de assets (Sketchfab, Spline community, Poly Pizza)

## Fuentes de modelos gratuitos

- `sketchfab.com` — modelos GLTF/GLB con licencia
- `spline.design` — escenas interactivas sin código
- `polypizza.pizza` — low-poly gratuitos
- `market.pmnd.rs` — assets para R3F

## Notas

- Three.js + Next.js requiere `'use client'` en el componente Canvas
- `useGLTF` de Drei hace preload automático — llamar `useGLTF.preload('/model.glb')` fuera del componente
- Evitar escenas +5MB en mobile — usar LOD o versión simplificada
