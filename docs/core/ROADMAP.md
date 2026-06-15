# HELM — Product Roadmap

> Living document tracking completed phases, current state, and planned work.
> Updated after each phase completion.

---

## Milestone: 100% Maturity Path (2026-06-13 Plan, Updated 2026-06-14)

> Reference: `docs/planning/100_PERCENT_MASTER_PLAN.md` — canonical 6-phase plan
> Reference: `docs/planning/COMPREHENSIVE_IMPLEMENTATION_PLAN.md` — execution plan with VCI infra, risk register, dependency graph
> **Security Audit:** `.commandcode/adversarial_audit_report.md` — 97 findings (17 CRITICAL, 35 HIGH, 33 MEDIUM, 12 LOW)
> Status: **Sprint S1 (Security Hardening) ACTIVE. Phases 1-4 complete. A5 parallel.**
> Target: Behavioral 90/100, UI/UX 93/100, Trust Layer 33/35
> TDD Dispatch: per-phase plans in `docs/planning/TDD_DISPATCH_PHASE_*.md` + `TDD_DISPATCH_SPRINT_S1_SECURITY_HARDENING.md`

### Phase 0 — Beta Launch Readiness (🔄 IN PROGRESS)
- Sprint A5: Bangla strings + Release APK + Device testing (parallel with S1)
- Sprint S1-W6: QA Pre-Release Fixes (9 findings from 10-gate QA execution on 2026-06-15)
- Helm Signal Deck UI slice merged 2026-06-16: Signal Hero, Signal Horizon, Decision Deck, Flow/Trace shell
- Effort: ~10 hours total (A5 ~4h + S1-W6 ~6h)
- Gate: Release APK signs with release keystore. All 9 QA findings resolved. APK runs on reference device. Bangla authored.

### Sprint S1 — Security Hardening (🔄 ACTIVE) [2026-06-14]
- 12-agent adversarial audit: 97 findings across 12 security domains
- 7 waves: Critical Auth/Storage → Navigation/Data → High Auth/Storage/Input → High State/Nav/Race → High Platform/Code → All Medium → All Low + Re-Audit
- **S1-W6**: QA Pre-Release Fixes — 9 findings (2 BLOCKER, 4 HIGH, 2 MEDIUM, 1 LOW). Dispatch: `docs/planning/QA_FIX_DISPATCH.md`
- Effort: ~46 hours (base ~40h + S1-W6 ~6h)
- Gate: 52/97 critical+high resolved. Hive encrypted. Release signing. FLAG_SECURE. Bundle ID. CSV guard. QA re-run clean. Re-audit ≤10 LOW.
- Trust Layer target: 23→33/35

### Phase 1 — Behavioral Foundation (✅ COMPLETE) [2026-06-13]
- Wire 4 boundary events, add haptics, fix 3 contrast ratios, button active states, slider steppers, quiet affirmations, global onboarding skip
- TDD dispatch: `docs/planning/TDD_DISPATCH_PHASE_1_BEHAVIORAL_FOUNDATION.md`
- Effort: ~6 hours
- Score: Behavioral 62→68, UI/UX 78→83

### Phase 2 — Analytics Infrastructure (✅ COMPLETE) [2026-06-12]
- Hive event persistence, NudgeEventLogger, "next best action" dashboard card, Semantics coverage, cadence preference discovery
- TDD dispatch: `docs/planning/TDD_DISPATCH_PHASE_2_ANALYTICS_INFRASTRUCTURE.md`
- Effort: ~8 hours
- Score: Behavioral 68→76, UI/UX 83→89

### Phase 3 — Notification System (✅ COMPLETE) [2026-06-12]
- Push notifications (flutter_local_notifications v22), nudge evaluator engine (14 tests), in-app notification center with date-grouped timeline, nudge log persistence (Hive typeId 8), nudge effectiveness tracking (4 tests), evaluator→log→analytics loop wired into dashboard session start
- TDD dispatch: `docs/planning/TDD_DISPATCH_PHASE_3_NOTIFICATION_SYSTEM.md`
- Effort: ~12 hours
- Score: Behavioral 76→82

### Phase 4 — Doctrine Gap Closure (✅ COMPLETE) [2026-06-13]
- **Group 4A (Auth)**: Magic Link screen (email→inbox→verify), SessionEntity + Hive model (typeId 9), AuthRepository (abstract + mock datasource + Hive impl), Magic Link Riverpod providers, GoRouter 3-tier guard (Magic Link→PIN→Home), biometric abstraction ready for `local_auth`. 41 tests across domain/data/presentation.
- **Group 4B (Onboarding)**: Pain-point qualifier copy ("Have you ever spent money thinking a payment cleared...?"), Bangla rephrase on 12s inactivity, disqualification screen. 8 widget tests.
- **Group 4C (UI)**: Exclude-from-calculation toggle chip on income card (inline below amount, visible when excluded). `_IncomeListItem` → ConsumerWidget, `_toggleExclude()` calls `incomeNotifierProvider`.
- **Group 4D (Buffer %)**: Already done in D1.11 — buffer as percentage (5-30%, default 15%).
- **Group 4E (Instrumentation)**: 7 new event constants + 2 property keys. Wired to notification center, onboarding, dashboard stopwatch, S2S provider try/catch, SharedPrefs 30min window.
- TDD dispatch: `docs/planning/TDD_DISPATCH_PHASE_4_DOCTRINE_GAP_CLOSURE.md`
- Effort: ~20 hours
- Score: Behavioral 82→90, UI/UX 89→93, MVP 100%

### Phase 5 — V1 Features (🔲 BLOCKED — requires beta thresholds cleared)
- Multi-wallet, intra-wallet transfers, state colors, duplicate-last-entry, skeletons, ETA notifications
- TDD dispatch: `docs/planning/TDD_DISPATCH_PHASE_5_V1_FEATURES.md`
- Effort: ~15 hours
- Gate: Beta must clear all 5 thresholds (2+ misses = KILL)

### Phase 6 — V2 Features (🔲 BLOCKED — requires V1 stable + legal + pricing)
- Invoice-Lite (3 sprints), tax reserve, paid tiers, final 100% polish
- TDD dispatch: `docs/planning/TDD_DISPATCH_PHASE_6_V2_FEATURES.md`
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

> This roadmap was updated on 2026-06-04 to align with `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md`.
> The Final Doctrine is the authoritative source for version scope.
> Prior items superseded: Subscription Leakage Radar, Client/Project ROI, v0.3-pro-power, v1.0-cloud milestones.
