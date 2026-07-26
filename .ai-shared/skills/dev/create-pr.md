# /create-pr — Publish Reviewed Work

Resolve the active plan per CORE. Entry status is `reviewed`; `gate-check` also requires issue, worktree, and finalized PR Pattern. Read the plan and project AI config, then run everything in `<worktree>`.

Default is draft; `$ARGUMENTS` may include `ready`.

## Preflight

1. Resolve `<base>` and branches from finalized `## PR Pattern`; never infer parents from the current checkout. Single parent is `<base>`; chain slice 1 uses `<base>`, later slices use the preceding branch.
2. Require an empty `git status --porcelain` before switching branches. Dirty state returns to execution/review; create-pr never commits it.
3. For each branch, require it exists and has commits above its parent; empty slice → absorb or drop it, then return through review-code.
4. Run `dev-check artifacts <parent> <branch>`.

## Publish

For each PR in PR-Pattern order, check out its branch and create a body from the plan plus `git diff <parent>..<branch>`:

- title `<type>(<scope>): <summary>` under 72 characters;
- WHAT: 3–6 behavior bullets;
- HOW: approach, decisions, correctness, out of scope;
- Testing: automated evidence and manual steps;
- project checklist, or default checklist;
- `Closes #N` from the plan.

For a chain, every PR body includes the complete ordered branch table, with the current row marked and known PR numbers filled. Create with:

```bash
gh pr create --title "..." --body "..." --base <parent> --draft
```

Omit `--draft` when `ready` is requested. After creating each later chain PR, update PR 1's exact branch row with its PR number; never substring-match branch names.

## Archive and Cleanup

Immediately before archival, require the worktree is still clean.

Archive **inside the worktree, as a commit** — the plan is a tracked file on the branch, so an uncommitted status flip would either be lost at teardown or leave `$MAIN_ROOT` permanently diverged from what the merged branch says:

1. In `<worktree>`, on the **last** branch of the PR Pattern (single PR → its only branch; chain → the final slice, which merges last), set `Status: archived`, clear `Worktree:`, and commit `docs(<scope>): archive plan`. Push it so the open PR carries the final state.
2. Confirm `git -C <worktree> status --porcelain` is empty again.
3. Remove `$MAIN_ROOT`'s locator copy of the plan — it is scratch, it is untracked there, and its content now lives in the branch commit. Verify that before deleting: if the locator differs from the archived worktree copy in anything but `Status:`/`Worktree:`, STOP and show the diff instead of deleting.
4. From `$MAIN_ROOT`, remove the worktree normally. Refusal due to uncommitted/untracked state → STOP and show it; `--force` requires explicit destructive-action confirmation.

Chain note: the archive commit lands only on the final branch. Earlier PRs keep the plan at `reviewed`, which is true of them; merging in PR-Pattern order leaves `<base>` with the archived plan.

## Self-Check (BLOCKING)

- [ ] **Committed scope:** every branch has reviewed commits above its correct parent; worktree remained clean; artifact scan passed.
- [ ] **Description:** title, WHAT, HOW, Testing, checklist, and issue closure are accurate to the actual diff.
- [ ] **Chain, if used:** all rows/parents/order match the finalized pattern; each created number is linked from PR 1.
- [ ] **Archive safety:** the `archived` flip was committed on the last branch and pushed; the `$MAIN_ROOT` locator matched before removal; no uncommitted work or forced teardown.

The first two checks gate publication. After PR creation, complete the chain and archive checks before copying or teardown. Then archive safely, remove the worktree, and print PR URL(s) plus `Feature shipped.`
