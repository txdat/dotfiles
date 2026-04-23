# Workflow: /simplify-code — Parallel Simplification

Target from input or ask. Read `GEMINI.md`. No new features/bugs.

## Analysis
If >1 file, write context to `/tmp/gemini-ctx-$$.md`. Spawn subagents per file.
Search: dead code, redundant logic, premature abstractions, over-engineering.

## Apply
Aggregate findings. Present summary. Ask "Apply?".
Apply changes. Run targeted tests. Revert failures.
Print lines removed and test status.
