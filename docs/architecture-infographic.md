# architecture-infographic

Turns "how does X work?" into one visual page that people scan instead of read: an architecture, a data flow, or a user journey. Pictures carry the meaning and text only labels them.

## When an agent uses it

- Someone asks for an explanation, a diagram, or "something visual".
- A previous answer had too much text.

For a quick fact, the agent answers in chat instead.

## How it works

1. Read the real source (code, schemas, docs) until the system can be sketched on a napkin.
2. Pick the shape that fits: pipeline, layered system, sequence over time, user flow, lifecycle, record cards, or before/after for a proposal.
3. Copy `templates/infographic.html` and edit its `DOC` object. Sections are optional and can be in any order: `steps`, `journey`, `screens`, `layers`, `branch`, `records`, `points`, `changes`.
4. Render with `scripts/render.sh <file> [scenarioId ...]`. It writes a light and a dark PNG for each scenario. The agent inspects each image for overlaps and cut-off text, then fixes and re-renders.
5. Share the file path and one screenshot, with a few lines on how to read it.

New or proposed parts get a dashed accent border so they are not mistaken for what runs today. A scenario switch can redraw the same page for different cases (one item or many, success or failure).

## What you need

- Chrome or Chromium for `render.sh`. Set `CHROME_BIN` if it is not on the usual path. `WIDTH` and `HEIGHT` are optional.
- An agent that can look at images. The skill text names Hermes tools (`vision_analyze`, `MEDIA:`) and the macOS `open` command; adapt them to your agent.
- The template loads nothing from the network.

## Limits

The page often describes internal systems, so the skill keeps it in the scratch directory unless you ask for another place.
