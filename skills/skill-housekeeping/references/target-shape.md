# Target shape

Optimize the path through the instructions, not only the file size.

## Entry file

Keep `SKILL.md` as the task entry: trigger and boundary, authority, the default
workflow, completion criteria, and pointers for branches. Inline what every path
needs. Each pointer names both its target and the condition for loading it.

Aim for fewer than 8,000 characters in the entry and 10,000 in each topic reference.
These are review thresholds, not hard platform limits. Keep an indivisible recipe
together when a split would hide a prerequisite or create unnecessary navigation.
Explain retained oversize sections in the result rather than cutting requirements.

## Topic files

Use task-based names under `references/`. Split by a real branch or distinct stage,
not by an arbitrary character count. Avoid a catch-all reference that becomes the
new oversized entry. Keep definitions and their exceptions beside the procedure
that uses them. A reference must have a reachable pointer; an orphan file is not
progressive disclosure.

Put deterministic repeated checks in `scripts/`, format contracts in `templates/`,
and static inputs in `assets/`. This housekeeping task does not justify inventing
new automation or changing a working script's behavior.

## Compatibility and availability

Record each renamed file/heading and its inbound consumers. Update callers within
the approved scope together with their targets. Keep a compatible heading or a
short forwarding file when a caller cannot be changed; remove it only once callers
are migrated with permission. The forwarding text points to the new source rather
than duplicating the procedure.

Delegating to another skill is safe only if all intended profiles can load it and
it preserves the same requirements. Shared skills contain generic policy and
mechanics; profile-specific identities, projects and permissions stay in the
profile's own workflow. Never copy a private rule into a common skill just to
reduce the original file.

## Acceptance checks

| Check | Passing evidence |
|---|---|
| Preservation | Every protected rule maps to retained text or an approved change |
| Reachability | Default, uncommon and boundary scenarios reach all prerequisites |
| Integrity | Links checked, renamed targets searched, executable paths exercised |
| Discovery | Entry and moved reference load in the intended runtime(s) |
| Recovery | A snapshot contains the original including uncommitted work |

Report entry and total Markdown sizes separately. The CLI's character/4 token
estimate is only a rough indicator, not a tokenizer or a claim about actual runtime
context. Do not count moved reference text as deleted knowledge.
