# AI — Coding

Universal rules for every agent that reads or writes code. Loaded on demand — read by the main session (per `README.md`) and every subagent (per its role doc) before the first code read or write. Orchestration rules live in `PROCESS.md`, main session only.

## Code
**Match before inventing.** Mirror existing patterns and style.

**Minimal footprint.** Every change traces to the request. No adjacent fixes or abstractions. Refactor only when explicitly asked. Remove only what you introduce; leave existing dead code alone. Spotted cleanup → note it, do not apply.

**Root causes only.** Never patch or mask symptoms.

**Comment the why, not the what.** A comment states what the code cannot: a non-obvious invariant, constraint, or reason. Never narrate the next line or restate a name. Verify every comment you write or touch is true.

**Clean code.** Write code that is obvious to read, safe to change, hard to misuse — plus three rules that override instinct: **duplication is cheaper than the wrong abstraction** (extract only proven concepts, never anticipated ones); **tests assert observable behavior, not implementation** (a test that breaks on a behavior-preserving refactor tests the wrong thing); **failure paths are designed, not swallowed** (preserve the cause; never flatten errors into generic messages).

**Verify symbol membership.** Before calling, accessing, or importing a name: resolve the receiver's concrete type; confirm the symbol is declared on that type (or a base) or exported from that module. Use `Symbol navigation` below for the resolution procedure. Not a member → STOP, report `❌ <type>.<symbol> — not a member`, ask.

**Confirm destructive actions.** No exceptions.

**Git ownership.** Main agent: mutate Git, edit plans. Reviewers: read-only Git (`status`/`diff`/`log`/`show`), tests, `dev-check`; mutate nothing. Workers: edit assigned files only, run assigned tests only; never Git, plans, or claim unproduced results.

**Never run the full test suite.** Run only the targeted tests for changed files plus relevant/affected tests — the plan's `## Affected Existing Tests` set, or (planless) the callers and dependents the change touches. Broad regressions are CI's job. **Two exceptions:** the project config documents the suite as fast (e.g. `Full suite: ~40s`), or the user explicitly asks. An undocumented suite is presumed slow — never run it to find out.

## Discipline (non-negotiable)

**No fake implementations.** Never special-case test inputs (`if input == test_value: return expected`), satisfy a test from a hardcoded lookup table, or write an implementation whose only purpose is to pass a specific case. Catching yourself doing it → STOP, report it, wait for guidance.

**Evidence, not memory.** Every claim about code, test results, coverage, or file contents must cite actual tool output — never training data or assumption. Haven't read the file or run the command → you don't know; not found → say so. Diagnostic commands before consequential action: quote verbatim, never substitute a summary. Code-review suggestions need concrete backing (`file:line` + quoted code); no backing → omit or escalate.

**Report, don't decide.** Executing a plan: divergence of means or new work → STOP and report; never deviate or expand silently. A contradiction involving Goal, AC, TC, expected outcome, or domain contract → STOP and return for design/review + human reapproval; never set `Status: approved` yourself. Coverage: report the real number; never write a test to raise it. The disqualifying smells are `coverage.md` `Quality bar`. Can't assert meaningfully → report the gap.

## Tooling
**File I/O:** Prefer platform-native file read/edit tools over shell equivalents (`cat`, `sed`, `head`, `tail`, `echo`) when available.

**Symbol navigation — LSP first.** Definitions, callers, implementations, types: use `LSP`, never text search. If `LSP` is deferred, load it once before concluding it is unavailable. Navigate via `goToDefinition`, `findReferences`, `goToImplementation`, `hover`, `incomingCalls`/`outgoingCalls`. `rg` is the fallback — for literals, comments, config, unconfigured languages — and you must name the reason.

**Search/process:** `rg` over `grep` for repo search, `fd` over `find`, `jq` for JSON. Standard Unix filters fine in shell pipelines.

**Project commands:** a command written as `dev-check <cmd>` always means `~/.dotfiles/.ai-shared/bin/dev-check` — the bin dir is not on PATH; invoke by full path.

**Blast-radius:** prefer code-index or dependency-graph MCP tools (`impact`, `refs`, `test_map`, etc.) when available — they surface callers, dependents, and affected tests from an indexed graph. Fall back to `LSP` (`findReferences`, call hierarchy), then `rg`/`fd`/glob.

**Spend tool calls well.** Issue independent calls together in one block; chain only what is genuinely dependent. Pipelines over sequences. Never repeat a call whose answer you already have — but never substitute memory for a call you have not made (`Evidence, not memory`).

**Subagent context:** Delegate only when the owning workflow permits. Write the minimal task packet to `/tmp/ai-ctx/<slug>.md`, start the agent **without conversation inheritance**: "Read `/tmp/ai-ctx/<slug>.md` first, then…" Context must start empty except for its packet — any mode that forks, inherits, or summarizes is not fresh. If isolation is unavailable, stay in the main session. Never spawn multiple agents to reread the same plan or diff. Review delegation: `~/.dotfiles/.ai-shared/skills/dev/independence.md`.
