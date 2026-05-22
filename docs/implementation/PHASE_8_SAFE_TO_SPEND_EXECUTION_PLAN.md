# Phase 8 — Safe-to-Spend Execution Plan

> Type: Implementation Governance
> Status: **APPROVED — GOVERNS PHASE 8b IMPLEMENTATION**
> Created: 2026-05-23
> Phase 8a (Formula & Contract): COMPLETE
> Phase 8b (Implementation): PENDING CHIEF ARCHITECT GO-AHEAD
> Spec Source: `docs/specs/SAFE_TO_SPEND_MODEL.md`

---

## Goal

Implement the Safe-to-Spend calculation and display (Phase 8b) incrementally and safely. A
freelancer must be able to open the app and immediately see — in one glance — how much they can
spend freely, with full transparency into how the number was calculated.

---

## What Phase 8a Delivered (This Document's Prerequisite)

Phase 8a defined, without touching code:
- The Safe-to-Spend MVP formula (locked)
- All data sources and their liquidity classification (locked)
- Liquid vs non-liquid rules (locked)
- What must NOT be included in Safe-to-Spend (locked)
- All 10 edge cases with named handling rules (locked)
- Transparency requirements and breakdown structure (locked)
- `SafeToSpendResult` value object contract
- `FixedCostEntry` entity contract
- Phase 8b implementation contract (this document)

**No Flutter code was written in Phase 8a. No `lib/` files were modified.**

---

## Current System Context

| System | Status | Phase 8b Touch |
|---|---|---|
| Transaction CRUD (Phases 1–6) | Stable, Frozen | READ ONLY — query expense totals |
| Income Pipeline (Phase 7) | Stable, Frozen | READ ONLY — query received income |
| Dashboard (`DashboardScreen`) | Stable | ADD Safe-to-Spend hero section only |
| Routing (`app_router.dart`) | Frozen | ADD 1 new route (STS Settings) |
| Hive architecture | Stable | ADD 1 new box (`fixedCostsBox`) + adapter |
| `app_box_names.dart` | Stable | ADD `fixedCostsBox` constant |
| `hive_service.dart` | Stable | ADD adapter + box registration at end |
| `transactionsProvider` | Frozen | NONE — READ through repository only |
| `incomeNotifierProvider` | Frozen | NONE — READ through repository only |
| `SharedPreferences` | Stable | ADD 2 new keys (`stsSettings_taxRate`, `stsSettings_anxietyBuffer`) |

---

## Implementation Philosophy

1. **Additive, never destructive.** Safe-to-Spend is a new feature module. Existing income and
   transaction systems are untouched except via read-only access to their repositories.
2. **Formula first, UI second.** The calculation logic must be a pure Dart function/class before
   any UI is written. This enables unit testing independent of Flutter.
3. **No black-box numbers.** Every number displayed to the user must be traceable to a line in
   the breakdown. The `SafeToSpendResult` value object carries all breakdown data.
4. **Spec is the authority.** All 10 edge cases in `SAFE_TO_SPEND_MODEL.md` are binding. If a
   case is not in the spec — escalate to Chief Architect, do NOT guess.
5. **Offline-first by default.** All data is local. No network calls. Zero loading spinners.
6. **Pending/expected income is NEVER liquid.** This rule is the most important in the product.
   It must be enforced at the calculation layer — the UI layer has no override.

---

## Recommended Incremental Sub-Phases

### Phase 8a — Formula & Data Contract ✅ COMPLETE

Goal: Define the contract before touching code.
Deliverables: `SAFE_TO_SPEND_MODEL.md` (locked), this plan, the acceptance checklist.
Quality gate: No code changes. Chief Architect review of formula and contract.

---

### Phase 8b — Calculation Engine

Goal: Pure Dart Safe-to-Spend calculator — testable without UI.

Deliverables:
- `FixedCostEntry` domain entity (`lib/features/safe_to_spend/domain/entities/fixed_cost_entry.dart`)
- `FixedCostRepository` abstract class (`lib/features/safe_to_spend/domain/repositories/`)
- `FixedCostModel` with `@HiveType(typeId: 3)` (`lib/features/safe_to_spend/data/models/`)
- `FixedCostLocalDataSource` + `FixedCostRepositoryImpl` (`lib/features/safe_to_spend/data/`)
- `StsSettings` value object (taxRate, anxietyBuffer — SharedPreferences-backed)
- `StsSettingsRepository` abstract + `StsSettingsRepositoryImpl` (SharedPreferences)
- `SafeToSpendResult` value object (`lib/features/safe_to_spend/domain/entities/`)
- `SafeToSpendCalculator` pure Dart class (`lib/features/safe_to_spend/domain/`)
  - Input: `List<IncomeEntryEntity>`, `List<TransactionEntity>`, `StsSettings`, `List<FixedCostEntry>`
  - Output: `SafeToSpendResult`
  - All 10 edge cases handled per spec
- `AppBoxNames.fixedCostsBox` constant added to `core/constants/app_box_names.dart`
- Adapter + box registered in `core/local_storage/hive_service.dart`

