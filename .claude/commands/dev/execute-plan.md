---
model: sonnet
effort: medium
---

# /execute-plan — Implement the Approved Plan

## Purpose
Execute the approved plan from a named plan file in `<plansDir>/` step by step.
Never write code without a verified plan. Never expand scope silently.

---

## Step 0: Resolve Plan File

Resolve plans directory: read `plansDirectory` from project `CLAUDE.md`. If not set, default to `plans/`. Use this as `<plansDir>` throughout.

Determine the target plan file from $ARGUMENTS:

- If $ARGUMENTS is a full filename (e.g., `myapp_2024-01-15_add-auth.md`), use `<plansDir>/<filename>`.
- If $ARGUMENTS is a partial name, find the file in `<plansDir>/` whose name contains that string.
- If $ARGUMENTS is empty:
  - List all `.md` files in `<plansDir>/` whose content has status `approved` or `in-progress`.
  - If exactly one → use it automatically.
  - If multiple → print the list and ask: "Which plan do you want to execute?"
  - If none → STOP. Print: "No approved plan found in <plansDir>/. Run /make-plan first."

## Step 0b: Gate Check

Read the resolved plan file.

- If file does not exist → STOP. Print: "Plan file not found: <plansDir>/<filename>."
- If status is `planning` → STOP. Print: "Plan is not yet approved. Confirm the plan in /make-plan first."
- If status is not `approved` or `in-progress` → STOP. Print: "Task status is '<status>'. Expected 'approved'."

Read project `CLAUDE.md` and `~/.claude/CLAUDE.md` for coding standards.
Update status in the plan file to `in-progress`.

---

## Step 1: Locate Next Step

Determine the current phase:
- If any Test Steps are unchecked → Phase 1 (RED). Find the first unchecked Test Step.
  Print: "🔴 Writing Test N: <description>"
- If all Test Steps are `[x]` and any Implementation Steps are unchecked → Phase 2 (GREEN). Find the first unchecked Implementation Step.
  Print: "🟢 Implementing Step N: <description>"

---

## Step 2: Implement

Follow these rules strictly:

**Coding standards**
- Apply all rules from CLAUDE.md — architecture layers, naming, error handling
- No placeholder implementations — if something can't be done, say so, don't write `// TODO`
- No silent scope expansion — if you discover needed work outside the plan, STOP (see Step 4)

**TDD two-phase execution**

Execute all `### Test Steps` before any `### Implementation Steps`.

**Phase 1 — Write Tests (RED)**

For each unchecked Test Step (in order):
1. Write the test — do not write any implementation code yet
2. Run the test and confirm it **fails** (RED). If it passes without implementation, the test is wrong — fix it before marking done.
3. Mark the Test Step as `[x]`
4. Print: "🔴 Test N written and failing: <what it verifies>"

Once all Test Steps are `[x]`, move to Phase 2.

**Phase 2 — Implement (GREEN)**

For each unchecked Implementation Step (in order):
1. Implement only enough to make the corresponding test(s) pass — no extra logic
2. Run the related test(s):
   - Java/Maven: `mvn test -pl <module> -am -q -Dtest=<TestClass>`
   - Go: `go test ./<affected_package>/...`
   - Python: `pytest <affected_path> -q`
   - TypeScript: `npm test -- --testPathPattern=<affected_file_or_describe>`
3. If tests fail → fix before moving on. Do NOT skip or mark step complete with failing tests.
4. Mark the Implementation Step as `[x]`
5. Print: "✅ Step N done: <what was implemented>"

Do NOT run the full test suite unless the user explicitly says `/execute-plan --full-test` or asks for it.

---

## Step 3: Completion

When all checklist items are `[x]`:
- Update status in `the plan file` to `implemented`
- Run lint and build to confirm the full changeset is clean by using the stack defined in project `CLAUDE.md`.
  If lint or build fails → fix before marking `implemented`. Do NOT skip.
- Print summary:
  ```
  All steps complete.
  Lint: ✅ / ❌
  Build: ✅ / ❌
  Status: implemented
  
  Next: run /review-code to check the changes, then /create-pr to create the pull request.
  ```

---

## Step 4: Scope Creep Protocol

If during implementation you discover work that is NOT in the plan:

1. STOP immediately — do not implement the out-of-scope work
2. Append to `the plan file` under `## Discovered Scope`:
   ```
   - <what was discovered> — <why it's needed> — <estimated size: small/medium/large>
   ```
3. Ask the user:
   - "Include it in this task?" → update the plan checklist, continue
   - "Separate task?" → note it, continue without implementing it
   - "Not needed?" → note the decision, continue

Never silently implement out-of-scope work.

---

## Step 5: Partial Runs

$ARGUMENTS may contain an optional plan name followed by an optional step selector:
- `/execute-plan <name> <N>` → resolve plan by name, implement only step N
- `/execute-plan <name> from <N>` → resolve plan by name, start from step N
- `/execute-plan <N>` or `/execute-plan from <N>` (no name) → auto-discover plan, apply step selector

Default: implement all unchecked steps in order.
