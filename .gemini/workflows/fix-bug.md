# Workflow: /fix-bug — Structured Bug Fix

Modes: `full fix` or `diagnose only`.

1. **Collect:** Symptom, expected behavior, reproduction. Read stack traces.
2. **Regressions:** `git log --oneline -20` & `git diff main --stat`.
3. **Hypothesize:** Generate 3–5 hypotheses.
4. **Investigate:** If >2 hypotheses, write context to `/tmp/gemini-ctx-$$.md` and spawn parallel subagents. Select first CONFIRMED hypothesis.
5. **Root Cause:** State specific line/condition, manifesting link, and why missed.
6. **Fix:** Apply minimal fix. run reproduction + affected tests.
7. **Verify:** Write regression test `should_not_<bad>_when_<cond>`. Update broken tests.

Append to active plan under `## Bug Fixes`.
Print: "Bug fix complete. Run /review-code."
