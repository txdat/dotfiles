# /ielts-writing — Writing Review and Practice

Read [README.md](README.md) for voice, provenance, calculations, tags, and archiving. Read [rubric.md](rubric.md) before scoring.

## Select the mode

| Input | Action |
|---|---|
| Prompt and response | Review the original, explain errors, demonstrate revisions |
| Prompt only | Analyze requirements and suggest an outline; no score or archive |
| Request for a practice task | Supply a complete task, then wait for the response |
| A specific sentence or question | Answer that question without forcing the full workflow |

Use IELTS Academic. Establish Task 1 or Task 2 only when unclear. Task 1 needs the actual visual or complete data. Missing task material prevents TA/TR assessment, not useful language feedback.

## Prompt analysis and practice

- **Task 2:** identify every requested response, scope qualifier, and position requirement. Build an outline around those requirements. PEEL is an optional planning aid, not a required paragraph or sentence count. A qualified or balanced position is valid when clearly explained and responsive.
- **Academic Task 1:** identify units, time frame, main features, comparisons or stages, and an overview. Do not invent values from an unreadable visual.
- **Generated tasks:** label them original practice material. Provide the complete Task 2 question, or all data/a legible visual for Task 1. A chart title alone is not a usable prompt. Wait for the learner's attempt before revealing a sample response.

Minimum prompt-only output: (1) task requirements, (2) an outline covering each requirement, (3) one likely trap. For a generated task: (1) complete prompt/data, (2) task instructions, (3) invitation to attempt it. A focused sentence question needs only the answer, correction if needed, and reason; no full-review checklist.

## Review

1. **Check the original.** Record task, prompt coverage, and word count. Task 1 requires at least 150 words; Task 2 requires at least 250. Explain insufficient development without a fixed under-length deduction. Source: [Academic Writing format](https://ielts.org/take-a-test/test-types/ielts-academic-test/ielts-academic-format-writing).
2. **Assess independently of the rewrite.** Apply the relevant descriptors to TA/TR, CC, LR, and GRA. Each estimate needs a quoted example and an explanation of the limiting feature. All estimates are `model_inference`. Leave unsupported scores `null`.
3. **Annotate useful corrections.** Cite paragraph/sentence, original wording, tag, correction, and effect on meaning or accuracy. Group repeated instances of the same error while naming their locations. Distinguish errors from optional alternatives.
4. **Demonstrate revision.** Preserve the learner's intended meaning. Separate language edits from added development or reorganized arguments. If content is missing, explain that vocabulary changes alone cannot repair it. Label new examples as illustrative; do not fabricate personal facts or evidence. Bold changed phrases and explain substantive changes.
5. **Choose the next action.** Prioritize the issue most limiting the response, then give a small revision task. Score a revised version only if useful and supported by the rubric; never promise current band +1 or treat an AI rewrite as learner progress.

Example annotation:

> “Technology have changed how we communicate.”

**GRA · subject-verb-disagreement:** “Technology **has** changed how we communicate.” The singular subject takes “has.” Common words elsewhere in this sentence need no replacement.

## Report

For a full review, complete these items in order:

1. Task, available prompt/data, and word count.
2. Criterion table: estimate or N/A, evidence, limiting feature, and `rubric_basis`. Name TA for Task 1 and TR for Task 2; label estimates `model_inference`. Include unrounded mean and **estimated task band** only when all four criteria are assessable.
3. Located annotations with tags/status; revised response or focused comparison; useful contextual alternatives, or “none needed.” Do not manufacture errors or synonyms to fill a section.
4. One priority exercise and the actual uncertainty. Local-summary scoring remains usable when the PDF is unavailable; missing task evidence still limits assessment.
5. When saving is authorized, complete every archive field below and preserve the original/report. Verify the file before announcing its path.

## Archive

Follow README's authorization and collision rules.

Filename: `writing/YYYY-MM-DD_T<1|2>_<topic-slug>.md`.

Example frontmatter:

```yaml
---
type: writing-batch
date: 2026-06-15
module: academic
task: T2
prompt: "The learner's complete prompt"
topic_tags: [technology]
word_count: 287
ai_score:
  tr: 6.0
  cc: 6.0
  lr: 6.5
  gra: 6.5
  criterion_mean: 6.25
  overall: 6.5
  basis: estimated-task-band
  rubric_basis: local-summary
  source: model_inference
human_score: null
errors:
  - {tag: subject-verb-disagreement, status: observed, count: 1, source: model_inference}
synonyms_extracted: []
open_verifications: []
---
```

Task 1 uses `ta` instead of `tr`. Store the original response and report once; do not duplicate annotations already in the report. Record a human score only when supplied, with its assessor and basis. Verify the new file, then report its path and the estimated **task** band, or “not scored.”
