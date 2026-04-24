---
model: gpt-5.3-codex
effort: high
---

# /dev:orchestrate — Full Development Cycle

Flow: **explore → plan → execute → review → recap → pr**

`$ARGUMENTS`: `<requirement or issue #>` — append `from <step>` to resume.
Steps: `explore` · `plan` · `execute` · `review` · `recap` · `pr`

Read `CODEX.md`; if present, also read `~/.codex/CODEX.md`.

## State Detection

If `from <step>` not provided, auto-detect resume point from plan status in `docs/plans/`:

| Plan status | Resume from |
|-------------|-------------|
| none | `explore` |
| `planning` | `plan` |
| `approved` | `execute` |
| `in-progress` | `execute` |
| `implemented` | `review` |
| `reviewed` | `recap` |
| `pr-created` | warn: cycle already complete — stop unless user specifies a step |

## Phase: explore

Follow `/dev:explore` logic on `<requirement or issue #>`. Output structured findings.

**→ PAUSE** — print findings summary. Ask: "Proceed to planning?" Stop if no.

## Phase: plan

If a plan at `Status: planning` exists → follow `/dev:review-plan` logic to approve it.
Otherwise → follow `/dev:make-plan` logic to create and approve a new plan.

Outputs plan at `Status: approved`.

**→ PAUSE** — print plan summary. Ask: "Proceed to execution?" Stop if no.

## Phase: execute

Follow `/dev:execute-plan` logic — TDD RED→GREEN→BLUE, all steps `[x]`.

**→ PAUSE** — print completion summary. Ask: "Proceed to code review?" Stop if no.

## Phase: review

Follow `/dev:review-code` logic. If REWORK REQUIRED: fix blocking issues inline, re-review before proceeding.

**→ PAUSE** — print review report. Ask: "Proceed to recap?" Stop if no.

## Phase: recap

Follow `/dev:recap` logic.

**→ PAUSE** — Ask: "Create PR?" Stop if no.

## Phase: pr

Follow `/dev:create-pr` logic. Default `--draft`; pass `ready` in arguments to open directly.

Print PR URL.
