# Layout and Adaptation

## Points, pixels, and scale

Design interface geometry in points, not hardware pixels. Image and rendering resources may be produced at multiple scale factors, but layout logic should be scale-independent. Prefer vector assets, SF Symbols, and asset catalogs where possible.

Do not embed a permanent table of current iPhone resolutions in the skill. Device families, cutouts, window modes, and display scales change. Use the current Apple device templates or UI kit when exact geometry matters.

## Safe areas

- Keep essential content and controls within safe areas unless an intentional edge-to-edge experience extends behind system regions.
- Backgrounds, media, and decorative surfaces may extend edge to edge; interactive content must remain reachable and legible.
- Account for status regions, sensor housings, rounded corners, the Home indicator, navigation and tab bars, keyboards, sheets, sidebars, and inspectors.
- Do not simulate safe-area offsets with one fixed top or bottom padding.
- Test landscape and all supported orientations.

## Spacing and alignment

- Start with system spacing and UI-kit components instead of reconstructing Apple metrics by eye.
- Use a small, consistent spacing scale and align related content to shared edges.
- Common iPhone content margins often begin around 16–20 pt, but treat this as a starting convention rather than a universal requirement.
- Maintain adequate separation between unrelated actions and between destructive and routine actions.
- Let readable text columns remain narrower than full-screen media on larger devices.

## Adaptive structure

Design for size classes and available space, not named devices alone.

- iPhone commonly favors a navigation stack or compact tab structure.
- iPad may use sidebars, split views, inspectors, toolbars, keyboard commands, pointer interactions, and multiple resizable windows.
- Let tab navigation adapt into a sidebar when the information architecture is shared and the platform supports it.
- Allow columns to resize fluidly and collapse deliberately.
- Preserve selection and navigation context when moving between compact and regular layouts.
- Avoid “stretched iPhone UI” on iPad.

## Text-driven layout

- Use semantic text styles and Dynamic Type.
- Allow labels and body content to wrap where appropriate.
- Avoid fixed-height text containers.
- Reflow rather than merely shrink when accessibility text sizes become large.
- Keep important actions reachable when text expands.
- Test long localized strings, bidirectional text, and right-to-left layout.

## Keyboard and input

- Keep the focused field and its validation visible when the keyboard appears.
- Use the appropriate keyboard type, return-key behavior, text-content type, autofill, and secure entry.
- Provide keyboard dismissal that does not discard input.
- On iPad, support hardware keyboards, pointer hover where useful, and focus navigation where applicable.

## Scrolling

- Use standard scrolling behavior and indicators.
- Make overflow discoverable without relying solely on a temporarily visible scroll indicator.
- Avoid nesting scroll views with the same axis unless the interaction has been proven usable.
- Scroll automatically only enough to reveal a focus, search result, selection, or insertion point.
- Use scroll-edge effects only where floating interface elements overlap scrolling content.
- Prefer automatic scroll-edge behavior; test hard or soft styles over real content before customizing.

## Review checklist

- Safe areas respected in every state.
- No clipped content at large Dynamic Type sizes.
- Keyboard never hides the active task.
- Rotation and multitasking retain context.
- iPad layout uses available space intentionally.
- Scroll behavior remains predictable and discoverable.
- Exact device metrics come from current official resources.
