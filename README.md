# Atelion Agent Skills

Open-source skill pack for Codex, Claude Code, OpenCode, and compatible agents. It contains 118 editable skills covering engineering, DevOps, design, marketing, security, automation, writing, presentations, calendar planning, business operations, and multi-agent coordination.

## Included

- **Atelion skills:** engineering, product, operations, finance, HR, data, design, marketing, automation, productivity, and orchestration.
- **Design craft:** skills adapted from Emil Kowalski, Impeccable, Taste Skill, Magic UI, and SmoothUI.
- **Security:** Cloudflare's defensive security-audit workflow.
- **Instagram:** planning, reels, stories, carousels, captions, engagement, DMs, audits, and repurposing.

All imported skills retain their upstream attribution and licenses in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) and [`third_party/`](third_party/). They are vendored into this repository so they can be reviewed, simplified, and adapted to local requirements without depending on a live upstream checkout.

Skills do not contain credentials and do not grant permissions that the agent runtime does not already have.

## Install

### Linux server — all skills

```bash
git clone https://github.com/Atelion-Corp/skill-agente.git
cd skill-agente
./scripts/install-skills.sh
```

For a persistent agent home:

```bash
./scripts/install-skills.sh --dest /path/to/agent-home/.codex/skills
```

Install only selected skills by adding their folder names:

```bash
./scripts/install-skills.sh automation-engineer content-writer security-audit impeccable
```

Existing folders are not overwritten unless `--force` is supplied. Forced updates first move each previous folder to a timestamped backup.

### Codex skill installer

Install one or more paths from `Atelion-Corp/skill-agente`, for example:

```text
skills/automation-engineer
skills/calendar-planner
skills/presentation-designer
```

Start a new agent turn after installation so discovery refreshes.

### Claude Code

Add the repository as a local plugin or marketplace source. The complete manifest is in `.claude-plugin/plugin.json`.

## Main categories

| Category | Examples |
| --- | --- |
| Orchestration | `super-orquestador`, `agent-context`, `area-eng`, `area-design` |
| Programming | `eng-backend`, `eng-frontend`, `eng-database`, `eng-qa`, `write-swift` |
| DevOps and security | `eng-devops`, `deploy-guardian`, `stack-guardian`, `security-audit` |
| Design and motion | `impeccable`, `design-taste-frontend`, `emil-design-eng`, `figma-playwright-design` |
| UI libraries | `magic-ui`, `smoothui`, `unlumen-ui`, `pick-ui-library` |
| Marketing | `mkt-pipeline`, `mkt-copy`, `mkt-seo`, `mkt-cro`, `ig-plan` |
| Automation and work | `automation-engineer`, `workplace-assistant`, `calendar-planner` |
| Writing and presentations | `content-writer`, `presentation-designer`, `docs-autocomplete` |
| Product and business | `product-manager`, `ops-pm`, `data-analyst`, `finance-analyst` |

Browse [`skills/`](skills/) for the full catalog. Each skill's frontmatter description controls automatic discovery.

## Optional integrations

Some workflows become more capable when the runtime separately connects:

- Figma MCP for authorized design-file inspection and edits.
- Playwright for browser rendering, interaction, and visual verification.

Those integrations are intentionally not bundled with credentials or enabled automatically. Configure them in the target runtime and keep tokens outside this repository.

## Validate

```bash
python -m pip install PyYAML
python scripts/sync-manifests.py
for skill in skills/*; do python scripts/quick-validate.py "$skill"; done
```

CI runs the same checks and scans the complete Git history with Gitleaks.

## Contributing

Keep skills focused and portable. Never add private hosts, customer data, credentials, cookies, environment files, or production snapshots. After adding or renaming a skill, run the manifest synchronizer and full validation.

See [CONTRIBUTING.md](CONTRIBUTING.md) and [SECURITY.md](SECURITY.md). The Atelion code is MIT licensed; vendored content follows the licenses listed in the third-party notices.
