# Workflow: /fix-bug — Structured Bug Fix

Modes: `full fix` (diagnose & resolve), `diagnose only` (stop before code).

1. **Data**: symptom, expected behavior, reproduction steps, context. Read stack traces/test outputs.
2. **Regressions**: run `git log --oneline -20` & `git diff main --stat` to identify regressions.
3. **Hypothesize**: generate 3–5 hypotheses ranked by probability. Present before investigating.
4. **Investigate**: test highest-probability first. CONFIRMED → fix; ELIMINATED → next; INCONCLUSIVE → retry once, move on. Mark debug logs `// DEBUG`.
5. **Root Cause**: State before touching code:
   ```markdown
   Root Cause: <specific line/condition/assumption>
   Why it manifests as: <link to symptom>
   Why it was missed: <test gap or wrong assumption>
   ```
6. **Diagnose Only**: Stop here if requested. Ask: "Proceed with fix?". Do NOT touch code.
7. **Fix**: root cause only, no refactor, no new behavior. Run reproduction + affected tests. Remove `// DEBUG` logs.
8. **Verify**: write regression test `should_not_<bad behavior>_when_<condition>`. Verify fail before fix, pass after.

Plans dir: `docs/plans/`. Append active plan under `## Bug Fixes`:
```markdown
### Fix: <date> — <symptom>
Root cause: <one line>
Fix: <file:line — what changed>
Regression test: <name>
```
