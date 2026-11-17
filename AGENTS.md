# Contributor instructions

This is a public, portable skill pack for multiple agent runtimes.

## Scope

- Keep skills runtime-neutral unless a skill explicitly targets one product.
- Preserve user intent and authorization boundaries. Guidance never implies permission for an external action.
- Prefer focused skills over catch-all instructions and route to a narrower skill when appropriate.
- Do not encode private ports, hosts, credentials, customer data, internal paths, or operating procedures.

## Skill contract

Every `skills/<name>/SKILL.md` must use UTF-8, start with YAML frontmatter, define `name` and `description`, keep custom fields inside `metadata`, and match the lowercase kebab-case folder name.

Put substantial conditional guidance in `references/`, deterministic helpers in `scripts/`, and generated-output resources in `assets/`.

## Safety

- Use placeholders such as `<TOKEN>` and `<HOST>`.
- Require explicit authorization before consequential external writes, messages, deployments, deletions, purchases, or account changes.
- Prefer reversible changes and verify observable outcomes.
- Never commit operational snapshots, environment files, access tokens, cookies, private keys, or production data.
- Preserve upstream copyright and license notices when adapting vendored skills.

## Validation

```bash
python -m pip install PyYAML
python scripts/sync-manifests.py
for skill in skills/*; do python scripts/quick-validate.py "$skill"; done
```

Claude and Codex manifests must remain synchronized with all skill folders.
