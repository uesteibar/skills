---
name: posthog-product-analytics
description: Use when querying PostHog analytics or verifying project access.
---

# PostHog product analytics

Build dashboards from the live project taxonomy, validate every chart before saving it, and verify the completed dashboard with fresh results.

## Workflow

1. **Discover the available PostHog tools.** Search narrowly for dashboard, insight, query, and schema tools. Run `info` once for every tool whose schema is not already in context. If `info` returns a `hint`, drill into that field with `schema` before populating it.
2. **Check for an existing dashboard.** Search dashboards by the requested metric/domain before creating a new one. Decide whether the request means a new dashboard or extending an established one; avoid accidental duplicates.
3. **Verify the collected-data taxonomy.** Use `read-data-schema` in this order:
   - events/actions;
   - properties for each relevant event;
   - observed property values for every filter or breakdown.
   Never construct analytics from guessed canonical names.
4. **Inspect instrumentation when semantics are unclear.** If the relevant repository is available, cross-check the event-emission code and observability contract. This is especially useful for units, bucket boundaries, success/failure terminal events, and privacy transformations.
5. **Design the smallest useful set of insights.** Common dashboard coverage:
   - raw volume/outcomes over time;
   - derived rate over time (for example, `successful / (successful + failed)`);
   - the requested categorical breakdowns;
   - latency or duration trends.
6. **Test each query before saving.** Run typed `query-*` tools when possible. Confirm the result has plausible columns, breakdown values, date interval, and non-empty recent data. Use SQL only for multi-event correlation or calculations typed queries cannot express.
7. **Create and attach.** Create the dashboard, then save validated insights with the complete dashboard ID list. Use clear names and descriptions that define numerator/denominator, time range, and known limitations.
8. **Verify the artifact.** Run every dashboard insight with blocking or force-blocking refresh. Confirm every tile executes and surface the dashboard URL returned by PostHog.

## Project and access verification

Use this workflow when the user asks whether the current connector can access a named PostHog workspace or project:

1. Read the connector's active-environment metadata, but do not treat the active project as the full access list.
2. Discover and inspect the schemas for the organization-listing and project-listing tools before calling them.
3. List accessible organizations, then list projects in the current organization. If other organizations are accessible, inspect them through the supported organization/project context workflow and restore the original context before finishing.
4. Report the exact boundary: “not accessible through this connector/account/region” is justified when absent; “the project does not exist” is not.
5. Do not switch the active project merely to answer an access question when listing is sufficient.
6. Never reproduce project API tokens, personal API keys, or other credential fields that may appear in environment metadata or project-list responses. Report only organization/project names, IDs when useful, region, and access outcome.

## Percentile and duration metrics

- True p50/p90/p95/p99 calculations require a **numeric raw measurement** with a known unit, such as `duration_ms`.
- A categorical value such as `1_5s` or `5_15s` supports distribution-by-bucket charts, but **does not support exact percentiles**.
- Never convert buckets to guessed midpoints or label an approximation as p9x.
- When raw duration is absent, preserve task momentum: build the reliable outcome/source charts, add a clearly labeled duration-bucket fallback if useful, and report the instrumentation gap precisely.
- Recommend adding one numeric duration property consistently to all terminal outcomes. Keep privacy policy and cardinality in mind; duration is usually low sensitivity and low cardinality as a numeric measure.

## Query design notes

- Default to the last 30 days unless the product context justifies another range. For newly launched instrumentation, a 90-day view can make rollout timing obvious but may contain long zero periods.
- Pick intervals based on range and expected volume. Sparse new events often read better daily than weekly; validate the chart rather than relying only on defaults.
- For success rates, use terminal outcomes rather than submissions unless product semantics explicitly define abandoned attempts as failures.
- Breakdown properties must be present on every series being compared, or the resulting chart can silently omit combinations.
- Name formulas explicitly and use `percentage_scaled` only for ratios in the 0–1 range.

## Pitfalls

- Do not claim a requested metric is implemented when instrumentation only supports a weaker proxy.
- Do not save untested insights directly to a dashboard.
- Do not infer property units from names alone; inspect event code or authoritative documentation.
- Do not stop after entity creation. Freshly execute the completed dashboard and verify all tiles.
- Do not duplicate an existing operational dashboard without checking whether extension is the better interpretation.
