# Navigation, Search, and Structure

## Choose navigation by information architecture

### Tab bar

Use tabs for a small number of peer destinations that remain globally available.

- Keep visible iPhone tabs to five or fewer.
- Use short, specific labels and recognizable SF Symbols.
- Preserve state within each tab when practical.
- Do not use tabs as sequential steps or transient filters.
- A tab can minimize during scrolling when this benefits content focus and does not harm discoverability.
- A tab structure may adapt into a sidebar on larger devices.

### Navigation stack

Use hierarchical push navigation for drill-down from broad content to detail. Preserve the system back gesture and back-button conventions. Do not intercept the edge-swipe gesture for unrelated custom behavior.

Large titles can establish the top level and collapse as content scrolls. Use inline titles where hierarchy or density calls for them; do not apply large titles mechanically to every screen.

### Sidebar and split view

Use sidebars for broader collections, workspaces, or persistent sections on iPad. Use split views to keep source lists, detail, and optional inspectors visible when space permits. Support fluid resizing and predictable collapse into compact navigation.

### Modal navigation

Use a modal presentation for a self-contained task, temporary branch, or explicit interruption. Do not place the app’s primary information architecture inside a chain of modals.

## Toolbars

- Place frequent actions in predictable locations and keep primary content central.
- Group actions that affect the same object or scope.
- Use standard icons for standard actions.
- Do not mix text and icons inconsistently within one visual group.
- Give every icon-only item an accessibility label.
- Hide the toolbar item itself, not only its internal view, to avoid empty chrome.
- Use menus to contain lower-frequency related actions instead of overcrowding the toolbar.

## Search

- Make search easy to find where content volume or retrieval behavior justifies it.
- Use a standard search field and platform conventions for cancellation, clearing, suggestions, and focus.
- In current iOS navigation, search may integrate into a toolbar or navigation bar, receding and expanding with scroll and keyboard presentation.
- If search is a dedicated tab, use the semantic search role so the system can place it distinctly at the trailing edge.
- Present useful suggestions or recent searches before text entry when appropriate.
- Update results responsively, but avoid expensive requests on every keystroke without debouncing or cancellation.
- Preserve the query and result context when visiting a result and returning.
- Announce result-count or empty-result changes accessibly.

## Menus and contextual actions

- Use menus for related choices and secondary actions, not for hiding the core path.
- Put frequent and harmless actions first; separate destructive actions and mark them with a destructive role.
- Use standard selectors/actions so the system can supply familiar icons where supported.
- Keep top contextual-menu actions consistent with swipe actions for the same item.
- Anchor popovers and action sheets to the initiating control when the platform supports it.

## Wayfinding review

For every state, verify:

- Current location is apparent.
- Primary destination and next action are discoverable.
- Back, cancel, close, or escape behavior is predictable.
- Deep links land in a coherent hierarchy.
- Tab, sidebar, and stack state survive adaptation.
- Custom gestures do not compete with system navigation.
