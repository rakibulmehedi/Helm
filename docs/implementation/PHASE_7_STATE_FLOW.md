# Phase 7 — State Flow Governance

> Type: Implementation Governance
> Status: AUTHORITATIVE — Read before writing any provider, notifier, or dashboard logic
> Created: 2026-05-22
> Scope: Reactive data flow and financial domain ownership for Phase 7

---

## 1. Purpose

### Why State-Flow Governance Matters

Phase 7 introduces a second financial domain alongside the existing transaction system. Without explicit ownership rules, implementation agents will:

- Compute dashboard totals in multiple places, causing inconsistency
- Accidentally treat pending income as spendable money
- Build dashboard widgets that recalculate summaries independently, diverging from each other
- Create provider dependencies that cause circular refresh loops
- Contaminate the transaction domain with income logic (or vice versa)

Each of these failure modes is invisible at first and catastrophic later. A freelancer who sees "Received: ৳45,000" on the dashboard but cannot reconcile that number with their bank account will lose trust in the app permanently.

### Why Financial Trust Depends on Money-State Separation

Money exists in multiple states simultaneously in a freelancer's world:
- Money promised but not yet initiated (Expected)
- Money in transit but not yet liquid (Pending)
- Money in hand and spendable (Received)

If these states bleed into each other in the data model, the UI will show numbers that feel wrong even when they are technically correct. A user who sees pending money counted in their "available balance" will over-spend. A user who does not see any summary of pending money will under-plan.

Pocketa's promise is **cashflow clarity**. That promise fails if the state model is ambiguous.

### Why Pending Income Must Never Behave Like Liquid Money

Pending money is real money that has not arrived. It must be:
- **Visible** — the user needs to know it exists
- **Clearly labeled** — the user must know it is not yet spendable
- **Never aggregated with liquid money** — combining them destroys the entire value proposition

The moment Pending income is treated as Received income in any calculation, the Safe-to-Spend model (Phase 8) becomes untrustworthy, and the user's cashflow picture becomes false.

**This rule is foundational. It must never drift.**

---

## 2. Financial Domain Separation

Pocketa operates with three distinct financial domains. These domains have separate persistence, separate providers, and separate calculation responsibilities. They must never be merged.

---

### Domain 1: Transaction Domain

**What it owns:**
- Expenses (money spent)
- Income transactions that represent money already received and entered manually as a general transaction
- Historical money movement — what happened, when, how much

**Hive box:** `transactionBox` (typeId: 0)
**Provider:** `transactionsProvider` (Frozen — do not modify)
**Notifier:** `TransactionsNotifier`

**Semantic meaning:** This domain answers "What has happened with my money so far?"

**Scope boundary:**
- Does NOT own pipeline tracking (Expected → Pending → Received lifecycle)
- Does NOT own client/project metadata
- Does NOT compute income pipeline summaries
- Does NOT know about `IncomeStatus`

---

### Domain 2: Freelancer Income Domain

**What it owns:**
- Expected income (work done, payment not initiated)
- Pending income (payment initiated, in transit)
- Received income (money confirmed liquid — end of pipeline)
- Client name, project name, expected date, received date
- Pipeline lifecycle (status transitions)

**Hive box:** `incomeBox` (typeId: 2)
**Provider:** `incomeNotifierProvider`
**Notifier:** `IncomeNotifier`

**Semantic meaning:** This domain answers "What money is coming, when, and at what stage?"

**Scope boundary:**
- Does NOT own general expense tracking
- Does NOT compute net balance (that is Transaction domain + Safe-to-Spend logic in Phase 8)
- Does NOT know about `TransactionEntity`
- Does NOT store derived totals in Hive

---

### Domain 3: Dashboard Aggregation Domain

**What it owns:**
- Derived summaries computed at render time from Domains 1 and 2
- Operational overview (pipeline totals, transaction summaries)
- Non-persistent computed values

**Persistence:** NONE — all dashboard values are derived, never stored
**Provider:** No separate provider — dashboard widgets consume `transactionsProvider` and `incomeNotifierProvider` directly, or via a thin computed layer
**Notifier:** NONE — dashboard is read-only, reactive to upstream changes

