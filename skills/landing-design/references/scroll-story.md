# Scroll-told stories

Read this when the landing tells its story by scroll (a pinned stage that changes as the visitor scrolls). Skip it for a plain page.

## Structure

- One tall section (`height: calc(100svh * N)`, N about 5 to 7 screens) holds a stage with `position: sticky; top: 0; height: 100svh; overflow: hidden`.
- Compute progress in a scroll handler throttled with `requestAnimationFrame`: `p = clamp(-rect.top / (section.offsetHeight - innerHeight), 0, 1)`. Native sticky is enough; you do not need a pinning library.
- Split the story into beats. Give each beat named start and end constants (`FALL_START`, `SORT_END`), not numbers inline, so beats can be re-timed in one place.
- Inside a beat, map progress with a segment function (`seg(p, a, b)` returns 0 to 1 between `a` and `b`) and an easing curve. Write styles only for the element that the beat is about.
- Because every value comes from `p`, scrolling up plays the story backwards without extra code. Do not use one-shot triggers (`IntersectionObserver` that adds a class once) for story beats.

## Layout

- Position every animated element absolutely inside the stage, and give each one a CSS fallback position that is its final readable frame, for the page without JavaScript.
- Measure positions in a `layout()` function that runs after `document.fonts.ready` and on resize (debounced, about 150 ms). A font swap changes heights.
- Keep content off the viewport edges: things that pile up or sit at the bottom need about 40 to 64 px of air below them (more on a phone with a bottom bar), and copy, objects and their labels should read as one group, not drift apart with a void between them.
- Objects that enter must not cross text: start them below the copy, or fade them in under it.
- When part of a word changes (one syllable rolls into another), animate the container width between the measured widths of both parts; a container that keeps the wider width leaves a gap.
- Size a large one-line sentence from its widest variant (measure every variant, or clamp the font size from the viewport width). Sizing from the first variant clips longer ones on a phone.
- Put `overflow-x: clip` on `html` as well as `body`: transforms near the edge can still widen the document when only `body` clips.
- When code scrolls to a section (a scroll catch, an anchor link), offset it by the height of a fixed header, or the header covers the section title.

## Reduced motion

With `prefers-reduced-motion: reduce`, collapse the tall section to one screen and show the key frames of the story as still content. Do not scrub.
