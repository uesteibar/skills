# Article Coverage Map

Source: Design+Code, “iOS Design Guidelines” — https://designcode.io/ios-design-guidelines

The article is an iOS 26-era educational overview. This map preserves its useful topic coverage while routing current facts to official Apple guidance.

| Article area | Skill destination | Treatment |
| --- | --- | --- |
| Design philosophy and visual hierarchy | `principles-and-process.md` | Preserve and expand with purpose, agency, responsibility, familiarity, flexibility, simplicity, craft, delight. |
| Screen resolutions, points, pixels, scale | `layout-and-adaptation.md` | Preserve point/scale concepts; replace frozen device table with current resource lookup. |
| Safe areas, margins, spacing, orientation | `layout-and-adaptation.md` | Preserve as adaptive layout rules; exact metrics come from current kit. |
| Typography and Dynamic Type | `materials-color-and-typography.md` | Preserve semantic styles, hierarchy, tracking, leading, scaling, localization. |
| Color, semantic colors, Dark Mode | `materials-color-and-typography.md` | Preserve and expand with increased contrast and Liquid Glass interaction. |
| SF Symbols and interface icons | `symbols-icons-and-assets.md` | Replace old catalog assumptions with current SF Symbols behavior and availability checks. |
| Tab bars, navigation bars, large titles | `navigation-search-and-structure.md` | Preserve hierarchy; add minimization, sidebar adaptation, and current search behavior. |
| Search | `navigation-search-and-structure.md` | Preserve discoverability and suggestions; add semantic search tab and keyboard/scroll behavior. |
| Toolbars and menus | `navigation-search-and-structure.md` | Preserve action hierarchy; add grouping, standard selectors/icons, current glass behavior. |
| Buttons, switches, fields, pickers, sliders | `controls-lists-forms-and-modals.md` | Preserve component choice; avoid treating historical dimensions as permanent. |
| Lists, tables, forms, scrolling | `controls-lists-forms-and-modals.md`, `layout-and-adaptation.md` | Preserve interaction patterns; add spacious current metrics and scroll-edge behavior. |
| Alerts, action sheets, popovers, sheets | `controls-lists-forms-and-modals.md` | Preserve modal-purpose rules; add inset sheets and source anchoring. |
| Materials, translucency, blur, vibrancy | `materials-color-and-typography.md` | Supersede with current Liquid Glass guidance. |
| Gestures, animation, springs, haptics | `fluid-interaction-and-web-translation.md`, `accessibility-and-motion.md` | Preserve directness and interruption; qualify sample physics and add reduced-motion equivalents. |
| App icons | `symbols-icons-and-assets.md` | Preserve simplicity and recognition; replace production workflow with layered Icon Composer process. |
| Images and asset scale | `symbols-icons-and-assets.md` | Preserve vectors, scale, cropping, dark variants, accessibility. |
| Launch screens | `symbols-icons-and-assets.md` | Preserve immediate, static, first-frame matching behavior; reject timed splash screens. |
| Widgets | `widgets-extensions-and-launch.md` | Preserve glanceability; add deep links, interactive widgets, tinting, stale/offline states. |
| Extensions and App Clips | `widgets-extensions-and-launch.md` | Preserve focused scope and host context; add privacy and handoff checks. |
| Notifications and ongoing status | `widgets-extensions-and-launch.md` | Preserve timely actionable content; add Live Activities and Lock Screen privacy. |
| Accessibility | `accessibility-and-motion.md` | Mandatory in every review: targets, VoiceOver, Dynamic Type, contrast, settings, alternate inputs. |
| UI resources and templates | `current-version-and-sources.md` | Link current official resources; do not redistribute binaries. |

## Coverage rule

A future update must not remove an article area without either:

- Moving it to another named reference,
- Marking it obsolete with an official replacement, or
- Explaining why it is outside Apple product UI design.

This protects semantic completeness without copying the article verbatim.
