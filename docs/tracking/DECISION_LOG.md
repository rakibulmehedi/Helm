# POCKETA — DECISION LOG

This file records important product and architecture decisions.

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