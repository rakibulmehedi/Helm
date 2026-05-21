# POCKETA — Product Roadmap

> Living document tracking completed phases, current state, and planned work.
> Updated after each phase completion.

---

## Milestone: v0.1-mvp-foundation ✅

> Tagged: `v0.1-mvp-foundation`
> Status: **COMPLETE**
> Core transaction loop — create, read, update, delete with offline persistence.

---

### Phase 0 — App Foundation ✅

**Commit:** `d23bce4`

| Item | Status |
|---|---|
| GoRouter setup | ✅ |
| App startup flow | ✅ |
| Splash → Onboarding → Dashboard routing | ✅ |
| Onboarding guard via SharedPreferences | ✅ |
| Theme system (light/dark) | ✅ |
| Localization scaffolding (intl) | ✅ |
| ProviderScope + app entry point | ✅ |

---

### Phase 1 — Transaction Data Layer ✅

**Commit:** `443f630`

| Item | Status |
|---|---|
| TransactionModel with Hive TypeAdapter | ✅ |
| TransactionEntity (domain) | ✅ |
| TransactionLocalDataSource (Hive CRUD) | ✅ |
| TransactionRepository (abstract + impl) | ✅ |
| TransactionsNotifier (StateNotifier) | ✅ |
| Riverpod provider wiring | ✅ |

---

### Phase 2 — Add Transaction UI ✅

**Commit:** `17656e3`

| Item | Status |
|---|---|
| AddTransactionScreen with form | ✅ |
| Type toggle (income/expense) | ✅ |
| Title, amount, category, date, note fields | ✅ |
| Form validation | ✅ |
| Save via transactionsProvider | ✅ |
| Route: /add-transaction | ✅ |
| FAB on dashboard | ✅ |

---

### Phase 3 — Dashboard Integration ✅

**Commit:** `9c9b007`

| Item | Status |
|---|---|
| Dashboard reads transactionsProvider | ✅ |
| Summary cards (income, expense, balance) | ✅ |
| Recent transaction list (newest first) | ✅ |
| Empty state | ✅ |
| Transaction item display (title, amount, type, category, date, note) | ✅ |
| Swipe-to-delete with confirmation | ✅ |

---

### Phase 3.5 — Stabilization & UX Polish ✅

**Commit:** `b10c81e`

| Item | Status |
|---|---|
| Replace deprecated withOpacity → withValues | ✅ |
| Delete confirmation dialog | ✅ |
| SnackBar after save/delete | ✅ |
| Amount formatting with NumberFormat | ✅ |
| Safe Dismissible with confirmDismiss | ✅ |
| Small screen overflow prevention | ✅ |

---

### Phase 4 — Transaction Filtering & Date Grouping ✅

**Commit:** `95a9019`

| Item | Status |
|---|---|
| Date grouping (Today, Yesterday, older dates) | ✅ |
| Filter chips (All, Income, Expense) | ✅ |
| Summary cards based on all transactions | ✅ |
| Delete flow preserved | ✅ |

---

### Phase 5 — Edit Transaction Flow ✅

**Commit:** `48b2be0`

| Item | Status |
|---|---|
| AddTransactionScreen supports create + edit mode | ✅ |
| Route: /edit-transaction/:id | ✅ |
| Tap transaction → navigate to edit | ✅ |
| Pre-fill form from existing transaction | ✅ |
| updateTransaction across all layers | ✅ |

---

### Phase 6 — Transaction UX Hardening ✅

**Commit:** `e5b01d3`

| Item | Status |
|---|---|
| IdGenerator (timestamp + secure random hex) | ✅ |
| Missing transaction error state in edit route | ✅ |
| Double-submit prevention | ✅ |
| Mounted guards on setState/navigation | ✅ |
| Immediate delete + Undo SnackBar | ✅ |
| Try/catch error recovery on submit | ✅ |

---

## Milestone: v0.2-insights (Planned)

> Status: **NOT STARTED**
> Visualization, categories, and spending awareness.

### Phase 7 — Charts & Spending Visualization
- Monthly spending chart
- Income vs expense comparison
- Category breakdown pie/donut chart

### Phase 8 — Category Management
- Category model with icons and colors
- Category CRUD
- Assign categories to transactions
- Category-based filtering

### Phase 9 — Budget Module
- Monthly budget target
- Budget vs actual tracking
- Budget progress indicators
- Over-budget alerts

---

## Milestone: v0.3-power (Planned)

> Status: **NOT STARTED**
> Recurring transactions, multi-wallet, and data export.

### Phase 10 — Recurring Transactions
- Recurring transaction model
- Auto-generation on schedule
- Subscription tracking

### Phase 11 — Multi-Wallet Support
- Wallet model (Cash, bKash, Nagad, Bank)
- Per-wallet balance
- Transfer between wallets

### Phase 12 — Data Export
- CSV export
- PDF report generation
- Date range selection

---

## Milestone: v1.0-cloud (Planned)

> Status: **NOT STARTED**
> Cloud sync, auth, and multi-device.

### Phase 13+ — Supabase Integration
- User authentication
- Cloud sync for transactions
- Multi-device support
- Conflict resolution

---

## Architecture Snapshot

```
Current Stack (v0.1):
├── Flutter 3.7.2+
├── Riverpod (state management)
├── Hive (local persistence)
├── GoRouter (navigation)
├── SharedPreferences (flags/prefs)
├── Google Fonts (typography)
└── intl (localization + formatting)

Future Additions (planned):
├── fl_chart or syncfusion (charts)
├── Supabase (cloud sync + auth)
└── TBD (export, notifications)
```