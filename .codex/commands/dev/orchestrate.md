---
effort: high
---

# /dev:orchestrate — Full Development Cycle

**explore → plan → execute → review → recap → pr**

`$ARGUMENTS`: `<requirement>` — append `from <step>` to resume, `skip approval` to run end-to-end without pauses.

Read `CODEX.md`.

## State Detection

Auto-detect from plan status if `from` not given:

| Status | Resume |
|--------|--------|
| none | explore |
| planning | plan |
| approved/in-progress | execute |
| implemented | review |
| reviewed | recap |
| pr-created | warn — stop |

If `skip approval` in $ARGUMENTS — skip all PAUSEs, auto-approve all internal prompts in each phase (issue creation, plan changes, fixes, etc.).

## Phases

**explore** → `/dev:explore`. **PAUSE** — "Proceed to planning?"

**plan** → existing `planning`? `/dev:review-plan` : `/dev:make-plan`. **PAUSE** — "Proceed to execution?"

**execute** → `/dev:execute-plan` (RED→GREEN→BLUE). **PAUSE** — "Proceed to review?"

**review** → `/dev:review-code`. REWORK? Fix inline, re-review. **PAUSE** — "Proceed to recap?"

**recap** → `/dev:recap`. **PAUSE** — "Create PR?"

**pr** → `/dev:create-pr`. Print PR URL.
