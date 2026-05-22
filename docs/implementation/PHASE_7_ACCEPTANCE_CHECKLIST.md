# Phase 7 — Acceptance Checklist

> Type: Implementation Governance
> Status: ACTIVE — Complete all items before marking Phase 7 done
> Created: 2026-05-22
> Spec Source: docs/specs/PHASE_7_FREELANCER_INCOME_TRACKING.md + docs/specs/INCOME_PIPELINE_MVP.md

Instructions: Check each item manually or via analyzer. Do NOT mark Phase 7 complete until all items in "Final Ship Criteria" are checked.

---

## Functional Checks

### Income CRUD
- [ ] User can create an income entry with: client name, project name, amount, currency (BDT/USD), expected date, optional notes
- [ ] New income entry defaults to `expected` status on creation
- [ ] User can create an income entry in under 15 seconds
- [ ] Income entry persists to Hive and survives app hot restart
- [ ] User can edit all fields of an income entry at any status stage
- [ ] User can delete an income entry at any status stage
- [ ] Delete triggers immediate removal + SnackBar with "Undo" action
- [ ] Undo restores the deleted income entry correctly
- [ ] Form shows per-field validation errors for: empty clientName, empty projectName, amount ≤ 0, invalid amount format

### Status Transitions
- [ ] Expected → Pending: allowed via quick-action button on card
- [ ] Pending → Received: allowed via quick-action button on card
- [ ] Expected → Received: allowed (skip transition — e.g., cash payment)
- [ ] Pending → Expected: allowed (backward — e.g., failed transfer)
- [ ] Received → any status: NOT allowed via quick-action button (terminal via button)
- [ ] Full status control (including Received) available via edit screen only
- [ ] When marking Received: `receivedDate` auto-populated with `DateTime.now()`
- [ ] User can override `receivedDate` via edit screen after marking Received

### Income List
- [ ] Income list screen (`/income`) shows all income entries
- [ ] "All" tab shows all income entries regardless of status
- [ ] "Expected" tab shows only Expected entries
- [ ] "Pending" tab shows only Pending entries
- [ ] "Received" tab shows only Received entries
- [ ] Entries sorted by expectedDate, newest first within each status group
- [ ] Income card displays: client name, project name, amount + currency, status badge, expected/received date

### Dashboard Summary
- [ ] Dashboard shows Income Pipeline Summary section
- [ ] Section displays three values: total Expected, total Pending, total Received (current month)
- [ ] Expected total calculates sum of amount where `status == expected` (filtered by `expectedDate`, current month)
- [ ] Pending total calculates sum of amount where `status == pending` (filtered by `expectedDate`, current month)
- [ ] Received total calculates sum of amount where `status == received` (filtered by `receivedDate`, current month)
- [ ] Amounts formatted with `NumberFormat` and currency symbol
- [ ] Tap on Expected card navigates to income list filtered by Expected
- [ ] Tap on Pending card navigates to income list filtered by Pending
- [ ] Tap on Received card navigates to income list filtered by Received
- [ ] Dashboard income summary updates reactively when income data changes (no restart required)
- [ ] When all income values are zero: shows income pipeline empty state instead of three zero cards

### Offline
- [ ] All income features work with device in airplane mode
- [ ] Income entries created offline persist and are readable offline

---

## UX Checks

### Color Rules
- [ ] Expected status badge: soft grey — NO red, NO orange
- [ ] Pending status badge: soft blue or amber — NO red
- [ ] Received status badge: gentle green
- [ ] No raw hex colors anywhere in income feature (all via `AppColors`)

### Copy / Language Rules
- [ ] No "overdue" language anywhere in income feature
- [ ] No "late" language anywhere in income feature
- [ ] Expected-by-date copy uses "Expected by [date]" pattern
- [ ] Overdue-like state uses "still waiting" or equivalent neutral language
- [ ] Delete SnackBar copy: "Income entry deleted" with "Undo" action

### Empty States
- [ ] First-time empty state (no income entries): shows guidance + "Add Income" action button
- [ ] Expected tab empty: "No expected payments. Add one when you start a new project."
- [ ] Pending tab empty: "No payments in transit right now."
- [ ] Received tab empty: "No payments received this month yet."
- [ ] All-received state (no expected/pending): "All payments received. You're fully covered."
- [ ] Dashboard income zero state: prompts user to add first income entry
- [ ] All empty states include a clear next action (not hollow)

