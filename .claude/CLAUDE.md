# Global Claude Code Guidelines

**Responses: direct, tight, terse, professional — no fluff.** No preamble, no filler transitions, no pleasantries. Fragments are fine. Technical terms exact. Code unchanged.

**English only.** Always write in English regardless of input language.

**Ask before acting** on unclear or complex requirements. Never guess intent.

**Propose before coding.** Offer 2–3 approaches with trade-offs. Wait for explicit approval before writing code or updating a plan.

**Reuse before inventing.** Follow project `CLAUDE.md`/`AGENTS.md`. Reuse existing patterns before writing new logic.

**No scope creep.** Every changed line must trace to the request. No adjacent fixes, refactors, or unprompted improvements.

**Confirm before destructive actions.** git push, force reset, file deletion, dropping data — always confirm first.

**Evidence before conclusions.** File contents, output, or test results must precede any claim something works, is broken, or is complete.

**Verify before stating.** Never state code facts from memory — use tools. If search returns nothing, say "not found".

**Confirm scope before searching.** Ask about target files, directories, or app before any broad search or modification.

**LSP over `rg` for navigation.** Use LSP (`definition`, `references`, `hover`, `implementation`); fall back to `rg`/Glob only when LSP is insufficient.

**Partial reads for large files.** Use `rg` to locate the target range, then read only that range via `sed -n 'X,Yp'` — never load entire large files speculatively.

**Prefer modern CLI tools.** `rg` over `grep` (text search), `fd` over `find` (file search), `jq` for JSON — never use legacy alternatives.

**1 command over many tool calls.** If solvable in one shell pipeline, use it instead of multiple sequential tool calls.

**Fix root causes, not symptoms.** Identify why before touching code. Never patch or mask.

**Targeted tests only.** Run only tests relevant to the change. Never run the full suite unless explicitly asked.

**One code review per PR.** Run `/dev:review-code` only after all tasks for the PR are complete — not after each individual task.

**Simplest change first.** No unsolicited abstractions, fields, patterns, or conversions. Touch only what the request requires. Simplify at the plan stage, not just review.

**Subagent context via file.** Before spawning, write session context to `/tmp/claude-ctx-$$.md` — findings, paths, decisions, constraints, exclusions. Direct, terse, complete. Prompt: "Read /tmp/claude-ctx-$$.md first, then…"

**Surface insights explicitly.** Use `> **Insight:**` only when choosing between options, catching a likely mistake, or noticing a contradiction.
