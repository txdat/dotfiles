# Frontend Design — Visual Design Guidance

Read by `design-feature` and `execute-feature` for UI/frontend work. Read AI project configuration.

## First: audit what exists

Before any design decision, read the existing codebase for its visual language. Find the design tokens — colors, type scale, spacing, radii, shadows, breakpoints — wherever the framework keeps them:

- **Flutter:** `ThemeData`, `ColorScheme`, `TextTheme`, `AppBarTheme`, custom extension types, constants files
- **React/web:** CSS custom properties, theme objects (MUI/Chakra/shadcn), Tailwind config, styled-components themes, CSS modules, design token files
- **Scattered:** tokens hardcoded in individual components or stylesheets — note these too; they are the real system even when unintentional

Identify the component patterns: how cards, forms, navigation, modals, empty states, and error states already look and behave. Note the existing typefaces, their roles, and how they are paired.

The existing design is the brief. New UI must look like it belongs in the same product, not like a different designer built it. Every color, font, spacing value, and radius comes from the existing system unless the system has no precedent for the need.

## Extending the system

When the existing system has no token or pattern for what the feature needs, extend it — do not invent a parallel system. A new color follows the existing naming and scale. A new component follows the existing structural conventions (padding ratios, border treatments, interaction patterns). Match the existing level of complexity: if the product uses simple flat cards, do not introduce glassmorphism.

Propose extensions explicitly in `## Design Decisions` during design-feature. Name the gap, the proposed token or pattern, and why the existing system cannot cover it.

## Craft within constraints

**Typography.** Use the established type scale. Set hierarchy through the existing weight and size steps. If the product has a display face, use it as the product already does — with the same restraint or boldness.

**Structure.** Structural devices (dividers, labels, eyebrows, numbering) match existing conventions. If the product uses numbered markers, use them the same way. If it does not, do not introduce them. Structural choices encode the product's information architecture, not decoration.

**Motion.** Match the existing motion language — duration, easing, and where animation appears. If the product is static, keep it static. If it uses transitions, follow the same timing and triggers. New animation only when the feature has an interaction pattern the product has not needed before.

**Density and spacing.** Follow the established spacing scale and density. A data-heavy product stays data-heavy. A spacious product stays spacious.

## Quality floor

Responsive down to mobile. Visible keyboard focus states. Respect `prefers-reduced-motion`. Sufficient color contrast (WCAG AA). These are not features — they are baseline. Match however the existing product handles them; if it does not, add them without fanfare.

## AI-generated defaults to avoid

AI-generated UI clusters around recognizable defaults regardless of context: warm cream backgrounds with serif display type and terracotta accents; near-black backgrounds with acid-green or vermilion accents; broadsheet layouts with hairline rules and newspaper columns. These are legitimate when they match the existing product — but never introduce them into a product that does not already use them.

## Styling discipline

Follow the project's existing styling architecture. Common pitfalls by framework:

- **Flutter:** Use theme tokens (`Theme.of(context)`) instead of hardcoded values. Extend `ThemeExtension` for custom tokens rather than top-level constants. Follow the project's widget composition patterns — if it wraps Material widgets, wrap them the same way; if it builds custom, build custom.
- **React/web:** Structure selector specificities to avoid conflicts — type-based selectors (`.section`) and element-based selectors (`.cta`) cancel each other's padding and margins. Scope selectors to their component. Follow the existing CSS architecture — BEM, CSS modules, Tailwind, CSS-in-JS, or whatever the project uses.
- **Both:** Do not mix styling approaches. If the project uses a design system library, use its primitives. If it rolls its own, extend that.

## Copy

Words are design material. Follow the existing product voice.

**Match the register.** Read existing UI copy — button labels, headings, empty states, error messages, tooltips — and match the tone, formality, and vocabulary. If the product says "Save" not "Submit," new UI says "Save." If errors are terse, new errors are terse.

**Name things consistently.** An action keeps the same name through its flow: the button that says "Publish" produces a toast that says "Published." Use the product's existing vocabulary for concepts — do not introduce synonyms.

**Active voice, sentence case.** Controls say what happens when used. Labels label. Examples demonstrate. Nothing does double duty.

**Errors and empty states.** Explain what went wrong and how to fix it. No apologies, no vagueness. An empty screen is an invitation to act. Match the existing product's pattern for these.