### Interaction Quality
- [ ] Status transition quick-action requires max 1 tap from income list card
- [ ] Quick-action button NOT shown on Received cards (terminal state)
- [ ] Adding income entry takes < 15 seconds from tap to SnackBar confirmation
- [ ] Dashboard income summary is visible without scrolling (or clearly accessible within 1 scroll)
- [ ] Received total visually most prominent of the three summary values
- [ ] Expected total visually least prominent of the three summary values

### Consistency
- [ ] Income entry delete UX matches transaction delete UX (swipe → immediate delete → SnackBar with undo)
- [ ] Success SnackBars appear for: add income, update income, delete income
- [ ] Navigation back after save is consistent with transaction add/edit patterns

---

## Architecture Checks

### Feature Isolation
- [ ] All income files live exclusively under `lib/features/income/`
- [ ] No file in `lib/features/transactions/` has been modified
- [ ] No income file imports from `lib/features/transactions/`
- [ ] No transaction file imports from `lib/features/income/`
- [ ] Income entries are NOT stored in `transactionBox`
- [ ] No shared `FinancialEntry` or `BasePayment` base class exists

### Domain Layer Purity
- [ ] `income_entry_entity.dart` has zero Flutter framework imports (pure Dart)
- [ ] `income_repository.dart` is abstract — no implementation logic
- [ ] `IncomeStatus` enum has exactly 3 values: `expected`, `pending`, `received`
- [ ] `IncomeEntryEntity` has `copyWith()` method

### Data Layer Correctness
- [ ] `IncomeModel` uses `@HiveType(typeId: 2)` — not 0, not 1, not any other
- [ ] All HiveField indices match spec (0=id, 1=clientName, 2=projectName, 3=amount, 4=currency, 5=statusIndex, 6=expectedDate, 7=receivedDate, 8=notes, 9=createdAt, 10=updatedAt)
- [ ] No HiveField indices changed after first write
- [ ] `income_model.g.dart` is generated, not manually edited
- [ ] `IncomeRepositoryImpl` wraps data source — no direct Hive calls from presentation layer

### Naming Conventions
- [ ] Feature folder: `income/` (snake_case)
- [ ] Screens: `IncomeListScreen`, `AddIncomeScreen`, `EditIncomeScreen` (PascalCase + Screen suffix)
- [ ] Model: `IncomeModel` (PascalCase + Model suffix)
- [ ] Entity: `IncomeEntryEntity` (PascalCase + Entity suffix)
- [ ] Providers: `incomeNotifierProvider`, `incomeRepositoryProvider`, `incomeDataSourceProvider` (camelCase + Provider suffix)
- [ ] Notifier: `IncomeNotifier` (PascalCase + Notifier suffix)
- [ ] Repository: `IncomeRepository`, `IncomeRepositoryImpl` (PascalCase + Repository/RepositoryImpl suffix)
- [ ] DataSource: `IncomeLocalDataSource` (PascalCase + DataSource suffix)

### Code Quality
- [ ] All files under 300 lines
- [ ] No file contains a `build()` method exceeding 100 lines without sub-widget extraction
- [ ] All imports use `package:pocketa_v2/...` (no relative imports)
- [ ] No `withOpacity()` anywhere in income feature — uses `withValues(alpha:)` instead
- [ ] `IdGenerator.uniqueId()` used for all income entry IDs — no manual UUID or random generation
- [ ] All async operations wrapped in `try/catch` with user-facing SnackBar error handling

---

## State Management Checks

### Riverpod
- [ ] All income providers live in `lib/features/income/presentation/providers/income_providers.dart`
- [ ] `IncomeNotifier` extends `StateNotifier<List<IncomeEntryEntity>>`
- [ ] `incomeNotifierProvider` is `StateNotifierProvider`
- [ ] `incomeRepositoryProvider` is `Provider`
- [ ] `incomeDataSourceProvider` is `Provider`
- [ ] No income provider placed in `application/providers/` or any transaction provider file
- [ ] No income provider `ref.watch`es any transaction provider
- [ ] No `ChangeNotifier` used anywhere in income feature
- [ ] No raw `setState` used for income business logic

