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