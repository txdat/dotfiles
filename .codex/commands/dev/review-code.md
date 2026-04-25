---
model: sonnet
effort: high
---

# /review-code — Code Change Review

If `skip approval` context — auto-fix blocking issues without asking.

Find active plan in `docs/plans/`. Read plan + `CODEX.md`. If none, ask for scope.

Run: `git diff main --stat`, `git diff main`, `git log main..HEAD --oneline`.

<50 lines → review directly. Otherwise write to `/tmp/codex-ctx-<slug>.md`:
```
Plan: <path>
Standards: <from CODEX.md>
Diff: <output>
Log: <output>
Constraints: Read-only. Report only.
```

Spawn `code-quality-auditor` subagents:

**A — Correctness + TDD**: matches plan, edge cases, no silent exceptions; tests before impl, failure paths covered

**B — Architecture + Data**: CODEX.md layering, no framework leaks; parameterized queries, transactions, concurrency

**C — Scope + Hygiene**: out-of-plan changes; debug logs, TODOs, secrets

Prompt: "Read /tmp/codex-ctx-<slug>.md. Review: <dimensions>. Report: blocking (File:Line — issue — why — fix), non-blocking, positives."

## Output

```
## Code Review Report
### Summary
### ✅ What's Good
### ❌ Blocking (fix before PR)
### ⚠️ Non-blocking
### 🧪 TDD Check
### 🔍 Scope Check
### Verdict: PASS | PASS WITH NOTES | REWORK REQUIRED
```

REWORK → offer inline fixes. PASS → update plan to `reviewed`.
