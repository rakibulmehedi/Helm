# POCKETA — DECISION LOG

This file records important product and architecture decisions.

---

## Decision 022 — D1 PIN Hash: SHA-256 + per-setup salt (D1P patch)

Date: 2026-06-06 (updated D1P 2026-06-06)

Decision:
PIN is stored as `SHA-256(salt + pin)` hex digest in Hive `auth_box`.
- `pin_hash` key: 64-char hex SHA-256 digest
- `pin_salt` key: 32-char hex random salt (16 bytes, generated once per setup)
- `crypto: ^3.0.3` added to pubspec.yaml (approved)

`PinHasher` domain class (`lib/features/auth/domain/pin_hasher.dart`) encapsulates `generateSalt()`, `hashPin()`, `verify()` — tested via `test/features/auth/domain/pin_hasher_test.dart`.

Migration: if `pin_is_setup=true` but `pin_salt` absent → old base64 format detected → PIN cleared → user must re-setup. Cannot upgrade without original PIN.

Reason:
base64 is reversible encoding, not hashing. SHA-256 with unique salt prevents rainbow-table attacks even on local storage. `crypto` package approved for D1P.

Impact:
Existing beta testers with base64 PIN will be forced to re-setup PIN once. Acceptable at pre-beta stage.

---

## Decision 023 — D1 Buffer: Percentage (5–30%) replaces Absolute BDT

Date: 2026-06-06

Decision:
`StsSettings.anxietyBuffer` (absolute BDT floor) replaced by `bufferPercent` (5–30%, default 15%). Calculator computes `buffer = bufferPercent / 100 * totalReceivedIncomeBdt`.

Reason:
Absolute BDT floor becomes meaningless as income changes. Percentage scales with freelancer income variability. GAP-009 resolution.

Impact:
Migration: old `stsSettings_anxietyBuffer` SharedPrefs key converted to `stsSettings_bufferPercent = 15.0` on first load. `SafeToSpendResult.anxietyBuffer` field unchanged (still holds computed BDT amount for display).

---

## Decision 024 — D1 Export: Documents directory + share sheet (D1E patch)

Date: 2026-06-06 (updated D1E patch 2026-06-06)

Decision:
CSV export writes 5 files to `getApplicationDocumentsDirectory()`, then triggers native share sheet via `Share.shareXFiles`. `share_plus: ^10.1.2` approved and added.

Reason:
Documents-dir save alone is friction-heavy — not directly accessible on all Android devices. Share sheet gives users instant access to email, Drive, WhatsApp, etc. Export remains explicit and user-initiated.

Impact:
`_showSuccessDialog` replaced by `_shareFiles` in `export_screen.dart`. Beta blocker resolved. `local_auth` (D1.04 biometric) remains open.

---

## Decision 025 — D1 Biometric: Deferred to V1

Date: 2026-06-06

Decision:
D1.04 (biometric auth via `local_auth`) deferred. PIN-only auth for MVP.

Reason:
Requires `local_auth` package approval. Many budget Android phones lack biometric hardware. PIN must be primary fallback regardless.

Impact:
PIN auth guard is live. Biometric offer during PIN setup is placeholder for V1.

---

## Decision 026 — Beta Blocker Package Registry

Date: 2026-06-06

Decision:
Two packages are deferred pending explicit approval. They are NOT forgotten TODOs —
they are named, tracked beta blockers that must be resolved before closed beta ships.

| Package | Purpose | Blocked task | TODO location |
|---|---|---|---|
| `share_plus` | Native share sheet for CSV export | D1.08-09 UX | **RESOLVED** — D1E patch 2026-06-06 |
| `local_auth` | Biometric auth (fingerprint/Face ID) | D1.04 | `pin_setup_screen.dart` + `pin_entry_screen.dart` |

Reason:
Both packages require Flutter plugin approval (platform code, Play Store permissions).
Merging without review risks unnecessary permissions in production binary.

Impact:
Before beta: approve or explicitly kill each package. If approved, replace TODO stubs
in named files. If killed, update TASKS.md backlog accordingly.

---

## Decision 027 — D3 Closed Beta Readiness: Conditional GO

Date: 2026-06-06

Decision:
Pocketa is **CONDITIONAL GO** for closed beta distribution. All technical prerequisites pass. All product prerequisites pass. Critical PIN deletion bug (base64 vs SHA-256 hash mismatch in `_PinConfirmDialog`) fixed during sprint. 17 known limitations documented — none are beta blockers.

