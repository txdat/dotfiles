---
model: gpt-5.4-mini
description: Create a standalone GitHub issue from a short prompt.
---

# /create-issue — Create Standalone GitHub Issue

For plan-linked issues, use `/dev:make-plan` — it creates and links an issue automatically.

For issues not tied to a plan: bugs, spikes, discussions, quick tasks.

Collect from $ARGUMENTS or ask: title, description, labels, milestone (all optional except title).

```bash
gh issue create --title "..." --body "..." [--label "..."] [--milestone "..."]
```

Print: issue URL.