**Semantic meaning:** This domain answers "What is my financial picture right now?"

**Scope boundary:**
- Does NOT write to Hive
- Does NOT own source data
- Does NOT have its own state notifier
- Does NOT cache computed totals

---

### Domain Merge Prohibition

The following merges are EXPLICITLY FORBIDDEN:

| Forbidden Action | Why |
|-----------------|-----|
| Storing income entries in `transactionBox` | typeId collision, domain corruption |
| Adding `IncomeStatus` to `TransactionEntity` | Destroys transaction domain purity |
| Computing income totals inside `TransactionsNotifier` | Wrong ownership — breaks separation |
| Creating a shared `FinancialEntry` base class | Merges domains — catastrophic |
| Making `incomeNotifierProvider` watch `transactionsProvider` | Circular dependency risk, wrong coupling |
| Computing transaction summaries inside `IncomeNotifier` | Wrong ownership |
| Storing any dashboard total in Hive | Derived state must not persist |

---

## 3. Liquid vs Non-Liquid Rules

### Definitions

| Money State | Liquid? | Hive Source | Provider |
|-------------|---------|-------------|----------|
| `IncomeStatus.received` | YES — spendable | `incomeBox` | `incomeNotifierProvider` |
| `IncomeStatus.pending` | NO — in transit | `incomeBox` | `incomeNotifierProvider` |
| `IncomeStatus.expected` | NO — not initiated | `incomeBox` | `incomeNotifierProvider` |
| Transaction (expense) | N/A — spent | `transactionBox` | `transactionsProvider` |
| Transaction (income type) | YES — already received | `transactionBox` | `transactionsProvider` |

### What May Appear in Dashboard Summaries

| Summary Card | May Include | May NOT Include |
|-------------|-------------|-----------------|
| Income → Expected | `IncomeStatus.expected` amounts only | Pending, Received, Transactions |
| Income → Pending | `IncomeStatus.pending` amounts only | Expected, Received, Transactions |
| Income → Received | `IncomeStatus.received` amounts only | Expected, Pending, Transactions |
| Transaction Summary (existing) | Transaction domain data only | Income domain data |

**The income summary and transaction summary are separate UI sections. They must never be combined into a single number.**

### What May Affect Safe-to-Spend (Phase 8 — for reference only)

Phase 8 will compute Safe-to-Spend. When that phase is designed, these rules govern which money may be included:

- `IncomeStatus.received` income → MAY feed Safe-to-Spend (liquid)
- `IncomeStatus.pending` income → MAY appear as "incoming soon" context — NOT as spendable balance
- `IncomeStatus.expected` income → Must NOT feed Safe-to-Spend in any form
- Transaction expenses → Feed Safe-to-Spend as outflows

**Do NOT pre-implement this logic in Phase 7.** These rules are documented here so Phase 7 code does not accidentally make Phase 8 impossible.

### What May NOT Affect Operational Balance

- Pending income must never appear in any "total available" or "net balance" figure
- Expected income must never appear in any balance calculation
- Dashboard income cards (Expected, Pending, Received) are informational — they are NOT a balance

---

## 4. Provider Ownership Rules

### Ownership Table

| Responsibility | Owner | Location |
|---------------|-------|----------|
| Raw income list (all entries) | `IncomeNotifier` via `incomeNotifierProvider` | `income/presentation/providers/income_providers.dart` |
| Income CRUD operations | `IncomeNotifier` | Same file |
| Filtered income by status | Widget layer — computed from provider state | `income_list_screen.dart` |
| Sorted income entries | Widget layer — computed from provider state | `income_list_screen.dart` |
| Income pipeline totals (Expected/Pending/Received) | `IncomePipelineSummary` widget — computed from provider state | `income_pipeline_summary.dart` |
| Raw transaction list | `TransactionsNotifier` via `transactionsProvider` | `transactions/presentation/providers/` (FROZEN) |
| Transaction CRUD | `TransactionsNotifier` | (FROZEN) |
| Transaction summaries | Dashboard — computed from `transactionsProvider` | Existing dashboard logic (FROZEN) |

### Ownership Rules

