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

## Phase 8e Lessons (2026-05-23)

### 1. Clamped values mask state detection bugs — always check the raw value
`SafeToSpendCalculator` clamps `safeToSpend = max(0.0, rawSafeToSpend)`. The hero checked `result.safeToSpend < 0` for "In reserve mode" — which is permanently false. Any derived value used for UI state must be the raw computed value, not the display-safe clamped one.

### 2. Widget input constraints must match entity assertions
The tax slider allowed 0–50% but `StsSettings` asserts `taxRate ≤ 0.40`. Input widgets must be bounded to match domain invariants — never rely on the entity to catch an assertion at runtime.

### 3. Silent fallbacks in financial inputs hide user errors
`double.tryParse(text) ?? 0.0` silently resets the buffer to zero on bad input. In a financial app, every input failure must produce explicit feedback. Users should never wonder "did my save work?"

### 4. Red for deductions creates unnecessary financial anxiety
`AppColors.error` on expense/tax/fixed-cost breakdown rows triggers alarm signals in users who are already anxious about money. Neutral grey for deductions; amber only for true reserve/warning states.

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

---

## Phase 8a Lessons (2026-05-23)

### 1. Formula work is product work — it deserves its own phase
The Safe-to-Spend formula has ten edge cases, two separate formulas (primary vs horizon), and a
full liquidity taxonomy. Jumping into implementation without locking the contract would have
produced a calculator that handles some edge cases and silently ignores others. Phase 8a treated
formula design as a first-class deliverable — the result is a deterministic, auditable contract
that Phase 8b can implement without guessing.

### 2. A "data contract phase" prevents implementation drift
Naming a phase "Formula & Data Contract" (rather than "research" or "planning") gives it
artifact authority: the spec is the law, not a suggestion. Phase 8b implementers have a locked
formula, named edge cases, a typed value object contract, and an acceptance checklist — zero
ambiguity.

### 3. The tax reserve base is gross income, not net liquid cash
A subtlety that could have silently produced wrong numbers: tax is owed on income earned, not on
income-minus-expenses. If a freelancer earns ৳100,000 and spends ৳60,000, their taxable income
is ৳100,000 — not ৳40,000. The formula correctly applies `tax_rate × received_income`, not
`tax_rate × liquid_cash`. This distinction only surfaces when you spell out every term explicitly.

### 4. Two income systems coexist — the calculator must not conflate them
Phase 8 introduces a critical accounting distinction: `TransactionEntity` with
`type == TransactionType.income` (the old Phase 1–6 transaction system) and `IncomeEntryEntity`
with `status == received` (the Phase 7 income pipeline) are SEPARATE. A careless calculator
implementation could double-count income by summing both. The contract explicitly states: only
`IncomeEntryEntity` with `status == received` AND `currency == 'BDT'` feeds the liquid cash
calculation. Old income transactions are not counted.

### 5. Clamping negative to zero is a UX decision, not a math decision — preserve the raw value
The formula can produce a negative Safe-to-Spend result (e.g., fixed costs + buffer exceed liquid
cash). The UI must never show a bare negative number — it must show ৳0 with calming contextual
copy. But the raw negative value must be stored in `SafeToSpendResult.rawSafeToSpend` so the
breakdown can be mathematically accurate. This distinction — display value vs computed value —
must be encoded in the value object, not hacked in the UI widget.

### 6. The dueDayOfMonth range of 1–28 prevents month-length bugs
Days 29, 30, 31 do not exist in all months. A fixed cost "due on day 31" would silently never
trigger in February, April, June, September, November. Constraining the input to 1–28 prevents
this class of bug entirely in the MVP. Advanced recurrence logic (end-of-month, last business day,
etc.) is a future enhancement — not a Phase 8 concern.

### 7. TypeId assignment must be documented as a global registry
Hive typeIds are global to the app — not scoped to a feature. Two features accidentally using the
same typeId will cause runtime corruption with no useful error. The rule: maintain a registry.
Phase 8 uses typeId: 3 for `FixedCostModel`. Document this in the spec and check the acceptance
checklist. Future features must consult this registry before assigning a new typeId.

### 8. Hive typeIds are global architecture state and require a registry.

---

## Phase 8b Lessons (2026-05-23)

### 1. Pure dart business logic layers are easy to test
The calculation logic was kept pure Dart (no Hive/Flutter imports), allowing immediate and easy unit tests with 10 edge cases.

### 2. Riverpod asynchronous state handling requires care
Deriving computed state like `safeToSpendProvider` from both synchronous notifiers and asynchronous sources (like `transactionsProvider`) needs `.valueOrNull ?? []` with proper fallback logic.