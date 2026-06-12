# POCKETA — TASKS

> Reference: `docs/planning/100_PERCENT_MASTER_PLAN.md` (adopted 2026-06-12)

## Current Sprint

**Phase 0 / Sprint A5 — Bangla + Release Build** (🔲 PENDING, ~4h)

## In Progress

*None — A5 pending start*

## Completed UX Canon Sprints (16 sprints, 2026-05-22 to 2026-06-07)

1. [x] Sprint 1: UX-5 Visual Identity / Design System (12 tasks) — **COMPLETE [2026-06-05]**
2. [x] Sprint 2: UX-1 Dashboard Cockpit Redesign (14 tasks) — **COMPLETE [2026-06-05]**
3. [x] Sprint 3: UX-2 Onboarding Redesign (8/11 tasks) — **COMPLETE [2026-06-05]** (3 deferred)
4. [x] Sprint 4: UX-3 Pipeline Quick-Update (13 tasks) — **COMPLETE [2026-06-05]**
5. [x] Sprint 5: UX-4 Microcopy Replacement (8 tasks) — **COMPLETE [2026-06-06]**
6. [x] Sprint 6: D1 Trust Layer Foundation (11/12 tasks) — **COMPLETE [2026-06-06]** (D1.04 biometric deferred)
7. [x] Sprint 7: D2 Beta Instrumentation (6 tasks) — **COMPLETE [2026-06-06]**
8. [x] Sprint 8: D3 Closed Beta Readiness (8 tasks) — **COMPLETE [2026-06-06]**
9. [x] Sprint A1: Internal Alpha Maturity Audit — **COMPLETE [2026-06-07]**
10. [x] Sprint A2: Beta Blocker Resolution (8 tasks) — **COMPLETE [2026-06-07]**
11. [x] Sprint A3: First Impression Polish (3 tasks) — **COMPLETE [2026-06-07]**
12. [x] Sprint A4: Test Coverage + Design Stabilization (9 tasks) — **COMPLETE [2026-06-07]**

## Phase 0 — Beta Launch Readiness (A5) — PENDING

- [ ] A5.1 Author native Bangla strings (app_bn.arb) — Brand Guardian + Gemini CLI
- [ ] A5.2 Build release APK — Gemini CLI
- [ ] A5.3 Test on Samsung Galaxy A14 (or equivalent) — Antigravity
- [ ] A5.4 Verify Android minSdkVersion compatibility — Gemini CLI
- [ ] A5.5 Verify app icon and branded splash — Gemini CLI

## Phase 1 — Behavioral Foundation — PENDING (can start parallel with A5)

