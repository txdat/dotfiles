# Workflow: /execute-plan — Implement the Approved Plan

Plans dir: `docs/plans/`. read `GEMINI.md`. zero placeholders (`// TODO`).

## Dependency Analysis
Classify steps:
- **Independent:** touches different files, no shared state → parallel batch.
- **Sequential:** shares files/depends on prior output → ordered between batches.
Per batch, select agent: `rapid-coder` (pattern exists) or `dedicated-coder` (edge cases/security).

## TDD Execution
1. **Phase 1 — RED** (main agent): Feature/fix = failing test. Refactor = passing coverage confirmed.
2. **Phase 2 — GREEN:**
   - If ≤3 steps or sequential: implement on main agent.
   - Otherwise, write context to `/tmp/gemini-ctx-$$.md`. Spawn parallel batches. Prompt subagents to read context, assigning specific steps and files.
3. **Phase 3 — BLUE** (main agent): Clean up code from Phase 2. Simplify naming, remove duplication. re-run tests.

## completion
Run lint + build. Update status `implemented`. Suggest `/review-code`.
