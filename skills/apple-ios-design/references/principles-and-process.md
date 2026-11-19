# Principles and Process

## Foundational qualities

Use Apple’s traditional principles together:

- **Deference:** interface chrome supports the content instead of competing with it.
- **Clarity:** text, icons, hierarchy, and controls remain legible and unambiguous.
- **Depth:** layering, motion, and spatial transitions explain hierarchy and causality.

Use these broader product principles when judging tradeoffs:

1. **Purpose:** every feature and element earns its place.
2. **Agency:** people remain in control and can recover from mistakes.
3. **Responsibility:** privacy, safety, and truthful behavior outweigh engagement tricks.
4. **Familiarity:** reuse platform conventions and coherent metaphors.
5. **Flexibility:** support devices, contexts, abilities, languages, and expertise levels.
6. **Simplicity:** expose the common path clearly; progressive disclosure beats either clutter or hidden capability.
7. **Craft:** spacing, alignment, typography, feedback, and adaptation are deliberate and consistent.
8. **Delight:** the outcome of usefulness and craft, not decoration added afterward.

## Hierarchy and composition

- Make the primary task and content obvious before styling secondary chrome.
- Use order, scale, weight, spacing, alignment, contrast, and grouping to establish hierarchy.
- Proximity implies relationship. Place controls near the content or object they affect.
- Separate groups with spacing before adding dividers or containers.
- Preserve content focus; navigation and controls occupy a functional layer above content.
- Keep primary actions prominent and destructive actions visually distinct without making every action loud.
- Use concise, specific labels. Prefer destinations such as “Library” or “Progress” over vague labels such as “Home” when specificity improves prediction.

## Wayfinding and agency

Every screen should answer:

- Where am I?
- What can I do here?
- Where can I go next?
- How do I go back, cancel, or exit?

Preserve system back behavior. Confirm only genuinely destructive or hard-to-reverse actions; excessive confirmation trains people to ignore warnings. Prefer undo when recovery is practical.

## Feedback

Cover four feedback classes:

- **Status:** what the system is doing now.
- **Completion:** what succeeded and what changed.
- **Warning:** a preventable risk before commitment.
- **Error:** what failed, why when known, and what can be done next.

Respond immediately on press or gesture start. Validate fields near the source of the problem. Maintain visible progress for operations that take perceptible time. Do not use haptics, sounds, animation, or toast messages without a user-facing purpose.

## Process

1. Define the user’s core job and success condition.
2. Sketch the information architecture and navigation before visual styling.
3. Prototype the highest-risk interaction rather than polishing static screens.
4. Test real text lengths, loading, empty, error, offline, permission, and destructive states.
5. Test on representative device sizes and accessibility settings.
6. Review with real users in realistic contexts when stakes justify it.
7. Iterate from task failure and confusion, not from aesthetic preference alone.

An interactive prototype reveals gesture, keyboard, scrolling, interruption, and transition problems that static mockups conceal.
