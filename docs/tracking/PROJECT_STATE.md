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
- **security hardening sprint initiated** (June 2026: Sprint S1 — 12-agent adversarial audit found 97 vulnerabilities, full remediation sprint active)

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
- Phase 4 complete (2026-06-13) — Magic Link auth, instrumentation hardening, 210 tests
- A5.1 ✅ — 96 Bangla ARB keys authored (native, not machine-translated)
- A5.2 ⏳ — build config fixed; needs keystore + actual flutter build apk --release (human)
- A5.3 ⏳ — blocked on A5.2
- A5.4 ✅ — minSdk 21 compatible with Galaxy A14 (API 33)
- A5.5 ✅ — splash #FAFAF6, iOS name "Helm"; icons still default (needs designer)
- Core S2S engine + dashboard + pipeline: production-grade
- **Security posture**: CRITICAL — all auth client-side, no encryption at rest, no root detection
- Distance to closed beta: Security hardening completion + A5 APK build + device test
- Distance to 100% maturity: ~85h (master plan) + ~40h (security sprint) = ~125h
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
- **SECURITY DEBT (97 findings from Sprint S1 — IN PROGRESS)**:
  - Auth: client-side trust chain, no encryption at rest, 4-digit PIN, brute-force vectors
  - Storage: zero Hive encryption, schema versioning absent, type confusion crash vectors
  - Input: no sanitization on free-text fields, CSV formula injection, no maxLength
  - State: provider disposal safety gaps, assert-stripped validation, TOCTOU races
  - Platform: no root/jailbreak detection, debug signing, no obfuscation, `com.example.helm`
  - Dependencies: abandoned Hive, google_fonts runtime network, caret version ranges
  - Full inventory: `.commandcode/adversarial_audit_report.md`

## 5. Current Architecture
- Framework: Flutter
- State Management: Riverpod
- Storage: Hive
- Navigation: GoRouter
- Paradigm: Offline-first

## 6. Active Modules
- **Phase 7 COMPLETE**: Freelancer Income Pipeline (all sub-phases 7a–7e done)
  - income domain entity, Hive model (typeId:2), local data source, repository, providers — stable
  - income add/edit form screen with full validation — stable
  - income list screen with status filter chips, income cards, delete+undo, empty states — stable
  - /income route wired; accepts optional initialFilter for deep-link from dashboard
  - dashboard income pipeline summary: Expected/Pending/Received totals, calm colors, empty state, tap-to-filter navigation
  - status quick-action transitions (Expected→Pending, Pending→Received), UX hardening, financial trust fixes
- **Phase 7f COMPLETE**: Storage Abstraction & Domain Cleanup
  - `TransactionEntity` created (pure Dart, zero Hive/Flutter imports)
  - `TransactionType` enum cleaned (Hive adapter moved to `data/adapters/` layer)
  - `TransactionRepository` interface now accepts/returns `TransactionEntity`
  - `TransactionRepositoryImpl` maps entity↔model internally — data layer boundary enforced
  - `TransactionModel` now has `fromEntity()`, `toEntity()`, `fromJson()`, `toJson()`
  - `IncomeModel` now has `fromJson()`, `toJson()`
  - Zero Hive imports in domain or presentation layers
  - `dart analyze` clean: 0/0/0
- **Phase 8b COMPLETE**: Safe-to-Spend Calculation Engine
  - `SafeToSpendCalculator` built as pure Dart logic with 10 edge cases tested.
  - `FixedCostEntry`, `StsSettings`, `SafeToSpendResult` domain value objects.
  - `FixedCostModel` (typeId 3) registered with Hive.
  - `safe_to_spend_providers.dart` Riverpod providers set up.
- **Phase 8c COMPLETE**: Safe-to-Spend Settings Screen
  - `StsSettingsScreen` built with tax rate slider, anxiety buffer input, and fixed costs CRUD.
- **Phase 8d COMPLETE**: Safe-to-Spend Dashboard Hero
  - `SafeToSpendHero` replaces raw Total Balance on the dashboard.
  - Transparent math breakdown via bottom sheet.
  - Excludes pending and expected income safely.
