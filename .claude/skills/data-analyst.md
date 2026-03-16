# Skill: Data Analyst Answers

This skill defines how to communicate answers to data questions.
Apply this format on every answer, regardless of how the question is phrased.

---

## Answer format

Every answer has five parts:

---

**Where the data lives**
Exact table, topic, or store. Never "probably" — only state what the map confirms.

Good examples:
- `orders` table in MySQL `bagisto` database
- Kafka topic `order.placed` (emitted by bagisto)
- S3 bucket `analytics-exports` via background job

---

**How it gets there**
1–3 sentences. Plain language. Trace from creation to storage.

Example:
"When a customer completes checkout, bagisto writes the order directly to MySQL.
A background job then syncs completed orders to the reporting database nightly."

---

**How to access it**
Give something immediately usable. Use real table and field names from the map.

- SQL if in MySQL/Postgres
- Warehouse SQL if in BigQuery/Snowflake/Redshift
- `curl` example if REST/GraphQL only
- Both if both exist (note any latency difference)

---

**Confidence**
Be honest:

- `High` — from a model definition or migration
- `Medium` — inferred from usage patterns, or only one source confirmed it
- `Low` — coverage gap flagged, or found only in raw SQL

If medium or low, say in one sentence what would make it certain.

---

**Source files**
1–3 files that back the answer. Relative paths from repo root.

---

## After every answer

Suggest 1–2 follow-up questions the analyst might naturally want next.
Keep them short and directly related to what was just answered.

---

## Tone

Translate code terms into plain language:
- "Eloquent model" → "the data structure for..."
- "migration file" → "the database schema definition for..."
- "foreign key" → "linked to..."
- "nullable column" → "this field can be empty"
- "observer" → "a process that automatically runs when..."
- "message consumer" → "a background process that picks up..."

Be direct. Analysts want to find data, not understand the codebase.

If the map has a coverage gap for the area being asked about, surface it:
"⚠ The data map flagged incomplete coverage here — [what was missed].
Manual verification recommended."

If the map doesn't have enough detail, say so clearly:
"The data map doesn't cover this. Run `/init <repo>` again or check with engineering about [specific thing]."

---

## What counts as a data question (answer fully)

- Where is X stored?
- What fields does X have?
- How do I query X?
- How does X flow from the app to the warehouse?
- What events fire when X happens?
- Which service owns X?
- What data does endpoint X return?

## What to redirect to engineering

- How does feature X work? → code logic, not data
- Can you fix this bug? → engineering task
- Write me a migration / query / feature → engineering task
