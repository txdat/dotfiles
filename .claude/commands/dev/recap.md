---
model: sonnet
effort: low
---

# /recap — Session Insights & Memory Capture

Plans directory: `docs/plans/`. Recaps directory: `docs/recaps/`. Find active plan (status `in-progress`/`implemented`/`reviewed`/`pr-created`). Read it. Run `git diff main --stat` and `git log main..HEAD --oneline`. Ask: "Anything specific to capture?"

---

Extract insights across 5 categories:

- **📌 Facts**: permanent project decisions future sessions must not re-litigate
- **🔁 Patterns**: reusable non-obvious implementation approaches
- **⛔ Anti-patterns**: things that failed or caused bugs — "Do NOT..."
- **💡 Concepts**: named concepts applied (language/framework/database/architecture). Each entry: what it is, when to use it, key trade-off (1–5 lines).
- **🔧 Command Improvements**: any `/command` that felt incomplete, unclear, or missing — note what would have helped. Not written to files, noted only.

Route each insight:
- Project-specific → `<repo>/CLAUDE.md`
- Generic engineering → `~/.claude/CLAUDE.md`
- New reusable workflow → `~/.claude/commands/dev/<name>.md`

---

Present full extraction to user. Ask: "Does this look right?" Apply edits before writing.

Append to target files under correct section headers — never overwrite. Create headers if missing.

Save recap summary to `docs/recaps/<basename $PWD>_<yyyy-mm-dd>.md` with: task name, PR URL, insights written, plan path.

Update plan status to `archived`.

Print: task name, PR URL, plan path (archived), count of items written per file.
