---
name: apple-ios-design
description: Use when designing or auditing iOS and iPadOS interfaces.
version: 1.2.0
author: uesteibar, Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [apple, ios, ipados, design, ui-review, accessibility]
    related_skills: [mobile-product-design, material-android-design]
---

# Apple iOS Design

Design, specify, or audit Apple-platform interfaces using current Apple guidance, official UI resources, and fluid-interaction craft. This skill covers iPhone and iPad product UI, including layout, navigation, components, materials, typography, symbols, app icons, accessibility, motion, widgets, extensions, and launch behavior.

Treat official Apple guidance and the current Apple UI kit as the source of truth. The Design+Code article is a useful coverage map, not a frozen specification. Do not copy its prose or make old measurements timeless rules.

## When to Use

Use this skill when:

- Designing, redesigning, or reviewing an iOS or iPadOS interface.
- Auditing an interface for Apple-platform quality.
- Writing an implementation-ready UI specification for SwiftUI, UIKit, React Native, Expo, or a web experience intentionally modeled on Apple UI.
- Choosing Apple navigation, controls, sheets, search, typography, color, symbols, app icons, widgets, or motion behavior.
- Translating Apple interaction principles to gesture-driven or web UI.

Do not use it as generic visual polish when the product is not meant to follow Apple conventions. Do not assume that a web imitation can reproduce private system rendering exactly.

## Combining with the shared mobile workflow

For paired iOS/Android design, ports, or shared UI decisions, use `mobile-product-design` to coordinate shared semantics, platform differences, and separate acceptance. Also load `material-android-design` for the Android side; this skill governs only the Apple side. For iOS-only work, this skill is sufficient. Load each relevant skill once, not recursively.

Keep product-specific feature rules, palette choices, and approved screens in project-owned documents, not in this generic platform skill.

Preserve an explicitly iOS-only task. Do not make an approved iOS composition the mandatory Android template, apply Apple system colours or metrics to Android, or claim cross-platform readiness from iOS evidence alone. Product parity is equal task quality, not identical pixels. The shared workflow does not override current Apple guidance on Apple targets.

## Authority and Currentness

Use this priority order:

1. Current Apple Human Interface Guidelines and technology overviews.
2. Current official Apple Design Resources and UI kits.
3. Platform framework behavior and accessibility settings.
4. This skill’s synthesized guidance.
5. Historical or third-party articles.

When sources disagree, prefer the higher authority and state the target OS. Exact device, bar, control, and material metrics are version-sensitive; verify them in the current UI kit instead of inventing or reusing an old number.

Read `references/current-version-and-sources.md` whenever the request asks what is current, mentions Liquid Glass, needs exact component appearance, or targets a named OS release.

## Reference Map

Load only what the task needs. For reviews, load accessibility guidance to recognise relevant constraints; loading it does not expand a narrowly scoped task into a comprehensive accessibility audit.

| Topic | Reference |
| --- | --- |
| Design principles, hierarchy, feedback, process | `references/principles-and-process.md` |
| Points, safe areas, device adaptation, layout | `references/layout-and-adaptation.md` |
| Tabs, navigation stacks, sidebars, toolbars, search | `references/navigation-search-and-structure.md` |
| Buttons, inputs, lists, forms, menus, sheets, alerts | `references/controls-lists-forms-and-modals.md` |
| Liquid Glass, materials, color, Dark Mode, typography | `references/materials-color-and-typography.md` |
| SF Symbols, app icons, Icon Composer, launch assets | `references/symbols-icons-and-assets.md` |
| VoiceOver, targets, Dynamic Type, contrast, motion | `references/accessibility-and-motion.md` |
| Widgets, extensions, notifications, App Clips | `references/widgets-extensions-and-launch.md` |
| Springs, gestures, momentum, web translation | `references/fluid-interaction-and-web-translation.md` |
| Current iOS/iPadOS changes and official links | `references/current-version-and-sources.md` |
| Coverage of the source article | `references/article-coverage-map.md` |

## Procedure

### 1. Establish the review frame

Determine:

- Platform and minimum OS version.
- Device classes and orientations.
- Implementation stack.
- Primary users, tasks, and data sensitivity.
- Whether the deliverable is a concept, design spec, implementation review, or live UI audit.

If these are unavailable, state assumptions. Completion criterion: the review has an explicit platform/version frame.

### 2. Gather evidence

When the user requests a limited component/layout pass, define an explicit keep-unchanged list before recommending changes. Reconcile prior runtime audits with the current restored design: a runtime defect may already be corrected in the design, or the design may intentionally use a different domain-specific control. Do not turn a broad audit into an automatic redesign checklist. Identify exact current frames/components, and disclose absent frames instead of inventing IDs or repurposing an unrelated screen.

