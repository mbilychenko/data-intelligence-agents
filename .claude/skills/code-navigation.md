# Skill: Code Navigation

This skill defines how to find information before answering any question.
Follow this on every question — no exceptions.

---

## Step 1 — Read the index first

Before anything else, read `.data-agent/index.md`.

If it doesn't exist:
"This workspace hasn't been initialised yet.
Clone a repo into `repos/` and run `/init <repo-name>` to get started."

The index tells you:
- Which repos are mapped and what domains they own
- Where each repo's data map lives
- When each map was last generated

---

## Step 2 — Pick the right repo

Match the question to a repo using the `Domains` field in the index.

Examples:
- "order data" → repo that owns `orders`
- "customer email" → repo that owns `users` or `customers`
- "inventory levels" → repo that owns `inventory` or `products`

If unsure, check the entity list in each candidate repo's map.

If a question spans multiple repos (e.g. "how does an order in service A
trigger a notification in service B"):
- Start with the repo that owns the origin entity
- Trace using events/consumers across maps

---

## Step 3 — Load the data map

Read `.data-agent/<repo-name>.md` for the identified repo.
Read it fully before answering. The map has:

- **Entities** — tables, fields, relationships
- **Events** — message topics, producers, consumers
- **Data stores** — databases, caches, queues
- **API endpoints** — REST/GraphQL paths
- **Coverage gaps** — areas that may be incomplete

---

## Step 4 — Go to source code only when needed

The map covers ~80% of questions. Only open actual source files when:
- The map points to a file and you need exact field names/types
- The map shows `confidence: medium` or `low` for the relevant entity
- The analyst asks for something very specific (nullability, default value, index)
- A coverage gap suggests the map missed something relevant

When reading source files:
- Go directly to the file the map references
- Read only the relevant section
- Use Grep only as a last resort when the map gives no pointer

---

## Step 5 — Cross-repo tracing

When data flows across repos:
1. Load the origin repo map — find the event emitted
2. Check the index for which other repo lists that domain or event
3. Load that repo's map — find where it consumes/writes
4. Repeat until the chain ends

If a step in the chain has no map yet, say so:
"The data flow continues into `<repo-name>` but that repo hasn't been
initialised yet. Run `/init <repo-name>` to trace further."

---

## What not to do

- Do not browse repo directories looking for files
- Do not answer from training knowledge about frameworks — answer from the maps
- Do not skip the index step even if you think you know the answer
- Do not read files the map doesn't reference without a clear reason
