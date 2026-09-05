# /ielts-speaking — Speaking Preparation and Transcript Review

Read [README.md](README.md), then [rubric.md](rubric.md) before assessment.

## Select the mode

| Request | Action |
|---|---|
| Group a topic list | Cluster by genuine overlap and map adaptable experiences |
| Prepare a topic | Provide cue-card notes, an illustrative response, and follow-up practice |
| Improve an answer | Correct language while preserving a spoken register |
| Assess a transcript | Review available evidence within the transcript limits below |

Follow the requested intent. If an answer arrives without a clear request, give focused language feedback; do not silently convert it into a scored performance.

## Preparation principles

Answer the actual question. Reusable experiences are prompts for flexible speaking, not a reason to redirect unrelated questions. No fixed story count guarantees topic coverage.

Prepare all parts. Part 1 benefits from direct answers with relevant detail; Part 3 benefits from explaining, comparing, and qualifying views. Avoid rigid sentence counts and filler quotas. A natural accent does not need replacement; any pronunciation feedback must concern observed intelligibility.

Part 2 allows one minute of preparation and a long turn of up to two minutes. Word count alone cannot establish speaking time. Source: [IELTS Speaking format](https://ielts.org/take-a-test/test-types/ielts-academic-test/ielts-academic-format-speaking).

## Topic grouping

1. Read every supplied topic and note its requested subject and angle. For a broad list, start with about five groups; use fewer for a short list and split groups when their topics need unrelated experiences. Travel, people, objects, events, and media are starting themes, not mandatory categories.
2. Name each group by its common subject/experience. Prefer learner-supplied experiences; label invented stories as fictional practice examples. Keep outliers separate rather than forcing five groups.
3. Map every supplied topic to a group, an experience, and the detail answering its actual question. Check each mapping against that question; mark a forced fit as uncovered rather than claiming success.
4. If reporting coverage, use the actual denominator: `covered / supplied topics × 100`. Tag the mapping `model_inference`; coverage is a planning judgment, not a test prediction.

Output: `Group | Topic | Experience | Relevant detail | Gap`, followed by gaps and any coverage calculation. Verify every supplied topic appears; suggest additional material only for the gaps.

## Topic preparation

Use the supplied cue card, or label a generated one as original practice. Provide in order:

1. A short note outline addressing the topic and its prompts.
2. A natural illustrative response, with specific details and a reason for each main point.
3. Useful expressions in context, explaining when an alternative changes meaning or register.
4. Related Part 3 **practice questions**, with reasoning outlines. Do not present them as predicted exam questions.

Invite a timed spoken attempt. Adjust length to observed delivery; a script has no guaranteed band. Preserve flexibility by asking the learner to vary an example or respond to a follow-up.

## Transcript review

Establish the question/part and whether the transcript is verbatim, edited, or automatically generated. Work with the evidence available while asking about material uncertainty.

| Evidence | Assessment |
|---|---|
| Sufficient verbatim text | Provisional LR/GRA estimates under the Speaking descriptors |
| Very short or edited text | Qualitative language feedback; no performance band |
| Text organization and preserved disfluencies | Coherence observations; full FC score remains N/A |
| No accessible audio | Pronunciation remains N/A |
| Transcript alone | Overall Speaking band remains N/A |

An automatic transcript can hide hesitation and introduce errors. Do not mark punctuation supplied by transcription as the learner's grammar. Audio-specific claims require audio the environment actually inspected.

For each correction, show the original phrase, a natural spoken alternative, and why it helps. Keep acceptable common words. “Big impact” is not intrinsically an error, and a simple sentence does not by itself prove limited grammar.

A revised version demonstrates language choices. It cannot demonstrate better pronunciation or fluency until the learner speaks it. Do not re-score an edited script as a measured performance gain.

## Report and archive

For a full transcript review, complete these items in order:

1. Question/part, transcript kind, available evidence, and `rubric_basis`.
2. Provisional LR/GRA estimates with evidence where justified; coherence observations. State: “Transcript review only; delivery and pronunciation are unassessed.” Keep FC, pronunciation, and overall `null`; tag estimates `model_inference`.
3. Located corrections with tags/status and natural spoken alternatives; useful contextual expressions, or “none needed.”
4. One next exercise and any unresolved evidence questions. A focused answer-improvement request needs corrections and reasons, without forced scoring.
5. When saving is authorized, complete every archive field below and preserve the original, question, and report. Verify the file before announcing its path.

Explicit transcript-review invocation permits archiving under README's rules. Topic materials save only on request.

Filename: `speaking/YYYY-MM-DD_P<1|2|3>_<topic-slug>.md`; use `Punknown` when needed.

```yaml
---
type: speaking-transcript
date: 2026-06-15
module: academic
part: 2
topic: describe-a-trip
transcript_kind: verbatim
audio_assessed: false
word_count: 230
ai_score:
  fc: null
  lr: 6.5
  gra: 6.0
  pronunciation: null
  estimated_band: null
  basis: transcript-only
  rubric_basis: local-summary
  source: model_inference
errors: []
synonyms_extracted: []
open_verifications: []
---
```

Keep LR/GRA `null` too when evidence is insufficient. Save the original transcript, question, report, and evidence references. Confirm the path after writing; never announce an overall band from this record.
