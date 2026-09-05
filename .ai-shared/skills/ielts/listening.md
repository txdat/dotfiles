# /ielts-listening — Evidence-Based Error Analysis

Read [README.md](README.md) for provenance, tags, raw-score interpretation, and archive rules.

## Modes and evidence

| Mode | Input and result |
|---|---|
| Error analysis | Script, questions/instructions, learner answers, key if available → marking and diagnosis |
| Intensive listening | A learner-accessible recording/segment → staged listening and comparison |
| Focused drill | A specific problem → a small exercise with an explicit evidence basis |

Check available capabilities. If audio cannot be played or inspected in this environment, work from supplied text and the learner's replay observations. Do not claim to hear audio, and do not describe a text-only number exercise as a listening test.

Use supplied book/test/part metadata. A title alone does not supply the official script or key. Missing key → proposed answers from the script are `model_inference`; missing or ambiguous evidence stays unresolved.

## Error analysis

1. **Mark answers.** Follow question-specific word/number limits, required answer count, spelling, and accepted variants. Identify the key or provisional marking basis.
2. **Report the raw result.** A single part gets `correct / total` only. Complete-test conversions follow README. There is no “7/10 in Part 4 means band 7” rule.
3. **Locate evidence.** Quote the decisive script phrase; include question number and timestamp only when supplied or observed.
4. **Separate observation from cause.** Record the answer mismatch first. Propose a primary error tag only when supported; competing causes remain in `open_verifications`.
5. **Choose one diagnostic replay.** Ask the learner to replay the specific segment and say what they heard or why they chose the answer. Use that response to refine the diagnosis.

Use these differentiators as coaching hypotheses; README's diagnosis status makes their certainty explicit.

| Candidate tag | Distinguishing observation | Replay or explanation check |
|---|---|---|
| `synonym-missed` | Learner recognizes the spoken phrase but fails to connect its meaning to the question; copying a question word is only a clue | Ask for the heard phrase and its matching question phrase; can they explain the link? |
| `paraphrase-misread` | Learner's explanation changes the meaning or scope of a question/option | Have them restate the option before comparing it with the script |
| `distraction` | Selected information occurs in the recording but is rejected, corrected, or belongs to another option | Replay the initial claim and correction; ask which remains valid and why |
| `attention-drift` | Learner reports losing their place or missing a stretch | Locate the last understood point and where attention returned; an unrelated answer alone proves nothing |
| `signal-missed` | Missed a transition/correction cue and its effect on the answer | Replay across the cue; ask what changed after it |
| `info-order-confusion` | Located facts were assigned to the wrong questions | Map each fact to its question while replaying the sequence |
| `number-mishear` | Learner reports hearing a different number | Compare their heard form with the specific audio contrast; a wrong digit alone is insufficient |
| `accent-trouble` | Learner recognizes the written word but reports difficulty identifying this spoken realization | Check the same word in context; do not generalize to an accent from one miss |
| `spelling-error` | Written form is misspelled | Check spelling separately from what was heard; both errors can coexist |
| `instruction-misread` | Answer violates a stated limit or required form | Ask learner to restate the instruction and repair the answer format |

If multiple tags fit, retain alternatives and select one discriminating check. For example, a missed correction may involve `distraction` or `signal-missed`; ask whether the learner heard and understood the correction cue. Do not require replay to finish a useful report: retain `possible-cause` when evidence is unavailable.

Minimum error-analysis report:

1. Metadata, marking basis, raw result, and unresolved questions.
2. Per wrong/uncertain item: learner answer → expected/proposed answer and source → excerpt → observed mismatch → tag/status or unresolved causes → replay check.
3. Contextual question/script paraphrase pairs, or “none identified”; one priority practice action.
4. If saving is authorized, complete the archive schema, preserve answers/evidence, and verify the file.

## Intensive listening

Work on a short learner-accessible segment.

1. **Before revealing text:** learner listens and records the gist or attempted answers. Do not reveal the answer-bearing transcript first.
2. **Replay:** learner focuses on the disputed phrase and revises their answer.
3. **Compare:** reveal the script, explain contrasts/paraphrases, and ask for a brief retelling.

If the learner already saw the script, label this supported practice, not an unseen diagnostic attempt. This mode saves only on request.

## Focused drills

For number contrasts such as thirteen/thirty, use accessible audio or ask the learner to replay a supplied recording. Keep the target answer hidden until they respond. Without audio, offer a clearly labeled text exercise on spelling, format, or contrast; it does not test hearing.

Part 4 is an academic monologue. Select dictation, paraphrase matching, or note-taking from the actual error pattern. Avoid fixed difficulty rankings or invented frequency statistics.

For each intensive-listening or drill turn: (1) identify the segment and whether audio is accessible, (2) give the current attempt/replay/comparison step with targets hidden until appropriate, (3) after the response, record the observed error, supported tag/status, useful paraphrase and next action, or state that none was identified. Do not force scoring or saving into practice.

Reference: [IELTS Listening format](https://ielts.org/take-a-test/test-types/ielts-academic-test/ielts-academic-format-listening).

## Archive

An explicit error-analysis invocation authorizes a new record unless the learner declines saving. Apply README's safe filename and collision rules.

Save one record per analyzed part:
`listening/YYYY-MM-DD_<book-slug>_test<N>_section<S>.md`

```yaml
---
type: listening-batch
date: 2026-06-15
module: academic
source_book: Cambridge 18
test_id: Test 3
section: 4
total_questions: 10
correct_count: 7
score_source: confirmed_decision
key_source: learner-reported-marking
band_estimate: null
band_source: null
errors:
  - {q: 32, tag: spelling-error, status: observed, source: model_inference}
unresolved_questions: []
synonyms_extracted: []
open_verifications: []
---
```

This is an example of learner-reported marking, not a verified key. For provisional script-derived marking use `model_inference`. If unresolved answers prevent a final count, use `correct_count: null` and report the checked subtotal separately.

A full test still archives each part separately; part records keep both band fields `null`. Put a complete-test result and its conversion source in a separate `section: full-test` summary using a `_full-test.md` suffix. Never attach the full-test band to a single-part score.

Save learner answers, script/key references, the analysis, and replay questions. Verify the file before reporting its path. Error-pattern claims remain limited to this attempt.
