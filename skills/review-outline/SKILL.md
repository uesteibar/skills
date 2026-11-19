---
name: review-outline
description: "Use when outlining a PR or diff so it can be reviewed without code."
metadata:
  author: uesteibar
---

# Review Outline

Turn a change set (a PR, a branch, or a local diff) into a short outline that
a reviewer can read instead of the code. The outline must be **accurate**
(every claim comes from the diff) and **digestible** (one screen per section,
no code). It is not a code review: it does not hunt bugs or give a verdict.

## When to use

- The user asks for an outline, overview, summary or walkthrough of a PR,
  branch or diff, or asks "what does this PR change?".
- A coding agent opens or updates a PR: add the outline in PR mode (below).
- Don't use for: a bug-hunting review, a teaching explainer, or the author's
  handoff document.

## Modes

| Mode | Output | Language |
|---|---|---|
| Chat (default) | Markdown in the reply, plus the same file in the scratch directory (`review-outline-<topic>.md`) | The user's language |
| PR mode | A collapsed `<details><summary>Review outline</summary>` block in the PR body | The repository's PR language |

Translate headings and table headers into the output language; keep code
identifiers, paths and the ledger class names as they are.

Both modes use the same sections and template:
[references/outline-template.md](references/outline-template.md).

## Procedure

1. **Resolve the exact change set.**
   - PR: `gh pr view <n> --json title,body,baseRefName,headRefOid,files,additions,deletions,commits,url`,
     then `git fetch origin <base>` and diff `origin/<base>...<head>`
     (three dots, against the fetched base; a stale local `main` shows
     phantom changes).
   - Merged PR: the three-dot diff is empty or fails. Add `mergeCommit` to
     the `gh pr view` fields and diff `<merge>^1 <merge>`, or use
     `gh pr diff <n>`.
   - Local branch: `git diff origin/<base>...HEAD`; add `git diff HEAD` only
     if the user includes uncommitted work.
   - Done when your file list matches `gh` (or `git diff --stat`). Line
     counts can differ by diff algorithm; try `--minimal` before you
     suspect a wrong change set.
2. **Get the intent.** Read the PR body, the linked ticket/issue and the commit
   messages. If no reason is given, write `Intent: not stated`. Never invent
   a motivation.
3. **Build the file ledger.** Put every changed file in exactly one class:
   `behaviour`, `refactor` (renames, moves, extractions with no behaviour
   change), `mechanical` (formatting, mass find-replace), `generated`
   (lockfiles, snapshots, codegen, schema dumps), `tests`, `docs/config`.
   A file with mixed changes takes its dominant class; the Modules table can
   show `behaviour + refactor` for its cohort.
   Read the full diff and enough surrounding code of every `behaviour` and
   `refactor` file to state what it does now. For tests, read the diff plus
   the setup and helpers it uses, enough to name each scenario and what it
   mocks. Sample one example of each mechanical pattern; skip generated
   files.
   Done when the class counts add up to the total file count. On a follow-up,
   rebuild this ledger from the complete current PR diff; do not retain old
   class counts while updating only additions/deletions.
4. **Group into cohorts in dependency order**: data (schema, migrations) →
   domain logic → interfaces (API routes, events, jobs) → UI → config/infra →
   tests. Name each cohort after the repository's own module or area, not a
   generic label.
5. **Run the probes** below and fill each section. An empty section stays and
   says what you checked: `None. Checked: migrations/, *.sql, ORM models.`
   Absence is information for the reviewer.
6. **Draw the flows** with the notation below: one step table per use case,
   one arrow chain per data path.
7. **Map the tests** to scenarios (see Tests section), then read the real CI
   state with `gh pr checks <n>`. Runs started outside the PR checks (a
   `/integration` comment, a manual dispatch) count when you see them in
   `gh run view <id>` or a bot comment; name the source and the commit each
   run covered. Report only what ran.
8. **Pick the review focus**: 3 to 5 places that need a careful read, with
   the reason for each, and what is safe to skim.
9. **Self-check** with the checklist in Verification, then deliver.

## Header ratings

- **Risk:** `Low` = leaf change, no data or contract change. `Medium` = core
  path or changed contract, with tests that cover it. `High` = migration with
  backfill or long lock, auth, billing or data deletion, a breaking contract,
  or untested behaviour on a core path. Give the one reason that sets it.
