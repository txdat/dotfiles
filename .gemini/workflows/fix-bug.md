# Workflow: /fix-bug — Structured Bug Fix

Modes: `full fix` — diagnose and resolve; `diagnose only` — stops before touching code.

1. **Collect Data**: symptom, expected behavior, reproduction steps, context (when did it start, after which change). Read any available stack trace or test output.
2. **Identify Regressions**: run `git log --oneline -20` and `git diff main --stat` to identify regressions vs never-worked bugs.
3. **Hypothesize**: generate 3–5 hypotheses ranked by probability. Present them before investigating.
4. **Investigate**: test highest-probability first. For each: CONFIRMED → fix now; ELIMINATED → next hypothesis; INCONCLUSIVE → one retry then move on.
5. **State Root Cause** before touching code:
   ```markdown
   Root Cause: <specific line/condition/assumption>
   Why it manifests as: <link to symptom>
   Why it was missed: <test gap or wrong assumption>
   ```
6. **Apply Minimal Fix**: root cause only, no refactoring, no new behavior. Run the reproduction case + affected module tests.
7. **Verify**: Write a new regression test: `should_not_<bad behavior>_when_<condition>`. Verify it fails on unfixed code and passes after the fix.

Plans directory: `docs/plans/`. Find active plan. If found, append under `## Bug Fixes`:
```markdown
### Fix: <date> — <symptom>
Root cause: <one line>
Fix: <file:line — what changed>
Regression test: <name>
```
