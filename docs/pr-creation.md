# pr-creation

Creates, rewrites and updates GitHub pull requests so a reviewer grasps the goal, the important decisions and the verification in under a minute.

## When an agent uses it

You ask to open, draft, prepare, polish, shorten or update a PR, including turning a branch into a PR.

## How it works

1. Inspect the change: repository instructions, PR template, branch, diff, commits, and any existing PR.
2. Collect existing verification evidence. The agent reuses recorded commands and results and does not rerun checks just to write a PR.
3. Choose the PR state (draft or ready) from your request and the repository's rules. It prefers updating an existing PR to opening a duplicate.
4. Write the title and body. The default is 250 to 500 words: goal, an architecture diagram (Mermaid when supported), a user-flow diagram only when it helps, the key decision and trade-off, and verification.
5. Create or update with `gh`, using `--body-file`, then check the title, body, branches, draft state and URL.

Every claim must come from the diff or the evidence. The skill forbids invented screenshots, timings or rollout claims. It also follows the repository's PR template and title convention.

## What you need

- `gh` (GitHub CLI), authenticated.
- It uses `review-outline` to add a collapsed review outline to the PR body, and `verification-evidence` records as its source of proof.

## Limits

It writes PRs. It does not review code, merge, or mark a PR ready unless you ask.
