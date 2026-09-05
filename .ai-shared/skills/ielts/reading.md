# /ielts-reading — Reading Reasoning and Practice

Read [README.md](README.md) for provenance, conversions, voice, and archive rules.

## Modes and input

- **Error analysis:** passage, questions/instructions, learner answers, and key if available.
- **Guided practice:** passage and unanswered questions; use hints before revealing answers.
- **Focused drill:** work on a named question type. Use a supplied task or generate a short original passage and questions.

Use Academic passages and conversions. Ask for missing passage/question text rather than inventing it from a book title. If a key is missing, derive provisional answers from the supplied passage and label them `model_inference`. If a key conflicts with the evidence, preserve both and flag the exact discrepancy.

## Analyze answers

1. Identify question types and their instructions, including word limits and whether multiple answers are required.
2. Mark against the available key or clearly labeled provisional answers. Check spelling, answer form, and accepted variants where relevant. Report unresolved items separately.
3. For each incorrect or uncertain answer, show the learner answer, expected/proposed answer and source, passage location, minimal evidence excerpt, and reasoning.
4. Explain why the distractor fails. A diagnosis of the learner's thought process is a hypothesis unless they supplied their reasoning.
5. Extract useful paraphrases **in context**. Similar words need not be interchangeable elsewhere. End with one correction to the learner's method.

Suggested breakdown:

```text
Q: question and type
Learner answer:
Expected/proposed answer: [source and key location, if available]
Evidence: paragraph/sentence + short excerpt
Reasoning: how the evidence settles the whole statement
Distractor: what fails or remains unstated
Next check: the specific habit to practice
```

## True / False / Not Given

Evaluate the complete proposition: subject, time, quantity, comparison, and conditions.

- **TRUE:** the passage supports the full statement, including clear paraphrase and necessary implications.
- **FALSE:** passage evidence makes the statement incompatible with what is stated.
- **NOT GIVEN:** the passage settles neither the statement nor its opposite.

Necessary implications are allowed; outside knowledge, plausible guesses, and unstated causal assumptions are not. Matching a topic or keyword alone proves nothing. For Yes/No/Not Given, apply the same distinction to the writer's views or claims. Use the labels requested by the question.

Original teaching example:

> Passage: “Every delivery arrived before noon.”

“Some deliveries arrived after noon” is **FALSE**: the time claim contradicts “every.” “The deliveries travelled by van” is **NOT GIVEN**: transport is unspecified.

Basis: [Academic Reading question formats](https://ielts.org/take-a-test/test-types/ielts-academic-test/ielts-academic-format-reading). The example is original practice material; its analysis is `model_inference`.

## Question-type strategy

These are coaching methods, not answer-order guarantees. Start with the printed instructions.

| Type | Core method | Common trap to check |
|---|---|---|
| True/False/Not Given; Yes/No/Not Given | Compare the whole claim with the passage or writer's view | Treating unstated detail as contradiction; missing quantifiers |
| Matching headings | Name each paragraph's main purpose before comparing headings | Choosing a vivid detail or repeated word |
| Matching information | Locate the requested example, reason, comparison, or fact | Confusing a paragraph's theme with the specified detail |
| Matching features/people | Track who is linked to each claim; check option reuse | Assigning a nearby person's view to the wrong speaker |
| Matching sentence endings | Test grammatical fit and complete meaning against evidence | Selecting a plausible ending unsupported by the passage |
| Multiple choice | Predict the evidence-supported answer, then eliminate alternatives | Choosing an option only partly supported |
| Sentence/summary/note/table/flow-chart completion | Predict answer form; locate the paraphrase; check word limit | Correct topic but wrong grammar, scope, or answer form |
| Diagram labels; short answers | Locate the named part or requested fact; follow answer limits | Nearby label, wrong unit, or extra words |

## Matching headings

1. Read the whole paragraph. Note what each sentence does: introduces, explains, exemplifies, contrasts, or concludes.
2. Draft a short gist: subject + main claim/purpose. First and last sentences are clues; check the middle for the actual focus.
3. Track pivots such as “however.” Decide whether the paragraph develops the opening claim or shifts to a different main point.
4. Compare the gist with candidate headings. Reject headings that are too broad, too narrow, contradicted, or only keyword matches.
5. Between close options, name the difference and cite the sentence(s) that settle it. Eliminate used options only when instructions disallow reuse; revisit unresolved choices after other matches.

Show the gist and why the closest alternative fails. Never reduce paragraph meaning to first + last sentences alone.

## Guided practice and drills

Ask for an attempt, then reveal hints progressively: relevant idea → paragraph location → decisive phrase → full explanation after the answer or an explicit request to reveal it. Honor a direct request for the solution.

Without supplied material, generate a short original drill. Label it AI-created, not a Cambridge/official item. Check privately that each question has one defensible answer from the passage, then withhold the key until the learner attempts it. Do not require buying or opening a book to practice.

## Report and archive

For error analysis, complete this minimum report in order:

1. Question range, instructions, marking source, checked/provisional count, and unresolved items. No passage-to-band conversion.
2. Each incorrect/uncertain answer: evidence, reasoning, distractor, error tag and diagnosis status. Do not invent a mental cause.
3. Contextual paraphrase pairs with passage locations, or “none identified”; one priority exercise.
4. If saving is authorized, include every frontmatter field below and preserve answers/evidence. Otherwise finish in the conversation.

For guided practice or a focused drill: (1) give the task and instructions, (2) obtain an attempt before hints/answers unless requested otherwise, (3) after the attempt, explain evidence, relevant tags and paraphrases, then one next check. Omit unneeded score/archive sections.

Reading has a 60-minute limit; time allocation within it is a practice strategy. Adjust pacing to the learner's observed bottleneck. Do not quote a universal guessing percentage; the chance depends on answer format and remaining options.

Save only on request, using README's collision rules:

`reading/YYYY-MM-DD_<book-slug>_test<N>_passage<P>.md`

Frontmatter fields: `type: reading-batch`, date, module, source_book, test_id, passage, total_questions, correct_count, score_source, key_source, unresolved_questions, errors, synonyms_extracted, open_verifications. Use `null` for a final correct_count when unresolved marking prevents an exact total; retain the checked subtotal in the report. Generated drills identify their source as AI-created.

The body preserves learner answers, task/evidence references, and the report. Verify the new file before announcing its path.
