# skills

Agent skills I use day to day with Pi, Claude, Codex and Hermes. Each skill is
a folder in `skills/` with a `SKILL.md`. Three skills assume Hermes by default
(`pr-shepherd`, `pi-shepherd` and `skill-housekeeping`); the others work with
any agent that reads the Agent Skills format. Read a skill before you use it.

## Skills

Each skill has a page in `docs/` that explains what it does, when an agent
loads it, how it works, what it needs, and its limits. Read a page before you
install the skill.

### Workflow and review

| Skill | What it does |
| --- | --- |
| [`pr-creation`](docs/pr-creation.md) | Write and update GitHub PRs that a reviewer grasps in a minute. |
| [`pr-shepherd`](docs/pr-shepherd.md) | Watch an open PR through CI and review, and route each event. |
| [`pi-shepherd`](docs/pi-shepherd.md) | Watch a Pi agent in a Rex block, and route each event. |
| [`review-outline`](docs/review-outline.md) | Summarise a PR or diff as an outline a reviewer can read instead of the code. |
| [`verification-evidence`](docs/verification-evidence.md) | Capture proof while verifying a change, so the PR can report it without reruns. |
| [`test-driven-development`](docs/test-driven-development.md) | Test-first workflow with focused red-green cycles. |
| [`skill-housekeeping`](docs/skill-housekeeping.md) | Prune or split a skill without changing its behaviour. |

### Design

| Skill | What it does |
| --- | --- |
| [`ui-design`](docs/ui-design.md) | Short, ordered process for any interface design task. |
| [`landing-design`](docs/landing-design.md) | Design a product landing page that tells a convincing story, from references to verified result. |
| [`find-icon-opportunities`](docs/find-icon-opportunities.md) | Decide where a UI needs icons, which ones, and whether they need text. |
| [`apple-ios-design`](docs/apple-ios-design.md) | Design and audit iPhone and iPad interfaces. |
| [`material-android-design`](docs/material-android-design.md) | Design and audit Android interfaces with Material 3. |
| [`mobile-product-design`](docs/mobile-product-design.md) | Coordinate one product's design across iOS and Android. |
| [`architecture-infographic`](docs/architecture-infographic.md) | Turn an architecture, data flow or user flow into one visual page. |

### Other

| Skill | What it does |
| --- | --- |
| [`posthog-product-analytics`](docs/posthog-product-analytics.md) | Build and verify PostHog dashboards; check connector access. |
| [`concise-formatting`](docs/concise-formatting.md) | A reply style: short answers, real links, sparing emphasis. |

## How skills work

An agent lists the name and description of every installed skill in its
prompt. It reads the full `SKILL.md` only when a task matches, and it reads
files in `references/` or runs files in `scripts/` only when the skill says so.
Install only the skills you want, because every installed skill adds its
description to the prompt.

## Requirements

- **`gh` (GitHub CLI), authenticated:** `pr-creation`, `pr-shepherd`, `review-outline`.
- **Python 3 (standard library only):** the scripts of `pr-shepherd`, `pi-shepherd` and `skill-housekeeping`.
- **Rex CLI:** `pi-shepherd`.
- **Chrome or Chromium:** `architecture-infographic` (rendering).
- **PostHog connector:** `posthog-product-analytics`.
- **Hermes:** `pr-shepherd`, `pi-shepherd` and `skill-housekeeping` keep state or find skill folders under `$HERMES_HOME` by default. Each has an environment variable or option to change that; see its page.

Skills that call each other: `pr-creation` uses `review-outline` and the records from `verification-evidence`; `mobile-product-design` coordinates `apple-ios-design` and `material-android-design`. `landing-design` uses `ui-design`, `find-icon-opportunities` and `verification-evidence`, plus Emil Kowalski's animation skills from [emilkowalski/skills](https://github.com/emilkowalski/skills) (not in this repository).

## Side effects to know about

- `pr-shepherd` tells the agent to post replies to PR review comments with `gh`, which posts under **your own GitHub account**, and to rerun failed CI jobs. It never resolves threads, merges or marks a PR ready. Read `docs/pr-shepherd.md` before you install it.
- `pr-creation` creates or edits PRs with `gh`.

## Install

Two options. Skills run with your agent's permissions: read a skill before you
install it.

1. **`npx skills add`** (the skills.sh CLI). It creates one copy in `~/.agents/skills` and links
   Claude to it:

   ```bash
   npx skills add uesteibar/skills --skill pr-creation -g -a claude-code -a pi -a codex
   npx skills add uesteibar/skills --list
   ```

2. **`./install`** (this repo's script). It links each skill into
   `~/.agents/skills` (Pi and Codex) and `~/.claude/skills` (Claude):

   ```bash
   ./install --dry-run              # preview every link
   ./install pr-creation            # one skill, both agents
   ./install --uninstall            # remove what this repo installed
   ```

   If a target directory is a symlink to another repo, `./install` refuses to
   write into it (exit 3). If only a parent of the target is a symlink (for
   example `~/.claude` linked from a dotfiles repo), it continues and prints a
   `note` line on stderr with the resolved destination.

   `./install` needs a `readlink` that supports `-f` (GNU coreutils; recent
   macOS versions include it; otherwise install GNU coreutils).

## License

MIT. See `LICENSE`. One file is adapted from another project; see `THIRD_PARTY_NOTICES.md`.
