---
name: docs-autocomplete
description: Updates technical documentation periodically by consolidating validation reports, architecture changes, and operational logs into structured markdown summaries with diagrams references.
license: MIT
---

# docs-autocomplete

Use this skill to keep architecture and operations docs fresh without exposing secrets.

## Inputs

- validation reports JSON/CSV
- deploy/audit logs
- monitoring summaries

## Output

- updated markdown changelog
- docs gap list
- next suggested diagrams/sections

## Guardrails

- never include credentials/secrets
- only summarize metadata and technical events
- keep references to source files

