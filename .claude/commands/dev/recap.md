---
model: sonnet
effort: low
---

# /recap — Session Insights & Memory Capture

## Purpose
Close the session by extracting what matters — decisions made, patterns learned,
traps discovered, and anything future-you needs to remember.
Write it to the right place so it survives beyond this session.

---

## Step 1: Load Session Context

Resolve plans directory: read `plansDirectory` from project `CLAUDE.md`. If not set, default to `plans/`. Use this as `<plansDir>` throughout.

Resolve the active plan file: find the `.md` in `<plansDir>` with status `in-progress`, `implemented`, `reviewed`, or `pr-created`. If multiple match, ask the user which one. Read it in full.
Run: `git diff main --stat` and `git log main..HEAD --oneline`

Also ask the user: "Anything specific you want captured that might not be in the task file?"

---

## Step 2: Extract Insights

Analyze the session and extract across these 4 categories:

### 📌 Facts (permanent decisions for this project)
Decisions made this session that future Claude instances must know to avoid re-litigating.
Ask: "If a new engineer (or a new Claude session) starts on this project tomorrow, 
what must they know that isn't obvious from the code?"

Examples:
- "Ledger entries are immutable after write — enforced at application layer, not just DB"
- "Idempotency keys expire after 24h, managed by pg_cron job in migration V012"

### 🔁 Patterns (reusable approaches)
Implementation patterns applied that will recur.
Ask: "Did I solve something in a non-obvious way that I'll need to repeat?"

Examples:
- "Idempotency: read-check-write inside SERIALIZABLE transaction, not application lock"
- "Outbox event always emitted after aggregate state change, never before"

### ⛔ Anti-patterns (traps discovered)
Things that failed, were reverted, or caused bugs.
Ask: "What should I never do again? What assumption was wrong?"

Examples:
- "Do NOT use Redis for idempotency — consistency gap caused phantom duplicates under load"
- "Do NOT wrap domain events in Spring @Transactional — breaks port isolation"

### 💡 Concepts (language, framework, database, architecture)
Named concepts — from programming languages, frameworks, databases, or system design — that were applied or learned this session. Capture these so future sessions can reference them by name rather than re-explaining from scratch.

Sub-categories:
- **Language/Framework**: Java virtual threads, Spring lifecycle hooks, Python asyncio patterns, etc.
- **Database**: PostgreSQL MVCC, index-only scans, advisory locks, partition pruning, etc.
- **Architecture**: SAGA pattern, hexagonal architecture, outbox pattern, CQRS, event sourcing, etc.

Ask: "Was a named concept applied here that I should have on record — even if I already knew it?"

Each concept entry must include a brief description (1–5 lines) covering: what it is, when to use it, and any key constraint or trade-off observed this session.

Examples:
- **SAGA (choreography)**: A distributed transaction pattern where each service publishes events and reacts to others' events to complete or compensate. No central coordinator. Use when services must stay decoupled. Trade-off: harder to trace the overall flow.
- **Hexagonal architecture**: Isolates the domain from frameworks and infrastructure. Ports define interfaces; adapters implement them. Domain layer has zero framework imports — enforced at compile time.
- **PostgreSQL advisory locks**: Session-scoped named locks for distributed mutual exclusion. Acquired with `pg_try_advisory_lock(key)`. Released on session close or explicit unlock. Lighter than table locks; no automatic rollback on transaction end.

### 🔧 Command Improvements (workflow gaps)
Did any /command feel incomplete, unclear, or missing for this session?
Note what would have helped.

---

## Step 3: Decide Where Each Insight Lives

For each extracted insight, classify the target:

| Scope | Target file |
|---|---|
| This project only | `<repo>/CLAUDE.md` under relevant section |
| All projects (generic engineering) | `~/.claude/CLAUDE.md` under relevant section |
| Repeatable workflow | New `~/.claude/commands/<name>.md` |

---

## Step 4: Present Before Writing

Show the user the full extraction:

```
## Recap: <task name> — <date>

### 📌 Facts → <repo>/CLAUDE.md
- ...

### 🔁 Patterns → <repo>/CLAUDE.md  
- ...

### ⛔ Anti-patterns → <repo>/CLAUDE.md
- ...

### 💡 Concepts → <repo>/CLAUDE.md
- ...

### 🔧 Command Improvements (noted only, not written)
- ...
```

Ask: "Does this look right? Remove, edit, or add anything before I save."

---

## Step 5: Write Approved Insights

Append to target files under the correct section headers.
Never overwrite — always append.
If a section header doesn't exist yet, create it.

Example appended block in CLAUDE.md:
```markdown
## Learned Patterns
<!-- <task-slug> <date> -->
- Idempotency check: SERIALIZABLE tx wrapping read-check-write, not Redis lock

## Anti-patterns
<!-- <task-slug> <date> -->
- Do NOT use Redis for idempotency key storage — see task 2025-01-15-idempotency
```

---

## Step 6: Archive the Task

Update status in the resolved plan file to `archived`.
Print the plan filename.

---

## Step 7: Session Close Summary

Print:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Session recap complete.

Task: <name>
PR: <url or 'not yet created'>
Plan: <plansDir>/<filename> (archived)

Written to <repo>/CLAUDE.md:
  + <N> facts
  + <N> patterns  
  + <N> anti-patterns
  + <N> concepts

Written to ~/.claude/CLAUDE.md:
  + <N> generic patterns

Session closed. ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
