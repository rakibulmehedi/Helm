# HELM — DECISION LOG

This file records important product and architecture decisions.

---

## Decision 022 — D1 PIN Hash: SHA-256 + per-setup salt (D1P patch)

Date: 2026-06-06 (updated D1P 2026-06-06)

Decision:
PIN is stored as `SHA-256(salt + pin)` hex digest in Hive `auth_box`.
- `pin_hash` key: 64-char hex SHA-256 digest
- `pin_salt` key: 32-char hex random salt (16 bytes, generated once per setup)
- `crypto: ^3.0.3` added to pubspec.yaml (approved)

`PinHasher` domain class encapsulates `generateSalt()`, `hashPin()`, `verify()`.

Migration: if `pin_is_setup=true` but `pin_salt` absent → old base64 format detected → PIN cleared → user must re-setup.

Reason:
base64 is reversible encoding, not hashing. SHA-256 with unique salt prevents rainbow-table attacks even on local storage.

---

## Decision 023 — D1 Buffer: Percentage (5–30%) replaces Absolute BDT

Date: 2026-06-06

Decision:
`StsSettings.anxietyBuffer` (absolute BDT floor) replaced by `bufferPercent` (5–30%, default 15%). Calculator computes `buffer = bufferPercent / 100 * totalReceivedIncomeBdt`.

Reason:
Absolute BDT floor becomes meaningless as income changes. Percentage scales with freelancer income variability. GAP-009 resolution.

---

## Decision 024 — D1 Export: Documents directory + share sheet (D1E patch)

Date: 2026-06-06 (updated D1E patch 2026-06-06)

Decision:
CSV export writes 5 files to `getApplicationDocumentsDirectory()`, then triggers native share sheet via `Share.shareXFiles`. `share_plus: ^10.1.2` approved and added.

Reason:
Documents-dir save alone is friction-heavy on all Android devices. Share sheet gives users instant access to email, Drive, WhatsApp, etc.

---

## Decision 025 — D1 Biometric: Deferred to V1

Date: 2026-06-06

Decision:
D1.04 (biometric auth via `local_auth`) deferred. PIN-only auth for MVP.

Reason:
Requires `local_auth` package approval. Many budget Android phones lack biometric hardware. PIN must be primary fallback regardless.

---

## Decision 026 — Beta Blocker Package Registry

Date: 2026-06-06

Decision:
Two packages tracked as named beta blockers requiring explicit approval before closed beta ships.

| Package | Purpose | Status |
|---|---|---|
| `share_plus` | Native share sheet for CSV export | RESOLVED — D1E patch 2026-06-06 |
| `local_auth` | Biometric auth | Pending — stub in pin screens |

Reason:
Flutter plugin packages require approval due to platform code and Play Store permissions.

Alternatives evaluated.

---

## Decision 031 — Phases 2-6 TDD + Clean Architecture Dispatch Plans (Per-Phase)

Date: 2026-06-12
Trigger: Phase 1 dispatch plan complete. Remaining 5 phases need equivalent TDD+clean architecture dispatch specs, each in a separate document per phase.

---

## Decision 032 — S1-W4 Security Hardening: Input Validation & Audit Log

Date: 2026-06-14
Trigger: Adversarial audit remediation Sprint S1, Waves 1-2.

Decision:
- Centralize all input validation/sanitization in `lib/core/utils/input_validator.dart`.
- Harden `TransactionModel` and `IncomeModel` JSON deserialization against NaN, out-of-range amounts, invalid dates, and unknown currencies.
- Sanitize CSV export: strip control characters, prefix formula-triggering values, write UTF-8 BOM, best-effort `chmod 600`.
- Harden audit log: `kAuditSchemaVersion = 1`, unique event ids, `previousValue` for update/delete, SHA-256 tamper-evidence chain, 90-day retention pruning, `exported` event on successful CSV export.

Reason:
Raw user input and deserialized JSON are the primary attack surface. Audit records must be trustworthy enough to reconstruct state changes and detect tampering.

See git history.

---

