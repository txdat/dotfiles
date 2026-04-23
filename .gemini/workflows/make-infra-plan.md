# Workflow: /make-infra-plan — Infrastructure Plan Creation

Plans directory: `docs/plans/`. Warn if plan exists.
Filename: `docs/plans/<basename $PWD>_<yyyy-mm-dd>_infra_<slug>.md` — slug max 5 words.

Read `GEMINI.md`. Do NOT apply changes.
Run READ-ONLY commands anytime to inspect state (`terraform show`, `kubectl get`, `helm get values`). Audit unfamiliar state before asking.
Ask clarifying questions (scope, envs, state, dependencies, rollback, downtime). Max 3 rounds.

**Drift detection** (Pre-flight): compare live state vs config files (`terraform show` vs `.tf`, `kubectl get` vs manifests).
If drift found: add sync step as first Implementation Step.

Structure:
```
# Task: <name>
Status: planning
Type: infra
Environment: <dev | staging | prod | all>
Issue:

## Requirement
<one paragraph — change & why>

## Scope
### In scope
### Out of scope

## Design Decisions
| Decision | Options Considered | Chosen | Reason |

## Risk Flags
- [ ] <risk>: <mitigation>

## Pre-flight Checks
Read-only only. Audit live state, detect drift.
- [ ] Check 1: `<command>` — confirms <state>

## Implementation Steps
Ordered, verifiable. Destructive steps: note dry-run inline `<cmd>` *(dry-run: `<dry-run>`)*.
- [ ] Step 1: <what> — `<command>`

## Verification Steps
Post-apply checks.
- [ ] Verify 1: `<command>` — expected: <result>

## Rollback Plan
- Trigger: <condition>
- [ ] Step 1: <undo> — `<command>`

## Out of Scope (explicit)
- <item>: <why excluded>
```
Rules: Verifiable unit per step. Dependency-ordered. 5–15 steps total across Pre/Impl/Verify. Propose split if >15.

**Verification gate**: Validate `## Verification Steps` non-empty, every Impl Step has Verify Step, `## Rollback Plan` ≥1 step. Add missing, re-confirm.

Save draft. Show brief (Task, Env, Requirement, counts). Ask "Apply these changes?". Apply edits. Ask "Create a GitHub issue?". If yes: `gh issue create`, update `Issue:` field.
Print "Plan saved at `<path>`. Run /review-plan before execution."
