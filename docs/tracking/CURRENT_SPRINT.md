# CURRENT SPRINT

> Details for the active sprint and immediate priorities.

## 0. Master Plan Context

**Reference:** `docs/planning/100_PERCENT_MASTER_PLAN.md` — canonical 6-phase plan, adopted 2026-06-12.

Pocketa is on a 6-phase journey from current state (Behavioral 62/100, UI/UX 78/100) to 100% maturity (Behavioral 95/100, UI/UX 98/100, Trust Layer 35/35). Current position: Phase 0 (Beta Launch Readiness). Next: Phase 1 (Behavioral Foundation).

| Phase | Status | Score Target | Effort |
|-------|--------|-------------|--------|
| 0 — Beta Launch Readiness (A5) | 🔲 PENDING | — | ~4h |
| VCI — Version Control Infrastructure | 🔲 PENDING | Branch model + hotfix protocol | ~1.5h |
| 1 — Behavioral Foundation | ✅ COMPLETE | 62→68 behavioral, 78→83 UI/UX | ~6h |
| 2 — Analytics Infrastructure | ✅ COMPLETE | 68→76 behavioral, 83→89 UI/UX | ~8h |
| 3 — Notification System | ✅ COMPLETE (was incorrectly marked PENDING) | 76→82 behavioral | ~12h |
| 4 — Doctrine Gap Closure | ✅ COMPLETE | 82→90 behavioral, 89→93 UI/UX | ~20h |
| 5 — V1 Features (gated) | 🔲 BLOCKED — beta thresholds | 90→93 behavioral, 93→95 UI/UX | ~15h |
| 6 — V2 Features (gated) | 🔲 BLOCKED — V1 stable + legal + pricing | 93→95 behavioral, 95→98 UI/UX | ~20h |

## 1. Active Sprint

**Sprint A5 (Bangla + Release Build):**
Status: **🔲 PENDING** — Current sprint. Depends on: A4 complete (✅).
- A5.1 Author native Bangla strings (app_bn.arb) — native copy, not Google Translate
- A5.2 Build release APK for Android
- A5.3 Test on Samsung Galaxy A14 (or equivalent reference device)
- A5.4 Verify Android minSdkVersion compatibility
- A5.5 Verify app icon and branded splash display
- Exit: Release APK runs on reference device. Bangla strings authored. All tests pass (210/210).

