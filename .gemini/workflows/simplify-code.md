# Workflow: /simplify-code — Simplify Existing Code

Do NOT add features, fix bugs, or change behavior.

**Analyze for:**
- **Dead Code**: unused variables, unreachable branches.
- **Redundant Logic**: duplicated conditions, re-computed values.
- **Premature Abstractions**: interfaces/classes with only one implementation.
- **Over-engineering**: patterns that don't earn their complexity.

**Steps:**
1. State findings: what, where, why, and the simpler form.
2. Present findings before editing.
3. Apply approved changes and run tests.
4. Revert any change that causes a test failure.