Conditions for full GO:
1. Release build verified on physical device (Samsung A14 or equivalent)
2. Manual QA script (docs/beta/MANUAL_QA_SCRIPT.md) completed on device
3. Tester cohort recruited (15-25 Bangladeshi freelancers)
4. Feedback channel created (WhatsApp/Telegram group)

Post-beta decision per Doctrine S16:
- 5 mandatory thresholds: pipeline >=85%, override <5%, retention >=60%, onboarding >=70%, S2S comprehension >=80%
- If 2+ miss: KILL. Do not ship V1.
- Full protocol: docs/beta/BETA_VALIDATION_PROTOCOL.md

Impact:
- No more feature sprints before beta. Ship what exists.
- All 8 UX Canon sprints complete (UX-5, UX-1, UX-2, UX-3, UX-4, D1, D2, D3)
- Next action: build APK, run manual QA, recruit testers, distribute

---

## Decision 001 — Positioning Pivot

Date: 2026-05-22

Decision:
Pocketa will evolve from a generic expense tracker into a Freelancer Finance OS for emerging Bangladeshi earners.

Reason:
Generic expense trackers have low differentiation and weak ROI. Freelancer finance has stronger pain around irregular income, pending payments, subscriptions, and business/personal separation.

Impact:
Future features must prioritize freelancer cashflow clarity over generic personal finance feature bloat.

---

## Decision 002 — Offline-first Architecture

Date: 2026-05-22

Decision:
Pocketa will remain offline-first using Hive for local persistence.

Reason:
Target users may have unstable internet, and financial logging must feel instant.

Impact:
Cloud sync will be added later without breaking local-first behavior.

---

## Decision 003 — Agentic Engineering OS

Date: 2026-05-22

Decision:
Pocketa will use project brain documentation to guide Antigravity, Claude Code, and Gemini CLI.

Reason:
Multi-agent development creates architecture drift unless agents share product and engineering rules.

Impact:
Agents must read POCKETA_BRAIN.md, ARCHITECTURE_RULES.md, AGENT_WORKFLOW.md, and ROADMAP.md before major work.

---

## Decision 004 — No Feature Spam After MVP CRUD

Date: 2026-05-22

Decision:
After transaction CRUD stabilization, the project should avoid random charts, AI, budget, or cloud features until product direction is validated.

Reason:
Feature bloat can destroy UX clarity.

Impact:
Next major module should be Freelancer Income Tracking, not generic chart expansion.

---

## Decision 005 — Cashflow Operations Over Expense Tracking

Date: 2026-05-22

Decision:
Adopt Cashflow Operations & Financial Mental Health as the strategic category framing.

Reason:
Freelancers suffer from future cashflow uncertainty (pending payments, subscriptions) more than past spending categorization.

Impact:
Income Pipeline and Safe-to-Spend Balance are now the highest priority modules. AI chatbot, complex invoicing, and deep budgeting are explicitly deprioritized.

---

## Decision 006 — Three-State Income Model (Not Five)

Date: 2026-05-22

Decision:
Phase 7 Income Pipeline uses three states (Expected, Pending, Received) instead of the five-state model described in research (Invoiced, Escrow, Transit, Pending, Cleared).

Reason:
Research describes the full freelancer payment lifecycle, but implementing all states in MVP creates unnecessary complexity. Three states capture the core psychological distinction: money I expect, money in motion, and money I have. Sub-states (Escrow vs Transit) can be added later if user demand validates them.

Impact:
Data model uses a simple enum. Status transitions are straightforward. Future phases can add granularity without breaking the existing model.

---

## Decision 007 — Income Entries Separate From Transactions

Date: 2026-05-22

Decision:
Income Pipeline entries will be a separate entity (IncomeEntry) from existing Transactions, stored in a separate Hive box.

Reason:
Transactions represent completed financial events (expenses and income that already happened). Income Pipeline entries represent future/in-progress cashflow with status tracking. Merging them would complicate the existing stable transaction system and create confusion between "income I received" (transaction) and "income I'm expecting" (pipeline entry).

Impact:
New feature module at `lib/features/income/`. Separate data layer, domain entities, and providers. Dashboard integrates both but does not merge the data models.

---

## Decision 008 — Income list remains flat in Phase 7c

Date: 2026-05-22

Decision:
The income pipeline list displays as a flat list sorted by expectedDate / updatedAt without month grouping.

Reason:
To keep the MVP cognitive load low and defer month grouping until real usage shows list length is actually a problem.

