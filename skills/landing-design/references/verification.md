# Verifying a landing page

Check the live page in a real browser, driven by code (for example the Chrome DevTools Protocol), and measure. Screenshots show what is wrong; numbers prove it is right.

## Sizes

- Desktop 1440 × 900 first, then 1280 × 800.
- Phone 390 × 844 with mobile and touch emulation turned on after you navigate, then reload. Drive swipes with touch events, not mouse events.
- Reduced motion: emulate `prefers-reduced-motion: reduce`, reload, and check the still frames.
- No JavaScript: every section must still read.

## Every load

- Turn off the cache, so you test the files you just changed. A fix that does not show is usually a cached file.
- Install an error collector before the page loads (an init script that records `error` and `unhandledrejection`). If the collector returns nothing at all (null, not an empty list), it is not installed on this page: install it again and reload. Do not report "no errors" from a collector that did not run.
- Scroll to the end before you read the resource list, so lazy assets load.

## Measure

- **Errors:** zero console errors.
- **Broken assets:** list every resource whose response status is 400 or more (`performance.getEntriesByType('resource')`). Fonts, logos and removed scripts fail silently otherwise. After you remove a component, check that nothing still requests its files.
- **Horizontal overflow:** `document.documentElement.scrollWidth` equals the viewport width while scrolling and again after the interactive parts are used (a swipe, a flight, an answer), because transient transforms cause overflow that a scroll-only pass misses. To find the cause, list elements whose right edge passes the viewport.
- **Covering:** for each beat where one element must stay visible, sample many scroll positions and report the largest overlap between it and the elements that move past it. The target is 0 px.
- **Air and clipping:** at each key beat, `innerHeight - max(bottom)` of the bottom content is at least about 40 px. Titles and cards stay inside the viewport on the phone (`left ≥ 0`, `right ≤ innerWidth`); a centred card wider than the viewport clips its text without causing overflow.
- **Text over text:** moving objects never sit on visible copy. Compute visibility through the parents' opacity, not only the element's own.

## Sampling

- Sample scroll positions as fractions of the story section, not of the whole page, so the story gets most of the samples. Then add the interactive part, the section after it and the close.
- When a beat reveals its parts in steps (source, then link, then result), take three or more samples inside that beat before you report a part as missing.
- Scroll down and back up through every scroll-tied animation and check that it rewinds.

## Screenshots

Capture full viewports and tile them into one contact sheet per page (12 to 16 frames) before you look at them. Crop details from the full capture. Look at every frame yourself; the measurements above tell you where to look.
