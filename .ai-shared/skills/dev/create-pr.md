# /create-pr — Publish Reviewed Work

If `~/.dotfiles/.ai-shared/PROCESS.md` is not yet loaded, read it first.

Takes an exact `docs/plans/<file>.md` per PROCESS `Named plan and entry gates`. Entry status is `reviewed`; `gate-check` also requires issue, worktree, and finalized PR Pattern. Read the plan and AI project configuration, then run everything in `<worktree>`.

Default is draft; `$ARGUMENTS` may include `ready`.

## Preflight

1. Bind `<base>` from the plan's `Base:` field (PROCESS `Base branch`); missing or empty → STOP. Resolve every branch **and its parent** from the finalized `## PR Pattern` table's `Parent` column; never infer a parent from the current checkout, and never substitute `<base>` for a recorded parent. Usually that is `<base>` for a single PR or slice 1 and the preceding branch for later slices — but a follow-up amending an unmerged PR records that PR's branch, and its own PR must target it (`Shipped, and what comes after` below). A row with no parent → STOP; return through review-code to finalize the pattern.
2. Require `git status --porcelain --untracked-files=all` shows only the untracked plan file (`?? docs/plans/...`) before switching branches. Any other dirty state returns to execution/review; create-pr never commits it.
3. For each branch, require it exists and has commits above its parent; empty slice → absorb or drop it, then return through review-code. For a chain, require the finalized pattern's `Slice N (<branch>): green at <sha>` line for every row, with `<sha>` matching that branch's current tip. Missing, or stale because code moved after review → return through review-code; publishing a slice that is not green alone is publishing a PR that cannot merge or revert alone.
4. Run `dev-check artifacts <parent> <branch>`.

## Publish

For each PR in PR-Pattern order, check out its branch and create a body from the plan plus `git diff <parent>..<branch>`. Before creating it, query GitHub for an existing PR with this exact repository, head, and base. Reuse a matching PR on retry after checking its head SHA against the reviewed branch tip. Multiple matches, a different tip, or a closed unmerged PR → STOP and report; never create a duplicate to bypass the mismatch.

- title `<type>(<scope>): <summary>` under 72 characters;
- WHAT: 3–6 behavior bullets;
- HOW: approach, decisions, correctness, out of scope;
- Testing: automated evidence and manual steps;
- project checklist, or default checklist;
- the plan's issue link, initially `Refs #N`. Resolve the final closing reference under `Issue closure` after all PRs exist and the current goal's checkbox is updated.

For a chain, every PR body includes the complete ordered branch table, with the current row marked and known PR numbers filled. Write the exact multiline body to a temporary file, then create with:

```bash
gh pr create --title "..." --body-file <body-file> --base <parent> --draft
```

Omit `--draft` when `ready` is requested. After creating each later chain PR, update PR 1's exact branch row with its PR number; never substring-match branch names.

When the plan links a shared parent, tick this goal's entry only after all its PRs exist, and record their numbers (`gh issue edit`). The tick means *PRs exist*, not *merged*. Preserve other goals' entries. If publication was partial, leave this goal unchecked and resume using its existing PRs.

## Issue closure

After updating the current goal's checkbox, fetch the issue again. Two checks, in order — both must pass for `Closes #N`; either failing → retain `Refs #N`:

  1. **Sole active claimant:** `rg -l 'Issue: #N\b' "$MAIN_ROOT/docs/plans/"` lists only this plan **once every hit whose header reads `Status: abandoned` is discarded**. Archival removes each shipped plan's locator, but `approval.md` `Abandoning a plan` keeps an abandoned one's locator on purpose — so without that filter a dropped sibling reads as a live claimant and the parent can never be closed.
  2. **No unchecked deferred goals:** `gh issue view N` shows every deferred-goal checklist entry ticked. `frame-goal` defers goals as checklist items; the first scan alone would let goal 1 close a parent that still owes later goals.

Rewrite the body file with the resolved reference, then apply it (`gh pr edit --body-file <body-file>`). For a chain, only its final PR may carry `Closes #N`; preceding PRs retain `Refs #N`. Verify the resulting body before archival. A failed checkbox or body update leaves the plan `reviewed` so publication can resume. Unsure which goal entry belongs to this plan → ask before editing it.

