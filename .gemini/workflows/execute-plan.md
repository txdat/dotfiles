# Workflow: /execute-plan — Implement the Approved Plan 🔴🟢🔵

Plans directory: `docs/plans/`. Find plan by status `approved`/`in-progress`.

Gate: status must be `approved` or `in-progress`. Set status to `in-progress`. Read `GEMINI.md` for coding standards.
No placeholders — if something can't be done, say so; never write `// TODO`.

## Dependency Analysis
Classify each Implementation Step:
- **Independent**: touches different files, no shared state → parallel batch.
- **Sequential**: shares files or depends on prior output → ordered between batches.

## TDD Three-Phase Execution

**Phase 1 — RED** (main agent, sequential):
- *Feature/fix*: write each test, run it, confirm FAILS. Passing test = implementation exists — fix or remove it. Mark `[x]`. Print `🔴 Test N: <what it verifies>`.
- *Refactor*: run existing tests, confirm ALL PASS before touching code. Add characterization tests if coverage insufficient. Mark `[x]`. Print `🔴 Coverage confirmed: <area>`.

**Phase 2 — GREEN**:
If ≤3 steps total or all steps sequential → implement directly, skip delegating.

Otherwise, write shared context to `/tmp/gemini-ctx-$$.md`:
```
Plan: <path>
Stack: <detected stack>
Standards: <key points from GEMINI.md>
```
For each independent batch, use the `generalist` tool concurrently. Prompt each:
- "Read /tmp/gemini-ctx-$$.md first."
- Assigned steps: N, M, ...
- Files in scope: <list>
- Off-limits: <files owned by other batches>
- Tests to pass: <test names for assigned steps>

Each `generalist`: implements assigned steps only, runs targeted tests, does NOT touch out-of-scope files, reports steps completed + tests passing + blockers.
Sequential steps run on the main agent between batches.
Print `🟢 Step N: <what was implemented>` as each completes.

**Phase 3 — BLUE** (main agent, after all batches complete):
Scope strictly to code written in Phase 2 — do NOT touch pre-existing code. Remove duplication, improve naming, simplify — no behavior changes. Re-run targeted tests. Print `🔵 Refactor: <what was cleaned up>`.

**Scope Creep**: Discovered work not in the plan: STOP. Log under `## Discovered Scope` with size. Ask: include, separate task, or skip?

**Completion**: All steps `[x]`: run lint + build. Update status to `implemented`. Suggest: `/dev:review-code`.
