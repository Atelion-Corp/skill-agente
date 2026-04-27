---
name: design-uiverse
description: Implement physics-based scroll interactions — smooth momentum scroll (Lenis), parallax, infinite scroll, horizontal scroll sections, scroll progress indicators, scroll-triggered animations, custom scrollbars. Use when user wants cinematic scroll experience, smooth scroll physics, scroll storytelling, or UIverse-style scroll components.
license: MIT
---

# design-uiverse — Scroll Physics & UIverse Components

Scroll suave con física, parallax, scroll infinito, animaciones al scroll. Patrones de UIverse.io.

## Cuándo usar

- "scroll suave", "momentum scroll", "tipo Lenis"
- "animación al scroll", "parallax", "scroll infinito"
- "scrollbar custom", "scroll storytelling", "horizontal scroll"
- "scroll progress bar", "scroll physics"

## Stack

```bash
npm install @studio-freight/lenis   # smooth scroll física
npm install gsap                    # scroll triggers
# opcional:
npm install motion                  # Motion.dev (más ligero)
```

## 1. Lenis — Setup global

```tsx
// app/layout.tsx o providers.tsx
import Lenis from '@studio-freight/lenis'
import { useEffect } from 'react'

export function SmoothScrollProvider({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    const lenis = new Lenis({
      duration: 1.2,
      easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)), // expo out
      smooth: true,
      touchMultiplier: 2,
    })

    function raf(time: number) {
      lenis.raf(time)
      requestAnimationFrame(raf)
    }
    requestAnimationFrame(raf)

    return () => lenis.destroy()
  }, [])

  return <>{children}</>
}
```

## 2. GSAP ScrollTrigger + Lenis

```tsx
import gsap from 'gsap'
import ScrollTrigger from 'gsap/ScrollTrigger'
gsap.registerPlugin(ScrollTrigger)

useEffect(() => {
  const lenis = new Lenis()

  // Sincronizar con GSAP
  lenis.on('scroll', ScrollTrigger.update)
  gsap.ticker.add((time) => lenis.raf(time * 1000))
  gsap.ticker.lagSmoothing(0)

  // Animación al entrar en viewport
  gsap.fromTo('.section',
    { opacity: 0, y: 60 },
    {
      opacity: 1, y: 0,
      duration: 0.8,
      stagger: 0.1,
      scrollTrigger: {
        trigger: '.sections-wrapper',
        start: 'top 80%',
        end: 'bottom 20%',
        toggleActions: 'play none none reverse'
      }
    }
  )

  return () => { lenis.destroy(); ScrollTrigger.killAll() }
}, [])
```

## 3. Parallax

```tsx
// Parallax con GSAP scrub
gsap.to('.hero-bg', {
  y: '30%',
  ease: 'none',
  scrollTrigger: {
    trigger: '.hero',
    start: 'top top',
    end: 'bottom top',
    scrub: true
  }
})
```

## 4. Horizontal scroll section

```tsx
useEffect(() => {
  const sections = gsap.utils.toArray<HTMLElement>('.panel')
  gsap.to(sections, {
    xPercent: -100 * (sections.length - 1),
    ease: 'none',
    scrollTrigger: {
      trigger: '.horizontal-track',
      pin: true,
      scrub: 1,
      snap: 1 / (sections.length - 1),
      end: () => '+=' + (document.querySelector('.horizontal-track') as HTMLElement).offsetWidth
    }
  })
}, [])
```

```tsx
// HTML necesario
<div className="horizontal-track overflow-hidden">
  <div className="flex w-[300vw]">
    <div className="panel w-screen h-screen flex-shrink-0">Panel 1</div>
    <div className="panel w-screen h-screen flex-shrink-0">Panel 2</div>
    <div className="panel w-screen h-screen flex-shrink-0">Panel 3</div>
  </div>
</div>
```

## 5. Scroll progress indicator

```tsx
function ScrollProgress() {
  const [progress, setProgress] = useState(0)

  useEffect(() => {
    const update = () => {
      const total = document.documentElement.scrollHeight - window.innerHeight
      setProgress((window.scrollY / total) * 100)
    }
    window.addEventListener('scroll', update, { passive: true })
    return () => window.removeEventListener('scroll', update)
  }, [])

  return (
    <div
      className="fixed top-0 left-0 h-[2px] bg-violet-500 z-50 transition-none"
      style={{ width: `${progress}%` }}
    />
  )
}
```

## 6. Infinite scroll

```tsx
export function useInfiniteScroll(onLoadMore: () => void, hasMore: boolean) {
  const observer = useRef<IntersectionObserver>()

  const lastElementRef = useCallback((node: HTMLElement | null) => {
    if (observer.current) observer.current.disconnect()
    observer.current = new IntersectionObserver(entries => {
      if (entries[0].isIntersecting && hasMore) onLoadMore()
    }, { threshold: 0.1 })
    if (node) observer.current.observe(node)
  }, [onLoadMore, hasMore])

  return lastElementRef
}

// Uso
function ItemList() {
  const [items, setItems] = useState(initial)
  const [hasMore, setHasMore] = useState(true)
  const lastRef = useInfiniteScroll(() => fetchMore(), hasMore)

  return (
    <ul>
      {items.map((item, i) => (
        <li key={item.id} ref={i === items.length - 1 ? lastRef : null}>
          {item.name}
        </li>
      ))}
    </ul>
  )
}
```

## 7. Custom scrollbar (CSS)

```css
::-webkit-scrollbar { width: 5px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb {
  background: rgba(255,255,255,0.2);
  border-radius: 3px;
}
::-webkit-scrollbar-thumb:hover { background: rgba(255,255,255,0.4); }

/* Firefox */
* { scrollbar-width: thin; scrollbar-color: rgba(255,255,255,0.2) transparent; }
```

## Performance

- `passive: true` en todos los listeners de scroll
- Lenis usa RAF: no agregar listeners de scroll manuales encima
- ScrollTrigger: usar `scrub` en lugar de callbacks para sincronización exacta