### Filtering / Sorting
- [ ] Tab filtering implemented as `.where()` in widget layer — NOT as a separate Riverpod provider
- [ ] Sorting implemented as local computation in widget layer — NOT as a separate Riverpod provider
- [ ] No separate filter/sort/search providers created for Phase 7

---

## Offline-First Checks

- [ ] `incomeBox` opened before any income provider reads from it (correct initialization order)
- [ ] Income feature tested manually in airplane mode — all features work
- [ ] No `FutureProvider` in income feature that depends on network
- [ ] No Supabase, Dio, http, or any network package imported in `lib/features/income/`
- [ ] `IncomeModel` has no `syncStatus`, `serverId`, `isSynced`, or `isDirty` fields

---

## Routing Checks

- [ ] Route `/income` → `IncomeListScreen` defined and working
- [ ] Route `/add-income` → `AddIncomeScreen` defined and working
- [ ] Route `/edit-income/:id` → `EditIncomeScreen` with correct ID parameter defined and working
- [ ] `RouteNames.income`, `RouteNames.addIncome`, `RouteNames.editIncome` constants added to `route_names.dart`
- [ ] All navigation uses `context.pushNamed()` or `context.goNamed()` with named routes
- [ ] Existing routes (onboarding, splash, transactions) still work
- [ ] Editing income entry with invalid ID shows error state + back navigation

---

## Localization Checks

- [ ] All user-facing strings in income feature are localized (added to `.arb` files)
- [ ] No hardcoded English strings in income widgets (unless localization is explicitly deferred)
- [ ] No existing localization keys renamed or removed

---

## Analyzer Checks

- [ ] `dart analyze` → 0 errors
- [ ] `dart analyze` → 0 warnings
- [ ] `dart analyze` → 0 infos
- [ ] No `// ignore:` suppressions added to income files
- [ ] No `// ignore_for_file:` suppressions added to income files

---

## Governance Checks

### No Future-Phase Logic
- [ ] No Safe-to-Spend calculation code present
- [ ] No Virtual Wallet logic present
- [ ] No Subscription tracking logic present
- [ ] No chart / analytics code present
- [ ] No AI categorization code present
- [ ] No cloud sync scaffolding present (no Supabase, no syncStatus fields)
- [ ] No currency conversion math present (`amount` stored as-is)
- [ ] No recurring income template logic present
- [ ] No push notification code present
- [ ] No invoice generation code present
- [ ] No client management entity (clientName is free text only)

### No Banned Patterns
- [ ] No raw hex colors in any income file
- [ ] No `ChangeNotifier` in any income file
- [ ] No direct Hive calls from presentation layer (UI → repository only)
- [ ] No god-files over 500 lines
- [ ] No circular imports between income and transaction features
- [ ] No packages added to `pubspec.yaml` without Chief Architect approval

### Doc Updates Required Before Ship
- [ ] `docs/tracking/TASKS.md` updated — Phase 7 sub-phases marked complete
- [ ] `docs/tracking/CURRENT_SPRINT.md` updated — all 7a–7e items marked done
- [ ] `docs/tracking/PROJECT_STATE.md` updated — income feature listed as stable system
- [ ] `docs/core/ROADMAP.md` updated — Phase 7 marked complete
- [ ] `docs/tracking/LESSONS.md` updated — any new lessons from implementation added
- [ ] `docs/tracking/DECISION_LOG.md` updated — any architectural decisions made during implementation logged

---

## Final Ship Criteria

**Phase 7 is complete ONLY when ALL of the following are true:**

- [ ] `dart analyze` → 0/0/0 (zero errors, zero warnings, zero infos)
- [ ] Income CRUD works end-to-end
- [ ] Status lifecycle works (all defined transitions, all edge cases)
- [ ] Dashboard income summary is reactive
- [ ] Existing transaction flows untouched and working
- [ ] Existing dashboard behavior untouched
- [ ] Existing routing untouched
- [ ] Offline mode verified manually
- [ ] No Phase 8+ code present
- [ ] No forbidden patterns present
- [ ] All doc updates completed
- [ ] Completion report delivered to Chief Architect in format specified by `docs/governance/AGENT_WORKFLOW.md`
