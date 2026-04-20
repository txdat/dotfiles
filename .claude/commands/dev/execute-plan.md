---
model: sonnet
effort: medium
---

# /execute-plan — Implement the Approved Plan

Resolve `plansDirectory` from project `CLAUDE.md` (default: `plans/`). Find plan from $ARGUMENTS (full/partial name) or auto-discover by status `approved`/`in-progress`. If multiple, ask. If none, stop.

Gate: status must be `approved` or `in-progress`. Set status to `in-progress`. Read `CLAUDE.md` and `~/.claude/CLAUDE.md` for coding standards.

Partial runs: `/execute-plan <name> from <N>` starts at step N; `/execute-plan <name> <N>` runs only step N.

---

No placeholder implementations — if something can't be done, say so; never write `// TODO`. No silent scope expansion (see Scope Creep below).

**TDD two-phase execution:**

**Phase 1 — RED** (all Test Steps first): Write each test, run it, confirm it FAILS. A passing test with no implementation is wrong — fix it. Mark `[x]`. Print `🔴 Test N: <what it verifies>`.

**Phase 2 — GREEN** (all Implementation Steps after): Implement only enough to pass the corresponding test(s). Run targeted tests only — not the full suite. Fix failures before moving on. Mark `[x]`. Print `✅ Step N: <what was implemented>`.

Test commands by stack: Maven `mvn test -pl <module> -Dtest=<Class>` · Go `go test ./<pkg>/...` · Python `pytest <path> -q` · TypeScript `npm test -- --testPathPattern=<file>`.

---

**Scope creep**: if you discover work not in the plan, STOP. Log under `## Discovered Scope` with estimated size (small/medium/large). Ask: include in this task, separate task, or skip?

---

When all steps are `[x]`: run lint + build per `CLAUDE.md`. Update status to `implemented`. Print result and suggest next step: `/review-code`.
