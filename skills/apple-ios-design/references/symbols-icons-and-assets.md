# Symbols, Icons, and Assets

## SF Symbols

Prefer SF Symbols for standard actions and platform concepts.

- Match symbol weight and scale to adjacent text.
- Use the symbol whose established meaning matches the action; visual similarity is not enough.
- Provide an accessibility label for every icon-only control.
- Avoid redundant labels when the visible adjacent text already supplies the accessible name.
- Respect automatic right-to-left adaptation and localized symbol variants.
- Use monochrome, hierarchical, palette, multicolor, or gradient rendering deliberately.
- Animate symbols only when motion clarifies state, progress, causality, or feedback.
- Test availability against the minimum OS and provide fallbacks for newer symbols or effects.

Current SF Symbols includes thousands of symbols, multiple weights and scales, variable rendering, and expressive effects such as Draw, Bounce, Wiggle, Rotate, Breathe, and Magic Replace. The exact catalog and OS availability are version-sensitive; consult the current SF Symbols app.

## Custom interface icons

Use simple geometry, consistent optical weight, clear alignment, and adequate negative space. Custom icons should feel coherent with the symbol set without imitating a symbol that already exists. Test at actual display size and in all appearances.

Avoid text inside small icons unless it is essential and localizable. Avoid photos or detailed illustrations for compact interface glyphs.

## App icons

The app icon is a brand identifier, not a miniature screenshot.

- Start with one simple, memorable concept.
- Use a minimal number of clear, filled shapes.
- Keep the primary form centered and optically balanced.
- Provide square, unmasked source layers; the system applies the final platform mask.
- Prefer vectors or lossless assets and clearly defined layer edges.
- Do not pre-bake system shadows, blur, highlights, refraction, bevels, or rounded corners.
- Avoid replicating Apple hardware, standard controls, or app screenshots.
- Include text only when essential to the brand; it does not localize or scale accessibly.
- Keep the central identity consistent across platforms and appearance variants.

For current iOS, iPadOS, macOS, and watchOS production, build a layered 1024 × 1024 source design and use Icon Composer. Define foreground and background layers, inspect opacity and grouping, and preview Default, Dark, Clear/Mono, and tinted appearances as supported. Let the system generate or enhance dynamic lighting effects.

Alternate app icons must remain recognizably related to the app and need the required appearance variants. All variants are subject to App Review.

## Images and illustrations

- Use aspect-fit or aspect-fill intentionally; never distort content.
- Preserve focal content around cropping, safe areas, and variable window shapes.
- Supply accessible descriptions for meaningful images and hide decorative images from assistive technology.
- Test light/dark variants where an asset contains its own background or contrast.
- Prefer vectors for scalable line art and PNG for lossless raster artwork; use appropriate photographic formats for photos.

## Launch experience

Use the platform launch screen mechanism. It should appear immediately, match the first app frame, and avoid implying that the app is already interactive.

- Do not build a timed branding splash, advertisement, or progress simulation.
- Minimize visual movement between launch screen and first rendered screen.
- Keep the launch composition simple and adaptive.
- Load real state as quickly as possible and show honest loading feedback only when needed after launch.

## Official resources

Do not bundle Apple UI kits or product bezels into this skill. Link to Apple Design Resources, the current official Figma/Sketch kit, SF Symbols, and Icon Composer. Their content and license can change.