1. **Raw data ownership:** Each Hive box has exactly one notifier. `incomeBox` → `IncomeNotifier`. `transactionBox` → `TransactionsNotifier`. No crossover.

2. **Derived total ownership:** Derived totals (sum of Expected this month, sum of Pending this month, etc.) are computed in the widget that displays them, by calling `.where()` and `.fold()` on the provider state list. They are NOT stored in a separate provider or in Hive.

3. **Filter ownership:** Status filtering (All / Expected / Pending / Received tabs) is a pure widget-layer operation. Compute via `.where((e) => e.status == IncomeStatus.pending)` in the build method or a local computed variable. No separate filter provider.

4. **Sort ownership:** Sorting by `expectedDate` is a pure widget-layer operation. Compute via `.sorted()` or `.sort()` on a local copy. No separate sort provider.

5. **No provider watches provider:** `incomeNotifierProvider` must NOT watch `transactionsProvider`. `transactionsProvider` must NOT watch `incomeNotifierProvider`. They are independent.

6. **Dashboard is read-only:** Dashboard consumes provider state but writes nothing. No reverse data flow from dashboard to providers.

### Single Calculation Point Rule

Any financial total that appears in more than one widget must be computed in exactly one place. Options:
- Compute in the widget closest to the data (preferred for Phase 7)
- Extract to a named extension method on `List<IncomeEntryEntity>` (acceptable if >2 widgets need same calculation)
- Do NOT create a new provider just to hold a derived total

---

## 5. Reactive State Flow

### Flow 1: Add Income Entry

```
User submits Add Income form
↓
AddIncomeScreen calls incomeNotifierProvider.addIncome(entity)
↓
IncomeNotifier calls incomeRepositoryProvider.addIncome(entity)
↓
IncomeRepositoryImpl maps entity → IncomeModel
↓
IncomeLocalDataSource writes IncomeModel to Hive incomeBox
↓
IncomeNotifier updates state: [...currentList, newEntity]
↓
All widgets watching incomeNotifierProvider rebuild:
  → IncomeListScreen (new card appears)
  → IncomePipelineSummary on dashboard (Expected total updates)
↓
AddIncomeScreen navigates back + shows success SnackBar
```

---

### Flow 2: Edit Income Entry

```
User submits Edit Income form
↓
EditIncomeScreen calls incomeNotifierProvider.updateIncome(updatedEntity)
↓
IncomeNotifier calls incomeRepositoryProvider.updateIncome(updatedEntity)
↓
IncomeRepositoryImpl maps entity → IncomeModel
↓
IncomeLocalDataSource overwrites IncomeModel in Hive (by id)
↓
IncomeNotifier updates state: replaces matching entity in list
↓
All widgets watching incomeNotifierProvider rebuild:
  → IncomeListScreen (card shows updated data)
  → IncomePipelineSummary (totals recompute if status/amount/date changed)
↓
EditIncomeScreen navigates back + shows success SnackBar
```

---

### Flow 3: Status Transition

```
User taps quick-action button on IncomeCard ("Mark Pending" / "Mark Received")
↓
IncomeCard calls incomeNotifierProvider.updateIncome(entity.copyWith(
  status: nextStatus,
  receivedDate: nextStatus == received ? DateTime.now() : entity.receivedDate,
  updatedAt: DateTime.now(),
))
↓
[Same as Flow 2 from IncomeNotifier call onward]
↓
IncomeCard status badge updates (grey → blue → green)
IncomePipelineSummary totals recompute (moved from one bucket to another)
```

Note: Status transitions use the same `updateIncome` path as general edits. No separate transition method needed.

---

### Flow 4: Delete Income Entry

```
User swipes to delete IncomeCard
↓
IncomeListScreen calls incomeNotifierProvider.deleteIncome(entity.id)
  and stores deleted entity locally for potential undo
↓
IncomeNotifier calls incomeRepositoryProvider.deleteIncome(id)
↓
IncomeLocalDataSource removes IncomeModel from Hive incomeBox
↓
IncomeNotifier updates state: removes matching entity from list
↓
All widgets watching incomeNotifierProvider rebuild:
  → IncomeListScreen (card disappears)
  → IncomePipelineSummary (totals recompute)
↓
IncomeListScreen shows SnackBar: "Income entry deleted" + "Undo" button

--- IF USER TAPS UNDO ---

User taps "Undo" on SnackBar
↓
IncomeListScreen calls incomeNotifierProvider.addIncome(deletedEntity)
↓
[Same as Flow 1 from IncomeNotifier call onward]
↓
Card reappears. Totals recompute.
```

