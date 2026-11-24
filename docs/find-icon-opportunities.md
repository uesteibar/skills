# find-icon-opportunities

Decides where an interface needs icons, finds them, and decides per element whether the icon stands alone or sits next to text.

## When an agent uses it

While designing a screen (step 6 of `ui-design`), or when you ask it to audit the icons of an existing interface.

## How it works

0. Fix one icon set for the product: SF Symbols on Apple platforms, Material Symbols on Android, one open library (Lucide, Phosphor) on the web. One style, no emoji.
1. List every element that carries text and mark the candidates: repeated items in scanned lists, frequent actions with a strong convention, short space, kinds that must be told apart, metadata next to a value.
2. Find one icon per candidate in the chosen set, preferring the convention people already know, with one meaning per icon.
3. Decide icon only, icon and text, or text only, by how universal the meaning is, how often it is used and what a wrong guess costs. Destructive and external actions always keep a label.
4. Apply them: grid sizes, optical alignment, `currentColor`, touch targets, accessible names, tooltips on desktop only as a supplement.
5. Check the screen at real size and report a table: element, icon, decision, reason.

## Limits

No scripts. It does not draw new icons; when a set lacks one, it asks for one drawn on the same grid and style.
