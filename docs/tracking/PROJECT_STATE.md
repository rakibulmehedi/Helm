# PROJECT STATE

> Overview of the current architecture, stable systems, and technical debt.

## 1. Current Stable Systems
- onboarding
- localization
- routing
- Hive persistence
- transaction CRUD
- dashboard summaries
- filtering/grouping
- edit flow
- undo delete
- UX hardening
- income pipeline (Phase 7 complete: data layer, entry UI, list/filter, dashboard, status transitions)
- transaction domain abstraction (Phase 7f complete: TransactionEntity, clean repository interface, Hive boundary enforcement)
- safe-to-spend engine (Phase 8 complete: calculator, settings, hero, breakdown, UX hardening)
- trust layer (D1 complete: PIN auth, audit log, CSV export, account deletion)
- beta instrumentation (D2 complete: 15 analytics events, LocalAnalyticsService)
- behavioral audit system (June 2026: behavioral nudge audit + UI/UX audit + synthesized analysis + nudge engine deliverables)
- master plan documentation (June 2026: 100% master plan, 6 phases, 145+ tasks)
- agent infrastructure (10 agent definitions in .claude/agents/)
- behavioral foundation (June 2026: Phase 1 complete — 4 boundary events, 5 haptic types, 3 WCAG AA contrasts, button pressed states, slider stepper buttons, onboarding global skip, quiet affirmations in trust strip)
- notification system (June 2026: Phase 3 complete — push notifications via flutter_local_notifications, nudge evaluator engine, Hive log persistence, notification center UI with badge, effectiveness tracking, dashboard session loop)
- doctrine gap closure (June 2026: Phase 4 complete — Magic Link auth, conversational qualifier, exclude toggle UI, instrumentation hardening, 210 tests, dart analyze 0/0/0)
- beta build config (June 2026: Sprint A5 in progress — pubspec version 0.3.0-beta.1+1, app label "Helm", splash #FAFAF6, iOS display name "Helm", 96 Bangla ARB keys authored)
- branded app icon (June 2026: VISR-029 ledger-rail + BDT mark, deep teal/warm-white master source, Android adaptive + Android/iOS/macOS/web raster sets)
- UX gap improvements phase 2 (June 2026: 13 UX improvements across 11 files — haptics, floating tooltip, page entry animations, semantics, zero-state reask animation, responsive layout, error iconography, empty states, shimmer skeleton system, IncomePattern.none enum + onboarding skip button (temp — remove before release))
- **security hardening S1-W5 complete** (June 2026: Waves 4-6 continuation — state-machine enforcement, fixed-cost integrity, consecutive-day streak, navigation/race guards, notification lock-screen privacy, export double-submit, SDK constraint pinned, calculator/STS hardening; `dart analyze` 0 issues, 282 tests pass)
- **Signal Deck UI shell merged** (June 2026: Signal Hero, Signal Horizon, Decision Deck, Flow route, calculation trace sheet, dashboard home, shell nav, confirm haptics; `dart analyze` 0 issues, `flutter test` 307/307 pass)
- **release APK optimized** (June 2026: APK shrunk 57→20.8MB via `--tree-shake-icons` + arm64-only target; APK signature verification added; SSL pinning infrastructure created; KGP deprecation warning acknowledged as unfixable without Flutter SDK upgrade; `dart analyze` 0 warnings/errors, build clean)

## 2. Frozen Systems
*(Do NOT heavily refactor without explicit approval)*
- transaction provider structure
- Hive architecture
- routing structure
- localization system

## 3. Readiness Status

**Current Verdict: S1-W6 — QA PRE-RELEASE FIXES (2026-06-15)**
- **QA Gate Execution**: 10 gates run against release APK on physical device. 6 failed, 3 conditional pass, 1 pass. **Release Verdict: NO GO.** 9 findings (2 BLOCKER, 4 HIGH, 2 MEDIUM, 1 LOW).
- **Fix Dispatch**: `docs/planning/QA_FIX_DISPATCH.md` — 9 fixes across 12 files + 7 font assets. Execution order: BLOCKERs → HIGHs → MEDIUM/LOW.
- **S1-W5 complete** (2026-06-14) — State-machine enforcement, fixed-cost integrity, consecutive-day streak, navigation/race guards, notification lock-screen privacy, export double-submit, SDK constraint pinned, calculator/STS hardening. `dart analyze` 0 issues, 282 tests pass.
- **S1-W4 complete** (2026-06-14) — Secret hygiene, platform hardening, trust-layer bugs, crypto/storage, input validation/sanitization, audit log hardening, lint sweep. `dart analyze` 0 issues, 251 tests pass.
- **Adversarial audit**: 97 findings total. 3 new findings surfaced by QA gates (API 21→24 regression, account deletion incomplete, audit CSV chain hashes missing).
- Phase 4 complete (2026-06-13) — Magic Link auth, instrumentation hardening, 210 tests
- Signal Deck UI slice complete (2026-06-16) — premium spatial editorial shell merged, verified, and documented
- A5.1 ✅ — 96 Bangla ARB keys authored (native, not machine-translated)
- A5.2 ⏳ — build config fixed; needs keystore + actual flutter build apk --release (human)
- A5.3 ⏳ — blocked on A5.2
- A5.4 ✅ — minSdk 21 compatible with Galaxy A14 (API 33) — **REGRESSION: current APK resolves to API 24. Fix in QA_FIX_DISPATCH Fix 1.**
- A5.5 ✅ — splash #FAFAF6, iOS name "Helm", branded app icons installed across Android/iOS/macOS/web
- Core S2S engine + dashboard + pipeline: production-grade
- **Distance to closed beta**: 9 fixes (est. ~6h) + A5 APK build + device re-test
- **Master plan**: `docs/planning/100_PERCENT_MASTER_PLAN.md` (adopted 2026-06-12)
- **Security audit**: `.commandcode/adversarial_audit_report.md` (2026-06-14)
- **QA fix dispatch**: `docs/planning/QA_FIX_DISPATCH.md` (2026-06-15)
- See `docs/beta/INTERNAL_ALPHA_MATURITY_AUDIT.md` for full report

## 4. Known Technical Debt
- categories currently placeholder string labels
- no formal wallet model yet
- no sync abstraction yet
- Analytics: debugPrint-only, no Hive persistence, no nudge effectiveness tracking — RESOLVED in Phase 2/3
- No "next best action" guidance on dashboard (passive state display only) — RESOLVED in Phase 2
- No cadence/personalization preferences — RESOLVED in Phase 2
- Client/Project ROI tracking — different product
- Charts/reports without S2S context — noise
- **SECURITY DEBT (97 findings from Sprint S1 — IN PROGRESS; S1-W4 + S1-W5 complete)**:
  - Auth: magic-link completion awaited, used-token store now persistent, rate-limit and token-reuse guards tested; remaining: client-side-only trust model, onboarding guard
  - State: fixed-cost duplicate-ID guard, income status transitions enforced, export double-submit guard, consecutive-day streak; remaining: delete-account rollback, null-assert theme extensions
  - Platform: splash timer cancelled, notification lock-screen privacy set; remaining: release signing/obfuscation, bundle ID change (Android done), custom lint rules
  - Input/CSV: currency case normalization, fxRate<=0 exclusion, RTL/formula CSV scrubbing; remaining: full per-field formatter sweep
  - Business logic: STS default fallback audit-logged, calculator returns failure on exception; remaining: STS buffer migration, USD-without-FX warning badge
  - Dependencies: `sdk` constraint pinned; remaining: `google_fonts` runtime download (assets pending), version pinning policy
  - Full inventory: `.commandcode/adversarial_audit_report.md`

## 5. Current Architecture
- Framework: Flutter
- State Management: Riverpod
- Storage: Hive
- Navigation: GoRouter
- Paradigm: Offline-first

## 6. Completed Phase Summary

All phases through S1-W4 complete. See CURRENT_SPRINT.md for detailed sprint records and DECISION_LOG.md for decisions.

| Phase | Status | Key Outcome |
|-------|--------|-------------|
| Phase 7 (Income Pipeline) | ✅ DONE | IncomeEntryEntity, Hive typeId:2, full CRUD UI |
| Phase 7f (Storage Abstraction) | ✅ DONE | TransactionEntity pure Dart, Hive boundary enforced |
| Phase 8 (Safe-to-Spend) | ✅ DONE | Calculator, settings, hero, breakdown, UX hardening |
| Phase 9a/9b (QA Validation) | ✅ DONE | Hypotheses validated, friction points identified |
| UX Canon (8 sprints) | ✅ DONE | 81 tasks, design system ~90%, 78 tests |
| A1–A4 (Alpha) | ✅ DONE | All blockers resolved, 104 tests |
| Phase 1–4 (Behavioral/Auth) | ✅ DONE | 210 tests, 0/0/0 analyze |
| S1-W4 (Security) | ✅ DONE | 251 tests, platform/crypto/input hardened |

## 5b. D1 Trust Layer — COMPLETE (2026-06-06)

PIN auth, audit log (typeId:5), CSV export, account deletion, buffer % migration. D1.04 biometric deferred (needs package approval). See CURRENT_SPRINT.md for full D1 record.

## 5c. D2 Beta Instrumentation — COMPLETE (2026-06-06)

`AnalyticsService` + `LocalAnalyticsService`, 15 event constants, all screens wired. Zero PII/persistence/third-party SDK.

## 5d. D3 Closed Beta Readiness — COMPLETE (2026-06-06)

7 beta docs created. 17 limitations documented, 0 blockers. Verdict superseded by A1 audit → INTERNAL ALPHA READY.

## 6a–6e. Alpha Sprints A1–A4 + Phase 1 — ALL COMPLETE (2026-06-07 to 2026-06-13)

Alpha sprints A1–A4 complete 2026-06-05 to 2026-06-13 — see CURRENT_SPRINT.md for full records.
- A1: Internal alpha audit (3 blockers, 5 majors identified)
- A2: All blockers resolved, 0 beta blockers remaining, 78/78 tests
- A3: First impression polish, first_pipeline_page.dart, S2S hint banner
- A4: +40 tests (78→78), design system migration ~90%
- Phase 1: Behavioral Foundation complete — 7 groups, +26 tests (78→104), see DECISION_LOG.md Decision 026

## 7. Blocked Modules
- Cloud sync (requires authentication decision + backend stack lock per Doctrine §14)
- Biometric auth (D1.04 deferred — needs `local_auth` package approval)
- Push notifications (Phase 3 — needs `flutter_local_notifications` package approval)
- Auth system (Phase 4 — needs backend stack decision + legal L1-L7)
- Multi-wallet (Phase 5 — gated on beta thresholds cleared)
- Invoice-Lite / Tax reserve / Paid tiers (Phase 6 — gated on V1 stable + legal L5 + pricing validation)

## 7b. Planned Modules (Master Plan — `docs/planning/100_PERCENT_MASTER_PLAN.md`)

| Module | Phase | Status | Gate |
|--------|-------|--------|------|
| Bangla localization | 0 (A5) | Pending | — |
| Analytics persistence (Hive) | 2 | Pending | Depends Phase 1 |
| Next-best-action card | 2 | Pending | Depends Phase 1 |
| Full Semantics coverage | 2 | Pending | — |
| Cadence preference UI | 2 | Pending | — |
| Notification system (push + center) | 3 | Pending | Depends Phase 2 + pkg approval |
| Nudge evaluator engine | 3 | Pending | Depends Phase 2 |
| Nudge effectiveness tracking | 3 | Pending | Depends Phase 2 |
| Magic Link auth system | 4 | Pending | Depends Phase 0 + legal + stack |
| Conversational onboarding | 4 | Pending | — |
| FX rate per-entry + exclude toggle | 4 | Pending | — |
| Buffer as percentage (5-30%) | 4 | Pending | — |
| Multi-wallet system | 5 | Blocked | Beta thresholds |
| Dashboard state colors | 5 | Blocked | Beta thresholds |
| Skeleton screens | 5 | Blocked | Beta thresholds |
| Invoice-Lite (3 sprints) | 6 | Blocked | V1 stable + legal L5 |
| Tax reserve (user-declared) | 6 | Blocked | V1 stable |
| Paid tiers (Free/Pro/Power) | 6 | Blocked | V1 stable + pricing valid |

> Phase 1 modules (boundary events, haptics, contrast fixes, affirmations, button states, slider steppers, onboarding skip): all DONE — see §1 Stable Systems.

## 7b. Version Control Gap

> **Discovered: 2026-06-13 (Comprehensive Implementation Plan audit)**

The project runs entirely on `main` with zero branching strategy. 60 commits in 13 days all direct to `main`. No `feature/`, `release/`, `develop`, or `hotfix/` branches. pubspec.yaml still shows `1.0.0+1` — unchanged from initial scaffold.

**Impact**: Beta testers reporting bugs on a main-only workflow means either (a) fix on main and ship a broken beta, (b) can't patch without shipping everything in progress, (c) hold fixes until next full commit.

**Resolution**: See `docs/planning/COMPREHENSIVE_IMPLEMENTATION_PLAN.md` §2 (Sprint A5.5 — VCI Infrastructure). Must be resolved before beta APK distribution.

## 8. Current Product Direction (per Final Doctrine)
- Focus: Freelancer Cashflow Clarity
- Identity: Single-purpose calm cockpit for Bangladeshi USD-earning freelancers
- Core Wedge: Pipeline-aware Safe-to-Spend
- Target: $800–$3,000/month USD earners using Payoneer/nsave/ElevatePay
- MVP Goal: Validate manual pipeline maintenance + S2S trust
- Next: Release build verification → APK distribution → Closed Beta (15-25 freelancers, 4 weeks)
- Strategic Authority: `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md`

## 9. Doctrine-Killed Features
- F-commerce / COD / inventory / POS — wrong product entirely
- Generic expense categorization — TallyKhata territory
- Subscription Leakage Radar — not in doctrine scope
- AI insights / financial advice — hallucination risk
- Gamification — patronizing
- Charts/reports without S2S context — noise
- Client/Project ROI tracking — different product

## 10. Doctrine-Deferred Features
- Multi-wallet → V1 (after MVP beta clears)
- Tax reserve → V2 (user-declared %, not algorithmic)
- Invoice-Lite → V2 (3-sprint allocation)
- Push notifications → V1 transactional only (never engagement)
- Reports/charts → V3
- Email auto-ingestion → V4+ if ever
