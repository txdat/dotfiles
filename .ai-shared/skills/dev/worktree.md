# Worktree Lifecycle — Single Source

Referenced by execute-feature, fix-bug, review-code, and create-pr. Skills bind `<slug>`/`<branch>`/`<parent>` and may summarize entry needs, but this file defines the lifecycle. The governing rule — the worktree copy is the plan's single source of truth, and all git commands run there — is PROCESS `Plan worktree`.

- **Create (first run):** `<parent>` is always explicit — never implicit HEAD. Only the main agent runs these Git commands.
  ```bash
  MAIN_ROOT=$(git rev-parse --show-toplevel)
  WORKTREE="$HOME/work/ai-worktrees/$(basename "$MAIN_ROOT")-<slug>"
  git worktree add "$WORKTREE" -b <branch> <parent>
  ```
  Record `Worktree: <path>` (the resolved `$WORKTREE`) in the main-tree plan frontmatter immediately.
- **Plan copy (once, right after create):** design skills write `docs/plans/<file>.md` only into `$MAIN_ROOT`'s working tree — never committed there — so a fresh worktree checkout may lack both the file and its directory. After recording the worktree, run `mkdir -p "$WORKTREE/docs/plans"`, then `cp "$MAIN_ROOT/docs/plans/<file>.md" "$WORKTREE/docs/plans/<file>.md"`. Verify the copy before advancing status or running tests. If the initial copy failed, reuse the registered worktree and retry the copy only when its destination file is absent; never overwrite an existing worktree plan with the locator. From this point on, edit the plan *inside* the worktree only; the plan stays untracked in both trees throughout the lifecycle — never committed anywhere.
- **Dependency linking (once, before any test run):** for each dep dir present at `$MAIN_ROOT` and absent in the worktree (`node_modules`, `vendor`, `.venv`, `venv`, `Pods`, or project convention) — symlink, never reinstall or copy: `ln -s "$MAIN_ROOT/<dep>" "<worktree>/<dep>"`. This is a deliberate non-hermetic optimization: the worktree tests against `$MAIN_ROOT`'s installed tree, which is correct exactly while the two agree. (Dep dirs are normally gitignored; a project that doesn't ignore one leaves its symlink untracked, so teardown's `git worktree remove` will need confirmed `--force`.)
- **Dependency divergence — unlink *before* the command, never after a diff:** the symlink must be broken by **any command capable of changing dependency declarations or contents** (`npm|pnpm|yarn install|add|update`, `pip install`, `poetry add`, `go get`, `bundle add`, `cargo add`, `composer require`, …). Comparing manifests first does not work: `npm install <package>` writes into `$MAIN_ROOT/node_modules` *through the symlink* before updating the manifest — every concurrent worktree is already mutated. The trigger is the command's capability, not the pre-command diff. So, before running one:
  1. remove that dependency directory's **symlink** (`rm` the link itself, never its target);
  2. create a real local dependency directory in the worktree (`mkdir -p <worktree>/<dep>`);
  3. verify: `test -d <worktree>/<dep> && ! test -L <worktree>/<dep>` — skip this and the next step catches you, but the error is cryptic;
  4. run the command there.

  A read-only command (`npm test`, `npm ci --dry-run`, `pip list`) may keep using the symlink. Never install into `$MAIN_ROOT`'s shared dependency directory through the link. If the symlink cannot be safely unlinked, STOP and ask.
- **Resume:** `Worktree:` set → reuse it; `git worktree list` must show it (missing → STOP `❌ worktree <path> missing — recreate or ask`); verify ancestry — `git -C <worktree> merge-base --is-ancestor <parent> <branch>` non-zero → STOP `❌ <branch> not based on <parent>`.
- All plan commands run inside the worktree (`cd <worktree>` or `git -C <worktree>`).

**Plan resolution vs. truth:** resolution starts from `$MAIN_ROOT/docs/plans/<file>.md` (the worktree path is not otherwise discoverable) → reads `Worktree:` → absent → STOP. The main-tree file is a **scratch locator**: untracked, never committed, edited exactly once (the `Worktree:` record). Only abandonment writes to it again. The plan file is never committed anywhere — status flips and all plan edits stay in the untracked worktree copy. create-pr posts the plan as an issue comment, then removes both the locator and the worktree copy.

**`$MAIN_ROOT` sharing:** the main working tree is never checked out or committed to by any skill — only `git worktree add`/`remove` touch it. It stays on whatever branch it was on for the whole plan lifecycle, so it's safe to share across concurrent agents/plans on the same repo; each plan's isolation comes entirely from its own `<worktree>` + branch. The one shared-mutable-state exception is symlinked dependency directories — they point back into `$MAIN_ROOT`, which is exactly why a worktree that needs different dependencies breaks its symlink and installs locally (`Dependency divergence` above) rather than installing anywhere through the link. Nothing a plan does may mutate `$MAIN_ROOT`'s installed tree.
