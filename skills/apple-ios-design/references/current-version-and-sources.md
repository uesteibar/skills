# Current Version and Sources

Last verified: **2026-09-10**.

This file is intentionally versioned. Re-check official sources before relying on it for a later OS cycle.

## Current iOS/iPadOS 27 design delta

Compared with the iOS 26-era Design+Code article, current Apple guidance emphasizes:

- Liquid Glass as a dynamic functional layer for controls and navigation.
- Automatic adoption by standard SwiftUI, UIKit, and AppKit components.
- Removing custom backgrounds that interfere with system materials and scroll-edge effects.
- Using custom glass sparingly and testing Reduce Transparency, Reduce Motion, and increased contrast.
- Tab bars that can minimize during scrolling and adapt into sidebars.
- A semantic search tab separated at the trailing edge.
- Search integrated with navigation, scroll, and keyboard behavior.
- Rounder control geometry and an extra-large control size.
- More spacious lists, tables, and forms with title-style section headers.
- Grouped Liquid Glass toolbar actions and standard icons for common commands.
- Inset/rounder half sheets and source-anchored action sheets.
- Functional automatic, hard, and soft scroll-edge effects.
- Layered app icons produced with Icon Composer.
- Default, Dark, Clear/Mono, and tinted icon appearances as supported.
- Current SF Symbols animation and variable-rendering capabilities.
- Arbitrary iPad window sizes and fluid split-view adaptation.

## UI-kit policy

Use the official iOS/iPadOS 27 Figma or Sketch kit for exact visual comparisons. The Figma kit states that it contains common controls and views, templates, text styles, color styles, and materials and was overhauled for iOS/iPadOS 27 changes including Liquid Glass, layout, sidebar colors, and scroll-edge effects.

Do not bundle or redistribute Apple UI-kit files in this skill. Open the current official resource and follow its license. Do not infer current measurements from old screenshots.

## Official primary sources

### Apple design and resources

- What’s new: https://developer.apple.com/design/whats-new/
- Apple Design Resources: https://developer.apple.com/design/resources/
- iOS and iPadOS 27 Figma kit: https://www.figma.com/community/file/1651309003795292092/ios-and-ipados-27
- Human Interface Guidelines: https://developer.apple.com/design/human-interface-guidelines/

### Current visual system

- Liquid Glass overview: https://developer.apple.com/documentation/technologyoverviews/liquid-glass
- Adopting Liquid Glass: https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass
- Materials: https://developer.apple.com/design/human-interface-guidelines/materials
- Color: https://developer.apple.com/design/human-interface-guidelines/color
- Dark Mode: https://developer.apple.com/design/human-interface-guidelines/dark-mode

### Structure and components

- Layout: https://developer.apple.com/design/human-interface-guidelines/layout
- Tab bars: https://developer.apple.com/design/human-interface-guidelines/tab-bars
- Toolbars: https://developer.apple.com/design/human-interface-guidelines/toolbars
- Search fields: https://developer.apple.com/design/human-interface-guidelines/search-fields
- Scroll views: https://developer.apple.com/design/human-interface-guidelines/scroll-views
- Sheets: https://developer.apple.com/design/human-interface-guidelines/sheets
- Buttons: https://developer.apple.com/design/human-interface-guidelines/buttons
- Lists and tables: https://developer.apple.com/design/human-interface-guidelines/lists-and-tables
- Text fields: https://developer.apple.com/design/human-interface-guidelines/text-fields
- Toggles: https://developer.apple.com/design/human-interface-guidelines/toggles
- Pickers: https://developer.apple.com/design/human-interface-guidelines/pickers
- Menus: https://developer.apple.com/design/human-interface-guidelines/menus

### Type, symbols, icons, and inclusion

- Typography: https://developer.apple.com/design/human-interface-guidelines/typography
- Accessibility: https://developer.apple.com/design/human-interface-guidelines/accessibility
- Motion: https://developer.apple.com/design/human-interface-guidelines/motion
- App icons: https://developer.apple.com/design/human-interface-guidelines/app-icons
- Icon Composer: https://developer.apple.com/icon-composer/
- SF Symbols: https://developer.apple.com/sf-symbols/

### Secondary coverage source

- Design+Code iOS Design Guidelines: https://designcode.io/ios-design-guidelines

Use the secondary source to ensure topic coverage. Use Apple sources to settle current behavior.

## Refresh procedure

When a task requires current facts:

1. Open Apple’s What’s New, Design Resources, and the relevant HIG pages in background tabs.
2. Check page change logs and the official UI-kit update date.
3. Compare changed behavior with this file.
4. Treat new device lists and exact metrics as volatile.
5. Update this file through `skill_manage` if the guidance materially changed.
6. Record the new verification date and summarize only durable deltas.

Completion criterion: every current-version claim used in the result is backed by a freshly checked official page or explicitly marked as not reverified.
