# Paired-platform design workflow

Use this reference to record deliberate differences and review two mobile versions of the same product. Platform skills supply their own component and interaction guidance; this reference supplies the comparison method.

## Decision matrix

| Concern | Shared invariant | iOS presentation | Android presentation | Reason / source | Status |
|---|---|---|---|---|---|
| Navigation | Same destination and task | Appropriate Apple pattern | Appropriate Material pattern | Task structure and platform guidance | |
| Primary action | Same meaning and priority | Contextual platform placement | Contextual platform placement | Discoverability and reachability | |
| Input | Same information and validation | Apple input and focus behaviour | Android input and IME behaviour | Platform mechanics and content capacity | |
| Transient surfaces | Same outcome and dismissal semantics | Appropriate sheet, menu, or alert | Appropriate sheet, menu, or dialog | Platform guidance and recovery | |
| Return / cancel | Same preserved work and outcome | Navigation and gesture semantics | Up, system Back, and gesture semantics | Entry paths and state contract | |
| Theme and assets | Recognisable identity and hierarchy | Apple semantic roles and assets | Material semantic roles and assets | Platform guidance and project policy | |
| Adaptation | Same task capability | In-scope Apple windows and inputs | In-scope Android windows and inputs | Actual device/window scope | |

Do not force identical font sizes, radii, shadows, icon glyphs, or motion constants. Preserve shared meaning, then justify each platform's expression. Keep explicit project decisions in project documents, not in this matrix's generic guidance.

## Review on two independent axes

### Platform quality

Review iOS with `apple-ios-design` and Android with `material-android-design`. Check the agreed navigation, controls, input, system regions, accessibility, and adaptation scope. Disclose unavailable artifacts and runtime evidence.

### Product parity

Compare the same tasks and state semantics, not frame names or screenshot dimensions:

- Can users achieve the same intended outcomes?
- Is required information available and understandable on both sides?
- Are actions discoverable, and does cancellation or recovery preserve work?
- Does the identity remain recognisable without copying platform chrome?
- Are differences intentional and supported by evidence rather than unequal design maturity?

Equal quality does not require equal pixels or identical interaction sequences.

## Acceptance ledger

| Flow/state | Shared contract | iOS design | Android design | iOS runtime | Android runtime | Gap / owner |
|---|---|---|---|---|---|---|

Use explicit statuses: `proposed`, `reviewed`, `approved`, `verified`, `unverified`, `blocked`, or `out of scope`. Design approval is not runtime verification. Do not hide one platform's gap behind an overall checkmark.

For design-only work, verify the edited artifact's persistence and inspect current renders on both sides. For separately authorized runtime work, exercise actual platform controls and transitions. Do not require an application scaffold merely to finish a design artifact.

## Scope checks

- A paired task keeps both platforms in the review cycle; either may lead exploration.
- A port preserves the existing platform unless its redesign is explicitly requested.
- A single-platform correction does not trigger a redesign of the other platform.
- A shared mockup is not a claim that both native presentations or runtimes are verified.
- A stack limitation is recorded as a gap or decision, not concealed by native-looking artwork.
