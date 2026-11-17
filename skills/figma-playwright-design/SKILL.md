---
name: figma-playwright-design
description: Turn authorized Figma designs into verified interfaces using Figma MCP for design context and Playwright for browser inspection and visual QA. Use for design-to-code work, visual comparison, responsive validation, and UI regression diagnosis.
license: MIT
metadata:
  domain: design
  role: Design Engineer
---

# Figma and Playwright Design Workflow

Use connected tools only within the files, projects, pages, and environments the user has authorized.

## Workflow

1. Read the target Figma frame through Figma MCP and identify layout, typography, color, spacing, reusable components, states, assets, and breakpoints.
2. Inspect the existing application before editing. Reuse its tokens and components where they match the design intent.
3. Implement the smallest coherent change. Keep design credentials in runtime secrets and never embed them in code, logs, screenshots, or skill files.
4. Start the approved local preview and use Playwright to inspect the rendered page at representative desktop and mobile sizes.
5. Compare hierarchy, geometry, typography, color, overflow, interaction states, keyboard navigation, and reduced-motion behavior.
6. Iterate on material discrepancies and run the project's relevant tests. Summarize verification evidence and any remaining differences.

Do not write back to Figma, publish a deployment, or accept destructive browser prompts unless the user explicitly authorized that action.

If either MCP is unavailable, state which part could not be verified and continue only with evidence available from the repository.
