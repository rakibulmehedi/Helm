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
- Phase 7: Freelancer Income Pipeline (7a–7d DONE; 7e pending)
  - income domain entity, Hive model (typeId:2), local data source, repository, providers — all stable
  - income add/edit form screen with full validation — stable
  - income list screen with status filter chips, income cards, delete+undo, empty states — stable
  - /income route wired; accepts optional initialFilter for deep-link from dashboard
  - dashboard income pipeline summary: Expected/Pending/Received totals, calm colors, empty state, tap-to-filter navigation

## 6. Blocked Modules
- Cloud sync (requires authentication decision)

## 7. Current Product Direction
- Focus: Freelancer Finance OS
- Goal: Calm, premium, fast, operational, low stress
- Avoid: Clutter, chart overload, finance jargon