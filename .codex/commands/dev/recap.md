---
model: gpt-5.3-codex
effort: medium
---

# /recap — Session Insights & Memory Capture

```bash
BASE_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
[ -z "$BASE_BRANCH" ] && BASE_BRANCH=main
```

Plans directory: `docs/plans/`. Recaps directory: `docs/recaps/`. Find active plan (status `in-progress`/`implemented`/`reviewed`/`pr-created`). Read it. Run `git diff $BASE_BRANCH --stat` and `git log $BASE_BRANCH..HEAD --oneline`. Ask: "Anything specific to capture?"

Extract insights across 4 categories. Classify each:

- **📌 Facts**: "We decided X and won't revisit it." — one-time project decision, not reusable (e.g. "we use UUIDs for all PKs").
- **🔁 Patterns**: "This worked — reuse it next time." — non-obvious technique that succeeded; phrase as an actionable imperative (e.g. "Always wrap DB calls in a retry decorator").
- **⛔ Anti-patterns**: "This burned us — avoid it." — approach that failed or caused a bug; phrase as "Do NOT..." (e.g. "Do NOT call `time.Now()` inside a transaction").
- **💡 Concepts**: "I now understand what X is and when it applies." — named technical concept; include: what it is, when to use, key trade-off (1–5 lines).

When in doubt:
- **Fact vs Pattern**: Fact = decision (non-reusable); Pattern = technique (reusable across similar situations).
- **Pattern vs Concept**: Pattern is an actionable rule ("do X when Y"); Concept explains what something IS.
- **Pattern vs Anti-pattern**: did the approach succeed or fail?

Route each insight:
- **Patterns / Anti-patterns** → `<repo>/CODEX.md` only — do NOT write to `~/.codex/CODEX.md`
- **Facts / Concepts** → recap file only — do NOT write to any CODEX.md
- **Command Improvements** (any `/dev:command` that felt incomplete or missing) → if it warrants a new command, create `~/.codex/commands/dev/<name>.md`; otherwise noted only

Present full extraction to user. Ask: "Does this look right?" Apply edits before writing.

Append to target files under correct section headers — never overwrite. Create headers if missing.

Save recap summary to `docs/recaps/<basename $PWD>_<yyyy-mm-dd>.md` with: task name, PR URL, insights written, plan path.

Update plan status to `archived`.

Print: task name, PR URL, plan path (archived), count of items written per file.
