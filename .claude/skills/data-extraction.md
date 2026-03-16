# Skill: Data Extraction

This skill defines how to scan a source repo and produce a data map.
Used by the `/init` command. Reusable across any project that needs repo scanning.

---

## Step 1 — Detect language(s)

Look for these files in the repo root and one level deep:

| File | Language/Framework |
|---|---|
| `composer.json` | PHP (likely Laravel) |
| `go.mod` | Go |
| `package.json` + `prisma/schema.prisma` | Node + Prisma |
| `package.json` + `*.entity.ts` | Node + TypeORM |
| `package.json` + `schema.graphql` or `*.graphql` | Node + GraphQL |
| `requirements.txt` or `pyproject.toml` + `models.py` | Python/Django |
| `requirements.txt` or `pyproject.toml` + `Base` in any `.py` | Python/SQLAlchemy |
| `pom.xml` or `build.gradle` | Java/Spring |

A repo can have multiple languages. List all detected.

---

## Step 2 — Target file patterns by language

Use Glob to find files. Do NOT read everything — target these patterns only.

### PHP / Laravel
```
app/Models/**/*.php
database/migrations/**/*.php
app/Events/**/*.php
app/Jobs/**/*.php
app/Observers/**/*.php
routes/api.php
routes/web.php
app/Http/Controllers/**/*Controller.php
```

### Python / Django
```
**/models.py
**/models/**/*.py
**/migrations/**/*.py
**/serializers.py
**/serializers/**/*.py
**/signals.py
```

### Python / SQLAlchemy
```
**/models.py
**/models/**/*.py
**/schema.py
**/database.py
**/db/**/*.py
```

### Node / Prisma
```
prisma/schema.prisma
**/*.graphql
**/schema.graphql
```

### Node / TypeORM
```
**/*.entity.ts
**/migrations/**/*.ts
**/dto/**/*.ts
```

### Go
```
**/models/**/*.go
**/model/**/*.go
**/db/**/*.go
**/repository/**/*.go
**/store/**/*.go
**/*.proto
```

### Java / Spring
```
**/entity/**/*.java
**/model/**/*.java
**/repository/**/*.java
**/dto/**/*.java
src/main/resources/**/*.xml
```

### Universal (always check, any language)
```
docker-compose.yml
docker-compose*.yml
openapi.yaml
openapi.json
swagger.yaml
swagger.json
.env.example
**/*.avsc
**/schema.json
```

---

## Step 3 — Find event / message bus references

After file glob, run Grep across the repo for these patterns to catch Kafka,
RabbitMQ, SQS, and similar regardless of language:

- `kafka` (case-insensitive)
- `topic` near `publish|emit|dispatch|produce|consume|subscribe`
- `rabbitmq|amqp`
- `sqs|sns` (AWS)
- `event.*dispatch|dispatch.*event`
- `publish\(|emit\(`

Limit grep to source files only (exclude `node_modules`, `vendor`, `.git`, `tests`, `docs`).

---

## Step 4 — Read files in batches

Read the discovered files in batches of 15. For each batch, extract:

### Entities (DB models / tables)
- Name, table name (if explicit), fields with types
- Relationships (belongs_to, has_many — note linked table, not code detail)
- Source file path
- Confidence: `high` if from model/migration, `medium` if inferred from usage

### Events / Messages
- Topic or event name
- Direction: `produces` or `consumes`
- What triggers it (user action, job, observer)
- What subscribes/consumes it (if visible in this repo)
- Source file path

### Data stores
- Type: `postgres`, `mysql`, `redis`, `mongodb`, `elasticsearch`, `bigquery`, `snowflake`, `s3`, etc.
- Connection name / database name (from `.env.example`, `docker-compose.yml`, config files)
- What it stores (infer from context)

### API endpoints
- Method + path (e.g. `GET /api/orders`)
- What data it returns or accepts
- Source file path

---

## Step 5 — Write the data map

Write to `.data-agent/<repo-name>.md` using this exact structure:

```markdown
# Data Map: <repo-name>
_Generated: <timestamp> | Language: <detected> | Files scanned: <count>_

---

## Entities

### <EntityName>
- **Table:** `<table_name>`
- **Store:** <postgres/mysql/etc> (`<db_name>`)
- **Key fields:** `id`, `<field>` (<type>), `<field>` (<type>), ...
- **Relationships:** linked to `<other_table>` via `<field>`
- **Confidence:** high / medium / low
- **Source:** `<relative/path/to/file>`

(repeat for each entity)

---

## Events

### <event.name>
- **Direction:** produces / consumes
- **Trigger:** <what causes this event>
- **Payload:** <key fields if visible>
- **Consumer:** <which service/job consumes it, or "unknown">
- **Source:** `<relative/path/to/file>`

(repeat for each event)

---

## Data Stores

| Type | Name | What it holds |
|---|---|---|
| postgres | `<db_name>` | <summary> |
| redis | `<connection>` | <summary> |

---

## API Endpoints

| Method | Path | Returns / Accepts |
|---|---|---|
| GET | `/api/orders` | order list |
| POST | `/api/orders` | creates order |

---

## Coverage Gaps

List any areas where the map may be incomplete:
- Area, what was missed, suggestion for manual verification

If nothing was missed, write: _No significant gaps detected._
```

---

## Step 6 — Update the index

Read `.data-agent/index.md` (create if it doesn't exist).
Add or update the entry for this repo:

```markdown
# Data Agent Index
_Last updated: <timestamp>_

## Repos

### <repo-name>
- **Path:** `repos/<repo-name>`
- **Language:** <detected>
- **Map:** `.data-agent/<repo-name>.md`
- **Last init:** <timestamp>
- **Domains:** <comma-separated list inferred from entity names>
- **Entities:** <count> | **Events:** <count> | **Stores:** <count>

(one block per repo)
```

For **Domains**: infer from entity names. E.g. entities Order, OrderItem, OrderStatus → domain `orders`. User, UserProfile → domain `users`.

---

## What to skip

- `vendor/`, `node_modules/`, `.git/` — always exclude
- Test files (`tests/`, `spec/`, `__tests__/`, `*_test.go`, `*.test.ts`) — skip unless no other source exists
- Frontend assets (`resources/js/`, `public/`, `static/`) — skip
- Documentation (`docs/`, `*.md`) — skip
- Lock files — skip
