# Apple UI Review

## Review frame

- Product:
- Platform and minimum OS:
- Device classes/orientations:
- Implementation stack:
- Artifact reviewed:
- Primary user tasks:
- Assumptions and unverified areas:

## Executive assessment

Summarize task success, platform fit, accessibility risk, and the highest-leverage correction in 3–6 sentences.

## Prioritized findings

### [Severity] Finding title

- **Authority:** Apple guidance | Current-version delta | Implementation defect | Product recommendation
- **Evidence:** Screen/state and observable behavior
- **User impact:** What becomes slower, confusing, inaccessible, unsafe, or inconsistent
- **Recommendation:** Concrete component, layout, content, or behavior change
- **States to cover:** Default/pressed/loading/error/empty/etc.
- **Accessibility/adaptation:** Dynamic Type, VoiceOver, appearances, motion, device/window behavior
- **Acceptance criteria:** A testable statement of completion
- **Source:** Official HIG/UI-kit link when the finding relies on current platform guidance

Repeat for every finding, ordered Critical → High → Medium → Low.

## Cross-cutting checks

- [ ] Navigation and escape paths
- [ ] Safe areas, keyboard, rotation, iPad resizing
- [ ] Dynamic Type and localization
- [ ] VoiceOver names, roles, values, focus order
- [ ] 44 × 44 pt targets and alternate inputs
- [ ] Light/Dark/increased contrast
- [ ] Reduce Motion/Reduce Transparency
- [ ] Loading, empty, offline, error, success, destructive states
- [ ] System-component and SF Symbol opportunities
- [ ] Version-sensitive metrics verified in current UI kit

## Recommended sequence

1. Blockers, safety, privacy, and accessibility exclusions.
2. Core task flow and navigation.
3. Layout and component architecture.
4. States and feedback.
5. Current Apple visual-system adoption.
6. Polish and delight.

## Positive observations

Record platform-aligned choices worth preserving so the redesign does not regress them.

## Open questions

List only questions whose answers materially change the recommendation.
