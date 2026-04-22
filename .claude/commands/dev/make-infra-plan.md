---
effort: high
---

# /make-infra-plan — Infrastructure Plan Creation

Plans directory: `docs/plans/`. Warn and ask if an `approved` or `in-progress` infra plan already exists for the same target.

Filename: `docs/plans/<basename $PWD>_<yyyy-mm-dd>_infra_<slug>.md` — slug from $ARGUMENTS, max 5 words, hyphenated.

Read project `CLAUDE.md` and `~/.claude/CLAUDE.md` before proceeding. Do NOT apply any changes.

You may run READ-ONLY commands at any time during planning to inspect current state (e.g. `terraform show`, `kubectl get`, `helm get values <release>`, `gcloud`/`aws` describe commands). If the target infrastructure is unfamiliar, audit existing state before asking clarifying questions.

Ask clarifying questions grouped by concern (scope, environment targets, existing state, dependencies, re-run safety, rollback strategy, downtime tolerance). Up to 3 rounds maximum.

**Drift detection**: during Pre-flight, compare live state against configuration files using specific command pairs:
- Terraform: `terraform show` vs `.tf` files
- Helm: `helm get values <release>` vs `values.yaml`
- Kubernetes: `kubectl get <resource> -o yaml` vs manifests

If drift is found, add a sync step as the first Implementation Step to reconcile config files with live state before applying any new changes.

Write the plan in this exact structure:

```
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
Ordered changes to apply. Each step is independently verifiable.
- [ ] Step 1: <what to apply> — `<command>`

## Verification Steps
Post-apply checks to confirm the change succeeded.
- [ ] Verify 1: `<command>` — expected: <result>

## Rollback Plan
- Trigger: <condition that requires rollback>
- [ ] Step 1: <what to undo> — `<command>`

## Out of Scope (explicit)
Items considered during planning but deliberately excluded — future plans must not re-litigate these.
- <item>: <why excluded>
```

Checklist rules: each step = one verifiable unit of work; dependency-ordered (step N never requires step N+1); target 5–15 total steps across Pre-flight + Implementation + Verification. If steps exceed 15, stop — propose a split before continuing.

For each destructive Implementation Step, note the dry-run command inline: `<apply command>` *(dry-run: `<dry-run command>`)* — e.g. `terraform apply` *(dry-run: `terraform plan`)*, `helm upgrade` *(dry-run: `--dry-run`)*, `kubectl apply` *(dry-run: `--dry-run=client`)*. Skip for non-destructive steps (config file edits, tagging, labelling).

**Verification gate**: before saving, validate that `## Verification Steps` is non-empty, every Implementation Step has a corresponding Verification Step, and `## Rollback Plan` has at least one step. If not, add the missing entries and re-confirm before saving.

Save draft to filename. Show a brief:
- Task name, Environment
- Requirement: <1-line summary>
- Pre-flight: N | Implementation: N | Verification: N | Rollback: N
- Risk Flags: N
- `<path>`

Ask: "Apply these changes?" Apply approved edits in place.

Ask: "Create a GitHub issue for this plan?" If yes:
```bash
gh issue create --title "<Task name>" --body "<Requirement paragraph>"
```
Update the `Issue:` field in the saved plan with the created issue number.

Print: "Plan saved to `<path>`. Run /dev:review-plan to review before execution."
