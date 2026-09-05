# Frontend Design — Visual Design Guidance

Read by `design-feature` and `execute-feature` for UI/frontend work. Read AI project configuration for token paths, styling mechanisms, and component primitives. Sections through **Process** apply at design-feature; **Craft within constraints** through **Styling discipline** guide execute-feature; the rest apply to both.

Within the constraints of the existing system, make choices that are specific to this brief rather than borrowed from a template. Generic defaults read as generated regardless of whether the brief asks for something generic. Audit the system first — then be deliberate and opinionated within it.

## First: audit what exists

Before any design decision, read the project configuration and existing codebase for its visual language. Find the design tokens — colors, type scale, spacing, radii, shadows, breakpoints — wherever the system defines them:

- **Project configuration:** Token entry points, component libraries, and styling engines declared in project docs.
- **Centralized tokens:** Theme objects, stylesheets, token files, or constants declared by the project.
- **Scattered tokens:** Values hardcoded in individual components or views — note these too; they are the real system even when unintentional.

Identify the component patterns: how cards, forms, navigation, modals, empty states, and error states already look and behave. Note the existing typefaces, their roles, and how they are paired.

The existing design is the brief. New UI must look like it belongs in the same product, not like a different designer built it. Every color, font, spacing value, and radius comes from the existing system unless the system has no precedent for the need. Prefer semantic intent tokens (for example `surface-primary` or `background-subtle`) over raw primitive scales (for example `zinc-900` or `#18181B`).

## Extending the system

When the existing system has no token or pattern for what the feature needs, extend it — do not invent a parallel system. A new color follows the existing naming and scale. A new component follows the existing structural conventions (padding ratios, border treatments, interaction patterns). Match the existing level of complexity: if the product uses simple flat cards, do not introduce glassmorphism.

Propose extensions explicitly in `## Design Decisions` during design-feature. Name the gap, the proposed token or pattern, and why the existing system cannot cover it.

## Process: plan, review, build

**This section applies only where the audit above found no existing visual system** — a greenfield product, or a surface the system has no precedent for. Where a system exists it already answers these questions, so the design plan is the **delta**, not a fresh palette: name which existing tokens the feature consumes, which it extends and why (`Extending the system`), and the layout concept. Skip the subject-matter framing and its confirmation below: the product, its audience, and its job are already settled.

Ground the design in subject matter before planning. Identify the product, its audience, and its primary job — the subject's industry, materials, and vernacular are where distinctive visual choices come from. If the brief does not state these, propose them and confirm before proceeding.

Then produce a short design plan:
- **Color:** the core base palette as 4–6 named hex values.
- **Type:** typefaces and their roles.
- **Layout:** a one-sentence concept with ASCII wireframes for comparison. Include alignment guidance.
- **Principles:** what makes this design specific to this brief.

Review the plan before writing code: if any part reads like the default you would produce for any similar brief — revise it, state what changed and why. Only proceed once the choices are specific to this brief, not borrowed from a template.

## Craft within constraints

**Typography.** Use the established type scale. Set hierarchy through existing weight and size steps. If the product has a display face, use it as the product already does. Default to line lengths under 80 characters; serif body text needs slightly more line-height than sans-serif.

Avoid these typographic defaults — they are the commonest tells of generated UI:
- Accenting a single word or phrase in a headline (italic, bold, or a different color).
- Using all caps for labels.
- Adding unnecessary typographic labels above content.

**Structure.** Structural devices (dividers, labels, eyebrows, numbering) match existing conventions. Numbered markers (01 / 02 / 03) are only appropriate when the content actually is a sequence — a stepped process or timeline. If the product does not use them, do not introduce them. Structural choices encode information architecture, not decoration.

**Motion.** Match the existing motion language — duration, easing, and where animation appears. If the product is static, keep it static. New animation only when the feature has an interaction pattern the product has not needed before. A single orchestrated moment lands better than scattered effects; fade-and-slide-up entrances per section and hover transitions on every card are the generic default.

**Density and spacing.** Follow the established spacing scale and density. A data-heavy product stays data-heavy. A spacious product stays spacious.

**Layout stability.** Reserve explicit dimensions for asynchronous content and media to prevent layout shift. Define wrapping or scrolling behavior for small screens and large font scales.

**Restraint.** Spend boldness in one place — let one element be the memorable thing, keep everything around it quiet, and cut decoration that does not serve the brief. Critique your own output as you build; take screenshots if your environment supports it.

## Quality floor

Responsive down to mobile. Minimum touch targets (44×44 pt / 48×48 px). Visible keyboard focus states. Native interactive and accessible elements (for example accessible buttons instead of unlabelled generic containers). Accessible names for icon-only buttons. Respect `prefers-reduced-motion`. Sufficient color contrast (WCAG AA). Handle all six interactive states: default, hover/focus, active/pressed, loading/skeleton, disabled, and error. These are not features — they are baseline. Match however the existing product handles them; if it does not, add them without fanfare.

## AI-generated defaults to avoid

AI-generated UI clusters around recognizable defaults. All of the following are legitimate for some briefs, but they are defaults rather than choices and appear regardless of subject. Never introduce them into a product that does not already use them:

1. A warm cream background (near #F4F1EA) with a high-contrast serif display and a terracotta or warm-clay accent (often near #D97757).
2. A near-black background with a single bright acid-green or vermilion accent.
3. A broadsheet-style layout with hairline rules, zero border-radius, and dense newspaper-like columns.
4. The SaaS-card kit: content chopped into identical rounded cards, one border-radius on everything regardless of hierarchy, the same soft grey shadow (`rgba(0,0,0,.1)`) under each, and gradient washes as decoration.
5. Template chrome regardless of subject: tracked-out ALL-CAPS eyebrow labels above every heading; meta strings joined with middle dots ('A · B · C'); labels as 'WORD — fragment' with a spaced em dash; tinted near-black (#0B0B0B, #111) standing in for black; a monospace face for small data labels; '→' appended to link and button text.

## Styling discipline

Follow the project's existing styling architecture and project configuration:

- **Encapsulation:** Scope styles to their component or view. Avoid leaking global styles or conflicting selectors. Watch CSS selector specificity — type-based selectors (`.section`) and element-based selectors (`.cta`) can cancel each other out, which commonly surfaces as padding or margin conflicts between sections.
- **Theme injection:** Consume theme tokens through the platform's standard injection pattern rather than top-level global constants.
- **Single paradigm:** Do not mix styling approaches. If the project uses a design system library, use its primitives. If it rolls its own, extend that.

## Copy

Words are design material. Follow the existing product voice. Bring the same intentionality to copy that you bring to spacing and color.

**Match the register.** Read existing UI copy — button labels, headings, empty states, error messages, tooltips — and match the tone, formality, and vocabulary. If the product says "Save" not "Submit," new UI says "Save." If errors are terse, new errors are terse.

**Write from the user's perspective.** Name things by what users understand, not by how the system is built. A user manages notifications, not webhook config. Specific and legible beats clever.

**Name things consistently.** An action keeps the same name through its flow: the button that says "Publish" produces a toast that says "Published." Use the product's existing vocabulary — do not introduce synonyms.

**Active voice, sentence case.** Controls say what happens when used. Labels label. Nothing does double duty.

**Errors and empty states.** Explain what went wrong and how to fix it, in the interface's voice. Errors don't apologize and are never vague. An empty screen is an invitation to act. Match the existing product's pattern for these.
