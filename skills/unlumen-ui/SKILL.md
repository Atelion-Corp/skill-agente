---
name: unlumen-ui
description: Design and implement polished React interfaces using patterns and components inspired by the Unlumen UI catalog. Use when selecting, adapting, or reviewing animated UI blocks from ui.unlumen.com while preserving accessibility, performance, and the project's design system.
license: MIT
metadata:
  domain: design
  role: UI Engineer
---

# Unlumen UI

Use Unlumen as a pattern catalog, not as permission to copy unknown code blindly.

## Workflow

1. Inspect the current project stack, tokens, component conventions, motion preferences, and accessibility requirements.
2. Consult `https://ui.unlumen.com/` for the requested pattern and confirm the current usage or license terms before bringing source code into the project.
3. Prefer adapting the visual behavior to existing primitives over adding a duplicate UI framework.
4. Preserve semantic HTML, keyboard operation, visible focus, reduced-motion behavior, responsive layout, and adequate contrast.
5. Keep animation GPU-friendly and avoid unnecessary dependencies, client-side JavaScript, and layout thrashing.
6. Render the result in a real browser, test relevant states and breakpoints, and report any intentional differences from the reference.

Never add credentials, private design assets, or unlicensed third-party material to the repository.
