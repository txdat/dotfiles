## Sverklo — Code Intelligence

Read once when `mcp__sverklo__*` tools are present, per `CODING.md`'s code navigation cascade. Sverklo is a code-intelligence index: ranked search, dependency graph, persistent memory. Use it as the **default** tool for code discovery in whatever repository is loaded. Navigation only — response voice is `AGENTS.md` `Communication`'s, and config overrides only how code is written (`AGENTS.md` `Precedence`).

### Always Do

- **MUST call `overview` before exploring an unfamiliar directory.** It returns the PageRank-ranked map of the codebase in one call — much cheaper than `ls` + `Read` loops.
- **MUST use `search` instead of Grep for any query that is conceptual or fuzzy** ("how does auth work", "anything related to billing", "where do we handle retries"). Grep is for exact strings only.
- **MUST use `lookup` to find a symbol's definition** by name — never grep + Read for this.
- **MUST run `impact` before renaming, deleting, or changing the signature of any function/class/method** that may be called from elsewhere. Report the blast radius (callers, depth) to the user before editing.
- **MUST use `refs` to enumerate callers of a symbol.**
- **MUST use `deps` to see imports + importers of a file** before moving or splitting it.
- **MUST call `remember` when the user corrects you** with phrasing like "stop X", "never X", "always Y", "don't Y", "prefer Z", "remember that I want Q", "actually, do W". Save with `category:correction` (stop/never/don't) or `category:preference` (prefer/want/like), `kind:semantic`, and the user's instruction as content. Save before continuing the response. Do not ask permission — corrections are explicit instructions to persist behavior across sessions.
- **MUST call `recall` at the start of work** on a non-trivial task to surface prior decisions and corrections.

### Never Do

- **NEVER use Grep when the query is conceptual.** Grep cannot find "the auth flow" — sverklo's `search` can.
- **NEVER edit a function or class without first running `impact`** on it. Silently breaking a caller is the most expensive bug this codebase produces.
- **NEVER ignore HIGH or CRITICAL impact warnings** without surfacing them to the user.
- **NEVER rename symbols with find-and-replace.** Use `refs` first; it knows which "foo" is the function and which is a string.
- **NEVER save routine task summaries to memory.** `recall` is only useful when hits are signal-dense — save only (a) bugs that took >1h to debug, (b) recurring mistakes, (c) non-obvious architectural decisions, (d) audit findings needing user judgment.
- **NEVER re-read a file sverklo just returned a path for.** Use `lookup` for the specific symbol instead.

### When Grep / Read still wins

| Task | Tool |
|---|---|
| Exact string match (`"TODO(alice)"`, error message text) | Grep |
| Read a known file at a known path | Read |
| Inspect a specific line range | Read with offset/limit |

### Exploration order

`overview` (1 call) → `search` (1 call) → `lookup` on the top hit → `refs` / `impact` only if you need the blast radius. If you've made 5 sverklo calls and still don't have the answer, **stop and ask a clarifying question** — don't burn 10 more.
