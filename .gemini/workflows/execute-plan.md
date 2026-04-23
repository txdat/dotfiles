# Workflow: /execute-plan — Implement the Approved Plan

Plans directory: `docs/plans/`. Find plan by status `approved`/`in-progress`.
Gate: status must be `approved` or `in-progress`. Set `in-progress`. Read `GEMINI.md`.
No placeholders — if cannot do, say so; never write `// TODO`.

## Dependency Analysis
Classify Implementation Steps:
- **Independent**: different files, no shared state → parallel batch.
- **Sequential**: shares files/depends on prior output → ordered between batches.

## TDD Three-Phase Execution

**Phase 1 — RED** (main agent, sequential):
- *Feature/fix*: write test, run, confirm FAILS. Passing = implementation exists — fix or remove. Mark `[x]`. Print `🔴 Test N: <what it verifies>`.
- *Refactor*: run existing tests, confirm ALL PASS before coding. Add characterization tests if coverage insufficient. Mark `[x]`. Print `🔴 Coverage confirmed: <area>`.

**Phase 2 — GREEN**:
If ≤3 steps or all sequential → implement directly.

Otherwise, write context to `/tmp/gemini-ctx-$$.md`:
```
Plan: <path>
Stack: <detected stack>
Standards: <key points from GEMINI.md>
```
For independent batches, spawn concurrent `generalist` tools. Prompt:
- "Read /tmp/gemini-ctx-$$.md first."
- Assigned steps: N, M...
- Files in scope: <list>
- Off-limits: <files owned by other batches>
- Tests to pass: <test names>

Each `generalist`: implements assigned steps only, runs tests, no out-of-scope files, reports completion/tests/blockers.
Sequential steps run on main agent between batches.
Print `🟢 Step N: <what was implemented>`.

**Phase 3 — BLUE** (main agent, after batches):
Scope strictly to code written in Phase 2 — do NOT touch pre-existing code. Remove duplication, improve naming, simplify — no behavior changes. Re-run tests. Print `🔵 Refactor: <what was cleaned up>`.

## Scope Creep
Discovered work not in plan: STOP. Log under `## Discovered Scope` with size. Ask: include, separate task, or skip?

## Completion
All steps `[x]`: run lint + build. Update status `implemented`. Suggest `/review-code`.
