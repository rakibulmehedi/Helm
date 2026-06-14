# Phase 8 — Safe-to-Spend Acceptance Checklist

> Type: Implementation Governance
> Status: ACTIVE — Complete all items before marking Phase 8 done
> Created: 2026-05-23
> Spec Source: `docs/specs/SAFE_TO_SPEND_MODEL.md`
> Plan Source: `docs/implementation/PHASE_8_SAFE_TO_SPEND_EXECUTION_PLAN.md`

Instructions: Check each item manually or via analyzer. Do NOT mark Phase 8 complete until all
items in "Final Ship Criteria" are checked. Use sub-phase checks as internal quality gates.

---

## Phase 8b — Calculation Engine Checks

### SafeToSpendCalculator — Formula Correctness

- [ ] `SafeToSpendCalculator` takes pure domain inputs: `List<IncomeEntryEntity>`, `List<TransactionEntity>`, `StsSettings`, `List<FixedCostEntry>`
- [ ] `SafeToSpendCalculator` returns `SafeToSpendResult`
- [ ] `Liquid_Cash = Σ received BDT income − Σ all expenses` — correct
- [ ] `Tax_Reserve = Σ received BDT income × taxRate` — correct (applied to income, not liquid cash)
- [ ] `Fixed_Costs_Due = Σ fixed costs with dueDayOfMonth due within 30-day rolling window` — correct
- [ ] `Safe_to_Spend = Liquid_Cash − Tax_Reserve − Fixed_Costs_Due − Anxiety_Buffer` — correct
- [ ] `rawSafeToSpend` stored (can be negative); `safeToSpend` clamped to ≥ 0 in display logic
- [ ] `Horizon_Number = safeToSpend + (pendingIncome × 0.8) + (expectedIncome × 0.3)` — correct

### SafeToSpendCalculator — Liquidity Rules Enforcement

- [ ] Pending income (`status == pending`) is NEVER included in `Liquid_Cash` or `Safe_to_Spend`
- [ ] Expected income (`status == expected`) is NEVER included in `Liquid_Cash` or `Safe_to_Spend`
- [ ] USD income entries (any status) are NEVER included in `Liquid_Cash` (excluded, tracked separately)
- [ ] Only `TransactionType.expense` entries reduce `Liquid_Cash` (income-type transactions not double-counted)
- [ ] `TransactionType.income` transactions (old system) are NOT included in received income calculation — only `IncomeEntryEntity` with `status == received` counts

### SafeToSpendCalculator — Edge Case Coverage

- [ ] **EC-01** (no income): `Liquid_Cash = 0.0`, result correctly shows negative or zero
- [ ] **EC-02** (no expenses): Calculation uses only income, result is positive if income received
- [ ] **EC-03** (negative result): `rawSafeToSpend < 0` correctly computed; `safeToSpend = 0.0` clamped; `SafeToSpendResult.rawSafeToSpend` preserved
- [ ] **EC-04** (future receivedDate): Entry included if `status == received` regardless of `receivedDate` date value
- [ ] **EC-05** (status edited to un-received): Entry removed from `totalReceivedIncomeBdt` upon notifier update
- [ ] **EC-06** (received entry deleted): Entry removed from calculation upon notifier update
- [ ] **EC-07** (no fixed costs due in window): `fixedCostsDue = 0.0`
- [ ] **EC-08** (tax rate = 0%): `taxReserve = 0.0`
- [ ] **EC-09** (no anxiety buffer): `anxietyBuffer = 0.0` (default)
- [ ] **EC-10** (USD + BDT mixed): BDT entries included, USD entries counted in `excludedUsdIncome` only

### FixedCostEntry Domain Entity

- [ ] `FixedCostEntry` has: `id`, `label`, `amount`, `dueDayOfMonth`, `createdAt`
- [ ] `FixedCostEntry` has zero Flutter or Hive framework imports (pure Dart)
- [ ] `FixedCostEntry` has `copyWith()` method
- [ ] `dueDayOfMonth` range: 1–28 (enforced at validation layer)

### FixedCostModel Data Layer

