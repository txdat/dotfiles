---
model: haiku
effort: low
---

# /create-issue — Create Standalone GitHub Issue

For plan-linked issues, use `/dev:make-plan` — it creates and links an issue automatically.

Use this command for issues not tied to a plan: bugs, spikes, discussions, or quick tasks.

Collect from $ARGUMENTS or ask: title, description, labels, milestone (all optional except title).

```bash
gh issue create --title "..." --body "..." [--label "..."] [--milestone "..."]
```

Print: issue URL.
