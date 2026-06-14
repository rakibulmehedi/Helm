# Doctrine-to-Code Gap Analysis

> Status: ACTIVE
> Date: 2026-06-04
> Authority: Final Product Doctrine (`docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md`)
> Scope: Compare current implemented app against Doctrine MVP requirements

---

## 1. Current Implementation Inventory

### Features Implemented (lib/features/)

| Feature | Directory | Status |
|---|---|---|
| Dashboard | `dashboard/` | S2S hero, income summary, expense list |
| Income Pipeline | `income/` | Full clean architecture (data/domain/presentation) |
| Safe-to-Spend | `safe_to_spend/` | Calculator, settings, hero widget, breakdown |
| Transactions | `transactions/` | CRUD, expense-only (legacy income hidden per D015) |
| Onboarding | `onboarding/` | Basic swipe cards |
| Splash | `splash/` | App launch screen |

### Core Infrastructure

| Component | Status |
|---|---|
| Riverpod state management | Stable |
| Hive persistence (3 boxes: transactions, income, fixed costs) | Stable |
| GoRouter navigation | Stable |
| Feature-first clean architecture | Enforced |
| Domain/data boundary | Clean (Phase 7f) |
| dart analyze 0/0/0 | Maintained |

---

## 2. Doctrine MVP Feature Mapping

### IMPLEMENTED (Aligned with Doctrine)

| # | Doctrine MVP Feature | Implementation | Notes |
|---|---|---|---|
| 3 | Single aggregated balance | SafeToSpendHero on dashboard | No wallet partitioning. Correct. |
| 4 | Income Pipeline (Expected/Pending/Received) | `IncomeEntryEntity` with 3-state enum | Fully implemented. 3 states match doctrine exactly. |
| 5 | One-tap Pending -> Received | Status quick-action transitions on income cards | Phase 7e complete. Swipe/tap gesture works. |
| 6 | Fixed Costs registry | `FixedCostEntry` + `FixedCostModel` (typeId 3) | CRUD in STS settings screen. Due day 1-28. |
| 7 | S2S hero metric (computed, never stored) | `SafeToSpendCalculator` pure Dart logic | Always computed from live data. Never persisted. Correct. |
| 8 | Calculation breakdown drawer | Bottom sheet in `SafeToSpendHero` | Shows all deductions transparently. |
| 13 | Safety buffer | `anxietyBuffer` in `StsSettings` | Default exists. Editable. |

### PARTIALLY IMPLEMENTED

| # | Doctrine MVP Feature | Current State | Gap |
|---|---|---|---|
| 2 | 3-minute conversational onboarding | Generic 3-page swipe ("Track expenses", "Set budget", "Financial freedom") | NOT conversational. Does NOT capture fixed costs, buffer %, income pattern. Copy conflicts with doctrine identity. Must be rebuilt. |
| 9 | Editable inputs (FX rate, expected date, exclude entry) | Expected date: editable. Currency: BDT/USD stored. | **No per-entry FX rate field.** No exclude-entry toggle per pipeline entry. USD entries are auto-excluded by calculator but user can't manually exclude BDT entries. |
| 14 | "---" fallback on calc failure | S2S shows "0" when no data. `rawSafeToSpend` can be negative (clamped to 0). | No explicit "---" display when calculation fails or inputs are stale. Need fallback UI for calc failure state. |
| 13 | 15% safety buffer (editable 5-30%) | Anxiety buffer exists but defaults to **৳0** (absolute BDT amount, not percentage). No enforced bounds. | Default must be 15% of received income. Range must be enforced at 5-30%. Type should be percentage, not absolute. |

### MISSING (MVP-Blocking Gaps)

| # | Doctrine MVP Feature | Status | Sprint Estimate |
|---|---|---|---|
| 1 | Magic Link auth + mandatory PIN/biometric | **MISSING** — no auth system at all | 2 sprints (backend decision required first per Doctrine S14) |
| 2 | Conversational onboarding | **MISSING** — current is generic, non-conversational | 1 sprint |
| 10 | Audit log on financial edits | **MISSING** — no event logging anywhere | 1 sprint |
| 11 | CSV data export | **MISSING** — only localization strings reference it | 0.5 sprint |
| 12 | Account deletion (full purge) | **MISSING** — no deletion flow | 0.5 sprint |
| 15 | Closed-beta instrumentation | **MISSING** — zero analytics/event tracking | 1 sprint |
| 9 | Editable FX rate per entry | **MISSING** — no FX rate field on income entries | 0.5 sprint |
| 9 | Exclude-entry flag per pipeline entry | **MISSING** — auto-exclude only for USD | 0.5 sprint |

---

## 3. Misaligned Features

