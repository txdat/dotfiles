---
model: gpt-5.3-codex
description: Review code changes against the plan and project standards.
effort: high
---

# /review-code — Code Change Review

Plans directory: `docs/plans/`. Find active plan (status `in-progress`/`implemented`/`reviewed`). Read it plus `CODEX.md`. If no plan found, ask for review scope.

```bash
BASE_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
[ -z "$BASE_BRANCH" ] && BASE_BRANCH=main
```

Run: `git diff $BASE_BRANCH --stat`, `git diff $BASE_BRANCH`, `git log $BASE_BRANCH..HEAD --oneline`.

If diff <50 lines → review sequentially on the main agent, skip spawning.

Otherwise, write shared context to `/tmp/codex-ctx-<slug>.md`:
```
Plan: <path>
Standards: <key points from CODEX.md>
Diff: <git diff $BASE_BRANCH output>
Log: <git log $BASE_BRANCH..HEAD --oneline output>
Constraints: Read-only — do NOT modify any files. Report findings only.
```

Spawn parallel `code-quality-auditor` subagents. For each, substitute `<dimensions>` with its bullet list:

**Subagent A — Correctness + TDD**
- Correctness: implementation matches plan, all checklist steps done, edge cases handled, no silent exception swallowing
- TDD: test commits before impl commits (check log), tests cover failure paths, names `should_<expected>_when_<condition>`

**Subagent B — Architecture + Data**
- Architecture: follows `CODEX.md` layering, no framework dependencies leaking into domain
- Data: queries parameterized, transactions scoped correctly, concurrency handled (locks/versioning/idempotency)

**Subagent C — Scope + Hygiene**
- Scope: flag any changes not in the approved plan
- Hygiene: no debug logs, commented-out code, unlinked TODOs, or secrets

Prompt template:
```
Read `/tmp/codex-ctx-<slug>.md` first — follow Constraints exactly.

Review these dimensions only:
<dimensions>

Report: blocking issues (File:Line — issue — why — fix), non-blocking issues, positives.
```

Aggregate into:

```
## Code Review Report

### Summary
### ✅ What's Good
### ❌ Blocking Issues (must fix before /dev:create-pr)
- File:Line — <issue> — <why it matters> — <fix>
### ⚠️ Non-blocking Issues
### 🧪 TDD Check
- Tests committed before implementation: YES / NO / PARTIAL
- All Implementation Steps covered: YES / NO (list gaps)
### 🔍 Scope Check
- In-plan: <list>
- Out-of-plan: <list or "none">
### Verdict: PASS | PASS WITH NOTES | REWORK REQUIRED
```

If REWORK REQUIRED, offer to fix blocking issues inline. If PASS or PASS WITH NOTES, update plan status to `reviewed`.
