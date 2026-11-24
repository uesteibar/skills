# landing-design

Designs or redesigns a product landing page so it tells a convincing story and makes the product's purpose and key ideas clear.

## When an agent uses it

When you ask it to design, redesign or review a landing page for a product.

## How it works

1. Collects quality references: asks you for pages you like and why, searches showcases (Awwwards first, then other curated galleries, competitors and nearby products) and reads each one live. It does this again whenever you want to change or add something.
2. Agrees the story before any design: the product truth, an outline where each section has one job, each key idea explained once with a real example, and calm copy with a list of forbidden phrases.
3. Runs the design in rounds: several directions first, then fewer, then a final built on the proposal you liked, with your feedback written into a brief for each round and earlier rounds kept as history.
4. Applies motion rules that hold on any landing (one subject at a time, `transform` and `opacity` only, scroll-tied animation that rewinds, readable without JavaScript, still frames for reduced motion), using Emil Kowalski's animation skills.
5. Uses `ui-design`, `find-icon-opportunities` and `verification-evidence` along the way, and designs the phone page as a phone page.
6. Checks the live page at 1440, 1280 and 390 px (touch) and reports measured numbers: errors, broken assets, overflow, overlaps, clipping.

`references/scroll-story.md` covers pages that tell their story by scroll; `references/verification.md` lists the checks.

## What it needs

- A browser the agent can drive (for example through the Chrome DevTools Protocol) for the checks.
- Web access for references.
- Optional: Emil Kowalski's animation skills from https://github.com/emilkowalski/skills (not in this repository), and a connected UI reference library.

## Limits

No scripts. It does not host or deploy the page, and it does not prescribe a visual style: the brand comes from the references and the user's choices.
