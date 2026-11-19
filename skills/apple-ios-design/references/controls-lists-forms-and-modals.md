# Controls, Lists, Forms, and Modals

Prefer standard controls. They inherit platform appearance, interaction behavior, accessibility, localization, Dynamic Type, keyboard support, and current materials. Customize only when product meaning requires it.

## Buttons

- Use a verb or outcome-specific label.
- Maintain one clear primary action per task region.
- Use roles for destructive and cancellation actions.
- Avoid using red for non-destructive emphasis.
- Do not disable an action without making the reason discoverable.
- Provide immediate pressed feedback and a generous hit area.
- Use system button styles, including current glass styles, before building a custom glass surface.
- Icon-only buttons require accessible names and should use familiar symbols.

## Toggles and switches

Use a toggle for an immediate binary state. The label describes the state or feature, not an instruction such as “Turn on.” Reflect the new state immediately or communicate pending work and failure. Do not use a switch when a separate confirmation step is required; use a selection control or button flow instead.

## Text fields

- Use a single-line text field for concise input and a text view/editor for longer content.
- Keep labels persistent when loss of context would be harmful; placeholders are examples, not replacements for labels.
- Select appropriate keyboard, content type, capitalization, autocorrection, and secure-entry behavior.
- Provide clear affordance when needed, but avoid decorative borders that conflict with system styling.
- Validate close to the field, explain recovery, and preserve entered data after errors.
- Move focused fields consistently when the keyboard appears.

## Pickers and segmented controls

- Use a picker or menu for selecting from several values.
- Use a segmented control for a small number of closely related, mutually exclusive views or modes.
- Keep segment labels short and balanced; do not crowd the control with many options.
- Prefer platform pickers for dates, times, and other structured values.
- Show the current value clearly and respect locale formatting.

## Sliders and steppers

Use a slider for a continuous range where approximate adjustment is meaningful. Use a stepper for discrete increments where exact value changes matter. Provide the current value and accessible increment/decrement behavior. Do not require precision that the control cannot support.

## Lists, tables, and forms

- Use lists for scannable collections and forms for grouped data entry or settings.
- Preserve familiar row selection, disclosure, swipe, reorder, and edit behavior.
- Keep destructive swipe actions explicit and recoverable where possible.
- Use sections and whitespace to express structure.
- Current list/form styling uses more breathing room, increased corner radii, and title-style section headers.
- Avoid fixed row heights that fail with Dynamic Type or multiline content.
- Provide meaningful empty, loading, filtered-empty, offline, and error states.
- For tables on iPad, support selection, sorting, resizing, keyboard/pointer interaction, and horizontal constraints only when the data benefits from columns.

## Alerts and confirmations

Use an alert for critical information requiring acknowledgement or a decision. Keep the title concise, explain consequences in the message, and label actions with outcomes. Use confirmation dialogs/action sheets for contextual choices. Do not use alerts as routine success feedback.

Confirm destructive, irreversible, or unusually costly actions. Prefer undo for reversible actions. Never make a destructive button visually indistinguishable from a routine action.

## Sheets and popovers

- Use sheets for focused tasks that preserve context beneath them.
- Keep a clear completion and cancellation model.
- Current half sheets may be inset and reveal surrounding content; audit both the sheet interior and visible background edges.
- Avoid adding custom visual-effect backgrounds that interfere with system material.
- Anchor popovers and action sheets to their source control.
- Let larger or more complex tasks expand or move to full screen when necessary.
- Preserve entered data across detent changes, interruptions, and temporary dismissal when the product model permits.

## Share and system views

Prefer system views for sharing, document picking, photos, permissions, authentication, payments, and other system-owned tasks. They carry user trust and established behavior. Request permission at the moment value is understandable, not during an unexplained startup sequence.

## State coverage

Every component review must cover:

- Default, pressed, focused, selected, disabled, loading, success, warning, error.
- Long text, localization, and right-to-left layout.
- Dynamic Type and VoiceOver.
- Light, Dark, and increased contrast.
- Pointer, keyboard, and touch where the device supports them.
