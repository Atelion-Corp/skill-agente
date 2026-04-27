---
name: design-premium
description: Guía para diseño web premium/luxury — alta estética, animaciones sofisticadas, tipografía custom, scroll storytelling. Usar cuando el cliente ofrece producto/servicio de lujo o alto valor percibido.
license: MIT
---

# design-premium — Diseño Premium / Luxury

Workflow para páginas de lujo: experiencias visuales de alto impacto, animaciones fluidas, tipografía editorial, paleta refinada, scroll storytelling.

## Cuándo usar

- "diseño luxury", "premium", "alto impacto", "experiencia visual"
- "marca de lujo", "producto premium", "agencia creativa de alto nivel"
- Cliente vende bienes de lujo, inmuebles premium, servicios exclusivos, moda

## Identidad del tier

| Atributo | Premium |
|----------|---------|
| Paleta | Negro, crema/off-white, dorado/champagne, blanco puro |
| Tipografía | Display serif editorial (Cormorant Garamond, Didact Gothic, GT Sectra) |
| Layout | Asimétrico, mucho whitespace, texto + imagen en tensión visual |
| Animaciones | Framer Motion — reveals suaves, parallax, hover magnético |
| Imágenes | Full-bleed, alta resolución, art-directed, B&W + color selectivo |
| Componentes | No cards genéricas — secciones únicas, narrativa visual |

## Workflow

### 1. Intake

Preguntar:
- Producto/servicio: qué vende y a quién
- Referencias: 2–3 sitios de inspiración
- Paleta de marca o libertad total
- ¿Hay assets: fotos profesionales, video? (Si no, recomendar unsplash premium o pexels)

### 2. Dependencias

```bash
npm install framer-motion
npm install @studio-freight/lenis  # smooth scroll premium
npm install gsap  # opcional para animaciones complejas
```

### 3. Smooth scroll con Lenis

```tsx
// src/components/layout/SmoothScroll.tsx
'use client'
import { useEffect } from 'react'
import Lenis from '@studio-freight/lenis'

export function SmoothScroll({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    const lenis = new Lenis({ lerp: 0.07, smoothWheel: true })
    function raf(time: number) { lenis.raf(time); requestAnimationFrame(raf) }
    requestAnimationFrame(raf)
    return () => lenis.destroy()
  }, [])
  return <>{children}</>
}
```

### 4. Hero premium con reveal

```tsx
'use client'
import { motion } from 'framer-motion'

export function PremiumHero() {
  return (
    <section className="relative h-screen bg-black flex items-end pb-20">
      {/* Background image */}
      <div className="absolute inset-0">
        <img src="/hero.jpg" className="h-full w-full object-cover opacity-60" alt="" />
      </div>
      {/* Content */}
      <div className="relative z-10 container mx-auto px-8">
        <motion.p
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.8 }}
          className="text-white/60 text-xs tracking-[0.3em] uppercase mb-4"
        >
          Colección 2025
        </motion.p>
        <motion.h1
          initial={{ opacity: 0, y: 40 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 1, delay: 0.2 }}
          className="font-serif text-7xl text-white leading-none"
        >
          El Arte de<br />lo Esencial
        </motion.h1>
      </div>
    </section>
  )
}
```

### 5. Parallax scroll section

```tsx
'use client'
import { useScroll, useTransform, motion } from 'framer-motion'
import { useRef } from 'react'

export function ParallaxSection() {
  const ref = useRef(null)
  const { scrollYProgress } = useScroll({ target: ref, offset: ['start end', 'end start'] })
  const y = useTransform(scrollYProgress, [0, 1], ['-20%', '20%'])

  return (
    <section ref={ref} className="relative h-screen overflow-hidden">
      <motion.div style={{ y }} className="absolute inset-0 scale-110">
        <img src="/section-bg.jpg" className="h-full w-full object-cover" alt="" />
      </motion.div>
      <div className="relative z-10 flex h-full items-center justify-center">
        <h2 className="font-serif text-5xl text-white text-center">Crafted with Intent</h2>
      </div>
    </section>
  )
}
```

### 6. Cursor magnético (diferenciador premium)

```tsx
'use client'
import { useEffect, useRef } from 'react'

export function MagneticButton({ children }: { children: React.ReactNode }) {
  const ref = useRef<HTMLButtonElement>(null)

  useEffect(() => {
    const el = ref.current
    if (!el) return
    const handleMove = (e: MouseEvent) => {
      const { left, top, width, height } = el.getBoundingClientRect()
      const x = (e.clientX - left - width / 2) * 0.3
      const y = (e.clientY - top - height / 2) * 0.3
      el.style.transform = `translate(${x}px, ${y}px)`
    }
    const reset = () => { el.style.transform = '' }
    el.addEventListener('mousemove', handleMove)
    el.addEventListener('mouseleave', reset)
    return () => { el.removeEventListener('mousemove', handleMove); el.removeEventListener('mouseleave', reset) }
  }, [])

  return (
    <button ref={ref} className="px-8 py-4 border border-white text-white text-sm tracking-widest uppercase transition-colors hover:bg-white hover:text-black">
      {children}
    </button>
  )
}
```

## Output

- Componentes premium: Hero, Parallax, Smooth scroll, Cursor magnético
- Paleta y tokens de diseño luxury
- Dependencias instaladas (Framer Motion, Lenis)

## Notas

- Rendimiento: Framer Motion tiene buen tree-shaking — importar solo lo usado
- Smooth scroll con Lenis: desactivar en mobile (`window.innerWidth < 768`)
- No abusar de animaciones — cada sección 1 animación principal max
- Fuentes premium gratuitas: Cormorant Garamond (Google Fonts), libre para uso comercial