---

### Flow 5: Dashboard Refresh (Reactive)

```
App launches
↓
Hive incomeBox opened (hive_service.dart initialization)
↓
incomeNotifierProvider initialized → IncomeNotifier.state = all stored entries
↓
DashboardScreen renders → IncomePipelineSummary consumes incomeNotifierProvider
↓
IncomePipelineSummary computes:
  expectedTotal = state.where(status==expected && sameMonth).fold(0, (sum, e) => sum + e.amount)
  pendingTotal  = state.where(status==pending  && sameMonth).fold(0, (sum, e) => sum + e.amount)
  receivedTotal = state.where(status==received && sameMonth).fold(0, (sum, e) => sum + e.amount)
↓
Three summary cards render with computed totals
↓
[On any income CRUD operation: provider state updates → widgets rebuild → totals recompute automatically]
```

No manual "refresh" call needed. Riverpod's reactive rebuild handles this.

---

## 6. Derived State Rules

### Source-of-Truth Hierarchy

```
Level 1 (Source of Truth):   Hive boxes (incomeBox, transactionBox)
                                   ↓ read by
Level 2 (Live State):        StateNotifier state (IncomeNotifier, TransactionsNotifier)
                                   ↓ consumed by
Level 3 (Derived Display):   Widget-layer computations (totals, filters, sorts)
                                   ↓ rendered by
Level 4 (UI):                Widgets (cards, badges, summary sections)
```

Data flows DOWN only. No level writes back to a higher level.

### Rules

1. **Hive is truth.** `incomeBox` contains the authoritative income entries. If Hive says an entry exists, it exists.

2. **Notifier state mirrors Hive.** `IncomeNotifier.state` is a live in-memory mirror of `incomeBox`. Any write to Hive must be reflected in state immediately.

3. **Derived values are never persisted.** The sum of Expected income this month is a derived value. It must not be stored in Hive, SharedPreferences, or any stateful object outside the widget render cycle.

4. **If source data changes, all derived values recompute.** This is automatic via Riverpod's reactive rebuild. Do not manually cache derived totals.

5. **Widget computations are pure.** A widget that computes `expectedTotal` must produce the same result given the same provider state. No side effects in filter/sort/sum logic.

6. **No stale cache.** Do not store `expectedTotal`, `pendingTotal`, or `receivedTotal` in widget state (`StatefulWidget` fields). Compute them fresh on each rebuild from provider state.

---

## 7. Dashboard Calculation Rules

### Income Pipeline Summary Calculations

| Card | Calculation | Month Filter | Notes |
|------|-------------|--------------|-------|
| Expected | `sum(amount where status==expected)` | Filtered by `expectedDate` — current calendar month | Shows what the user hopes to receive this month |
| Pending | `sum(amount where status==pending)` | Filtered by `expectedDate` — current calendar month | Shows what is in transit this month |
| Received | `sum(amount where status==received)` | Filtered by `receivedDate` — current calendar month | Shows confirmed liquid money this month |

"Current calendar month" = entries where `date.month == DateTime.now().month && date.year == DateTime.now().year`.

### What Dashboard Must NOT Combine

- Do NOT add Expected + Pending + Received into a single "Total Income" figure. Each is a distinct money state.
- Do NOT combine any income total with the transaction domain's net balance.
- Do NOT show a "Net Cash" or "Available Balance" figure in Phase 7. That is Phase 8 (Safe-to-Spend).

### Emotional Trust Considerations

**Received = real money. Design reflects this.**
- Received card: highest visual prominence, solid color, clear currency display
- Pending card: secondary prominence, softer color — this money is on its way but not yours yet
- Expected card: lowest prominence, muted — this is a plan, not a promise

