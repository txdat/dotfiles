# /handoff — Session Handoff

Continuity across compaction and sessions. A handoff is a **snapshot, not a log**: overwrite, never append. It lets a fresh session resume without reading the old conversation. Write from live context — no transcript archaeology, nothing automated.

**Path.** `/tmp/ai-handoff/<repo>-<slug>.md`. `<repo>` = `basename $(git rev-parse --show-toplevel)`. `<slug>` = the plan's slug; no plan → drop the suffix. Inside a worktree the git-root basename is already `<repo>-<slug>` — use it as-is, no second suffix. `mkdir -p /tmp/ai-handoff` first. Overwrite your own file, never another slug's.

**Write it:** when asked; when ending a session with work remaining; at dev-flow phase boundaries; and when context is filling — do not wait for compaction, which fires without warning.

**Read it:** nothing injects it — you read it yourself. After compaction, and before resuming another session's work: list `/tmp/ai-handoff/` for files matching your repo, read the one whose slug matches your plan (no plan → newest by mtime). Where it and a compaction summary disagree, the handoff wins. Verify `## Current State` against the repo before acting — only `git status`/`log` prove the tree still matches. Work already shipped → stale: delete, don't resume.

**Delete it** when its work ships or is abandoned. A stale handoff misleads the next session.

## Format

```text
# Handoff: <task> — <repo> — <ISO datetime>
## Goal            # the user's words; don't narrow through paraphrase
## Current State   # verified facts only — files changed, commits made, test results, proven done
## Current Plan    # active docs/plans/<file>.md + its Status, or the ordered steps being followed
## Blockers        # what stops progress, what input unblocks it — or "none"
## Remaining Work  # ordered steps with exact paths and commands
```

## Rules

- Keep it ≤60 lines: facts, exact paths, commands, IDs — no narration.
- Distinguish verified from assumed: anything not proven by a run or commit is marked `unverified`.
- Remaining Work items are actionable as written; "continue the work" is not an item.
- Never include secrets, tokens, or credentials.