- **Blast radius:** `Leaf` = a failure stays local (one page, report, script).
  `Core` = other parts depend on it (auth, schema, shared libraries, public
  API, orchestration). Name the area in parentheses.
- **Review effort (1–5):** 1 = a few lines, one concept; 3 = several
  behaviour files, one or two new concepts; 5 = many behaviour files across
  cohorts, new architecture or data model.

## Probes per section

- **Modules affected:** cohorts from step 4, one line each, with the change
  type (`behaviour` / `refactor` / `mechanical`).
- **Data and migrations:** new or changed tables, columns, indexes,
  constraints, enums; backfills; whether the migration reverts cleanly; long
  locks or table rewrites on large tables; what old code does with new data
  (rollout order).
- **Functional and architecture changes:** new modules or concepts; changed
  public contracts (API shapes, event names, job payloads, env vars, feature
  flags, config keys); removed behaviour; new dependencies; breaking changes.
- **Performance:** queries in loops (N+1), unbounded queries or missing
  limits, new indexes or queries without one, new external calls on a request
  path, cache added or removed, heavier payloads or client bundles, new
  concurrency or background fan-out. Say "hot path" only when the code shows
  it.
- **User flow per use case:** derive use cases from the intent and the entry
  points in the diff (pages, routes, commands, jobs). When behaviour changes,
  mark changed steps `~` and state the old behaviour in the System cell
  (`… (before: picked the only repo)`); show a removed step as a `-` row.
- **Data flow:** where data enters, what transforms it, where it is stored or
  sent.
- **Tests:** scenarios, not test names. For each scenario: kind (unit,
  integration, e2e), what is real and what is mocked, and whether it covers a
  `behaviour` cohort. Name the gaps: behaviour with no test, tests that mock
  the risky part, deleted or weakened assertions.

## Flow notation

Data flow: one arrow chain per path, at most about 6 nodes, inside a code
block (a `└→` branch line counts separately). Nodes are real names from the
code. Prefix a changed node: `+` new,
`~` changed, `-` removed. Branch with `└→` under the node it leaves from.

```
BrandForm → POST /api/brands → ~BrandService.create → brands (+col locale)
                                     └→ +syncBrandTask → brand_events
```

User flow: one table per use case.

| # | User | System | Change |
|---|---|---|---|
| 1 | Opens Brand Setup | Shows the form | — |
| 2 | Picks a language | Validates the locale | `+` |
| 3 | Saves | Stores the brand, starts the background sync | `~` |

Do not use Mermaid or ASCII boxes.

## Accuracy rules

- Every claim traces to the diff or to code you read. Mark a claim you
  deduced but did not read as `(inferred)`.
- Unknown is `not stated`, never a guess.
- Never claim tests or CI passed without the actual output.
- Keep `refactor`, `mechanical` and `generated` changes out of the
  behaviour sections; count them in the ledger line.
- Mention files only as `path` pointers next to a claim. No code snippets.

## Length budget

- Each section: at most 5 bullets or rows; overflow becomes
  `…and N more in <cohort>`.
- A normal PR outline fits in about 80 lines. A PR with more than 40
  behaviour files may be longer, but keep each section capped.
- Collapse sections that do not apply into one line:
  `No changes: performance, migrations. Checked: …`.

## Pitfalls

- Line counts from `gh` include generated files; read the ledger before you
  judge the size.
- A rename shows as delete plus add without `-M`; use `git diff -M` so a
  move is not reported as new code.
- Squash-merged base branches make three-dot diffs show already-merged work;
  check the commit list against the PR's own commits.
- PR mode: keep the outline inside `<details>` so the PR body stays short,
  and keep any existing template sections intact. After follow-up commits,
  refresh the outline's behavior, flows, ledger and test gaps together; a new
  evidence paragraph does not correct an obsolete description of the feature.

## Verification

Before you deliver, confirm:

- [ ] The ledger counts add up to the total changed files.
- [ ] Every section is present, filled or marked `None. Checked: …`.
- [ ] Each flow node is a real name in the diff or the code around it.
- [ ] Test and CI claims come from real output.
- [ ] Review focus has 3 to 5 entries, each with a reason.
- [ ] No code snippets; each section respects the length budget.
