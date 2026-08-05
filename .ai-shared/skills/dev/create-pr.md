# /create-pr — Publish Reviewed Work

`PROCESS.md` must be loaded before this skill runs — not in context → read it now.

Takes an exact `docs/plans/<file>.md` per PROCESS `Named plan and entry gates`. Entry status is `reviewed`; `gate-check` also requires issue, worktree, and finalized PR Pattern. Read the plan and project config for AI, then run everything in `<worktree>`.

Default is draft; `$ARGUMENTS` may include `ready`.

## Preflight

1. Resolve every branch **and its parent** from the finalized `## PR Pattern` table's `Parent` column; never infer a parent from the current checkout, and never substitute `<base>` for a recorded parent. Usually that is `<base>` for a single PR or slice 1 and the preceding branch for later slices — but a follow-up amending an unmerged PR records that PR's branch, and its own PR must target it (`Shipped, and what comes after` below). A row with no parent → STOP; return through review-code to finalize the pattern.
2. Require an empty `git status --porcelain` before switching branches. Dirty state returns to execution/review; create-pr never commits it.
3. For each branch, require it exists and has commits above its parent; empty slice → absorb or drop it, then return through review-code. For a chain, require the finalized pattern's `Slice N (<branch>): green at <sha>` line for every row, with `<sha>` either that branch's current tip or separated from it only by commits that touch nothing outside `docs/plans/` — review-code's own `review passed` commit and create-pr's archive commit land after the tips are verified and cannot change what a test does. Missing, or stale because code moved after review → return through review-code; publishing a slice that is not green alone is publishing a PR that cannot merge or revert alone.
4. Run `dev-check artifacts <parent> <branch>`.

## Publish

For each PR in PR-Pattern order, check out its branch and create a body from the plan plus `git diff <parent>..<branch>`:

- title `<type>(<scope>): <summary>` under 72 characters;
- WHAT: 3–6 behavior bullets;
- HOW: approach, decisions, correctness, out of scope;
- Testing: automated evidence and manual steps;
- project checklist, or default checklist;
- the plan's issue link. Two checks, in order — both must pass for `Closes #N`; either failing → `Refs #N`:
  1. **Sole active claimant:** `rg -l 'Issue: #N\b' "$MAIN_ROOT/docs/plans/"` lists only this plan. Archival removes each shipped plan's locator, so survivors are exactly the still-active claimants.
  2. **No unchecked deferred goals:** `gh issue view N` shows every deferred-goal checklist entry ticked. `frame-goal` defers goals as checklist items; the first scan alone would let goal 1 close a parent that still owes later goals.

  A parent is closed by the last goal to ship, never by whichever merges first. Unsure → ask.

For a chain, every PR body includes the complete ordered branch table, with the current row marked and known PR numbers filled. Create with:

```bash
gh pr create --title "..." --body "..." --base <parent> --draft
```

Omit `--draft` when `ready` is requested. After creating each later chain PR, update PR 1's exact branch row with its PR number; never substring-match branch names.

When the plan links a shared parent, tick this goal's entry in the parent's task list and note the PR number (`gh issue edit`). The tick means *a PR exists*, not *merged* — the parent itself closes when the last goal's PR merges via its `Closes #N`. Skipping the tick strands the parent open forever, since the next sibling's closure check reads exactly these boxes.

## Archive and Cleanup

Immediately before archival, require the worktree is still clean.

Archive **inside the worktree, as a commit** — the plan is a tracked file on the branch, so an uncommitted status flip would either be lost at teardown or leave `$MAIN_ROOT` permanently diverged from what the merged branch says:

1. In `<worktree>`, on the **last** branch of the PR Pattern (single PR → its only branch; chain → the final slice, which merges last), set `Status: archived`, clear `Worktree:`, and commit `docs(<scope>): archive plan`. Push it so the open PR carries the final state.
2. Confirm `git -C <worktree> status --porcelain` is empty again.
3. Remove `$MAIN_ROOT`'s locator copy — it is scratch, untracked, and its content now lives in the branch commit. Verify **identity and persistence**, never content equality (the frozen locator and evolved worktree copy are *expected* to differ). Confirm:
   - locator is the exact resolved path, still under `$MAIN_ROOT/docs/plans/`, still untracked;
   - its `Worktree:` names the currently registered worktree;
   - locator and authoritative copy share same basename and `Issue: #<n>`;
   - authoritative copy is tracked in the final branch's `HEAD`, reads `Status: archived` with `Worktree:` cleared, and is pushed;
   - `git -C <worktree> status --porcelain` is empty.

   Any check failing → STOP and show which one. Then remove **only** that exact locator path. Do not require `$MAIN_ROOT` itself to be clean (`worktree.md` `$MAIN_ROOT sharing`).
4. From `$MAIN_ROOT`, remove the worktree normally. Refusal due to uncommitted/untracked state → STOP and show it; `--force` requires explicit destructive-action confirmation.

Chain note: the archive commit lands only on the final branch. Earlier PRs keep the plan at `reviewed`, which is true of them; merging in PR-Pattern order leaves `<base>` with the archived plan.

## Self-Check (BLOCKING)

- [ ] **Committed scope:** every branch has reviewed commits above its correct parent; worktree remained clean; artifact scan passed.
- [ ] **Description:** title, WHAT, HOW, Testing, and checklist are accurate to the actual diff; the issue verb was resolved, not assumed — `Closes` only where both conditions held (no other active plan links it **and** no unchecked deferred goal remains on it), `Refs` otherwise; a shared parent's entry for this goal was ticked with its PR number.
- [ ] **Chain, if used:** all rows/parents/order match the finalized pattern; every row carries a green-tip record whose `<sha>` is that branch's tip up to plan-only commits; each created number is linked from PR 1.
- [ ] **Archive safety:** the `archived` flip was committed on the last branch and pushed; locator identity and archived persistence were verified before removing that exact locator — never content equality, which the frozen locator is expected to fail; no uncommitted work in `<worktree>` and no forced teardown.

The first two checks gate publication. After PR creation, complete the chain and archive checks before copying or teardown. Then archive safely, remove the worktree, and emit PR URL(s) plus `Feature shipped.`

## Shipped, and what comes after

`archived` and `Feature shipped.` mean the PR exists and this cycle is closed — **never merged, never deployed**. From here the branch is immutable under this workflow: any requested change to the PR (review feedback, a follow-up fix) is a new artifact-bound cycle with its own plan, review, approval, and PR, linking a new issue or the same parent. Nothing reopens an archived plan or updates a PR in place, and teardown already removed the worktree one would need.

**A follow-up amending a PR that has not merged yet parents on that PR's branch, not `<base>`** — `<base>` does not contain the code being amended. The new plan records that branch in its PR Pattern `Parent` column and its PR targets it, so the two merge in order. Once the original merges, the follow-up parents on `<base>` like any other plan.
