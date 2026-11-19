# apple-ios-design

Guidance for designing, specifying and auditing iPhone and iPad interfaces. It treats current Apple guidance as the source of truth and adds craft rules for fluid, gesture-driven interaction.

## When an agent uses it

- You design, redesign or review an iOS or iPadOS interface.
- You need an implementation-ready UI specification for SwiftUI, UIKit, React Native, Expo, or a web experience that is meant to follow Apple UI.
- You choose navigation, controls, sheets, search, typography, colour, symbols, app icons, widgets or motion.

Do not use it as generic visual polish for a product that does not follow Apple conventions.

## How it works

1. Establish the review frame (scope, devices, OS versions, what must stay unchanged).
2. Gather evidence from the real screens and the current Apple sources.
3. Review in a fixed order, then classify each finding.
4. Recommend concrete corrections.
5. Produce the deliverable (a review, or a spec from `templates/design-spec.md`).

Source priority: current Apple Human Interface Guidelines, then current Apple design resources, then platform behaviour and accessibility settings, then the skill's own synthesis, then older articles. More than ten reference files (layout, navigation, materials and typography, controls, symbols, accessibility and motion, widgets, and others) load only when needed.

## What you need

- Access to current Apple documentation, because the skill tells the agent to verify against it.
- For paired iOS and Android work, also load `mobile-product-design` and `material-android-design`.

## Limits

It is design guidance. It does not authorise code changes, and it does not claim that a web imitation reproduces private system rendering exactly.
