# CURRENT SPRINT

> Details for the active sprint and immediate priorities.

## 1. Active Sprint

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

- **Sprint A4 COMPLETE** — 40 new tests, 6 files migrated PocketaColors, PocketaToast adopted, 78/78 tests
- **Sprint 2 (UX-1) COMPLETE** — 14/14 tasks done, dart analyze 0/0/0
- **Sprint 3 (UX-2) COMPLETE** — 5-step onboarding flow live, dart analyze 0/0/0, all 26 tests pass
- **Sprint 4 (UX-3) COMPLETE** — 10/10 tasks done, dart analyze 0/0/0, 30/30 tests pass
- **UX-3P Polish COMPLETE** — swipe-to-advance (PIPE-020), 5s undo (PIPE-019), Needs decision header (PIPE-013)
- **Sprint 5 (UX-4) COMPLETE** — 8 tasks: Microcopy Replacement
- **Dashboard is now doctrine-aligned** — Reality Stack live, no Income/Expense chips, no transaction list on home
- **Onboarding is now doctrine-aligned** — qualifier → balance → fixed costs → income pattern → buffer → home
- **Token foundation is stable** — new widgets consume pocketa_colors, pocketa_typography, pocketa_spacing, pocketa_motion
- **Execution docs**: `docs/planning/UX_EXECUTION_TODO.md`, `UX_SPRINT_SEQUENCE.md`, `UX_TO_CODE_FILE_MAP.md`
- **Canonical spec**: `docs/ux/POCKETA_CANONICAL_UX_IMPLEMENTATION_SPEC.md`
- MVP success criteria locked per Doctrine §4:
  - Pipeline update compliance ≥85%
  - Override-equivalent rate <5%
  - 30-day retention ≥60%
  - Onboarding completion ≥70%
  - S2S comprehension ≥80%

## 3. Sprint Status — UX Canon Implementation

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
| A1 | Internal Alpha Maturity Audit | **COMPLETE** ✅ | Code-only audit |
| A2 | Beta Blocker Resolution | **COMPLETE** ✅ | 8/8 (B1+B2+B3+M1+M2+M3+P5) |
| A3 | First Impression Polish | **COMPLETE** ✅ | 3/3 (M5+P2+S2S hint) |
| A4 | Test Coverage + Design Stabilization | **COMPLETE** ✅ | 9/9 (40 tests, 6 migrations, PocketaToast) |

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
