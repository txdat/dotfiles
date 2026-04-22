# Workflow: /review-code — Code Change Review

Find active plan. Read it + `GEMINI.md`. Run `git diff main --stat`, `git diff main`, `git log main..HEAD --oneline`.

**Criteria:**
- **Correctness**: matches plan, checklist done, edge cases handled, no silent exceptions.
- **Architecture**: follows `GEMINI.md` layers, no leaked frameworks.
- **Data**: parameterized queries, scoped transactions, handled concurrency.
- **TDD**: tests before impl (check `git log`), failure paths covered, names `should_<expected>_when_<condition>`.
- **Scope**: flag out-of-plan changes.
- **Hygiene**: no debug logs, commented code, unlinked TODOs, secrets.

**Output:**
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
