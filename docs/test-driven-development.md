# test-driven-development

A compact test-first workflow for changes to testable production behaviour: features, bug fixes and refactors.

## When an agent uses it

You ask for a change to behaviour that code can test.

## How it works

1. **Red**: write the smallest test that shows the next behaviour.
2. Run it once and confirm that it fails because the behaviour is missing, not because the test is broken.
3. **Green**: write the minimum production code that passes.
4. Run the focused test.
5. **Refactor** while the focused test stays green.
6. Start a new cycle only when the next behaviour is materially different.

For a regression, the test first reproduces the reported symptom. For a behaviour-preserving refactor, focused coverage comes before the structure change.

Good tests exercise public behaviour, fail for one clear reason, stay deterministic and small, and use real collaborators when a mock would only copy the implementation. The skill ships `testing-anti-patterns.md`, which the agent loads when it writes tests or adds mocks.

## Verification budget

The agent runs the focused test for each cycle, and then at most one broader check after the slice is stable. It does not rerun an unchanged failure to document it twice, and it does not run full suites after every edit. Mandatory project gates and an explicit budget from you still win.

## Attribution

`testing-anti-patterns.md` is adapted from [obra/superpowers](https://github.com/obra/superpowers) (MIT, Copyright (c) 2025 Jesse Vincent). See `THIRD_PARTY_NOTICES.md`. The rest of the skill is original.

## Limits

Generated code, throwaway prototypes, configuration, prompts, documentation and test tooling do not need new tests. The skill assumes that your repository has its own TDD and verification policy, and it adds execution detail without a second matrix.
