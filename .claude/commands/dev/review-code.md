---
model: sonnet
effort: medium
---

# /review-code — Code Change Review

## Purpose
Systematically review code changes made by agents or collaborators.
Act as a principal engineer doing a thorough PR review — not a rubber stamp.

---

## Step 1: Load Context

Resolve plans directory: read `plansDirectory` from project `CLAUDE.md`. If not set, default to `plans/`. Use this as `<plansDir>` throughout.

Resolve the active plan file: find the `.md` in `<plansDir>` with status `in-progress`, `implemented`, or `reviewed`. If multiple match, ask the user which one. Read it to understand the intent and approved plan.
Read project `CLAUDE.md` for coding standards, architecture rules, and PR checklist.

If no plan file is found, ask the user what the intent of the changes is before proceeding.

---

## Step 2: Get the Diff

```bash
git diff main --stat          # overview of what changed
git diff main                 # full diff
git log main..HEAD --oneline  # commits on this branch
```

---

## Step 3: Review Against These Dimensions

### 3.1 Correctness
- Does the implementation match the approved plan in the resolved plan file?
- Are all checklist steps actually implemented?
- Are edge cases and failure modes handled?
- Is error handling explicit — no silent swallowing of exceptions?

### 3.2 Architecture & Standards
- Does the code follow the layering rules in CLAUDE.md?
- Are domain objects free of framework dependencies (if applicable)?
- Are side effects contained and explicit?
- No magic — framework features that obscure control flow?

### 3.3 Data & Consistency
- Are DB queries parameterized? No string concatenation in SQL?
- Are transactions scoped correctly — not too wide, not too narrow?
- If concurrent access is possible, is it handled (locks, versioning, idempotency)?
- For financial/ledger code: BigDecimal only, RoundingMode explicit, double-entry balanced?

### 3.4 Tests & TDD Compliance
- Is there a test for every Implementation Step in the plan?
- Do tests assert invariants, not just "it ran without exception"?
- Are test names descriptive: `should_<expected>_when_<condition>`?
- No test depends on execution order or shared mutable state?
- **TDD order** (check `git log --oneline`): were test files committed before their corresponding implementation files? If implementation commits precede test commits, flag as a blocking issue.
- **RED confirmation**: do the tests actually cover failure paths — or do they only pass because the implementation is already in place? Spot-check by reading the test assertions against the implementation.

### 3.5 Scope Creep
- Are there changes NOT in the approved plan?
- Flag them explicitly — they may be valid, but must be acknowledged.

### 3.6 Code Hygiene
- No debug logging, `System.out`, `console.log`, `print()` left in
- No commented-out code
- No TODOs without a linked issue
- No secrets or credentials

---

## Step 4: Produce Review Report

Format:

```
## Code Review Report

### Summary
<2-3 sentences: overall assessment — pass / pass with minor issues / needs rework>

### ✅ What's Good
- ...

### ❌ Blocking Issues  (must fix before /create-pr)
- File:Line — <issue> — <why it matters> — <suggested fix>

### ⚠️ Non-blocking Issues  (should fix, not required)
- File:Line — <issue> — <suggestion>

### 🧪 TDD Check
- Tests committed before implementation: YES / NO / PARTIAL
- All Implementation Steps covered by tests: YES / NO (list gaps)

### 🔍 Scope Check
- In-plan changes: <list>
- Out-of-plan changes: <list or "none">

### Verdict
PASS | PASS WITH NOTES | REWORK REQUIRED
```

---

## Step 5: Next Steps

- If PASS or PASS WITH NOTES → "Run /create-pr when ready."
- If REWORK REQUIRED → list the exact blocking issues. Do not proceed to /create-pr.
- Offer to fix blocking issues inline: "Should I fix the blocking issues now?"