- [ ] `FixedCostModel` uses `@HiveType(typeId: 3)` — not 0, 1, or 2
- [ ] HiveField indices: 0=id, 1=label, 2=amount, 3=dueDayOfMonth, 4=createdAt
- [ ] No HiveField indices changed after first write
- [ ] `fixed_cost_model.g.dart` is generated, not manually edited
- [ ] `AppBoxNames.fixedCostsBox` constant added to `core/constants/app_box_names.dart`
- [ ] Adapter + box registered at end of `hive_service.dart` initialization

### StsSettings Value Object

- [ ] `StsSettings` is a pure Dart value object: `taxRate` (double), `anxietyBuffer` (double)
- [ ] Default `taxRate = 0.10` (10%)
- [ ] Default `anxietyBuffer = 0.0`
- [ ] `StsSettings` has zero framework imports
- [ ] `StsSettingsRepository` abstract class defined
- [ ] `StsSettingsRepositoryImpl` persists to `SharedPreferences` with keys: `stsSettings_taxRate`, `stsSettings_anxietyBuffer`

---

## Phase 8c — Settings Screen Checks

### Functional

- [ ] `StsSettingsScreen` accessible at route `/sts-settings`
- [ ] Tax rate slider: range 0%–40%, step 1%, default 10%
- [ ] Anxiety buffer input: BDT amount, ≥ 0, default 0
- [ ] Fixed costs list displays all stored `FixedCostEntry` items
- [ ] User can add a new fixed cost: label (required), amount (required, > 0), due day (1–28, required)
- [ ] User can delete a fixed cost
- [ ] User can edit an existing fixed cost
- [ ] All settings persist to storage and survive app hot restart
- [ ] Settings changes reflect immediately in Safe-to-Spend hero (reactive)

### Validation

- [ ] Tax rate: 0%–40% enforced (slider prevents out-of-range)
- [ ] Anxiety buffer: must be ≥ 0 (negative not allowed)
- [ ] Fixed cost label: non-empty, max 100 chars
- [ ] Fixed cost amount: > 0
- [ ] Fixed cost due day: 1–28 (not 29, 30, 31 — month-safe range)

---

## Phase 8d — Dashboard Hero Number Checks

### Safe-to-Spend Display

- [ ] Safe-to-Spend hero number is the largest, most prominent element on dashboard
- [ ] Displayed value is clamped to ৳0 minimum (rawResult < 0 shows ৳0, not a negative)
- [ ] Color: Green when `safeToSpend > anxietyBuffer`
- [ ] Color: Amber when `0 < safeToSpend ≤ anxietyBuffer`
- [ ] Color: Grey/Neutral when `safeToSpend ≤ 0` (raw result ≤ 0)
- [ ] ❌ NO RED color in any Safe-to-Spend state
- [ ] Subtitle copy matches spec Section 9.2 (calming, non-judgmental)
- [ ] Amount formatted with `NumberFormat` and ৳ symbol

### Breakdown (On Tap)

- [ ] Tapping hero number expands breakdown
- [ ] Breakdown rows: Received Income (+), Expenses (−), Liquid Cash (=), Tax Reserve (−), Fixed Costs Due (−), Anxiety Buffer (−), Safe-to-Spend (=)
- [ ] Each row labeled clearly (no bare numbers)
- [ ] Pending income exclusion noted: "Pending ৳XX,XXX not counted until received"
- [ ] USD exclusion noted if applicable: "USD income (X entries) not included — convert to BDT first"
- [ ] No row shows a missing calculation (all SafeToSpendResult fields are populated)

### Horizon Number

- [ ] Horizon Number is NOT shown by default
- [ ] Horizon Number accessible on second tap or explicit "see more" action
- [ ] Horizon Number labeled "What could be available" — NOT "Your balance" or "Total"
- [ ] Pending income shown with "(×0.8)" discount label
- [ ] Expected income shown with "(×0.3)" discount label
- [ ] Horizon Number NEVER used as the primary hero number

### Reactivity

- [ ] Hero number updates immediately when a received income entry is added
- [ ] Hero number updates immediately when a received income entry is deleted
- [ ] Hero number updates immediately when an income entry status changes
- [ ] Hero number updates immediately when an expense transaction is added/deleted
- [ ] Hero number updates immediately when tax rate setting is changed
- [ ] Hero number updates immediately when anxiety buffer is changed
- [ ] Hero number updates immediately when a fixed cost is added/edited/deleted
- [ ] No manual refresh or restart required for any update

### Edge Cases — UI Display