## Decision 033 — S1-W4 Security Hardening: Platform + Crypto + Lint Sweep

Date: 2026-06-14
Trigger: Adversarial audit remediation Sprint S1, Waves 1-2.

Decision:
- Platform hardening: disable Android cleartext traffic, disable auto-backup for sensitive boxes, set `FLAG_SECURE` on PIN activities, wire root/jailbreak detection to auth gate.
- Crypto/storage hardening: PIN uses `PinHasher` (SHA-256 + 16-byte salt), secure storage for Hive encryption key, explicit box wipe + key deletion on account deletion.
- Lint sweep: convert `catch` clauses to `on Exception catch`, await haptic futures, replace deprecated `withOpacity`/`Share.shareXFiles` with `withValues(alpha:)`/`SharePlus.instance.share()`.

Reason:
Client-side security for an offline-first app depends on making local extraction expensive. Platform flags, hardened KDF, secure key storage, and clean lint reduce attack surface.

See git history.

---

## Decision 032 — Phase 3 Notification System Complete

Date: 2026-06-12
Trigger: Phase 3 Groups 3A, 3B, 3C, 3E implemented and wired end-to-end.

Decision:
Phase 3 completed with all 5 groups implemented:

- **Group 3A**: `FlutterNotificationService` wraps `flutter_local_notifications` v22. Abstract `NotificationService` interface.
- **Group 3B**: Pure Dart `NudgeEvaluator` with 6 ranked rules. `NudgeDecision` value object. 14 unit tests.
- **Group 3C**: `NudgeLogEntryEntity` + Hive model (typeId 8). `NotificationCenterScreen` with date-grouped timeline, swipe-to-dismiss + undo toast, tap-to-navigate. Route at `/notifications`.
- **Group 3D**: Clinical-warm Helm voice copy inline in evaluator. No exclamation marks, no emoji, no comparative language.
- **Group 3E**: `NudgeEffectivenessService` computes sent/opened/dismissed/actioned rates per nudge type. 4 tests.

Wiring: `NudgeSessionService.evaluateAndLog()` called on every dashboard mount postFrameCallback.

Stats: dart analyze 0/0/0. 162/162 tests pass (+34). 2 packages added. 6 micro-commits.

See git history.

Reason:
Per-phase dispatch docs prevent agent context overload during implementation.

---

## Decision 030 — Phase 1 TDD + Clean Architecture Dispatch Plan

Date: 2026-06-12
Trigger: Phase 1 Behavioral Foundation ready for implementation.

Decision:
Execute Phase 1 (18 tasks, ~6 hours) as a TDD-gated, clean-architecture-enforced dispatch across 7 task groups in 3 waves. Full plan in `docs/planning/TDD_DISPATCH_PHASE_1_BEHAVIORAL_FOUNDATION.md`.

Key constraints: RED→GREEN→REFACTOR per task, no domain-to-data imports, no Flutter in domain, `mounted` guard after async. Exit: dart analyze 0/0/0, 78+25 tests pass.

Reason:
Phase 1 touches 7+ files across dashboard, onboarding, auth, income, safe-to-spend, and core themes. Wave structure prevents file-touch conflicts.

See git history.

---

## Decision 029 — Parallel Agent Dispatch: 3-Wave Insane Practice Hunt

Date: 2026-06-12
Trigger: 10 agent lenses available, master plan adopted.

Decision:
3-wave parallel agent dispatch against Helm codebase across 10 agent domains. Plan in `docs/planning/PARALLEL_AGENT_DISPATCH_PLAN.md`.

- Wave 1 (6 agents, zero deps): Nudge Engine, UX Researcher, UI Designer, Whimsy Injector, Brand Guardian, UX Architect
- Wave 2 (2 agents): Persona Walkthrough, Visual Storyteller
- Wave 3 (2 agents, deferred): Inclusive Visuals + Image Prompt Engineer — Phase 5 exit

Reason:
6 parallel lenses produce ~100-120 findings simultaneously instead of sequentially. Single-agent audit cannot cover all dimensions at once.

See git history.

---