Impact:
Income list has a simple flat list layout. No sections or complex adapter header logic are introduced yet.

---

## Decision 009 — Dashboard Pipeline Totals Filter by Dashboard Currency

Date: 2026-05-22

Decision:
IncomePipelineSummary on the dashboard only sums entries matching the dashboard's active currency (e.g. BDT). Mixed-currency totals are not shown.

Reason:
Summing BDT and USD amounts into a single total is financially misleading. Multi-currency display requires conversion logic that is out of scope for Phase 7. Filtering by currency is the safest minimal fix.

Impact:
Users with USD income entries will not see those amounts in a BDT dashboard summary. Full multi-currency pipeline totals are deferred to a future phase.

---

## Decision 010 — Storage Architecture: Defer Hive → Drift Migration

Date: 2026-05-22
Trigger: Brutal Product Audit recommended immediate Hive → Drift migration.

Decision:
Do NOT migrate from Hive to Drift before Phase 8.
Execute domain cleanup only (TransactionEntity, @HiveType relocation, fromJson/toJson). ~7–11h.
Revisit full migration at Phase 9 kickoff or when gate criteria are met.

Reason:
- Audit's core claim ("integer primary keys make sync impossible") is factually wrong for this codebase — Pocketa uses string IDs via IdGenerator.uniqueId()
- Abstract data source interfaces already exist; eventual migration surface is ~4 files
- Cloud sync is Phase 13+ (12+ months away); migrating now is premature optimization
- Delaying Safe-to-Spend (the singular product value) for infrastructure is product malpractice

Impact:
Safe-to-Spend ships on current Hive architecture. Domain violations are fixed before Phase 8.
Migration gate criteria: sync scheduled within 2 phases, or >200 active users, or new data domain added, or Hive breaks on Flutter stable.

Ref: docs/architecture/LOCAL_DATABASE_DECISION_REVIEW.md, docs/architecture/HIVE_TO_DRIFT_MIGRATION_OPTIONS.md

---

## Decision 011 — Public Positioning: Drop "OS" From External Copy

Date: 2026-05-22
Trigger: Brutal Product Audit + Gemini validation flagged "Freelancer Finance OS" as externally dangerous.

Decision:
- Internal (docs, agents, architecture): Keep "Freelancer Finance OS" — it helps contributors think systematically.
- External (App Store, website, social, taglines): Drop "OS" permanently. Use cashflow-specific framing.

Reason:
"OS" implies ERP/accounting software to consumers, creating an expectation-reality gap. Pocketa explicitly excludes invoicing, tax filing, and complex accounting. The term sets expectations it cannot meet.

Impact:
No code changes required. External-facing copy must use cashflow-specific positioning before any App Store listing or public promotion.
Candidate directions: "Active Cashflow Guardian", "Cashflow Survival Guide", "Safe-to-Spend for Freelancers".

---

## Decision 012 — Adopt Storage Abstraction First (Phase 7f)

Date: 2026-05-22
Authority: Chief Architect
Trigger: External Brutal Product Audit recommended immediate Hive → Drift migration. Repo-aware audit (Claude) contradicted this.

Decision:
Pocketa will NOT immediately migrate from Hive to Drift before Phase 8. Instead, it will first clean the transaction domain and storage boundaries so future migration becomes low-risk.

This work is scoped as Phase 7f and runs before Phase 8 (Safe-to-Spend).

Reason:
- Repo-aware audit found the external audit's integer-key sync concern does not apply — Pocketa uses string IDs with box.put(id, model), not integer auto-keys
- Full Drift migration now delays Safe-to-Spend by 1–2 weeks for sync readiness that is 12+ months away
- Option C (Storage Abstraction First) provides the best risk/reward at this stage
- Safe-to-Spend is the singular product value proposition and must not be delayed for infrastructure

Impact:
- Phase 7f will clean transaction domain boundaries before Safe-to-Spend
- Creates TransactionEntity, fixes TransactionRepository domain violation, moves @HiveType out of domain, adds fromJson/toJson
- Migration surface reduced to ~4 files when Drift is actually needed
- Drift/PowerSync remains the confirmed long-term target before cloud sync (Phase 13+)

Migration gate criteria (when to execute actual Drift migration):
- Cloud sync is scheduled within 2 phases, OR
- Active users exceed 200 (data recovery becomes critical), OR
- A third data domain is added, OR
- Hive breaks on a Flutter stable release

Ref: docs/architecture/LOCAL_DATABASE_DECISION_REVIEW.md, docs/architecture/HIVE_TO_DRIFT_MIGRATION_OPTIONS.md

