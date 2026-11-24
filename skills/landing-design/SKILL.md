---
name: landing-design
description: Use when designing or redesigning a product landing page.
metadata:
  author: uesteibar
---

# Landing design

A landing page has one job: tell a convincing story that makes the product's purpose and its key ideas clear, so the right visitor acts (signs up, joins a waitlist, tries it). Every section, word and animation serves that story. A page that looks good but leaves the visitor unsure what the product does has failed.

Work through the steps in order. Steps 1 and 2 come before any visual design.

## 1. Get quality references, first and every time something new starts

References decide the level of the result more than any other input. Collect them at the start, and again each time the user wants to change a part or add something new (a section, an effect, an illustration, a brand element).

1. **Ask the user for references.** Ask for landing pages, sites or details they consider high quality, and what they like in each one. A link with one line ("the way this hero sets the product name huge") is worth more than an adjective.
2. **Search yourself, with every means you have.** Start with Awwwards (Sites of the Day, the category and technique collections), then other curated showcases (Godly, Land-book, Lapa Ninja, SiteInspire), the landing pages of direct competitors and of the best products in nearby categories, designers' posts that show motion, and any reference library the user has connected. Read each reference live (scroll it, look at it on a phone), not only its screenshot.
3. **Write down what you take from each one:** one line per link (the structure, a motion principle, a type treatment, how it explains the product). Take the idea, never the markup or assets.
4. **Give workers the links, not descriptions.** A worker who opens the reference understands it better than one who reads your summary of it.

`ui-design` step 2 has more on where to look.

## 2. Agree the story before the design

1. **Write the product truth** and get the user's agreement: what the product is, who it is for, the problem it solves, how it works, what makes it different. Keep it short and concrete. The landing must never contradict it.
2. **Write an outline of sections.** Give each section one job: convince (why care) or explain (how it works). Order them as a story: the problem the visitor knows, the turn the product brings, how it works, proof the visitor can try or see, how to start. Get the outline approved before you design.
3. **Explain each key idea once.** Show it with one concrete, real example of the product, not an abstraction. When several examples show the same mechanism, give them the same anatomy so the visitor learns it once. When two sections explain the same thing, merge them.
4. **Make every change legible.** When the page shows something turning into something else (a request into a result), the visitor must be able to follow it. A clever transition that does not read fails.
5. **Write concrete, calm copy.** Agree a list of forbidden phrases with the user (buzzwords, empty reassurance, "AI-powered", "seamless"). No fake social proof on a product that has no users yet.

## 3. Run the design in rounds

- **Open first.** Round 1 explores several clearly different directions. Show only the key sections of each, so the comparison is fast.
- **Then narrow.** When both the brand and the page structure are still open, show a few brands across the same few structures, so the user can judge brand and structure apart. Then build two or three full proposals on one brand.
- **Write one brief per round.** Put the user's feedback in it as binding, quoted in their words and split into what they liked, what they disliked and what is new. Each new round reads the briefs before it.
- **Build the final on the liked base.** Fork the proposal the user liked most and port the parts they liked from the others into it. Keep every earlier round untouched as history, so the user can compare.
- **One worker per proposal.** Give each its own folder and shared components (a small kit) so proposals differ in what matters and stay consistent in the rest. Name who owns which files.
- **Verify before you show.** The person who coordinates opens the live page on desktop and on a phone and checks it (see `references/verification.md`). A worker's report is not proof.

## 4. Motion

Load Emil Kowalski's animation skills (https://github.com/emilkowalski/skills, MIT) when you design, build or review motion: `animate` to build an animation, `find-animation-opportunities` to decide where motion helps, `animation-vocabulary` to name what the user describes, `animation-performance` to keep within the frame budget, `improve-animations` and `review-animations` to audit. They are not in this repository; install them from that repository.

Rules that hold on any landing:

- Motion serves the story. Move one subject at a time, and never let a moving element cover the subject of that moment.
- Animate only `transform` and `opacity`. Elements that do not change do not move.
- Everything tied to scroll follows the scroll position and rewinds when the visitor scrolls back up. Never fire a scroll animation once and leave it.
- Hover effects never change the size of the element or shift the layout.
- Without JavaScript, every element shows its final, readable state. With `prefers-reduced-motion`, show still frames.
- When the page tells its story with scroll, read `references/scroll-story.md`.

## 5. Use the other skills

- `ui-design`: the visual process and the brand system (type, colour, components). Run it inside step 3.
- `find-icon-opportunities`: where the page needs icons, which ones, and whether they need text. Use one icon set, and real logos for the products and tools the page names.
- `verification-evidence`: capture proof during the checks, so the report does not need reruns.

## 6. Design the phone page

Design the phone version as a phone page, not a shrunk desktop page. Every effect must work on the phone: simplify the layout, never drop the effect. Taps replace hovers.

## 7. Check before you call it done

Run the checks in `references/verification.md` at desktop (1440 px and 1280 px wide) and phone (390 px, touch) sizes, and report the numbers you measured, not impressions.