**Never merge Pending + Received into a combined figure.**
A combined figure creates false confidence. A freelancer who sees "৳65,000 incoming" (pending + expected combined) may spend money that has not arrived. The app must make the distinction visually unmistakable.

### UX Clarity Rules for Dashboard

1. Each card is labeled with its exact state name ("Expected", "Pending", "Received") — no synonyms, no abbreviations
2. If a user taps a card, they navigate to the income list filtered by that status — they see exactly which entries make up the number
3. Numbers must reconcile. Sum of all entries in filtered list must equal the dashboard card total. Any discrepancy destroys trust.
4. "0" is a valid and meaningful state. Show ৳0 with the same formatting as other amounts.
5. All-zero state: replace three zero cards with a single "Start tracking your income pipeline" prompt (less alarming, more actionable)

### Anti-Confusion Principles

- The dashboard income section is labeled "Income Pipeline" — distinct from any transaction summary
- No mixed terminology: do not call Received income a "transaction", do not call a transaction an "income entry"
- Currency display: always show currency symbol or code next to amount (৳ or USD) — never a raw number without context

---

## 8. Anti-Patterns

These patterns are EXPLICITLY FORBIDDEN in Phase 7 implementation:

### Financial Logic Anti-Patterns

| Anti-Pattern | Why Forbidden |
|-------------|---------------|
| Including `pending` income in any "available balance" or "spendable" figure | Pending money is not liquid — misleads user into overspending |
| Including `expected` income in any total that implies certainty | Expected money is not promised — creates false confidence |
| Combining income pipeline totals with transaction domain totals | Different domains, different semantics — combined number is meaningless |
| Adding Expected + Pending + Received into single "Total Income" card | Destroys the three-way separation that is the feature's core value |
| Storing `expectedTotal`, `pendingTotal`, or `receivedTotal` in Hive | Derived values must not persist — stale cached totals create inconsistency |

### Provider Anti-Patterns

| Anti-Pattern | Why Forbidden |
|-------------|---------------|
| Computing income totals inside `TransactionsNotifier` | Wrong ownership — transaction notifier must not know about income |
| Computing transaction summaries inside `IncomeNotifier` | Wrong ownership — income notifier must not know about transactions |
| `incomeNotifierProvider.watch(transactionsProvider)` | Cross-domain dependency — creates coupling, potential circular dependency |
| Separate `expectedTotalProvider`, `pendingTotalProvider`, `receivedTotalProvider` | Provider proliferation — compute in widget layer instead |
| Dashboard notifier/provider that owns computed totals | Dashboard has no state — it is a read-only view |

### Calculation Anti-Patterns

| Anti-Pattern | Why Forbidden |
|-------------|---------------|
| Computing `expectedTotal` in two different widgets independently | Inconsistency risk — two computations may diverge on edge cases |
| Filtering income by status in both the list screen AND the dashboard widget with different logic | Logic duplication — one source of truth for filter logic |
| Caching computed totals in `StatefulWidget` local state | Stale data risk — computed values must derive fresh from provider state |
| Using `GlobalKey` or `InheritedWidget` to share computed income totals | Wrong pattern — use Riverpod providers |

### Architecture Anti-Patterns

| Anti-Pattern | Why Forbidden |
|-------------|---------------|
| Direct Hive calls from any widget or screen | Bypasses repository — all Hive access through data source → repository → notifier |
| Income entries stored in `transactionBox` | Domain contamination + typeId mismatch |
| `IncomeModel` with typeId other than 2 | typeId collision with TransactionModel (0) |
| Cross-feature imports between income and transaction features | Coupling — two features must be independently modifiable |
| Shared Riverpod state between income and transaction features (other than at dashboard view level) | Breaks domain isolation |

---

## 9. Future Compatibility Notes

These notes define what Phase 7 must NOT pre-implement but MUST NOT prevent.

### Safe-to-Spend (Phase 8)

Phase 8 will compute: `Safe-to-Spend = liquid_received_income + transaction_income - transaction_expenses - committed_expenses`