---

## Decision 013 — Post-Phase 8 User Validation Sprint Is Mandatory

Date: 2026-05-22
Trigger: Brutal Product Audit + Gemini validation identified manual pipeline maintenance as the #1 product failure vector.

Decision:
After Phase 8 ships, before Phase 9 begins, run a 30-day user validation sprint with 5–10 real Bangladeshi freelancers.

Primary validation target:
"Will users actually maintain the Expected → Pending → Received pipeline manually for 30 days?"

Success threshold: If ≥50% of users maintain their pipeline for 30 days, continue to Phase 9 (Subscription Leakage Radar).
Failure threshold: If <50% maintain it, immediately pivot engineering resources to friction reduction (reminder prompts, simplified transitions, or future SMS parsing).

Reason:
All the architecture, formula math, and UX design in the world cannot save a product whose data is stale because users stopped caring. This is the fatal unknown. It cannot be validated by code.

Impact:
Phase 9 scope is conditional on validation outcome. SMS parsing (local Android) is the contingency feature if manual entry proves fatal.

Ref: docs/planning/POST_AUDIT_EXECUTION_ROADMAP.md

---

## Decision 014 — Safe-to-Spend MVP Formula Finalized (Phase 8a)

Date: 2026-05-23
Authority: Chief Architect (Phase 8a mission brief)
Trigger: Phase 8a formula & data contract task.

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

Sub-decisions:
1. **Pending and Expected income are NEVER included in Safe-to-Spend.** Absolute rule, no UI override.
2. **USD income is excluded in Phase 8 MVP.** No conversion logic available. Shown in breakdown as excluded note.
3. **Tax reserve base = received income, not liquid cash.** Tax is owed on gross income, not net-of-expenses.
4. **rawSafeToSpend preserves negative values; displayed safeToSpend is clamped to ৳0.** Never show negative to user without context.
5. **FixedCostEntry.dueDayOfMonth range: 1–28.** Days 29/30/31 excluded to avoid month-length edge cases in MVP.
6. **FixedCostModel typeId = 3.** Next available typeId after transaction (0/1) and income (2).
7. **SafeToSpendResult is a value object** carrying all breakdown fields — UI renders without re-computing.
8. **Horizon Number uses 0.8× pending and 0.3× expected discount factors.** Starting hypotheses subject to user validation — NOT a locked value.
9. **30-day rolling window for fixed cost deduction.** MVP uses a fixed 30-day window. Dynamic adjustment (e.g., 45-day income cycle) is a Phase 8+ enhancement.
10. **TransactionType.income entries (old system) are NOT counted in received income.** Only IncomeEntryEntity with `status == received` and `currency == 'BDT'` counts as liquid income.

Reason:
All formula decisions align with the primary product rule: a freelancer's Safe-to-Spend must reflect
only confirmed liquid money. Pending/expected money is hope, not cash. Including it in the primary
number would create false confidence and risk overspend. The formula is intentionally conservative
and transparent — every deduction is visible and user-auditable in the breakdown.

Impact:
Phase 8b implementation must conform exactly to this formula. No deviation without Chief Architect approval.
Full contract: `docs/specs/SAFE_TO_SPEND_MODEL.md` (overwritten from hypothesis to locked state in Phase 8a).

Ref: docs/specs/SAFE_TO_SPEND_MODEL.md, docs/implementation/PHASE_8_SAFE_TO_SPEND_EXECUTION_PLAN.md

---

## Decision 015 — Legacy Income Obsolescence

Date: 2026-05-23
Trigger: Post-Phase 8 Deep QA Validation Sprint revealed confusion when mixing legacy transaction income and pipeline income on the Dashboard.

Decision:
`TransactionType.income` records become legacy-only. They are permanently hidden from primary dashboard summaries and the recent transactions list.

Reason:
Safe-to-Spend uses the Income Pipeline as the only trusted income source. Keeping transaction income active creates double-income confusion and violates the single source of truth for liquid cash.

Impact:
- Add Transaction is strictly expense-only.
- Existing legacy income records remain stored in the database but will not affect Safe-to-Spend or primary summaries.
- Dashboard completely filters out `TransactionType.income` from the "Recent Transactions" list.

---

## Decision 016 — Final Product Doctrine Adopted as Canon

Date: 2026-06-04
Trigger: Chief Architect approved `docs/strategy/POCKETA_FINAL_PRODUCT_DOCTRINE.md` as the highest strategic authority.

