# /review-code — Review Implemented Plan Work

Main agent: load `PROCESS.md` if needed. A delegated reviewer uses its packet, this file, and the references below; it does not load PROCESS or resolve the main-tree locator.

Entry: exact `docs/plans/<file>.md`, `Status: implemented`. The worktree plan is authoritative. `gate-check` checks metadata, traceability closure, and proof ordering; those checks do not establish behavioral correctness. Bind `<review-base>` from the first PR slice's recorded `Parent`. `Base:` is presence-checked for create-pr only. Review `<review-base>..HEAD` inside `<worktree>`, including reads, tests, and Git inspection. This includes all plan slices and excludes inherited work from an unmerged parent.

## Independence and scope

Follow `independence.md` for reviewer context, authority, re-review, and escalation. The reviewer reports findings; the main agent owns edits, status changes, and PR Pattern finalization. Review-only authorization permits no fixes. Authorized delivery or revision-and-verification includes in-scope repairs and independent re-review.

Load the approved plan, project config, diff, changed files/tests, and only the definitions or callers needed to verify behavior or a concrete concern. Inventory once and batch independent reads. On re-review, focus new checks on the revision and affected dependencies. Reusable independent evidence must identify its reviewed revision, commands, per-test results, and relevant dependency/environment state. Inspect it and verify that intervening changes preserve its inputs; a previous verdict alone is insufficient. Missing or stale evidence requires fresh checks. Reference reusable evidence from the plan's Review History so a fresh reviewer can find it.

## Review procedure

Read `tdd.md` for proof requirements and `coverage.md` for measurement and test quality. Start with the Goal, ACs, diff name/status, stat, and proof history. Use one integrated pass and one evidence table:

`TC | AC | test path | proof/baseline result | implementation/assertion evidence | current result`

### A. Goal, contracts, and tests

Independently describe the required outcome before treating tests as an oracle. For each AC:

- Verify its Source, Success, and Failure against the Goal and delivered behavior.
- Map every clause to an assertion that reaches it. A clause without meaningful evidence is blocking.
- Attempt a concrete implementation that passes its TCs while violating the AC or Goal; record the counterexample and what defeats it.
- Check each TC's `Proves:` and `Test: path::name` against the actual scenario, production entry point, and assertion. A test joined below the relevant production behavior does not prove that entry point.
- Verify tests fail when their named behavior breaks. Apply `coverage.md`'s quality bar, including vacuous assertions, implementation mirroring, and untested failure paths.

TC bodies are first reviewed here; plan review assessed their intent only. Run `dev-check proof <commit> [--test <path>] [--stub <path>]` for relevant proof commits, inspect their contents, and verify per-test baseline/failure evidence under `tdd.md`. Targeted batches are valid when they expose each test's result and failure reason. Independently run TC tests and `## Affected Existing Tests`, subject to the evidence-reuse rule above.

Confirm `## Open Risks` is empty: existing approved TCs must settle each recorded verification uncertainty. New or changed TC semantics follow `approval.md`; the risk entry itself grants no authority. Editorial corrections preserve meaning and follow that same file's classification rule.

Roll the table into an `AC-N: PASS|FAIL — evidence` conclusion for every AC. Passing tests cannot override a failed AC or Goal. Implementation failure against a sound spec is rework; a wrong or ambiguous spec returns through `approval.md`.

### B. Architecture and data

Check applicable boundaries, query safety, transactions/concurrency, compatibility, security/data exposure, observability, performance, and each Non-functional commitment. Verify new calls, fields, and imports against actual types/modules. For shared mutable state used as a decision input or signal, follow `dependents.md`: inspect other writers and invalidate assumptions contradicted by their semantics. Restrict this to affected paths and credible consumers.

### C. Scope and hygiene

Compare the diff with Implementation Steps and `## Design Decisions`. Verify deviations have substantive `Plan said / Doing instead / Why / Tradeoff` fields; report missing entries for the main agent to record. An absent `## Deviations` section is not evidence of alignment. Dropping a required design decision is a scope finding, not a style preference. Material risk changes require the decision described by PROCESS #4; new scope follows #6. A delegated reviewer reports either for the main agent to resolve.