| Current Feature | Doctrine Conflict | Resolution |
|---|---|---|
| Onboarding copy ("Track expenses", "Set budget", "Financial freedom") | Doctrine: Helm is NOT an expense tracker or budgeting app | Rewrite onboarding to conversational flow capturing fixed costs, buffer, income pattern |
| Tax rate slider in STS settings (Phase 8c) | Doctrine: Tax Reserve is V2, not MVP | **Keep as-is.** Current tax rate is a simple S2S deduction, not the full Tax Reserve feature (V2 includes audit-logged history, disclaimers, etc.). Rename to avoid confusion. |
| Transaction system supports income type | Decision 015 already hid legacy income | Aligned. No action needed. |
| `v0.2-cashflow-operations` milestone naming | Doctrine uses MVP/V1/V2/V3 naming | Updated in ROADMAP.md. Keep internal milestone for git tags. |

---

## 4. Stale/Superseded Documents

| Document | Status | Action |
|---|---|---|
| `docs/specs/SUBSCRIPTION_LEAKAGE_RADAR.md` | **SUPERSEDED** | Feature killed by doctrine. Mark header as superseded. |
| `docs/specs/VIRTUAL_WALLETS.md` | **SUPERSEDED for MVP** | Feature moved to V1. Mark header as deferred. |
| `docs/planning/POST_AUDIT_EXECUTION_ROADMAP.md` | **PARTIALLY SUPERSEDED** | Phase 9 references Subscription Leakage Radar (killed). Validation thresholds updated by doctrine. Core analysis still valid. |
| `docs/research/PRODUCT_STRATEGY_ANALYSIS.md` | **NEEDS REVIEW** | May contain F-commerce or generic expense tracking references |
| `docs/validation/VALIDATION_METRICS.md` | **NEEDS UPDATE** | Must align with Doctrine S4 thresholds (85/5/60/70/80) |
| `docs/Helm_ Brutal Product Audit.md` | **INPUT ONLY** | Pre-doctrine audit. Informational, not authoritative. |

---

## 5. Current App Alignment Summary

| Category | Score | Detail |
|---|---|---|
| Core S2S Engine | **90% aligned** | Formula, breakdown, exclusions all correct. Minor gaps: fallback display, buffer range verification. |
| Income Pipeline | **95% aligned** | 3-state model, status transitions, currency support all match doctrine. Missing: per-entry FX rate, exclude flag. |
| Trust Layer | **20% aligned** | No auth, no audit log, no export, no deletion. Major gaps. |
| Onboarding | **10% aligned** | Exists but wrong type (generic vs conversational) and wrong copy. |
| Instrumentation | **0% aligned** | Zero event tracking. Doctrine requires 9+ event types for beta. |
| Fixed Costs | **85% aligned** | Registry works. Due day range (1-28) matches doctrine. |
| Dashboard | **80% aligned** | S2S hero correct. Missing: state colors (Safe/Tight/At Risk is V1). |

**Overall MVP Readiness: ~55%**

Core product logic (S2S + Pipeline) is strong. Trust layer and instrumentation are the critical gaps.

---

## 6. Next Execution Priorities (Ordered by Doctrine Criticality)

### Priority 1: Trust Layer (MVP-Blocking)
1. Audit log on financial edits (Doctrine S10, Layer 4)
2. CSV data export (Doctrine S10, Layer 5)
3. Account deletion flow (Doctrine S10, Layer 5)

### Priority 2: Auth System (MVP-Blocking, Requires Backend Decision)
4. Backend stack decision (Supabase vs Next.js+Postgres — Doctrine S14)
5. Magic Link auth implementation
6. PIN/biometric gate on app open

### Priority 3: Onboarding + Instrumentation (Beta-Blocking)
7. Conversational onboarding (capture fixed costs, buffer, income pattern)
8. Closed-beta instrumentation (9 event types per Doctrine S16)

### Priority 4: Income Pipeline Polish (Quality)
9. Per-entry FX rate field
10. Exclude-entry toggle per pipeline entry
11. "---" fallback display on S2S calc failure

---

## 7. Doctrine Alignment vs Code Reality Matrix

```
DOCTRINE MVP SCOPE (15 features)
================================
  IMPLEMENTED    [======     ] 7/15 (47%)
  PARTIAL        [==         ] 4/15 (27%)
  MISSING        [====       ] 4/15 (27%)

TRUST LAYERS (8 layers)
========================
  ADDRESSED      [==         ] 2/8  (25%) — Layer 3 (agency), Layer 7 (partial storage)
  MISSING        [======     ] 6/8  (75%) — Layers 1,2,4,5,6,8
```

The app has strong product logic but is missing the trust infrastructure that the Doctrine treats as non-negotiable. The gap is not in the "what" (S2S + Pipeline are correct) but in the "how safely" (auth, audit, export, deletion, legal).
