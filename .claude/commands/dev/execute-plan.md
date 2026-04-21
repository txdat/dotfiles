---
model: sonnet
effort: medium
---

# /execute-plan — Implement the Approved Plan

Plans directory: `docs/plans/`. Find plan from $ARGUMENTS (full/partial name) or auto-discover by status `approved`/`in-progress`. If multiple, ask. If none, stop.

Gate: status must be `approved` or `in-progress`. Set status to `in-progress`. Read `CLAUDE.md` and `~/.claude/CLAUDE.md` for coding standards.

Partial runs: `/dev:execute-plan <name> from <N>` starts at step N; `/dev:execute-plan <name> <N>` runs only step N.

---

No placeholders — if something can't be done, say so; never write `// TODO`.

**TDD three-phase execution:**

**Phase 1 — RED**: Detect plan type:
- *Feature/fix*: write each test, run it, confirm it FAILS. A passing test means the implementation already exists — fix or remove the test. Mark `[x]`. Print `🔴 Test N: <what it verifies>`.
- *Refactor*: run existing tests covering the target area, confirm they ALL PASS before touching code. If coverage is insufficient, add characterization tests that pass now and must continue to pass. Mark `[x]`. Print `🔴 Coverage confirmed: <area>`.

**Phase 2 — GREEN**: Implement only enough to pass the corresponding test(s). Run targeted tests only — not the full suite. Fix failures before moving on. Mark `[x]`. Print `🟢 Step N: <what was implemented>`.

**Phase 3 — BLUE**: Scope strictly to code written or modified in Phase 2 — do NOT touch pre-existing code. Remove duplication, improve naming, simplify structure — no behavior changes. Re-run targeted tests to confirm all still pass. Print `🔵 Refactor: <what was cleaned up>`.

Test commands by stack: Maven `mvn test -pl <module> -Dtest=<Class>` · Go `go test ./<pkg>/...` · Python `pytest <path> -q` · TypeScript `npm test -- --testPathPattern=<file>`.

---

**Scope creep**: if you discover work not in the plan, STOP. Log under `## Discovered Scope` with estimated size (small/medium/large). Ask: include in this task, separate task, or skip?

---

When all steps are `[x]`: run lint + build per `CLAUDE.md`. Update status to `implemented`. Print result and suggest next step: `/dev:review-code`.
