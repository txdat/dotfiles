# Workflow: /review-code — Code Change Review

Find active plan. Read it + `GEMINI.md`. Run `git diff main --stat`, `git diff main`, `git log main..HEAD --oneline`.

## Parallel Analysis
If diff <50 lines → review sequentially.

Otherwise, write shared context to `/tmp/gemini-ctx-$$.md`:
```
Plan: <path>
Standards: <key points from GEMINI.md>
Diff: <git diff main output>
Log: <git log main..HEAD --oneline output>
```
Spawn parallel `generalist` tasks for independent review dimensions:
**A — Correctness + TDD**: matches plan, checklist done, edge cases, silent exceptions. Tests before impl, failure paths covered, naming.
**B — Architecture + Data**: follows `GEMINI.md` layers, no leaked frameworks. Parameterized queries, scoped transactions, concurrency.
**C — Scope + Hygiene**: flag out-of-plan changes. No debug logs, commented code, unlinked TODOs, secrets.

Prompt each: "Read /tmp/gemini-ctx-$$.md first. Review: <assigned dimensions explicitly>. Report: blocking issues (File:Line — issue — why — fix), non-blocking issues, positives."

## Output
Aggregate findings:
```markdown
## Code Review Report
### Summary
### ✅ What's Good
### ❌ Blocking Issues (must fix before /dev:create-pr)
- File:Line — <issue> — <why> — <fix>
### ⚠️ Non-blocking Issues
### 🧪 TDD Check
- Tests committed before implementation: YES/NO/PARTIAL
- All Implementation Steps covered: YES/NO (list gaps)
### 🔍 Scope Check
- In-plan: <list>
- Out-of-plan: <list or "none">
### Verdict: PASS | PASS WITH NOTES | REWORK REQUIRED
```
If REWORK REQUIRED, offer inline fixes. If PASS/PASS WITH NOTES, update plan status to `reviewed`.
