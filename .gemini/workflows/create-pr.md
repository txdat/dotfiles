# Workflow: /create-pr — Create Pull Request

Find active plan (status `implemented`/`reviewed`). If none, warn/ask. Read `GEMINI.md`.

If on `main`/`master`/protected, create branch: `<type>/<slug>` (types: `feat`, `fix`, `refactor`, `chore`, `migration`, `hotfix`; slug max 5 words from plan).

## Pre-flight checks:
```bash
git diff main | grep -nE "System\.out|console\.log|print\(|// DEBUG"
git diff main | grep -nE "^[<>]{7}|^={7}"
```
Stage/commit uncommitted: `<type>(<scope>): <imperative summary>`.

## Generate PR description:
- **Title**: `<type>(<scope>): <summary < 72 chars>`
- **WHAT**: 3–6 bullets observable behavior changes (not file names).
- **HOW**: implementation approach, design decisions, correctness strategy, out of scope.
- **Testing**: tests added, invariants verified, manual steps.
- **Checklist**: from `GEMINI.md` or default (tests pass · no debug artifacts · no secrets · migrations backward-compatible).
- **Closes**: if plan has `Issue:` set (e.g. `Issue: 42`), append `Closes #42` to body.

Execute:
```bash
gh pr create --title "..." --body "..." --draft
```
Default: `--draft`. Pass `ready` to open directly.
Print PR URL. Update plan status `pr-created` with URL. Print "Run /recap before closing session."