## Decision 028 — 100% Master Plan Adopted as Implementation Roadmap

Date: 2026-06-12
Trigger: Behavioral Nudge Audit (62/100) + UI/UX Audit (78/100) + Synthesized Agent Analysis.

Decision:
`docs/planning/100_PERCENT_MASTER_PLAN.md` adopted as canonical implementation roadmap. 6 phases, ~85h total, ~15-17 sprints. Phase 5 gated on beta clearing all 5 thresholds. Phase 6 gated on V1 stable + legal + pricing.

Reason:
145+ total tasks from audits require a consolidated execution roadmap with explicit dependencies and gates to prevent scope drift.

See git history.

---

## Decision 027 — D3 Closed Beta Readiness: Conditional GO

Date: 2026-06-06

Decision:
Helm is **CONDITIONAL GO** for closed beta distribution. All technical and product prerequisites pass. 17 known limitations documented — none are beta blockers.

Conditions for full GO:
1. Release build verified on physical device (Samsung A14 or equivalent)
2. Manual QA script completed on device
3. Tester cohort recruited (15-25 Bangladeshi freelancers)
4. Feedback channel created

Post-beta decision per Doctrine S16: 5 mandatory thresholds (pipeline ≥85%, override <5%, retention ≥60%, onboarding ≥70%, S2S comprehension ≥80%). If 2+ miss: KILL.

---

## Decision 001 — Positioning Pivot

Date: 2026-05-22

Decision:
Helm will evolve from a generic expense tracker into a Freelancer Finance OS for emerging Bangladeshi earners.

Reason:
Generic expense trackers have low differentiation. Freelancer finance has stronger pain around irregular income, pending payments, subscriptions, and business/personal separation.

---

## Decision 002 — Offline-first Architecture

Date: 2026-05-22

Decision:
Helm will remain offline-first using Hive for local persistence.

Reason:
Target users may have unstable internet, and financial logging must feel instant.

---

## Decision 003 — Agentic Engineering OS

Date: 2026-05-22

Decision:
Helm will use project brain documentation to guide Antigravity, Claude Code, and Gemini CLI.

Reason:
Multi-agent development creates architecture drift unless agents share product and engineering rules.

---

## Decision 004 — No Feature Spam After MVP CRUD

Date: 2026-05-22

Decision:
After transaction CRUD stabilization, avoid random charts, AI, budget, or cloud features until product direction is validated.

Reason:
Feature bloat can destroy UX clarity.

---

## Decision 005 — Cashflow Operations Over Expense Tracking

Date: 2026-05-22

Decision:
Adopt Cashflow Operations & Financial Mental Health as the strategic category framing.

Reason:
Freelancers suffer from future cashflow uncertainty more than past spending categorization.

---

## Decision 006 — Three-State Income Model (Not Five)

Date: 2026-05-22

Decision:
Income Pipeline uses three states (Expected, Pending, Received) instead of the five-state model from research.

Reason:
Three states capture the core psychological distinction. Sub-states can be added later if user demand validates them.

---

## Decision 007 — Income Entries Separate From Transactions

Date: 2026-05-22

Decision:
Income Pipeline entries are a separate entity (`IncomeEntry`) stored in a separate Hive box.

Reason:
Transactions represent completed events. Pipeline entries represent future/in-progress cashflow. Merging them would complicate the stable transaction system.

---

## Decision 008 — Income list remains flat in Phase 7c

Date: 2026-05-22

Decision:
Income pipeline list displays as a flat list sorted by expectedDate / updatedAt without month grouping.

Reason:
Keep MVP cognitive load low; defer grouping until list length proves to be a problem.

---

## Decision 009 — Dashboard Pipeline Totals Filter by Dashboard Currency

Date: 2026-05-22

Decision:
`IncomePipelineSummary` on the dashboard only sums entries matching the dashboard's active currency. Mixed-currency totals are not shown.

Reason:
Summing BDT and USD amounts into a single total is financially misleading. Multi-currency display is out of scope for Phase 7.

---

## Decision 010 — Storage Architecture: Defer Hive → Drift Migration

