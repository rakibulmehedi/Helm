# Phase 7 Planning Audit: Freelancer Income Pipeline

## 1. Existing Architecture Compatibility
- **Data Layer:** `TransactionModel` uses Hive. Adding fields like `status` (enum) and `expectedDate` (DateTime) is compatible with Hive, provided we handle nulls for existing records gracefully.
- **State Management:** `TransactionsNotifier` holds all transactions. We can easily derive new states (e.g., `clearedTransactionsProvider`, `pendingIncomeProvider`) using standard Riverpod `Provider`s without breaking the existing core provider.
- **Routing:** Current routing (`/add-transaction`, `/edit-transaction/:id`) is completely reusable. We just need conditional UI based on whether the user selects "Income" or "Expense".
- **UX Patterns:** The Dashboard card layout and list views can be adapted. "Pending" transactions can be visually distinguished (e.g., greyed out) without breaking the existing swipe-to-delete flow.

## 2. Required New Models
- **`TransactionStatus` Enum:** `cleared`, `pending`, `escrow`, `transit`.
- **Domain/Data Modifications:** `TransactionEntity` and `TransactionModel` must be expanded to include:
  - `status` (TransactionStatus)
  - `expectedDate` (DateTime?, applicable when status is not cleared)

## 3. Proposed Hive TypeIds
- `0`: `TransactionModel` (Existing)
- `4`: `TransactionType` (Existing)
- **`5`: `TransactionStatus` (Proposed New Enum)**

## 4. Repository Layer Design
- The `TransactionRepository` and `TransactionLocalDataSource` interfaces remain largely unchanged, as they handle CRUD for transactions.
- We do not need new repositories for Phase 7. Filtering logic by status should reside in the Provider layer to maintain a single source of truth and avoid redundant database queries.

## 5. Riverpod Provider Strategy
- Keep `transactionsProvider` as the master source of truth.
- **Create Derived Providers (No new state notifiers needed for these):**
  - `clearedTransactionsProvider`: Filters `transactionsProvider` for `status == TransactionStatus.cleared`.
  - `pendingIncomeProvider`: Filters for `type == income` and `status != cleared`.
  - `safeToSpendBalanceProvider`: A dedicated provider for the "Safe-to-Spend" math (Current Cash + Cleared Income - ...). Initially, it might just be Cleared Income - Cleared Expenses.

## 6. Dashboard Integration Strategy
- **Hero Number:** Change from "Total Balance" to "Cleared Balance" (or "Safe-to-Spend").
- **Pipeline Visuals:** Introduce a new "Pending Pipeline" or "Expected Income" card/section directly below the hero number.
- **Transaction List:** Visually differentiate pending transactions (using a neutral grey color, per `SAFE_TO_SPEND_MODEL.md`) from cleared ones to signify "not available yet". Ensure they sort logically.

## 7. UX Risk Analysis
- **Data-Entry Friction:** Adding fields for status and expected date could slow down expense entry, violating the <5s rule. 
  - *Mitigation:* Default expenses to `cleared` and hide the status/expected date fields. Only show them when "Income" is selected.
- **Confusion over Balance:** Users might expect "Total Balance" to include pending income. 
  - *Mitigation:* Explicitly label the hero number "Cleared Balance" and show "Pending" separately. Use grey for pending to avoid alarmist colors.

## 8. Scope Risk Analysis
- **Creeping into Phase 8/10:** It's tempting to add Client/Project tracking or full "Safe-to-Spend" features (fixed expense detection, tax buffer). 
  - *Mitigation:* Strictly limit Phase 7 to tracking the *status* of income and its expected date. Do not build Client models or automated tax deductions yet.

## 9. Anti-Pattern Risks
- **Adding logic to `TransactionsNotifier`:** Don't put filtering or balance math inside the notifier itself. Use separate standard `Provider`s that watch `transactionsProvider`.
- **Hardcoding Colors for Pending States:** Ensure any new colors for "Pending" or "Transit" are added to `AppColors` and `AppTheme`, avoiding raw hex in the dashboard.
- **Null Safety in Hive:** Failing to handle existing transactions which won't have a `status` field. Must provide a `defaultValue` or getter fallback.

## 10. Suggested Incremental Phases
- **Phase 7.1: Domain & Data Expansion.** Add `TransactionStatus` enum, update `TransactionModel` and `TransactionEntity`. Generate Hive adapters.
- **Phase 7.2: Provider Logic.** Build the derived Riverpod providers for pending/cleared segregation.
- **Phase 7.3: Form UI.** Update `AddTransactionScreen` to show pipeline options conditionally for income.
- **Phase 7.4: Dashboard UI.** Update `DashboardScreen` to display the pipeline and use the derived providers.

## 11. Recommended File Structure
```
lib/features/transactions/
├── domain/
│   └── entities/
│       ├── transaction_status.dart      <-- NEW
│       └── transaction_entity.dart      <-- MODIFIED
├── data/
│   └── models/
│       └── transaction_model.dart       <-- MODIFIED
├── presentation/
│   ├── providers/
│   │   ├── transaction_provider.dart    <-- MODIFIED (Add derived providers)
│   │   └── pipeline_provider.dart       <-- NEW (Optional: specific for pipeline math)
│   └── views/
│       └── add_transaction_screen.dart  <-- MODIFIED
lib/features/dashboard/
└── presentation/
    └── views/
        └── dashboard_screen.dart        <-- MODIFIED
```

## 12. Recommended Implementation Order
1. Define `TransactionStatus` enum and update domain/data models.
2. Run build_runner to generate Hive adapters.
3. Handle Hive migration/default values for existing data.
4. Create derived Riverpod providers.
5. Implement the UI changes in `AddTransactionScreen`.
6. Implement the UI changes in `DashboardScreen`.

## 13. Areas That Must Remain Frozen
- Existing routing definitions and GoRouter structure.
- The `TransactionLocalDataSource` interface.
- Core localization and theming structures.
- Offline-first paradigm (no cloud sync added).

## 14. Potential Future Migration Risks
- **Client/Project Tracking (Phase 10):** The `TransactionModel` might become bloated if we keep adding fields. We may need to migrate to a relational structure or nested objects later.
- **Virtual Wallets (Phase 8):** "Transit" and "Escrow" states might require tracking *where* the money is (which Wallet). We might need a database migration then to link transactions to specific wallets.
