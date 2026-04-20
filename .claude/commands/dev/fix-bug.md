---
model: sonnet
effort: high
---

# /fix-bug — Structured Bug Fix

## Purpose
Fix a bug end-to-end: diagnose systematically, identify root cause, apply minimal fix, add regression test.

---

## Step 1: Capture the Failure

Ask the user (or read from $ARGUMENTS) for:
1. **Symptom**: What is the observed behavior?
2. **Expected**: What should happen instead?
3. **Reproduction**: Steps to reproduce (command, request, test name, etc.)
4. **Context**: When did it start? After which change? On which environment?

If a stack trace, error log, or failing test output is available, read it now.

---

## Step 2: Understand the Blast Radius

```bash
git log --oneline -20          # recent changes
git diff main --stat           # what's changed on this branch
```

Identify: is this a regression (worked before) or a never-worked bug?
If regression: narrow to the introducing commit range.

---

## Step 3: Build a Hypothesis List

Based on symptom + context, generate 3–5 hypotheses ranked by probability.

Format:
```
Hypothesis 1 (most likely): <what could cause this>
  → How to verify: <specific check, log, test, or breakpoint>
  
Hypothesis 2: ...
  → How to verify: ...
```

Present hypotheses to the user before starting investigation.
Most debugging time is wasted on low-probability hypotheses — eliminate the likely ones first.

---

## Step 4: Investigate — One Hypothesis at a Time

For each hypothesis (highest probability first):

1. State: "Testing hypothesis N: <description>"
2. Run the verification:
   - Add targeted debug logging if needed (mark with `// DEBUG` for cleanup later)
   - Run the specific test or reproduction case
   - Read relevant source code
   - Check DB state if applicable
3. Conclude: CONFIRMED | ELIMINATED | INCONCLUSIVE
4. If CONFIRMED → go to Step 5
5. If ELIMINATED → next hypothesis
6. If INCONCLUSIVE → refine and retest once, then move on

Do not pursue a hypothesis for more than 2 iterations if evidence is weak.

---

## Step 5: Root Cause Statement

Once confirmed, write a precise root cause statement:

```
Root Cause: <specific line/condition/assumption that is wrong>
Why it manifests as: <link root cause to observed symptom>
Why it was missed: <what assumption or test gap allowed this>
```

---

## Step 6: Fix

Apply the minimal fix that addresses the root cause.

Rules:
- Fix the root cause, not the symptom
- Do not refactor unrelated code while fixing
- Do not introduce new behavior beyond the fix

After fixing:
1. Run the original reproduction case — confirm it passes
2. Run the full test suite for affected modules
3. Remove any `// DEBUG` logging added during investigation

---

## Step 7: Regression Test

Write or update a test that would have caught this bug:
- If a unit test is sufficient → add it
- If only an integration test catches it → note why and add it
- Test name should describe the bug: `should_not_<bad behavior>_when_<condition>`

---

## Step 8: Fix Report

Resolve plans directory: read `plansDirectory` from project `CLAUDE.md`. If not set, default to `plans/`. Use this as `<plansDir>` throughout.

Resolve the active plan file: find the `.md` in `<plansDir>` with status `in-progress` or `implemented`. If none found, skip the append and note it to the user.

Append to that plan file under `## Bug Fixes`:

```
### Fix: <date> — <symptom summary>
Root cause: <one line>
Fix: <file:line — what changed>
Regression test: <test name added>
```

Print: "Bug fix complete. Run /review-code to verify the fix before /create-pr."
