# /handoff — Session Handoff

Continuity across compaction and across sessions. A handoff is a living **snapshot, not a log**: overwrite the file, never append history. It must let a fresh session act correctly without reading the old conversation. You write it from live context — no transcript archaeology, and nothing automated does it for you.

**Path.** `/tmp/ai-handoff/<repo-basename>-<slug>.md` (`mkdir -p /tmp/ai-handoff` first). `<repo-basename>` is the basename of `git rev-parse --show-toplevel`. `<slug>` is the slug of the plan this session is working on — many sessions can work one repo, so the plan distinguishes them. No plan in play → drop the suffix. A worktree's git-root basename is already `<repo>-<slug>`: use it as-is, never a second suffix. Overwrite your own file, never another slug's.

**Write it:** when you are asked to hand off; when ending a session with work remaining; at dev-flow phase boundaries in a long session; and when context is filling — do not wait for compaction, which may fire without warning.

**Read it:** yourself — nothing injects it. After compaction, and before continuing another session's work on a repo, list `/tmp/ai-handoff/` for files matching your repo basename and read the one whose slug matches your plan (no plan → the newest match). Where it and a compaction summary disagree, the handoff wins. Verify its Current State against the repo before acting on it: the file is a claim from another session, and only `git status`/`log` prove the tree still matches. If its work already shipped, it is stale — delete it instead of resuming.

**Delete it** when its work ships or is abandoned. A stale handoff misleads the next session.

## Format

```text
# Handoff: <task> — <repo> — <ISO datetime>
## Goal            # the user's requested outcome — preserve their intent, not a paraphrase that narrows it
## Current State   # only verified facts: files changed, commits made, test results, what is proven done
## Current Plan    # active docs/plans/<file>.md + its Status, or the ordered steps being followed
## Blockers        # what stops progress and exactly what input/decision unblocks it — or "none"
## Remaining Work  # ordered, concrete next steps with exact paths/commands
```

## Rules

- Keep it under ~60 lines: facts, exact paths, commands, and IDs — no narration.
- Distinguish verified from assumed: anything not proven by a run or commit is marked `unverified`.
- Remaining Work items are actionable as written; "continue the work" is not an item.
- Never include secrets, tokens, or credentials.
