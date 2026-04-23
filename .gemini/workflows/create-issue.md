# Workflow: /create-issue — Create Standalone Issue

For issues not tied to a plan (bugs, spikes, discussions, quick tasks).
Plan-linked issues are created automatically by `/make-plan`.

1. **Collect Data**: title, description, labels, milestone (all optional except title).
2. **Execute**:
   ```bash
   gh issue create --title "..." --body "..." [--label "..."] [--milestone "..."]
   ```
3. **Report**: Print issue URL.
