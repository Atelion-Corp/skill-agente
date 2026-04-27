---
name: design-images
description: Guía para diseño web centrado en imágenes — galerías, heroes, art direction, optimización y lazy loading. Usar cuando el proyecto tiene contenido visual pesado.
license: MIT
---

# design-images — Diseño Web con Imágenes

Workflow para sitios image-heavy: galerías fotográficas, portfolios, landing pages con hero images, art direction responsiva y optimización de rendimiento.

## Cuándo usar

- "portfolio de fotos", "galería de imágenes", "hero con imagen de fondo"
- "lazy loading de imágenes", "optimizar imágenes"
- "masonry grid", "lightbox", "imagen responsiva"

## Stack recomendado

- **Next.js**: `next/image` — optimización automática, WebP, blur placeholder
- **Vanilla/React**: `<img loading="lazy">` + Intersection Observer
- **Galería avanzada**: `yet-another-react-lightbox` o `PhotoSwipe`
- **Masonry**: `react-masonry-css` o CSS Grid con `grid-auto-rows`

## Workflow

### 1. Intake

Preguntar:
- Tipo: portfolio, galería de producto, hero estático, carrusel, art direction
- Cantidad de imágenes: pocas (&lt;10), media (10-50), masiva (50+)
- Stack del proyecto
- Fuente de imágenes: local, CDN externo, CMS (Contentful, Sanity, Cloudinary)

### 2. Componente de imagen optimizada

**Next.js — imagen hero con placeholder blur:**
```tsx
import Image from 'next/image'

export function HeroImage() {
  return (
    <div className="relative h-[70vh] w-full overflow-hidden">
      <Image
        src="/hero.jpg"
        alt="Hero visual"
        fill
        priority
        sizes="100vw"
        className="object-cover object-center"
        placeholder="blur"
        blurDataURL="data:image/jpeg;base64,/9j/4AAQ..."
      />
      <div className="absolute inset-0 bg-black/40" />
    </div>
  )
}
```

**Galería masonry con CSS Grid:**
```tsx
export function MasonryGallery({ images }: { images: string[] }) {
  return (
    <div className="columns-1 sm:columns-2 lg:columns-3 gap-4 space-y-4">
      {images.map((src, i) => (
        <div key={i} className="break-inside-avoid">
          <Image
            src={src}
            alt={`Foto ${i + 1}`}
            width={800}
            height={600}
            className="w-full rounded-lg"
            loading={i < 6 ? 'eager' : 'lazy'}
          />
        </div>
      ))}
    </div>
  )
}
```

### 3. Lightbox

```bash
npm install yet-another-react-lightbox
```

```tsx
import Lightbox from 'yet-another-react-lightbox'
import 'yet-another-react-lightbox/styles.css'

const [index, setIndex] = useState(-1)

<Lightbox
  slides={images.map(src => ({ src }))}
  open={index >= 0}
  index={index}
  close={() => setIndex(-1)}
/>
```

### 4. Art direction responsiva

```tsx
<picture>
  <source media="(max-width: 768px)" srcSet="/hero-mobile.webp" />
  <source media="(min-width: 769px)" srcSet="/hero-desktop.webp" />
  <img src="/hero-desktop.jpg" alt="Hero" loading="eager" />
</picture>
```

### 5. Optimización de assets

```bash
# Convertir a WebP (requiere sharp o imagemagick)
npx sharp-cli -i ./public/images/*.jpg -o ./public/images/optimized/ -f webp -q 80

# Generar blur placeholder base64
npx plaiceholder ./public/hero.jpg
```

### 6. Patrones de layout

| Layout | CSS | Uso |
|--------|-----|-----|
| Full-bleed hero | `h-screen object-cover` | Landing page |
| Grid uniforme | `grid-cols-3 gap-2` | Portfolio |
| Masonry | `columns-3` | Fotografía |
| Carrusel | Embla Carousel | Productos |
| Split (texto+imagen) | `grid-cols-2` | Secciones |

## Dependencias comunes

```bash
npm install yet-another-react-lightbox
npm install embla-carousel-react          # carrusel
npm install react-intersection-observer   # lazy avanzado
```

## Output

- Componentes de imagen optimizados para el stack
- Grid / galería / lightbox funcional
- Estrategia de lazy loading implementada

## Notas

- `priority` solo en imágenes above-the-fold (hero, LCP)
- `sizes` correcto reduce el tamaño de imagen descargada significativamente
- Alt text descriptivo — accesibilidad y SEO
- WebP save ~30% vs JPEG mismo quality
