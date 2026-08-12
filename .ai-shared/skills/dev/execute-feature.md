# /execute-feature — Implement the Approved Plan

`PROCESS.md` must be loaded before this skill runs — not in context → read it now.

Takes an exact `docs/plans/<file>.md` per PROCESS `Named plan and entry gates`. Entry status is `approved` or `in-progress`; `gate-check` owns plan/issue/status. Read the Goal, every AC and TC, `## Open Risks`, the plan, and project config for AI. Open Risks are gaps deferred from design review — resolve each during RED by adding a TC that covers it, or confirm existing TCs already cover it and remove the entry. `$ARGUMENTS`: `<plan> [from N|N]`; partial execution must preserve dependency order. No TODO placeholders.

## Setup

Use `worktree.md` exactly. Bind `<slug>` from the plan filename; single branch `<type>/<slug>`, chain branches `<type>/<slug>-k`. Take every `<parent>` from the finalized `## PR Pattern` table's `Parent` column — normally `<base>` for the first branch and the preceding branch for later slices, but a follow-up amending an unmerged PR parents on that PR's branch (`create-pr.md` `Shipped, and what comes after`). Never default to `<base>` when a parent is recorded. Never commit to `<base>` or edit the main-tree locator after copying it.

Once the worktree copy exists, set `Status: in-progress` and commit `docs(<scope>): start plan execution` before proof. Plan edits are separate from proof commits.

`in-progress` means *execution was entered*, not that proof exists. On resume, read the worktree's commits, not the status: no proof commit → start at RED; proof present → `tdd.md` step 3 governs which proof is reusable. A slice with neither proof nor implementation has no work to preserve.

## Strategy

Execute inline by default. Delegation is permitted **only** when more than three steps are genuinely independent and each owns an exclusive set of source/test files; otherwise every step runs inline, whatever its difficulty. When that bar is met, route each delegated step by its nature, not by convenience: critical → `senior-engineer`; simple and well-patterned → `junior-engineer`. Workers receive the Goal, owning ACs, TCs, steps, critical invariants, file ownership, and off-limits paths, and may neither edit plans nor run Git. The main agent verifies the resulting file union, reruns the union of targeted tests and coverage, and alone commits.

Security, concurrency, or data-integrity steps are critical: state invariants and failure modes before editing, whether inline or delegated.

## RED → GREEN → BLUE

Read and follow `tdd.md` (single source).

**The RED commit authors the TC body.** The plan carries each TC's one-line intent and its `Proves:`; the Given/When/Then is written here, as a running test. The AC is the oracle for what the test must assert — the intent line names the scenario, it does not license a different one. Back-fill the plan's `Test:` field with `path::name` in a `docs(<scope>): record TC tests` commit **immediately after** the proof commit — never inside it: plan edits stay separate from proof commits (Setup above), and `dev-check proof` blocks a `docs/plans/` path outright.

The three mechanical rules governing that authorship — reject-if-green on a stub-free baseline, fails-for-the-right-reason, unconstructible-arrangement — are `tdd.md` step 2; record each new test's individual baseline result as you go.

The approved Goal → AC → TC spec is the oracle; TDD consumes it and may not invent or reinterpret behavior. For a single PR, execute all TCs as one proof/GREEN unit. For a chain, process slices sequentially in PR-Pattern order; each slice gets its own branch and proof/GREEN pair scoped to the TCs wholly owned by that slice.

Before each GREEN:

1. Verify each new call, field access, and import against its target type/module per CODING.
2. Run `dev-check proof <commit> [--test <in-source-test-path>] [--stub <throwing-stub-path>]`.
3. Commit implementation separately after its targeted tests pass. Any test-input special case or hardcoded expected-value table is a fake implementation → STOP and report.

After all GREEN work, perform BLUE as defined in `tdd.md`: inspect for worthwhile simplification and refactor only when beneficial. If BLUE changed a file, the main session verifies behavior preservation and reruns its targeted tests and coverage. "No refactor needed" is valid. Do not dispatch `code-quality-auditor` during BLUE unless the user explicitly requests a delegated audit; its sanctioned dispatch is review-code's Independence rule.

## Verification

For every changed file, derive targeted tests using project conventions, semantic references, then filename/import search. No test found → log a Coverage Gap and STOP: return through design/review and re-approval for a new TC, accept a stated gap, or split. Never add unapproved behavior and never run the full suite unless CODING permits it.

At first scoring read `coverage.md`. Measure touched/changed files, run `dev-check coverage <percent> [uncovered-critical]`, and apply PROCESS #6 judgment. Log every ⚠️/❌ in `## Coverage Gaps`, naming the uncovered lines and the behavior each belongs to. **⚠️ → log and continue; ❌ → STOP and ask.** Coverage-driven new behavior must enter through a reviewed, re-approved plan TC.

After GREEN/BLUE, follow `dependents.md` for every changed externally reachable symbol. Breakage or unresolved reachability → log `## Discovered Scope`, STOP, and ask: re-plan/re-review, separate, or narrow via a recorded PROCESS #5 deviation. Never ship a known-broken caller.

Run lint, build, the TC tests, and `## Affected Existing Tests`. **In a chain, run them at each slice's tip before starting the next slice** — atomicity is a per-slice property (`design-feature` `PR Pattern`), and a slice whose tests need a later slice's code is a slice boundary in the wrong place: STOP and route the correction through `approval.md` rather than carrying the dependency forward. Root-cause failures: regression → fix implementation; incomplete implementation → finish its step. A conflict among Goal, AC, TC, domain contract, or observed intended behavior is not a free deviation: STOP and go back through `approval.md`. Run `dev-check artifacts <base> HEAD`.

Scope discovered beyond the approved plan follows PROCESS #7; divergence of means within unchanged behavior follows PROCESS #5. Which of the two you are looking at, and what a behavior change costs, is `approval.md` — do not re-derive it here.

## Self-Check (BLOCKING)

- [ ] **Behavior:** every TC is implemented, its parent AC and the Goal are satisfied, and targeted/affected tests, lint, and build pass; failures were root-caused. Chain: each slice tip was green on its own before the next slice began. Tips verified: __.
- [ ] **TC authorship:** every TC body was authored in its RED commit and observed failing **individually**, on a stub-free baseline (or at GREEN-minus-one where the stub was load-bearing), for the absence of its named behavior — not for a stub, an import error, or a suite-level exit code; its plan line carries `Test: path::name`, back-filled in the docs commit after proof; no test was made to fail by weakening implementation or stubbing; any unconstructible arrangement was STOP-routed through `approval.md`, never substituted. Per-test baseline results: __.
- [ ] **Symbols and implementation:** all new symbols resolve; no fake implementation or hollow test. Issues: __.
- [ ] **Coverage:** each changed file is ✅ or ⚠️ logged; no unresolved ❌; BLUE-touched files remeasured. Gaps: __.
- [ ] **Dependents:** evidence blocks complete; breakage/unknowns were STOP-asked. Open: __.
- [ ] **Scope:** all deviations have four PROCESS #5 fields; discoveries follow PROCESS #7. Open: __.
- [ ] **Delegation, if used:** exclusive ownership held; main agent verified file union and reran combined tests/coverage. Violations: __.

All checked → set the worktree plan to `implemented`, commit `docs(<scope>): mark plan implemented`, and emit: `Implementation complete. Run the dev-review-code skill for independent AC verification.` Surface non-empty Coverage Gaps and Deviations.