Date: 2026-05-22

See Decision 012 (supersedes).

---

## Decision 011 — Public Positioning: Drop "OS" From External Copy

Date: 2026-05-22

Decision:
- Internal: Keep "Freelancer Finance OS" — helps contributors think systematically.
- External: Drop "OS" permanently. Use cashflow-specific framing.

Reason:
"OS" implies ERP/accounting software, creating an expectation-reality gap Helm cannot meet.

---

## Decision 012 — Adopt Storage Abstraction First (Phase 7f)

Date: 2026-05-22
Authority: Chief Architect

Decision:
Helm will NOT migrate from Hive to Drift before Phase 8. First clean transaction domain and storage boundaries so future migration is low-risk (Phase 7f). Drift/PowerSync remains confirmed long-term target before cloud sync (Phase 13+).

Reason:
External audit's integer-key sync concern doesn't apply — Helm uses string IDs. Full Drift migration now delays Safe-to-Spend by 1–2 weeks for sync readiness 12+ months away.

Migration gate: cloud sync scheduled within 2 phases, OR >200 active users, OR new data domain added, OR Hive breaks on Flutter stable.

---

## Decision 013 — Post-Phase 8 User Validation Sprint Is Mandatory

Date: 2026-05-22

Decision:
After Phase 8 ships, run a 30-day user validation sprint with 5–10 real Bangladeshi freelancers before Phase 9 begins.

Success threshold: ≥50% maintain pipeline for 30 days → continue to Phase 9. Failure: immediately pivot to friction reduction.

Reason:
Manual pipeline maintenance is the #1 product failure vector. Architecture cannot save a product whose data is stale.

---

## Decision 014 — Safe-to-Spend MVP Formula Finalized (Phase 8a)

Date: 2026-05-23
Authority: Chief Architect

Decision:
The Safe-to-Spend MVP formula is locked as:

```
Safe_to_Spend = Liquid_Cash − Tax_Reserve − Fixed_Costs_Due − Anxiety_Buffer

Where:
  Liquid_Cash       = Σ received BDT income − Σ all expenses
  Tax_Reserve       = Σ received BDT income × tax_rate (default 10%)
  Fixed_Costs_Due   = Σ user-entered fixed costs due within 30-day rolling window
  Anxiety_Buffer    = user-defined floor (default ৳0)
```

Sub-decisions: Pending/Expected income never included. USD excluded in Phase 8. Tax base = gross received income. `rawSafeToSpend` preserves negatives; displayed value clamped to ৳0. `FixedCostEntry.dueDayOfMonth` range 1–28. `FixedCostModel` typeId = 3. `SafeToSpendResult` is a value object. Horizon Number uses 0.8× pending / 0.3× expected discount factors. 30-day rolling window for fixed costs. `TransactionType.income` entries NOT counted.

Reason:
Safe-to-Spend must reflect only confirmed liquid money. Including pending/expected creates false confidence. Formula is intentionally conservative and user-auditable.

---

## Decision 015 — Legacy Income Obsolescence

Date: 2026-05-23

Decision:
`TransactionType.income` records become legacy-only, permanently hidden from primary dashboard summaries and recent transactions list. Add Transaction is strictly expense-only.

Reason:
Safe-to-Spend uses Income Pipeline as the only trusted income source. Keeping transaction income active creates double-income confusion.

---

## Decision 016 — Final Product Doctrine Adopted as Canon

Date: 2026-06-04

Decision:
`docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md` supersedes all prior roadmaps and earlier doctrine drafts. All future decisions must align. Conflicting documents must be updated or marked superseded.

Reason:
Prior docs contained scope drift and lacked validation gates. The Doctrine enforces disciplined execution with binary go/no-go thresholds.

---

## Decision 017 — F-Commerce and Generic Expense Tracking Permanently Killed

Date: 2026-06-04

Decision:
F-commerce operators and generic expense categorization are permanently excluded — not deferred, killed.

Reason:
F-commerce is a different product (COD tracking, inventory, POS). Generic expense tracking is TallyKhata/Hishabee territory. Both dilute the core S2S wedge.