- [ ] EC-01 (no income): Callout prompts user to add received income — no raw ৳0 hero without context
- [ ] EC-03 (negative result): Shows ৳0 hero with "reserve mode" copy; Horizon Number visible
- [ ] EC-04 (future receivedDate): Entry included; soft note in breakdown "Marked received on [date]"
- [ ] EC-10 (USD + BDT): USD exclusion note present in breakdown

---

## Phase 8e — UX Hardening Checks

### Copy Rules

- [ ] No "overspent" language anywhere
- [ ] No "budget exceeded" language anywhere
- [ ] No "warning" language for low balance
- [ ] No red text anywhere in Safe-to-Spend feature
- [ ] "Pause mode" used (not "danger zone" or "overdraft")
- [ ] "Freely" used in positive balance copy (key behavioral word)
- [ ] "Protected" used in reserve copy (empowerment framing)

### Interaction Quality

- [ ] Breakdown accessible within 1 tap from hero number
- [ ] Settings accessible from dashboard without opening a nav drawer (1 tap or prominent entry)
- [ ] Marking income received with future date triggers soft warn (not a hard block)
- [ ] Double-submit guard on fixed cost add/edit save button
- [ ] `mounted` guard on all async operations in settings screen

---

## Architecture Checks

### Feature Isolation

- [ ] All Safe-to-Spend files live exclusively under `lib/features/safe_to_spend/`
- [ ] No file in `lib/features/transactions/` has been modified
- [ ] No file in `lib/features/income/` has been modified
- [ ] Safe-to-Spend reads income data via `incomeNotifierProvider` — does NOT import income data layer directly
- [ ] Safe-to-Spend reads transaction data via `transactionsProvider` — does NOT import transaction data layer directly
- [ ] No shared base class created across income, transaction, and safe-to-spend features

### Domain Layer Purity

- [ ] `fixed_cost_entry.dart` has zero Flutter or Hive framework imports (pure Dart)
- [ ] `sts_settings.dart` has zero Flutter or Hive framework imports (pure Dart)
- [ ] `safe_to_spend_result.dart` has zero Flutter or Hive framework imports (pure Dart)
- [ ] `safe_to_spend_calculator.dart` has zero Flutter or Hive framework imports (pure Dart)
- [ ] `FixedCostRepository` is abstract — no implementation logic

### Naming Conventions

- [ ] Feature folder: `safe_to_spend/` (snake_case)
- [ ] Screen: `StsSettingsScreen` (PascalCase + Screen suffix)
- [ ] Model: `FixedCostModel` (PascalCase + Model suffix)
- [ ] Entities: `FixedCostEntry`, `StsSettings`, `SafeToSpendResult` (PascalCase + Entity/Result suffix)
- [ ] Calculator: `SafeToSpendCalculator` (PascalCase)
- [ ] Providers: `safeToSpendProvider`, `fixedCostNotifierProvider`, etc. (camelCase + Provider)
- [ ] Notifier: `FixedCostNotifier` (PascalCase + Notifier suffix)
- [ ] Repository: `FixedCostRepository`, `StsSettingsRepository` (PascalCase + Repository suffix)
- [ ] DataSource: `FixedCostLocalDataSource`, `StsSettingsDataSource` (PascalCase + DataSource suffix)

### Code Quality

- [ ] All files under 300 lines
- [ ] No file contains a `build()` method exceeding 100 lines without sub-widget extraction
- [ ] All imports use `package:helm_v2/...` (no relative imports)
- [ ] No `withOpacity()` anywhere — uses `withValues(alpha:)` instead
- [ ] `IdGenerator.uniqueId()` used for all `FixedCostEntry` IDs
- [ ] All async operations wrapped in `try/catch` with user-facing SnackBar error handling

---

## State Management Checks

### Riverpod

- [ ] All Safe-to-Spend providers live in `lib/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart`
- [ ] `FixedCostNotifier` extends `StateNotifier<List<FixedCostEntry>>`
- [ ] `safeToSpendProvider` is a derived provider (watches income + transaction + settings + fixed costs)
- [ ] `safeToSpendProvider` returns `SafeToSpendResult`
- [ ] No Safe-to-Spend provider placed in `application/providers/` or any other feature's provider file
- [ ] No `ChangeNotifier` used anywhere in safe_to_spend feature
- [ ] No raw `setState` used for Safe-to-Spend business logic

