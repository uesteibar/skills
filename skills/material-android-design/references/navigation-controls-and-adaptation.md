# Navigation, controls, and adaptation

## Design by intent, not by iOS component substitution

| Intent | Android starting point | Check before selection |
|---|---|---|
| Top-level destinations | Material navigation bar; rail or other adaptive navigation at larger window sizes | Real destinations, labels, selected state, preserved tab history |
| Navigate within a hierarchy | Top app bar with Up where appropriate | Deep-link entry, Back versus Up destination, scroll behaviour |
| Primary contextual creation | FAB or extended FAB when it clearly earns prominence | One dominant action, no duplicated competing CTA, no obscured content |
| Submit/review/save | Appropriately emphasised button in the task surface | IME reachability, pending state, duplicate-submit prevention |
| Short contextual choices | Menu | Anchor, focus, dismissal, destructive meaning |
| Supporting task | Bottom sheet or dialog when bounded; full screen for substantial work | Keyboard, scroll, Back, cancellation, unsaved input |
| Search | Material search pattern suited to scope | Focus, query retention, no-results, clear and Back behaviour |
| Selection | Radio, checkbox, switch, chips, or segmented buttons based on semantics | Mutually exclusive versus independent, immediate setting versus form submission |
| Transient feedback | Snackbar where suitable | Timing/accessibility, actionable recovery, persistent alternative for important information |
| Photo/file/system sharing | Android-owned chooser/share surface | Before/after state, cancellation, permission denial; no custom system-dialog artwork |

These are candidates, not forced one-to-one mappings. Read the current component guidance before exact specification.

## Back contract

For each meaningful state, specify:
- What system Back does: keyboard dismissal, transient surface exit, navigation, or another justified action.
- What toolbar Up does, including deep links and cross-task entry.
- What unsaved work survives and when discard confirmation is justified.
- Whether a predictive-back preview is available, what committing changes, and how cancelling restores the original state.

Prefer navigator/platform support to a global custom handler. Do not pop routes, discard data, or submit mutations during an uncommitted preview. Do not install edge-drag targets that compete with system Back. Validate both gesture and three-button modes.

## Window and inset contract

- Use available window space rather than a fixed phone/tablet label; resizing can happen on the same device.
- Specify when a bar becomes a rail, or a list/detail flow becomes two panes. Preserve selected item, query, draft, and scroll state as appropriate.
- Assign inset ownership to a specific shell/component. Verify backgrounds draw edge-to-edge while controls and essential text avoid system occlusion.
- Validate top/bottom bars, cutouts, IME, display scaling, landscape, and any floating actions independently. Do not copy an iPhone home-indicator allowance into Android.
- Test content can scroll clear of a persistent action and keyboard; do not add an extra bottom inset if the library already consumes it.
- For foldables, keep controls/content away from obstructing hinges and define posture behaviour only when supported and in scope.

## Handoff and runtime checks

Name the owner of each mechanic: OS, navigator, component library, or app code. Verify installed-library support before naming an implementation. A Material-styled React Native component is not automatically a Compose component or an OS-owned control.

For a runtime task, collect route state, accessibility state, and pixels for the named interaction. Mockups cannot prove Back, keyboard synchronisation, state restoration, or TalkBack operation.
