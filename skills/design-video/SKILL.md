---
name: design-video
description: Guía para diseño web con video — backgrounds de video, players personalizados, video en hero, scroll-driven video. Usar cuando el proyecto usa video como elemento de diseño central.
license: MIT
---

# design-video — Diseño Web con Video

Workflow para integrar video en páginas web: background videos, players custom, hero con video, video controlado por scroll.

## Cuándo usar

- "video de fondo", "hero con video", "video en loop"
- "player de video custom", "video scroll-driven"
- "showreel", "demo video", "video en landing"

## Formatos y soporte

| Formato | Soporte | Uso |
|---------|---------|-----|
| **WebM** (VP9) | Chrome, Firefox, Edge | Mejor compresión |
| **MP4** (H.264) | Todos | Fallback universal |
| **AV1** | Moderno | Mejor calidad/peso |

Siempre proveer MP4 + WebM para máxima compatibilidad.

## Workflow

### 1. Intake

Preguntar:
- Tipo: background loop, hero con audio, player custom, scroll-driven
- Fuente: archivo propio, YouTube/Vimeo embed, CDN
- Mobile: ¿mostrar video en mobile o imagen fallback?
- Autoplay: ¿sí? (requiere `muted`)

### 2. Video background en hero

```tsx
export function VideoHero() {
  return (
    <section className="relative h-screen overflow-hidden">
      <video
        autoPlay
        muted
        loop
        playsInline
        className="absolute inset-0 h-full w-full object-cover"
      >
        <source src="/hero.webm" type="video/webm" />
        <source src="/hero.mp4" type="video/mp4" />
      </video>
      {/* Overlay */}
      <div className="absolute inset-0 bg-black/50" />
      {/* Contenido */}
      <div className="relative z-10 flex h-full items-center justify-center">
        <h1 className="text-white text-5xl font-bold">Tu mensaje aquí</h1>
      </div>
    </section>
  )
}
```

### 3. Fallback para mobile (ahorro de datos)

```tsx
'use client'
import { useEffect, useState } from 'react'
import Image from 'next/image'

export function VideoHeroAdaptive() {
  const [isMobile, setIsMobile] = useState(false)

  useEffect(() => {
    setIsMobile(window.innerWidth < 768)
  }, [])

  if (isMobile) {
    return <Image src="/hero-fallback.jpg" alt="Hero" fill className="object-cover" />
  }

  return (
    <video autoPlay muted loop playsInline className="absolute inset-0 h-full w-full object-cover">
      <source src="/hero.webm" type="video/webm" />
      <source src="/hero.mp4" type="video/mp4" />
    </video>
  )
}
```

### 4. Player custom con controles

```bash
npm install react-player   # YouTube, Vimeo, archivos locales
```

```tsx
import ReactPlayer from 'react-player/lazy'

export function CustomPlayer({ url }: { url: string }) {
  return (
    <div className="aspect-video w-full overflow-hidden rounded-xl shadow-2xl">
      <ReactPlayer
        url={url}
        width="100%"
        height="100%"
        controls
        light  // thumbnail preview, carga player al click
        playsinline
      />
    </div>
  )
}
```

### 5. Video scroll-driven (avanza con scroll)

```tsx
'use client'
import { useEffect, useRef } from 'react'

export function ScrollVideo({ src }: { src: string }) {
  const videoRef = useRef<HTMLVideoElement>(null)

  useEffect(() => {
    const video = videoRef.current
    if (!video) return

    const handleScroll = () => {
      const scrolled = window.scrollY
      const maxScroll = document.body.scrollHeight - window.innerHeight
      const progress = scrolled / maxScroll
      video.currentTime = progress * video.duration
    }

    video.addEventListener('loadedmetadata', () => {
      window.addEventListener('scroll', handleScroll)
    })
    return () => window.removeEventListener('scroll', handleScroll)
  }, [])

  return (
    <video
      ref={videoRef}
      muted
      playsInline
      className="sticky top-0 h-screen w-full object-cover"
      src={src}
    />
  )
}
```

### 6. Optimización de video

```bash
# Comprimir MP4 con ffmpeg
ffmpeg -i input.mp4 -vcodec h264 -acodec aac -crf 23 -preset slow output.mp4

# Convertir a WebM
ffmpeg -i input.mp4 -c:v libvpx-vp9 -crf 33 -b:v 0 output.webm

# Sin audio (background loop)
ffmpeg -i input.mp4 -an -vcodec h264 -crf 23 output-no-audio.mp4
```

Tamaño objetivo para background video: &lt;5MB, 15–30 segundos de loop.

## Output

- Componente de video funcional (hero / player / scroll-driven)
- Fallback para mobile
- Instrucciones de compresión con ffmpeg

## Notas

- `autoPlay` solo funciona con `muted` en browsers modernos
- `playsInline` obligatorio para iOS
- Video background: preferir loops cortos (5–15s), sin audio
- Alojar en CDN propio o Cloudflare Stream — YouTube/Vimeo tienen delay de carga
