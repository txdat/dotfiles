# Design Altitude — Single Source

Referenced by design-feature (drafting standard) and review-feature (advisory finding). Applies to `docs/plans/**` and `docs/architecture/**`.

**A plan carries design, not implementation. Everything in it is language-neutral design notation.**

- **Contract declarations are design — state them exactly, as notation.** A signature, an endpoint shape, a schema change, an event payload: `apply(tx) → receipt | reject(reason)`, not `def apply(tx: Transaction) -> Receipt:`.
- **Implementation bodies never appear.** No function bodies, no procedural code, nothing the executor would paste instead of write.
- **Pseudo-code only when the structure is itself the decision** — an algorithm, a state machine, a protocol.
- **Quoting existing source as evidence is citation, not implementation.** Cite it with `file:line`.

Target-language text anchors the executor to one implementation and substitutes premature detail for behavior, hiding the gaps the AC/TC graph exists to expose.

**Verdict:** in design-feature this is the drafting standard — write notation, and rewrite target-language syntax before handoff. In review-feature it is a **Should Fix** finding, reported with the rewrite, never a `NEEDS CHANGES` on its own. It does not clear `Review:` and it does not gate the approval pause: a plan whose ACs and TCs are sound is not made unsound by a stray type annotation. Altitude blocks nothing; the AC/TC graph and the counterexamples do.
