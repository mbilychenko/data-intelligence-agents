# Command: /refresh

> **Not yet implemented.**
> Run `/init <repo-name>` to rebuild the map from scratch.

---

## Planned behaviour (future)

`/refresh` will be a smarter alternative to `/init` — it will:

1. `git pull` the latest code in `repos/<repo-name>`
2. Diff against the last init to find changed files
3. Re-scan only data-relevant changed files (models, migrations, schemas, events)
4. Merge updates into the existing map rather than rebuilding from scratch
5. Report what changed (new entities, modified fields, new events)

This makes refreshing large repos fast — only changed files are re-read.

---

## When to use /init instead (now)

- After cloning a new repo
- After significant changes to the codebase
- When the map seems stale or incomplete

```
/init <repo-name>
```
