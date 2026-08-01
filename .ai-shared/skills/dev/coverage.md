# Coverage Measurement — Single Source

Referenced by PROCESS gate #6 (thresholds, bands, and the stricter-only rule live there) and read by execute-feature/fix-bug at first scoring. PROCESS owns the gates; this file owns only measurement — so the measurement rules can't be edited to bypass a gate. Mechanics below; each names its **fallback** for when the stack can't measure what it asks.

- **Branch, not just line, for logic.** On business-logic/domain/service files the branches *are* the behavior (auth, state transitions, money math, validation, retry/idempotency); a red branch is an untested error path, i.e. a future incident. Gate on branch coverage. *Fallback where the stack cannot measure branch coverage:* gate line-% and flag each untested branch by name in the Coverage Gap.
- **Curate the denominator.** Exclude generated code, DTOs, serialization boilerplate, migrations, config, and `main`/wiring via the project's coverage config (omit/exclude globs), not by padding with hollow tests. *Fallback where editing that config is out of the step's scope:* don't exclude silently — note the boilerplate lines as excluded-by-reason in the Coverage Gap and score the rest. A meaningful 82% beats a hollow 92%.
- **Line coverage lies under mocks.** For DB/adapter/repository code, a mocked call shows green while the real query/isolation/constraint is wrong. Cover that layer with integration tests against real dependencies (testcontainers). *Fallback where real deps aren't wired into the step:* treat the mocked line-% as unverified — flag it, do not report it as ✅.

Use the project's own test command (as documented in its config for AI) with its coverage flag. Derive branch coverage from the tool's branch output where the stack supports it; fall back to line-% + flag untested branches by name where it does not.

## Closing a gap — behavior-first, never line-first

**When this section applies:** a ❌, or a ⚠️ you have decided to close. A ⚠️ you log and carry stops at step 1 — name the behavior in the Coverage Gap entry and continue (PROCESS #6). Logging an uncovered behavior is not Discovered Scope and is not a STOP; only an attempt to *close* it can surface PROCESS #7 work.

A red line is a symptom; the unit of testing is a behavior (input class, error path, state transition — a Given/When/Then), never a line. For a gap in scope:

1. Name the behavior each uncovered line/branch belongs to. Can't name one → boilerplate/unreachable: log excluded-by-reason (denominator curation above), don't test it.
2. Behavior already has a plan TC → the test is missing or misaligned: fix *that* test.
3. Behavior has no TC → discovered work, not a free test: log in `## Discovered Scope` and ask. Approved → add the TC intent line to the plan first, then author its body at RED like any other. **Tests enter through TCs only.**

A `## Coverage Gaps` entry names lines *and* the behavior each belongs to — a bare percentage is not an entry:

```text
⚠️ payments/refund.py — 84% branch (patch, diff-cover vs <base>)
   Uncovered: 112-118 — the gateway-timeout retry path (AC-3); no TC exercises a timeout.
   Uncovered: 131 — the `currency mismatch` guard; unreachable until multi-currency lands (Out of Scope).
   Carried, not closed: logging this is not Discovered Scope (PROCESS #6).
```

"⚠️ coverage 84% — will fix later" names no line and no behavior, so it hides the hole it claims to flag.

**Quality bar (every test):** a test must fail when the behavior it names breaks. Smells that fail it: assert-nothing (runs code, asserts no exception), trivial asserts (not-null, type-only, blanket snapshots), asserting a mock was called instead of the outcome, copying the implementation's expression into the expectation. Such a test raises % while verifying nothing — the mirror of a fake implementation; delete it and log the gap instead.

**Touched-line (patch) coverage** — PROCESS #6 gates lines *this change* touched, not the whole file. Where the run emits coverage XML, get patch granularity with `diff-cover coverage.xml --compare-branch=<base>`. Fallback (no XML/diff-cover): score the whole changed-file % (never repo-global). **That fallback dilutes most where the file is largest and best covered** — when scoring a whole file, read the uncovered-line list against the diff and gate touched lines by inspection. A ✅ no changed line earned is a false pass.
