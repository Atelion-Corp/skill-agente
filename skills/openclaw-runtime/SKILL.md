---
name: openclaw-runtime
description: OpenClaw-first runtime policy for all agents and skills. Defines single runtime execution, RBAC, allowlist SSH policy, and audit requirements.
license: MIT
---

# openclaw-runtime

Use this skill when the task requires runtime governance, safe execution controls, or OpenClaw operational defaults.

## Goals

- Enforce OpenClaw as the only runtime.
- Apply RBAC and command allowlist before execution.
- Ensure every run has audit metadata and bounded timeout.

## Required checks

1. Load `config/openclaw-runtime.json`.
2. Confirm `contracts/skills-contracts.json` exists.
3. Confirm allowlist file exists (`config/ssh-command-allowlist.txt`).
4. Reject execution when any mandatory control is missing.

## Output format

- `decision`
- `controls_checked`
- `missing_controls`
- `execution_policy`

