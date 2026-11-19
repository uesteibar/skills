---
name: material-android-design
description: Use when designing or auditing Android Material UI.
version: 0.2.0
author: uesteibar, Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [android, material-3, mobile, design, accessibility]
    related_skills: [mobile-product-design, apple-ios-design]
---

# Material Android Design

Design, specify, and audit Android interfaces using Material 3 and current Android platform guidance. Preserve product identity while making navigation, controls, adaptation, and feedback natural on Android. This is design guidance, not authorization to implement or migrate a UI framework.

## When to Use

- Designing or reviewing Android phone, tablet, or foldable app UI.
- Choosing Material navigation, controls, typography, colour, surfaces, motion, or interaction patterns.
- Translating an existing iOS product into a first-class Android experience.
- Specifying Android behaviour for Compose, Views, React Native, Expo, or another native-mobile stack.
- For paired iOS/Android work, load `mobile-product-design` and follow its cross-platform design contract; load `apple-ios-design` for the iOS side. Do not apply Apple conventions to Android.
- Do not use Android mechanics as universal Material rules for web, desktop, Wear, or TV. Those targets require their own current platform guidance.

## Authority and Currentness

Use this order:
1. Direct user scope and approved product requirements establish intent, not exemptions from accessibility or OS constraints.
2. Current Material guidance defines design patterns; current Android documentation defines platform behaviour.
3. Installed framework/library source, types, release notes, and runtime define actual implementation support.
4. This skill supplies working defaults; samples and visual references supply inspiration only.

Load [sources and version policy](references/sources-and-version-policy.md) for each new project or version-sensitive decision. Verify target Android versions, target SDK, window sizes, navigation mode, and installed libraries before recommending exact APIs or metrics. If unavailable, state assumptions rather than inventing support.

M3 Expressive expands Material 3. Treat expressive components and motion as selective design choices whose library availability must be checked, not a wholesale replacement requirement. Dynamic colour, branded themes, and Expressive are separate decisions.

## Procedure

### 1. Lock scope and inspect evidence

State whether the task is discussion, design, audit, specification, or implementation; name target devices, review axes, exclusions, and protected artifacts. Inspect current canonical screens and the actual product model when designing concrete states. Use `vision_analyze` for supplied images and relevant design/code tools for artifacts. Do not claim runtime defects from remembered designs.

Completion: named evidence, assumptions, platform frame, and keep-unchanged list.

### 2. Establish hierarchy and navigation

Read [navigation, controls, and adaptation](references/navigation-controls-and-adaptation.md).

- Preserve real destinations and action semantics. Never create a fake tab to host an action or copy an iOS tab-bar composition mechanically.
- Choose navigation bar, rail, or another pattern from task structure and available window space, not the device marketing label.
- Keep navigation Up distinct from system Back; inspect entry paths, deep links, transient surfaces, and unsaved work.
- Define Back commit and cancel behaviour, including predictive back where supported. Do not consume Back solely to imitate iOS.
- Prefer platform/library-owned transitions, menus, pickers, and text input over custom imitations.
- Choose a FAB only for a clear high-priority contextual action. Material does not require a FAB on every screen.

Completion: every action has an entry, destination, return path, and reason for placement.

### 3. Establish the Material theme

Read [theming, accessibility, and motion](references/theming-accessibility-and-motion.md).

- Define semantic colour roles and paired foreground roles, not a palette pasted onto components.
- Map brand identity into light and dark schemes, shape roles, type roles, imagery, and sparse identity moments.
- Decide branded versus dynamic colour explicitly; preserve recognisable assets and semantic meaning under either.
- Use surfaces, spacing, typography, and tonal hierarchy before adding borders or cards. Do not wrap every line or metric in its own container.
- Use platform-appropriate icons with consistent meanings. Do not import SF Symbols as Android system iconography.

Completion: a short theme policy that explains what is branded, platform-owned, and intentionally custom.

### 4. Design complete state families

Use real content, reducers, and presentation helpers rather than fabricated fields or timing. Cover the happy path plus actual empty, loading, keyboard-open, error, retry, cancellation, and pending-save states. Preserve source evidence and entered work where the real flow supports recovery. OS-owned choosers and permission dialogs need interaction specifications, not custom artboards.

Do not shrink body text to fit a phone frame. Let reading surfaces scroll and text reflow. Preserve useful domain-specific controls; add explicit accessible values/actions and a non-gesture-only way to operate them.

Completion: coherent complete screens, with a state matrix and explicit omissions, before component extraction.

### 5. Validate Android mechanics

- Account for status/navigation bars, cutouts, gesture insets, and IME without double-padding. Edge-to-edge backgrounds do not imply controls may sit under system gestures.
- Check gesture navigation and three-button navigation, keyboard dismissal, focus, and primary-action reachability.
- Check window resizing, rotation, and state continuity. Tablet/foldable scope must be explicit; do not silently promise full adaptation from a phone mockup.
- Verify TalkBack roles, names, state/value announcements, traversal, focus restoration, and custom actions.
- Verify touch targets of at least 48 × 48 dp, including actual hit areas and adjacent overlap; check text scaling, light/dark contrast, non-colour status cues, and reduced/disabled animation settings.
- Check external keyboard and pointer behaviour when those device classes are in scope.

Completion: evidence for each in-scope check, with unavailable device/runtime checks labelled unverified.

### 6. Report and hand off

Use [the Android review template](templates/android-design-review.md). Classify findings as `Material guidance`, `Android platform requirement`, `Implementation defect`, or `Product recommendation`. Prioritise task blockers and data loss above visual polish. Cite the current source for platform claims and exact screen/state evidence for defects.

Distinguish:
- **Material-aligned specification:** an artifact describing expected appearance and behaviour.
- **Library-rendered Material UI:** actual components from a named, verified implementation.
- **OS-owned surface:** a chooser or other interface presented by Android itself.
- **Custom approximation:** app-rendered UI that still needs behavioural verification.

Compose is an official Material implementation, not an implicit mandate to rewrite a React Native app. A library name or M3 theme flag does not prove all components, accessibility, predictive back, or Expressive features are supported.

Completion: requested deliverable, evidence-backed findings, deliberate exceptions, and remaining runtime verification.

## Pitfalls

- Android as a post-approval iOS reskin.
- Equating native quality with Google's stock colours, excessive rounding, cards, or FABs.
- Treating wallpaper dynamic colour as mandatory or incompatible with all brand identity.
- Using a brand hex with an arbitrary foreground instead of checking the resolved role pair.
- Copying old SDK thresholds, animation constants, or experimental APIs without version checks.
- Assuming Compose defaults exist in another framework.
- Replacing an effective custom control with a stock component for visual conformity alone.
- Calling a screenshot native, or tests green, without runtime evidence.

## Verification

- [ ] Scope, authority level, target OS/SDK/framework, and assumptions recorded.
- [ ] Current official sources checked for version-sensitive recommendations.
- [ ] Real information, navigation, actions, and state transitions preserved.
- [ ] Material theme and dynamic-colour decisions explicit.
- [ ] Back/Up, IME, insets, adaptation, and accessibility reviewed within scope.
- [ ] Complete screens reviewed before extracting shared components.
- [ ] Structural checks and screenshots inspected independently.
- [ ] Runtime quality separated from artifact quality; gaps not reported as passed.
- [ ] Product identity preserved without importing Apple mechanics.