Quality gate: `dart analyze` 0/0/0. `SafeToSpendCalculator` unit tests cover all 10 edge cases.
No UI changes yet.

---

### Phase 8c — Settings Screen

Goal: Allow user to configure tax rate, anxiety buffer, and fixed costs.

Deliverables:
- `StsSettingsScreen` at `/sts-settings`
  - Tax rate slider (0%–40%, step 1%, default 10%)
  - Anxiety buffer BDT input field (≥ 0, default 0)
  - Fixed costs list: label + BDT amount + due day of month
  - Add/edit/delete fixed costs inline (no separate screen needed for MVP)
- Riverpod providers:
  - `stsSettingsProvider` (reads/writes SharedPreferences)
  - `fixedCostNotifierProvider` (StateNotifierProvider for fixed costs list)
  - `fixedCostRepositoryProvider`, `fixedCostDataSourceProvider`
- Route: `RouteNames.stsSettings` → `/sts-settings`
- Settings accessible from dashboard via icon or settings row (not a FAB)

Quality gate: `dart analyze` 0/0/0. Settings persist across hot restart. Default values correct.
All inputs validate (tax rate 0–40, buffer ≥ 0, cost amount > 0, day 1–28).

---

### Phase 8d — Dashboard Hero Number

Goal: Add Safe-to-Spend hero section to the dashboard.

Deliverables:
- `SafeToSpendProvider` (computed/derived Riverpod provider)
  - Watches: `incomeNotifierProvider`, `transactionsProvider`, `stsSettingsProvider`,
    `fixedCostNotifierProvider`
  - Returns: `SafeToSpendResult`
  - Reactive: recalculates on any change to any watched provider
- `SafeToSpendHeroCard` widget:
  - Large hero number (Safe-to-Spend — clamped to ৳0 for display if rawResult < 0)
  - Color state: Green (above buffer) / Amber (below buffer) / Grey (≤ 0)
  - Subtitle copy per `SAFE_TO_SPEND_MODEL.md` Section 9.2
  - Tap → expands breakdown (or navigates to breakdown screen)
- `SafeToSpendBreakdown` widget:
  - Received Income row (+৳XX,XXX)
  - Expenses row (-৳XX,XXX)
  - Liquid Cash subtotal (=৳XX,XXX)
  - Tax Reserve row (-৳X,XXX)
  - Fixed Costs row (-৳X,XXX, with "due in 30 days" note)
  - Anxiety Buffer row (-৳X,XXX)
  - Safe-to-Spend total (=৳XX,XXX)
  - Excluded USD note if applicable
  - Pending income note ("Pending ৳XX,XXX not counted")
- `SafeToSpendHeroCard` inserted ABOVE the `IncomePipelineSummary` on dashboard

CRITICAL: Do NOT modify `IncomePipelineSummary` or existing transaction summary. Only INSERT above.

Quality gate: `dart analyze` 0/0/0. Hero number reactive to income/expense/settings changes.
All 10 edge cases verified manually in device/emulator. Existing dashboard behavior unchanged.

---

### Phase 8e — UX Hardening

Goal: Polish edge cases, copy, and consistency.

Deliverables:
- Horizon Number accessible on second tap / secondary row
  - Clear label: "What could be available" (NOT "Your balance")
  - Pending × 0.8 and Expected × 0.3 shown with discount labels
- USD exclusion note in breakdown (if applicable)
- Soft warning when marking income received with future date (EC-04)
- Empty income state inline callout in STS hero (EC-01)
- "Pause mode" grey state copy (EC-03)
- Tap-to-navigate from hero card to STS settings
- Completed `mounted` guards on all async operations in settings screen
- Double-submit guard on fixed cost save

Quality gate: `dart analyze` 0/0/0. All 10 edge cases pass. UX matches copy rules in spec.
No red color anywhere in STS feature.

---

## Dependency Order

```
8a — Formula & Data Contract ✅
     └── 8b — Calculation Engine      (depends on: IncomeEntryEntity, TransactionEntity)
          └── 8c — Settings Screen    (depends on: FixedCostEntry, StsSettings from 8b)
               └── 8d — Dashboard     (depends on: SafeToSpendProvider from 8b+8c)
                    └── 8e — UX Hard. (depends on: all above)
```

Do NOT start a sub-phase before its dependency is analyzer-clean and manually verified.

---

## Feature Module Structure

```
lib/features/safe_to_spend/
├── data/
│   ├── datasources/
│   │   ├── fixed_cost_local_data_source.dart   (abstract + Hive impl)
│   │   └── sts_settings_data_source.dart       (abstract + SharedPreferences impl)
│   ├── models/
│   │   └── fixed_cost_model.dart               (@HiveType typeId: 3)
│   └── repositories/
│       ├── fixed_cost_repository_impl.dart
│       └── sts_settings_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── fixed_cost_entry.dart               (pure Dart)
│   │   ├── sts_settings.dart                   (pure Dart value object)
│   │   └── safe_to_spend_result.dart           (pure Dart value object)
│   ├── repositories/
│   │   ├── fixed_cost_repository.dart          (abstract)
│   │   └── sts_settings_repository.dart        (abstract)
│   └── safe_to_spend_calculator.dart           (pure Dart calculation logic)
└── presentation/
    ├── providers/
    │   └── safe_to_spend_providers.dart
    └── views/
        ├── sts_settings_screen.dart
        └── widgets/
            ├── safe_to_spend_hero_card.dart
            └── safe_to_spend_breakdown.dart
```

