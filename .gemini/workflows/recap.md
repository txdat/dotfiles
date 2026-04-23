# Workflow: /recap — Session Insights & Memory Capture

Find active plan. Read it. Run `git diff main --stat` and `git log main..HEAD --oneline`. Ask "Anything specific to capture?".

Extract insights across 4 categories:
- **📌 Facts**: "Decided X, won't revisit." (One-time decision, not reusable).
- **🔁 Patterns**: "Worked — reuse it." (Non-obvious technique, actionable imperative).
- **⛔ Anti-patterns**: "Burned us — avoid." (Failed approach, phrase "Do NOT...").
- **💡 Concepts**: "Understand X and when applies." (Named concept, trade-off).

**Routing:**
- **Patterns/Anti-patterns** → Append to `GEMINI.md` only.
- **Facts/Concepts** → Use `save_memory` tool (scope: `project`) AND save to recap file.
- **Command Improvements** → Note in recap.

Present extraction. Ask "Look right?". Apply edits.
Append to target files (create headers if missing). Never overwrite.

**Output:**
Save recap to `docs/recaps/<basename $PWD>_<yyyy-mm-dd>.md`: task name, PR URL, insights, plan path.
Update plan status `archived`.
Print task name, PR URL, plan path, insight counts.
