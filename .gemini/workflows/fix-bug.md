# Workflow: /fix-bug — Structured Bug Fix

Modes: `full fix` (diagnose & resolve), `diagnose only` (stop before code).
Data: symptom, expected behavior, reproduction steps, context. Read stack traces/test outputs.
Regressions: `git log --oneline -20` & `git diff main --stat`.

## Hypothesis Investigation
Generate 3–5 hypotheses ranked by probability.
If ≤2 hypotheses → investigate sequentially.

Otherwise, write context to `/tmp/gemini-ctx-$$.md`:
```
Symptom: <description>
Expected: <behavior>
Stack trace: <if available>
Git context: <log + diff stat>
Hypotheses: <ranked list>
```
Spawn parallel `generalist` tasks. Prompt: "Read /tmp/gemini-ctx-$$.md first. Investigate hypothesis: <N — description>. Find evidence using `grep_search` and `read_file`. Verdict: CONFIRMED / ELIMINATED / INCONCLUSIVE. If CONFIRMED: exact file:line, why it causes symptom."

Select first CONFIRMED. If none, retry INCONCLUSIVE sequentially.

## Root Cause
State before touching code:
```
Root Cause: <specific line/condition/assumption>
Why it manifests as: <link to symptom>
Why it was missed: <test gap or wrong assumption>
```
If `diagnose only`: stop here. Ask "Proceed with fix?". Do NOT touch code.

## Fix
Apply minimal fix — root cause only, no refactoring/new behavior. Mark debug logs `// DEBUG`. Run reproduction + affected tests. Remove `// DEBUG`.
Write regression test `should_not_<bad behavior>_when_<condition>`. Verify fail before fix, pass after. Update broken tests.

Append active plan under `## Bug Fixes`:
```markdown
### Fix: <date> — <symptom>
Root cause: <one line>
Fix: <file:line — what changed>
Regression test: <name>
```
Print "Bug fix complete. Run /review-code before /create-pr."
