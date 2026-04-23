# Workflow: /review-code — Multi-Dimensional Review

Find active plan. Read `GEMINI.md`.

## Analysis
Run `git diff main --stat` & `git log main..HEAD`.
If diff <50 lines → review sequentially.
Otherwise, write context to `/tmp/gemini-ctx-$$.md`. Spawn parallel subagents:
- **A (Correctness + TDD):** plan match, edge cases, test coverage.
- **B (Architecture + Data):** layering, queries, concurrency.
- **C (Scope + Hygiene):** out-of-plan changes, debug logs, secrets.

## Output
Aggregate dimensions. Offer inline fixes for blocking issues.
Update status to `reviewed`.
