# Theming, accessibility, and motion

## Theme without losing identity

1. Name the identity-bearing elements: imagery, voice, domain visualisation, custom controls, illustration, accent policy.
2. Map those into Material colour, type, and shape roles; do not force shared raw values with iOS.
3. Use correct foreground pairs such as primary/onPrimary and surface/onSurface. Verify resolved contrast in real component states, not only in the palette.
4. Define light and dark schemes. If supporting dynamic colour, test representative generated palettes and a branded fallback where dynamic colour is unavailable.
5. Keep meaning independent of colour: ratings, errors, progress and selection also need text, shape or another accessible cue.
6. Choose a small useful type hierarchy. Expressive display text must not compete with instructions. Scale reading text and reflow layouts rather than clamping or shrinking it.
7. Use shape and tonal differences to communicate grouping and emphasis. Repeated rounded cards and borders are not mandatory Material styling.

Dynamic colour is supported on Android 12 and above in the cited Compose guidance. Treat adoption as an explicit product choice. Verify target framework support; do not assume a boolean theme flag provides the complete policy.

Read the project's approved visual-identity policy before choosing surfaces, imagery, accents, or custom controls. Map those choices into Android semantic colour roles, not Apple API tokens. Keep product-specific palettes and feature rules in project-owned documents rather than this generic skill. Branded colour and wallpaper-derived dynamic colour are separate choices; neither a fixed palette nor dynamic colour is a universal Material requirement.

## Accessibility and input checklist

- Touch targets at least 48 × 48 dp. A small icon is acceptable only if its actual target is adequate and does not overlap adjacent targets.
- Reading text uses scalable units/appropriate framework support; verify large text and display scaling with real long content.
- Normal small text targets at least 4.5:1 contrast; large text at least 3:1; meaningful non-text UI boundaries/indicators at least 3:1 where applicable. Do not equate all decorative marks or disabled controls with required interactive contrast.
- TalkBack receives logical grouping, names, roles, selected/checked/expanded state, value and bounds where applicable, and meaningful actions.
- Do not announce the same label from both a row and its decorative child icon. Hide decorative illustration from accessibility traversal.
- Custom dials need accessible adjustment actions and a usable alternative where gesture precision would exclude users.
- Announce important completion/error states without repeated disruptive chatter. Preserve/recover focus after sheets, pickers and navigation.
- Do not make sound, haptics, colour, gesture, or animation the only way to understand a state or complete an action.
- Test keyboard focus and pointer interaction for in-scope large-window use.

## Motion policy

- Start with platform/library motion; verify installed support before inventing animation code.
- Use motion for continuity, hierarchy, direct manipulation and clear state changes. Avoid perpetual decorative movement.
- Do not make application state depend on whether an animation finishes.
- Respect system reduced/disabled animation settings through the actual stack. Provide immediate stable end states.
- For predictive Back, preserve cancellability and correct destination semantics; appearance alone does not prove integration.
- Evaluate Expressive motion selectively against task clarity, interruption, accessibility, and device performance.

## Verification evidence

For design artifacts: inspect screenshots, resolved token contrast, text bounds, target frames, scroll/inset specification, and declared accessibility semantics. For implementation: additionally exercise real controls, TalkBack, text/display scaling, navigation modes, appearance modes, and interruption. Label untested conditions explicitly.