Decision:
The Final Product Doctrine supersedes all prior roadmaps, expansion maps, and earlier doctrine drafts. All future product, architecture, and scope decisions must align with the Doctrine. Conflicting documents must be updated or marked as superseded.

Reason:
Prior docs contained scope drift (F-commerce, Subscription Leakage Radar, generic expense tracking) and lacked validation gates. The Doctrine enforces disciplined execution with binary go/no-go thresholds.

Impact:
- Strategic Authority Hierarchy established: Doctrine > CLAUDE.md > BRAIN > ARCHITECTURE_RULES > ROADMAP > Specs
- All agent pre-flight checklists updated to read Doctrine first
- ROADMAP.md restructured to match Doctrine version scope

---

## Decision 017 — F-Commerce and Generic Expense Tracking Permanently Killed

Date: 2026-06-04
Trigger: Final Product Doctrine §2, §8

Decision:
F-commerce operators (Facebook/Instagram sellers, COD, inventory, POS) are permanently excluded from target users. Generic expense categorization is permanently excluded from product scope. These are not deferred — they are killed.

Reason:
F-commerce is a different product entirely (COD tracking, inventory, POS). Generic expense tracking is TallyKhata/Hishabee territory with no Pocketa advantage. Both dilute the core wedge (pipeline-aware Safe-to-Spend for USD→BDT freelancers).

Impact:
- Target Users updated in POCKETA_BRAIN.md
- ROADMAP.md scope cleaned
- No future agent may propose these features

---

## Decision 018 — Subscription Leakage Radar Killed

Date: 2026-06-04
Trigger: Final Product Doctrine — feature not present in any version scope (MVP/V1/V2/V3)

Decision:
Subscription Leakage Radar is killed. The spec at `docs/specs/SUBSCRIPTION_LEAKAGE_RADAR.md` is superseded. No implementation will occur.

Reason:
The Doctrine explicitly scopes MVP through V3. Subscription tracking does not appear in any version. It was a pre-doctrine feature proposal that does not serve the core S2S wedge.

Impact:
- `docs/specs/SUBSCRIPTION_LEAKAGE_RADAR.md` marked as SUPERSEDED
- Removed from ROADMAP and CURRENT_SPRINT out-of-scope lists

---

## Decision 019 — Multi-Wallet Deferred to V1, Tax Reserve to V2, Invoice-Lite to V2

Date: 2026-06-04
Trigger: Final Product Doctrine §4, §5, §6

Decision:
- Multi-wallet: V1 scope (after MVP beta clears thresholds). MVP uses single aggregated balance.
- Tax Reserve: V2 scope. User-declared %, never algorithmic. Explicit "This is not tax advice" disclaimer required.
- Invoice-Lite: V2 scope. 3-sprint allocation, non-negotiable. Sequential numbering, TIN, BDT-equivalent, PDF, email delivery.

Reason:
MVP must validate S2S trust with minimal complexity. Multi-wallet doubles complexity before trust is proven. Tax reserve has ambiguity that could become a trust bomb. Invoice-Lite is a 2–3 sprint feature, too heavy for MVP.

Impact:
- Virtual Wallets spec (`docs/specs/VIRTUAL_WALLETS.md`) is superseded for MVP scope
- Current S2S formula's tax rate slider remains in app but is Doctrine-deferred to V2 for the formal Tax Reserve feature
- ROADMAP restructured with V1/V2 milestones

---

## Decision 020 — Closed Beta Validation Gates Are Mandatory

Date: 2026-06-04
Trigger: Final Product Doctrine §4, §16

Decision:
MVP closed beta (15–25 freelancers, 4 weeks) with specific go/no-go thresholds is mandatory before V1 begins. Thresholds:
- Pipeline update compliance: ≥85%
- Override-equivalent rate: <5%
- 30-day retention: ≥60%
- Onboarding completion: ≥70%
- S2S comprehension: ≥80%

**If 2+ thresholds miss → KILL. Do not ship V1.**

Reason:
The Doctrine treats the beta as a controlled experiment, not a soft launch. If the core S2S loop doesn't work with 15–25 users, it won't work with 1,000.

Impact:
- Supersedes Decision 013's softer "50% maintain pipeline" threshold
- Builds on Decision 013's validation mandate with stricter criteria
- Closed-beta instrumentation must be built into MVP

---

## Decision 021 — Trust Layer is Non-Negotiable from MVP

Date: 2026-06-04
Trigger: Final Product Doctrine §10

