# Tool boundaries and audit limits

Use the active runtime's help and current documentation for writer and skill-manager
limits. Treat a refusal as a boundary: read the exact error and use the supported
edit path. Do not bypass a permission lock with a shell copy.

## Reading and installation

Readers can truncate a very long line even when the file itself fits the read
budget. `skill-audit wrap` writes a disposable reading copy. Line numbers and code
formatting in that copy differ from the source; never install it or use its line
numbers in a patch. Lines are split at a fixed character width, including unbroken
tokens; original spaces and tabs are preserved.

Use a fresh staging directory for the replacement. Snapshot outside locations that
are automatically cleaned. A git commit does not preserve uncommitted edits; include
those in the snapshot. Restore only the authorized paths, preserving unrelated work.
Verify loading with the actual skill tool: a shortened name in a tabular listing is
not evidence that discovery failed.

## CLI contract

Run `scripts/skill-audit --help` for syntax. Commands take the skill directory.

| Command | Result |
|---|---|
| `measure SKILL [--top N]` | Markdown characters, rough token estimate, long lines, largest level-2 sections |
| `refs SKILL [--roots DIR ...]` | Inbound Markdown mentions with candidate file/title citations |
| `links SKILL [--roots DIR ...]` | Missing inline Markdown targets/anchors and inferred inbound citations |
| `wrap SKILL NEW_DIR [--width N]` | Reading copy; the destination must be new and outside the source |

Exit codes: 0 completed (for `links`, no detected problems); 1 link problems;
2 invalid input. `measure` warnings are advisory. Only `wrap` writes files.

The default roots are the active `$HERMES_HOME/skills` and block-list
`skills.external_dirs` entries discovered in its config. The script uses a small
text parser, not a YAML library: pass `--roots` explicitly for inline lists,
nonstandard configuration, another runtime, or additional consumer repositories.
Inline configuration returns an input error until explicit roots are supplied.
Missing explicit roots also fail rather than producing a false clean result.
Use roots only from the authorized workspace; avoid scanning unrelated profiles.

## What the checker does not prove

This is a lightweight scanner, not a full Markdown or YAML parser. It checks inline
links outside fenced blocks and approximates GitHub-style ATX heading anchors.
Reference-style links, HTML anchors, complex nested Markdown, multiline citations,
and citations without the skill's name can need manual checks. URL reachability is
not checked. File and quoted-title citations inferred after a skill name are
heuristics: confirm a warning before editing policy. Ambiguous prose that mentions
several skills is listed by `refs` but is not assigned a definite citation owner.

`refs` searches Markdown, so search source, runtime configuration and automation
separately. A clean `links` result means no problems found in supported forms and
scanned roots; it does not mean all consumers were examined or rules preserved.
Keep the disposition ledger and scenario checks as the semantic acceptance test.
