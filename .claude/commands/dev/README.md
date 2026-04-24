# Claude Code Commands

**Orchestrated**: `/dev:orchestrate <requirement>` — explore → plan → execute → review → recap → pr (pauses each phase)

Resume: `/dev:orchestrate add-jwt from execute`

No confirmations: `/dev:orchestrate add-jwt skip approval`

---

## Step-by-step

| Step | Command | Purpose |
|------|---------|---------|
| 0 | `/dev:create-issue <title>` | Standalone issue (not plan-linked) |
| 1 | `/dev:explore <target>` | Map entry points, flow, patterns |
| 2 | `/dev:make-plan <requirement>` | Draft + approve plan |
| 3 | `/dev:execute-plan [from N]` | TDD RED→GREEN→BLUE |
| 4 | `/dev:fix-bug <symptom>` | Diagnose + minimal fix (optional) |
| 5 | `/dev:review-code` | Review against plan |
| 6 | `/dev:recap` | Extract patterns → CLAUDE.md |
| 7 | `/dev:create-pr [ready]` | Draft PR (or ready) |

---

## Other

| Command | Purpose |
|---------|---------|
| `/dev:review-plan` | Review existing/interrupted plan |
| `/dev:simplify-code <target>` | Simplify without behavior change |
| `/dev:make-infra-plan` | Infrastructure plan + approval |
