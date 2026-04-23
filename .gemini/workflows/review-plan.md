# Workflow: /review-plan — Review and Improve an Existing Plan

Do NOT write code.
Plans directory: `docs/plans/`. Find plan. Suggest `/explore` if area unfamiliar.
Read plan + `GEMINI.md`.

Review:
- **Requirement**: clear, measurable done.
- **Scope**: explicit in/out, no hidden assumptions.
- **Design decisions**: alternatives, reasoning.
- **Risks**: actionable mitigations.
- **Steps**: dependency-ordered, verifiable. If >10 steps, flag `❌` blocking — propose split.
  - **Split accepted**: create new plan files. Ask to create sub-issues (`gh issue create --title "..." --body "Part of #N"`).
- **TDD compliance (blocking)**: `### Test Steps` non-empty; Test Steps before Implementation Steps; references exist. Missing = `❌` blocking. Validate: `feature/fix` = new failing test; `refactor` = passing coverage test.

Flag ambiguities. Unresolvable → ask (1 round max).

Show brief:
- Verdict: READY | NEEDS CHANGES
- ❌ Blocking: N (titles only)
- ⚠️ Suggestions: N (titles only)
- `<plan path>`

Ask: "Apply these changes?". Apply approved edits in place.
If status `planning` and blocking resolved → set `approved`. Print "Plan updated. Run /execute-plan to begin."
