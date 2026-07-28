# /create-issue — Standalone GitHub Issue

For plan-linked issues, use the design-feature skill instead.

Collect from $ARGUMENTS or ask: title, problem/context, and expected outcome (required); labels and milestone (optional). Build the body from the required problem/context and expected outcome.

This skill loads no core file, so read PROCESS `Git credentials` — the single source for the identity `gh` runs under — before the command below.

```bash
gh issue create --title "..." --body "..." [--label "..."] [--milestone "..."]
```

## Self-Check (BLOCKING)

- [ ] **Standalone:** not plan-linked — otherwise this is design-feature's job.
- [ ] **Content:** specific title under 72 chars; body carries problem, expected outcome, context; requested labels/milestone applied.
- [ ] **Auth:** `gh auth status` shows the account PROCESS requires.

All checked → create the issue and print its URL.