---

## Offline-First Checks

- [ ] `fixedCostsBox` opened before any fixed cost provider reads from it (correct initialization order)
- [ ] Safe-to-Spend feature tested manually in airplane mode — all features work
- [ ] `StsSettings` loaded from SharedPreferences on app startup (no async gap)
- [ ] No network calls in any Safe-to-Spend file
- [ ] `FixedCostModel` has no `syncStatus`, `serverId`, `isSynced`, or `isDirty` fields

---

## Routing Checks

- [ ] Route `/sts-settings` → `StsSettingsScreen` defined and working
- [ ] `RouteNames.stsSettings` constant added to `route_names.dart`
- [ ] All navigation uses `context.pushNamed()` or `context.goNamed()` with named routes
- [ ] Existing routes (onboarding, splash, transactions, income) still work

---

## Analyzer Checks

- [ ] `dart analyze` → 0 errors
- [ ] `dart analyze` → 0 warnings
- [ ] `dart analyze` → 0 infos
- [ ] No `// ignore:` suppressions added to safe_to_spend files
- [ ] No `// ignore_for_file:` suppressions added to safe_to_spend files

---

## Governance Checks

### No Future-Phase Logic

- [ ] No bank balance sync code present
- [ ] No auto-detection of recurring expenses (no pattern matching on transactions)
- [ ] No AI-driven forecasting code present
- [ ] No multi-currency conversion math present
- [ ] No Virtual Wallet logic present
- [ ] No cloud sync scaffolding present (no Supabase, no syncStatus fields)
- [ ] No "Can I buy this?" simulator logic present
- [ ] No ML models or external API calls present
- [ ] No chart/visualization code (charts deferred — summary only)
- [ ] `FixedCostEntry` has no `endDate`, `recurrenceType`, or `frequency` fields (monthly-only MVP)

### No Banned Patterns

- [ ] No raw hex colors in any safe_to_spend file
- [ ] No red color in any Safe-to-Spend UI state
- [ ] No `ChangeNotifier` in any safe_to_spend file
- [ ] No direct Hive calls from presentation layer
- [ ] No god-files over 500 lines
- [ ] No circular imports between safe_to_spend and other features
- [ ] No packages added to `pubspec.yaml` without Chief Architect approval

### Doc Updates Required Before Ship

- [ ] `docs/tracking/TASKS.md` updated — Phase 8 sub-phases marked complete
- [ ] `docs/tracking/CURRENT_SPRINT.md` updated — Phase 8 marked done, next sprint set
- [ ] `docs/tracking/PROJECT_STATE.md` updated — Safe-to-Spend listed as stable system
- [ ] `docs/core/ROADMAP.md` updated — Phase 8 marked complete
- [ ] `docs/tracking/LESSONS.md` updated — Phase 8 lessons added
- [ ] `docs/tracking/DECISION_LOG.md` updated — formula decision (Decision 014) logged

---

## Final Ship Criteria

**Phase 8 is complete ONLY when ALL of the following are true:**

- [ ] `dart analyze` → 0/0/0 (zero errors, zero warnings, zero infos)
- [ ] Safe-to-Spend hero number visible on dashboard within 3 seconds of app open
- [ ] Breakdown accessible within 1 tap from hero number
- [ ] All 10 edge cases (EC-01 through EC-10) verified manually in device/emulator
- [ ] Pending/expected income NEVER appears in primary Safe-to-Spend result
- [ ] USD income NEVER appears in primary Safe-to-Spend result (Phase 8 MVP)
- [ ] No red color anywhere in Safe-to-Spend feature
- [ ] Settings (tax rate, buffer, fixed costs) persist across hot restart
- [ ] Safe-to-Spend reactive to income, expense, and settings changes (no restart required)
- [ ] Existing transaction flows untouched and working
- [ ] Existing income pipeline flows untouched and working
- [ ] Existing dashboard behavior untouched (income summary still present)
- [ ] Existing routing untouched and working
- [ ] Offline mode verified manually (airplane mode)
- [ ] No future-phase code present (no ML, no bank sync, no auto-detection, no charts)
- [ ] No forbidden patterns present
- [ ] All doc updates completed (6 items in governance section above)
- [ ] Completion report delivered to Chief Architect per `docs/governance/AGENT_WORKFLOW.md`
