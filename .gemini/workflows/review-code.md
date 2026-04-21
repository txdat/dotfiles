# Workflow: /review-code — Code Change Review

Find active plan (status `in-progress`/`implemented`/`reviewed`). Read it plus `GEMINI.md`.

**Review Criteria:**
- **Correctness**: implementation matches plan, all checklist steps done, edge cases handled, no silent exception swallowing.
- **Architecture**: follows `GEMINI.md` layering, no framework dependencies leaking into domain.
- **Data**: queries parameterized, transactions scoped correctly, concurrency handled (locks/versioning/idempotency).
- **TDD**: test commits before impl commits (check `git log`), tests cover failure paths, names `should_<expected>_when_<condition>`.
- **Scope**: flag any changes not in the approved plan.
- **Hygiene**: no debug logs, commented-out code, unlinked TODOs, or secrets.

**Output Structure:**
```markdown
## Code Review Report

### Summary
### ✅ What's Good
### ❌ Blocking Issues (must fix before /dev:create-pr)
- File:Line — <issue> — <why it matters> — <fix>
### ⚠️ Non-blocking Issues
### 🧪 TDD Check
### 🔍 Scope Check
### Verdict: PASS | PASS WITH NOTES | REWORK REQUIRED
```

If REWORK REQUIRED, offer to fix blocking issues inline. If PASS or PASS WITH NOTES, update plan status to `reviewed`.
