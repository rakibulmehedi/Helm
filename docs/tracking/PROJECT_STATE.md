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
  - Configured route `/sts-settings`.
  - Delete with Undo implemented for fixed costs.
- **Next**: Phase 8d — Dashboard Hero Number

## 6. Blocked Modules
- Cloud sync (requires authentication decision)

## 7. Current Product Direction
- Focus: Freelancer Finance OS
- Goal: Calm, premium, fast, operational, low stress
- Avoid: Clutter, chart overload, finance jargon