---

## Decision 018 — Subscription Leakage Radar Killed

Date: 2026-06-04

Decision:
Subscription Leakage Radar killed. `docs/specs/SUBSCRIPTION_LEAKAGE_RADAR.md` superseded. No implementation.

Reason:
Does not appear in any Doctrine version scope. Pre-doctrine proposal that does not serve the core S2S wedge.

---

## Decision 019 — Multi-Wallet Deferred to V1, Tax Reserve to V2, Invoice-Lite to V2

Date: 2026-06-04

Decision:
- Multi-wallet: V1 scope. MVP uses single aggregated balance.
- Tax Reserve: V2 scope. User-declared %, never algorithmic. Explicit disclaimer required.
- Invoice-Lite: V2 scope. 3-sprint allocation, sequential numbering, TIN, BDT-equivalent, PDF, email delivery.

Reason:
MVP must validate S2S trust with minimal complexity before adding multi-wallet or tax/invoice complexity.

---

## Decision 020 — Closed Beta Validation Gates Are Mandatory

Date: 2026-06-04

Decision:
MVP closed beta (15–25 freelancers, 4 weeks) with go/no-go thresholds mandatory before V1. Thresholds: pipeline ≥85%, override <5%, retention ≥60%, onboarding ≥70%, S2S comprehension ≥80%. **2+ miss → KILL.**

Reason:
Beta is a controlled experiment. If S2S loop doesn't work with 15–25 users, it won't work with 1,000. Supersedes Decision 013's softer threshold.

---

## Decision 021 — Trust Layer is Non-Negotiable from MVP

Date: 2026-06-04

Decision:
All 8 trust layers required in MVP: Auth (Magic Link + PIN), Calculation (never stored, "—" on failure), Agency (users edit inputs only), Audit (every financial edit logged immutably), Sovereignty (CSV export + account deletion Day 1), Multi-device (single-device acceptable MVP), Storage (integer paisa, event-sourced), Legal (PDPO 2026 opinions before Sprint 1).

Reason:
Trust is the product. A finance app that loses trust on Day 1 never recovers.

---

## Decision 022 — UX Canon as Implementation Authority

Date: 2026-06-05

Decision:
`docs/ux/HELM_CANONICAL_UX_IMPLEMENTATION_SPEC.md` is the single source of truth for all UX implementation decisions, resolving 7+ conflicts across 10 source documents via explicit authority hierarchy.

Reason:
Without a canonical merged spec, implementation agents make inconsistent choices depending on which doc they read.

---

## Decision 023 — Sprint Sequence Reordered: Design System First

Date: 2026-06-05

Decision:
Sprint order changed to dependency-order: UX-5 (design system) → UX-1 (dashboard) → UX-2 (onboarding) → UX-3 (pipeline) → UX-4 (microcopy) → D1 (trust) → D2 (instrumentation) → D3 (beta readiness).

Reason:
Every sprint uses color tokens, typography, and widgets from UX-5. Building on wrong tokens then migrating is double work.

---

## Decision 024 — 81 Atomic Tasks as Implementation Contract

Date: 2026-06-05

Decision:
All UX implementation work decomposed into 81 atomic, verifiable tasks in `docs/planning/UX_EXECUTION_TODO.md`. Each task has 11 mandatory fields including acceptance criteria and verification method.

Reason:
Vague tasks cause agent drift and scope creep. Atomic tasks with explicit criteria allow any agent to execute without full project context.

---

## Decision 025 — A1 Internal Alpha Maturity Audit Downgrades Beta Readiness

Date: 2026-06-07

Decision:
D3 "CONDITIONAL GO" downgraded to **INTERNAL ALPHA READY**. 3 beta blockers (B1: audit log unreachable from UI; B2: auth guard bypasses PIN session check on cold start; B3: S2S shows 0 instead of "---" on failure), 5 major issues, 9 polish items identified.

Reason:
Full code inspection of 103 Dart files revealed navigation, auth guard, and S2S display bugs blocking external beta.