---

## Frozen Systems

| System | Allowed Touch | Forbidden |
|---|---|---|
| `features/transactions/` | READ data via existing providers | Any modification |
| `features/income/` | READ data via existing providers | Any modification |
| `DashboardScreen` | INSERT `SafeToSpendHeroCard()` above IncomePipelineSummary | Modify existing cards |
| `config/router/app_router.dart` | ADD 1 new GoRoute | Restructure existing routes |
| `config/router/route_names.dart` | ADD `stsSettings` constant | Rename existing |
| `core/constants/app_box_names.dart` | ADD `fixedCostsBox` | Rename/remove existing |
| `core/local_storage/hive_service.dart` | ADD adapter + box at end | Change existing registration order |
| `transactionsProvider` | NONE | Any modification |
| `incomeNotifierProvider` | NONE | Any modification |
| `TransactionModel` | NONE | Any field/typeId modification |
| `IncomeModel` | NONE | Any field/typeId modification |

---

## UX Preservation Rules

1. Dashboard hero card must not crowd out the income pipeline summary.
2. No red for any Safe-to-Spend state — use Green / Amber / Grey.
3. No scolding language. "Pause mode" not "You overspent".
4. Horizon Number is secondary and clearly labeled — never the hero.
5. Breakdown is opt-in via tap — not expanded by default.
6. Safe-to-Spend of ৳0 displays as ৳0, not as a negative number.
7. Settings accessible from dashboard via non-intrusive entry point (icon or row).

---

## Architecture Preservation Rules

1. `SafeToSpendCalculator` takes pure domain entities as input — no Hive, no Flutter, no providers.
2. `SafeToSpendResult` is a value object — immutable, no side effects.
3. Domain entities (`fixed_cost_entry.dart`, `sts_settings.dart`, `safe_to_spend_result.dart`) have zero framework imports.
4. Presentation never imports from `data/` directly — wire through Riverpod providers.
5. All colors via `AppColors` — no raw hex anywhere.
6. Use `withValues(alpha: x)` — NEVER `withOpacity(x)`.
7. Use `IdGenerator.uniqueId()` for all `FixedCostEntry` IDs.
8. All files under 300 lines. Extract sub-widgets when `build()` exceeds 100 lines.
9. Use package imports: `package:pocketa_v2/...` — no relative imports.
10. Safe-to-spend feature is isolated — no cross-feature imports into income or transaction features.
11. `FixedCostModel` typeId MUST be `3` — never reuse a typeId.

---

## Quality Gates

Each sub-phase must pass all gates before the next begins:

| Gate | Requirement |
|---|---|
| Analyzer | `dart analyze` → 0 errors, 0 warnings, 0 infos |
| Regression — transactions | Existing transaction CRUD works end-to-end |
| Regression — income | Existing income pipeline works end-to-end |
| Regression — dashboard | Existing dashboard summary renders correctly |
| Regression — routing | Existing routes (onboarding, splash, transactions, income) work |
| Formula accuracy | SafeToSpendCalculator returns correct result for all 10 EC cases |
| Reactivity | Hero number updates immediately on income/expense/settings change |
| Offline | Feature works with airplane mode enabled |
| File size | No file over 300 lines |
| No future scope | No Phase 9+ logic introduced (no ML, no bank sync, no auto-detection) |
| No banned patterns | No raw hex, no `withOpacity`, no `ChangeNotifier`, no direct Hive from UI |
| Transparency | Breakdown shows every addend and deduction with labels |
| No red | No red color anywhere in Safe-to-Spend feature |

---

## Rollback Strategy

**If a frozen system is mutated:**
1. Stop immediately — do NOT push forward.
2. `git diff` to identify the mutation.
3. Revert only the mutation.
4. Re-run `dart analyze`.
5. Report to Chief Architect before continuing.

**If dashboard becomes cluttered after 8d:**
1. Stop — do NOT add more UI elements.
2. Simplify hero card — reduce visual weight.
3. Get Chief Architect approval before shipping.

---

## Final Validation Requirements

Before Phase 8 is marked complete, all of the following must be true:

1. All items in `docs/implementation/PHASE_8_ACCEPTANCE_CHECKLIST.md` are checked.
2. `dart analyze` → 0/0/0.
3. Existing transaction flows work end-to-end.
4. Existing income pipeline flows work end-to-end.
5. Safe-to-Spend hero number visible on dashboard within 3 seconds of opening app.
6. Breakdown accessible within 1 tap from hero number.
7. All 10 edge cases verified manually in device/emulator.
8. No pending/expected income included in Safe-to-Spend primary number.
9. No red color anywhere in Safe-to-Spend feature.
10. Settings (tax rate, buffer, fixed costs) persist across app restarts.
11. Completion report delivered to Chief Architect per `docs/governance/AGENT_WORKFLOW.md`.