Decision:
All 8 trust layers from the Doctrine must be addressed in MVP:
1. Auth: Magic Link + mandatory PIN/biometric on every app open
2. Calculation: S2S always computed, never stored; "—" on failure
3. Agency: Users edit inputs, never override S2S output
4. Audit: Every financial edit logged immutably
5. Sovereignty: CSV export + account deletion from Day 1
6. Multi-device: No last-write-wins; single-device acceptable in MVP
7. Storage: Integer paisa, event-sourced financial operations
8. Legal: PDPO 2026 opinions required before Sprint 1

Reason:
Trust is the product. A finance app that loses trust on Day 1 never recovers.

Impact:
- Auth system (Magic Link + PIN) must be built — currently MISSING
- Audit log must be built — currently MISSING
- CSV export must be built — currently MISSING
- Account deletion must be built — currently MISSING
- These are MVP-blocking gaps

---

## Decision 022 — UX Canon as Implementation Authority

Date: 2026-06-05
Trigger: UX Canon Extraction & Implementation Planning Sprint

Decision:
The Canonical UX Implementation Spec (`docs/ux/POCKETA_CANONICAL_UX_IMPLEMENTATION_SPEC.md`) is now the single source of truth for all UX implementation decisions. It merges and resolves conflicts across 10 source documents using this authority hierarchy:
1. Final Product Doctrine (highest product authority)
2. UX Doctrine (highest UX authority)
3. Visual Identity Critique & Refined System (overrides earlier VI System)
4. Tier-1 Dashboard Critique v2 (overrides earlier Dashboard Redesign)
5. Microcopy System (copy authority)
6. Pipeline Interaction Optimization (pipeline authority)
7. Onboarding Redesign (onboarding authority)
8. UX Research (evidence, not law)
9. Existing code (reality, not authority)

Reason:
10 source documents contained 7+ direct contradictions. Without a canonical merged spec, implementation agents would make inconsistent choices depending on which doc they read. The canonical spec resolves every contradiction explicitly.

Impact:
- All implementation sprints reference the canonical spec, not individual source docs
- 7 conflicts explicitly resolved (accent line → Ledger Rail, chronometer → cashflow ledger, alpha → solid colors, dashboard layout, tax reserve timing, onboarding steps, card borders)
- Supersedes ad-hoc UX decisions from earlier phases

---

## Decision 023 — Sprint Sequence Reordered: Design System First

Date: 2026-06-05
Trigger: Dependency analysis during UX-to-code planning

Decision:
Implementation sprint order changed from doc-order (UX-1 first) to dependency-order (UX-5 first):
1. UX-5 Visual Identity / Design System (foundation — no dependencies)
2. UX-1 Dashboard Cockpit Redesign (depends on UX-5)
3. UX-2 Onboarding Redesign (depends on UX-5)
4. UX-3 Pipeline Quick-Update (depends on UX-1, UX-5)
5. UX-4 Microcopy Replacement (depends on UX-1, UX-2, UX-3)
6. D1 Trust Layer Foundation (depends on UX-2)
7. D2 Beta Instrumentation (depends on D1)
8. D3 Closed Beta Readiness (depends on all above)

Reason:
Every sprint uses color tokens, typography, spacing, and widgets defined in UX-5. Building Dashboard (UX-1) first would require using wrong tokens then migrating — double work. Design system first means every subsequent sprint builds on correct foundations.

Impact:
- 81 tasks across 8 sprints
- Sprint 1 (UX-5) has zero dependencies — can start immediately
- Each sprint end gate: `dart analyze` 0/0/0

---

## Decision 024 — 81 Atomic Tasks as Implementation Contract

Date: 2026-06-05
Trigger: UX Canon planning Pass 3

Decision:
All UX implementation work is decomposed into 81 atomic, verifiable tasks documented in `docs/planning/UX_EXECUTION_TODO.md`. Each task has 11 mandatory fields: task ID, source requirement, affected screen/module, files affected, expected outcome, non-goals, acceptance criteria, verification method, docs update requirement, learning note, and suggested commit message.

Reason:
Vague tasks ("improve dashboard") cause agent drift, scope creep, and unverifiable outcomes. Atomic tasks with explicit acceptance criteria allow any agent to execute a single task without needing full project context. The 11-field format prevents the most common planning failures: unclear scope, missing non-goals, and no verification method.

Impact:
- Future implementation agents must use `UX_EXECUTION_TODO.md` as their task contract
- Each task completion must update `CURRENT_SPRINT.md`
- No task may be marked complete without passing its verification method