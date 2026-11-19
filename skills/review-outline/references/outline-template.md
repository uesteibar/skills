# Review outline template

Fill every section. Keep the headings in this order. Replace the example
values; they show the expected density. Translate headings into the output
language. In the Size line, list only classes with at least one file. Rating
scales are in SKILL.md, "Header ratings".

````md
## <PR title or change name>

**What and why:** <one line: the outcome and the reason, or "Intent: not stated">
**Size:** 23 files (+412 / −96) · 9 behaviour · 3 refactor · 6 tests · 5 generated
**Risk:** Medium (new column read on the request path) · **Blast radius:** Core (brand creation) · **Review effort:** 3/5
**Scope:** Requested <one line> · Actual <one line> · Extra <files or behaviour outside the request, or "none">

### 1. Modules affected
| Cohort | Change | Type |
|---|---|---|
| Database | `brands.locale` column + index | behaviour |
| Brand service | Stores and validates the locale | behaviour |
| Brand Setup UI | Language picker in step 2 | behaviour |
| Shared utils | `formatDate` moved to `lib/dates` | refactor |

### 2. Data and migrations
- `+` `brands.locale text not null default 'en'` (`migrations/20261113_brand_locale.sql`)
- Backfill: none; the default covers existing rows.
- Revert: drop column; no data loss outside the new field.
- Rollout: old code ignores the column; safe to deploy migration first.

### 3. Functional and architecture changes
- New contract: `POST /api/brands` accepts optional `locale` (`app/api/brands/route.ts`).
- New background task `syncBrandTask` replaces the inline sync.
- Feature flag: `brand-locale` (default off).

### 4. Performance
- Brand list query now joins `brand_events` with no limit (`lib/brands/repo.ts`) (inferred: list size grows with events).
- No changes to caching. Checked: cache helpers, revalidation calls.

### 5. User flows
**Create a brand with a language**
| # | User | System | Change |
|---|---|---|---|
| 1 | Opens Brand Setup | Shows the form | — |
| 2 | Picks a language | Validates the locale | `+` |
| 3 | Saves | Stores the brand, starts the background sync (before: synced inline) | `~` |

### 6. Data flow
```
BrandForm → POST /api/brands → ~BrandService.create → brands (+col locale)
                                     └→ +syncBrandTask → brand_events
```

### 7. Tests
| Scenario | Kind | Real vs mocked | Covers |
|---|---|---|---|
| Create brand with and without locale | integration | real DB | Brand service |
| Invalid locale is rejected with 400 | integration | real DB | Brand service |
| Sync task retries on provider error | unit | provider mocked | Brand service |
- **Gaps:** no test for the language picker; the sync test mocks the provider, so the real payload is unverified.
- **CI:** 14 passed, 1 skipped (`integration` runs only in the merge queue). Source: `gh pr checks`.

### 8. Where to look
- **Read carefully:** `lib/brands/service.ts` (locale validation and default), `migrations/20261113_brand_locale.sql` (lock on a large table).
- **Skim:** `lib/dates/*` (pure move), `pnpm-lock.yaml` (generated).
````

## PR mode

Wrap the same content in a collapsed block below the PR's goal:

```md
<details>
<summary>Review outline</summary>

…sections 1–8…

</details>
```
