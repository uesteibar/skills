# pr-shepherd

Keeps an open pull request moving after a coding agent publishes it. It waits for CI and review feedback, helps the agent decide what each event needs, and stops when the PR merges or closes.

## When an agent uses it

A PR is open and a coding agent is responsible for it.

## The CLI

`scripts/pr-shepherd` is a standard-library Python script that calls `gh`. It uses no LLM.

| Command | Use |
| --- | --- |
| `wait <owner/repo> <pr> [--events ci,review,conflict] [--timeout 2h]` | Block until the first actionable event, print it, exit |
| `context <owner/repo> <pr> --ci` | Failing checks, with a log excerpt per job |
| `context <owner/repo> <pr> --reviews` | Unresolved review threads and review summaries |
| `status <owner/repo> <pr>` | One-shot state, changes nothing |

`wait` prints one `EVENT ...` line and exits with a code: 0 `CI_GREEN`, 1 `CI_RED`, 2 `REVIEW`, 3 `TIMEOUT`, 4 `CONFLICT`, 5 `MERGED`, 6 `CLOSED`, 7 `ERROR`, 8 `STOPPED`, 64 usage error.

## How the loop works

- It reports CI only when every check on the current head has finished, so failures arrive in one batch.
- It ignores the PR author's own comments, bot comments and slash commands, and batches feedback that arrives within two minutes.
- For `CI_RED`, the agent classifies each failed job. A real defect goes back to the coding agent as one correction batch. An infrastructure failure gets one rerun.
- For `REVIEW`, each comment is checked against the code. Valid items go to the coding agent, invalid ones get a reply with evidence, and product decisions go to you. Threads are never resolved.
- For `CONFLICT`, the agent merges the base branch. It does not rebase or force push.
- After three correction rounds without progress, it stops and asks you.

## Side effects

This skill acts on GitHub through the agent that follows it:

- It tells the agent to post replies to review threads with `gh api ... /replies`. `gh` posts under **your own GitHub account**, and each reply starts with the prefix `Hermes Agent, for @<pr-author>:` (change it with `--own-prefix`). The skill tells the agent to say this to you.
- It tells the agent to rerun failed CI jobs once with `gh run rerun --failed`.
- It never resolves threads, merges, enqueues, deploys or marks a PR ready. The script itself only reads from GitHub.

If you do not want an agent to post under your account, do not install this skill, or add a rule to your agent that forbids posting without your approval. The skill says that such a rule wins.

## What you need

- `gh`, authenticated, and Python 3.
- An agent that can run a background process and be woken when it exits.
- State files go to `$PR_SHEPHERD_STATE_DIR`, or to `$HERMES_HOME/data/pr-shepherd` when that variable is set. Replies start with a prefix set by `--own-prefix` or `$PR_SHEPHERD_OWN_PREFIX` (default `Hermes Agent`).

## Limits

On macOS, the check for an older running wait reads `/proc`, which does not exist there. A replaced wait is not detected, and `status` can show a stale state. The loop never merges, enqueues, deploys or marks a PR ready. Those need your explicit request. It also does not launch the coding agent: send and thread commands belong to your own workflow.