Impact: Sprint A2 commissioned (~3h). Total estimated effort to beta: ~17h across 4 sprints. See git history.

---

## Decision 026 — TDD Dispatch for Phase 1 Behavioral Foundation

Date: 2026-06-13
Authority: Antigravity (Claude Code implementation agent)

Decision:
Phase 1 Behavioral Foundation executed via TDD-first across 7 groups (A-G). 18 tasks, single sprint. 104/104 tests pass, dart analyze 0/0/0. 0 new packages.

Key decisions: `AppButton` → `StatefulWidget` with `AnimatedScale(0.97)`; haptics in presentation layer only; boundary events use SharedPrefs de-duplication; affirmation computation is pure domain; quiet copy (no exclamation marks, emoji, comparative language); slider steppers clamp via `onPressed: null`; onboarding skip persists partial draft.

Reason:
7+ files touched across dashboard, onboarding, auth, income, safe-to-spend, and core themes require TDD enforcement to prevent regressions.

See git history.

---

## Decision 035 — 12-Agent Adversarial Security Audit: 97 Vulnerabilities Found

Date: 2026-06-14

Decision:
**Security Hardening Sprint (Sprint S1)** commissioned to address all 97 vulnerabilities. Full audit report at `.commandcode/adversarial_audit_report.md`.

**97 findings**: 17 CRITICAL (P0), 35 HIGH (P1), 33 MEDIUM (P2), 12 LOW (P3).

Top exploit chains: (1) rooted device → PIN brute force → full data breach; (2) no PIN re-entry on resume → unlocked phone access; (3) debug signing → reverse engineer auth patterns; (4) cold-start PIN reset → brute force 10K PINs; (5) silent error returns → wrong S2S → financial loss.

Reason:
12-agent parallel adversarial audit covers every domain simultaneously, revealing cross-domain systemic vulnerabilities invisible to sequential single-domain reviews.

See git history.

---

## Decision 034 — Comprehensive Implementation Plan Adopted

Date: 2026-06-13

Decision:
`docs/planning/COMPREHENSIVE_IMPLEMENTATION_PLAN.md` adopted as canonical execution reference alongside 100% Master Plan. Adds: (1) Version Control Infrastructure (develop branch, release tags, hotfix protocol) before beta APK; (2) Phase 5 decomposed into 3 groups; (3) Phase 6 decomposed into 6 groups; (4) risk register with kill signals; (5) documentation hygiene mandate; (6) conventional commits + quality gates enforced.

Reason:
Master Plan lacks execution details on version control across beta distribution, phase sub-group decomposition, and risk materialization responses.

See git history.

---

## Decision 033 — Phase 4 Doctrine Gap Closure Complete

Date: 2026-06-13

Decision:
Phase 4 completed: 4 of 5 groups implemented (4B, 4C, 4E as planned; 4A as mock-first auth; 4D already done in D1.11).

Key decisions: Magic Link uses mock backend with swappable `AuthRemoteDataSource`; GoRouter 3-tier auth guard (Magic Link → PIN → Home); exclude toggle on income card (not in list); qualifier copy changed from identity-based to pain-point-based; instrumentation uses 30-minute SharedPrefs timestamp window; one widget test skipped due to Hive/FutureProvider deadlock.

Reason:
Mock-first auth architecture allows real backend swap (URL change only) without architecture changes. Legal L1-L7 still pending before real backend.

Stats: 210 total tests (+48), dart analyze 0/0/0, MPI feature completion 100%. See git history.

---

## Decision 036 — Helm Signal Deck Visual Direction Approved

Date: 2026-06-16

Decision:
Adopt **Helm Signal Deck**, a Spatial Editorialism design direction combining restrained spatial translucence, editorial hierarchy, and tactile interaction feedback. The approved composition uses a dominant Signal Hero, signature Signal Horizon, one-action Decision Deck, and `Signal / Flow / Trace` navigation model.

Reason:
Existing card and ledger layouts were judged insufficiently futuristic and structurally too close to generic finance dashboards. Signal Deck creates a premium, ownable decision-instrument identity while preserving Helm's trust, calm, and low-cognitive-load product contracts.

