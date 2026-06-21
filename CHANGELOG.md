# Changelog

All notable changes to Helm are documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.5.0-beta.1] — 2026-06-21

### Added
- **History tab — Paper Ledger reskin**: `AuditLogScreen` rebuilt to Paper Ledger standard with date-grouped event cards, tappable before→after detail sheet (`AuditEventDetailSheet`), and ledger integrity strip
- **Chain re-verification**: `AuditChainService.verifyChain` recomputes SHA-256 over the full event history at read time; `ChainVerification` result surfaced in `LedgerIntegrityStrip`
- **Paper Ledger widget system**: `HelmLedgerHero`, `HelmLedgerRow`, `HelmNextEventCard`, `LedgerState` — shared ledger primitives used across Dashboard and History tab
- **Audit presentation utils**: pure helpers `auditIconFor`, `auditColorFor`, `auditEntityLabel`, `auditTitleFor` covering all 6 event types and 5 entity types
- **History grouping**: date-bucket grouping (Today / This Week / Earlier) with full unit-test coverage
- `auditIntegrityProvider` — chain integrity verified on History tab open, result shown in `LedgerIntegrityStrip`
- Fraunces font family (Regular, Medium, SemiBold) added for Paper Ledger display typography
- Golden baselines for History tab (light + dark)

### Changed
- **Dashboard reskin**: Signal Deck replaced by Paper Ledger widgets (`HelmLedgerHero`, `HelmNextEventCard`); ledger state drives safe/tight/atRisk/empty color logic
- **Income list screen removed**: standalone income list and pipeline summary deleted; income managed via pipeline and add-income routes

### Removed
- Signal Deck widget family (`HelmSignalHero`, `HelmDecisionDeck`, `HelmFlowRoute`, `HelmSignalHorizon`) and associated tests

---

## [0.4.0-beta.1] — 2026-06-20

### Added
- Guest mode: users can skip magic-link identity verification and use the app locally; identity-specific routes (audit log, trace, delete account) are blocked for guests
- `errorInvalidEmail` localization key in en/bn (324/324 ARB keys); magic-link screen now shows a distinct error for malformed email addresses rather than reusing the rate-limit message
- Hive cross-validation for magic-link flag: spoofing SharedPrefs via ADB backup no longer bypasses the identity gate

### Fixed
- **CRITICAL**: base64url token regex now accepts `-` and `_`; prior regex rejected all real Supabase OTP tokens containing those characters, breaking production auth
- Negative amounts (`formatBDT`, `formatUSD`) no longer render as `-,36,000.00`; sign is stripped before grouping and restored after
- `box.get() as bool` crash vector replaced with `== true`; tampered Hive values no longer throw `TypeError` inside `_globalRedirect`
- `logout()` now clears `magic_link_verified` from Hive and `guest_mode` from SharedPrefs; stale identity state no longer persists across sessions
- `onAuthenticated` / `onGuest` callbacks typed as `Future<void> Function()`; auth writes are now awaited before navigation, eliminating silent write failures
- Dead `guest_mode` Hive write removed from onGuest callback; guest mode is intentionally SharedPrefs-backed

### Changed
- Complete UI/UX migration to HelmSpacing, HelmTypography, and HelmColors design tokens across all screens (58 hardcoded radius/spacing values replaced)
- Currency symbols centralized behind `NumberFormatter.symbolForCode` boundary (7 files)
- GoRouter magic-link→onboarding redirect loop fixed: early `null` return prevents gate stacking
- `_identityRoutes` constant introduced for declarative guest route restriction

### Internal
- 19 commits since v0.3.0-beta.1
- 365/365 tests pass; 0 errors / 0 warnings / 0 infos — dart analyze clean
- Dual-model adversarial review (Claude + Codex) completed before merge

---

## [Unreleased]

### Next
- User Validation Sprint: 5–10 real freelancer users, 30-day observation
- Post-validation: Phase 9 decision (Subscription Leakage Radar — conditional)
- Hive → Drift migration (deferred pending validation; see Decision 010)
- Cloud sync (requires authentication decision)

---

## [0.8.0] — 2026-05-23

### Phase 8 — Safe-to-Spend Engine (Complete)

**Phase 8e — UX Hardening**
- Fixed: `rawSafeToSpend` now correctly drives "In reserve mode" / "Fully allocated" visual state (was dead code using wrong field)
- Fixed: Tax rate slider maximum capped at 40% (entity asserts `<= 0.40`; slider previously allowed 50%)
- Added: Anxiety buffer validation with explicit SnackBar on invalid input; `FilteringTextInputFormatter` guards numeric field
- Changed: Breakdown deduction rows now use `AppColors.textSecondary` instead of `AppColors.error` (removes anxiety-inducing red)
- Added: USD exclusion transparency row in breakdown when `excludedUsdIncome > 0`
- Added: Reserve-mode context note in breakdown when `rawSafeToSpend < 0`
- Fixed: `Colors.grey` replaced with `AppColors.textSecondary` throughout settings screen

**Phase 8d — Dashboard Safe-to-Spend Hero**
- `SafeToSpendHero` widget replaces raw Total Balance on dashboard
- Transparent math breakdown via bottom sheet
- Pending and expected income excluded from Safe-to-Spend correctly

**Phase 8c — Settings Screen**
- `StsSettingsScreen` with tax rate slider, anxiety buffer input, fixed costs CRUD

**Phase 8b — Calculation Engine**
- `SafeToSpendCalculator` as pure Dart logic (zero Flutter imports)
- 26 unit tests covering all edge cases
- `FixedCostEntry`, `StsSettings`, `SafeToSpendResult` domain value objects
- `FixedCostModel` registered with Hive (typeId: 3)
- Riverpod providers wired

**Phase 8f — QA and Validation Prep**
- Real device QA checklist
- Safe-to-Spend scenario matrix
- Founder validation script and user interview questions
- Validation metrics defined

---

## [0.7.0] — 2026-05-22

### Phase 7 — Freelancer Income Pipeline (Complete)

**Phase 7f — Domain Abstraction**
- `TransactionEntity` created as pure Dart (zero Hive/Flutter imports)
- `TransactionRepository` interface accepts/returns `TransactionEntity`
- `TransactionRepositoryImpl` maps entity↔model at data layer boundary
- `TransactionModel` gains `fromEntity()`, `toEntity()`, `fromJson()`, `toJson()`
- `IncomeModel` gains `fromJson()`, `toJson()`
- Hive imports fully removed from domain and presentation layers

**Phase 7a–7e — Income Pipeline**
- Income domain entity: `IncomeEntryEntity` with status (Expected/Pending/Received)
- Hive model (typeId: 2), local data source, repository, Riverpod providers
- Add/edit income form screen with full validation
- Income list screen with status filter chips, income cards, delete + undo, empty states
- `/income` route with optional `initialFilter` for deep-link from dashboard
- Dashboard income pipeline summary: Expected/Pending/Received totals, tap-to-filter navigation
- Status quick-action transitions: Expected → Pending → Received

---

## [0.1.0] — 2025-08-18

### Initial Foundation

- Flutter project scaffolding
- Riverpod state management setup
- Hive local storage integration
- GoRouter navigation
- Feature-first architecture structure
- Onboarding flow
- Transaction CRUD (add, edit, delete, undo delete)
- Dashboard with summary totals
- Transaction filtering and grouping
- Theme system (AppColors, AppTheme)
- Localization scaffolding (English + Bengali)
- GitHub release workflow (standard-version)
