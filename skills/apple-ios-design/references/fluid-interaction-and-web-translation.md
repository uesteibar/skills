# Fluid Interaction and Web Translation

Use this reference for drawers, sheets, drag/swipe interactions, carousels, reordering, direct manipulation, and Apple-inspired web motion.

## Response and direct manipulation

- Show pressed feedback on pointer/touch down; commit on release.
- During a drag, keep the object attached 1:1 to the pointer and preserve the original grab offset.
- Track position and timestamp history so release velocity is reliable.
- Capture the pointer so tracking continues outside element bounds.
- Use a small movement threshold before committing to a drag direction.
- Detect plausible gestures in parallel, then cancel losers as intent becomes clear.

On the web, Pointer Events and `setPointerCapture` are the foundation. Update compositor-friendly properties such as `transform` and `opacity` in `requestAnimationFrame`.

## Interruptibility

Every user-driven animation must be interruptible and redirectable.

- Never lock input until a transition finishes.
- Retarget from the live presentation value, not the previous logical target.
- Carry current velocity through reversal to avoid a visible stop.
- Separate X and Y motion when their velocities or constraints differ.
- Avoid rigid keyframes for elements people can grab mid-flight.

## Springs

Think in response and damping rather than fixed duration.

- Start routine UI near critical damping: no gratuitous bounce.
- Add modest overshoot only when momentum from a gesture justifies it.
- Tune against travel distance, device size, and interaction purpose.
- Treat sample values as starting points, never platform law.

Historical starting points from Apple fluid-interface examples:

| Interaction | Damping ratio | Response |
| --- | --- | --- |
| Move/reposition | `1.0` | about `0.4 s` |
| Rotation | `0.8` | about `0.4 s` |
| Drawer/sheet release | `0.8` | about `0.3 s` |

Web spring libraries use different parameterizations. Verify mapping rather than assigning Apple’s damping ratio directly to a library’s `damping` coefficient.

## Velocity handoff

The release animation should begin at the gesture’s current velocity. Some APIs accept absolute velocity; others expect velocity normalized by the remaining distance:

```text
relativeVelocity = gestureVelocity / (target - current)
```

Guard against a zero or tiny remaining distance.

## Momentum projection

Choose a snap target from the projected resting position, not only the release point:

```js
function project(initialVelocity, decelerationRate = 0.998) {
  return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate);
}

const projected = currentPosition + project(releaseVelocity);
const target = nearestSnapPoint(projected);
animateSpringTo(target, { velocity: releaseVelocity });
```

Tune the deceleration rate for the product and library. The value above models Apple-like exponential scroll projection; it is not a universal constant.

## Rubber-banding

At boundaries, progressive resistance communicates that input is still recognized:

```js
function rubberband(overshoot, dimension, constant = 0.55) {
  return (overshoot * dimension * constant) /
    (dimension + constant * Math.abs(overshoot));
}
```

Snap back with an interruptible spring. Do not rubber-band controls whose movement could imply a valid destructive or financial action.

## Spatial consistency

- Enter and exit along the same path.
- Anchor transitions to their source control.
- Make intermediate motion point toward the destination.
- Use velocity sign and projected endpoint when deciding commit versus return.
- Preserve continuity when a gesture reverses.

## Multimodal feedback

Combine visual, audio, and haptic feedback only when:

1. **Causality:** the user can identify the triggering action.
2. **Harmony:** feedback occurs at the same perceptual moment.
3. **Utility:** it adds information or confidence.

Reserve stronger haptics for commit, snap, success, warning, or error. Respect system settings and provide a visual path.

## Reduced motion

For `prefers-reduced-motion` or the native Reduce Motion setting, replace large translation, zoom, parallax, and overshoot with a short opacity transition or immediate state change. Maintain response and causality.

For web approximations of material, support `prefers-reduced-transparency` and `prefers-contrast` where available. A solid, bordered surface is preferable to illegible decorative blur.

## Verification

- Press response is immediate.
- Drag tracking remains 1:1 and honors grab offset.
- Release velocity flows into the animation.
- The animation can be grabbed and reversed at any frame.
- Boundaries resist continuously rather than freezing.
- Reduced-motion behavior preserves comprehension.
- Motion remains smooth under representative performance load.
