---
name: mcp-catalog
description: Enterprise MCP catalog — complete reference of available MCPs organized by business function (docs, email, PM, BI, CRM, finance, databases, dev, communication). Use when selecting MCPs for a project or configuring integrations for sub-agents.
license: MIT
metadata:
  agent_type: utility
  domain: all
---

# MCP Catalog — Herramientas Empresariales Integradas

Catálogo completo de MCPs disponibles para potenciar los sub-agentes. Organizado por función de negocio.

> "Un sub-agente con MCP es un experto con acceso directo a los datos reales."

---

## DOCUMENTOS Y ARCHIVOS

### Google Workspace
| MCP | Función | Sub-agentes que lo usan |
|-----|---------|------------------------|
| `mcp-google-drive` | Leer/escribir archivos Drive, buscar docs, acceder carpetas | Todos |
| `mcp-google-docs` | Crear/editar documentos, exportar PDF | ops-pm, hr-manager, ops-strategy |
| `mcp-google-sheets` | Leer/escribir hojas, fórmulas, datos tabulares | data-analyst, finance-analyst, accounting, product-analyst |
| `mcp-google-slides` | Crear presentaciones | ops-strategy, mkt-copy |
| `mcp-google-calendar` | Ver/crear eventos, gestión de agenda | ops-pm, hr-manager |

### Microsoft Office 365 / OneDrive
| MCP | Función | Sub-agentes que lo usan |
|-----|---------|------------------------|
| `mcp-microsoft-graph` | Acceso unificado a toda la suite Microsoft | finance-analyst, hr-manager |
| `mcp-onedrive` | Archivos OneDrive, SharePoint | ops-pm, finance-analyst |
| `mcp-excel` | Leer/escribir Excel, tablas pivote, fórmulas | finance-analyst, accounting, data-analyst |
| `mcp-word` | Crear/editar documentos Word | hr-manager, ops-strategy, legal |
| `mcp-outlook` | Email, calendario, contactos Outlook | hr-manager, ops-pm, finance-analyst |
| `mcp-teams` | Mensajes, canales, reuniones Teams | ops-pm, hr-manager |

### Almacenamiento
| MCP | Función |
|-----|---------|
| `mcp-dropbox` | Archivos Dropbox, compartir |
| `mcp-filesystem` | Archivos locales del sistema |
| `mcp-s3` | Amazon S3 buckets |

---

## COMUNICACIÓN

| MCP | Servicio | Sub-agentes |
|-----|---------|-------------|
| `mcp-gmail` | Email Gmail: leer, enviar, buscar, etiquetar | mkt-copy, sales-crm, hr-manager |
| `mcp-outlook` | Email Outlook/Exchange | finance-analyst, hr-manager, ops-pm |
| `mcp-slack` | Mensajes Slack: canales, DMs, búsqueda | ops-pm, eng-devops, hr-manager |
| `mcp-discord` | Servidores Discord, mensajes | mkt-growth |
| `mcp-whatsapp-business` | WhatsApp Business API | sales-crm, mkt-copy |

**Configuración básica:**
```json
{
  "mcpServers": {
    "gmail": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-gmail"]
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": { "SLACK_BOT_TOKEN": "<token>" }
    }
  }
}
```

---

## GESTIÓN DE PROYECTOS

| MCP | Servicio | Sub-agentes |
|-----|---------|-------------|
| `mcp-jira` | Issues, sprints, boards, epics, Jira Cloud | eng-qa, ops-pm, product-manager |
| `mcp-linear` | Issues Linear, proyectos, ciclos | eng-qa, product-manager, ops-pm |
| `mcp-notion` | Páginas, bases de datos, wikis Notion | ops-pm, hr-manager, product-manager |
| `mcp-asana` | Proyectos Asana, tareas, dependencias | ops-pm |
| `mcp-monday` | Tableros Monday.com, automatizaciones | ops-pm, sales-crm |
| `mcp-trello` | Tableros Trello, tarjetas | ops-pm |
| `mcp-github-projects` | GitHub Projects, issues, PRs | eng-qa, eng-devops, product-manager |