## Plan Comment and Cleanup

The plan is never committed. Keep the live worktree plan `reviewed`, with `Worktree:` intact, until teardown. Only the issue-comment snapshot carries `Status: archived` and an empty `Worktree:`. This keeps failed **publication** resumable through the existing entry gate; teardown has its own resume rules below.

1. Require the worktree is clean — `git -C <worktree> status --porcelain --untracked-files=all` shows only the untracked plan file.
2. Copy the worktree plan to a snapshot outside both Git trees. Set only its status to `archived` and clear only its `Worktree:`. Use a stable comment marker containing the repository, plan basename, issue number, and reviewed branch SHAs. Check issue comments for that marker before posting. An identical verified comment is reused; a conflicting match → STOP. Otherwise post with `gh issue comment <n> --body-file <snapshot-file>` and fetch the comment to verify its full content. If posting or verification fails, keep both local plans, report the failure, and stop. On retry, query comments first because the server may have accepted a request whose response was lost.
3. Before deleting anything, report the verified comment URL. Confirm:
   - locator is the exact resolved path, still under `$MAIN_ROOT/docs/plans/`, still untracked;
   - its `Worktree:` names the currently registered worktree;
   - locator and worktree copy share same basename and `Issue: #<n>`.

   Any check failing → STOP and show which one. Keep the locator until worktree removal succeeds. Do not require `$MAIN_ROOT` itself to be clean (`worktree.md` `$MAIN_ROOT sharing`).
4. Remove the untracked worktree plan file if still present, then remove the worktree normally from `$MAIN_ROOT`. If resuming with that plan file already gone, first reverify the matching archive comment and locator identity against its marker; no matching comment → STOP. Refusal → keep the locator and show git's message. `--force` requires explicit destructive-action confirmation. The verified issue comment holds the plan; no local restore is needed.
5. Confirm the worktree is no longer registered and its directory is gone. If it was already gone when teardown resumed, first confirm the issue carries this publication's verified archive comment, matching its marker and reviewed branch SHAs; no matching comment → STOP. Recheck the locator's exact path, untracked state, issue, basename, and `Worktree:` pointing to the removed worktree. A changed locator → STOP. Remove only that verified locator. The issue comment is the surviving archived record.

## Self-Check (BLOCKING)

- [ ] **Committed scope:** every branch has reviewed commits above its correct parent; worktree remained clean; artifact scan passed.
- [ ] **Description:** title, WHAT, HOW, Testing, and checklist are accurate to the actual diff. After all PRs existed and this goal's checkbox was updated, the issue verb was resolved and its PR body verified — `Closes` only where both conditions held (no other active plan links it **and** no unchecked deferred goal remains on it), `Refs` otherwise. Only the final PR of a chain carries a closing reference.
- [ ] **Chain, if used:** all rows/parents/order match the finalized pattern; every row carries a green-tip record whose `<sha>` matches that branch's current tip; each created number is linked from PR 1.
- [ ] **Plan comment:** the full archived snapshot was verified on the issue before local deletion; retries reused matching PRs/comments; the live plan stayed `reviewed` until teardown. Locator identity was verified, and the locator was removed only after successful worktree removal. No forced teardown remains.

Committed scope and description accuracy gate PR creation. After creation, verify the resolved issue reference and chain links, archive the plan, and complete cleanup. Only then emit PR URL(s) plus `Feature shipped.`

## Shipped, and what comes after

`archived` and `Feature shipped.` mean the PR exists and this cycle is closed — **never merged, never deployed**. From here the branch is immutable under this workflow: any requested change to the PR (review feedback, a follow-up fix) is a new artifact-bound cycle with its own plan, review, approval, and PR, linking a new issue or the same parent. Nothing reopens an archived plan or updates a PR in place, and teardown already removed the worktree one would need.

**A follow-up amending a PR that has not merged yet parents on that PR's branch, not `<base>`** — `<base>` does not contain the code being amended. The new plan records that branch in its PR Pattern `Parent` column and its PR targets it, so the two merge in order. Once the original merges, the follow-up parents on `<base>` like any other plan.
