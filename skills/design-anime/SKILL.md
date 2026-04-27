---
name: design-anime
description: Implement Anime.js v4 animations — micro-interactions, stagger effects, timeline sequences, spring physics, SVG morphing, scroll-triggered animations, text character animation, hover effects. Use when user wants to animate elements, add motion to UI, create cinematic page loads, entrance animations, or needs JavaScript animation beyond CSS.
license: MIT
---

# design-anime — Anime.js Animations

Skill para implementar animaciones con Anime.js v4 (3KB). Cubre micro-interacciones hasta timelines complejos.

## Cuándo usar

- "anima esto", "quiero micro-interacciones", "stagger en cards"
- "animación al hacer scroll", "spring physics", "morphing SVG"
- "entrance animation", "cinematic page load", "hover con JS"
- "anima texto carácter por carácter"

## Setup

```bash
npm install animejs
```

```js
// CDN
<script src="https://cdn.jsdelivr.net/npm/animejs@4/dist/anime.iife.min.js"></script>
```

## Tipos de animación

### 1. Básica

```js
import anime from 'animejs'

anime({
  targets: '.element',
  translateX: 250,
  opacity: [0, 1],
  duration: 800,
  easing: 'easeOutExpo'
})
```

### 2. Stagger (el más usado)

```js
// Cards/items en cascada
anime({
  targets: '.card',
  opacity: [0, 1],
  translateY: [30, 0],
  delay: anime.stagger(100),
  duration: 600,
  easing: 'easeOutCubic'
})

// Grid stagger desde centro
anime({
  targets: '.grid-item',
  scale: [0.8, 1],
  delay: anime.stagger(50, { grid: [4, 3], from: 'center' })
})
```

### 3. Timeline (secuencias)

```js
const tl = anime.timeline({ easing: 'easeOutExpo', duration: 600 })

tl
  .add({ targets: '.title', opacity: [0, 1], translateY: [-20, 0] })
  .add({ targets: '.subtitle', opacity: [0, 1] }, '-=300') // overlap
  .add({ targets: '.cta', scale: [0.8, 1], opacity: [0, 1] }, '-=200')
```

### 4. Spring physics

```js
anime({
  targets: '.ball',
  translateX: 300,
  easing: anime.spring({ stiffness: 80, damping: 10, mass: 1 })
})
```

### 5. Scroll-triggered

```js
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      anime({
        targets: entry.target,
        opacity: [0, 1],
        translateY: [40, 0],
        duration: 700,
        easing: 'easeOutCubic'
      })
      observer.unobserve(entry.target)
    }
  })
}, { threshold: 0.1 })

document.querySelectorAll('.animate-on-scroll').forEach(el => observer.observe(el))
```

### 6. SVG Morphing

```js
// Requiere igual número de puntos en ambos paths
anime({
  targets: '#shape path',
  d: [
    { value: 'M10 80 C 40 10, 65 10, 95 80 S 150 150, 180 80' },
    { value: 'M10 80 Q 95 10 180 80' }
  ],
  easing: 'easeInOutQuad',
  duration: 1000,
  direction: 'alternate',
  loop: true
})
```

### 7. Texto carácter por carácter

```js
// Split en spans
const chars = [...'Hello World'].map(c =>
  `<span class="char">${c === ' ' ? '&nbsp;' : c}</span>`
).join('')
document.querySelector('.title').innerHTML = chars

anime({
  targets: '.char',
  opacity: [0, 1],
  translateY: [20, 0],
  delay: anime.stagger(40),
  duration: 500
})
```

## Page load cinematic (patrón más pedido)

```js
document.addEventListener('DOMContentLoaded', () => {
  const tl = anime.timeline({ easing: 'easeOutExpo' })
  tl
    .add({ targets: 'nav', opacity: [0,1], translateY: [-10,0], duration: 500 })
    .add({ targets: '.hero-title', opacity: [0,1], translateY: [40,0], duration: 800 }, '-=200')
    .add({ targets: '.hero-sub', opacity: [0,1], duration: 600 }, '-=400')
    .add({ targets: '.hero-cta', scale: [0.9,1], opacity: [0,1], duration: 500 }, '-=300')
})
```

## Hover interactivo

```js
document.querySelectorAll('.card').forEach(card => {
  card.addEventListener('mouseenter', () =>
    anime({ targets: card, scale: 1.03, duration: 250 }))
  card.addEventListener('mouseleave', () =>
    anime({ targets: card, scale: 1, duration: 250 }))
})
```

## React / Next.js

```tsx
import { useEffect, useRef } from 'react'
import anime from 'animejs'

export function AnimatedCard({ children }: { children: React.ReactNode }) {
  const ref = useRef<HTMLDivElement>(null)
  useEffect(() => {
    if (!ref.current) return
    anime({ targets: ref.current, opacity: [0, 1], translateY: [30, 0], duration: 600, easing: 'easeOutCubic' })
  }, [])
  return <div ref={ref} style={{ opacity: 0 }}>{children}</div>
}
```

## Easings

| Tipo | Ejemplos |
|------|----------|
| Standard | `easeOutExpo`, `easeInOutQuad`, `easeOutCubic` |
| Spring | `anime.spring({stiffness, damping, mass})` |
| Elastic | `easeOutElastic(1, .5)` |
| Custom | `cubicBezier(.17,.67,.83,.67)` |

## Performance

- Animar solo: `transform` (translateX/Y/Z, scale, rotate) + `opacity` → GPU
- Evitar: `width`, `height`, `top`, `left`, `margin` → layout thrash
- Listas largas: `will-change: transform` en CSS
