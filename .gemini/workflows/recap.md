# Workflow: /recap — Session Insights & Memory Capture

Find active plan. Read it. Extract insights across 4 categories:

- **📌 Facts**: "We decided X and won't revisit it." — one-time project decision, not reusable (e.g. "we use UUIDs for all PKs").
- **🔁 Patterns**: "This worked — reuse it next time." — non-obvious technique that succeeded; phrase as an actionable imperative (e.g. "Always wrap DB calls in a retry decorator").
- **⛔ Anti-patterns**: "This burned us — avoid it." — approach that failed or caused a bug; phrase as "Do NOT..." (e.g. "Do NOT call `time.Now()` inside a transaction").
- **💡 Concepts**: "I now understand what X is and when it applies." — named technical concept; include: what it is, when to use, key trade-off (1–5 lines).

**Routing:**
- **Patterns / Anti-patterns** → Append to `GEMINI.md` only.
- **Facts / Concepts** → Use the `save_memory` tool with `scope: 'project'` to persist these facts natively, AND save them to the recap file.

**Output:**
Save recap summary to `docs/recaps/<basename $PWD>_<yyyy-mm-dd>.md` with: task name, insights written, plan path.
Update plan status to `archived`.
