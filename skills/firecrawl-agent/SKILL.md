---
name: firecrawl-agent
description: Usa Firecrawl AI para hacer scraping web, búsqueda y extracción de datos de URLs. Ideal para research, análisis de competidores, o extraer contenido de páginas.
license: MIT
---

# firecrawl-agent — Agente de Scraping con Firecrawl

Agente que usa Firecrawl SDK para hacer scraping, búsqueda web y extracción de datos estructurados.

## Cuándo usar

- "busca información de X en la web"
- "scrappea esta URL"
- "extrae datos de esta página"
- "haz research de competidores"
- "analiza el contenido de una web"

## Setup

### Requisitos

- API key de Firecrawl (obtener en firecrawl.dev)
-安装 `firecrawl-py`: `pip install firecrawl-py`

### Configuración

```python
from firecrawl import Firecrawl

app = Firecrawl(api_key="fc-TU-API-KEY")
```

O usar variable de entorno:
```bash
export FIRECRAWL_API_KEY=fc-TU-API-KEY
app = Firecrawl()
```

## Workflow

### 1. Búsqueda web

```python
results = app.search("query de búsqueda", limit=5)

for result in results.web:
    print(result.title, result.url)
```

### 2. Scraping básico

```python
doc = app.scrape("https://ejemplo.com", formats=["markdown"])
print(doc.markdown)
```

### 3. Extraer JSON estructurado

```python
from pydantic import BaseModel

class Info(BaseModel):
    titulo: str
    precio: str

result = app.scrape(
    "https://ejemplo.com",
    formats=[{
        "type": "json",
        "schema": Info.model_json_schema(),
        "prompt": "Extrae el título y precio del producto"
    }]
)
print(result.json)
```

### 4. Interactuar con página dinámica

```python
scrape_id = app.scrape("https://amazon.com", formats=["markdown"]).metadata.scrape_id

# Click, fills, navegación
response = app.interact(scrape_id, prompt="Busca iPhone 16")
response = app.interact(scrape_id, prompt="Click en el primer resultado")
```

## Comandos disponibles

- `firecrawl search <query>` — Buscar en la web
- `firecrawl scrape <url>` — Scrapear una URL
- `firecrawl crawl <url>` — Crawl completo de sitio

## Notas

- Firecrawl NO es para Gmail — es para scraping público
- Para Gmail, usar Google Gmail API o similar
- Respetar ToS de sitios scrapeados
- rate limits aplican según plan