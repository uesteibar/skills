# mobile-product-design

Coordinates the design of one product for iOS and Android together. It keeps the task meaning shared and lets each platform present it in its own way.

## When an agent uses it

- You design a flow for both platforms in the same review cycle.
- You port a design from one mobile platform to the other.
- You decide what to share and what to leave different.
- You review parity and justified differences.

For a single-platform task, use the matching platform skill and do not widen the scope.

## How it works

1. Establish the paired scope: deliverable level, platforms, OS versions, sources, protected artifacts, exclusions.
2. Define one shared task and state contract.
3. Specify deliberate platform differences.
4. Design and review both platforms together.
5. Hand off with separate acceptance for each platform.

The contract shares goals, information meaning, terminology, action semantics and recognisable identity. It does not require identical pixels, tap counts or component trees. The skill ships a brief template (`templates/paired-platform-design-brief.md`) and a workflow reference.

## What you need

Load `apple-ios-design` and `material-android-design` first: they own the platform rules, and this skill owns the coordination.

## Limits

It is not a feature specification, brand policy or design-tool guide. Design work does not authorise code changes.
