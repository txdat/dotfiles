# Workflow: /review-plan — Review and Improve an Existing Plan

Find plan by status `planning`/`approved`. Read the plan plus project `GEMINI.md`.

**Review Criteria:**
- **Requirement**: clear problem statement and definition of done.
- **Scope**: in/out explicitly defined.
- **Design Decisions**: alternatives considered and reasoning stated.
- **Risks**: actionable mitigation for each.
- **Steps**: dependency-ordered; each verifiable.
- **TDD Compliance (blocking)**: non-empty `### Test Steps`; all Test Steps before Implementation Steps.

**Output**:
```markdown
## Plan Review: <filename>

### ✅ What's solid
### ❌ Issues (must fix before execution)
### ⚠️ Suggestions
### Verdict: READY | NEEDS CHANGES
```
Produce the full review internally, then show a brief of Verdict, blocking issues, and suggestions. Ask: "Apply these changes?". Apply approved edits in place (full details used internally to drive edits). If status was `planning` and all blocking issues resolved → set `approved`.
d`.
