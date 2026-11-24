---
name: find-icon-opportunities
description: Use when deciding where a UI needs icons, and which ones.
metadata:
  author: uesteibar
---

# Find icon opportunities

An icon earns its place when it lets people find, recognise or tell apart something faster than a word. It fails when it needs a word to be understood, or when it is decoration. This skill finds the first kind, picks the icon, and decides per element whether the icon stands alone or sits next to text.

Use it while designing a screen (step 6 of `ui-design`) and when auditing an existing one. Work through steps 0 to 4 in order, then check and report the result as a table (step 5).

## 0. Choose one icon set

Before you look at elements, fix the set the whole product uses:

- **Platform first.** iOS and iPadOS: SF Symbols. Android: Material Symbols. Web or cross-platform: one open library, for example Lucide or Phosphor.
- **One set, one style.** One stroke width (or one weight), one corner style, one grid size. Do not mix libraries; a missing icon is drawn on the same grid in the same style, not taken from another set.
- **Filled versus outline has one meaning**, if it has any (for example filled = selected tab, outline = not selected). Never mix them at random.
- Never use emoji or Unicode characters (✓ ★ →) as icons. They render differently on each system and do not take the text colour.

## 1. Find the elements an icon could explain better

List every element that carries text: buttons, navigation items, tabs, menu items, toolbar actions, labels, status words, metadata (time, attachment, location, owner), table headers, empty states, toggles.

Mark an element as a **candidate** when one of these is true:

- It repeats in a list people scan (status, type, attachment, owner, priority): an icon lets the eye find it without reading every row.
- It is a frequent action with a strong convention (search, close, back, more, share, add, settings, reply, archive).
- Space is short and the element appears many times (row actions, toolbars, a phone tab bar).
- Things of different kinds must be told apart at a glance (an email reply, a calendar action, a task, a question).
- It is metadata next to a value (a paperclip next to "1 file", a clock next to "11:43").

Mark it as **not a candidate** when:

- The concept is abstract or specific to this product and no picture exists that most people would name the same way ("Request changes", "Routing rule", "Grey zone").
- It is a heading, a sentence or a body of text: an icon there is decoration.
- The element is already clear and the icon would only add noise (most form labels).

## 2. Find one icon for each candidate

- Search the chosen set by the concept and its synonyms ("archive", "box", "file away"). Useful search pages: lucide.dev/icons, phosphoricons.com, fonts.google.com/icons, the SF Symbols app, and the Iconify search API (`https://api.iconify.design/search?query=archive&prefix=lucide`) to compare many sets at once.
- **Convention beats cleverness.** Check what the products your users already know use for the same thing (mail clients for archive and reply, iOS for share). A familiar icon with a weaker metaphor wins over a clever new one.
- **One meaning per icon, one icon per meaning.** Keep a list as you go. If the same icon would mean two things, or two icons would mean the same thing, change one.
- Look at the icon at the size it will really have (16 or 20 px on desktop, 24 px on a phone tab bar). Detailed icons become unreadable small: choose the simpler one.

## 3. Decide: icon only, icon and text, or text only

Ask, per element: would four out of five people who use this product name the icon the same way, without help? Then weigh how often it is used and what a wrong guess costs.

| Decision | When | Examples |
| --- | --- | --- |
| **Icon only** | Universal convention, used often, a wrong guess is cheap and easy to undo, or repeated per row where a header or the first use teaches it. | Search, close, back, more, add, settings, play, a paperclip for an attachment, a lock for private. |
| **Icon and text** | Primary actions; navigation (tab bars and sidebars, where the label helps people learn the place); actions specific to the product; rare actions; actions that are hard to undo or affect other people (send, delete, decline). | "Send", "Approve", "Archive", "Rules", "Decline and archive". |
| **Text only** | No icon that most people would name the same way, or an icon that would itself need an explanation; editorial contexts where the text is the design. | "Request changes", "Grey zone", "Ask me". |

Two rules that override the table:

- **Never let an icon carry an uncommon meaning alone.** A row of icon-only status beads or event marks that people must decode is unreadable. Pair it with a word, or drop it.
- **The more it costs to get it wrong, the more text.** Destructive or external actions (send, pay, delete, decline someone) always have a label.

## 4. Apply the icons

- **Size and alignment.** Use the set's grid (16, 20 or 24 px). Next to text, centre the icon optically on the cap height of the label, not on the line box; use a gap of 6–8 px. Keep the same size for the same role across the product.
- **Colour.** Draw with `currentColor` (or the platform's equivalent), so the icon follows the text colour and its states. Do not give icons their own colours unless the colour is the meaning (one status colour, one agent colour).
- **Targets.** An icon-only control has a touch target of at least 44 × 44 pt on phones (48 dp on Android) and 28–32 px on desktop, even if the glyph is 16 px.
- **Accessibility.** An icon-only control has an accessible name (`aria-label`, `accessibilityLabel`). A decorative icon next to a label is hidden from assistive technology (`aria-hidden="true"`). On desktop, an icon-only control shows a tooltip with its name and its keyboard shortcut. On touch, where there is no hover, nothing important may live only in a tooltip.
- **States.** Hover, pressed, selected and disabled change the colour or the fill of the whole control, consistently. Selection is never shown by the icon alone; add a background, a weight change or a label.

## 5. Check and report

- Look at the screen at real size (screenshot) and squint: the icons should guide the eye to actions and types, not add a second texture. If everything has an icon, nothing stands out; remove the weakest.
- Report the result as a table with one row per candidate: element, icon (set and name), decision (icon only / icon and text / text only) and the reason in a few words. List the elements you decided against, with the reason.

## Pitfalls

- **Icon soup.** Adding an icon to every label, heading and menu item. Most text does not need one.
- **Decoration.** An icon in front of a section title or a card heading that tells nothing the words do not.
- **Mixed sets.** One icon from another library looks wrong at once (different stroke, different corners).
- **Invented metaphors** for product-specific concepts. A word is clearer than an icon nobody can name.
- **Meaning only in the icon on touch.** Long-press tooltips are not discoverable; on phones, uncommon actions need a label.