**Ejemplo — Jira:**
```json
{
  "mcpServers": {
    "jira": {
      "command": "npx",
      "args": ["-y", "mcp-server-jira"],
      "env": {
        "JIRA_BASE_URL": "https://<domain>.atlassian.net",
        "JIRA_EMAIL": "<email>",
        "JIRA_API_TOKEN": "<token>"
      }
    }
  }
}
```

---

## BUSINESS INTELLIGENCE Y ANALYTICS

| MCP | Servicio | Sub-agentes |
|-----|---------|-------------|
| `mcp-google-analytics` | GA4: sesiones, eventos, conversiones, audiencias | mkt-seo, mkt-cro, product-analyst |
| `mcp-power-bi` | Reportes Power BI, datasets, DAX | finance-analyst, data-analyst |
| `mcp-metabase` | Queries Metabase, dashboards, preguntas | data-analyst, product-analyst |
| `mcp-tableau` | Workbooks Tableau, vistas, datos | data-analyst |
| `mcp-looker` | Explores Looker, dashboards, LookML | data-analyst |
| `mcp-mixpanel` | Eventos, funnels, cohortes Mixpanel | product-analyst, mkt-cro |
| `mcp-amplitude` | Analytics de producto, retención, funnels | product-analyst |
| `mcp-segment` | CDP: eventos, traits, destinations | product-analyst, mkt-growth |

---

## CRM Y VENTAS

| MCP | Servicio | Sub-agentes |
|-----|---------|-------------|
| `mcp-salesforce` | Leads, oportunidades, cuentas, reportes Salesforce | sales-crm, ops-strategy |
| `mcp-hubspot` | CRM HubSpot: contacts, deals, pipelines, emails | sales-crm, mkt-copy, mkt-growth |
| `mcp-pipedrive` | Pipeline Pipedrive, deals, actividades | sales-crm |
| `mcp-zoho-crm` | CRM Zoho: contactos, leads, módulos | sales-crm |
| `mcp-apollo` | Prospección Apollo.io, datos de contacto | sales-crm |

**Ejemplo — HubSpot:**
```json
{
  "mcpServers": {
    "hubspot": {
      "command": "npx",
      "args": ["-y", "mcp-server-hubspot"],
      "env": { "HUBSPOT_ACCESS_TOKEN": "<token>" }
    }
  }
}
```

---

## FINANZAS Y CONTABILIDAD

| MCP | Servicio | Sub-agentes |
|-----|---------|-------------|
| `mcp-quickbooks` | QuickBooks: facturas, gastos, P&L, balance | accounting, finance-analyst |
| `mcp-xero` | Xero: contabilidad, facturación, reconciliación | accounting, finance-analyst |
| `mcp-stripe` | Stripe: pagos, subscripciones, MRR, churn | finance-analyst, eng-backend |
| `mcp-paypal` | PayPal: transacciones, reportes | accounting |
| `mcp-mercury` | Cuentas bancarias Mercury | accounting |
| `mcp-brex` | Tarjetas Brex, gastos, receipts | accounting |
| `mcp-mercadopago` | MercadoPago LATAM: pagos, reportes | accounting, finance-analyst |

---

## BASES DE DATOS

| MCP | Servicio | Sub-agentes |
|-----|---------|-------------|
| `mcp-postgres` | PostgreSQL: queries, schema, explain | eng-database, data-analyst |
| `mcp-mysql` | MySQL/MariaDB | eng-database, data-analyst |
| `mcp-mongodb` | MongoDB: collections, aggregations | eng-database, data-analyst |
| `mcp-supabase` | Supabase: DB + Auth + Storage | eng-backend, eng-database |
| `mcp-sqlite` | SQLite local | data-analyst |
| `mcp-bigquery` | Google BigQuery | data-analyst, finance-analyst |
| `mcp-snowflake` | Snowflake data warehouse | data-analyst |
| `mcp-redis` | Redis: keys, lists, pub/sub | eng-backend, eng-database |

