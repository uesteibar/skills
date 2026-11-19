# posthog-product-analytics

Builds PostHog dashboards from the live project taxonomy, tests every chart before saving it, and verifies the finished dashboard. It also answers whether a connector can reach a given PostHog project.

## When an agent uses it

You ask for a PostHog dashboard or insight, a metric from product analytics, or whether the current connector has access to a named workspace or project.

## How it works

1. Discover the PostHog tools that the connector offers, and read each tool's schema once.
2. Search for an existing dashboard first, to avoid duplicates.
3. Verify the real event and property names with the schema tool. The agent never guesses names.
4. Check the instrumentation code when units or terms are unclear.
5. Design the smallest useful set of insights: volume, a derived rate, the breakdowns you asked for, and duration.
6. Run each query before saving it, then create the dashboard and attach the insights.
7. Refresh every insight and confirm that every tile runs. Return the dashboard URL.

Rules on metrics: exact percentiles (p50, p90, p95, p99) need a numeric raw measurement with a known unit. A bucketed value gives a distribution chart, not a percentile, and the skill forbids guessed midpoints. For access questions, the agent lists organisations and projects, reports the exact boundary ("not accessible through this connector"), and never prints API tokens.

## What you need

A PostHog MCP connector, or another set of tools that exposes dashboards, insights, queries and the data schema.

## Limits

It does not claim a metric exists when the instrumentation only supports a weaker proxy. It reports the instrumentation gap instead.