- **Phase 8e COMPLETE**: Safe-to-Spend UX Hardening
  - Critical fix: `rawSafeToSpend` used for "In reserve mode" / "Fully allocated" state detection (was always dead code).
  - Critical fix: tax slider max capped at 40% (entity asserts ≤ 0.40; slider was 50%).
  - Anxiety buffer validation: explicit SnackBar on invalid input; `FilteringTextInputFormatter` added.
  - Breakdown deduction rows use `AppColors.textSecondary` not `AppColors.error` (no anxiety-inducing red).
  - USD exclusion transparency row added to breakdown when `excludedUsdIncome > 0`.
  - Reserve-mode context note added to breakdown when `rawSafeToSpend < 0`.
  - `Colors.grey` replaced with `AppColors.textSecondary` throughout settings screen.
- **Phase 8f COMPLETE**: Real Device QA + Validation Prep
  - `PHASE_8_REAL_DEVICE_QA_CHECKLIST.md` for manual device testing.
  - `SAFE_TO_SPEND_SCENARIO_MATRIX.md` for formula edge cases.
  - `FOUNDER_VALIDATION_SCRIPT.md` and user interview questions prepared.
  - `VALIDATION_METRICS.md` defined for assessing product-market fit.
- **Pre-Flight Deep QA Complete**: Found and fixed trust mismatch on Dashboard Income chip. Re-routed to `SafeToSpendResult`. Hardened `AddTransactionScreen` to strictly enforce `TransactionType.expense` and dropped legacy income categories. Ready for human QA.
- **Phase 8 COMPLETE** — Safe-to-Spend engine is production-grade.
- **Phase 9a COMPLETE** — Cognitive Persona Simulation QA. Validated core concepts, identified friction points (manual pipeline status updates).
- **Phase 9b COMPLETE** — Hypothesis-Based Validation Sprint. Core hypotheses validated as strong, while manual maintenance discipline flagged as critical risk.
- **UX Canon Extraction & Planning COMPLETE** (2026-06-05)
  - 10 source docs processed, 12 extracted docs, 1 canonical spec, 3 planning docs
  - 81 implementation tasks across 8 sprints defined
  - 7 doc conflicts resolved via authority hierarchy
  - 33 code-vs-doctrine gaps documented, 8 MVP-blocking
  - See `docs/ux/HELM_CANONICAL_UX_IMPLEMENTATION_SPEC.md` for canonical spec
  - See `docs/planning/UX_EXECUTION_TODO.md` for task list
- **Sprint 1 (UX-5) COMPLETE** (2026-06-05): Visual Identity / Design System — 12 tasks, dart analyze 0/0/0
- **Next**: Sprint 2 (UX-1 Dashboard Cockpit Redesign) — 14 tasks

## Visual Foundation Status (2026-06-05)
- Token system: STABLE (helm_colors, helm_typography, helm_spacing, helm_motion)
- app_theme.dart: REBUILT (new tokens, legacy shim intact)
- Core widgets: STABLE (HelmAmount, HelmLedgerRail, HelmTrustStrip, HelmToast)
- Card widgets: STABLE (HeroZone, LedgerCard, AuditCard, SourceCard, CautionCard)
- NumberFormatter: STABLE
- Feature files: NOT YET migrated to new tokens (still using AppColors.* via re-export)

## 5b. D1 Trust Layer — COMPLETE (2026-06-06) + D1P Security Patch (2026-06-06)

- **D1.01-03 Auth module**: PIN setup + PIN entry screens, Riverpod auth state, Hive `auth_box`, GoRouter redirect guard on cold start + resume
- **D1P PIN security**: SHA-256 + per-setup salt via `crypto:^3.0.3`. `PinHasher` domain class (`lib/features/auth/domain/pin_hasher.dart`) — 8 unit tests pass. Old base64 hashes migrated → force re-setup. `authenticate()` logic bug fixed (was checking `isLocked` instead of `failedAttempts >= max`).
- **D1.05-07 Audit log**: `AuditEvent` entity, `AuditEventModel` (typeId:5), append-only `AuditLocalDataSourceImpl`, wired to all financial write paths (income/transaction/fixed cost/STS settings), `AuditLogScreen` accessible from Settings
- **D1.08-09 CSV export**: `ExportService` generates 5 CSVs (income/transactions/fixed_costs/settings/audit), saves to documents dir, then triggers native share sheet via `Share.shareXFiles` (`share_plus: ^10.1.2`). `ExportScreen` accessible from Settings. Beta blocker resolved (Decision 026 updated).
- **D1.10 Account deletion**: 2-step destructive flow — warning screen + PIN confirmation dialog (or type-DELETE fallback), clears all 6 Hive boxes + SharedPreferences, routes to welcome
- **D1.11 Buffer % conversion**: `anxietyBuffer` (absolute BDT) → `bufferPercent` (5–30%, default 15%), SharedPrefs migration, STS settings slider 5–30%, all 30 calculator tests pass
- **D1.04 Biometric**: Deferred — needs `local_auth` package approval. Tracked as explicit beta blocker (Decision 026).

