# /review-code — Review Implemented Plan Work

If `~/.dotfiles/.ai-shared/PROCESS.md` is not yet loaded, read it first.

Behavior is locked to the approved Goal and AC set. **You are the first reviewer of every TC body.** `design-feature` wrote each TC as a one-line intent; `execute-feature` authored its Given/When/Then at RED, which settles only that the test fails first and is constructible. Under-constraint, a misrouted `Proves:`, an assertion mirroring the implementation, and an AC clause no assertion reaches all arrive here unreviewed — and they arrive with the code, which is why this is the right place for them. A plan defect that makes work incorrect, insecure, lossy, or unverifiable is blocking and returns through `approval.md`.

The main agent names an exact `docs/plans/<file>.md` per PROCESS `Named plan and entry gates`; a delegated reviewer uses the worktree plan path in its packet and resolves nothing. Entry status is `implemented`; `gate-check` owns plan, issue, worktree, and proof-order gates. Read plan/config and inspect `<base>..HEAD` diff, stat, and log inside `<worktree>`; changed-file reads and test runs resolve there too — a bare repo-relative path lands on `$MAIN_ROOT`'s pre-change copy and silently reviews the wrong tree. The worktree plan is authoritative for status and the AC/TC spec; `$MAIN_ROOT`'s copy is only the locator and never advances past its pre-execution status (worktree.md `Plan resolution vs. truth`).

## Independence and Cost Boundary

Follow `independence.md` (single source). Verdict actions — Should Fix resolution, PR Pattern finalization, `reviewed` status, and the review commit — belong to the main agent, on the reviewer's evidence.

Cost boundary: load only the approved plan, project config, diff, changed files/tests, and definitions or callers needed to verify behavior or a suspected finding. Inventory once; do not reread the repository once per review category. Batch independent read-only commands when practical.

## Explicit invocation

Code review is uncounted and unlimited; `independence.md` `Re-review` owns the rule (single source). Applied here: once fixes for a verdict are committed, stop and emit `Fixes applied and committed. Run the dev-review-code skill when you want them re-reviewed.` The plan stays `implemented` and the diff stays unverified until the user invokes the next cycle.

## Review

Read `tdd.md` first — it is the standard the proof commits are judged against. Start with diff name/status, stat, log, and the plan's Goal/AC/TC set. Create one row per TC (`TC | AC | test | implementation evidence | result`) and fill it during one integrated changed-file pass. Roll TC evidence up to an `AC-N: PASS|FAIL — evidence` conclusion; never infer an AC pass only from green tests. Evaluate behavior, architecture/data, and scope together instead of rereading the diff by category. Cite findings as `file:line — issue — impact — required fix`.

### A. Goal and acceptance evidence

- read the original Goal before using tests as an oracle; independently describe the delivered observable outcome;
- verify each AC one by one against its Source, Success, and Failure fields; report `AC-N: PASS|FAIL — <evidence>`;
- attempt at least one counterexample **per AC** where all its TCs pass but the AC or Goal fails; write the cheating implementation concretely against the actual code. This catches a TC weaker than the AC it claims to prove — a test that goes RED then GREEN while the clause it exists to force is never implemented;
- **walk every AC clause** (`design-feature` defines the term). For each clause of an AC's Success and Failure, name the assertion that reaches it. A clause with no assertion is blocking — it is promised behavior nothing verifies, invisible to a green suite;
- verify which production entry point each test invokes: the behavior it proves must execute as a consequence of that entry point, not be asserted by joining below it;
- then verify every TC's `Test: path::name` names a real test in the diff, its `Proves: AC-N` names the AC the test actually constrains, and the test body matches the TC's intent line — not an adjacent scenario; extra behavioral tests require `## Discovered Scope`;
- confirm `## Open Risks` is empty. Each entry was a gap design review deferred to execution; a surviving entry is deferred work nothing resolved, and is blocking until a TC covers it or the review shows existing TCs already do;
- each test would fail when its named behavior breaks — apply `coverage.md` `Quality bar`; any smell it lists is blocking here;
- independently rerun TC tests plus `## Affected Existing Tests`;
- verify new calls/fields/imports resolve to their target type/module;
- inspect every proof commit with `dev-check proof <commit> [--test <in-source-test-path>] [--stub <throwing-stub-path>]`, then confirm its failure/baseline evidence against `tdd.md` step 2 — each test observed failing individually on a stub-free baseline, or a recorded GREEN-minus-one where the stub was load-bearing — and its meaningful assertion. `gate-check` already verifies proof ordering.

