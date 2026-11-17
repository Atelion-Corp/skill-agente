# Contributing

Contributions are welcome through focused pull requests.

1. Create a short-lived branch.
2. Keep skills portable and never include private infrastructure or credentials.
3. Keep custom frontmatter values under `metadata`.
4. Preserve attribution for adapted third-party work.
5. Synchronize manifests and validate:

```bash
python -m pip install PyYAML
python scripts/sync-manifests.py
for skill in skills/*; do python scripts/quick-validate.py "$skill"; done
```

Explain the use case and validation evidence in the pull request. Report security issues privately.
