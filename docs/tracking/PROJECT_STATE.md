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
- UX gap improvements phase 2 (June 2026: 13 UX improvements across 11 files — haptics, floating tooltip, page entry animations, semantics, zero-state reask animation, responsive layout, error iconography, empty states, shimmer skeleton system, IncomePattern.none enum + onboarding skip button (temp — remove before release))
- **security hardening S1-W4 complete** (June 2026: Waves 1-2 remediation — secret hygiene, platform hardening, trust-layer bugs, crypto/storage, input validation/sanitization, audit log hardening, lint sweep; `dart analyze` 0 issues, 251 tests pass)
- **S1 task mapping** (June 2026: 43/97 adversarial-audit tasks verified done in source/tests; 54 pending, with highest remaining risks documented in `docs/tracking/TASKS.md`)

## 2. Frozen Systems
*(Do NOT heavily refactor without explicit approval)*
- transaction provider structure
- Hive architecture
- routing structure
- localization system

## 3. Readiness Status

**Current Verdict: SPRINT S1 IN PROGRESS — Security Hardening (Adversarial Audit Remediation)** (2026-06-14)
- **Adversarial audit complete**: 12 agents, 97 findings (17 CRITICAL, 35 HIGH, 33 MEDIUM, 12 LOW)
- **Sprint S1 active**: 97 vulnerability fixes across 7 waves, ~40h estimated
- **S1-W4 complete** (2026-06-14) — Secret hygiene, platform hardening, trust-layer bugs, crypto/storage, input validation/sanitization, audit log hardening, lint sweep. `dart analyze` 0 issues, 251 tests pass.
- Phase 4 complete (2026-06-13) — Magic Link auth, instrumentation hardening, 210 tests
- A5.1 ✅ — 96 Bangla ARB keys authored (native, not machine-translated)
- A5.2 ⏳ — build config fixed; needs keystore + actual flutter build apk --release (human)
- A5.3 ⏳ — blocked on A5.2
- A5.4 ✅ — minSdk 21 compatible with Galaxy A14 (API 33)
- A5.5 ✅ — splash #FAFAF6, iOS name "Helm"; icons still default (needs designer)
- Core S2S engine + dashboard + pipeline: production-grade
- **Security posture**: HIGH — at-rest Hive encryption enabled, root/jailbreak detection wired, PIN KDF hardened, input sanitized, audit log tamper-evident, export CSV sanitized; remaining work is platform signing/obfuscation and release build verification
- Distance to closed beta: Security hardening completion + A5 APK build + device test
- Distance to 100% maturity: ~85h (master plan) + ~25h (remaining security sprint) = ~110h
- **Master plan**: `docs/planning/100_PERCENT_MASTER_PLAN.md` (adopted 2026-06-12)
- **Security audit**: `.commandcode/adversarial_audit_report.md` (2026-06-14)
- **Agent assets**: 10 agent definitions in `.claude/agents/` (all general-purpose, no codebase hardcoding)
- See `docs/beta/INTERNAL_ALPHA_MATURITY_AUDIT.md` for full report
- See `docs/planning/100_PERCENT_MASTER_PLAN.md` for complete 6-phase roadmap

## 4. Known Technical Debt
- categories currently placeholder string labels
- no formal wallet model yet
- no sync abstraction yet
- Analytics: debugPrint-only, no Hive persistence, no nudge effectiveness tracking — RESOLVED in Phase 2/3
- No "next best action" guidance on dashboard (passive state display only) — RESOLVED in Phase 2
- No cadence/personalization preferences — RESOLVED in Phase 2
- Client/Project ROI tracking — different product
- Charts/reports without S2S context — noise
- **SECURITY DEBT (97 findings from Sprint S1 — IN PROGRESS; S1-W4 complete)**:
  - Auth: PIN KDF hardened (SHA-256 + salt), lockout expiry fixed, magic-link validation tightened; remaining: 4→6 digit PIN, rate-limit per-email, token brute-force (mock backend)
  - Storage: Hive encryption enabled, schema version constant added, audit tamper-evidence chain added; remaining: full migration framework
  - Input: central `InputValidator` live, CSV formula injection guarded, route params validated; remaining: per-field maxLength, formatters
  - State: unawaited futures fixed, catch clauses typed; remaining: TOCTOU races, notifier disposal guards
  - Platform: root/jailbreak detection wired, FLAG_SECURE configured, backup disabled; remaining: release signing/obfuscation, bundle ID change
  - Dependencies: migrated to `hive_ce`; remaining: `google_fonts` runtime network review, version pinning policy
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