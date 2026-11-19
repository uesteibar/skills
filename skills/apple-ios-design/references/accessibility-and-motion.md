# Accessibility and Motion

Accessibility is a design constraint from the first layout, not a final checklist. Include this reference in every UI review.

## Interaction targets and inputs

- Provide at least a 44 × 44 pt touch target for interactive elements, or an equivalent accessible hit region without causing adjacent-target ambiguity.
- Maintain sufficient spacing between targets.
- Support touch, keyboard, pointer, switch control, and Voice Control where the platform and product context make them relevant.
- Do not require a complex gesture when a simple accessible action can perform the same task.
- Preserve system gestures and offer visible alternatives for custom gestures.

## VoiceOver and semantics

- Give controls concise accessible names, correct roles/traits, values, states, and hints only when needed.
- Ensure icon-only actions have meaningful labels.
- Group related static fragments when they should be read as one unit; separate independently actionable items.
- Order focus according to the visual and task hierarchy.
- Announce meaningful asynchronous changes such as validation errors, result updates, completion, and modal presentation.
- Do not place essential meaning only in an image, animation, color, or spatial relationship.

## Dynamic Type and readability

- Use semantic text styles and support the full intended Dynamic Type range.
- Reflow layouts at accessibility sizes; avoid shrinking, clipping, or overlapping.
- Preserve access to primary actions when text expands.
- Support Bold Text and increased contrast.
- Keep line lengths, leading, and paragraph spacing readable.
- Let people zoom media or text where product content demands it.

## Color and appearance

- Maintain sufficient contrast across light, dark, increased-contrast, tinted, and translucent contexts.
- Pair color with text, iconography, shape, or position.
- Do not assume red/green distinction.
- Test Smart Invert or other system adaptations when custom rendering or media could behave unexpectedly.

## Motion

Motion must explain cause, continuity, spatial relationship, or status.

- Respond immediately to touch and track direct manipulation continuously.
- Make interactive transitions interruptible and reversible.
- Enter and exit through spatially consistent paths.
- Anchor menus, sheets, and popovers to their source where appropriate.
- Avoid gratuitous parallax, large full-screen movement, flashing, or endless oscillation.
- Do not prescribe one universal duration such as 0.15–0.30 seconds; interaction, distance, velocity, and platform behavior determine timing.

When Reduce Motion is enabled:

- Replace large spatial travel, parallax, elastic overshoot, and zoom with short fades, dissolves, or static state changes.
- Preserve feedback and hierarchy; reduced motion does not mean no response.
- Avoid autoplaying animated backgrounds or nonessential symbol effects.

When Reduce Transparency is enabled:

- Replace translucent navigation and controls with a sufficiently opaque alternative.
- Maintain boundaries and hierarchy without relying on blur.

## Audio and haptics

Use haptics and sound only when they improve causality, confirmation, warning, or state comprehension. Synchronize them with the visual event. Never make audio or haptics the only feedback path, and respect system/user settings.

## Accessibility review states

Test at minimum:

- VoiceOver traversal and activation.
- Largest supported Dynamic Type sizes.
- Bold Text and increased contrast.
- Reduce Motion and Reduce Transparency.
- Light and Dark Mode.
- Color-vision deficiency simulation where color carries status.
- External keyboard navigation on iPad where applicable.
- Landscape, multitasking, and narrow resizable windows.
- Permission denial, error recovery, and destructive confirmation.
