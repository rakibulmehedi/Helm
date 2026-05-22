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

## Decision 012 — Post-Phase 8 User Validation Sprint Is Mandatory

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