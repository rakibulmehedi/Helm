# PROJECT STATE

> Overview of the current architecture, stable systems, and technical debt.

## 1. Current Stable Systems
- onboarding
- localization
- routing
- Hive persistence
- transaction CRUD
- dashboard summaries
- filtering/grouping
- edit flow
- undo delete
- UX hardening
- income pipeline (Phase 7 complete: data layer, entry UI, list/filter, dashboard, status transitions)
- transaction domain abstraction (Phase 7f complete: TransactionEntity, clean repository interface, Hive boundary enforcement)

## 2. Frozen Systems
*(Do NOT heavily refactor without explicit approval)*
- transaction provider structure
- Hive architecture
- routing structure
- localization system

## 3. Known Technical Debt
- categories currently placeholder string labels
- no formal wallet model yet
- no sync abstraction yet

## 4. Current Architecture
- Framework: Flutter
- State Management: Riverpod
- Storage: Hive
- Navigation: GoRouter
- Paradigm: Offline-first

## 5. Active Modules
- **Phase 7 COMPLETE**: Freelancer Income Pipeline (all sub-phases 7a–7e done)
  - income domain entity, Hive model (typeId:2), local data source, repository, providers — stable
  - income add/edit form screen with full validation — stable
  - income list screen with status filter chips, income cards, delete+undo, empty states — stable
  - /income route wired; accepts optional initialFilter for deep-link from dashboard
  - dashboard income pipeline summary: Expected/Pending/Received totals, calm colors, empty state, tap-to-filter navigation
  - status quick-action transitions (Expected→Pending, Pending→Received), UX hardening, financial trust fixes
- **Phase 7f COMPLETE**: Storage Abstraction & Domain Cleanup
  - `TransactionEntity` created (pure Dart, zero Hive/Flutter imports)
  - `TransactionType` enum cleaned (Hive adapter moved to `data/adapters/` layer)
  - `TransactionRepository` interface now accepts/returns `TransactionEntity`
  - `TransactionRepositoryImpl` maps entity↔model internally — data layer boundary enforced
  - `TransactionModel` now has `fromEntity()`, `toEntity()`, `fromJson()`, `toJson()`
  - `IncomeModel` now has `fromJson()`, `toJson()`
  - Zero Hive imports in domain or presentation layers
  - `dart analyze` clean: 0/0/0
- **Phase 8b COMPLETE**: Safe-to-Spend Calculation Engine
  - `SafeToSpendCalculator` built as pure Dart logic with 10 edge cases tested.
  - `FixedCostEntry`, `StsSettings`, `SafeToSpendResult` domain value objects.
  - `FixedCostModel` (typeId 3) registered with Hive.
  - `safe_to_spend_providers.dart` Riverpod providers set up.
- **Phase 8c COMPLETE**: Safe-to-Spend Settings Screen
  - `StsSettingsScreen` built with tax rate slider, anxiety buffer input, and fixed costs CRUD.
- **Phase 8d COMPLETE**: Safe-to-Spend Dashboard Hero
  - `SafeToSpendHero` replaces raw Total Balance on the dashboard.
  - Transparent math breakdown via bottom sheet.
  - Excludes pending and expected income safely.
- **Phase 8e COMPLETE**: Safe-to-Spend UX Hardening
  - Critical fix: `rawSafeToSpend` used for "In reserve mode" / "Fully allocated" state detection (was always dead code).
  - Critical fix: tax slider max capped at 40% (entity asserts ≤ 0.40; slider was 50%).
  - Anxiety buffer validation: explicit SnackBar on invalid input; `FilteringTextInputFormatter` added.
  - Breakdown deduction rows use `AppColors.textSecondary` not `AppColors.error` (no anxiety-inducing red).
  - USD exclusion transparency row added to breakdown when `excludedUsdIncome > 0`.
  - Reserve-mode context note added to breakdown when `rawSafeToSpend < 0`.
  - `Colors.grey` replaced with `AppColors.textSecondary` throughout settings screen.
- **Phase 8f COMPLETE**: Real Device QA + Validation Prep
  - `PHASE_8_REAL_DEVICE_QA_CHECKLIST.md` for manual device testing.
  - `SAFE_TO_SPEND_SCENARIO_MATRIX.md` for formula edge cases.
  - `FOUNDER_VALIDATION_SCRIPT.md` and user interview questions prepared.
  - `VALIDATION_METRICS.md` defined for assessing product-market fit.
- **Pre-Flight Deep QA Complete**: Found and fixed trust mismatch on Dashboard Income chip. Re-routed to `SafeToSpendResult`. Hardened `AddTransactionScreen` to strictly enforce `TransactionType.expense` and dropped legacy income categories. Ready for human QA.
- **Phase 8 COMPLETE** — Safe-to-Spend engine is production-grade.
- **Phase 9a COMPLETE** — Cognitive Persona Simulation QA. Validated core concepts, identified friction points (manual pipeline status updates).
- **Phase 9b COMPLETE** — Hypothesis-Based Validation Sprint. Core hypotheses validated as strong, while manual maintenance discipline flagged as critical risk.
- **Next**: Post-Phase 8 User Validation Sprint

## 6. Blocked Modules
- Cloud sync (requires authentication decision)

## 7. Current Product Direction
- Focus: Freelancer Finance OS
- Goal: Calm, premium, fast, operational, low stress
- Avoid: Clutter, chart overload, finance jargon