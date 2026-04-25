---
model: gpt-5.3-codex
description: Run the full development cycle from exploration to PR.
effort: high
---

# /dev:orchestrate — Full Development Cycle

Flow: **explore → plan → execute → review → recap → pr**

`$ARGUMENTS`: `<requirement or issue #>` — append `from <step>` to resume, `skip approval` for unattended run.
Steps: `explore` · `plan` · `execute` · `review` · `recap` · `pr`

Read `CODEX.md`; if present, also read `~/.codex/CODEX.md`.

## Entry Point

If `from <step>` not provided, auto-detect resume point from plan status in `docs/plans/`:

| Plan status | Resume from |
|-------------|-------------|
| none / not found | `explore` |
| `planning` | `plan` |
| `approved` / `in-progress` | `execute` |
| `implemented` | `review` |
| `reviewed` | `recap` |
| `pr-created` | **STOP** — cycle complete unless user specifies a step |

## Flow Control

**Normal mode**: PAUSE after each phase — print summary, ask user to confirm before proceeding. Stop if no.

**`skip approval` mode**: No pauses. Auto-approve internal prompts (issue creation, plan changes, fixes). Proceed to next phase immediately after completion.

## Phase: explore

Follow `/dev:explore` logic on `<requirement or issue #>`. Output structured findings.

**→ PAUSE** — print findings summary. Ask: "Proceed to planning?"

## Phase: plan

If a plan at `Status: planning` exists → follow `/dev:review-plan` logic to approve it.
Otherwise → follow `/dev:make-plan` logic to create and approve a new plan.

Outputs plan at `Status: approved`.

**→ PAUSE** — print plan summary. Ask: "Proceed to execution?"

## Phase: execute

Follow `/dev:execute-plan` logic — TDD RED→GREEN→BLUE, all steps `[x]`.

**→ PAUSE** — print completion summary. Ask: "Proceed to code review?"

## Phase: review

Follow `/dev:review-code` logic. If REWORK REQUIRED: fix blocking issues inline, re-review before proceeding.

**→ PAUSE** — print review report. Ask: "Proceed to recap?"

## Phase: recap

Follow `/dev:recap` logic.

**→ PAUSE** — Ask: "Create PR?"

## Phase: pr

Follow `/dev:create-pr` logic. Default `--draft`; pass `ready` in arguments to open directly.

Print PR URL and finish.
