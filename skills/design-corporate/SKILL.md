---
name: design-corporate
description: Guía para diseño de páginas corporativas/empresariales — estructura formal, paleta profesional, jerarquía clara, B2B. Usar cuando el cliente es una empresa que necesita transmitir confianza y autoridad.
license: MIT
---

# design-corporate — Diseño Corporativo

Workflow para páginas corporativas: estructura formal, layout denso con información, paleta sobria, tipografía de autoridad, orientada a B2B o institucional.

## Cuándo usar

- "página corporativa", "sitio empresarial", "landing B2B"
- "transmitir profesionalismo", "diseño institucional", "empresa de consultoría/finanzas/legal"
- Cliente es una empresa grande, bank, firma legal, consultora, institución

## Identidad del tier

| Atributo | Corporativo |
|----------|-------------|
| Paleta | Navy, gris oscuro, blanco, 1 acento (#0047AB, #1B365D) |
| Tipografía | Serif para headers (Playfair, Cormorant), Sans para body (Inter, IBM Plex) |
| Layout | Grids densos, columnas múltiples, mucha información |
| Animaciones | Mínimas — fade-in sutil, sin efectos llamativos |
| Imágenes | Fotos de equipo, oficinas, reuniones — sin ilustraciones |
| Componentes | Stats, testimonials de ejecutivos, logos de clientes |

## Workflow

### 1. Intake

Preguntar:
- Sector: finanzas, legal, consultoría, manufactura, salud, gobierno
- Tamaño empresa: SME, mid-market, enterprise
- CTA principal: contacto, demo, cotización, descarga de brochure
- Paleta de marca (si existe)

### 2. Setup de fuentes

```bash
# En Next.js
npm install @next/font  # ya incluido en Next.js 13+
```

```tsx
// src/app/layout.tsx
import { Inter, Playfair_Display } from 'next/font/google'

const inter = Inter({ subsets: ['latin'], variable: '--font-sans' })
const playfair = Playfair_Display({ subsets: ['latin'], variable: '--font-serif' })
```

### 3. Paleta Tailwind corporativa

```js
// tailwind.config.js
theme: {
  extend: {
    colors: {
      navy: { DEFAULT: '#0B1F4D', light: '#1B365D', dark: '#061230' },
      slate: { corporate: '#4A5568' },
      accent: { DEFAULT: '#C9A84C' }  // dorado — opcional para premium corp
    },
    fontFamily: {
      serif: ['var(--font-serif)', 'Georgia', 'serif'],
      sans: ['var(--font-sans)', 'system-ui', 'sans-serif'],
    }
  }
}
```

### 4. Estructura de página tipo

```
Header: Logo + Nav horizontal con megamenu
Hero: Headline autoritario + stat numbers + CTA doble (primario/secundario)
Trust bar: Logos de clientes / certificaciones
Services: Grid 3 columnas con íconos lineales
Stats: Números grandes (15 años, 200 clientes, $2B gestionados)
Testimonials: Quote + foto + cargo + empresa
Team: Grid de headshots con nombre y cargo
CTA final: Fondo navy oscuro + formulario de contacto
Footer: Columnas de links + certificaciones + legal
```

### 5. Componente Stats corporativo

```tsx
const stats = [
  { value: '15+', label: 'Años de experiencia' },
  { value: '200', label: 'Clientes activos' },
  { value: '98%', label: 'Satisfacción' },
]

export function StatsBar() {
  return (
    <section className="bg-navy py-16">
      <div className="container mx-auto grid grid-cols-3 gap-8 text-center text-white">
        {stats.map(s => (
          <div key={s.label}>
            <p className="font-serif text-5xl font-bold">{s.value}</p>
            <p className="mt-2 text-sm uppercase tracking-widest text-white/60">{s.label}</p>
          </div>
        ))}
      </div>
    </section>
  )
}
```

## Output

- Estructura HTML/JSX de la página corporativa completa
- Paleta y tokens Tailwind configurados
- Componentes: Hero, Stats, Testimonials, Team, CTA

## Notas

- Evitar colores vibrantes o gradientes llamativos
- Animaciones: solo `transition-opacity duration-300` — nada más
- Formulario de contacto: siempre visible en el footer y en sección dedicada
- Mobile: layout de columna única, nav colapsable en hamburger
