# Model Capability — Single Source

A recommendation, not a gate: nothing enforces it and the human may override it. But the phases do not ask the same thing of a model, and the flow's value sits almost entirely in the ones that cannot be mechanized.

| Class | Phases | What it demands |
|---|---|---|
| **Adversarial** | `review-feature`, `review-code`, `review-system` | Construct a cheating implementation that passes every TC while the AC fails; attack its own assumptions; judge whether a recorded defeater really constrains the cheat. |
| **Mechanical** | `create-pr`, `create-issue`, `explore`, `fix-bug diagnose` | Follow explicit procedures, run tools, verify shape and evidence against stated rules. |
| **Mixed** | `frame-goal`, `design-feature`, `design-system`, `execute-feature` | Mechanical schema and procedure; judgment where it bites — the unity test and ambiguity probing (scope), adversarial `## Counterexamples Attempted` (design), TC-body authorship at RED (execute), where a weak test is a hidden spec hole. |

A model that cannot do the adversarial work does not fail loudly — it produces counterexample-*shaped* text, a `## Review History` entry asserting an attack was defeated, and a `READY` verdict. That is worse than a blank section, which review-feature already catches (`a bare "none found" is unfalsifiable`).

**The quality floor is the reviewer's capability, not the author's procedure** — which is why scaffolding the authoring phases does not substitute for it.
