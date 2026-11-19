# Widgets, Extensions, Notifications, and App Clips

These surfaces are not miniature versions of the full app. Each has a focused system role, constrained interaction model, and limited space or execution time.

## Widgets

- Make the content glanceable and immediately useful.
- Prioritize one clear value proposition per widget family.
- Adapt composition rather than simply scaling one layout.
- Use system widget backgrounds, margins, typography, and tinting behavior.
- Keep information current and make stale or unavailable data understandable.
- Use deep links to open the relevant destination in the app.
- Support interactive controls only where the platform permits and the action can complete safely without hidden context.
- Avoid scroll views, dense navigation, lengthy text, and decorative chrome.
- Test StandBy, tinted, dark, and accessory presentations where relevant.

## App extensions

- Keep the extension focused on the host context and immediate task.
- Reuse app identity without forcing full-app navigation into the extension.
- Respect host-app size, appearance, privacy, and lifecycle constraints.
- Complete quickly, communicate progress honestly, and provide a clear path back to the host.
- Share data through supported containers and minimize sensitive-data exposure.

## Share extensions

Show the selected content and destination clearly. Keep options concise, preserve draft state on recoverable failure, and confirm completion without trapping the user.

## Notifications

- Ask for authorization only after explaining value in context.
- Keep notification text timely, specific, and privacy-conscious.
- Use categories and actions for genuinely useful responses.
- Deep-link to the exact related content.
- Do not expose sensitive content on the Lock Screen by default when the product domain makes that risky.
- Avoid using notifications as generic re-engagement pressure.

## Live Activities and ongoing status

Use a Live Activity for an event with a meaningful beginning, changing current state, and expected end. Keep updates compact, current, and aligned with the system’s presentation families. Do not use it for indefinite dashboards or advertising.

## App Clips

- Center the clip on one immediate task.
- Minimize setup, permissions, account creation, and navigation.
- Preserve continuity when the full app is installed.
- Use familiar payment, sign-in, and location mechanisms when they reduce friction and maintain trust.

## Launch and handoff

Extensions, widgets, notifications, and App Clips should deep-link into a coherent app state. Preserve context, avoid duplicate confirmation, and make it clear when responsibility moves between a system surface and the app.

## Review checklist

- Purpose is understandable without opening the full app.
- Interaction fits the surface’s constraints.
- Privacy is appropriate for glanceable/system-visible content.
- Deep links land correctly.
- Loading, stale, offline, and unavailable states are defined.
- Dynamic Type, VoiceOver, color, and tinting remain usable.
