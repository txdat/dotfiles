# /ielts-mock — Record Scores Without Inventing Them

Read [README.md](README.md) for provenance, calculations, and safe archiving. Record the supplied result; do not diagnose proficiency or force missing estimates.

## Collect only missing fields

Identify whether this is a real exam, a practice test, or a partial result. Reuse details already supplied.

- Date, defaulting to today only when the learner gives no date.
- Source/exam name and test identifier if applicable. Module is `academic`; do not ask the learner to choose it.
- Available L, R, W, S band scores, each with its source.
- Optional raw counts, reported overall, reviewer identity, testing conditions, and notes.

Accept recorded component bands across 0–9 in half-band steps and full-test raw counts as integers from 0–40. Zero band means a reported non-attempt, not an unknown score. Missing components are `null`. Ask about invalid entries without silently clipping them.

An inspected official report is `source_of_truth`. “These are my official scores” without the report is a learner-confirmed record (`confirmed_decision`), with `evidence: learner-reported`. A human reviewer's judgment is also `confirmed_decision`, not an official result.

For practice W/S, distinguish AI assessment, human review, and self-estimate. AI and self-estimates are `model_inference`. Record their actual basis: a single essay or text-only speaking review is not automatically a complete component score. Do not fill W/S from such partial evidence.

## Calculate and verify

Use the shared Decimal helper in README; keep the mean unrounded until the final conversion.

```python
from decimal import Decimal

def overall_band(components):
    if any(value is None for value in components):
        return None
    mean = sum(Decimal(str(value)) for value in components) / Decimal("4")
    return half_band(mean)
```

Call with exactly four validated components. Checks:
- L7.5 R7.5 W6.0 S6.0 → 7.0.
- L8.0 R8.0 W6.5 S6.5 → 7.5.
- L4.0 R4.5 W5.0 S5.5 → 5.0.
- Any missing component → calculated overall `null`.

A reported overall remains a separate field. If it disagrees with the calculated value, retain both and flag the discrepancy; do not overwrite either.

The calculated overall inherits the least certain input basis: any inferred component → `model_inference`; otherwise any learner/reviewer-confirmed component → `confirmed_decision`; all inspected official components → `source_of_truth`. Record `overall_basis: calculated` so it cannot be mistaken for a reported result. An unresolved input conflict makes the calculated conclusion `open_verification`.

Compare raw counts only with a verified test-specific conversion. Generic anchors cannot invalidate a supplied official band. If the conversion table is missing, retain the raw count and reported band, and note what remains unverified.

## Save a full or partial record

Filename: `mock/YYYY-MM-DD_<source-slug>_<test-slug>.md`. Use `real-exam` or `unknown` where appropriate. Apply README's collision policy to new attempts.

Example:

```yaml
---
type: mock-exam
entry_type: real-exam
date: 2026-06-15
module: academic
source_book: Real exam
test_id: null
scores:
  L: 4.0
  R: 4.5
  W: 5.0
  S: 5.5
  overall: 5.0
reported_overall: null
overall_basis: calculated
sources:
  L: confirmed_decision
  R: confirmed_decision
  W: confirmed_decision
  S: confirmed_decision
  overall: confirmed_decision
evidence: learner-reported
raw_correct:
  L: null
  R: null
weak_topics: []
notes: null
open_verifications: []
---
```

For partial records, unknown components, their sources, and calculated overall stay `null`. Preserve any independently supplied reported overall in its own field. Never invent weak topics from a low score.

Minimum recording sequence:

1. Validate available components and identify each source; preserve missing values as `null`.
2. Show the component/source table, reported overall, and independently calculated overall or the reason it remains `null`.
3. Preserve supplied notes and pending verification; never infer error tags, paraphrases, or weak topics from scores alone.
4. Under the explicit invocation or save request, complete every frontmatter field above and include the table/notes in the body. Honor “do not save.” Verify the file, then report its path and calculated overall, or “partial record; overall not calculated.”

Full error analysis belongs to the relevant coaching skill. Recording can finish with uncertainty preserved; it does not require the learner to obtain a report, key, or paid assessment first.
