# AI — Coding

Universal rules for every agent that reads or writes code. Loaded before the first code read or write — by the main session and every subagent (per its role doc).

## Code
**Match before inventing.** Mirror existing patterns and style.

**Minimal footprint.** Every change traces to the request. No adjacent fixes or abstractions. Refactor only when explicitly asked. Remove only what you introduce; leave existing dead code alone. Spotted cleanup → note it, do not apply.

**Address causes.** Prefer a fix supported by root-cause evidence. An authorized mitigation may reduce impact while diagnosis continues; label it as temporary, explain its limits and removal condition, and preserve evidence of the underlying failure.

**Comment the why, not the what.** A comment states what the code cannot: a non-obvious invariant, constraint, or reason. Never narrate the next line or restate a name. Verify every comment you write or touch is true.

**Clean code.** Write code that is obvious to read, safe to change, hard to misuse — plus three rules that override instinct: **duplication is cheaper than the wrong abstraction** (extract only proven concepts, never anticipated ones); **tests assert observable behavior, not implementation** (a test that breaks on a behavior-preserving refactor tests the wrong thing); **failure paths are designed, not swallowed** (preserve the cause; never flatten errors into generic messages).

**Verify symbols.** Before introducing or changing a call, access, or import, confirm it against the actual type or module using `Code navigation cascade` below. Correct an invalid reference when the intended behavior and valid replacement are clear. Ask only when resolving it requires a contract, scope, or material design decision. For dynamic or generated APIs, use declarations, generation sources, or focused runtime evidence; do not invent members.

**Authorize destructive actions.** Confirm the target and consequences before an irreversible or destructive action outside existing authorization. Explicit authorization for that same action and scope persists; ask again only when the target, consequences, or scope materially change. Respect platform approval controls.

**Git ownership.** Main agent: mutate Git. Subagents: only the scope their task assigns — read-only Git (`status`/`diff`/`log`/`show`) unless explicitly granted write; never claim unproduced results.

**Match verification to impact.** Start with targeted tests and affected callers/dependents, plus required project checks. Run the full suite when requested, required, known to be inexpensive, or necessary because affected tests cannot be isolated. For unknown cost, inspect test configuration and available timing evidence first; use a bounded run when safe. Report skipped or incomplete checks and their implications. Passing targeted tests does not prove unrelated behavior.

## Discipline (non-negotiable)

**No fake implementations.** Never special-case test inputs (`if input == test_value: return expected`) or substitute canned answers for required behavior. If you catch this, correct the implementation and rerun meaningful tests before claiming success. Ask when the intended behavior is unresolved.

**Evidence, not memory.** Ground claims about repository contents, behavior, test results, and coverage in inspected files or actual tool output. Distinguish inference from observation and unrun checks from passing checks. Cite relevant file locations or commands and summarize the decisive result; quote exact output when its wording matters. Never expose secrets in evidence. Review findings need a concrete location, failure mechanism, and consequence; label unverified concerns as questions.

**Report, don't decide.** Preserve agreed behavior, scope, and constraints. Resolve routine implementation details with evidence. For plan-backed work, record deviations under PROCESS #4; new scope follows #6. Pause the affected action for a contract conflict, material risk change, or decision outside authorization, and continue independent work. Coverage: report the real number; add tests for meaningful missing behavior, never merely to raise it. If no meaningful assertion is possible, report the gap.

## Tooling
**File I/O:** Prefer platform-native file read/edit tools over shell equivalents (`cat`, `sed`, `head`, `tail`, `echo`).

**Code navigation cascade.** For semantic navigation, use the highest available tier that supports the target code:

1. **Sverklo** (`mcp__sverklo__*`) — code search, symbol lookup, codebase navigation. If `mcp__sverklo__*` tools are present: read `~/.dotfiles/.ai-shared/skills/dev/sverklo.md` once, then use it first for supported semantic queries.
2. **LSP** — definitions, callers, implementations, types. Load it once if deferred before concluding unavailable. Navigate via `goToDefinition`, `findReferences`, `goToImplementation`, `hover`, `incomingCalls`/`outgoingCalls`.
3. **Shell search** — `rg` over `grep`, `fd` over `find`, `jq` for JSON. Use directly for literals, comments, and config; also use when semantic tools are unavailable, unsupported, or inconclusive. Explain a fallback only when it limits confidence in the result.

**Blast-radius.** Prefer code-index or dependency-graph MCP tools (`impact`, `refs`, `test_map`) when available for callers, dependents, and affected tests. Fall back through the navigation cascade above.

**Project commands:** `dev-check <cmd>` means `~/.dotfiles/.ai-shared/bin/dev-check` — not on PATH; invoke by full path.

**Spend tool calls well.** Batch independent reads and searches; keep dependent actions and mutations sequential. Reuse results while their inputs remain unchanged. Repeat checks after relevant changes or when evidence is stale or incomplete.

**Subagent context:** Delegate only when the owning workflow permits. Write the minimal task packet to `/tmp/ai-ctx/<slug>.md`, start the agent **without conversation inheritance**: "Read `/tmp/ai-ctx/<slug>.md` first, then…" Context must start empty except for its packet. If isolation is unavailable, stay in the main session. Never spawn multiple agents to reread the same diff.