Constraints:
Visual redesign must not change business logic, trust model, persistence, routing, or state management. No new package may be added without Chief Architect approval. See `docs/superpowers/specs/2026-06-16-helm-signal-deck-design.md`.

Status:
Approved design merged to `main` on 2026-06-16 as commit `6773be4`. Implementation verified with `dart analyze` 0 issues and `flutter test` 307/307 pass.

---

## Decision 037 — NumberFormatter is the Single Currency Symbol Boundary

Date: 2026-06-20

Decision:
`NumberFormatter` in `lib/core/utils/number_formatter.dart` is the single global-readiness boundary for currency symbols. All UI surfaces must resolve currency glyphs through `NumberFormatter.symbolForCode(code)` / `prefixForCode(code)` — never hardcode a glyph in a widget.

Reason:
Found 7 hardcoded `৳` glyphs across 6 screens. Country-specific symbols in widget code block multi-currency readiness (EUR/SGD/GBP needed for Experiment 16.1 variants). Centralizing to one switch makes currency expansion a 3-line edit in one file.

Constraints:
Only `number_formatter.dart` may define currency symbols. `defaultCurrencyCode = 'BDT'` is the single location of the BDT-first assumption for MVP.

---

## Decision 038 — Material System-Widget Sizing Exempt from HelmTypography Tokens

Date: 2026-06-20

Decision:
Material system-widget sizing constraints are exempt from HelmTypography token requirements. Specifically, `TextStyle(fontSize: 10)` for Material `Badge` labels is a documented intentional exception, not a token violation.

Reason:
Material Badge uses 10pt by design. HelmTypography's smallest token (labelSm) is 11pt. Forcing labelSm breaks badge proportions. System-widget sizing contracts take precedence over Helm design tokens.

---

## Decision 039 — Paper Ledger Visual Direction (2026-06-21)

**Supersedes:** Decision 036 (Signal Deck).

**Decision:** Adopt Paper Ledger — warm paper (`#F3ECE0`) / warm espresso (`#1E1813`) dual mode, terracotta (`#C2603F`) accent, Fraunces display + Inter UI + JetBrains Mono money + Hind Siliguri Bangla. Latin numerals for all money.

**Why:** "calm & human" product feeling target; terracotta owns no state meaning so it never collides with semantic state colors; warm espresso preserves human feeling at night. stateSafe darkened from #5E7C63 → #567059, stateTight from #9A7B2F → #7A6024 for WCAG AA on warm paper canvas.

**Scope:** Visual only — no business-logic, persistence, or routing-guard changes. Bottom nav expanded to 4 tabs (Home/Pipeline/History/Settings) — founder-approved exception.

**Signal Deck code removed**, not hidden. 10 files deleted (5 lib + 5 test).

**Spec:** `docs/superpowers/plans/2026-06-21-paper-ledger-redesign.md`

---

## Decision 040 — Income View Consolidated onto Pipeline Tab (2026-06-21)

**Decision:** Removed the superseded `IncomeListScreen`, its orphaned entry widget
`IncomePipelineSummary`, the `/income` route + `RouteNames.income`, and 15 income-list-only
l10n strings. The Pipeline tab (`PipelineScreen`) is now the single income view.

**Why:** `pipeline_screen.dart` already "Replaces IncomeListScreen"; the list screen was
reachable only via the orphaned `IncomePipelineSummary` (dropped from the dashboard during the
Paper Ledger migration `3450a89`, never deleted). Reskinning unreachable code is wasted work.
Consistent with Decision 039's "removed, not hidden" precedent. Also cleared a 757-line
file-limit violation.

**Scope:** No user-facing behaviour change; no business-logic/persistence/Pipeline changes.
A permanent guard test (`test/config/router/income_route_removed_test.dart`) prevents
re-introduction of the `/income` route.

**Spec:** `docs/superpowers/specs/2026-06-21-income-list-consolidation-design.md`
**Plan:** `docs/superpowers/plans/2026-06-21-income-list-consolidation.md`
