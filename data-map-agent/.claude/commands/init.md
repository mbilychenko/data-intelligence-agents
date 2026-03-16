# Command: /init

Build or rebuild the data map for a repository.

## Usage
```
/init <repo-name>
/init <repo-name> --light
```

`<repo-name>` is the folder name inside `repos/`.
Default is full scan. `--light` scans only schemas, migrations, and events — skips model internals. Use for large secondary services.

---

## Steps

### 1 — Check the repo exists

Look for `repos/<repo-name>/` in the workspace.

If not found, stop and say:
```
Can't find repos/<repo-name>/.

Clone it first:
  git clone <url> repos/<repo-name>
  (or: ./setup.sh <git-url>)

Then run /init <repo-name> again.
```

### 2 — Detect what's in the repo

Check for language marker files (`composer.json`, `go.mod`, `package.json`, `requirements.txt`, `pyproject.toml`).
Count files in key source directories (models, migrations, etc.) to estimate scope.
Check whether `.data-agent/<repo-name>.md` already exists.

Report to the user:
```
Found: PHP/Laravel + JavaScript repo
Relevant files: ~340
Previous map: none
Mode: full scan
```

If a previous map exists, ask:
```
A map already exists for <repo-name> (last built: <date>).
Rebuild it? This will replace the existing map. (yes/no)
```
Stop if the user says no.

### 3 — Run the extraction

Follow the **data-extraction skill** (`@.claude/skills/data-extraction.md`) exactly.

Show progress as you go:
```
Scanning PHP models...        (found 42 files)
Scanning migrations...        (found 87 files)
Scanning events/jobs...       (found 23 files)
Scanning API routes...        (found 3 files)
Searching for event bus refs... (done)
Reading files in batches...   (batch 1/10)
...
Writing data map...
Updating index...
```

### 4 — Validate the output

After writing `.data-agent/<repo-name>.md`, read it back and check:
- At least one entity was found
- At least one data store was identified

If the map looks empty or suspiciously small, warn:
```
⚠ The map has very few entries. This may mean:
- The repo uses an unconventional structure
- Key source directories weren't found
- Try /init <repo-name> --light to see if that helps

You can still ask questions, but answers may be incomplete.
```

### 5 — Final report

```
✓ Init complete: <repo-name>

  Language:        <detected>
  Entities:        <count>
  Events:          <count>
  Data stores:     <count> (<type/name>, ...)
  API endpoints:   <count>

  Coverage gaps: <count>
  <list gaps if any>

  Map: .data-agent/<repo-name>.md

  Ready. Ask me anything about data in <repo-name>.
```
