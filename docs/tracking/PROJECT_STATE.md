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
- `TransactionType` enum has `@HiveType` in domain layer (architecture violation — must move to data layer)
- No `TransactionEntity` — `TransactionRepository` interface currently imports `TransactionModel` directly (domain depends on data)
- No `fromJson`/`toJson` on `IncomeModel` or `TransactionModel` (limits export/import/debugging)

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
- **Next**: Domain Cleanup Sprint (TransactionEntity, @HiveType fix, fromJson/toJson) then Phase 8 Safe-to-Spend

## 6. Blocked Modules
- Cloud sync (requires authentication decision)

## 7. Current Product Direction
- Focus: Freelancer Finance OS
- Goal: Calm, premium, fast, operational, low stress
- Avoid: Clutter, chart overload, finance jargon