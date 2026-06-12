# POCKETA — Product Roadmap

> Living document tracking completed phases, current state, and planned work.
> Updated after each phase completion.

---

## Milestone: 100% Maturity Path (2026-06-12 Plan)

> Reference: `docs/planning/100_PERCENT_MASTER_PLAN.md` — canonical 6-phase plan
> Status: **Phase 0 in progress (Sprint A5 pending)**
> Target: Behavioral 95/100, UI/UX 98/100, Trust Layer 35/35

### Phase 0 — Beta Launch Readiness (🔲 PENDING)
- Sprint A5: Bangla strings + Release APK + Device testing
- Effort: ~4 hours
- Gate: Release APK runs on reference device. Bangla authored.

### Phase 1 — Behavioral Foundation (🔲 PENDING)
- Wire 4 boundary events, add haptics, fix 3 contrast ratios, button active states, slider steppers, quiet affirmations, global onboarding skip
- Effort: ~6 hours
- Score: Behavioral 62→68, UI/UX 78→83

### Phase 2 — Analytics Infrastructure (🔲 PENDING, depends on Phase 1)
- Hive event persistence, "next best action" dashboard card, Semantics coverage, cadence preference discovery
- Effort: ~8 hours
- Score: Behavioral 68→76, UI/UX 83→89

### Phase 3 — Notification System (🔲 PENDING, depends on Phase 2)
- Push notifications + in-app notification center + nudge evaluator engine + nudge copy + effectiveness tracking
- Effort: ~12 hours
- Requires: `flutter_local_notifications` package approval
- Score: Behavioral 76→82

### Phase 4 — Doctrine Gap Closure (🔲 PENDING, depends on Phase 0)
- Magic Link auth + PIN/biometric, conversational onboarding rebuild, FX rate field, exclude-entry toggle, buffer as percentage, instrumentation hardening
- Effort: ~20 hours
- Requires: Backend stack decision, legal L1-L7, `local_auth` package approval
- Score: Behavioral 82→90, UI/UX 89→93, MVP 100%

### Phase 5 — V1 Features (🔲 BLOCKED — requires beta thresholds cleared)
- Multi-wallet, intra-wallet transfers, state colors, duplicate-last-entry, skeletons, ETA notifications
- Effort: ~15 hours
- Gate: Beta must clear all 5 thresholds (2+ misses = KILL)

### Phase 6 — V2 Features (🔲 BLOCKED — requires V1 stable + legal + pricing)
- Invoice-Lite (3 sprints), tax reserve, paid tiers, final 100% polish
- Effort: ~20 hours
- Gate: V1 stable 2+ weeks, invoice pre-validation, legal L5, pricing validation ≥50% at ৳299
- Score: Behavioral 90→95, UI/UX 95→98

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
- Sub-phases: 8a (Formula/Contract) ✅ → 8b (Calculation Engine) ✅ → 8c (Settings UI) ✅ → 8d (Dashboard Hero) ✅ → 8e (UX Hardening) ✅ → 8f (Real Device QA + Validation Prep) ✅

### Doctrine Gap Resolution Sprint (Next)
- Align existing implementation with Final Doctrine MVP requirements
- Auth: Magic Link + PIN/biometric gate
- Onboarding: conversational 3-minute flow
- Missing MVP features: audit log, CSV export, account deletion, closed-beta instrumentation
- Ref: `docs/planning/DOCTRINE_TO_CODE_GAP_ANALYSIS.md`

### Closed Beta (per Doctrine §16)
- 15–25 freelancers, 4 weeks, invitation-only
- Thresholds: pipeline compliance ≥85%, override-equivalent <5%, retention ≥60%, onboarding ≥70%, S2S comprehension ≥80%
- **2+ threshold misses = KILL. Do not ship V1.**

---

## Milestone: V1 — Multi-Wallet + Polish (Planned, Conditional)

> Status: **BLOCKED — Requires MVP closed beta to clear all thresholds**
> Per Final Doctrine §5. Earned only after beta clears.

### V1 Features
- Multi-wallet (Payoneer USD, bKash BDT, Bank BDT, Cash, Custom)
- Intra-wallet transfer (record-only, audit-logged)
- Manual USD→BDT conversion with sanity validation
- Transactional ETA notifications
- Dashboard state colors (Safe / Tight / At Risk)
- Duplicate-last-entry pipeline template
- Empty/error states polished

---

## Milestone: V2 — Workflow + Monetization (Planned, Conditional)

> Status: **NOT STARTED — Requires V1 completion**
> Per Final Doctrine §6. Monetization begins here.

### V2 Features
- Invoice-Lite (3-sprint allocation, non-negotiable)
- Invoice → Pipeline auto-entry
- Minimal client profile (name, email, currency, terms)
- Tax Reserve (user-declared %, not algorithmic)
- Overdue invoice flagging + follow-up template
- Paid tier activation (Free / Pro ৳299 / Power ৳599)

---

## Superseded Items

> The following were in prior roadmap versions but are superseded by the Final Doctrine:

| Item | Status | Reason |
|---|---|---|
| Virtual Wallets as Phase 8+ | Moved to V1 | Doctrine §5 places multi-wallet in V1 |
| Subscription Leakage Radar | **KILLED** | Not in any doctrine version scope |
| Client & Project ROI (Phase 10) | **KILLED** | Not in doctrine; different product category |
| v0.3-pro-power milestone | **REPLACED** | Replaced by V1/V2 doctrine milestones |
| v1.0-cloud / Supabase Integration | **DEFERRED** | Backend decisions per Doctrine §14; not a version milestone |

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

Doctrine-Required Additions (planned):
├── Magic Link auth provider (Resend/Postmark)
├── PIN/biometric gate (local_auth)
├── CSV export
├── Backend: Next.js API routes OR Supabase (pick before Sprint 1)
├── PostgreSQL (managed, event-sourced, integer paisa)
└── Bangladesh-residency-aware hosting
```

---

## Doctrine Alignment Note

> This roadmap was updated on 2026-06-04 to align with `docs/strategy/POCKETA_FINAL_PRODUCT_DOCTRINE.md`.
> The Final Doctrine is the authoritative source for version scope.
> Prior items superseded: Subscription Leakage Radar, Client/Project ROI, v0.3-pro-power, v1.0-cloud milestones.