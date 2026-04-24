---
model: gpt-5.3-codex
effort: high
---

# /review-plan — Review and Improve an Existing Plan

Do NOT write any code.

Plans directory: `docs/plans/`. Find plan from $ARGUMENTS (full/partial name) or auto-discover by status `planning`/`approved`. If multiple, ask. If none, stop. If the plan references unfamiliar codebase areas, suggest running `/dev:explore` on them first.

Read the plan plus project `CODEX.md`; if present, also read `~/.codex/CODEX.md`.

Review:
- **Requirement**: clear problem statement, measurable definition of done
- **Scope**: in/out explicitly defined, no hidden assumptions
- **Design decisions**: alternatives considered, reasoning stated
- **Risks**: each has an actionable mitigation
- **Steps**: dependency-ordered; target 5–10; each verifiable. If steps exceed 10, flag `❌` blocking — propose a split.

**If split accepted**: create a new plan file for each sub-plan. If parent plan has `Issue:` set, ask: "Create sub-issues?" If yes: `gh issue create --title "..." --body "Part of #N"` for each sub-plan; update its `Issue:` field.

Flag ambiguities: undefined terms, missing constraints, unaddressed edge cases, unstated assumptions. If unresolvable from the plan, ask — one follow-up round maximum.

**TDD compliance (blocking)**: non-empty `### Test Steps`; Test Steps before Implementation Steps; every Implementation Step references a Test Step. Missing TDD structure is `❌` blocking — propose missing test steps. Validate content by type:
- *Feature/fix*: each Test Step describes a new failing test
- *Refactor*: each Test Step describes coverage/characterization tests that pass before and after

Show brief:
- Verdict: READY | NEEDS CHANGES
- ❌ Blocking: N (titles only)
- ⚠️ Suggestions: N (titles only)
- `<plan path>`

Ask: "Apply these changes?" Apply approved edits in place (full details used internally to drive edits).

If status was `planning` and all blocking issues resolved → set `approved` and print: "Plan approved. Run /dev:execute-plan to begin."
