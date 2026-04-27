---
name: design-remotion
description: Create programmatic video, motion graphics, and animated content with Remotion (React-based video framework). Use when user wants to generate videos with code, create animated product demos, data visualization videos, branded motion graphics, or embed animated players in web.
license: MIT
---

# design-remotion — Remotion Video Programático

Videos y motion graphics con React/Remotion. Exporta MP4, GIF, o embede como player web.

## Cuándo usar

- "video programático", "motion graphics con código"
- "exportar como MP4/GIF", "demo animado del producto"
- "presentación animada", "branded video template"
- "video de datos / animación de métricas"

## Setup

```bash
npx create-video@latest
# o en proyecto existente:
npm install remotion @remotion/player @remotion/cli
```

## Conceptos clave

| Concepto | Descripción |
|----------|-------------|
| `fps` | Frames por segundo (default 30) |
| `durationInFrames` | Total frames |
| `frame` | Frame actual (0 a durationInFrames-1) |
| `interpolate()` | Mapea frame → valor |
| `spring()` | Animación con física spring |
| `Sequence` | Activa componente desde frame X |

## Componente base

```tsx
import { AbsoluteFill, useCurrentFrame, useVideoConfig, interpolate, spring } from 'remotion'

export function HeroVideo() {
  const frame = useCurrentFrame()
  const { fps } = useVideoConfig()

  const opacity = interpolate(frame, [0, 30], [0, 1], { extrapolateRight: 'clamp' })
  const scale = spring({ frame, fps, config: { damping: 10, stiffness: 80 } })

  return (
    <AbsoluteFill style={{ background: '#0a0a0a', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
      <h1 style={{ color: 'white', fontSize: 72, opacity, transform: `scale(${scale})` }}>
        Mi Producto
      </h1>
    </AbsoluteFill>
  )
}
```

## Registro

```tsx
// Root.tsx
import { Composition } from 'remotion'
import { HeroVideo } from './HeroVideo'

export const RemotionRoot = () => (
  <Composition
    id="HeroVideo"
    component={HeroVideo}
    durationInFrames={150}   // 5 seg a 30fps
    fps={30}
    width={1920}
    height={1080}
  />
)
```

## Secuencias (timeline)

```tsx
import { Sequence, AbsoluteFill } from 'remotion'

export function ProductDemo() {
  return (
    <AbsoluteFill>
      <Sequence from={0} durationInFrames={60}><LogoScene /></Sequence>
      <Sequence from={30} durationInFrames={90}><FeaturesScene /></Sequence>
      <Sequence from={100} durationInFrames={50}><CTAScene /></Sequence>
    </AbsoluteFill>
  )
}
```

## Texto animado carácter por carácter

```tsx
import { interpolate, useCurrentFrame } from 'remotion'

function AnimatedText({ text, startFrame }: { text: string; startFrame: number }) {
  const frame = useCurrentFrame()

  return (
    <div style={{ display: 'flex' }}>
      {text.split('').map((char, i) => {
        const f = startFrame + i * 2
        const opacity = interpolate(frame, [f, f + 10], [0, 1], {
          extrapolateLeft: 'clamp', extrapolateRight: 'clamp'
        })
        const y = interpolate(frame, [f, f + 10], [20, 0], {
          extrapolateLeft: 'clamp', extrapolateRight: 'clamp'
        })
        return (
          <span key={i} style={{ opacity, transform: `translateY(${y}px)`, display: 'inline-block' }}>
            {char === ' ' ? ' ' : char}
          </span>
        )
      })}
    </div>
  )
}
```

## Interpolaciones comunes

```tsx
// Fade in 0→30
const opacity = interpolate(frame, [0, 30], [0, 1], { extrapolateRight: 'clamp' })

// Slide up
const y = interpolate(frame, [0, 30], [50, 0], { extrapolateRight: 'clamp' })

// Zoom out (logo reveal)
const scale = interpolate(frame, [0, 60], [1.3, 1], { extrapolateRight: 'clamp' })

// Progress bar (toda la duración)
const { durationInFrames } = useVideoConfig()
const progress = interpolate(frame, [0, durationInFrames], [0, 100])
```

## Exportar

```bash
# Preview en browser
npx remotion studio

# MP4
npx remotion render HeroVideo out/video.mp4

# GIF (requiere ffmpeg)
npx remotion render HeroVideo out/video.gif --codec=gif

# Imagen (frame específico)
npx remotion still HeroVideo --frame=30 out/frame.png
```

## Player embebido en web

```tsx
import { Player } from '@remotion/player'
import { HeroVideo } from './HeroVideo'

export function VideoPlayer() {
  return (
    <Player
      component={HeroVideo}
      durationInFrames={150}
      fps={30}
      compositionWidth={1920}
      compositionHeight={1080}
      style={{ width: '100%' }}
      controls
      autoPlay
      loop
    />
  )
}
```

## Formatos de video recomendados

| Uso | Formato | Comando |
|-----|---------|---------|
| Web/social | MP4 H.264 | `--codec=h264` (default) |
| Transparencia | WebM VP8 | `--codec=vp8` |
| GIF animado | GIF | `--codec=gif` |
| Alta calidad | ProRes | `--codec=prores` |
