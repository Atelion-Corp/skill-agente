# Diagramas de Arquitectura y Operación

## 1) Flujo general de plataforma

```mermaid
flowchart LR
    U[Admin UI] --> CP[Control Plane]
    CP --> EX[Execution Plane OpenClaw]
    EX --> SK[Skills Registry]
    EX --> AG[Agentes]
    AG --> DV[Validadores]
    DV --> DP[Deploy Guardian]
    DP --> APPS[Apps en Docker]
    APPS --> OBS[Observability Stack]
    OBS --> U
```

## 2) Flujo de validación + despliegue

```mermaid
flowchart TD
    A[Commit/Upload proyecto] --> B[Validación estructura]
    B --> C{Pasa reglas?}
    C -- No --> D[Reporte findings + autocorrección segura]
    C -- Sí --> E[Backup pre-deploy]
    E --> F[Deploy controlado]
    F --> G[Smoke tests]
    G --> H{OK?}
    H -- No --> I[Rollback]
    H -- Sí --> J[Publicar estado + auditoría]
```

## 3) Flujo de datos multi-tenant

```mermaid
flowchart LR
    FE[Frontend] --> API[Backend API]
    API --> TM[Tenant Resolver]
    TM --> DBP[(DB Plataforma)]
    TM --> DBT[(DB Tenant/Schema)]
    API --> R[(Redis interno)]
    API --> SM[Secret Manager]
```

## 4) Lifecycle de archivado

```mermaid
flowchart TD
    X[Backups/Logs] --> Y{Edad archivo}
    Y -- <30d --> Z[Storage activo]
    Y -- >=30d --> T1[Tier 30d zstd/gz]
    Y -- >=180d --> T2[Tier 180d xz]
    T1 --> ENC1[Cifrado opcional]
    T2 --> ENC2[Cifrado opcional]
```

## 5) Monitoreo visual

```mermaid
flowchart LR
    Host[Host Metrics] --> P[Prometheus]
    Docker[Container Metrics] --> P
    Logs[System/Docker Logs] --> L[Loki]
    P --> G[Grafana]
    L --> G
    G --> Admin[Admin Console]
```

