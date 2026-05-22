# POCKETA — LESSONS LEARNED

This file captures engineering, product, UX, and agentic workflow lessons.

---

## Product Lessons

### 1. Pocketa should not be a generic expense tracker
Generic expense apps are crowded and weakly differentiated. Pocketa is stronger as a Freelancer Finance OS.

### 2. Freelancer pain is more monetizable than general expense tracking
Irregular income, pending payments, subscriptions, and business/personal separation create stronger product value.

### 3. Pocketa must solve forward-looking freelancer cashflow uncertainty, not just backward-looking expense categorization
Users need to know "Am I okay this month?" and "When is this USD clearing?" Tracking past expenses doesn't solve this primary anxiety.

### 4. Calm UX matters more than feature count
Finance users need clarity, not dashboard noise.

---

## Engineering Lessons

### 1. Foundation before features
Routing, onboarding state, Hive setup, and analyzer cleanliness created a stable base.

### 2. Small phases prevent agent drift
Phase-based development kept Antigravity from overbuilding.

### 3. Offline-first is the correct default
Local-first CRUD made the app fast, usable, and reliable before cloud complexity.

### 4. Analyzer cleanliness is a quality gate
“No issues found” should remain mandatory after every phase.

---

## Agentic Engineering Lessons

### 1. Agents need product brain, not just code instructions
Without POCKETA_BRAIN.md, agents may build generic finance features.

### 2. Scope boundaries are mandatory
Every prompt must say what NOT to build.

### 3. Separate planner, builder, reviewer, stabilizer roles
One agent should not freely plan, code, and expand scope without review.

---

## Research-to-Spec Lessons

### 1. Research must be converted into spec boundaries, not left as general knowledge
Research docs contain rich insights but without explicit “build this / don't build this” boundaries, implementation agents will either ignore research or over-interpret it into feature bloat.

### 2. Three states are enough for MVP income tracking
Research describes 5+ states (Invoiced, Escrow, Transit, Pending, Cleared). For MVP, collapsing to Expected/Pending/Received captures 90% of the value without over-engineering the data model.

### 3. Color theory from research directly translates to UX rules
“No red for pending money” is a research-backed decision, not a style preference. Encoding behavioral findings as explicit UX rules in specs prevents implementation agents from defaulting to standard red/green patterns.

### 4. Pending money must never be treated as liquid cash in any calculation
This is the single most important insight from all research docs. It directly shapes both the Income Pipeline (Phase 7) and Safe-to-Spend (Phase 8) architecture.

---

## UX Lessons

### 1. Undo is better than heavy confirmation for frequent actions
Delete + Undo creates faster UX than confirm dialogs.

### 2. Filtering and grouping improve clarity before charts
Better list readability matters before visualization.

### 3. Empty states are product education moments
They should guide the user, not just say “No data”.

### 4. Empty states should be reassuring, not hollow
For a finance app targeting anxious users, “No pending payments right now” should feel calming, not alarming. Research shows freelancers scan for danger — empty states should signal safety.

### 5. Cache entity data at form load, not at submit time
Re-reading provider state during async submit creates race conditions. If entry is deleted between form open and submit, original data (like createdAt) is lost. Cache at initState.

### 6. Mixed-currency totals are financially misleading
Summing BDT and USD into one number is wrong. Dashboard summary must filter by active currency until proper conversion logic exists.

### 7. Delete undo snackbar should include amount
Users need to verify they deleted the right entry. Showing only client+project name is insufficient — the amount is the primary identifier in a financial app.

---

## Post-Audit Lessons (2026-05-22)

### 1. External audits must be verified against actual code, not just ecosystem knowledge
The Brutal Product Audit's most alarming architectural claim ("Hive mandates integer primary keys") was factually wrong for this specific codebase. Pocketa uses string IDs throughout. The audit read ecosystem documentation but not the repo. Always validate audit claims against actual source before acting on them.

### 2. TASKS.md is an agent contract — stale tasks mislead future agents
Phase 7e was marked `[x]` in TASKS.md but was NOT implemented. The next agent would have started Phase 8 on an incomplete Phase 7, breaking the pipeline feature. Docs must be updated at the moment a task is completed, not retroactively.

### 3. Architecture debt and product debt have different urgency profiles
Architecture violations (TransactionType @HiveType in domain) have low urgency but compound over time. Product behavioral gaps (manual friction) have unknown urgency but can kill the product immediately. Prioritize behavioral validation over architecture optimization whenever both are options.

### 4. Manual entry discipline is a behavioral hypothesis, not an engineering problem
No amount of good architecture, clean UI, or Riverpod providers can save an app whose core data goes stale because users stopped updating it. This must be validated with real users, not assumed.

### 5. "OS" positioning is a dual-use term — keep it internal, drop it externally
"Freelancer Finance OS" helps contributors and agents think systematically about product scope. To consumers, it signals ERP/accounting software they don't want. Both uses are valid — keep the internal framing, control the external framing.

### 6. When two AI agents contradict each other, the one who read the actual source code wins
Gemini research audit and Claude architecture audit gave opposite advice on Hive migration timing. Claude's audit was codebase-verified. Gemini's was ecosystem-verified. The codebase verification takes precedence for implementation decisions.

### 7. Never start a new feature phase without verifying the previous phase acceptance checklist is fully satisfied
Phase 7 acceptance checklist had status transition items unchecked. TASKS.md said it was done. The checklist is the ground truth — always verify it, not just the task tracker.

---

## Phase 7f Lessons (2026-05-23)

### 1. Moving a Hive adapter out of the domain is a surgical one-file change
When `@HiveType` annotations live in the domain layer, the fix is: (a) strip the annotation and `part` directive from the domain enum, (b) create a manual TypeAdapter in `data/adapters/`, (c) delete the stale `.g.dart`, (d) update `HiveService` import. Zero stored data changes, zero typeId changes. The entire operation is safe and reversible.

### 2. All generated adapters must have a matching manual fallback strategy documented
If build_runner ever fails, manual adapters in `data/adapters/` serve as a safe fallback. The key rule: preserve typeId and byte-index assignments exactly. Changing either causes irreversible data corruption.

### 3. Domain purity is testability — not just architecture theory
A pure Dart domain layer can be tested without Flutter, without Hive, without any platform setup. This is the real payoff. A domain that imports Hive forces all tests to mock storage infrastructure before testing business logic.

### 4. Repository interface type defines the domain boundary contract
If `TransactionRepository` accepts `TransactionModel`, every caller in the presentation layer must know about Hive models. Changing the interface to accept `TransactionEntity` ripples through exactly the right files — presentation and domain — without touching the data layer internals.