## Sverklo — Code Exploration and Lookup

Read once before using Sverklo, the second tier in `CODING.md`'s LSP → Sverklo → shell search/tracing cascade. Use it when LSP is unavailable, unsupported, stale, or inconclusive for the query, and only for code exploration and symbol lookup in the current repository.

| Need | Tool |
|---|---|
| Map an unfamiliar directory or subsystem | `overview` |
| Find code by concept or behavior | `search` |
| Locate a symbol and inspect its definition | `lookup` |

Use only these read-only Sverklo operations. Do not call `remember`, `recall`, or other memory, mutation, or management operations. User corrections apply within their stated scope; this tool does not persist them.

Limit Sverklo to five calls total per exploration task, across `overview`, `search`, and `lookup`, including retries. If the question remains unresolved after five calls, continue with shell search/tracing; reaching the budget does not require asking the user. Fall back sooner when the conditions below apply.

Read returned source as evidence and verify that it belongs to the intended repository. A returned path is a locator, not the file contents: read the file or relevant lines when needed. Exact strings, known paths, and configuration can go directly through shell search or file reads.

Start with the operation that answers the question; an existing symbol name usually needs only `lookup`. If the index is unavailable, stale, unsupported, or inconclusive, or the query requires an operation outside this allowed set, continue to shell search/tracing. Caller and impact checks do not expand the allowed operations. Do not switch to another provider. Ask about missing requirements only when the available evidence cannot resolve a material decision.
