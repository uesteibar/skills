# material-android-design

Guidance for designing, specifying and auditing Android interfaces with Material 3 and current Android platform guidance. It keeps product identity while making navigation, controls, adaptation and feedback feel native.

## When an agent uses it

- You design or review an Android phone, tablet or foldable UI.
- You translate an iOS product into a first-class Android experience.
- You specify behaviour for Compose, Views, React Native, Expo or another stack.

It does not apply to web, desktop, Wear or TV.

## How it works

1. Lock the scope and inspect the evidence (screens, product model, target devices).
2. Establish hierarchy and navigation.
3. Establish the Material theme (colour, type, surfaces). Dynamic colour, branded themes and Material 3 Expressive are separate decisions.
4. Design complete state families, so that each screen covers all of its states.
5. Validate Android mechanics against the platform.
6. Report and hand off, using `templates/android-design-review.md`.

Before a version-sensitive recommendation, the agent reads `references/sources-and-version-policy.md` and checks the target Android version, SDK, window size and installed libraries.

## What you need

- Access to current Material and Android documentation.
- For paired iOS and Android work, also load `mobile-product-design` and `apple-ios-design`. Do not apply Apple conventions to Android.

## Limits

It is design guidance. It does not authorise implementation.
