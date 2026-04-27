---
name: design-pro
description: Guía para diseño web profesional avanzado — design system propio, micro-interacciones, layouts complejos, tipografía custom, dark mode polished. Nivel agencia creativa o producto tech destacado.
license: MIT
---

# design-pro — Diseño Profesional Avanzado

Nivel agencia: design system propio, micro-interacciones cuidadas, layouts complejos y asimétricos, dark mode pulido, tipografía variable, experiencia de producto de alto nivel.

## Cuándo usar

- "nivel agencia", "diseño pro", "micro-interacciones", "design system propio"
- Producto tech ambicioso, agencia digital, startup bien financiada
- Usuario tiene diseño en Figma y quiere implementación fiel

## Identidad del tier

| Atributo | Pro |
|----------|-----|
| Paleta | Dark-first con accent neón (violet, cyan, emerald) — o light con greys ricos |
| Tipografía | Variable fonts (Geist, Bricolage Grotesque, Satoshi) |
| Layout | CSS Grid avanzado, asimétrico, elementos que rompen la grilla |
| Animaciones | Framer Motion — layout animations, shared element transitions |
| Componentes | Custom, no shadcn puro — estilos extendidos o design tokens propios |
| Dark mode | Primera clase — no afterthought |

## Workflow

### 1. Intake

Preguntar:
- ¿Viene con Figma / referencias detalladas?
- Dark-first o light-first
- Features especiales: scroll hijacking, cursor custom, transiciones de página
- Stack: Next.js App Router (confirmado), animaciones con Framer Motion

### 2. Dependencias

```bash
npm install framer-motion
npm install @studio-freight/lenis  # smooth scroll
npm install geist                  # fuente Vercel
```

### 3. Design system tokens

```js
// tailwind.config.js — tokens del design system
theme: {
  extend: {
    colors: {
      brand: {
        50:  '#f0f0ff',
        500: '#7c3aed',
        600: '#6d28d9',
        neon: '#a78bfa',
      },
      surface: {
        base: '#0a0a0f',
        elevated: '#111118',
        overlay: '#1a1a24',
        border: '#2a2a38',
      }
    },
    fontFamily: {
      sans: ['var(--font-geist-sans)'],
      mono: ['var(--font-geist-mono)'],
    },
    animation: {
      'gradient-x': 'gradient-x 3s ease infinite',
    },
    keyframes: {
      'gradient-x': {
        '0%, 100%': { 'background-position': '0% 50%' },
        '50%': { 'background-position': '100% 50%' },
      }
    }
  }
}
```

### 4. Hero pro con gradiente animado

```tsx
'use client'
import { motion } from 'framer-motion'

export function ProHero() {
  return (
    <section className="relative min-h-screen bg-surface-base flex items-center overflow-hidden">
      {/* Glow background */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] rounded-full bg-brand-500/20 blur-[120px] pointer-events-none" />

      <div className="container mx-auto px-8 relative z-10">
        {/* Badge animated */}
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.4 }}
          className="inline-flex items-center gap-2 border border-brand-neon/30 rounded-full px-4 py-1.5 text-brand-neon text-xs font-medium mb-8"
        >
          <span className="w-1.5 h-1.5 rounded-full bg-brand-neon animate-pulse" />
          Beta pública ya disponible
        </motion.div>

        {/* Headline */}
        <motion.h1
          initial={{ opacity: 0, y: 30 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.7, delay: 0.1 }}
          className="text-6xl lg:text-7xl font-bold text-white leading-[1.05] tracking-tight max-w-4xl"
        >
          El stack para equipos que{' '}
          <span className="bg-gradient-to-r from-brand-neon via-cyan-400 to-brand-neon bg-[length:200%] animate-gradient-x bg-clip-text text-transparent">
            mueven rápido
          </span>
        </motion.h1>

        {/* CTA */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.4 }}
          className="mt-10 flex gap-4"
        >
          <button className="bg-brand-500 hover:bg-brand-600 text-white px-6 py-3 rounded-lg font-semibold transition-colors">
            Empezar gratis →
          </button>
          <button className="border border-surface-border text-white/70 hover:text-white hover:border-white/40 px-6 py-3 rounded-lg transition-all">
            Ver documentación
          </button>
        </motion.div>
      </div>
    </section>
  )
}
```

### 5. Transiciones de página (App Router)

```tsx
// src/components/layout/PageTransition.tsx
'use client'
import { motion, AnimatePresence } from 'framer-motion'
import { usePathname } from 'next/navigation'

export function PageTransition({ children }: { children: React.ReactNode }) {
  const pathname = usePathname()
  return (
    <AnimatePresence mode="wait">
      <motion.div
        key={pathname}
        initial={{ opacity: 0, y: 8 }}
        animate={{ opacity: 1, y: 0 }}
        exit={{ opacity: 0, y: -8 }}
        transition={{ duration: 0.2 }}
      >
        {children}
      </motion.div>
    </AnimatePresence>
  )
}
```

### 6. Cursor custom

```tsx
'use client'
import { useEffect, useRef } from 'react'

export function CustomCursor() {
  const dot = useRef<HTMLDivElement>(null)
  const ring = useRef<HTMLDivElement>(null)

  useEffect(() => {
    let x = 0, y = 0, rx = 0, ry = 0

    const move = (e: MouseEvent) => { x = e.clientX; y = e.clientY }
    window.addEventListener('mousemove', move)

    const loop = () => {
      rx += (x - rx) * 0.1
      ry += (y - ry) * 0.1
      if (dot.current) { dot.current.style.left = `${x}px`; dot.current.style.top = `${y}px` }
      if (ring.current) { ring.current.style.left = `${rx}px`; ring.current.style.top = `${ry}px` }
      requestAnimationFrame(loop)
    }
    loop()
    return () => window.removeEventListener('mousemove', move)
  }, [])

  return (
    <>
      <div ref={dot} className="pointer-events-none fixed z-[9999] -translate-x-1/2 -translate-y-1/2 w-2 h-2 bg-white rounded-full" />
      <div ref={ring} className="pointer-events-none fixed z-[9998] -translate-x-1/2 -translate-y-1/2 w-8 h-8 border border-white/40 rounded-full transition-[width,height]" />
    </>
  )
}
```

## Output

- Design system tokens completo en Tailwind
- Hero pro con gradiente animado y glow
- Transiciones de página con Framer Motion
- Cursor custom (desktop only)
- Dark mode configurado como first class

## Notas

- Cursor custom: agregar `cursor-none` al `body`
- Glow blobs: `pointer-events-none` para no interferir con clicks
- Layout animations de Framer Motion requieren `layout` prop — no usar en listas largas
- Geist font: `import { GeistSans } from 'geist/font/sans'`