**Ejemplo — PostgreSQL:**
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": { "DATABASE_URL": "postgresql://<user>:<pass>@<host>/<db>" }
    }
  }
}
```

---

## DESARROLLO Y CÓDIGO

| MCP | Servicio | Sub-agentes |
|-----|---------|-------------|
| `mcp-github` | Repos GitHub: issues, PRs, code, actions | eng-backend, eng-devops, eng-qa |
| `mcp-gitlab` | GitLab: issues, pipelines, MRs | eng-devops |
| `mcp-filesystem` | Sistema de archivos local | eng-backend, data-analyst |
| `mcp-docker` | Docker: contenedores, imágenes, logs | eng-devops |

---

## MARKETING Y CONTENIDO

| MCP | Servicio | Sub-agentes |
|-----|---------|-------------|
| `mcp-ahrefs` | SEO: keywords, backlinks, auditorías | mkt-seo |
| `mcp-semrush` | SEO/SEM: posicionamiento, ads | mkt-seo |
| `mcp-mailchimp` | Email marketing: campañas, listas, stats | mkt-copy |
| `mcp-klaviyo` | Email/SMS: flows, segmentos | mkt-copy, mkt-growth |
| `mcp-buffer` | Social media scheduling | mkt-copy |
| `mcp-canva` | Diseño Canva: templates, assets | design-generator |

---

## RECURSOS HUMANOS

| MCP | Servicio | Sub-agentes |
|-----|---------|-------------|
| `mcp-workday` | HRIS Workday: empleados, nómina | hr-manager |
| `mcp-bamboohr` | BambooHR: perfiles, PTO, onboarding | hr-manager |
| `mcp-greenhouse` | ATS Greenhouse: candidatos, pipelines | hr-manager |
| `mcp-lever` | ATS Lever: reclutamiento, entrevistas | hr-manager |
| `mcp-gusto` | Nómina Gusto (US) | accounting, hr-manager |

---

## AUTOMATIZACIÓN / INTEGRACIÓN

| MCP | Servicio | Sub-agentes |
|-----|---------|-------------|
| `mcp-n8n` | n8n workflows: nodos, ejecuciones | eng-devops |
| `mcp-zapier` | Zapier: zaps, triggers, actions | ops-pm |
| `mcp-make` | Make (Integromat): scenarios | ops-pm |
| `mcp-webhook` | Webhooks genéricos | eng-backend |

---

## WEB / BÚSQUEDA

| MCP | Servicio |
|-----|---------|
| `mcp-brave-search` | Búsqueda web Brave |
| `mcp-fetch` | Fetch de URLs, scraping básico |
| `mcp-google-search` | Google Search programático |
| `mcp-google-maps` | Maps: direcciones, lugares, distancias |

---

## Configuración en Claude Code (`~/.claude/settings.json`)

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": { "DATABASE_URL": "postgresql://..." }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "<token>" }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/projects"]
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-slack"],
      "env": { "SLACK_BOT_TOKEN": "<token>" }
    }
  }
}
```

---

## Selección de MCPs por tipo de proyecto

| Tipo de proyecto | MCPs esenciales |
|-----------------|-----------------|
| App web SaaS | postgres, github, filesystem |
| E-commerce | stripe, postgres, github, mailchimp |
| Análisis de negocio | google-sheets, power-bi, postgres |
| CRM/Ventas | hubspot/salesforce, gmail, google-sheets |
| Finanzas/Contabilidad | quickbooks/xero, excel, google-sheets |
| HR/Personas | bamboohr, gmail, google-docs, notion |
| Marketing digital | google-analytics, mailchimp, semrush |
| Gestión de proyectos | jira/linear, github, slack, notion |
| Data warehouse | bigquery/snowflake, postgres, looker |

---

## Notas de seguridad

- Nunca hardcodear tokens en archivos de configuración versionados
- Usar variables de entorno o `~/.claude/settings.json` (no en repo)
- Tokens con permisos mínimos necesarios (principle of least privilege)
- Rotar tokens periódicamente (mínimo cada 90 días)
