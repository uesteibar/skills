# Apple UI Design Specification

## Context

- Product/feature:
- User and job to be done:
- Platform and minimum OS:
- Device classes/orientations:
- Implementation stack:
- Entry points and exit paths:
- Privacy/safety constraints:

## Information architecture

Describe primary destinations, hierarchy, selected-state persistence, deep links, and compact/regular adaptation.

## Screen specification

### Screen or state name

- **Purpose:**
- **Entry:**
- **Primary content:**
- **Primary action:**
- **Secondary actions:**
- **Navigation/chrome:**
- **System components:**
- **Layout and safe areas:**
- **Scrolling/keyboard behavior:**
- **Loading/empty/offline/error/success:**
- **Destructive and recovery behavior:**
- **iPad/window adaptation:**
- **Accessibility:**
- **Motion and reduced-motion equivalent:**
- **Analytics or telemetry, if appropriate:**
- **Acceptance criteria:**

Repeat for each meaningful screen and transient state.

## Visual tokens

- Semantic text styles:
- Semantic colors and appearances:
- Tint usage:
- Materials and scroll-edge effects:
- Spacing and shape rules:
- SF Symbols/custom icons and fallbacks:
- Image behavior:

Do not hard-code current system-component geometry here unless verified in the official UI kit.

## Interaction model

Specify press feedback, gestures, thresholds, interruption, velocity handoff, source anchoring, haptics, keyboard/pointer behavior, and system-gesture coexistence.

## Accessibility matrix

| Requirement | Expected behavior | Verification |
| --- | --- | --- |
| VoiceOver |  |  |
| Dynamic Type |  |  |
| Touch targets |  |  |
| Light/Dark |  |  |
| Increased contrast |  |  |
| Reduce Motion |  |  |
| Reduce Transparency |  |  |
| Keyboard/pointer |  |  |
| Localization/RTL |  |  |

## Current-version dependencies

List APIs, symbols, materials, or components tied to a particular OS. Define fallbacks for the minimum supported version.

## Validation plan

- Representative devices and window sizes:
- Real-content cases:
- Accessibility configurations:
- Performance-sensitive interactions:
- User tests or prototype questions:
- UI-kit/HIG measurements requiring confirmation:
