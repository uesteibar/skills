---
name: skill-housekeeping
description: "Use when pruning or splitting skills. Preserve behavior."
metadata:
  author: uesteibar
---

# Skill housekeeping

Restructure a named skill without changing its intended workflow. Reduce load,
remove duplication and stale material, and repair the references that depend on
it. Use this for an oversized skill, overlapping guidance, or accumulated incident
notes. Use the authoring skill for a new procedure; use the runtime's curator for
library-wide lifecycle management.

## Permission and scope

Inspect first. Edit only the skills and callers covered by the user's request.
Confirm ownership and provenance: shared skills require the owner's permission;
registry-managed skills require an upstream change or an explicit local override.
A locked skill requires an authorized unlock. Preserve unrelated working changes.

A cleanup preserves policy. Keep approval gates, user decisions, exception cases,
commands and identifiers intact unless a verified source supersedes them. Stop
and ask when two live rules conflict. Smaller text is not permission to remove a
safety boundary. Apply the active profile's coding and publication rules to scripts.

## Workflow

Use `scripts/skill-audit` from this skill's actual directory (`$AUDIT` below).
It is a Python 3 CLI, with no LLM or third-party dependencies.

### 1. Inventory

Resolve the canonical skill directory, source repository, owner, and dirty state.
Run `"$AUDIT" measure "$SKILL"` and save its output outside the skill. Read the
entire skill and its resources. If the reader truncates long lines, run
`"$AUDIT" wrap "$SKILL" "$NEW_READ_DIR"` and read that copy; never install it.

**Complete when:** every file has been read or marked as executable/binary with
its purpose identified, and the starting size and working state are recorded.

### 2. Map dependencies

Run `"$AUDIT" refs "$SKILL" --roots <skill-roots...>`. Read the related skills
before calling anything duplicate. Search the skill name and old file names in
caller repositories, prompts and automation outside those roots too. The CLI
inspects Markdown, not all consumers or runtime configuration.

**Complete when:** each inbound caller and each candidate replacement source has
an owner and a location. Record inaccessible roots as unverified.

### 3. Classify

Load [classification](references/classification.md). Make a disposition table:
`Source section | Keep / condense / move / delegate / remove | Destination | Evidence`.
Record protected decisions, gates, commands, exceptions and scripts separately.

For an explicit cleanup request, proceed within that scope. Otherwise present the
table before editing. Ask only about uncertain policy changes or additional scope.
Use the active profile's review tool when the user requests a plan review.

**Complete when:** every section has one disposition, and no conflict or deletion
of a protected rule is unresolved.

### 4. Design the target

Load [target shape](references/target-shape.md). Keep the entry workflow and
mandatory rules in `SKILL.md`; disclose branch-specific material by topic. Define
old-to-new file and heading mappings before renaming. Each delegated rule needs
a reachable, authoritative destination in every intended profile.

**Complete when:** every retained rule has one home and a trigger that reaches it.

### 5. Rewrite safely

Check [tool boundaries](references/pitfalls.md) when the reader, writer or skill
manager imposes limits. Make a restorable snapshot outside auto-pruned scratch,
including uncommitted content. Record its absolute path and restore procedure.
Write the complete replacement in a new staging directory. Reconcile it against
the disposition table and protected rules before replacing live files.

Install only scoped files, update authorized callers, then remove superseded files.
If a caller is outside permission, keep its target compatible or obtain approval.
Recheck dirty state before installation; merge concurrent edits instead of replacing
them. Do not edit runtime configuration to make a cleanup pass.

**Complete when:** the source skill and authorized callers reflect one consistent
version, and the original is recoverable without losing unrelated changes.

### 6. Verify

Run `"$AUDIT" links "$SKILL" --roots <skill-roots...>` and resolve every confirmed
problem. Inspect heuristic warnings manually. Search again for removed filenames
and headings in all mapped callers. Load the entry skill and a moved reference
through the actual skill tool; verify discovery in each intended runtime/profile.
Exercise changed scripts and their tests.

Trace three applicable requests through the new text: the default task, a less
common branch, and a permission/error boundary. Each must reach the necessary
instructions and preserve the old decisions. Fix unreachable or contradictory
rules. Rerun `measure`; size is a diagnostic, not the acceptance criterion.

**Complete when:** protected rules and mapped callers are accounted for, tests pass,
loading works, and scenario checks have no unexplained gaps. A zero link count
alone does not prove semantic equivalence.

### 7. Report

Give entry-file and total Markdown sizes before/after, what was removed or moved,
verified loading/tests/scenarios, and the snapshot path. State unverified roots or
consumers. Follow the repository's commit/publication policy; never claim a local
change has been published.
