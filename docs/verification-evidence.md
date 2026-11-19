# verification-evidence

Captures proof while a change is verified, so that PR preparation can report results later without rerunning anything.

## When an agent uses it

The agent implements or verifies a change, especially a UI change that needs screenshots or a short recording.

## How it works

1. Plan the evidence together with the verification: the smallest useful proof for each acceptance criterion.
2. Capture during the real check. Run each justified check once, and record the exact command, scope, outcome and relevant output. For UI work, take screenshots or a recording during the normal smoke test.
3. Store the artifacts in the repository's usual evidence location, or a clear non-secret place. Do not capture credentials or private data, and do not commit evidence unless the project requires it.
4. Write an evidence record: a table of check or scenario, command or steps, result and artifact, plus a "Gaps" list.
5. Hand off: say where the record is and which checks passed, failed, were skipped or are unverified.

## Rules

- Never fabricate or overstate a result. A skipped or blocked check is marked as such.
- Evidence supports a claim and does not replace required tests.
- Rerun only checks that are missing, failed, invalidated by later changes, mandated by the project, or requested by you.

## Works with

`pr-creation` reads this record and reports its real commands and results in the PR body.
