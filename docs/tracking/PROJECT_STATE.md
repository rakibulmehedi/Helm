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

## 2. Frozen Systems
*(Do NOT heavily refactor without explicit approval)*
- transaction provider structure
- Hive architecture
- routing structure
- localization system

## 3. Known Technical Debt
- categories currently placeholder string labels
- no formal wallet model yet
- no sync abstraction yet

## 4. Current Architecture
- Framework: Flutter
- State Management: Riverpod
- Storage: Hive
- Navigation: GoRouter
- Paradigm: Offline-first

## 5. Active Modules
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
  - See `docs/ux/POCKETA_CANONICAL_UX_IMPLEMENTATION_SPEC.md` for canonical spec
  - See `docs/planning/UX_EXECUTION_TODO.md` for task list
- **Sprint 1 (UX-5) COMPLETE** (2026-06-05): Visual Identity / Design System — 12 tasks, dart analyze 0/0/0
- **Next**: Sprint 2 (UX-1 Dashboard Cockpit Redesign) — 14 tasks

## Visual Foundation Status (2026-06-05)
- Token system: STABLE (pocketa_colors, pocketa_typography, pocketa_spacing, pocketa_motion)
- app_theme.dart: REBUILT (new tokens, legacy shim intact)
- Core widgets: STABLE (PocketaAmount, PocketaLedgerRail, PocketaTrustStrip, PocketaToast)
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

## 6. Blocked Modules
- Cloud sync (requires authentication decision + backend stack lock per Doctrine §14)
- Biometric auth (D1.04 deferred — needs `local_auth` package approval)

## 7. Current Product Direction (per Final Doctrine)
- Focus: Freelancer Cashflow Clarity
- Identity: Single-purpose calm cockpit for Bangladeshi USD-earning freelancers
- Core Wedge: Pipeline-aware Safe-to-Spend
- Target: $800–$3,000/month USD earners using Payoneer/nsave/ElevatePay
- MVP Goal: Validate manual pipeline maintenance + S2S trust
- Next: Release build verification → APK distribution → Closed Beta (15-25 freelancers, 4 weeks)
- Strategic Authority: `docs/strategy/POCKETA_FINAL_PRODUCT_DOCTRINE.md`

## 8. Doctrine-Killed Features
- F-commerce / COD / inventory / POS — wrong product entirely
- Generic expense categorization — TallyKhata territory
- Subscription Leakage Radar — not in doctrine scope
- AI insights / financial advice — hallucination risk
- Gamification — patronizing
- Charts/reports without S2S context — noise
- Client/Project ROI tracking — different product

## 9. Doctrine-Deferred Features
- Multi-wallet → V1 (after MVP beta clears)
- Tax reserve → V2 (user-declared %, not algorithmic)
- Invoice-Lite → V2 (3-sprint allocation)
- Push notifications → V1 transactional only (never engagement)
- Reports/charts → V3
- Email auto-ingestion → V4+ if ever