Hive typeId registry updated: AuditEventModelAdapter=5 registered.
New routes: `/pin-setup`, `/pin-entry`, `/audit-log`, `/delete-account`, `/export-data`

## 5c. D2 Beta Instrumentation — COMPLETE (2026-06-06)

- `AnalyticsService` abstract + `LocalAnalyticsService` (debugPrint, kDebugMode-gated)
- `event_registry.dart` — 15 event constants (10 transactional, 5 boundary)
- Dashboard, income, pipeline, PIN, export, deletion screens wired
- Zero PII, zero persistence, zero third-party SDK

## 5d. D3 Closed Beta Readiness — COMPLETE (2026-06-06)

- **Critical bug fixed**: PIN deletion confirmation used `base64Encode` instead of `PinHasher.verify()` — account deletion was broken for PIN-protected users
- 7 beta docs created in `docs/beta/`: readiness checklist, manual QA script, validation protocol, tester onboarding script, founder observation sheet, go/no-go criteria, known limitations
- Quality gate: dart analyze 0/0/0, flutter test 38/38 pass, Hive TypeIds clean, all routes healthy
- 17 known limitations documented, 0 beta blockers remaining
- Verdict: **CONDITIONAL GO** — pending release build verification on device + tester recruitment
- **NOTE**: D3 verdict downgraded to INTERNAL ALPHA READY by A1 audit (see §3 above)

## 6a. A1 Internal Alpha Maturity Audit — COMPLETE (2026-06-07)

- Full code inspection: 103 Dart files, 15 flows, all screens
- **3 Beta Blockers**: B1 (audit log unreachable), B2 (auth guard cold-start gap), B3 (missing "---" S2S fallback)
- **5 Major Issues**: M1 (STS Settings legacy tokens), M2 (Audit Log raw colors), M3 (History placeholder), M4 (no Bangla), M5 (missing onboarding Step 6)
- MVP Feature Completion: 12/15 DONE, 2/15 PARTIAL, 1/15 NOT DONE = ~87%
- Trust Layer Score: 23/35 (66%)
- Design System Migration: ~65%
- Widget Adoption: 9/13 (69%)
- Flow scores: Dashboard 5/5, Pipeline 5/5, S2S Breakdown 5/5, Export 4/5, Deletion 5/5, Settings 3/5, Audit Log 2/5, History 1/5
- See `docs/beta/INTERNAL_ALPHA_MATURITY_AUDIT.md`, `docs/planning/ALPHA_TO_BETA_ROADMAP.md`

## 6b. A2 Beta Blocker Resolution — COMPLETE (2026-06-07)

- B1 FIXED: "Change history" ListTile added to Settings (navigates to `/audit-log`)
- B2 FIXED: `AuthNotifier.sessionAuthenticated` static flag + router redirect enforces PIN on cold start
- B3 FIXED: S2S hero catches provider exceptions, shows "---" fallback
- M1 FIXED: STS Settings migrated from `AppColors` to `HelmColors` ThemeExtension
- M2 FIXED: Audit Log migrated from raw `Colors.*` to `HelmColors` tokens
- M3 FIXED: History tab removed from bottom nav (3-tab: Home, Pipeline, Settings)
- P5 FIXED: "Not financial advice" disclaimer added to S2S breakdown sheet
- Quality gate: dart analyze 0/0/0, 38/38 tests pass
- **0 beta blockers remaining**

## 6c. A3 First Impression Polish — COMPLETE (2026-06-07)

- M5 FIXED: Onboarding Step 6 — optional first pipeline entry page
- P2 FIXED: One-time S2S hint banner on first dashboard view
- New file: `first_pipeline_page.dart` (onboarding page)
- SharedPreferences: `sts_hint_shown` flag for one-time hint
- Quality gate: dart analyze 0/0/0, 38/38 tests pass

## 6d. A4 Test Coverage + Design Stabilization — COMPLETE (2026-06-07)

