---
name: design-medio
description: Guía para diseño web estándar/medio — Tailwind + shadcn/ui, componentes convencionales, animaciones sutiles. Tier equilibrado para la mayoría de proyectos SaaS, apps, y startups.
license: MIT
---

# design-medio — Diseño Estándar / Medio

Tier equilibrado: buen diseño sin overhead de lujo. Tailwind + shadcn/ui + animaciones sutiles. Ideal para SaaS, apps de gestión, startups, marketplaces.

## Cuándo usar

- "diseño estándar", "look moderno sin exagerar", "SaaS landing"
- La mayoría de proyectos que no son ni luxury ni minimalistas extremos
- Cuando el usuario no especifica tier — este es el default

## Identidad del tier

| Atributo | Medio |
|----------|-------|
| Paleta | Slate/zinc base + 1 color accent vibrante (indigo, violet, emerald) |
| Tipografía | Inter (body) + Cal Sans o Geist (headings) |
| Layout | Grid 12 cols, secciones bien definidas, cards con border + shadow-sm |
| Animaciones | Fade-in en scroll, hover lift en cards, transition 200ms |
| Imágenes | Dashboard mockups, screenshots de producto, ilustraciones Lucide |
| Componentes | shadcn/ui — Button, Card, Badge, Dialog, Toast |

## Workflow

### 1. Intake

Preguntar:
- Tipo de producto: SaaS, marketplace, app, portfolio dev, blog técnico
- Color accent preferido (o elegir de la paleta)
- Secciones necesarias: hero, features, pricing, testimonials, FAQ, CTA

### 2. Setup shadcn/ui

```bash
npx shadcn@latest init
npx shadcn@latest add button card badge dialog
```

### 3. Hero SaaS estándar

```tsx
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'

export function SaasHero() {
  return (
    <section className="py-24 px-4 text-center">
      <Badge variant="outline" className="mb-4">✨ Nuevo — Dashboard v2.0</Badge>
      <h1 className="text-5xl font-bold tracking-tight text-slate-900 dark:text-white max-w-3xl mx-auto">
        Gestiona tu equipo sin fricciones
      </h1>
      <p className="mt-6 text-lg text-slate-600 dark:text-slate-400 max-w-xl mx-auto">
        Todo lo que necesitas para organizar proyectos, sprints y tareas — en un solo lugar.
      </p>
      <div className="mt-8 flex gap-3 justify-center">
        <Button size="lg">Empezar gratis</Button>
        <Button size="lg" variant="outline">Ver demo →</Button>
      </div>
      {/* Social proof */}
      <p className="mt-6 text-sm text-slate-500">
        Usado por <strong>2,000+</strong> equipos en Latinoamérica
      </p>
    </section>
  )
}
```

### 4. Features grid

```tsx
const features = [
  { icon: '⚡', title: 'Tiempo real', desc: 'Cambios sincronizados al instante entre todo el equipo.' },
  { icon: '🔒', title: 'Seguro', desc: 'JWT auth, permisos por rol, datos encriptados.' },
  { icon: '📊', title: 'Métricas', desc: 'Velocidad de sprint, burn-down, y más.' },
]

export function FeaturesGrid() {
  return (
    <section className="py-20">
      <div className="container mx-auto grid grid-cols-1 md:grid-cols-3 gap-6">
        {features.map(f => (
          <div key={f.title} className="rounded-xl border border-slate-200 p-6 hover:shadow-md transition-shadow">
            <div className="text-3xl mb-3">{f.icon}</div>
            <h3 className="font-semibold text-slate-900">{f.title}</h3>
            <p className="mt-2 text-sm text-slate-600">{f.desc}</p>
          </div>
        ))}
      </div>
    </section>
  )
}
```

### 5. Pricing cards

```tsx
export function PricingCard({ plan, price, features, highlighted }: PricingCardProps) {
  return (
    <div className={cn(
      'rounded-2xl border p-8',
      highlighted ? 'border-indigo-500 bg-indigo-50 dark:bg-indigo-950' : 'border-slate-200'
    )}>
      {highlighted && <Badge className="mb-4 bg-indigo-500">Popular</Badge>}
      <h3 className="text-xl font-bold">{plan}</h3>
      <p className="mt-2 text-4xl font-bold">${price}<span className="text-sm font-normal text-slate-500">/mes</span></p>
      <ul className="mt-6 space-y-3">
        {features.map(f => <li key={f} className="flex gap-2 text-sm"><span className="text-green-500">✓</span>{f}</li>)}
      </ul>
      <Button className="mt-8 w-full" variant={highlighted ? 'default' : 'outline'}>Comenzar</Button>
    </div>
  )
}
```

### 6. Animaciones scroll (sin librerías extra)

```css
/* globals.css */
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}
.animate-fade-up {
  animation: fadeUp 0.5s ease forwards;
}
```

```tsx
// Con Intersection Observer simple
'use client'
import { useEffect, useRef } from 'react'

export function FadeUp({ children }: { children: React.ReactNode }) {
  const ref = useRef<HTMLDivElement>(null)
  useEffect(() => {
    const obs = new IntersectionObserver(([e]) => {
      if (e.isIntersecting) { ref.current?.classList.add('animate-fade-up'); obs.disconnect() }
    }, { threshold: 0.1 })
    if (ref.current) obs.observe(ref.current)
  }, [])
  return <div ref={ref} className="opacity-0">{children}</div>
}
```

## Output

- Hero SaaS + Features Grid + Pricing Cards
- shadcn/ui configurado
- Animación scroll sin dependencias extra

## Notas

- shadcn/ui no agrega bundle si solo importas componentes usados
- Dark mode: `dark:` clases de Tailwind + ThemeProvider de shadcn
- Tipografía: Inter está en Google Fonts, Geist en npm (`npm install geist`)