Check secrets, TODO/debug/conflict artifacts, then run `dev-check artifacts <review-base> HEAD`. Verify coverage evidence, affected callers, and any retained proof after a spec amendment.

### D. Efficiency and readability

Inspect changed paths for excessive complexity, N+1 queries, inefficient queries, redundant computation, hot-path allocations, unsuitable data structures, misleading names, unnecessary duplication or abstractions, unexplained constants, and newly introduced dead code. Report concrete consequences rather than generic preferences. A performance defect that risks failure or data loss is blocking; readability preferences are non-blocking.

For UI changes, inspect applicable requirements in `frontend-design.md`. A failed AC is blocking; other quality-floor misses are Should fix unless they independently cause a blocking correctness or safety defect. Required design decisions remain scope checks under C.

## Verdict and evidence

A blocking correctness, security, data-integrity, spec, or verification defect → `REWORK REQUIRED`. Otherwise classify observations as `Should fix` (material minor risk/debt) or `Skip` (negligible, intentional, or outside scope). Should fix items yield `PASS WITH NOTES`; none yields `PASS`.

Report the verdict and Goal outcome, AC conclusions, the single TC evidence table, and findings as `file:line — issue — consequence — required change`. Include counterexamples and commands/results with the evidence they support; do not repeat them in a second checklist report. Omit empty categories. Preserve uncertainty and unrun checks.

## Self-Check (BLOCKING)

Reference evidence already recorded in the table/report. Conditional domain checks may be N/A with a reason; required behavioral and proof checks may not.

- [ ] Authority, reviewer independence, correct worktree/range, and repair budget verified.
- [ ] Every AC and clause has outcome/assertion evidence and a concrete counterexample check.
- [ ] Every TC maps to the correct scenario, production entry point, and actual test.
- [ ] Proof commits and per-test baseline results inspected; no pending new-API sensitivity check remains.
- [ ] TC and affected tests have current independent results; reused evidence has verified inputs.
- [ ] Applicable architecture, security, data-integrity, concurrency, and Non-functional requirements checked; symbols resolve.
- [ ] Coverage gates and affected callers checked; no unresolved critical path or dependency breakage.
- [ ] Deviations/spec amendments accounted for and Open Risks settled.
- [ ] Artifact scan passes; efficiency/readability findings are classified by consequence.
- [ ] PR slices have complete step/TC ownership and can pass independently without later slices.

If a correctness check fails, report `REWORK REQUIRED` with the gap; the checklist does not suppress a failing verdict. A passing verdict cannot advance status until all checks pass.

## Actions and PR finalization

- `REWORK REQUIRED`: keep the plan `implemented` for implementation defects; semantic spec amendments return it to `planning` under `approval.md`. The main agent may fix within existing delivery authorization and route independent re-review. Otherwise report findings and the decision needed.
- `PASS WITH NOTES`: during authorized delivery, apply justified in-scope fixes or record why a non-blocking item is skipped. Ask about material tradeoffs outside authorization. Review-only requests end with the report. Any implementation edit requires verification and re-review before finalization; otherwise finalize when all notes are dispositioned.
- `PASS`: the main agent compares actual slices with the provisional PR Pattern. Matching slice count, TC ownership, and parents permits removing `(provisional)`. Within-slice step reordering is allowed. Changed slice boundaries, TC ownership, or parents require a corrected pattern and approval. A missing pattern is REWORK.

For a chain, the main agent checks out each slice tip in `<worktree>`, runs lint, build, and that slice's tests there, and records `Slice N (<branch>): green at <sha>`. Existing evidence can be reused only for that exact tip with unchanged verification inputs. A green final HEAD does not prove earlier tips. Return to the original branch. The delegated reviewer never checks out branches. A single slice uses the HEAD evidence already gathered.

After successful finalization, set the untracked worktree plan to `reviewed` and emit: `Review passed; every AC independently verified. Run the dev-create-pr skill.`