Inspect the actual UI, screenshots, design file, or code. Use `vision_analyze` for images and the appropriate browser or code tools for live interfaces. Do not claim a visual problem from memory when the artifact is available.

For each finding, record the screen/state, evidence, and affected user outcome. Completion criterion: every major claim points to observable evidence.

### 3. Review in this order

1. Purpose and information hierarchy.
2. Navigation, wayfinding, and exit paths.
3. Layout, safe areas, adaptation, and text scaling.
4. Component choice and state behavior.
5. Typography, color, materials, and iconography.
6. Feedback, loading, errors, empty states, and destructive actions.
7. Direct manipulation, motion, and interruption.
8. Accessibility and input-method coverage.
9. Current-version compatibility and system-component opportunities.

Do not begin with cosmetic glass effects while structure or task flow is broken.

### 4. Classify findings

Use these severities:

- **Critical:** blocks a core task, creates material privacy/safety risk, or excludes an accessibility path.
- **High:** causes navigation failure, data loss risk, severe adaptation failure, or repeated confusion.
- **Medium:** violates a strong platform convention or noticeably harms comprehension or efficiency.
- **Low:** polish, consistency, or delight issue with limited task impact.

Tag every finding as one of:

- `Apple guidance`
- `Current-version delta`
- `Implementation defect`
- `Product recommendation`

Completion criterion: severity and authority are explicit for every finding.

### 5. Recommend concrete corrections

Specify:

- What changes.
- Where and in which states.
- Which system component or semantic token to prefer.
- Expected behavior under Dynamic Type, Dark Mode, increased contrast, Reduce Motion, and Reduce Transparency.
- Whether exact metrics must be taken from the current UI kit.

Avoid vague advice such as “make it more native.” Completion criterion: each recommendation is implementable and testable.

### 6. Produce the deliverable

For a review, use `templates/ui-review.md`. For a design specification, use `templates/design-spec.md`.

Prioritize the smallest set of changes that improves task success first, then platform fidelity and polish. Preserve product identity; Apple-native does not mean visually cloning a system app.

## Non-Negotiable Checks

For a comprehensive iPhone/iPad review, check the applicable items below. For a narrowly scoped correction, check the items affected by that change and mark other axes or device classes as out of scope; do not silently expand the task. Always disclose an accessibility failure, data-loss risk, or OS constraint already observed in the evidence, even if fixing it is outside scope. An iPhone-only task does not require a new iPad design, and deferred checks must never be reported as passed.

Comprehensive review checklist:

- Safe areas, keyboard avoidance, rotation, and resizable iPad windows.
- Dynamic Type and content reflow.
- Minimum 44 × 44 pt touch targets unless a larger accessible hit area is provided.
- VoiceOver labels, traits, focus order, and accessible names for icon-only controls.
- Meaning not conveyed by color alone.
- Light, Dark, and increased-contrast appearances.
- Reduce Motion and Reduce Transparency behavior.
- Loading, empty, offline, error, success, and destructive states.
- System back behavior, gesture conflicts, and a clear escape route.
- Localization expansion and right-to-left mirroring where relevant.

## Pitfalls

- Do not hard-code historical iPhone screen tables as a universal source of truth.
- Do not bake shadows, blur, highlights, or masks into assets when the system supplies them.
- Do not layer multiple custom glass surfaces merely to look current.
- Do not replace semantic system colors with one fixed light/dark palette.
- Do not use SF Symbols decoratively when a symbol’s established meaning conflicts with the action.
- Do not hide core navigation behind novelty gestures.
- In inline editors, keep an item's heading and editable content within one clearly identified editing scope. Do not use unrelated surface treatments that imply separate ownership. Treat this as a design recommendation, not a universal HIG rule.
- Preserve effective custom interactions when refining native fit. Improve their system integration and accessibility; replace them only when evidence supports the change, not merely because a stock control exists.
- Do not recommend animation that cannot be interrupted, or motion without a reduced-motion equivalent.
- Do not redistribute Apple UI-kit binaries or copyrighted article imagery inside this skill; link to official sources.
- Do not label a preference as an HIG violation. Keep Apple guidance separate from product judgment.

## Verification

Before finishing a design or review, confirm:

- [ ] Platform, target OS, devices, and assumptions are named.
- [ ] Evidence covers every reviewed screen and important state.
- [ ] Findings are prioritized and tagged by authority.
- [ ] Structural and task-flow issues precede visual polish.
- [ ] Accessibility and adaptation checks are complete.
- [ ] Version-sensitive measurements are verified or explicitly marked for UI-kit confirmation.
- [ ] Recommendations identify components, states, and acceptance criteria.
- [ ] The result preserves the product’s identity while using Apple conventions deliberately.
