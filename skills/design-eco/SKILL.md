---
name: design-eco
description: Guía para diseño web eco/sostenible — paleta natural, mínimo JS, performance-first, estética verde/orgánica. Usar cuando el cliente es una marca ambiental, orgánica, o quiere transmitir sostenibilidad.
license: MIT
---

# design-eco — Diseño Eco / Sostenible

Diseño web que comunica sostenibilidad: paleta de tierra y verde, tipografía orgánica, mínimo impacto de carbono digital (bajo JS, CSS puro, imágenes optimizadas).

## Cuándo usar

- "diseño eco", "marca sostenible", "estética verde", "orgánico"
- Clientes: alimentos orgánicos, moda sostenible, ONG ambiental, energías renovables
- "bajo impacto digital", "web rápida y minimalista"

## Identidad del tier

| Atributo | Eco |
|----------|-----|
| Paleta | Verdes (#2D6A4F, #52B788), tierra (#8B5E3C), crema (#F1E9D2), blanco hueso |
| Tipografía | Sans humanista (DM Sans, Nunito), o serif suave (Lora) |
| Layout | Mucho whitespace, asimétrico suave, formas orgánicas |
| Animaciones | Mínimas — solo CSS transitions, sin JS pesado |
| Imágenes | Naturaleza, texturas, fotografía de producto en contexto |
| Componentes | Iconos de hoja/planta, badges de certificación, impacto medible |

## Workflow

### 1. Intake

Preguntar:
- Tipo: tienda eco, landing ONG, blog ambiental, producto orgánico
- Tono: científico/serio o cálido/artesanal
- ¿Tiene certificaciones que mostrar? (Carbono neutro, Fairtrade, etc.)
- CTA principal: comprar, donar, contactar

### 2. Paleta Tailwind eco

```js
// tailwind.config.js
theme: {
  extend: {
    colors: {
      forest: { DEFAULT: '#2D6A4F', light: '#52B788', dark: '#1B4332' },
      earth:  { DEFAULT: '#8B5E3C', light: '#A07850' },
      cream:  { DEFAULT: '#F1E9D2', dark: '#E8DFC8' },
      sage:   '#B7C4A0',
    }
  }
}
```

### 3. Hero eco

```tsx
export function EcoHero() {
  return (
    <section className="bg-cream min-h-screen flex items-center">
      <div className="container mx-auto px-8 grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
        <div>
          <span className="text-forest text-xs font-semibold tracking-widest uppercase">
            🌿 Certificado Carbono Neutro
          </span>
          <h1 className="mt-4 text-5xl font-serif text-earth leading-tight">
            Vivir bien<br />sin dañar<br />el planeta.
          </h1>
          <p className="mt-6 text-earth/70 text-lg leading-relaxed">
            Productos 100% orgánicos, envases biodegradables, huella cero.
          </p>
          <button className="mt-8 bg-forest text-white px-8 py-4 rounded-full text-sm font-semibold hover:bg-forest-dark transition-colors">
            Explorar colección →
          </button>
        </div>
        <div className="relative">
          <div className="aspect-square rounded-3xl overflow-hidden bg-sage/30">
            <img src="/product-organic.jpg" alt="Producto orgánico" className="w-full h-full object-cover" />
          </div>
          {/* Badge flotante */}
          <div className="absolute -bottom-4 -left-4 bg-white rounded-2xl p-4 shadow-lg">
            <p className="text-xs text-earth/60 uppercase tracking-wide">Huella de carbono</p>
            <p className="text-2xl font-bold text-forest">0.2 kg CO₂</p>
            <p className="text-xs text-earth/60">por envío</p>
          </div>
        </div>
      </div>
    </section>
  )
}
```

### 4. Badge de impacto

```tsx
const certifications = [
  { icon: '🌱', label: 'Orgánico certificado' },
  { icon: '♻️', label: 'Envase reciclable' },
  { icon: '🌍', label: 'Carbono neutro' },
  { icon: '🤝', label: 'Comercio justo' },
]

export function ImpactBadges() {
  return (
    <div className="flex flex-wrap gap-3">
      {certifications.map(c => (
        <span key={c.label} className="flex items-center gap-2 bg-forest/10 text-forest px-4 py-2 rounded-full text-sm font-medium">
          {c.icon} {c.label}
        </span>
      ))}
    </div>
  )
}
```

### 5. Performance eco (bajo impacto digital)

- Sin librerías de animación — solo `transition` CSS
- Imágenes en WebP, comprimidas al máximo
- Fuentes: máximo 2, subset `latin` solo
- No cargar analytics pesados — usar Plausible (2KB vs 45KB de GA)
- Target: &lt;100KB total CSS+JS transferido, &lt;2s LCP

## Output

- Hero eco completo con paleta y tipografía
- Badges de impacto/certificación
- Configuración Tailwind con tokens naturales
- Guía de performance eco (bajo impacto digital)

## Notas

- Texturas sutiles de papel o tela en backgrounds: `bg-[url('/texture.png')] bg-opacity-5`
- Formas orgánicas con `border-radius` irregular: `rounded-[30%_70%_70%_30%/30%_30%_70%_70%]`
- Evitar negro puro (`#000`) — usar `#1B3A2D` (verde muy oscuro) como color base
