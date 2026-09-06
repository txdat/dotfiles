# Frontend Design — Visual Design Guidance

Read by `design-feature` and `execute-feature` for UI/frontend work, and by reviewers for applicable requirements. Read AI project configuration for token paths, styling mechanisms, and component primitives. Audit, extensions, and **Process** guide planning; **Craft within constraints** and **Styling discipline** guide implementation. Quality, aesthetic, and copy guidance apply to both; **Verification** guides execution and review.

Audit the system first, then make choices that serve the brief. Existing conventions and explicit design requirements take precedence over the aesthetic preferences below. Familiar patterns are appropriate when they fit the content and task; novelty alone is not a reason to change them.

## First: audit what exists

Before any design decision, read the project configuration and existing codebase for its visual language. Find the design tokens — colors, type scale, spacing, radii, shadows, breakpoints — wherever the system defines them:

- **Project configuration:** Token entry points, component libraries, and styling engines declared in project docs.
- **Centralized tokens:** Theme objects, stylesheets, token files, or constants declared by the project.
- **Scattered tokens:** Values hardcoded in individual components or views — note these too; they are the real system even when unintentional. Search the UI source for hex and `rgb(`/`hsl(` colors, `px`/`rem` lengths, `font-family`, `border-radius`, and `box-shadow`, then rank by frequency; the values that repeat are the de facto scale.

Identify the component patterns: how cards, forms, navigation, modals, empty states, and error states already look and behave. Note the existing typefaces, their roles, and how they are paired.

The existing design is the brief. New UI must look like it belongs in the same product, not like a different designer built it. Every color, font, spacing value, and radius comes from the existing system unless the system has no precedent for the need. Prefer semantic intent tokens (`surface-primary`, `background-subtle`) over raw primitive scales (`zinc-900`, `#18181B`) — unless the system deliberately exposes only primitives, in which case follow that convention rather than introducing a semantic layer the product does not have.

## Extending the system

When the existing system has no token or pattern for what the feature needs, extend it — do not invent a parallel system. A new color follows the existing naming and scale. A new component follows the existing structural conventions (padding ratios, border treatments, interaction patterns). Match the existing level of complexity: if the product uses simple flat cards, do not introduce glassmorphism.

Propose extensions explicitly in `## Design Decisions` during design-feature. Name the gap, the proposed token or pattern, and why the existing system cannot cover it.

## Process: plan, review, build

**Existing visual system:** Plan the delta in `## Design Decisions` under the greenfield plan's four fields below — Color, Type, Layout, Principles and signature — citing existing token names rather than new values, and naming any extension with its gap (`Extending the system`). A missing component or layout precedent does not mean the visual system is absent. For example, a product's first dashboard still uses its established colors, typography, and spacing.

Use the known product, audience, and primary job. If a new surface leaves a material user need unclear, ask one focused question about that gap; established visual tokens do not establish its audience or behavior.

**No existing visual system:** Ground the design in the product, audience, and primary job. Use the brief and available project context; confirm any missing information that materially changes the design. Capture a short plan in `## Design Decisions`:

- **Color:** the core base palette as 4–6 named hex values.
- **Type:** typefaces and their roles.
- **Layout:** a one-sentence concept with ASCII wireframes for comparison. Include alignment guidance.
- **Principles and signature:** what makes this design specific to this brief.

In either branch, an unanswered question does not block: fall back to the nearest comparable surface in the product, or to the most conventional pattern for that surface type when none exists, and record the assumption in `## Design Decisions` for review.

Review the plan before writing code: connect its choices to the content, user task, or existing system. Revise choices that lack that connection. A familiar choice with a clear purpose needs no replacement. Follow the owning phase's review and approval gates.

## Craft within constraints

**Typography.** Use the established type scale. Set hierarchy through existing weight and size steps. If the product has a display face, use it as the product already does. Default to line lengths under 80 characters; serif body text needs slightly more line-height than sans-serif.

Check these treatments against existing conventions and the brief. Preserve established uses; introduce them when they serve emphasis, hierarchy, or navigation:

- Accenting a single word or phrase in a headline (italic, bold, or a different color).
- Using all caps for labels.
- Adding typographic labels above content.

**Structure.** Structural devices (dividers, labels, eyebrows, numbering) match existing conventions. Numbered markers (01 / 02 / 03) are only appropriate when the content actually is a sequence — a stepped process or timeline. If the product does not use them, do not introduce them. Structural choices encode information architecture, not decoration.

**Motion.** Match the existing motion language — duration, easing, and where animation appears. If the product is static, keep it static. New animation only when the feature has an interaction pattern the product has not needed before. A single orchestrated moment lands better than scattered effects; fade-and-slide-up entrances per section and hover transitions on every card are the generic default. When the product animates but documents no scale, derive duration and easing from its most common existing transitions; absent any precedent, keep hovers and small entrances near 150–250 ms with an ease-out, and reserve longer durations for larger travel.