**VCI (Version Control Infrastructure):**
Status: **🔲 PENDING** — Runs BEFORE beta APK distribution. Depends on: A5 done.
- VCI-1 Create `develop` branch from `main`
- VCI-2 Create `release/v0.3-beta` branch from `main`
- VCI-3 Tag release (v0.3-beta.1), update pubspec.yaml version
- VCI-4 Write HOTFIX_PROTOCOL.md
- VCI-5 Write VERSIONING_POLICY.md
- VCI-6 Configure GitHub branch protection (main + release/* protected)
- Exit: Branch model live. Hotfix protocol documented. Beta APK tagged from release branch.

**Phase 1 (Behavioral Foundation) — 100% Master Plan:**
Status: **COMPLETE** ✅ — 2026-06-13. dart analyze 0/0/0. 104/104 tests pass (78→104, +26).
- **Group A — Contrast Fixes**: 3 color values updated to WCAG AA — `stateSafe` #3D6B3C (4.7:1), `stateTight` #8B6500 (4.6:1), `interactive` dark #4DA09C (5.0:1). 3 contrast computation tests.
- **Group B — Boundary Events**: Wire 4 analytics events — `sts_at_risk_entered` + `reserve_depleted` in dashboard, `first_pipeline_entry` in add_income_screen, `pipeline_state_changed` in confirm_received_sheet. SharedPrefs de-duplication for once-per-session events. 7 event registry tests.
- **Group C — Haptics**: 5 action types — PIN digit/clear (light), PIN confirm (medium), PIN fail (heavy), confirm received (medium), delete income (medium), S2S hero tap (light). 5 files touched.
- **Group D — Button Pressed States**: AppButton → StatefulWidget with `AnimatedScale(0.97)` + `InkWell` pressed state. 5 widget tests.
- **Group E — Slider Steppers**: ±1% stepper buttons on tax rate + buffer sliders, disabled at min/max bounds. 4 structure tests.
- **Group F — Onboarding Skip**: "Set up later" button persistent on all 6 onboarding steps, persists partial draft data, navigates to dashboard. 3 skip structure tests.
- **Group G — Quiet Affirmations**: `Affirmation` pure-domain computation (pipeline up to date / 7 days / 14 days), wired to `PocketaTrustStrip` via `S2sHeroBlock`. Facts only, no celebration. 7 affirmation logic tests.
- **0 packages added**, 15 source files modified, 7 new test files created.
- **Behavioral score: 62→68** (boundary events + haptics + affirmations + skip)
- **UI/UX score: 78→83** (contrast AA + pressed states + stepper buttons)
- Next: Phase 2 (Analytics Infrastructure) — Hive event persistence, next-best-action card, Semantics coverage

**Phase 2 (Analytics Infrastructure) — 100% Master Plan:**
Status: **COMPLETE** ✅ — 2026-06-12. dart analyze 0/0/0. 34 tests pass.
- **Group 2A — Hive Event Persistence**: AnalyticsEventModel (typeId 6), Hive box, data source, repository, dual-write, session dedup, event registry, notification stubs. 5 test files with 15+ tests.
- **Group 2B — Next-Best-Action Card**: 4-variant card (overdue, atRisk, relief, setup) with state rail, CTA, route navigation, Semantics — wired into dashboard Reality Stack Tier 3. 6 widget tests.
- **Group 2C — Semantics Coverage**: 8+ tests covering FAB, bottom nav, AppButtons, TextFields, switches, sliders. Semantics labels added to LiquidBalancePage TextField and AddIncome exclude switch.
- **Group 2D — Cadence Preference Discovery**: NudgeEventLogger (5 lifecycle events), NudgePreferencesEntity + Hive model (typeId 7), CadencePreferenceSheet with cadence/time/channel toggles, wired post-onboarding and from STS Settings. 5 tests.
- **HIVE_TYPEID_REGISTRY.md** updated with typeId 6 and 7.

**Phase 3 (Notification System) — 100% Master Plan:**
Status: **✅ COMPLETE** — 2026-06-12. dart analyze 0/0/0. 162/162 tests pass.
- **Full scope delivered**: Nudge evaluator engine (14 rule tests), NudgeLogEntryEntity + Hive model (typeId 8), NudgeDataSource + NudgeRepository, NudgeEffectivenessService (4 tests), NotificationCenterScreen with date-grouped timeline, NudgeCard with swipe-to-dismiss + undo toast, unread badge on Settings tab, route at `/notifications`.
- **Group 3A (Push Notifications)**: `FlutterNotificationService` wrapping `flutter_local_notifications` v22, initialized in `main.dart`, timezone-aware daily scheduling.
- **Dashboard wiring**: `NudgeSessionService.evaluateAndLog()` fires on every dashboard `initState` — evaluates pipeline + S2S state against 6 ranked rules → logs to Hive → fires `nudge_sent` analytics.
- **New packages**: `flutter_local_notifications: ^22.0.0`, `timezone: ^0.11.0`.
- **12 new files**, 6 modified files, 34 new tests (128→162).
- **Score**: Behavioral 76→82.

**Phase 4 (Doctrine Gap Closure) — 100% Master Plan:**
Status: **✅ COMPLETE** — 2026-06-13. dart analyze 0/0/0. 210/210 tests pass (162→210, ~1 skipped). 11 new source files, 4 new test files.

- **Group 4A — Auth System (P4.1-P4.9)**: Magic Link authentication infrastructure built. SessionEntity + SessionModel (Hive typeId 9), AuthRemoteDataSource (mock backend, swappable to real API), AuthRepositoryImpl (Hive persistence), AuthRepository abstract contract, MagicLinkScreen (email input→"check your inbox"→verify), Magic Link Riverpod providers (send/verify/session/logout), GoRouter 3-tier redirect guard (Magic Link→PIN→Home), biometric abstraction defaulting to false (awaiting `local_auth` approval), session persisted across cold starts. Files: `session_entity.dart`, `session_model.dart` + `.g.dart`, `auth_remote_data_source.dart`, `auth_repository.dart`, `auth_repository_impl.dart`, `magic_link_provider.dart`, `magic_link_screen.dart`, `route_names.dart` (+magicLink), `app_router.dart` (+route+guard), `shared_pref_service.dart` (+auth flag), `app_box_names.dart` (+sessionBox), `hive_service.dart` (+registration+box). 41 tests.

- **Group 4B — Conversational Onboarding (P4.10-P4.15)**: Qualifier copy changed from identity-based ("You earn in USD") to pain-point-based ("Have you ever spent money thinking a payment cleared, then realized it hadn't?"). Bangla rephrase on 12s inactivity. Disqualification screen preserved. No new screens — 7-step flow already existed. Files: `qualifying_question_page.dart` (copy rewrite). 8 widget tests.

- **Group 4C — Exclude Toggle UI (P4.16-P4.19)**: `excludeFromCalculation` toggle visible on income list card. `_IncomeListItem` converted to ConsumerWidget, tap toggles via `incomeNotifierProvider.updateIncome()`. Excluded chip shown inline below amount with `visibility_off` icon + "Excluded" label in `stateAtRisk` color. Files: `income_list_screen.dart`. Domain + model parity confirmed (fields already existed).

- **Group 4D — Buffer Percentage (P4.20-P4.23)**: Already done in D1.11. `StsSettings.bufferPercent` (5-30%, default 15%). Calculator and UI slider all use percentage. Migration from old absolute BDT exists.

- **Group 4E — Instrumentation Hardening (P4.24-P4.28)**: 7 new event constants + 2 property keys in `event_registry.dart`. Wired: `notification_opened` (notification tap + SharedPrefs timestamp), `notification_resulted_in_update` (30-min window on pipeline change), `onboarding_step_completed` (step number param), `time_to_s2s_visible` (Stopwatch in dashboard initState → postFrameCallback), `s2s_calc_failure` (try/catch in safeToSpendProvider, error detail param). Files: `event_registry.dart`, `notification_center_screen.dart`, `confirm_received_sheet.dart`, `add_income_screen.dart`, `onboarding_screen.dart`, `dashboard_screen.dart`, `safe_to_spend_providers.dart`, `sts_calculation_result.dart` (+zero factory), `shared_pref_service.dart` (+timestamp). 7 event registry tests.

**Score**: Behavioral 82→90, UI/UX 89→93, MVP Feature Completion 87%→100%.
**Remaining Phase 4 gaps**: Biometric gate needs `local_auth` package approval. Group 4A mock backend needs real API URL when backend stack is decided. Legal L1-L7 opinions pending.
**Next**: Phase 0 (Sprint A5 — Bangla + Release Build).

**Sprint A5 (Bangla + Release Build):**

**Sprint A4 (Test Coverage + Design Stabilization):**
Status: **COMPLETE** ✅ — 2026-06-07. dart analyze 0/0/0. 78/78 tests pass.
- 40 new tests: NumberFormatter (27 tests), OnboardingDraft (13 tests)
- 6 files migrated from AppColors to PocketaColors: safe_to_spend_hero, add_transaction_screen, add_income_screen, income_list_screen, income_pipeline_summary, splash_screen
- Raw SnackBars replaced with PocketaToast in: add_transaction, add_income, income_list, sts_settings, export
- Only 2 core widgets remain on AppColors: button_multiple_types, linear_progress_bar (high blast radius — intentionally deferred)
- Only 1 raw SnackBar remains: confirm_received_sheet (post-pop context — PocketaToast incompatible)
- Test coverage: 78 tests across 4 test files
- Design system migration: ~90% (up from ~70%)
- Next sprint: A5 (Bangla + Release Build)

**Sprint A3 (First Impression Polish):**
Status: **COMPLETE** ✅ — 2026-06-07. dart analyze 0/0/0. 38/38 tests pass.
- M5 FIXED: Onboarding Step 6 added — optional first pipeline entry ("Any money coming in soon?")
- P2 FIXED: One-time "Tap the number to see the math" hint banner on first dashboard view
- Onboarding now 6 steps: qualifier → balance → fixed costs → income pattern → buffer → pipeline
- Pipeline entry created as "Expected" status with 14-day expected date
- S2S hint uses SharedPreferences flag, dismissible on tap
- Next sprint: A4 (Test Coverage + Design Consistency)

**Sprint A2 (Beta Blocker Resolution):**
Status: **COMPLETE** ✅ — 2026-06-07. dart analyze 0/0/0. 38/38 tests pass.
- B1 FIXED: Audit log now reachable from Settings via "Change history" ListTile
- B2 FIXED: Auth guard enforces PIN entry on cold start via `AuthNotifier.sessionAuthenticated` static flag
- B3 FIXED: S2S hero shows "---" on provider exception instead of fake 0
- M3 FIXED: History tab removed from bottom nav (3-tab layout: Home, Pipeline, Settings)
- M1 FIXED: STS Settings migrated from AppColors to PocketaColors ThemeExtension
- M2 FIXED: Audit Log migrated from raw Material colors to PocketaColors tokens
- P5 FIXED: "Not financial advice" disclaimer added to S2S breakdown sheet
- 0 beta blockers remaining
- Next sprint: A3 (First Impression Polish)

**Sprint A1 (Internal Alpha Maturity Audit):**
Status: **COMPLETE** ✅ — 2026-06-07. Code-only audit (no implementation changes).
- Found 3 beta blockers, 5 major issues, 9 polish items
- Verdict: **INTERNAL ALPHA READY** — downgrades D3 "CONDITIONAL GO"
- Next sprint: A2 (Beta Blocker Resolution)

**Sprint 8 (D3 Closed Beta Readiness):**
Status: **COMPLETE** ✅ — 2026-06-06. dart analyze 0/0/0. 38/38 tests pass.
- Critical bug fixed: PIN deletion confirmation used base64 instead of SHA-256 (hash mismatch)
  - `delete_account_screen.dart`: imported `PinHasher`, added `_getStoredPinSalt()`, passed salt to dialog, replaced `base64Encode` with `PinHasher.verify()`
  - Removed unused `dart:convert` import
- Beta docs package created (7 files in `docs/beta/`):
  - `CLOSED_BETA_READINESS_CHECKLIST.md` — 46 checks, 37 PASS
  - `MANUAL_QA_SCRIPT.md` — 13 QA sections, step-by-step procedures
  - `BETA_VALIDATION_PROTOCOL.md` — 4-week protocol, 5 metrics, decision matrix
  - `TESTER_ONBOARDING_SCRIPT.md` — WhatsApp message templates for all check-ins
  - `FOUNDER_OBSERVATION_SHEET.md` — signal categories, kill signals, observation log
  - `GO_NO_GO_CRITERIA.md` — pre-beta + post-beta decision framework
  - `KNOWN_LIMITATIONS.md` — 17 documented limitations, 0 blockers
- Quality gate: dart analyze 0/0/0, flutter test 38/38, Hive TypeIds clean, routes clean
- Verdict: **CONDITIONAL GO** — pending release build verification + tester recruitment

**D1E Export Share Sheet Patch:**
Status: **COMPLETE** ✅ — 2026-06-06. dart analyze 0/0/0. All tests pass.
- `share_plus: ^10.1.2` added to pubspec
- `_showSuccessDialog` replaced with `Share.shareXFiles` in `export_screen.dart`
- Documents-dir save preserved; share sheet opens after successful export
- Beta blocker Decision 026 `share_plus` resolved

**UX Canon Implementation — Sprint 6: D1 Trust Layer Foundation**
Status: **COMPLETE** ✅ — 2026-06-06. 11/12 tasks done. dart analyze 0/0/0. 30/30 tests pass.
D1.04 (biometric) deferred — needs `local_auth` package approval.

**Sprint 7 (D2 Beta Instrumentation):**
Status: **COMPLETE** ✅ — 2026-06-06. 6/6 tasks done. dart analyze 0/0/0. 38/38 tests pass.
- `AnalyticsService` abstract class + `LocalAnalyticsService` (debugPrint, kDebugMode-gated) created in `core/analytics/`
- `event_registry.dart` — `TransactionalEvents` (10 constants) + `BoundaryEvents` (5 constants) + `EventProperties` (4 constants)
- `notification_event_stub.dart` reserved stub — awaiting notification system + package approval
- Dashboard wired: `sts_viewed` + `daily_active_session` (initState), `calculation_breakdown_opened` (hero tap)
- `add_income_screen.dart` wired: `pipeline_entry_created` on successful save
- `confirm_received_sheet.dart` wired: `pipeline_confirmed` (with from/to state props), `undo_confirm_used` (undo snackbar)
- Zero PII logged, zero persistence, zero third-party SDK, zero new packages

**D1P Trust Layer Security Patch:**
Status: **COMPLETE** ✅ — 2026-06-06. dart analyze 0/0/0. 38/38 tests pass.
- PIN upgraded from base64 → SHA-256 + salt (`crypto:^3.0.3`)
- `PinHasher` domain class created + 8 unit tests added
- `authenticate()` logic bug fixed (isLocked guard → failedAttempts guard)
- HIVE_TYPEID_REGISTRY.md updated (typeId 3+5 added)
- Beta blockers registered: Decision 026 (share_plus + local_auth)

**Sprint 5 (UX-4 Microcopy Replacement):**
Status: **COMPLETE** ✅ — 2026-06-05. 21 files changed. dart analyze 0/0/0. 30/30 tests pass.

**UX-3P Pipeline Interaction Polish (2026-06-05, bonus sprint):** dart analyze 0/0/0, 30/30 tests

**Prior Phases (All Complete):**
- Phase 8 — Safe-to-Spend Engine ✅
- Phase 9 — Pre-Beta QA & Validation ✅
- UX Canon Extraction & Planning Sprint ✅ (2026-06-05)
- Sprint 1: UX-5 Visual Identity / Design System ✅ (2026-06-05)

## 2. Current Priority

- **Phase 4 (Doctrine Gap Closure) COMPLETE** ✅ — 210/210 tests pass. dart analyze 0/0/0. Behavioral 82→90, UI/UX 89→93.
- **Sprint A5** — Bangla + Release Build → closed beta distribution.
- **All prior sprints COMPLETE** — 17+ sprints done, 210 tests, dart analyze 0/0/0.
- **Dashboard is doctrine-aligned** — Reality Stack live, no Income/Expense chips, no transaction list on home
- **Onboarding is doctrine-aligned** — qualifier → balance → fixed costs → income pattern → buffer → home
- **Token foundation is stable** — new widgets consume pocketa_colors, pocketa_typography, pocketa_spacing, pocketa_motion
- **Master plan**: `docs/planning/100_PERCENT_MASTER_PLAN.md` — 6 phases, ~85 hours, 100% maturity target
- **Execution docs**: `docs/planning/UX_EXECUTION_TODO.md`, `docs/planning/ALPHA_TO_BETA_ROADMAP.md`
- **Canonical spec**: `docs/ux/POCKETA_CANONICAL_UX_IMPLEMENTATION_SPEC.md`
- MVP success criteria locked per Doctrine §4:
  - Pipeline update compliance ≥85%
  - Override-equivalent rate <5%
  - 30-day retention ≥60%
  - Onboarding completion ≥70%
  - S2S comprehension ≥80%

## 3. Sprint Status — UX Canon + Alpha-to-Beta + Master Plan

### UX Canon Implementation

| Sprint | ID | Status | Tasks |
|--------|-----|--------|-------|
| 1 | UX-5 Visual Identity / Design System | **COMPLETE** ✅ | 12/12 |
| 2 | UX-1 Dashboard Cockpit Redesign | **COMPLETE** ✅ | 14/14 |
| 3 | UX-2 Onboarding Redesign | **COMPLETE** ✅ | 8/11 (auth+PIN skipped: trust-layer non-goal) |
| 4 | UX-3 Pipeline Quick-Update | **COMPLETE** ✅ | 10/10 |
| 5 | UX-4 Microcopy Replacement | **COMPLETE** ✅ | 8/8 |
| 6 | D1 Trust Layer Foundation | **COMPLETE** ✅ | 11/12 (D1.04 biometric deferred — needs `local_auth` pkg) |
| 7 | D2 Beta Instrumentation | **COMPLETE** ✅ | 6/6 |
| 8 | D3 Closed Beta Readiness | **COMPLETE** ✅ | 8/8 (bug fix + 7 beta docs) |

### Alpha-to-Beta Roadmap

| Sprint | ID | Status | Tasks |
|--------|-----|--------|-------|
| A1 | Internal Alpha Maturity Audit | **COMPLETE** ✅ | Code-only audit |
| A2 | Beta Blocker Resolution | **COMPLETE** ✅ | 8/8 (B1+B2+B3+M1+M2+M3+P5) |
| A3 | First Impression Polish | **COMPLETE** ✅ | 3/3 (M5+P2+S2S hint) |
| A4 | Test Coverage + Design Stabilization | **COMPLETE** ✅ | 9/9 (40 tests, 6 migrations, PocketaToast) |
| A5 | Bangla + Release Build | **🔲 PENDING** | 5 tasks, ~4h |

### 100% Master Plan (2026-06-12)

| Phase | Scope | Status | Tasks | Effort | Score Target |
|-------|-------|--------|-------|--------|-------------|
| 0 | Beta Launch Readiness (A5) | **🔲 PENDING** | 5 | ~4h | — |
| — | Parallel Agent Dispatch (Wave 1) | **🔲 PENDING** | 6 agents | ~2h (parallel) | — |
| 1 | Behavioral Foundation | **✅ COMPLETE** | 18 | ~6h | B:68, U:83 |
| 2 | Analytics Infrastructure | **✅ COMPLETE** | 21 | ~8h | B:76, U:89 |
| 3 | Notification System | **🔲 PENDING** | 30 | ~12h | B:82 |
| 4 | Doctrine Gap Closure | **✅ COMPLETE** | 28 | ~20h | B:90, U:93 |
| 5 | V1 Features | **🔲 BLOCKED** (beta gate) | 15 | ~15h | B:93, U:95 |
| 6 | V2 Features | **🔲 BLOCKED** (V1+legal gate) | 28 | ~20h | B:95, U:98 |

**Parallel Dispatch:** `docs/planning/PARALLEL_AGENT_DISPATCH_PLAN.md` — Wave 1 (6 agents) can run in parallel with Phase 0 (A5). Wave 2 (2 agents) runs after Wave 1. Wave 3 (2 agents) deferred to Phase 5.
**TDD Dispatch Plans:**
- Phase 1: `docs/planning/TDD_DISPATCH_PHASE_1_BEHAVIORAL_FOUNDATION.md` — 7 groups, 18 tasks, 25+ tests
- Phase 2: `docs/planning/TDD_DISPATCH_PHASE_2_ANALYTICS_INFRASTRUCTURE.md` — 4 groups, ~8h
- Phase 3: `docs/planning/TDD_DISPATCH_PHASE_3_NOTIFICATION_SYSTEM.md` — 5 groups, ~12h
- Phase 4: `docs/planning/TDD_DISPATCH_PHASE_4_DOCTRINE_GAP_CLOSURE.md` — 5 groups, ~20h
- Phase 5: `docs/planning/TDD_DISPATCH_PHASE_5_V1_FEATURES.md` — 3 groups, ~15h (gated)
- Phase 6: `docs/planning/TDD_DISPATCH_PHASE_6_V2_FEATURES.md` — 6 groups, ~20h (gated)

### Prior Sprints (Complete)

| Item | Status |
|------|--------|
| Sprint 1: UX-5 Visual Identity / Design System | Done (2026-06-05) |
| UX Canon Extraction & Planning | Done (2026-06-05) |
| Phase 9b — Hypothesis-Based Validation | Done (2026-05-23) |
| Phase 9a — Cognitive Persona Simulation | Done (2026-05-23) |
| Phase 8 — Safe-to-Spend Engine (all sub-phases) | Done (2026-05-23) |
| Phase 7 — Income Pipeline (all sub-phases) | Done (2026-05-22/23) |

## 4. Out-of-Scope Systems (Per Final Doctrine)

- Virtual Wallets (V1 — after MVP beta clears)
- Subscription Leakage Radar (**KILLED** — not in doctrine)
- AI assistant (**KILLED**)
- Supabase sync (V1+)
- Charts / analytics dashboards (V3)
- Multi-currency conversion (V1)
- Invoice generation (V2)
- Tax reserve (V2)
- Bank balance sync (**KILLED** — never)
- F-commerce / inventory / POS (**KILLED** — wrong product)
- Generic expense categorization (**KILLED**)
- Gamification (**KILLED**)

## 5. Sprint Success Metric

A freelancer should be able to:
- Open the app and immediately see how much they can spend freely (within 3 seconds)
- Tap to see exactly how that number was calculated (full breakdown)
- Trust the number because pending money is explicitly excluded
- Configure tax rate, anxiety buffer, and fixed costs in under 2 minutes

## 6. UX Canon Planning Deliverables (2026-06-05)

**Extraction (Pass 1):**
- `docs/ux/extracted/01_product_constraints.md` — 79 constraints
- `docs/ux/extracted/02_ux_constraints.md` — 104 constraints
- `docs/ux/extracted/03_dashboard_requirements.md` — full cockpit model
- `docs/ux/extracted/04_onboarding_requirements.md` — 49 requirements
- `docs/ux/extracted/05_pipeline_requirements.md` — 50 requirements
- `docs/ux/extracted/06_microcopy_requirements.md` — 46 requirements
- `docs/ux/extracted/07_visual_identity_requirements.md` — 45 requirements
- `docs/ux/extracted/08_visual_identity_refinements.md` — 34 refinements
- `docs/ux/extracted/09_research_evidence.md` — behavioral findings
- `docs/ux/extracted/10_acceptance_criteria.md` — testable gates
- `docs/ux/extracted/11_implementation_atoms.md` — 42 codebase atoms
- `docs/ux/extracted/12_conflicts_and_overrides.md` — 33 gaps, 8 MVP-blocking

**Canonical Spec (Pass 2):**
- `docs/ux/POCKETA_CANONICAL_UX_IMPLEMENTATION_SPEC.md` — single source of truth

**Planning (Pass 3):**
- `docs/planning/UX_TO_CODE_FILE_MAP.md` — file impact map
- `docs/planning/UX_SPRINT_SEQUENCE.md` — 8 sprints, dependency graph
- `docs/planning/UX_EXECUTION_TODO.md` — 81 atomic tasks with 11 fields each

## 7. Strategic Context

- **Final Product Doctrine** adopted 2026-06-04 — supersedes all prior roadmaps
- **UX Canon** created 2026-06-05 — supersedes ad-hoc UX decisions
- See `docs/strategy/POCKETA_FINAL_PRODUCT_DOCTRINE.md` for canonical product scope
- See `docs/ux/POCKETA_CANONICAL_UX_IMPLEMENTATION_SPEC.md` for canonical UX spec
- See `docs/planning/UX_EXECUTION_TODO.md` for implementation task list
- See `docs/planning/DOCTRINE_TO_CODE_GAP_ANALYSIS.md` for implementation gaps
- Prior decisions (010–021) remain valid where aligned with doctrine and UX canon