- [ ] P1.1-P1.4 Wire 4 boundary events (sts_at_risk_entered, reserve_depleted, first_pipeline_entry, pipeline_state_changed)
- [ ] P1.5-P1.8 Add haptic feedback (PIN taps, confirm/delete, errors, card tap)
- [ ] P1.9-P1.11 Fix 3 contrast ratios (stateSafe→#3D6B3C, stateTight→#8B6500, dark interactive→#4DA09C)
- [ ] P1.12 Add active/pressed visual states to buttons
- [ ] P1.13-P1.14 Add ±1% stepper buttons to tax rate + buffer sliders
- [ ] P1.15 Add global "Set up later" skip to onboarding
- [ ] P1.16-P1.18 Add quiet affirmation signals (pipeline up to date, 7/14 days tracked)

## Phase 2 — Analytics Infrastructure — PENDING (depends on Phase 1)

- [ ] P2.1-P2.7 Analytics infrastructure (Hive persistence, query methods, dedup, session tracking)
- [ ] P2.8-P2.11 Dashboard "next best action" card (4 state variants, Semantics)
- [ ] P2.12-P2.17 Semantics coverage (FAB, nav items, forms, switches, sliders)
- [ ] P2.18-P2.21 Cadence preference discovery (Hive model, preference sheet, post-onboarding, Settings link)

## Phase 3 — Notification System — PENDING (depends on Phase 2, requires pkg approval)

- [ ] P3.1-P3.6 Notification infrastructure (flutter_local_notifications, init, schedule daily/periodic)
- [ ] P3.7-P3.13 Nudge evaluator engine (rules provider, overdue/S2S/re-engagement/affirmation rules)
- [ ] P3.14-P3.18 In-app notification center (grouped list, Hive storage, badge, swipe-to-dismiss, tap-nav)
- [ ] P3.19-P3.25 Nudge copy (7 copy strings in Pocketa brand voice — Brand Guardian review)
- [ ] P3.26-P3.30 Nudge effectiveness tracking (SENT/OPENED/DISMISSED/ACTIONED + report)

## Phase 4 — Doctrine Gap Closure — PENDING (depends on Phase 0, can parallel with 1-3)

- [ ] P4.1-P4.9 Auth system (Magic Link + PIN/biometric, requires backend decision + legal L1-L7)
- [ ] P4.10-P4.15 Conversational onboarding rebuild (3-min flow, qualifier, disqualification)
- [ ] P4.16-P4.19 FX rate field + exclude-entry toggle per pipeline entry
- [ ] P4.20-P4.23 Buffer as percentage (5-30%, default 15%)
- [ ] P4.24-P4.28 Instrumentation hardening (6 new events)

## Phase 5 — V1 Features — BLOCKED (requires beta thresholds cleared)

- [ ] P5.1-P5.6 Multi-wallet (Payoneer, bKash, Bank, Cash + intra-wallet transfers)
- [ ] P5.7-P5.8 Dashboard state colors (Safe/Tight/At Risk)
- [ ] P5.9 Duplicate-last-entry pipeline template
- [ ] P5.10-P5.12 Empty/error/loading state polish + skeleton screens
- [ ] P5.13 Manual USD→BDT conversion with sanity validation
- [ ] P5.14-P5.15 Transactional ETA notifications

## Phase 6 — V2 Features — BLOCKED (requires V1 stable + legal L5 + pricing validation)

- [ ] P6.1-P6.3 Invoice-Lite Sprint 1 (form + list + sequential numbering)
- [ ] P6.4-P6.6 Invoice-Lite Sprint 2 (PDF + email + audit log)
- [ ] P6.7-P6.10 Invoice-Lite Sprint 3 (pipeline cascade + client profiles + overdue flagging)
- [ ] P6.11-P6.15 Tax reserve (user-declared %, disclaimed, audit-logged)
- [ ] P6.16-P6.20 Paid tier activation (Free/Pro/Power with feature gates)
- [ ] P6.21-P6.28 Final 100% polish (a11y audit, dark mode pass, haptic audit, Semantics audit, perf, tests, docs)
4. [ ] Sprint A5: Bangla + Release Build (~4h) — app_bn.arb, APK, device test

## Backlog (Post-Beta / Deferred)

- [ ] Virtual Wallets (V1 — after beta clears)
- [ ] Tax reserve (V2)
- [ ] Invoice-Lite (V2)
- [ ] Multi-currency conversion (V1)
- [ ] Supabase sync (V1+)
- [ ] Push notifications (V1 transactional only)

## Killed (Per Doctrine)

- ~~Custom categories~~ — generic expense tracker territory
- ~~Client/project profitability tracking~~ — different product
- ~~Budget goals~~ — banned concept
- ~~Savings buckets~~ — not in doctrine
- ~~AI smart insights~~ — hallucination risk
- ~~Subscription Leakage Radar~~ — not in doctrine scope

## Blocked

- None

## Done

## D3: Closed Beta Readiness — COMPLETED [2026-06-06]

### Completed
- [x] D3.01: Fix PIN deletion confirmation hash mismatch (base64 → SHA-256 PinHasher.verify)
- [x] D3.02: Create CLOSED_BETA_READINESS_CHECKLIST.md (46 checks, 37 PASS)
- [x] D3.03: Create MANUAL_QA_SCRIPT.md (13 QA sections)
- [x] D3.04: Create BETA_VALIDATION_PROTOCOL.md (4-week protocol, 5 metrics)
- [x] D3.05: Create TESTER_ONBOARDING_SCRIPT.md (WhatsApp templates)
- [x] D3.06: Create FOUNDER_OBSERVATION_SHEET.md (signal categories)
- [x] D3.07: Create GO_NO_GO_CRITERIA.md (decision framework)
- [x] D3.08: Create KNOWN_LIMITATIONS.md (17 limitations, 0 blockers)

---

## D2: Beta Instrumentation — COMPLETED [2026-06-06]

### Completed
- [x] D2.01: AnalyticsService abstract + LocalAnalyticsService
- [x] D2.02: event_registry.dart (15 event constants)
- [x] D2.03: Dashboard instrumentation (stsViewed, dailyActiveSession, breakdownOpened)
- [x] D2.04: Income pipeline instrumentation (pipelineEntryCreated)
- [x] D2.05: Confirm-received instrumentation (pipelineConfirmed, undoConfirmUsed)
- [x] D2.06: PIN/export/deletion instrumentation

---

## UX-5: Visual Identity / Design System Foundation — COMPLETED [2026-06-05]

### Completed
- [x] UX-5.01: pocketa_colors.dart — ThemeExtension, 13 tokens, light+dark
- [x] UX-5.02: pocketa_typography.dart — Inter/JetBrains Mono/Hind Siliguri, 18 styles
- [x] UX-5.03: pocketa_spacing.dart — 8pt grid tokens + component dimensions
- [x] UX-5.04: pocketa_motion.dart — timing tokens, ease-out only
- [x] UX-5.05: app_theme.dart rebuilt — new tokens, legacy API preserved
- [x] UX-5.06: PocketaAmount widget — mono font, BDT/USD, lakh/crore
- [x] UX-5.07: PocketaLedgerRail widget — state rail with label
- [x] UX-5.08: PocketaTrustStrip widget — timestamp/source/audit strip
- [x] UX-5.09: PocketaToast widget — financial-safe snackbar
- [x] UX-5.10: 5 card widgets — HeroZone, LedgerCard, AuditCard, SourceCard, CautionCard
- [x] UX-5.11: number_formatter.dart — BDT lakh/crore, USD Western
- [x] UX-5.12: dart analyze 0/0/0 verified

---

- [x] UX Canon Extraction & Implementation Planning Sprint (2026-06-05)
  - 10 source docs processed, 12 extracted docs, 1 canonical spec, 3 planning docs, 81 tasks defined
- [x] Phase 0: Foundation
- [x] Phase 1: Transaction data layer
- [x] Phase 2: Add transaction UI
- [x] Phase 3: Dashboard summary/list
- [x] Phase 3.5: Stabilization & UX polish
- [x] Phase 4: Filtering/date grouping
- [x] Phase 5: Edit transaction
- [x] Phase 6: UX hardening
- [x] Agentic Engineering OS documentation
- [x] Research-to-spec refinement (2026-05-22)
- [x] Phase 7 spec finalized (2026-05-22)
- [x] Income Pipeline MVP spec created (2026-05-22)
- [x] Safe-to-Spend Model spec created — hypothesis stage (2026-05-22)
- [x] Virtual Wallets spec created — future phase (2026-05-22)
- [x] Subscription Leakage Radar spec created — Phase 9 candidate (2026-05-22)
- [x] Phase 7a — Income Data Layer (2026-05-22)
- [x] Phase 7b — Income Entry UI (2026-05-22)
- [x] Phase 7c — Income List & Filtering (2026-05-22)
- [x] Phase 7d — Dashboard Integration (2026-05-22)
- [x] Phase 7e — Status Transitions & UX Hardening (2026-05-22)
- [x] Phase 7f — Storage Abstraction & Domain Cleanup (2026-05-23)
- [x] Phase 8a — Formula & Data Contract: formula locked, 10 ECs defined, data contract finalized (2026-05-23)
- [x] Phase 8b — Calculation Engine: pure Dart logic, models, Hive data layer, providers, tests (2026-05-23)
- [x] Phase 8c — Settings Screen: tax rate slider, anxiety buffer input, fixed costs CRUD (2026-05-23)
- [x] Phase 8d — Dashboard Hero Number: `SafeToSpendHeroCard`, breakdown on tap, Horizon Number (2026-05-23)
- [x] Phase 8e — UX Hardening: rawSafeToSpend state detection fix, slider assertion fix, buffer validation, deduction color polish, USD exclusion row, reserve-mode breakdown note (2026-05-23)
- [x] Phase 8f — Real Device QA + Validation Prep: QA checklist, scenario matrix, founder validation script, user interview questions, validation metrics (2026-05-23)
- [x] Pre-Flight Deep QA Validation Sprint: Adversarial audit, bug fixes for Dashboard Income mismatch, and AddTransaction strict expense enforcement (2026-05-23)
- [x] Phase 9a — Cognitive Persona Simulation QA (2026-05-23)
- [x] Phase 9b — Hypothesis-Based Validation Sprint (2026-05-23)
