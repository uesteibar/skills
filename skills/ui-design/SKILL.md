---
name: ui-design
description: Apply a clear and structured design process to carry out a design task
metadata:
  author: uesteibar
---

# UI Design

When a design task is requested, work through these steps in order. Steps 1 to 3 come before you draw anything.

### 1. Reason about the product before you look at pixels

Write down, in a few lines, what the product is, who uses it, in which moments (desktop at a desk, phone between meetings) and what they want from this screen. Then list the affordances and signifiers the screen needs: what can be acted on, and how the user can tell before they read. The shape of an element should tell its kind (a reply looks like a message, an action shows its fields, a question offers its answers as buttons).

Write copy as a good assistant would: concrete and calm. Do not write defensive or reassuring filler ("Nothing is sent until you approve", "You're always in control", "AI-powered", "seamless"). If the interface needs a sentence to promise it is safe, fix the interaction instead.

### 2. Gather references: a saved library first, then the web

- **Saved library.** If a UI reference library is connected (for example the `uirefs` MCP server), search it first with the `ui-reference-search` skill: 1 to 3 concept queries ("approval card", "timeline ruler"), then open the one or two useful hits. An empty result is fine.
- **The web, beyond the obvious.** Do not stop at the library. Look for:
  - direct competitors and similar products;
  - products from other niches that share a problem with this one (an air-traffic flight strip for handing work between people, a receipt for a record of what was done);
  - award and showcase sites (Awwwards, Godly, 60fps.design, Mobbin) for craft and motion;
  - designers' posts on X (`site:x.com <pattern> interaction`, and curated archives of them) for the best motion and interaction work, which is rarely in libraries.
- Read each reference yourself (the live page, the frames of a video), not only a search snippet. Take the idea, the structure or the motion principle, never the markup. Name each reference with its link or id in your notes, with one line on what you took from it.

### 3. Choose the brand system on purpose

- **Typeface.** Choose the font as part of the identity, with a reason: what the product is and how it should feel (an editorial serif for correspondence, a precise grotesk with a mono for an instrument). Check that it has the weights, tabular numerals and language coverage you need. Pair at most two families. Do not default to the system font or to whatever the last project used.
- **Colour.** Backgrounds are white, or a real colour used with intent. Never use beige, cream, paper or warm-grey backgrounds and surfaces: they are the signature of generic AI-made interfaces. Secondary surfaces and hairlines are neutral greys. Use one accent, for one meaning.
- Write each reason next to its choice ("decision → reason"), so every later screen can follow it.

### 4. Stay within platform conventions and best practices

When designing a component or interface, stay within the platform's conventions and best practices. You must follow the principle of least astonishment.

Mobile platforms have specific design guidelines and best practices that should be followed. See the mobile-product-design skill for platform-specific design guidelines.

### 5. Build reusable components

When designing an interface, build reusable components that can be used across the platform. If there is already a component that can be used, reuse it instead of creating a new one.

### 6. Find the icon opportunities

Run the `find-icon-opportunities` skill: list the elements that an icon would explain better, find one icon for each in one library, decide per element between icon only and icon with text, then apply them. Do not put an icon on everything, and do not let an icon carry an uncommon meaning without text.

### 7. Use consistent design language

When designing an interface, use consistent design language across the platform. This includes using the same colors, fonts, and iconography.

### 8. Keep settings compact and contextual

When a control applies to one item, place it beside that item's label and related path or value in the existing row; do not add duplicate per-item rows just to hold the control. Reuse the existing row component, preserve accessibility, and avoid extra headings or help text when the visible label and control already explain the relationship.
