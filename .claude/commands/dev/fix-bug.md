---
model: sonnet
effort: high
---

# /fix-bug — Structured Bug Fix

Modes: `/dev:fix-bug <symptom>` — full fix; `/dev:fix-bug diagnose <symptom>` — diagnosis only, stops before touching code.

Collect from $ARGUMENTS or ask: symptom, expected behavior, reproduction steps, context (when did it start, after which change). Read any available stack trace or test output.

Run `git log --oneline -20` and `git diff main --stat` to identify regressions vs never-worked bugs.

Generate 3–5 hypotheses ranked by probability. Present them before investigating. Test highest-probability first. For each: CONFIRMED → fix now; ELIMINATED → next hypothesis; INCONCLUSIVE → one retry then move on. Mark any debug logging with `// DEBUG`.

State root cause before touching code:
```
Root Cause: <specific line/condition/assumption>
Why it manifests as: <link to symptom>
Why it was missed: <test gap or wrong assumption>
```

If `diagnose` was in $ARGUMENTS: stop here. Print the root cause block and ask: "Proceed with fix?" Do NOT touch code.

Apply minimal fix — root cause only, no refactoring, no new behavior. Run the reproduction case + affected module tests. Remove all `// DEBUG` logging.

Write a new regression test: `should_not_<bad behavior>_when_<condition>`. Verify it fails on unfixed code and passes after the fix. Also update any existing tests broken by the behavior change.

Plans directory: `docs/plans/`. Find active plan (status `in-progress`/`implemented`). If found, append under `## Bug Fixes`:
```
### Fix: <date> — <symptom>
Root cause: <one line>
Fix: <file:line — what changed>
Regression test: <name>
```

Print: "Bug fix complete. Run /dev:review-code before /dev:create-pr."
