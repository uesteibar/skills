---
name: pr-shepherd
description: "Use when a PR is open. Watch CI and reviews, route fixes."
metadata:
  author: uesteibar
---

# PR shepherd

Keep an open pull request moving after the coding agent publishes it: wait for
CI and review feedback, decide what each event needs, send the fixes to the
same coding agent, and stop when the PR merges or closes.

Delegation policy and the coding agent's thread commands belong to your
orchestration workflow. This skill owns the PR loop. Profile and repository rules override it (for
example, a profile that forbids posting on PRs without the user's permission).

## The CLI

`scripts/pr-shepherd` in this skill directory. No LLM, stdlib Python, uses `gh`.

| Command | Use |
| --- | --- |
| `pr-shepherd wait <owner/repo> <pr> [--events ci,review,conflict] [--timeout 2h]` | Block until the first actionable event, print it, exit |
| `pr-shepherd context <owner/repo> <pr> --ci` | Failing checks with a log excerpt per job; saves the brief and full logs |
| `pr-shepherd context <owner/repo> <pr> --reviews` | Unresolved threads (marked `answered by us` when our reply is last) and review summaries |
| `pr-shepherd status <owner/repo> <pr>` | One-shot state: CI counts, unreported feedback, running wait. Changes nothing |

`wait` prints one `EVENT <NAME> <repo>#<pr> head=<sha>` line plus details and
exits with: `0` CI_GREEN, `1` CI_RED, `2` REVIEW, `3` TIMEOUT, `4` CONFLICT,
`5` MERGED, `6` CLOSED, `7` ERROR, `8` STOPPED, `64` usage error. Read the
`EVENT` line, not only the exit code.

What `wait` does for you:

- Reports CI only when every check on the current head has finished, so all
  failures arrive in one batch. A head must be known for 60 s before green
  (3 min with no Actions checks), so a push that registered only some checks
  does not read as green.
- Reports each CI result and each conflict once per head. A re-armed wait on
  the old head stays silent until the new head arrives, so you can arm it right
  after you send a fix, before the agent pushes.
- Batches feedback that arrives within 2 min. Ignores the PR author's comments
  (the coordinator and the coding agent post through that account), comments
  that start with `Hermes Agent`, bot issue comments and `/commands`.
- The first `wait` with reviews on a PR marks existing feedback as already seen.
- MERGED and CLOSED always end the wait.
- Keeps one wait per PR: a new `wait` stops the older one, which exits `STOPPED`.

State lives in `$HERMES_HOME/data/pr-shepherd/`; briefs and logs go to the
profile scratch directory (`saved:` line).

## Arm the wait

Launch every wait as a background process that notifies the session on exit:

```
terminal(command="<skill_dir>/scripts/pr-shepherd wait <owner/repo> <pr>",
         background=true, notify=true, persist_on_release=true)
```

- Arm it as soon as the PR exists. On a PR that already has feedback, first run
  `context --reviews` and handle what is there, because the first wait treats
  existing feedback as seen.
- After you send a fix to the coding agent, re-arm the PR wait together with
  the wait on that coding agent's own thread.
- Never end a turn with an open PR of the task and no running wait, except
  when the user paused the work. `status` shows `wait: running (pid …)`.
- `STOPPED` from a wait you replaced is not an event; ignore it.

## Handle each event

1. **CI_RED.** Run `context --ci` and classify each failed job from its log:
   - Real defect (assertion, type error, lint on changed code): send one
     correction batch to the same thread with your orchestrator's send command. Point to the
     `saved:` brief, name the failing jobs, and require a commit and a normal
     push to the PR branch; forbid force push and merge.
   - Infra or flaky (runner, network, port, a test the PR does not touch that
     passed before) or `CANCELLED`: rerun once with
     `gh run rerun <run-id> --failed --repo <owner/repo>`. A second failure of
     the same job on the same head is a real defect.
   - An aggregate job (for example `CI Success`) only mirrors other jobs.
   Then re-arm.
2. **REVIEW.** Run `context --reviews`. Check each new item against the code
   before any brief:
   - Valid: add it to one correction batch for the coding agent.
   - Invalid: reply on the thread with the evidence (`path:line`), no brief.
   - Product or scope decision: ask the user with `clarify`; do not decide it.
   - Already fixed: reply with the commit.
   Start every reply with `Hermes Agent, for @<pr-author>:`, post it with
   `gh api repos/<owner>/<repo>/pulls/<n>/comments/<comment-id>/replies -F body=@<file>`,
   and tell the user that `gh` posts under their account. Never resolve threads.
   Then re-arm.
3. **CONFLICT.** Ask the coding agent to merge `origin/main` into the branch,
   resolve the conflicts, run the affected checks and push normally. No rebase,
   no force push. Then re-arm.
4. **CI_GREEN.** Report to the user: passed and skipped counts, the head, and any
   skipped check that matters (for example tests that run only in a merge
   queue). Then re-arm for late feedback:
   `wait <owner/repo> <pr> --events review,conflict --timeout 24h`.
5. **MERGED / CLOSED.** Report it and stop watching. Do not re-arm.
6. **TIMEOUT.** Not a result. Run `status` and decide: re-arm if CI is still
   running or feedback is still likely, or tell the user the PR is idle and stop.
7. **ERROR.** `gh` failed 10 times in a row. Check `gh auth status` and the
   network, then re-arm or tell the user.

## Limits and stopping

- After three correction rounds on one PR without progress, stop, name the
  doubtful assumption, and ask the user.
- A gateway or host restart kills running waits. When you resume a task with
  an open PR, run `status` and re-arm.
- This loop does not merge, enqueue, deploy or mark a PR ready. Those need
  the user's explicit request and the repository's own release rules.