Passing all TCs is insufficient when any AC or the Goal fails. Implementation failure against a sound AC/TC is rework; a wrong or ambiguous AC or TC is a plan defect and goes back through `approval.md`.

### B. Architecture and data

Check every plan Non-functional commitment. For changed paths, check applicable concerns: boundaries, query safety, transactions/concurrency, compatibility, security/data exposure, observability, and performance. Treat the rest as not applicable without reporting them; do not expand into a repository-wide audit.

### C. Scope and hygiene

Require every out-of-plan change to appear in `## Deviations` with all four fields present and substantive — **Plan said / Doing instead / Why (what forced it) / Tradeoff (gained vs lost, risk introduced)**. A missing or empty field is a finding, not a formatting nit. Check secrets and TODOs, then run `dev-check artifacts <base> HEAD`.

Classify non-blocking observations as **Should fix** (material minor risk/debt) or **Skip** (negligible, intentional, or out of scope) with reasons.

Verdict: any blocking finding → `REWORK REQUIRED`; none plus Should Fix → `PASS WITH NOTES`; otherwise `PASS`.

## Self-Check (BLOCKING)

- [ ] **Independence:** `independence.md` satisfied — fresh agent, or a session that did not implement; any in-session fallback re-derived every verdict from plan, diff, and test runs; every file read, test, and Git command ran inside `<worktree>`. Context: __.
- [ ] **Invocation:** this cycle began with an explicit user invocation of review-code, not as a continuation of a previous verdict's fixes. Trigger: __.
- [ ] **Goal/behavior:** every AC has independent PASS evidence against the Goal; a counterexample was attempted **per AC** and named with what defeated it in the actual code, not asserted as clean; **every clause of every AC's Success and Failure has a named assertion reaching it**; every TC's `Test:` names a real test whose body matches its intent and whose `Proves:` names the AC it constrains; edge/failure paths and meaningful assertions verified. Gaps: __.
- [ ] **Proof and symbols:** proof contents independently checked; app symbols resolve. Issues: __.
- [ ] **Architecture/data:** every Non-functional commitment and each concern applicable to changed paths were checked; no repository-wide audit was substituted. Issues: __.
- [ ] **Scope/hygiene:** deviations complete; `## Open Risks` empty, each entry resolved by a TC or shown already covered; no unplanned change, secret, TODO, or debug/conflict artifact. Issues: __.
- [ ] **PR Pattern:** actual diff remains independently mergeable under the provisional slices; every step is owned and no TC spans slices; no chain slice depends on a later slice's code to pass its own tests. Suspected dependencies to prove at finalization: __.

## Output and Actions

Report verdict and Goal outcome first, then AC conclusions, the TC evidence table, counterexample, test commands/results, Blocking, Should Fix, relevant Skip decisions, and Plan Defects. Omit empty sections, repeated evidence, and generic praise.

- `REWORK REQUIRED`: offer fixes and wait for approval before editing. Once the approved fixes are committed, stop per `Explicit invocation` — the next review is the user's call.
- `PASS WITH NOTES`: ask which Should Fix items to apply/skip; wait. **Every note skipped** → nothing changed since the verdict, so finalize as `PASS` below. **Any note applied** → the diff is no longer the one reviewed: commit the edits, leave the plan `implemented`, and stop per `Explicit invocation`.
- `PASS`: compare the actual diff with the provisional PR Pattern and finalize it. **Match** = same slice count, each slice owns the same TC set, and each branch has the same parent. Step reordering *within* a slice is not drift; a step moving *between* slices is, as are merged, split, added, or dropped slices — including a slice absorbed because it turned out trivial. Match → remove `(provisional)`; drift → propose a corrected pattern and wait for approval; missing → REWORK.

  **A chain finalizes only on proven atomicity.** Finalization is the main agent's action, and so is this: checking out each slice is a Git mutation the delegated reviewer may not perform (`independence.md`). For each slice in turn, check out its tip in `<worktree>` and run lint, build, and that slice's tests **there** — `HEAD` being green says nothing about the tips beneath it. Record one `Slice N (<branch>): green at <sha>` row under the pattern, then return the worktree to the branch it started on. A red tip is blocking: it would ship a PR that cannot merge or revert alone (`design-feature` `PR Pattern`). Execution already proved this slice by slice, but BLUE, rework, and back-fills all land afterwards, which is why it is re-proved here. A single-slice pattern needs nothing extra — its tip is the `HEAD` the reviewer already ran.

After PASS finalization, set the worktree plan to `reviewed`, commit `docs(<scope>): review passed`, and emit: `Review passed; every AC independently verified. Run the dev-create-pr skill.`
