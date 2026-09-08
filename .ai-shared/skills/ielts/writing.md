# /ielts-writing — Writing Assistant, Review and Practice

Read [README.md](README.md) for voice, provenance, calculations, tags, and archiving. Read [rubric.md](rubric.md) before scoring or giving target-band guidance.

## Select the mode

| Input | Action |
|---|---|
| A specific sentence/question, including “did my draft address all parts?” | Answer the requested question; for draft coverage, compare prompt obligations with located draft evidence and identify gaps, without forcing a full score, rewrite, or archive |
| Request for `assistant`, question breakdown, or help planning before writing | Use writing assistant mode for prospective planning; with a draft attached, use it when the learner explicitly asks to plan or replan |
| Prompt and response | Review the original, explain errors, demonstrate revisions |
| Prompt only | Use writing assistant mode; no score or automatic archive |
| Request for a practice task | Supply a complete task, then wait for the response |

Route by the requested action, not the word “assistant” alone. A request to check existing coverage is focused draft feedback; a request to score or review the essay uses Review. If the learner asks for both review and replanning, give the requested draft feedback first, then the plan, with observations and suggestions clearly distinguished.

Use IELTS Academic. Establish Task 1 or Task 2 only when unclear. Task 1 needs the actual visual or complete data. Missing task material prevents TA/TR assessment, not useful language feedback.

## Writing assistant — before drafting

Invocation example: `/ielts-writing assistant — target band 7.0 — [complete question]`. Natural-language requests work too.

Use the supplied prompt and target band, reusing relevant conversation context. If the prompt is missing, ask for the complete question; a topic alone does not establish its requirements. If the target is missing, ask for it while continuing the breakdown, coverage, outline, and traps; keep band-specific advice pending instead of assuming a target or current level. Apply a supplied target to this task's planning; if it explicitly refers to an exam overall or combined Writing score, explain the distinction and clarify the task target.

Validate a numeric target against the IELTS 0–9 scale in whole or half bands. For out-of-range values (such as 9.5) or unsupported increments (such as 7.3), explain the issue and ask for the intended target while continuing prompt analysis; do not silently round or clamp. An 8.5 target is valid and uses the band 8 and 9 descriptors. Targets requiring descriptors outside the local 5–8 anchors need the official table or a verified copy; if unavailable, keep band-specific guidance pending and give qualitative planning advice.

Throughout the brief, band expectations and outline ideas are prospective coaching. Claims about an existing draft's coverage, development, organization, or language require located evidence; without a draft, make no claims about the learner's current performance.

Produce the following planning brief, matching detail to the learner's request:

1. **Break down the question.** Identify task, topic, instruction words, every question to answer, and scope qualifiers (people, place, time, comparisons, or words such as “all” and “more”). Quote the prompt phrases that create each obligation and explain them in plain English. Separate background statements from instructions; use essay-type labels only as shorthand after reading the actual wording.
2. **Must cover / should develop.** Use a table: `Prompt phrase | Must cover | Should develop`. “Must” means the question or task instructions require it; “should” means a suggested way to develop a relevant answer. State the position requirement. Include the task's minimum length and connected-prose format, citing IELTS's [IELTS Academic: Writing test format](https://ielts.org/take-a-test/test-types/ielts-academic-test/ielts-academic-format-writing); if the link fails, locate that document by title on IELTS.org and cite the verified replacement. If it remains unavailable, cite the local guidance actually used and disclose that the official format source was not verified. Planning notes may use bullets. Specific arguments, examples, paragraph counts, and PEEL are choices, not exam rules.
3. **Target-band expectations.** When the target is known, use a table: `Criterion | Target descriptor in plain English | How to demonstrate it in this task | What would limit it`. Include TR (TA for Task 1), CC, LR, and GRA, expanding their names. Follow rubric.md's source and fallback rules; state `rubric_basis` and cite the relevant table/page. Distinguish official descriptor summaries from task-specific coaching (`model_inference`). For half-band targets, compare the neighboring whole-band descriptors and label the bridge as coaching; do not invent an official 6.5 or 7.5 descriptor. Explain that criteria are assessed separately and the brief is a preparation guide, not a guaranteed score or a requirement to receive identical scores in every criterion.
4. **Suggested outline.** Map every required response to a paragraph purpose. For Task 2, propose a clearly labeled possible position, main claims, reasoning, and relevant illustrative support; respect any position the learner already supplied. Explain how the reasoning answers the question. For Task 1, plan an overview and logically grouped details from the actual material. Keep the plan in notes; let the learner write the essay.
5. **Errors to avoid.** Prioritize traps specific to this question and target. For each, give `Risk | Criterion and effect | Prevention/self-check`. Cover missing parts, scope drift, unclear or inconsistent conclusions, and insufficient support where relevant; include useful language risks such as imprecise word choice or faulty sentence boundaries. Without a draft, these are prospective risks, not observed learner errors. With a supplied draft, call an error observed only with located evidence. Avoid fixed band deductions, invented error quotas, and claims that all errors must disappear at the target band. End with a short checklist the learner can use before and after drafting.

### Interpret the actual Task 2 instructions

| Wording | Coverage to plan |
|---|---|
| To what extent do you agree or disagree? | A clear degree of agreement, justified throughout; a qualified position is valid. A separate opposing-view paragraph is optional. |
| Discuss both views and give your opinion | Explain both stated views and give a supported personal position. Equal word counts are not required. |
| Advantages and disadvantages | Develop both. If asked whether one outweighs the other, make and justify that comparison; two lists alone do not answer “outweigh.” |
| Causes / problems / effects / solutions | Answer the exact requested categories; causes are not effects, and solutions must address the identified problem. |
| Two or more direct questions | Address each question, including any requested judgment; do not replace the questions with a familiar essay template. |
| Positive or negative development | Give and support an overall evaluation; a mixed judgment can work when its balance is clear. |

Use precise, appropriate vocabulary and a controlled range of structures. “Advanced words,” memorized introductions, a linker in every sentence, fixed example counts, and complex grammar in every sentence are not band requirements. Use relevant illustrative examples without presenting invented statistics, research, or personal experiences as facts.

### Academic Task 1 adaptation

Identify units, time frame, main features, comparisons or stages, and the overview. Use TA instead of TR; do not impose a personal opinion or argumentative thesis. Distinguish data description, processes, and maps when choosing the organization. If a visual is missing or unreadable, ask for the actual visual or complete data and give only the planning guidance the available material supports; do not invent trends, values, or an overview.

Assistant mode gives no performance score and does not automatically archive or supply a full model response. A full sample requires an explicit request and must be labeled illustrative; generated practice tasks follow the attempt-first rule below. A focused question still needs only a focused answer, not this entire brief.

## Practice task generation

Label generated tasks original practice material. Provide the complete Task 2 question, or all data/a legible visual for Task 1. A chart title alone is not a usable prompt. Include task instructions and invite the learner to attempt it. Wait for the learner's attempt before revealing a sample response.

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
