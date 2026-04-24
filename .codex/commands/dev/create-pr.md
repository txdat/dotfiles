---
model: gpt-5.4-mini
---

# /create-pr — Create Pull Request

Plans directory: `docs/plans/`. Find active plan (status `implemented`/`reviewed`). If none, warn and ask to confirm. Read it plus `CODEX.md` for PR checklist. Resolve `BASE_BRANCH` as the repo default branch (for example `main` or `master`).

```bash
BASE_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
[ -z "$BASE_BRANCH" ] && BASE_BRANCH=main
```

If on `$BASE_BRANCH`/protected branch, create branch: `<type>/<slug>` — types: `feat`, `fix`, `refactor`, `chore`, `migration`, `hotfix`; slug from plan name, max 5 words.

Pre-flight checks:
```bash
git diff $BASE_BRANCH | rg -n "System\.out|console\.log|print\(|// DEBUG"  # debug artifacts
git diff $BASE_BRANCH | rg -n "^[<>]{7}|^={7}"                            # conflict markers
```
Stage and commit uncommitted changes: `<type>(<scope>): <imperative summary>`.

Generate PR description from the plan and `git diff $BASE_BRANCH`:

- **Title**: `<type>(<scope>): <summary under 72 chars>`
- **WHAT**: 3–6 bullets of observable behavior changes (not file names)
- **HOW**: implementation approach, key design decisions, correctness strategy, what's out of scope
- **Testing**: tests added, invariants verified, manual steps if any
- **Checklist**: from `CODEX.md`, or default (tests pass · no debug artifacts · no secrets · migrations backward-compatible)
- **Closes**: if plan has `Issue:` set (e.g. `Issue: 42`), append `Closes #42` to PR body

```bash
gh pr create --title "..." --body "..." --draft
```

Default: `--draft`. Pass `/dev:create-pr ready` to open directly.

Print PR URL. Update plan status to `pr-created` with URL. Print: "Run /dev:recap before closing the session."
