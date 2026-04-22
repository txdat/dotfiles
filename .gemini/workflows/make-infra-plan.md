# Workflow: /make-infra-plan — Infrastructure Plan Creation

Plans directory: `docs/plans/`. Warn and ask if an `approved` or `in-progress` infra plan already exists for the same target.

Filename: `docs/plans/<basename $PWD>_<yyyy-mm-dd>_infra_<slug>.md` — slug from input, max 5 words, hyphenated.

**Rules:**
- Read project `GEMINI.md` before proceeding.
- Do NOT apply any changes.
- You may run READ-ONLY commands at any time during planning to inspect current state (e.g. `terraform show`, `kubectl get`, `helm get values <release>`, `gcloud`/`aws` describe commands). If the target infrastructure is unfamiliar, audit existing state before asking clarifying questions.
- Ask clarifying questions grouped by concern (scope, environment targets, existing state, dependencies, re-run safety, rollback strategy, downtime tolerance). Up to 3 rounds maximum.

**Drift detection**: during Pre-flight, compare live state against configuration files using specific command pairs (e.g., `terraform show` vs `.tf` files). If drift is found, add a sync step as the first Implementation Step.

**Structure:**
```markdown
# Task: <name>
Status: planning
Type: infra
Environment: <dev | staging | prod | all>
Issue:

## Requirement
<one paragraph — what infrastructure change is being made and why>

## Scope
### In scope
### Out of scope

## Design Decisions
| Decision | Options Considered | Chosen | Reason |

## Risk Flags
- [ ] <risk>: <mitigation>

## Pre-flight Checks
Read-only commands only — no mutations. Audit live state and detect drift against config files.
- [ ] Check 1: `<command>` — confirms <current state or no drift>

## Implementation Steps
Ordered changes to apply. Each step is independently verifiable. For each destructive Implementation Step, note the dry-run command inline: `<apply command>` *(dry-run: `<dry-run command>`)*.
- [ ] Step 1: <what to apply> — `<command>`

## Verification Steps
Post-apply checks to confirm the change succeeded.
- [ ] Verify 1: `<command>` — expected: <result>

## Rollback Plan
- Trigger: <condition that requires rollback>
- [ ] Step 1: <what to undo> — `<command>`

## Out of Scope (explicit)
- <item>: <why excluded>
```

**Checklist Rules:**
- Each step = one verifiable unit of work.
- Dependency-ordered (step N never requires step N+1).
- Target 5–15 total steps across Pre-flight + Implementation + Verification. If steps exceed 15, stop — propose a split before continuing.

**Verification gate**: before saving, validate that `## Verification Steps` is non-empty, every Implementation Step has a corresponding Verification Step, and `## Rollback Plan` has at least one step. If not, add the missing entries and re-confirm before saving.

**Draft Brief**: Show a brief of the plan before saving (Task name, Environment, Requirement 1-line summary, counts for steps/risks). Ask "Apply these changes?". Apply approved edits in place. Ask "Create a GitHub issue for this plan?". If yes, run `gh issue create` and update `Issue:` field.
