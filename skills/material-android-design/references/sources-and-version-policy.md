# Sources and version policy

## Official sources

Use the relevant page, not a homepage citation for a specific claim.

| Topic | Source | Use |
|---|---|---|
| Material design system | https://m3.material.io/ | Current component design, tokens, interaction guidance, resources |
| M3 theming and Expressive context | https://developer.android.com/develop/ui/compose/designsystems/material3 | Colour, typography, shape, component customisation; Compose implementation, not proof of another library's capabilities |
| Android system bars | https://developer.android.com/design/ui/mobile/guides/foundations/system-bars | Edge-to-edge, gesture/button navigation, cutouts, keyboard interaction |
| Predictive Back design | https://developer.android.com/design/ui/mobile/guides/patterns/predictive-back | Preview, commit, cancel, and gesture conflicts; re-check current implementation docs before using API/version examples |
| Accessible component defaults | https://developer.android.com/develop/ui/compose/accessibility/api-defaults | 48 dp targets, semantics, clickable group ownership, custom-control responsibilities |
| Adaptive layouts | https://developer.android.com/develop/ui/compose/layouts/adaptive/get-started-with-adaptive-apps | Window-based adaptation, navigation changes, panes, continuity, external inputs |

The Android pages above were inspected when this skill was authored. They are not frozen specifications. Exact component dimensions, token names, supported SDK ranges, and release status must be rechecked when needed.

## Research procedure

1. Capture target OS/minimum OS, target SDK, framework and library versions, relevant window sizes, navigation modes, and deliverable level.
2. Use `web_search` to locate current first-party guidance; read exact pages with `web_extract` or another available read-only path.
3. If m3.material.io returns only a JavaScript shell, use the configured background-browser workflow when usable, or the corresponding official Android documentation. State which evidence was accessible. Do not treat a search snippet as a full guideline inspection.
4. Separate design guidance from runtime capability: inspect installed packages and framework docs before API recommendations.
5. Record URL, supported claim, applicability, and any discrepancy. Prefer current API documentation over historical code embedded in design articles.

## Decision record

- Product and approved design source:
- Android OS range and target SDK:
- Framework/library and version:
- Window/device/input scope:
- M3 baseline / selected Expressive features:
- Branded or dynamic colour policy:
- Source URL → supported decision:
- Runtime evidence / unknowns:

Never infer platform support from a sample's appearance or assume a newer Android OS requires all Expressive styling. Distinguish a user preference, Material recommendation, OS behaviour, and implementation limitation.