Phase 7 must:
- Keep `IncomeStatus.received` clearly distinguishable from `IncomeStatus.pending`
- Ensure `receivedDate` is accurate and always set when status → received
- NOT pre-compute Safe-to-Spend
- NOT add `isSafeToSpend` or `isLiquid` fields to `IncomeEntryEntity`

The `IncomeNotifier.state` list + `IncomeStatus` enum are the data Phase 8 will consume. Keep them clean.

### Virtual Wallets (Future Phase)

Virtual Wallets will tag income entries and transactions to wallet buckets (business, personal, tax).

Phase 7 must:
- NOT add `walletId` or `walletTag` to `IncomeEntryEntity` or `IncomeModel`
- Keep `IncomeModel` HiveField indices 0–10 as specified — no extra fields added that would shift indices

When Virtual Wallets is designed, new `@HiveField` indices (11+) can be added without breaking existing data.

### Cloud Sync (Phase 13+)

Phase 7 must:
- NOT add `syncStatus`, `serverId`, `isSynced`, `isDirty`, or `lastSyncedAt` fields
- NOT import any network package
- NOT design `IncomeLocalDataSource` with a remote override in mind

When sync is designed, a `RemoteDataSource` can be introduced alongside `IncomeLocalDataSource` without modifying Phase 7 code.

### Forecasting (Future Phase)

Forecasting will use `expectedDate` and historical `receivedDate` data to predict cashflow patterns.

Phase 7 must:
- Ensure `expectedDate` and `receivedDate` are stored accurately and never null when required
- NOT compute forecasts or trend lines
- NOT add `forecastWeight` or `probability` fields

The existing data model is sufficient for future forecasting to consume.

### Multi-Currency (Phase 10)

Phase 10 will introduce currency conversion.

Phase 7 must:
- Store `currency` as a String field ("BDT" or "USD") — no conversion math
- NOT hardcode assumption that all amounts are in BDT
- NOT add exchange rate fields or conversion logic

When Phase 10 arrives, a `CurrencyConverter` utility can be applied to existing `amount` + `currency` fields without schema changes.

---

## 10. Escalation Triggers

Implementation agents must STOP and request Chief Architect approval before proceeding if any of the following conditions arise:

### Financial Semantics Escalations

- Any proposal to include `pending` income in a balance or total that implies spendability
- Any proposal to include `expected` income in any financial calculation beyond display
- Any proposal to add a 4th `IncomeStatus` value
- Any proposal to combine income pipeline totals with transaction totals in a single UI element

### Domain Integrity Escalations

- Any proposal to create a shared base class between `IncomeEntryEntity` and `TransactionEntity`
- Any proposal to store income entries in `transactionBox`
- Any proposal to give `IncomeNotifier` read access to transaction data (or vice versa)
- Any detected typeId conflict in Hive adapters

### Persistence Escalations

- Any proposal to persist derived totals (expectedTotal, pendingTotal, receivedTotal) in Hive
- Any proposal to cache dashboard computed values in SharedPreferences
- Any proposal to add Supabase, network, or sync fields to `IncomeModel`

### Provider Architecture Escalations

- Any proposal to add more than 3 income providers (`incomeDataSourceProvider`, `incomeRepositoryProvider`, `incomeNotifierProvider`)
- Any proposal to create a `dashboardProvider` that owns computed financial state
- Any proposal where one domain's provider watches the other domain's provider

### Dashboard Escalations

- Dashboard income section feels cluttered or confusing after integration (Phase 7d)
- Received total does not match sum of Received entries visible in the filtered list
- Any proposal to add a "Total" or "Net" figure that combines income states

---

## Summary: State-Flow Laws

These are the non-negotiable rules of Phase 7 state management:

1. **Two Hive boxes. Two notifiers. Zero crossover.**
2. **Pending is not liquid. Expected is not liquid. Only Received is liquid.**
3. **Derived totals compute at render time. They never persist.**
4. **Filter and sort live in the widget layer. Not in separate providers.**
5. **Dashboard reads. Dashboard never writes. Dashboard never caches.**
6. **Numbers must reconcile. Card total = sum of visible entries in filtered list.**
7. **Phase 8 (Safe-to-Spend) will consume this data. Keep the model clean.**
8. **When in doubt: separate, not merge. Isolate, not couple.**
