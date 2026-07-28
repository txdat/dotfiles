# /create-pr — Publish Reviewed Work

Takes an exact `docs/plans/<file>.md` per CORE `Named plan and entry gates`. Entry status is `reviewed`; `gate-check` also requires issue, worktree, and finalized PR Pattern. Read the plan and project config for AI, then run everything in `<worktree>`.

Default is draft; `$ARGUMENTS` may include `ready`.

## Preflight

1. Resolve every branch **and its parent** from the finalized `## PR Pattern` table's `Parent` column; never infer a parent from the current checkout, and never substitute `<base>` for a recorded parent. Usually that is `<base>` for a single PR or slice 1 and the preceding branch for later slices — but a follow-up amending an unmerged PR records that PR's branch, and its own PR must target it (`Shipped, and what comes after` below). A row with no parent → STOP; return through review-code to finalize the pattern.
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
3. Remove `$MAIN_ROOT`'s locator copy of the plan — it is scratch, it is untracked there, and its content now lives in the branch commit. Verify **identity and persistence**, never content equality — the locator froze at execution start (`worktree.md` `Plan resolution vs. truth`) while the authoritative copy kept evolving, so the two are *expected* to differ. Confirm all of:
   - the locator is the exact path originally resolved, still under `$MAIN_ROOT/docs/plans/`, and still untracked there;
   - its recorded `Worktree:` names the currently registered worktree;
   - locator and authoritative copy share the same basename and the same `Issue: #<n>`;
   - the authoritative copy is tracked in the final branch's `HEAD`, reads `Status: archived` with `Worktree:` cleared, and that commit is pushed;
   - `git -C <worktree> status --porcelain` is empty.

   Any check failing → STOP and show which one, instead of deleting. Then remove **only** that exact locator path. Do not require `$MAIN_ROOT` itself to be clean: it is deliberately shared and may hold unrelated user work (`worktree.md` `$MAIN_ROOT sharing`).
4. From `$MAIN_ROOT`, remove the worktree normally. Refusal due to uncommitted/untracked state → STOP and show it; `--force` requires explicit destructive-action confirmation.

Chain note: the archive commit lands only on the final branch. Earlier PRs keep the plan at `reviewed`, which is true of them; merging in PR-Pattern order leaves `<base>` with the archived plan.

## Self-Check (BLOCKING)

- [ ] **Committed scope:** every branch has reviewed commits above its correct parent; worktree remained clean; artifact scan passed.
- [ ] **Description:** title, WHAT, HOW, Testing, checklist, and issue closure are accurate to the actual diff.
- [ ] **Chain, if used:** all rows/parents/order match the finalized pattern; each created number is linked from PR 1.
- [ ] **Archive safety:** the `archived` flip was committed on the last branch and pushed; locator identity and archived persistence were verified before removing that exact locator — never content equality, which the frozen locator is expected to fail; no uncommitted work in `<worktree>` and no forced teardown.

The first two checks gate publication. After PR creation, complete the chain and archive checks before copying or teardown. Then archive safely, remove the worktree, and print PR URL(s) plus `Feature shipped.`

## Shipped, and what comes after

`archived` and `Feature shipped.` mean the PR exists and this cycle is closed — **never merged, never deployed**. From here the branch is immutable under this workflow: any requested change to the PR (review feedback, a follow-up fix) is a new artifact-bound cycle with its own plan, issue, review, approval, and PR. Nothing reopens an archived plan or updates a PR in place, and teardown already removed the worktree one would need.

**A follow-up amending a PR that has not merged yet parents on that PR's branch, not `<base>`** — `<base>` does not contain the code being amended. The new plan records that branch in its PR Pattern `Parent` column and its PR targets it, so the two merge in order. Once the original merges, the follow-up parents on `<base>` like any other plan.
