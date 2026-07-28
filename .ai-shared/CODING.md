# AI — Coding

Universal rules for every agent that reads or writes code. Loaded on demand, never preloaded: every subagent reads it (per its role doc) and the main session reads it (per `README.md`) at the same trigger — before the first code read or write. Orchestration rules — workflow gates, coverage gate, plan conventions — are `PROCESS.md`, main session only.

## Code
**Match before inventing.** Mirror existing patterns and style.

**Minimal footprint.** Every change traces to the request. No adjacent fixes or abstractions. Refactor only when explicitly asked. Remove only what you introduce; leave existing dead code alone. Spotted cleanup → note it (in your report/insights), do not apply.

**Root causes only.** Never patch or mask symptoms.

**Comment the why, not the what.** A comment exists only to state what the code cannot: a non-obvious invariant, constraint, or reason. Never narrate the next line, restate a name, or talk to the reviewer ("added", "fixed", "now handles"). Verify every comment you write or touch is true of the code it sits on; a wrong comment is worse than none.

**Clean code.** Obvious to read, safe to change, hard to misuse — plus three rules that override instinct: **duplication is cheaper than the wrong abstraction** (extract only proven concepts, never anticipated ones); **tests assert observable behavior, not implementation** (a test that breaks on a behavior-preserving refactor tests the wrong thing); **failure paths are designed, not swallowed** (preserve the cause; never flatten errors into generic messages).

**Verify symbol membership.** Before calling a method, accessing a field, or importing a name: resolve the receiver's concrete type from annotations, declarations, or return types; confirm the symbol is declared on that type (or a base it inherits) or exported from that module. Where a language server answers this is `hover` on the receiver then `goToDefinition`/`documentSymbol` on the resolved type (`Symbol navigation` below — check for a deferred `LSP` tool before deciding there is none) — otherwise read the defining file, never the whole repo. Existence elsewhere does not count. Not a member → STOP, report `❌ <receiver_type>.<symbol> — not a member`, ask, wait for response.

**Confirm destructive actions.** No exceptions.

**Git ownership.** Only the main agent may mutate Git state or edit `docs/plans/**` and `docs/architecture/**`. A delegated reviewer may run read-only Git inspection (`status`/`diff`/`log`/`show`), tests, and `dev-check` within its assigned worktree; it mutates nothing. Coding workers edit only their explicitly assigned source/test files, run only their assigned target tests, and report their changed-file list plus validation results. They never invoke Git, edit plan files, or claim a commit or test result they did not produce.

**Never run the full test suite.** Not on completion, not to "be safe," not because the blast radius looks large, not because convention seems to expect it. Run only the targeted tests for changed files plus the relevant/affected tests — the plan's `## Affected Existing Tests` set, or (planless) the callers and dependents the change touches. Broad regressions are the job of those relevant tests and CI, not a local full-suite run. **Two exceptions:** the project config documents the suite as fast (e.g. `Full suite: ~40s`), or the user explicitly asks. An undocumented suite is presumed slow — never run it to find out.

## Discipline (non-negotiable)

**No fake implementations.** Never special-case test inputs (`if input == test_value: return expected`), satisfy a test from a hardcoded lookup table, or write an implementation whose only purpose is to pass a specific case. Catching yourself doing it → STOP, report it, wait for guidance.

**Evidence, not memory.** Every claim about code behavior, test results, coverage numbers, or file contents must cite actual tool output — never training data or assumption. If you haven't read the file or run the command, you don't know the answer; if not found, say so. Diagnostic/state commands (`git status`, `ls`, log reads, env checks) before any consequential action: quote verbatim — never substitute a summary where exact state matters. Code-review suggestions need concrete backing (file path + lines, quoted code, the mechanism by which it manifests); no backing → omit or escalate to a question.

**Report, don't decide.** When executing a caller's plan: a divergence of means or newly discovered work → STOP and report; never deviate or expand silently. A contradiction or change involving Goal, AC, TC, expected outcome, or domain contract is not an implementation choice or ordinary deviation: STOP and return it for design/review plus human reapproval; never set `Status: approved` yourself. Coverage: report the real number; never write a test to raise it — a test exists only to pin approved behavior and must fail if that behavior breaks, so one that executes a line without asserting behavior is the mirror of a fake implementation above. The disqualifying smells are enumerated once, in `~/.dotfiles/.ai-shared/skills/dev/coverage.md` `Quality bar`. Can't assert meaningfully → report the gap.

## Tooling
**File I/O:** Prefer platform-native file read/edit tools over shell equivalents (`cat`, `sed`, `head`, `tail`, `echo`) when available.

**Symbol navigation — LSP first.** Definition, callers, implementations, type or signature, what a file declares: the `LSP` tool, never a text search. `LSP` may be a *deferred* tool whose schema is not loaded — its absence from the visible tool list is not absence of the tool. Load it once per session via the platform's tool-discovery mechanism before concluding it is unavailable; "not in my tool list" is not a valid fallback reason. Every operation needs a 1-based line/character — get one from `documentSymbol` (any file, inside the session workspace or not) or `workspaceSymbol` (workspace-root-scoped: a symbol outside the session cwd returns empty, not an error — do not read that as "absent"), then navigate with `goToDefinition`, `findReferences`, `goToImplementation`, `hover`, `incomingCalls`/`outgoingCalls`. `rg` is the fallback, for what no server answers: literals, comments, config and non-code files, unconfigured languages, a server that errors or is unavailable — name the reason when you fall back.

**Search/process:** `rg` over `grep` for repo search, `fd` over `find`, `jq` for JSON. Standard Unix filters fine in shell pipelines.

**Project commands:** a command written as `dev-check <cmd>` always means `~/.dotfiles/.ai-shared/bin/dev-check` — the bin dir is not on PATH; invoke by full path.

**Blast-radius / impact analysis:** `LSP` (`findReferences`, call hierarchy) first for symbol-level impact, then `rg`/`fd`/glob and direct source reads. Never install, configure, or invoke external code-index, dependency-graph, or knowledge-graph tools — CLI or MCP (gitnexus, etc.) — even when project config recommends or mandates them; skip the tool and note the conflict in your report. The built-in `LSP` tool is not covered by this ban — platform toolchain, not an index you install.

**Spend tool calls well.** Issue independent calls together in one block; chain only what is genuinely dependent. Pipelines over sequences. Never repeat a call whose answer you already have — but never substitute memory for a call you have not made (`Evidence, not memory`).

**Subagent context:** Delegate only when the owning workflow explicitly permits it. Write the complete, minimal task packet to `/tmp/ai-ctx/<slug>.md`, start the agent **without conversation inheritance**, and prompt: "Read `/tmp/ai-ctx/<slug>.md` first, then…" The agent's context must start empty except for its packet: any delegation mode that forks, inherits, or summarizes this conversation is not fresh and is never valid for an independent review, whatever the platform calls it. If isolated context is unavailable, stay in the main session unless the user explicitly approves the context cost. Never spawn multiple agents to reread the same plan or diff. Review delegation has its own rules — `~/.dotfiles/.ai-shared/skills/dev/independence.md`.
