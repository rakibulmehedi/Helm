# POCKETA — TASKS

## Current Sprint

Sprint: UX Canon Implementation — Sprint 3 (UX-2 Onboarding Redesign)

## In Progress

- [ ] UX Canon Implementation (8 sprints, 81 tasks — see `docs/planning/UX_EXECUTION_TODO.md`)

## Next (Sprint Order)

1. [x] Sprint 1: UX-5 Visual Identity / Design System (12 tasks) — **COMPLETE [2026-06-05]**
2. [x] Sprint 2: UX-1 Dashboard Cockpit Redesign (14 tasks) — **COMPLETE [2026-06-05]**
3. [ ] Sprint 3: UX-2 Onboarding Redesign (11 tasks) — **START HERE**
4. [ ] Sprint 4: UX-3 Pipeline Quick-Update (10 tasks)
5. [ ] Sprint 5: UX-4 Microcopy Replacement (8 tasks)
6. [x] Sprint 6: D1 Trust Layer Foundation (11/12 tasks) — **COMPLETE [2026-06-06]** (D1.04 biometric deferred)
7. [ ] Sprint 7: D2 Beta Instrumentation (6 tasks)
8. [ ] Sprint 8: D3 Closed Beta Readiness (8 tasks)

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
