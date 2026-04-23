# Workflow: /dev:orchestrate — Full Development Cycle

Flow: **explore → plan → execute → review → recap → pr**

Target: `<requirement or issue #>` — append `from <step>` to resume.
Steps: `explore` · `plan` · `execute` · `review` · `recap` · `pr`

Read `GEMINI.md`.

## State Detection
If `from <step>` not provided, auto-detect resume point from plan status in `docs/plans/`:
- none → `explore`
- `planning` → `plan`
- `approved`, `in-progress` → `execute`
- `implemented` → `review`
- `reviewed` → `recap`
- `pr-created` → warn: cycle complete — stop unless specified.

## Phases
**explore:** Follow `/explore` logic on target. Print findings. Ask: "Proceed to planning?". Stop if no.
**plan:** If `Status: planning` exists → follow `/review-plan`. Otherwise → follow `/make-plan`. Outputs `Status: approved`. Print plan summary. Ask: "Proceed to execution?". Stop if no.
**execute:** Follow `/execute-plan`. TDD RED→GREEN→BLUE. Print completion. Ask: "Proceed to code review?". Stop if no.
**review:** Follow `/review-code`. If REWORK REQUIRED: fix inline, re-review. Print report. Ask: "Proceed to recap?". Stop if no.
**recap:** Follow `/recap`. Ask: "Create PR?". Stop if no.
**pr:** Follow `/create-pr`. Default `--draft`; pass `ready` to open directly. Print PR URL.
