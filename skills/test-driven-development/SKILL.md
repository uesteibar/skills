---
name: test-driven-development
description: Apply test-first development to testable production behavior changes, using focused red-green cycles and the repository's proportional-verification policy.
---

# Test-Driven Development

Use the repository's canonical TDD policy. This skill supplies execution detail without adding a second verification matrix.

## Red–green–refactor

1. **Red:** Write the smallest test that demonstrates the next behavior.
2. **Confirm red once:** Run it and ensure it fails because the behavior is absent, not because the test is broken.
3. **Green:** Write the minimum production code needed to pass.
4. **Confirm green:** Run the focused test.
5. **Refactor:** Improve the code only while the focused test remains green.

Use one test for an isolated behavior or a focused/table-driven group for closely related boundary cases. Start another cycle only when the next behavior is materially distinct.

## Good tests

A good test:

- exercises public behavior rather than implementation details;
- fails for one clear reason;
- is deterministic and minimal;
- uses real collaborators when mocking would only reproduce the implementation;
- has a name that states the behavior and relevant condition.

For a regression, make the test fail with the observed symptom before applying the fix. For a behavior-preserving refactor, establish focused coverage of the boundary before changing structure.

## Scope

Test-first development applies to testable production behavior changes, including features, bug fixes, and refactors. Generated code, throwaway prototypes, configuration, prompts, documentation, and test tooling do not need new behavioral tests unless executable production behavior changes.

If a testable production change cannot reasonably be covered first, explain the constraint and get user agreement before proceeding.

## Proportional verification

- Run the focused test for each red-green cycle.
- Do not rerun the same unchanged failure merely to document it twice.
- Do not run aggregate suites or native matrices after each intermediate edit.
- After the slice is stable, run at most one broader check justified by the affected package, contract, or runtime. This default does not override gates mandated by the repository or user, nor verification of the changed tree that those gates or the change itself require.
- An explicit developer validation budget overrides default matrices unless safety, data integrity, or a public contract requires escalation.

## Common failure modes

- Writing production code before observing the relevant test fail
- Testing mocks rather than behavior
- Combining unrelated behaviors in one test
- Starting separate cycles for trivial variations that belong in one table
- Expanding scope while the smallest vertical slice is still unstable
- Treating a successful full suite as a substitute for a meaningful focused test

## Completion

Report the behavior covered, focused red/green evidence, and any broader verification actually justified and performed. Do not repeat raw output or run checks solely to fill a checklist.
