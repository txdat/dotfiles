---
model: sonnet
effort: high
---

# /execute-plan — Implement the Approved Plan

Plans directory: `docs/plans/`. Find plan from $ARGUMENTS (full/partial name) or auto-discover by status `approved`/`in-progress`. If multiple, ask. If none, stop.

Gate: status must be `approved` or `in-progress`. Set status to `in-progress`. Read `CLAUDE.md` and `~/.claude/CLAUDE.md` for coding standards.

Partial runs: `/dev:execute-plan <name> from <N>` starts at step N; `/dev:execute-plan <name> <N>` runs only step N.

No placeholders — if something can't be done, say so; never write `// TODO`.

## Dependency Analysis

Classify each Implementation Step:
- **Independent**: touches different files, no shared state → parallel batch
- **Sequential**: shares files or depends on prior output → ordered between batches

Per batch, select agent:
- **`rapid-coder`**: existing pattern confirmed via Grep/LSP, no edge cases, no security sensitivity
- **`dedicated-coder`**: no existing pattern, edge cases present, security/external integrations
- Mixed or uncertain → `dedicated-coder`

## TDD Three-Phase Execution

**Phase 1 — RED** (main agent, sequential):
- *Feature/fix*: write each test, run it, confirm FAILS. Passing test = implementation exists — fix or remove it. Mark `[x]`. Print `🔴 Test N: <what it verifies>`.
- *Refactor*: run existing tests, confirm ALL PASS before touching code. Add characterization tests if coverage insufficient. Mark `[x]`. Print `🔴 Coverage confirmed: <area>`.

**Phase 2 — GREEN**:

If ≤3 steps total or all steps sequential → implement on main agent, skip spawning.

Otherwise, write shared context to `/tmp/claude-ctx-<slug>.md`:
```
Plan: <path>
Stack: <detected stack>
Standards: <key points from CLAUDE.md>

Constraints:
- Implement ONLY your assigned steps. Touch NO other files.
- No placeholders. Never write `// TODO`. If blocked, stop and report.
- Run ONLY tests for your assigned steps. Never the full suite.
- Scope creep: STOP and report; do not implement.
- TDD: assigned tests must be RED before you write code; verify GREEN after.
```

For each independent batch, spawn the selected subagent with this prompt:
```
Read `/tmp/claude-ctx-<slug>.md` first — follow Constraints exactly.

Assigned steps: N, M, ...
Files in scope: <list>
Off-limits (do NOT touch): <files owned by other batches>
Tests to pass: <test names for assigned steps>

Report: steps completed, tests passing, blockers.
```

Sequential steps run on the main agent between batches.

Print `🟢 Step N: <what was implemented>` as each completes.

**Phase 3 — BLUE** (main agent, after all batches complete):
Scope strictly to code written in Phase 2 — do NOT touch pre-existing code. Remove duplication, improve naming, simplify — no behavior changes. Re-run targeted tests. Print `🔵 Refactor: <what was cleaned up>`.

## Test Commands

Maven `mvn test -pl <module> -Dtest=<Class>` · Go `go test ./<pkg>/...` · Python `pytest <path> -q` · TypeScript `npm test -- --testPathPattern=<file>`

## Scope Creep

Discovered work not in the plan: STOP. Log under `## Discovered Scope` with size (small/medium/large). Ask: include, separate task, or skip?

## Completion

All steps `[x]`: run lint + build + targeted tests per `CLAUDE.md` — never the full suite. Update status to `implemented`. Suggest: `/dev:review-code`.
