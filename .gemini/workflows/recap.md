# Workflow: /recap — Session Insights & Memory Capture

Find active plan. Read it. Run `git diff main --stat` and `git log main..HEAD --oneline`. Ask: "Anything specific to capture?"

Extract insights across 4 categories:
- **📌 Facts**: "We decided X and won't revisit it." (One-time decision, not reusable).
- **🔁 Patterns**: "This worked — reuse it." (Non-obvious technique, actionable imperative).
- **⛔ Anti-patterns**: "This burned us — avoid it." (Failed approach, phrase "Do NOT...").
- **💡 Concepts**: "I understand X and when it applies." (Named concept, trade-off).

**Routing:**
- **Patterns/Anti-patterns** → Append to `GEMINI.md` only.
- **Facts/Concepts** → Use `save_memory` tool (scope: `project`) AND save to recap file.
- **Command Improvements** → Note in recap.

**Output:**
Save recap to `docs/recaps/<basename $PWD>_<yyyy-mm-dd>.md`: task name, PR URL, insights, plan path.
Update plan status to `archived`.
