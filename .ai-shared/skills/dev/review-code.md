# /review-code — Review Implemented Plan Work

`PROCESS.md` must be loaded before this skill runs — not in context → read it now.

Behavior is locked to the approved Goal and AC set. **You are the first reviewer of every TC body.** `design-feature` wrote each TC as a one-line intent; `execute-feature` authored its Given/When/Then at RED, which settles only that the test fails first and is constructible. Under-constraint, a misrouted `Proves:`, an assertion mirroring the implementation, and an AC clause no assertion reaches all arrive here unreviewed — and they arrive with the code, which is why this is the right place for them. A plan defect that makes work incorrect, insecure, lossy, or unverifiable is blocking and returns through `approval.md`.

The main agent names an exact `docs/plans/<file>.md` per PROCESS `Named plan and entry gates`; a delegated reviewer uses the worktree plan path in its packet and resolves nothing. Entry status is `implemented`, with `Code Rounds:` 0, 1, or 2; `gate-check` owns plan, issue, worktree, round, and proof-order gates. Read plan/config and inspect `<base>..HEAD` diff, stat, and log inside `<worktree>`; changed-file reads and test runs resolve there too — a bare repo-relative path lands on `$MAIN_ROOT`'s pre-change copy and silently reviews the wrong tree. The worktree plan is authoritative for status and the AC/TC spec; `$MAIN_ROOT`'s copy is only the locator and never advances past its pre-execution status (worktree.md `Plan resolution vs. truth`).

## Independence and Cost Boundary

Follow `independence.md` (single source). Verdict actions — Should Fix resolution, PR Pattern finalization, `reviewed` status, and the review commit — belong to the main agent, on the reviewer's evidence.

Cost boundary: load only the approved plan, project config, diff, changed files/tests, and definitions or callers needed to verify behavior or a suspected finding. Inventory once; do not reread the repository once per review category. Batch independent read-only commands when practical.

## Hard Gate

`Code Rounds:` starts at 0 and counts completed verdicts. **Three review cycles maximum.** `gate-check` admits exactly 0, 1, or 2 and rejects exhausted, missing, malformed, non-canonical, or duplicate values. Increment once after every verdict. Entry at 2 is the third and final cycle: `PASS` may proceed, and `PASS WITH NOTES` may proceed only if every note is skipped; any required edit or `REWORK REQUIRED` ends this plan's lane. Never reset the counter; the user must choose replacement, decomposition into new plans, or abandonment.

## Review

Read `tdd.md` first — it is the standard the proof commits are judged against. Start with diff name/status, stat, log, and the plan's Goal/AC/TC set. Create one row per TC (`TC | AC | test | implementation evidence | result`) and fill it during one integrated changed-file pass. Roll TC evidence up to an `AC-N: PASS|FAIL — evidence` conclusion; never infer an AC pass only from green tests. Evaluate behavior, architecture/data, and scope together instead of rereading the diff by category. Cite findings as `file:line — issue — impact — required fix`.

### A. Goal and acceptance evidence

- read the original Goal before using tests as an oracle; independently describe the delivered observable outcome;
- verify each AC one by one against its Source, Success, and Failure fields; report `AC-N: PASS|FAIL — <evidence>`;
- attempt at least one counterexample **per AC** where all its TCs pass but the AC or Goal fails; write the cheating implementation concretely against the actual code. This catches a TC weaker than the AC it claims to prove — a test that goes RED then GREEN while the clause it exists to force is never implemented;
- **walk every AC clause** (`design-feature` defines the term). For each clause of an AC's Success and Failure, name the assertion that reaches it. A clause with no assertion is blocking — it is promised behavior nothing verifies, invisible to a green suite;
- verify which production entry point each test invokes: the behavior it proves must execute as a consequence of that entry point, not be asserted by joining below it;
- then verify every TC's `Test: path::name` names a real test in the diff, its `Proves: AC-N` names the AC the test actually constrains, and the test body matches the TC's intent line — not an adjacent scenario; extra behavioral tests require `## Discovered Scope`;
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
- [ ] **Rounds:** entry `Code Rounds:` was 0, 1, or 2; this verdict was produced and the counter incremented exactly once before any follow-up action. Value now: __.
- [ ] **Goal/behavior:** every AC has independent PASS evidence against the Goal; a counterexample was attempted **per AC** and named with what defeated it in the actual code, not asserted as clean; **every clause of every AC's Success and Failure has a named assertion reaching it**; every TC's `Test:` names a real test whose body matches its intent and whose `Proves:` names the AC it constrains; edge/failure paths and meaningful assertions verified. Gaps: __.
- [ ] **Proof and symbols:** proof contents independently checked; app symbols resolve. Issues: __.
- [ ] **Architecture/data:** every Non-functional commitment and each concern applicable to changed paths were checked; no repository-wide audit was substituted. Issues: __.
- [ ] **Scope/hygiene:** deviations complete; no unplanned change, secret, TODO, or debug/conflict artifact. Issues: __.
- [ ] **PR Pattern:** actual diff remains independently mergeable under the provisional slices; every step is owned and no TC spans slices. Issues: __.

## Output and Actions

Report verdict and Goal outcome first, then AC conclusions, the TC evidence table, counterexample, test commands/results, Blocking, Should Fix, relevant Skip decisions, and Plan Defects. Omit empty sections, repeated evidence, and generic praise.

Before acting on the verdict, increment `Code Rounds:` exactly once in the authoritative worktree plan. Commit that plan edit before implementation resumes; a passing round includes it in the existing review-passed commit.

- `REWORK REQUIRED`: below 3, offer fixes and wait for approval before editing. At 3, stop for replacement, decomposition, or abandonment; a fourth review is forbidden.
- `PASS WITH NOTES`: ask which Should Fix items to apply/skip; wait. Skipped notes need no new review. Applied edits require another independent round and therefore may proceed only while the incremented counter remains below 3.
- `PASS`: compare the actual diff with the provisional PR Pattern and finalize it. **Match** = same slice count, each slice owns the same TC set, and each branch has the same parent. Step reordering *within* a slice is not drift; a step moving *between* slices is, as are merged, split, added, or dropped slices — including a slice absorbed because it turned out trivial. Match → remove `(provisional)`; drift → propose a corrected pattern and wait for approval; missing → REWORK.

After PASS finalization, set the worktree plan to `reviewed`, commit `docs(<scope>): review passed`, and emit: `Review passed; every AC independently verified. Run the create-pr skill.`
