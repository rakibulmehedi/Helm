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

## Milestone: v0.2-cashflow-operations (In Progress)

> Status: **SPEC READY — IMPLEMENTATION PENDING**
> Forward-looking cashflow clarity and operational peace of mind.
> Specs finalized: 2026-05-22

### Phase 7 — Income Pipeline (Current)
- Spec: `docs/specs/PHASE_7_FREELANCER_INCOME_TRACKING.md`
- MVP spec: `docs/specs/INCOME_PIPELINE_MVP.md`
- Three-state model: Expected → Pending → Received
- Income entry CRUD with client/project tracking
- Dashboard income summary integration
- Sub-phases: 7a (data layer) ✅ → 7b (entry UI) ✅ → 7c (list/filter) ✅ → 7d (dashboard) ✅ → 7e (status transitions + UX hardening) ✅

### Phase 7f — Storage Abstraction & Domain Cleanup (Decision 012)
- Create `TransactionEntity` (pure Dart domain class)
- Fix `TransactionRepository` to use entities, not `TransactionModel`
- Move `TransactionType @HiveType` annotation out of domain layer
- Add `fromJson`/`toJson` to `IncomeModel` and `TransactionModel`
- Estimated effort: ~7–11h
- Ref: `docs/architecture/LOCAL_DATABASE_DECISION_REVIEW.md` (Option C)
- Authority: Chief Architect — Decision 012

### Phase 8 — Safe-to-Spend Model (In Progress)
- Spec: `docs/specs/SAFE_TO_SPEND_MODEL.md`
- Depends on Phase 7f (Storage Abstraction & Domain Cleanup)
- Formula: (Liquid Cash) - (Tax Reserve + Fixed Costs + Anxiety Buffer) = Safe to Spend
- Pending income excluded from primary Safe-to-Spend number
- "Waterline" concept for visual display
- Sub-phases: 8a (Formula/Contract) ✅ → 8b (Calculation Engine) ✅ → 8c (Settings UI) ✅ → 8d (Dashboard Hero) ✅ → 8e (UX Hardening)

### Post-Phase 8 — User Validation Sprint (Mandatory)
- 30 days with 5–10 real Bangladeshi freelancers
- Primary question: Will users maintain the pipeline manually?
- Decision 013: Phase 9 scope is conditional on validation outcome
- Ref: `docs/planning/POST_AUDIT_EXECUTION_ROADMAP.md`

### Phase 8+ — Virtual Wallets (Future)
- Spec: `docs/specs/VIRTUAL_WALLETS.md`
- Mental separation of Business / Personal / Tax / Reserve
- No actual banking integration
- Depends on Phase 7 + transaction tagging

### Phase 9 — Subscription Leakage Radar (Spec Ready, Conditional)
- Spec: `docs/specs/SUBSCRIPTION_LEAKAGE_RADAR.md`
- Manual stack builder first, then recurring detection
- SaaS burn rate tracking
- Non-judgmental "optimization opportunity" framing
- Pro monetization potential
- **Scope conditional on post-Phase 8 user validation outcome**


---

## Milestone: v0.3-pro-power (Planned)

> Status: **NOT STARTED**
> Advanced freelancer tools and monetization foundation.

### Phase 10 — Client & Project ROI
- Track income/expense per client
- Client profitability tracking
- Multi-currency support (USD/BDT)

### Phase 11 — Export & Reporting
- PDF/CSV generation for taxes and clients
- Advanced cashflow insights

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