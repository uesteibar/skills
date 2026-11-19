---
name: architecture-infographic
description: Explain architecture, data or user flows as a visual page.
metadata:
  author: uesteibar
---

# Visual Explainer

Turn "how does X work?" into one page people scan instead of read: a system's
architecture, how data moves and where it lands, or what a user goes through.
Pictures carry the meaning; text only labels them.

Use it when someone asks for an explanation, a diagram, "something visual", or
says an answer had too much text. For a quick fact, just answer in chat.

## Principles

- **Clear hierarchy.** Title, one-line lede, then a few big sections. The eye
  knows where to start and what matters most.
- **Little text.** Short labels, icons, status pills, arrows. If a sentence
  is needed, it belongs in the chat reply, not on the page.
- **Fit the shape to the subject.** Choose the form that matches how the
  thing actually works:
  - pipeline or request path: steps left to right, with a fan-out branch
  - layered system or deployment: stacked layers with their parts
  - interaction over time: a sequence or timeline, one lane per actor
  - user flow: a row of screens, or a journey with user and system lanes
  - lifecycle: states and the transitions between them
  - data: record cards with example rows, in write order
  - proposal: before/after, with the new parts marked
  Mix two or three when it helps; skip anything that adds no understanding.
- **Consistent visual language.** One colour per concept, kept everywhere it
  appears.
- **Proposed vs existing.** When a change is on the table, make new parts
  look different (the template uses dashed accent borders) so nobody confuses
  the plan with what runs today.
- **Real sources.** Build from code, schemas, docs or the actual product.
  Names, statuses and numbers on the page match the source; example values
  are plausible and read as examples.
- **Optional scenario switch.** When the interesting part is how the picture
  changes between cases (one item vs many, happy path vs failure), a switch
  that redraws the same page works well.

## Procedure

1. **Understand it** from the source until you can sketch it on a napkin:
   the actors, the steps, what is stored, what can go differently.
2. **Choose the shape** from the list above and pick the 2–4 sections that
   carry the explanation.
3. **Build** in the session scratch directory. `templates/infographic.html`
   is a starting point: copy it and edit its `DOC` object (sections: `steps`,
   `journey`, `screens`, `layers`, `branch`, `records`, `points`, `changes`;
   all optional, any order; the header comment lists the options). Building
   from scratch is fine when another form fits better, e.g. a state machine.
4. **Render and check.** `terminal(command="bash <skill_dir>/scripts/render.sh <file> [scenarioId ...]")`
   writes light and dark PNGs per scenario (`#<scenarioId>` preselects one).
   Look at each with `vision_analyze` for overlaps, cut-off text and empty
   areas; zoom with `region` on dense diagrams. Fix and re-render.
   Pages built from scratch can set `<html data-height>` or `HEIGHT=` for a
   full-height capture.
5. **Share.** `terminal(command="open <file>")`, then reply with the path,
   one screenshot via `MEDIA:`, and a few lines on how to read it.
   Iterate on feedback in the same file so a reload shows the update.

The page often describes internal systems; keep it in the scratch directory
unless the user wants it elsewhere.
