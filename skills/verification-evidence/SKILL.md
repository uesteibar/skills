---
name: verification-evidence
description: Capture and organize proof while verifying a code change so later PR preparation can report results without rerunning checks. Use when implementing or verifying work, especially UI changes that need screenshots or recordings.
---

# Verification Evidence

## Goal

Capture trustworthy, reviewable evidence as part of the verification already being performed. Leave a concise record that PR preparation can reuse without repeating tests, flows, or manual checks.

## Workflow outline

1. **Plan evidence alongside verification**
   - Derive checks from the changed behavior and the repository's validation rules.
   - Identify the smallest useful proof for each acceptance criterion: test output, command result, screenshot, recording, or other artifact.
   - Do not add redundant checks just to make the evidence record look complete.
2. **Capture during the real check**
   - Run each justified check once and record its exact command, scope, outcome, and relevant output.
   - For UI work, capture screenshots or a short recording during the ordinary smoke test, showing the resulting state and enough context to understand it.
   - Do not rerun successful verification just to capture prettier evidence or prepare a PR.
3. **Store artifacts safely**
   - Use the repository's established evidence/artifact location when one exists; otherwise choose a clear, non-secret location appropriate to the repo.
   - Use descriptive filenames and preserve useful context (screen, scenario, platform, or viewport).
   - Do not capture credentials, private user data, or unrelated sensitive content. Do not commit generated evidence unless project conventions or the user require it.
4. **Write an evidence record**
   - Record the date/context, check or scenario, command or steps, result, artifact path/link, and any limitation.
   - Mark skipped, blocked, or failed checks plainly; never imply they passed.
   - Include a compact evidence index or pointer in the implementation handoff so PR preparation can find it.
5. **Hand off without replay**
   - Tell the PR-writing workflow where the evidence record and artifacts are.
   - State which checks passed, failed, were skipped, or remain unverified.
   - Do not repeat tests merely to prepare a PR. Run checks that are missing, failed or invalidated by later changes, project-mandated gates, and any the user expressly requires.

## Evidence record outline

```md
# Verification evidence

| Check / scenario | Command or steps | Result | Evidence |
| --- | --- | --- | --- |
| [Focused test] | `[command]` | Pass / Fail / Blocked | [log or output reference] |
| [UI journey] | [brief steps] | Pass / Fail / Not run | [screenshot/video path or link] |

## Gaps
- [Skipped or unavailable proof and why]
```

## Boundaries

- Evidence supports a claim; it does not replace required tests or validation.
- Never fabricate, alter, or overstate results.
- Prefer small, focused artifacts that demonstrate the changed behavior.
- Follow repository instructions and explicit validation budgets. If evidence was not captured during the original check, report the gap instead of silently repeating verification.
