---
name: mkt-seo
description: Comprehensive SEO audit and optimization — technical SEO, on-page, E-E-A-T, schema markup, GEO (AI search optimization for Perplexity/ChatGPT), local SEO, keyword strategy, and sitemap. Use when user wants to improve search rankings, audit a site, optimize for AI search engines, or build an SEO content strategy.
license: MIT
---

# mkt-seo — SEO Comprensivo

Auditoría y estrategia SEO: técnico, on-page, GEO (AI search), schema, keywords, contenido.

## Cuándo usar

- "audit SEO", "mejorar rankings", "optimizar para Google"
- "optimizar para Perplexity / ChatGPT / AI search"
- "schema markup", "sitemap", "Core Web Vitals"
- "estrategia de keywords", "SEO de contenido"

## 1. SEO Técnico

```
Core Web Vitals:
  □ LCP < 2.5s
  □ CLS < 0.1
  □ INP < 200ms

Rastreo:
  □ robots.txt correcto
  □ sitemap.xml presente y válido
  □ Sin canonical conflicts
  □ HTTPS en todas las páginas
  □ Redirect chains < 3 hops

Estructura:
  □ URLs limpias (sin params innecesarios)
  □ Breadcrumbs implementados
```

## 2. On-Page SEO

```
Por página:
  □ Title tag: keyword + brand, ≤60 chars
  □ Meta description: benefit + CTA, ≤155 chars
  □ H1: único, incluye keyword
  □ H2-H3: estructura lógica
  □ Keyword en primer párrafo (natural)
  □ Alt text descriptivo en imágenes
  □ Internal links: 2-5 por página
```

## 3. E-E-A-T

```
Experience:
  □ Casos de estudio propios, screenshots reales
  □ "Lo que aprendí" vs "lo que dice la doc"

Expertise:
  □ Author bio con credenciales
  □ Fecha + "última actualización" visible

Authoritativeness:
  □ Backlinks de sitios del nicho
  □ Citado como fuente por otros

Trust:
  □ Política de privacidad accesible
  □ Contacto visible
  □ Reviews verificadas (G2, Trustpilot, Google)
```

## 4. Schema Markup

```
Por tipo de sitio:
  SaaS:      SoftwareApplication, FAQPage, HowTo
  E-commerce: Product, Offer, Review, BreadcrumbList
  Blog:      Article, Person, BlogPosting
  Local:     LocalBusiness, OpeningHoursSpecification
```

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "Nombre Producto",
  "applicationCategory": "BusinessApplication",
  "operatingSystem": "Web",
  "offers": { "@type": "Offer", "price": "0", "priceCurrency": "USD" },
  "aggregateRating": { "@type": "AggregateRating", "ratingValue": "4.8", "reviewCount": "247" }
}
</script>
```

## 5. GEO — Optimización para AI Search

Optimizar para: Perplexity, ChatGPT, Google AI Overviews, Claude.

```
□ Responder preguntas directamente (no esperar párrafo 3)
□ H2 como preguntas: "¿Qué es X?", "¿Cómo funciona Y?"
□ Datos con fuentes citables
□ Tablas comparativas (fácil de citar)
□ Listas numeradas con pasos claros
□ FAQ section al final de artículos
□ "Qué es X" en 2 oraciones al inicio del artículo
□ Author + fecha prominentes
```

## 6. Estrategia de Keywords

```
1. Seed keywords: términos del PROBLEMA, no del producto
2. Expandir: long-tail (4+ palabras)
3. Clasificar intent: informational / commercial / transactional
4. Priorizar: volumen × (1/KD) × intent_match
5. Clusterizar por tema

Mapping content:
  Homepage:    keyword transaccional principal
  Features:    keyword comercial + feature
  Blog:        informational + long-tail
  Comparativas: "[prod] vs [competidor]"
  Alternativas: "alternativas a [líder]"
```

## Output por módulo

| Solicitud | Output |
|-----------|--------|
| Audit técnico | Checklist Critical/High/Medium |
| On-page | Optimizaciones por página |
| Schema | JSON-LD listo para implementar |
| GEO | Reescritura de secciones |
| Keywords | Tabla vol/KD/intent/prioridad |
| Estrategia | Plan de contenido 3 meses |
