---
name: mobile-product-design
description: Use when designing iOS and Android together.
version: 2.0.0
author: uesteibar, Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [mobile, ios, android, cross-platform, design]
    related_skills: [apple-ios-design, material-android-design]
---

# Mobile Product Design

Coordinate the design of one product for iOS and Android. Preserve shared task semantics while choosing deliberate, platform-appropriate presentations. This skill covers paired design and review only: it is not a feature specification, brand policy, design-tool manual, or implementation guide.

## When to Use

- Designing a flow for both iOS and Android in the same review cycle.
- Porting a design from one mobile platform to the other.
- Deciding which behaviour and presentation to share across mobile platforms.
- Reviewing task parity and justified differences between platform versions.

For an explicitly single-platform task, use the relevant platform skill without expanding the scope. Retrieve unspecified platform scope from the project; if it remains unknown, state the assumption or ask one question.

## Prerequisites

Load `apple-ios-design` and `material-android-design` once for paired work. They own platform conventions; this skill owns coordination, comparison, and acceptance. Read the current project requirements and design evidence. Keep product-specific features, copy, palettes, and approved decisions in project-owned documents.

Use design-tool skills only when inspecting or editing their artifacts. Design work does not authorize application code changes or a framework migration.

## Cross-platform design contract

Share user goals, information meaning, terminology, action semantics, data continuity, and recognisable identity. Do not require identical pixels, tap counts, or component trees.

Allow navigation, action placement, controls, typography, icons, surfaces, modal presentation, and feedback to differ where platform guidance or task quality justifies it. Map semantic roles rather than forcing shared raw measurements or asset glyphs. Do not copy Apple mechanics to Android or treat Android as a reskin of an approved iOS composition.

User scope and approved product intent establish the task. Current platform guidance governs each platform's mechanics. Runtime evidence establishes what the chosen stack supports. Explain conflicts rather than averaging conventions or presenting product preferences as OS rules.

## Procedure

### 1. Establish paired scope and authority

Name the deliverable level, target platforms and OS versions, device/window scope, current sources, protected artifacts, and exclusions. Preserve existing approved directions. If one platform's evidence is missing, name the gap rather than inventing it.

Completion: one bounded brief with explicit assumptions and sources.

### 2. Define one shared task and state contract

Record the user goal, required information, action meanings, entry and exit paths, cancellation, recovery, and state continuity. Use current product evidence; label illustrative content. Select only the state coverage needed for the requested comparison.

Completion: one shared state matrix without a presumed platform composition.

### 3. Specify deliberate platform differences

For each relevant concern, record the shared invariant, iOS presentation, Android presentation, and reason. Cover navigation and return behaviour, input and transient surfaces, semantic theme roles, and adaptation as relevant. Use each platform's own units, system regions, accessibility behaviour, and current components.

Completion: every material difference is justified, not accidental.

### 4. Design and review the platforms together

Use equivalent content and state semantics for the paired screens. Either platform may lead exploration; both need a first-class review within the agreed scope. Compare complete screens before deciding which components or layouts can be shared. Preserve originals and manual changes while exploring.

Review each platform against its own guidance, then compare task success, information completeness, action discoverability, recovery, and recognisable identity. Do not favour a version merely because it received more refinement.

Completion: evidence-backed platform findings and a separate parity assessment.

### 5. Hand off with separate acceptance

Record design approval and runtime verification independently for iOS and Android. State what remains shared and where platform-specific presentation is intentional. Keep accessibility, text scaling, appearance, system insets, input, Back behaviour, and adaptation either evidenced within scope or explicitly unverified/out of scope.

A mockup specifies behaviour; it does not prove native rendering or runtime interaction. If implementation is requested separately, inspect actual stack support before proposing libraries or migrations.

Completion: the requested design or specification, plus an honest per-platform acceptance ledger.

## Supporting Files

- [Paired-platform workflow](references/paired-platform-design-workflow.md) — decision matrix and platform/parity review rubric.
- [Paired design brief](templates/paired-platform-design-brief.md) — reusable scope, state, difference, and acceptance template.

## Pitfalls

- Making one platform's composition the mandatory template for the other.
- Sharing visual constants merely because the application shares code.
- Inventing product functionality to fill the second platform's mockup.
- Treating platform conventions as permission to change product semantics.
- Reporting cross-platform completion from one platform's approval or tests.

## Verification

- [ ] Platforms, deliverable, protected artifacts, and exclusions are explicit.
- [ ] Shared tasks, content, action meanings, and continuity are preserved.
- [ ] Platform differences have reasons and appropriate guidance.
- [ ] Both in-scope versions have design evidence and a parity review.
- [ ] Approval, runtime evidence, and outstanding checks are separate per platform.
- [ ] No product-specific feature or brand policy has been embedded in this skill.
