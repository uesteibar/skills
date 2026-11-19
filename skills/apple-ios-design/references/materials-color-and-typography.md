# Materials, Color, and Typography

## Liquid Glass and materials

Liquid Glass is a dynamic functional layer for navigation and controls, not a decorative coating for every surface. Standard SwiftUI, UIKit, and AppKit components adopt the current material automatically when built with current SDKs.

- Let content occupy the main visual plane; navigation and controls float above it where appropriate.
- Prefer system bars, sheets, popovers, buttons, and controls before custom glass implementations.
- Remove custom backgrounds that interfere with system glass or scroll-edge effects.
- Avoid stacking translucent surfaces or placing multiple glass controls on top of one another.
- Use custom glass effects sparingly and only for important functional elements.
- Group custom effects in the platform’s shared glass container when required for performance and coherent morphing.
- Test transparency, refraction, focus, overlap, and motion over real light and dark content.
- When Reduce Transparency is enabled, preserve hierarchy with a more opaque or solid alternative.

Material weight communicates hierarchy. Larger structural surfaces may need stronger separation than small controls, but exact rendering belongs to the system. Do not reproduce system blur, shadow, highlight, or refraction with fixed screenshots or baked-in images.

## Scroll-edge effects

Use a scroll-edge effect only when scrolling content passes behind floating controls or chrome. Prefer automatic behavior. Hard or soft variants must be tested for legibility; they are not decorative gradients or generic section dividers. Apply one coherent effect per pane and align effects across split-view columns.

## Color

- Use semantic system colors for labels, secondary text, backgrounds, fills, separators, links, and destructive actions.
- Define custom colors with light, dark, and increased-contrast variants.
- Use tint intentionally for interactive emphasis, not as an uncontrolled brand wash.
- Do not communicate status through color alone; pair it with text, shape, position, or iconography.
- Reserve system red for destructive/error meaning in action contexts.
- Avoid putting colored content on translucent foreground layers when the result becomes unstable over changing backgrounds.
- Test colors on-device, in wide-gamut contexts when relevant, and with accessibility contrast settings.

Dark Mode is not color inversion. Preserve hierarchy, avoid pure white expanses, use semantic surfaces, and re-evaluate shadows, separators, illustrations, photos, and brand colors independently.

## Typography

Prefer San Francisco/system fonts and semantic text styles. They integrate with Dynamic Type, optical sizing, platform metrics, and accessibility.

- Build hierarchy with size, weight, leading, color, and spacing together.
- Body text in custom systems should generally not fall below roughly 16 pt; the platform’s standard body style is usually the safer default.
- Use Dynamic Type rather than freezing the design at one font size.
- Tighten tracking and leading for large display text; smaller text generally needs more open spacing.
- Avoid one global letter-spacing value across all sizes.
- Let labels wrap when meaning would otherwise be lost.
- Avoid all caps for long UI labels; current list/form section headers use title-style capitalization.
- Use monospaced digits only where stable numeric alignment improves reading.
- Use custom fonts only when they preserve language coverage, Dynamic Type behavior, and legibility.

## Text review

Check:

- Content hierarchy is visible without relying only on color.
- Body copy remains comfortable at default size.
- Accessibility sizes reflow rather than clip.
- Bold Text and increased contrast remain coherent.
- Localization expansion does not truncate critical actions.
- Links and interactive text are distinguishable and accessible.
- Truncation reveals full content through an appropriate detail path when the content matters.
