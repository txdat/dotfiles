---
model: haiku
effort: low
---

# /create-pr — Create Pull Request

Resolve `plansDirectory` from project `CLAUDE.md` (default: `plans/`). Find active plan (status `implemented`/`reviewed`). If none, warn and ask to confirm. Read it plus `CLAUDE.md` for PR checklist.

If on `main`/`master`, create branch: `<type>/<slug>` — types: `feat`, `fix`, `refactor`, `chore`, `migration`, `hotfix`; slug from plan name, max 5 words.

Pre-flight checks:
```bash
git diff main | grep -nE "System\.out|console\.log|print\(|// DEBUG"  # debug artifacts
git diff main | grep -nE "^[<>]{7}|^={7}"                            # conflict markers
```
Stage and commit uncommitted changes: `<type>(<scope>): <imperative summary>`.

---

Generate PR description from the plan and `git diff main`:

- **Title**: `<type>(<scope>): <summary under 72 chars>`
- **WHAT**: 3–6 bullets of observable behavior changes (not file names)
- **HOW**: implementation approach, key design decisions, correctness strategy, what's out of scope
- **Testing**: tests added, invariants verified, manual steps if any
- **Checklist**: from `CLAUDE.md`, or default (tests pass · no debug artifacts · no secrets · migrations backward-compatible)

```bash
gh pr create --title "..." --body "..." --draft
```

Default: `--draft`. Pass `/create-pr ready` to open directly.

Print PR URL. Update plan status to `pr-created` with URL. Print: "Run /recap before closing the session."
