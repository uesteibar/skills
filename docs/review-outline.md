# review-outline

Turns a change set (a PR, a branch or a local diff) into a short outline that a reviewer can read instead of the code. Every claim comes from the diff, and there is no code in the outline. It is not a code review: it hunts no bugs and gives no verdict.

## When an agent uses it

- You ask for an outline, overview, summary or walkthrough of a PR, branch or diff, or ask "what does this PR change?".
- A coding agent opens or updates a PR and adds the outline to the PR body.

## Modes

- **Chat** (default): Markdown in the reply, plus the same file in the scratch directory.
- **PR mode**: a collapsed `<details>` block in the PR body, in the repository's PR language.

## How it works

1. Resolve the exact change set (against the fetched base branch, with a three-dot diff) and check the file list against `gh` or `git diff --stat`.
2. Read the intent from the PR body, linked ticket and commits. If none is given, it writes `Intent: not stated` and never invents one.
3. Build a file ledger: every changed file in one class (behaviour, refactor, mechanical, generated, tests, docs and config).
4. Group the files into cohorts in dependency order: data, domain logic, interfaces, UI, config, tests.
5. Fill the sections with probes (modules, data and migrations, functional and architecture changes, performance, security, tests). An empty section stays and says what was checked.
6. Draw the flows, map tests to scenarios, and read the real CI state.
7. Pick three to five places that need a careful read, and say what is safe to skim.

The header carries ratings: risk (low, medium, high), blast radius (leaf or core) and review effort (1 to 5), each with the reason. The structure lives in `references/outline-template.md`.

## What you need

`git` and `gh` for PRs. Local diffs need only `git`.

## Limits

The outline reports only checks that ran, and it names the source and commit of each run.
