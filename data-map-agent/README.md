# Data Intelligence Agent

A Claude Code workspace that helps analysts, PMs, and data teams answer questions like:
- *Where is order data stored?*
- *What fields does the customer table have?*
- *What events fire when a payment fails?*
- *How does signup data flow into the warehouse?*

Works with any git repo. Supports PHP, Python, JS/TS, Go, Java — or a mix.

---

## How it works

1. **Clone** a repo into `repos/`
2. **Run `/init <repo-name>`** inside Claude Code — Claude scans the repo and builds a data map in `.data-agent/`
3. **Ask questions** in plain English — Claude navigates the pre-built map to answer with table names, SQL, and source file references

The init scan is a one-time cost. After that, questions are fast — Claude reads the map, not the whole codebase.

---

## Setup

```bash
# Clone a repo (manual)
git clone https://github.com/your-org/your-repo repos/your-repo

# Or use the helper script
./setup.sh https://github.com/your-org/your-repo

# Open Claude Code in this workspace
claude

# Build the data map
/init your-repo
```

No API key needed. No Python. Claude Code does the scanning natively.

---

## Multiple repos

Add as many repos as you need — Claude tracks them all in `.data-agent/index.md` and picks the right one per question.

```bash
./setup.sh https://github.com/org/service-a
./setup.sh https://github.com/org/service-b

# Inside Claude Code
/init service-a
/init service-b

# Claude now answers across both
> where does service-a write events that service-b consumes?
```

---

## Commands

| Command | What it does |
|---|---|
| `/init <repo-name>` | Full scan — builds or rebuilds the data map |
| `/init <repo-name> --light` | Light scan — schemas, migrations, events only (faster for large secondary services) |
| `/refresh <repo-name>` | Not yet implemented — run `/init` again to rebuild |

---

## File structure

```
repos/                         ← your git clones (not modified by init)
.data-agent/
  index.md                     ← registry of all repos and their domains
  <repo-name>.md               ← data map per repo (auto-generated)
.claude/
  skills/
    data-extraction.md         ← how Claude scans a repo (any language)
    data-analyst.md            ← how Claude formats answers
    code-navigation.md         ← how Claude uses the index and maps
  commands/
    init.md                    ← /init command definition
    refresh.md                 ← /refresh stub (future)
CLAUDE.md                      ← agent identity
setup.sh                       ← helper for cloning repos
```

---

## Supported languages

| Language / Framework | What gets mapped |
|---|---|
| PHP / Laravel | Models, migrations, Events, Jobs, Observers, routes |
| Python / Django | models.py, migrations, serializers, signals |
| Python / SQLAlchemy | model classes, schema files |
| Node / Prisma | schema.prisma, GraphQL types |
| Node / TypeORM | entity files, migrations, DTOs |
| Go | structs in models/db/repository, proto files |
| Java / Spring | entity/model/repository/dto classes |
| Any | docker-compose, OpenAPI specs, .env.example, Avro schemas |

---

## Known limitations

- **Static analysis only** — runtime config (e.g. Redis overriding a DB session) needs manual verification
- **Large repos** — init scans targeted directories, not every file. Coverage warnings appear where gaps are suspected
- **Unconventional structure** — works best with standard framework conventions; raw SQL or unusual ORMs surface at medium/low confidence
- **Cross-repo lineage** — works only if all relevant repos have been initialised
