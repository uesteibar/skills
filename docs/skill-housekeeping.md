# skill-housekeeping

Restructures one named skill without changing its intended workflow. It reduces load, removes duplication and stale material, and repairs the references that depend on the skill.

## When an agent uses it

- A skill is oversized, overlaps with another, or has collected incident notes.
- You ask to prune or split a skill.

For a brand-new procedure, use an authoring skill. For library-wide lifecycle work, use your runtime's own curator.

## How it works

1. **Inventory**: resolve the canonical directory, owner and dirty state, and read the whole skill.
2. **Map dependencies**: find every skill and caller that names this skill.
3. **Classify** each section: keep, condense, move, delegate or remove, with evidence.
4. **Design the target**: keep the entry workflow and mandatory rules in `SKILL.md`, and move branch-specific material into references.
5. **Rewrite safely**: take a restorable snapshot first, write the replacement in a staging directory, then install only the scoped files.
6. **Verify**: check links, load the skill through the real skill tool, and trace three applicable requests (default, less common, and an error or permission boundary).
7. **Report** what changed and what stayed.

A cleanup preserves policy. Approval gates, user decisions, exceptions and commands stay unless a verified source supersedes them.

## The helper CLI

`scripts/skill-audit` is a Python 3 script that uses no LLM and no third-party packages.

| Command | Use |
| --- | --- |
| `measure <skill-dir>` | Size per file and section, long lines, size warnings |
| `refs <skill-dir>` | Lines in other skills that name this skill |
| `links <skill-dir>` | Broken links and anchors, exit 1 on a problem |
| `wrap <skill-dir> <out-dir>` | Copy the Markdown with long lines split, for readers that cut long lines |

## What you need

Python 3. `--roots` sets the skill directories to scan. By default the script uses `$HERMES_HOME/skills` and the `skills.external_dirs` from the Hermes config, so outside Hermes pass `--roots` yourself.

## Limits

It inspects Markdown, not every consumer or runtime configuration. The skill tells the agent to record unreachable roots as unverified.
