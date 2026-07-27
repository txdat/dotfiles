# /review-code — Review Implemented Plan Work

Behavior is locked to the approved Goal/AC/TC spec. Review fidelity plus independent semantic correctness, security, and quality; do not reopen preferences owned by review-feature. A plan defect that makes work incorrect, insecure, lossy, or unverifiable is blocking and returns the plan through `approval.md`. Cosmetic design observations are out-of-band notes.

The main agent resolves the active plan per CORE; a delegated reviewer uses the worktree plan path in its packet and resolves nothing. Entry status is `implemented`, and `gate-check` owns plan, issue, worktree, and proof-order gates. Read plan/config and inspect `<base>..HEAD` diff, stat, and log inside `<worktree>`; changed-file reads and test runs resolve there too — a bare repo-relative path lands on `$MAIN_ROOT`'s pre-change copy and silently reviews the wrong tree. The worktree plan is authoritative for status and the AC/TC spec; `$MAIN_ROOT`'s copy is only the locator and never advances past its pre-execution status (worktree.md `Plan resolution vs. truth`).

## Independence and Cost Boundary

Follow `independence.md` (single source): reviewer `code-quality-auditor`, artifact the worktree plan plus the `<base>..HEAD` diff, verdict below. Verdict actions — Should Fix resolution, PR Pattern finalization, `reviewed` status, and the review commit — belong to the main agent, on the reviewer's evidence.

Cost boundary: load only the approved plan, project config, diff, changed files/tests, and definitions or callers needed to verify behavior or a suspected finding. Inventory once; do not reread the repository once per review category. Batch independent read-only commands when practical.

## Review

Start with diff name/status, stat, log, and the plan's Goal/AC/TC set. Create one row per TC (`TC | AC | test | implementation evidence | result`) and fill it during one integrated changed-file pass. Roll TC evidence up to an `AC-N: PASS|FAIL — evidence` conclusion; never infer an AC pass only from green tests. Evaluate behavior, architecture/data, and scope together instead of rereading the diff by category. Cite findings as `file:line — issue — impact — required fix`.

### A. Goal and acceptance evidence

- read the original Goal before using tests as an oracle; independently describe the delivered observable outcome;
- verify each AC one by one against its Source, Success, and Failure fields; report `AC-N: PASS|FAIL — <evidence>`;
- attempt at least one counterexample where all planned TCs pass but the AC or Goal fails; a known counterexample is blocking;
- then verify every TC has an identifiable test (TC ID or explicit plan mapping), the correct `Proves: AC-N`, and matching Given/When/Then behavior; extra behavioral tests require `## Discovered Scope`;
- each test would fail when its named behavior breaks — apply `coverage.md` `Quality bar`; any smell it lists is blocking here;
- independently rerun TC tests plus `## Affected Existing Tests`;
- verify new calls/fields/imports resolve to their target type/module;
- inspect every proof commit with `dev-check proof <commit> [--test <in-source-test-path>] [--stub <throwing-stub-path>]`, then confirm its failure/baseline evidence and meaningful assertion. `gate-check` already verifies proof ordering.

Passing all TCs is insufficient when any AC or the Goal fails. Implementation failure against a sound AC/TC is rework; a wrong or ambiguous AC or TC is a plan defect and goes back through `approval.md`.

### B. Architecture and data

Check every plan Non-functional commitment. For changed paths, check applicable concerns: boundaries, query safety, transactions/concurrency, compatibility, security/data exposure, observability, and performance. Treat the rest as not applicable without reporting them; do not expand into a repository-wide audit.

### C. Scope and hygiene

Require every out-of-plan change to appear in `## Deviations` with all four fields present and substantive — **Plan said / Doing instead / Why (what forced it) / Tradeoff (gained vs lost, risk introduced)**. A missing or empty field is a finding, not a formatting nit. Check secrets and TODOs, then run `dev-check artifacts <base> HEAD`.

Classify non-blocking observations as **Should fix** (material minor risk/debt) or **Skip** (negligible, intentional, or out of scope) with reasons.

Verdict: any blocking finding → `REWORK REQUIRED`; none plus Should Fix → `PASS WITH NOTES`; otherwise `PASS`.

## Self-Check (BLOCKING)

- [ ] **Independence:** `independence.md` satisfied — fresh agent, or a session that did not implement; any in-session fallback re-derived every verdict from plan, diff, and test runs; every file read, test, and Git command ran inside `<worktree>`. Context: __.
- [ ] **Goal/behavior:** every AC has independent PASS evidence against the Goal; each adversarial counterexample attempted is named with what defeated it in the actual code, not asserted as clean; every TC maps to its AC and test; edge/failure paths and meaningful assertions verified. Gaps: __.
- [ ] **Proof and symbols:** proof contents independently checked; app symbols resolve. Issues: __.
- [ ] **Architecture/data:** every Non-functional commitment and each concern applicable to changed paths were checked; no repository-wide audit was substituted. Issues: __.
- [ ] **Scope/hygiene:** deviations complete; no unplanned change, secret, TODO, or debug/conflict artifact. Issues: __.
- [ ] **PR Pattern:** actual diff remains independently mergeable under the provisional slices; every step is owned and no TC spans slices. Issues: __.

## Output and Actions

Report verdict and Goal outcome first, then AC conclusions, the TC evidence table, counterexample, test commands/results, Blocking, Should Fix, relevant Skip decisions, and Plan Defects. Omit empty sections, repeated evidence, and generic praise.

- `REWORK REQUIRED`: offer fixes; wait for approval before editing.
- `PASS WITH NOTES`: ask which Should Fix items to apply/skip; wait. Continue only after all are resolved.
- `PASS`: compare the actual diff with the provisional PR Pattern and finalize it. Match → remove `(provisional)`; drift → propose a corrected pattern and wait for approval; missing → REWORK.

After PASS finalization, set the worktree plan to `reviewed`, commit `docs(<scope>): review passed`, and print: `Review passed; every AC independently verified. Run the create-pr skill.`