- **40 new tests**: NumberFormatter (27 tests: BDT lakh/crore, USD, compact, FX rate, parse round-trip), OnboardingDraft (13 tests: copyWith, computed properties)
- **6 files migrated** from AppColors to HelmColors: safe_to_spend_hero, add_transaction_screen, add_income_screen, income_list_screen, income_pipeline_summary, splash_screen
- **HelmToast adopted** across 5 screens: add_transaction, add_income, income_list, sts_settings, export
- **Remaining AppColors**: 2 core widgets (button_multiple_types, linear_progress_bar) — high blast radius, deferred
- **Remaining raw SnackBar**: 1 (confirm_received_sheet — post-pop context, HelmToast incompatible)
- Test count: 38 → 78 (105% increase)
- Design system migration: ~70% → ~90%
- Quality gate: dart analyze 0/0/0, 78/78 tests pass

## 6e. Phase 1 Behavioral Foundation — COMPLETE (2026-06-13)

> Reference: `docs/planning/TDD_DISPATCH_PHASE_1_BEHAVIORAL_FOUNDATION.md`
> Agent: Antigravity (Claude Code), Review: Behavioral Nudge Engine, UI Designer, Brand Guardian

- **Group A — Contrast Fixes (P1.9-P1.11)**: `stateSafe` light #3D6B3C (4.7:1 AA), `stateTight` light #8B6500 (4.6:1 AA), `interactive` dark #4DA09C (5.0:1 AA). Test: `helm_colors_contrast_test.dart` (3 tests, WCAG relative luminance computation).
- **Group B — Boundary Event Wiring (P1.1-P1.4)**: 4 analytics events wired — `sts_at_risk_entered` + `reserve_depleted` (dashboard initState, SharedPrefs once-per-session deduplication), `first_pipeline_entry` (add_income_screen, once-ever), `pipeline_state_changed` (confirm_received_sheet, fires on every state transition). Test: `dashboard_boundary_events_test.dart` (7 tests). `BoundaryEvents.pipelineStateChanged` added to event_registry.
- **Group C — Haptic Feedback (P1.5-P1.8)**: 5 action types — PIN digit/clear (light), PIN confirm (medium), PIN fail (heavy), confirm received (medium), delete income undo (medium), S2S hero card tap (light). 5 files modified: `pin_entry_screen.dart`, `pin_setup_screen.dart`, `s2s_hero_block.dart`, `confirm_received_sheet.dart`, `income_list_screen.dart`. All haptics in presentation layer (clean architecture — no domain calls).
- **Group D — Button Active States (P1.12)**: `AppButton` converted from StatelessWidget to StatefulWidget with `AnimatedScale(0.97)`, `InkWell` press feedback, `Material` splash, 100ms duration. Test: `button_pressed_state_test.dart` (5 widget tests across all 3 variants + disabled + loading).
- **Group E — Slider Stepper Buttons (P1.13-P1.14)**: ±1% `IconButton` steppers on tax rate slider (0-40%) and buffer percent slider (5-30%), disabled at min/max via null `onPressed`. Keys: `tax_rate_plus`, `tax_rate_minus`, `buffer_plus`, `buffer_minus`. Test: `sts_settings_slider_test.dart` (4 structure tests).
- **Group F — Onboarding Global Skip (P1.15)**: Persistent "Set up later" `TextButton` (key: `onboarding_skip`) on all 6 onboarding steps via Stack overlay. Persists partial draft data (liquid balance, income pattern), sets onboarding complete, navigates to `/home`. Test: `onboarding_skip_test.dart` (3 structure tests).
- **Group G — Quiet Affirmation Signals (P1.16-P1.18)**: `Affirmation` pure-domain value object (`lib/features/dashboard/domain/affirmation.dart`) with `compute(overdueEntryCount, sessionCount)`. 3 states: pipeline up to date / 7 days tracked / 14 days tracked. Wired to `HelmTrustStrip.affirmation` → `S2sHeroBlock.affirmation` → dashboard `_computeAffirmation()`. Session counting via `SharedPrefServices.incrementSessionCount()`. Copy rules enforced: no exclamation marks, no emoji, no comparative language. Test: `dashboard_affirmations_test.dart` (7 logic tests including copy validation).
- **New files**: `affirmation.dart` (domain), 7 test files.
- **Quality gate**: dart analyze 0/0/0, 104/104 tests pass (78→104, +26). 0 packages added. 15 source files modified.

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
| Boundary event wiring | 1 | **DONE** | — |
| Haptic feedback system | 1 | **DONE** | — |
| Contrast ratio fixes | 1 | **DONE** | — |
| Quiet affirmation signals | 1 | **DONE** | — |
| Button active/pressed states | 1 | **DONE** | — |
| Slider stepper buttons | 1 | **DONE** | — |
| Onboarding global skip | 1 | **DONE** | — |
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