**Density and spacing.** Follow the established spacing scale and density. A data-heavy product stays data-heavy. A spacious product stays spacious.

**Layout stability.** Reserve explicit dimensions for asynchronous content and media to prevent layout shift. Define wrapping or scrolling behavior for small screens and large font scales.

**Restraint.** Spend boldness in one place — let one element be the memorable thing, keep everything around it quiet, and cut decoration that does not serve the brief. Critique your own output as you build; verify the result using **Verification** below.

## Quality floor

Apply these requirements to affected UI: responsive down to mobile, visible keyboard focus, native semantic controls, accessible names for icon-only buttons, respect for `prefers-reduced-motion`, and WCAG AA color contrast.

**Themes.** If the product supports a dark or alternate theme, every new surface, token, and state works in all of them; verify contrast in each, since a color that passes on light does not carry over.

**Target size.** For web, measure hit areas in CSS pixels:

| Case | Size |
| --- | --- |
| WCAG 2.2 AA minimum | 24×24 |
| Touch controls, minimum | 44×44 |
| Touch controls, preferred | 48×48 |

The 24×24 minimum has spacing, equivalent-control, inline-text, user-agent-control, and essential-presentation exceptions; use the [target-size guidance](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html) to check any claimed exception. Native UI follows its platform's units and target guidance; do not interchange native points and CSS pixels.

**States and scope.** Specify applicable states during design: default, hover, focus, active/pressed, loading, disabled, error, and selected/expanded where relevant. Derive them from actual behavior. A static navigation link needs no invented loading, disabled, or error condition. Match existing state patterns. Required behavioral additions belong in the plan; discoveries during execution follow PROCESS scope and approval rules.

## Common defaults to examine

These combinations can become automatic choices. Use them when supported by the brief or established design, including in greenfield work. For example, a broadsheet layout can suit a newspaper. Review whether each treatment helps the content and task; its presence alone is not a defect:

1. A warm cream background (near #F4F1EA) with a high-contrast serif display and a terracotta or warm-clay accent (often near #D97757).
2. A near-black background with a single bright acid-green or vermilion accent.
3. A broadsheet-style layout with hairline rules, zero border-radius, and dense newspaper-like columns.
4. The SaaS-card kit: content chopped into identical rounded cards, one border-radius on everything regardless of hierarchy, the same soft grey shadow (`rgba(0,0,0,.1)`) under each, and gradient washes as decoration.
5. Template chrome regardless of subject: tracked-out ALL-CAPS eyebrow labels above every heading; meta strings joined with middle dots ('A · B · C'); labels as 'WORD — fragment' with a spaced em dash; tinted near-black (#0B0B0B, #111) standing in for black; a monospace face for small data labels; '→' appended to link and button text. The tell is the reflex, not the device: monospace suits real data, and an eyebrow suits a real kicker.

## Styling discipline

Follow the project's existing styling architecture and project configuration:

- **Encapsulation:** Scope styles to their component or view. For conflicting styles, inspect matched rules and computed values. `.section` and `.cta` are class selectors with equal specificity; `section` is a type selector. For competing declarations, check cascade origin, importance, layers, specificity, source order, and shorthand/longhand overlap.
- **Theme injection:** Consume theme tokens through the platform's standard injection pattern rather than top-level global constants.
- **Single paradigm:** Do not mix styling approaches. If the project uses a design system library, use its primitives. If it rolls its own, extend that.

## Verification

For affected UI, record the checks performed and their results in the existing implementation or review evidence:

- Render the running UI at representative mobile and desktop widths and enlarged text; check wrapping, overflow, media space, and alignment with the plan. Drive it with the session's browser automation and capture a screenshot at each width.
- Exercise keyboard navigation, activation, and visible focus; check focus movement and return for overlays when applicable.
- Exercise the applicable states from the plan, including failure and recovery paths when present.
- Check accessible names, contrast, target sizes or justified exceptions, and reduced-motion behavior where applicable.

If browser or other required tools are unavailable, report the checks that could not run and the remaining manual checks. Distinguish static inspection and unit-test results from observed rendering and interaction; they do not establish visual or keyboard verification.

## Copy

Words are design material. Follow the existing product voice. Bring the same intentionality to copy that you bring to spacing and color.

**Match the register.** Read existing UI copy — button labels, headings, empty states, error messages, tooltips — and match the tone, formality, and vocabulary. If the product says "Save" not "Submit," new UI says "Save." If errors are terse, new errors are terse.

**Write from the user's perspective.** Name things by what users understand, not by how the system is built. A user manages notifications, not webhook config. Specific and legible beats clever.

**Name things consistently.** An action keeps the same name through its flow: the button that says "Publish" produces a toast that says "Published." Use the product's existing vocabulary — do not introduce synonyms.

**Active voice, sentence case.** Controls say what happens when used. Labels label. Nothing does double duty.

**Errors and empty states.** Explain what went wrong and how to fix it, in the interface's voice. Errors don't apologize and are never vague. An empty screen is an invitation to act. Match the existing product's pattern for these.
