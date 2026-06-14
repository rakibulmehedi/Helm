# POCKETA — LESSONS LEARNED

This file captures engineering, product, UX, and agentic workflow lessons.

---

## Audit Synthesis Lessons (2026-06-12)

### 11. Behavioral Audit + UI/UX Audit — Nudge delivery is the single biggest gap
Pocketa has sophisticated in-app psychology (loss aversion, anchoring, safety framing = 85/100) but zero out-of-app engagement infrastructure. Cadence & personalization scored 15/100, nudge delivery 20/100. The user must remember to open the app — the app never reaches out. Rule: in-app psychology without out-of-app delivery = great engine with no transmission.

### 12. Behavioral Audit + UI/UX Audit — Haptics are behavioral infrastructure, not polish
The UI/UX audit flagged zero haptic feedback as CRITICAL. The behavioral audit maps this to Fogg's "Ability" signal — haptics confirm micro-actions without cognitive load. Every tap, confirm, delete, and error should have haptic. This is table-stakes for fintech apps, not a "nice to have."

### 13. Behavioral Audit — Celebration tension has a middle ground
ONB-014 deliberately bans confetti and congratulations. But the behavioral audit gives Celebration & Reinforcement 10/100. The resolution is "Quiet Affirmation" — acknowledgment without gamification. "7 days tracked" in the trust strip is factual, not celebratory. Relief signals (pipeline up to date = green rail) are rewards without fanfare.

### 14. Behavioral Audit — Dashboard must be a coach, not a mirror
The current dashboard is passive: it displays state but doesn't guide action. A user with 3 overdue entries sees the same dashboard as a user with 0. The nudge engine's core rule — "Show the 1 most critical item, not all 50" — directly applies to the pipeline list and dashboard. The "next best action" card is the single highest-impact behavioral change.

### 15. Agent Design — Keep agent definitions general-purpose, not codebase-hardcoded
Per taste preference: agent definition files should be reusable lenses, not project-specific scripts. The behavioral nudge engine was briefly overwritten with Pocketa-specific Flutter/Dart code and brand voice constraints — then restored. The correct pattern: apply the agent as a lens to produce project-specific deliverables (in docs/), but leave the agent definition general-purpose.

### 16. Audit Workflow — Cross-referencing audits through agent lenses amplifies findings
Running both audits (Behavioral 62/100, UI/UX 78/100) through 7 agent lenses (Nudge Engine, UX Researcher, UI Designer, UX Architect, Whimsy Injector, Persona Walkthrough, Brand Guardian) revealed connections neither audit caught alone. The UI/UX audit's "CRITICAL haptics" and the behavioral audit's "Fogg Ability signal" are the same gap seen from different angles. Synthesis produces a merged priority matrix that neither individual audit could produce.

### 17. Planning — Comprehensive plans need explicit score projections and gates
The master plan includes per-phase score projections with measurement criteria. Beta gates (5 thresholds, 2+ misses = KILL) are mandatory before V1. V2 gates (V1 stable + invoice pre-validation + legal L5 + pricing validation) are mandatory before Phase 6. Without explicit gates, scope drift is inevitable.

### 18. Documentation — Audits must produce deliverables, not just findings
Both audits ended with prioritized action lists. The nudge engine produced 10 concrete deliverables (event wiring plan, nudge sequence design, nudge copy library, preference discovery flow, quiet affirmation system, dashboard card spec, notification center UI, effectiveness tracking, haptic plan, implementation priority). Every audit should end with "what do we build next?" not just "what did we find?"

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

### 5. UX-4 — Microcopy is a trust surface, not decoration
"Safe-to-Spend", "Not counted yet", "Added to liquid BDT", "Fixed costs" are product vocabulary that builds the user's mental model of the app. Inconsistent copy (e.g., "Reserve Mode" vs "At Risk", "Expenses Deducted" vs "Fixed costs") breaks that model and undermines trust. Audit and fix copy as a first-class sprint, not as an afterthought.

### 8. UX-4 — "Fixed costs" as a label is ambiguous — verify what value it describes
The S2S calculator has two distinct deduction paths: `totalExpenses` (sum of `TransactionType.expense` outflows) and `fixedCostsDue` (sum of `FixedCostEntry` monthly costs due in 30 days). Labeling both rows "Fixed costs" in the calc trace caused a mismatch: the formula has two separate `−` rows with colliding labels. Rule: always verify what `result.fieldName` comes from before assigning a copy label. `totalExpenses` → "Cash out". `fixedCostsDue` → "Fixed costs due". These are not interchangeable.

### 10. D1 — Audit at data source level (not UI level) ensures nothing slips through
Wiring audit logging in repositories/data sources (not screens) means every write path is covered automatically, including programmatic updates. UI-level audit calls would miss repository-direct updates.

### 11. D1P — PIN hash upgraded to SHA-256 + per-setup salt (crypto:^3.0.3 approved)
Dart core has no SHA-256. `dart:convert` base64 encoding is obfuscation, not a cryptographic hash. D1P patch: `crypto: ^3.0.3` added, `PinHasher` domain class extracts `generateSalt()` + `hashPin()` + `verify()` as testable pure functions. Old base64 hashes detected via missing `pin_salt` key → cleared → force re-setup. Migration is a one-time user disruption acceptable at pre-beta stage.

### 15. D1P — authenticate() had a silent logic bug: checked isLocked (always true when awaiting auth)
Original: `if (state.isLocked) return false` — but `AuthStatus.locked` IS the normal state for a user who has set up PIN but not yet authenticated this session. This meant nobody could ever authenticate. Bug was masked because no live users existed. Fix: check `state.failedAttempts >= _maxAttempts` instead. Always test auth flows with real state machines, not just happy paths.

### 12. D1 — Buffer as absolute BDT is meaningless as income changes; percentage scales
Old `anxietyBuffer: 0.0` BDT default meant no breathing room for new users and required manual re-configuration when income changed. `bufferPercent: 15.0` (of total expected income) scales automatically with freelancer income variability.

### 13. D1 — share_plus needed for proper export UX; documents-dir fallback is technically correct but friction-heavy
CSV export saves to `getApplicationDocumentsDirectory()` which is not directly accessible from Android Files app on all devices. Approve `share_plus` before beta to enable native share sheet. TODO comment placed in `export_screen.dart`.

### 14. D1 — Parallel agents sharing the same files require explicit interface contracts up front
Auth agent and deletion agent both touch `auth_box` — worked because both were given the same Hive key contract (`pin_hash`, `pin_is_setup`). Audit agent and export agent both reference `AuditEventModel` — worked because field names were provided in the export agent prompt. Contracts must be documented before dispatch, not discovered mid-flight.

### 9. UX-4 — "Add expected payment" belongs to the income pipeline, not the expense screen
`add_transaction_screen.dart` has `TransactionType _selectedType = TransactionType.expense` hardcoded. It is a general expense outflow screen, not the income pipeline entry screen. "Add expected payment" is income pipeline language (add_income_screen). Applying income copy to an expense screen inverts the product model. Copy replacement requires reading the screen's domain, not just its title.

### 6. UX-4 — Parallel agents hit rate limits on microcopy sprints
Rate limits cut agent work mid-execution. Mitigation: dispatch agents, check what was done via git diff, then continue manually for the remainder. Do not re-dispatch fresh agents for the same files.

### 7. UX-4 — Legacy l10n keys are dead weight but not urgent
Keys like `categoryDistribution`, `spendingTrend`, `walletOverview` are unused in the new UX. They do not appear in any screen or widget. They are safe to leave for a cleanup sprint but do not need immediate deletion.

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

## UX-5 Sprint Lessons (2026-06-05)

1. **google_fonts already in pubspec** — No approval needed for Inter/JetBrains Mono/Hind Siliguri. All three available via GoogleFonts.*().
2. **Legacy API preservation** — app_theme.dart legacy AppThemeData wrapper preserved so main.dart compiles unchanged. New API: AppTheme.light/AppTheme.dark. Feature files still use AppColors.* via re-export shim. Migration to context.colors.* is per-sprint, not big-bang.
3. **Solid colors over alpha for text** — VISR-008 rule: all text tokens are solid hex (inkSecondary: #3B3A36, inkTertiary: #6A6760). Only decorative elements (rails, dots) use withValues(alpha:). Prevents contrast inconsistency on Bangladesh Android screens.
4. **Token files are non-ThemeExtension where sensible** — PocketaSpacing and PocketaMotion are plain static-constant classes. Only PocketaColors and PocketaTypography need ThemeExtension (they vary light/dark).
5. **Card borders > shadows** — All cards use 1pt divider border, elevation: 0, no BoxShadow anywhere. This is enforced at widget level.

---

## UX-1 Sprint Lessons (2026-06-05)

1. **Design system API names differ from spec** — PocketaTypography uses `headingMd/headingSm/bodyMd/bodySm/labelSm`, not `sectionHeader/bodyText/caption/microLabel`. PocketaSpacing uses `screenEdge` not `screenMargin`. PocketaMotion uses `base` not `short`, `drawerRowStagger` not `staggerDelay`. Always read actual token files before writing new widgets.
2. **Parallel agent usage-limit failure** — Phase 2 agent (dashboard integration) hit usage limit mid-task. Mitigation: dispatch Phase 1 (pure widget creation) first, then do Phase 2 integration in main thread. Never depend on a single high-cost agent for critical integration work.
3. **ShellRoute + nested Scaffold works cleanly** — `DashboardScreen` retains its own Scaffold (AppBar + FAB). Shell Scaffold provides only `bottomNavigationBar`. FAB positions relative to inner Scaffold's bottom, which sits above the bottom nav — no extra padding needed.
4. **Pass location via ShellRoute builder, not GoRouterState.of** — `_AppShell(location: state.matchedLocation)` from the `ShellRoute.builder` is cleaner than calling `GoRouterState.of(context)` inside build. Avoids context dependency and works with const widgets.
5. **Calculation failure = "—" not "0.00"** — When `safeToSpend == 0 AND totalReceivedIncomeBdt == 0`, show em-dash. Zero looks like the user has zero money; dash clearly signals "not calculated yet". This is a trust rule, not a display preference.

---

## UX-2 Sprint Lessons (2026-06-05)

1. **Auth + PIN are trust-layer scope, not UX-2 scope** — Screen 2 (Magic Link email) and Screen 7 (PIN/biometric) require infrastructure that doesn't exist in MVP. Scope them to D1 Trust Layer sprint. The onboarding still works without them — qualify → balance → costs → pattern → buffer → home is a complete 5-step flow.
2. **Buffer stored as flat BDT, not percentage** — `StsSettings.anxietyBuffer` is a flat BDT amount. Onboarding collects a percentage (5/15/25/30%). Convert at save time: `anxietyBuffer = liquidBalance × bufferPct / 100`. Don't change the domain model — just adapt at the boundary.
3. **Liquid balance has no storage before UX-2** — The S2S calculator derives `liquidCash` from `incomeEntries - transactions`. For onboarding, `liquidBalance` is a new direct user input. Store in SharedPreferences as `liquid_balance_bdt`. This is a separate concept from the pipeline-derived liquid cash.
4. **Qualifier 12s inactivity rephrase = `Timer` in `initState`** — Cancel on first interaction, show Bangla rephrase at 12s. Cancel the timer in `dispose()`. Track whether rephrase already shown (one re-ask only, per ONB-023).
5. **`NeverScrollableScrollPhysics` enforces ONB-002** — User must not be able to swipe between onboarding steps. `PageView(physics: NeverScrollableScrollPhysics())` enforces the linear commitment funnel without extra navigation guards.
6. **lakh/crore formatter needs `TextInputFormatter` + display helper** — `FilteringTextInputFormatter.digitsOnly` clears commas; `_LakhFormatter` re-applies South Asian grouping on every keystroke. South Asian format: last 3 digits + groups of 2 from right (e.g., 12,34,567).

---

## UX-3P Pipeline Interaction Polish Lessons (2026-06-05)

1. **`Dismissible` is the right swipe primitive for open-sheet-on-swipe** — `Dismissible(confirmDismiss: ... return false)` gives 60%-threshold swipe, snap-back on false return, and background reveal for free. No custom drag tracking needed. Works cleanly inside `ListView` with no scroll-axis conflict.
2. **Capture `ScaffoldMessenger` and colors before `Navigator.pop()`** — After pop, `context` is unmounted. Capture `final messenger = ScaffoldMessenger.of(context)` and `final safeColor = context.colors.stateSafe` before the pop call, then use captured refs in the snackbar.
3. **Undo uses the captured notifier, not `ref.read()` in closure** — `ref` from `ConsumerStatefulWidget` is valid inside closures but capturing `notifier = ref.read(...)` before the async boundary is cleaner and avoids any potential ref invalidation issue.
4. **Split overdue bucket at 30 days with `.where()` chaining** — `overdueBase.where(e => days >= 30)` and `overdueBase.where(e => days < 30)` is idiomatic. No extra list allocations. Each sub-list gets its own header via the same `_SectionHeader` widget.
5. **PIPE-020 enforces "swipe opens question, not answer"** — The swipe gesture opens the ConfirmReceivedSheet but never commits. This is the critical safety rule: no state change from swipe alone. `confirmDismiss: return false` is the enforcement mechanism.

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

---

## Pre-Flight Deep QA Validation Lessons (2026-05-23)

### 1. Single Source of Truth for Display Totals
**Context:** The Dashboard showed an "Income" chip and a "Safe-to-Spend" hero. The hero correctly used `safeToSpendProvider` (which sums BDT received income), but the Income chip manually iterated over transactions looking for `TransactionType.income`.
**The Mistake:** Duplicating aggregation logic in the UI layer instead of asking the domain layer for the total.
**The Fix:** The UI must extract `totalReceivedIncomeBdt` directly from the `SafeToSpendResult` object. Never manually sum transactions in a presentation widget if the domain already models that aggregate state.

---

## Phase 8f Lessons (2026-05-23)

### 1. QA preparation is separate from development
Separating real device QA preparation and validation metrics definition into its own phase ensures that the product is actually ready for user feedback, moving the focus from building to observing.

---

## Phase 9a Lessons (2026-05-23)

### 1. Cognitive simulations predict friction before users experience it
Simulating specific target personas (e.g., F-commerce Seller vs. Spreadsheet Power User) revealed that manual status updates (Pending -> Received) might be a significant friction point that disrupts the app's usefulness. Identifying this early allows us to observe this specific behavior during real human QA.

### 2. USD exclusion requires explicit UI explanation
While the logic to exclude USD from liquid BDT is correct, the simulation highlighted that users might feel this is an error or untrustworthy if not explicitly explained. The UI must proactively state *why* it's excluded to maintain trust.

---

## UX Canon Extraction & Planning Lessons (2026-06-05)

### 1. Document authority hierarchy prevents contradictory implementations
10 source docs had 7 direct contradictions (e.g., "thin accent line" vs "3pt Ledger Rail", "chronometer" vs "cashflow ledger"). Without explicit authority ranking (Final Doctrine > UX Doctrine > Visual Identity Critique > earlier docs), agents would implement whichever doc they read last. The hierarchy resolved every conflict deterministically.

### 2. Solid hex colors are mandatory for Bangladesh Android-first design
Alpha-based color tokens (e.g., `#141413 @ 60%`) render inconsistently on budget Android devices. The Visual Identity Critique explicitly converts all text/UI colors to solid hex equivalents (e.g., `#3B3A36`). This is a hardware constraint, not a style preference.

### 3. Sprint sequencing by dependency graph, not by doc order
Initial requirement said UX-1 (Dashboard) first. Analysis showed UX-5 (Design System) is a dependency for ALL other sprints. Reordering UX-5 to Sprint 1 prevents every subsequent sprint from building on wrong tokens. Always build foundation before consumers.

### 4. 81 tasks is the right granularity for 8 sprints
Each task is atomic (one file or one logical change), verifiable (`dart analyze` clean), and has explicit acceptance criteria. Vague tasks like "improve dashboard" were decomposed into 14 specific tasks. Future agents can execute any single task without reading the entire sprint.

### 5. Extracted requirements must be numbered for traceability
Every constraint (PC-001 to PC-079, UX-001 to UX-104, etc.) has a unique ID. Implementation tasks reference these IDs. When a future agent asks "why is this widget built this way?", the answer traces back to a specific numbered requirement in a specific extracted doc.

### 6. Code-to-doctrine gap analysis reveals MVP-blocking items early
8 of 33 gaps are MVP-blocking (no auth, no audit log, no export, no account deletion, wrong buffer format, missing FX fields). Discovering these during planning — not during implementation — prevents wasted sprints building on incomplete foundations.

### 7. Parallel agent extraction is effective but requires race condition awareness
6 agents writing 12 files simultaneously worked well, but Glob queries during agent execution returned partial results. Always wait for all agents to complete before verifying file counts. Agent output timing is non-deterministic.
---

## UX-3 Sprint Engineering Lessons (2026-06-05)

### 8. PocketaColors field names diverge from spec descriptions — always read the file
The implementation spec described fields as `stateCaution` and `stateNeutral`. The actual `PocketaColors` extension uses `stateTight` (amber) and `stateHope` (blue-grey). Agents who read the spec but not the actual token file produced compile-time errors. Rule: always read the live token file before using field names, never trust spec prose alone.

### 9. Manually updating Hive generated adapters is safe and necessary
`income_model.g.dart` cannot be regenerated (would overwrite custom changes). Adding nullable HiveFields (11/12/13) by hand is safe when: (1) new fields are nullable, (2) existing field indices 0-10 are untouched, (3) the `writeByte` count header is incremented from 11 to 14. Nullable migration = backwards-compatible Hive box opens.

### 10. Parallel agent parameter name mismatches require a post-agent verify pass
Agent D used `PocketaMoneySourceLabel(label: ...)` when Agent A created the widget with `source:`. Both agents completed clean in isolation but introduced a cross-file error. Fix: always run full `dart analyze` after all parallel agents complete — never trust individual agent analyzer results alone.

### 11. Calculator conservatism: fxRate=null means excluded, fxRate=value means counted
Old behavior: all USD received entries → excluded. New behavior: USD with `fxRate != null` → converts to BDT and counts in S2S; USD without fxRate → still excluded (backwards-compat). This design lets users opt-in to FX conversion per entry rather than forcing global conversion or breaking existing data.

### 12. Boolean excludeFromCalculation is simpler than an Excluded enum state
The pipeline spec mentions an `Excluded` state, but the task spec uses a boolean flag. The boolean approach is simpler: reversible with a toggle, works alongside any pipeline status, doesn't require state machine changes. The enum approach would require handling Excluded→Previous transitions. When in doubt, prefer a boolean flag over a new enum variant for reversible user preferences.

---

## D3 — Closed Beta Readiness Lessons

### 16. D3 — PIN hash mismatch across screens is a silent trust-layer failure
`delete_account_screen.dart` used `base64Encode` for PIN verification while `auth_provider.dart` stores SHA-256 hashes. The result: PIN always fails silently during deletion. Users would think they entered the wrong PIN. This pattern is dangerous because: (a) no test catches cross-screen hash algorithm consistency, (b) both algorithms produce valid-looking strings, (c) the bug only manifests in a destructive path users rarely test. Rule: any screen verifying a PIN must use `PinHasher.verify()` — never reimplement hash logic locally.

### 17. D3 — Beta readiness is a docs sprint, not a feature sprint
D3 produced 7 docs and 1 bug fix. No new features, no UI changes, no architecture modifications. This is correct. The temptation is to add "one more thing" before beta — resist it. Beta validates the hypothesis with what exists. Missing features are documented as known limitations, not rushed implementations.

---

## A1 — Internal Alpha Maturity Audit Lessons

### 18. A1 — "Screen exists" is not "screen reachable"
The audit log screen works perfectly — events are written from all financial paths, the UI renders correctly. But no UI element in the app navigates to it. A screen without a navigation path is equivalent to a screen that doesn't exist from the user's perspective. Rule: every screen must have at least one in-app navigation path. Verify reachability, not just existence.

### 19. A1 — Auth guard comments are not auth guard code
`app_router.dart` comment says "in-memory session auth is handled at screen level via authProvider" but no screen-level redirect exists in `dashboard_screen.dart`. Comments describing intended behavior that was never implemented are worse than no comments — they create false confidence. Rule: if a security-critical behavior is described in a comment, verify the implementation exists.

### 20. A1 — Design system tokens created but not migrated is worse than no design system
PocketaColors, PocketaTypography, PocketaSpacing, and PocketaMotion all exist. 13 doctrine widgets created. But STS Settings still uses legacy `AppColors`, Audit Log uses raw `Colors.green.shade600`, and 4 widgets (PocketaToast, PocketaAuditCard, PocketaCautionCard) are never used anywhere. Two visual languages in one app damages trust more than one consistent legacy design. Rule: creating a design system without migrating all screens creates visual inconsistency debt.

### 21. A1 — "CONDITIONAL GO" without a maturity audit is premature
D3 declared "CONDITIONAL GO" based on checklist compliance. A1 found 3 beta blockers that the checklist missed (audit log unreachable, auth guard gap, S2S fallback). Checklists verify what you think to check — audits find what you didn't think to check. Rule: always run a maturity audit before declaring readiness for any external milestone.

## Phase 1 Behavioral Foundation Lessons (2026-06-13)

### 22. TDD on color constants is awkward but the right call
WCAG AA contrast tests needed 3 pure-computation tests (relative luminance formula). The old values passed dart analyze but failed WCAG. Without the tests, the replacements would be subjective guesses. The luminance formula is deterministic — test it once, trust it forever. Color changes are the rare case where the test and implementation are equally trivial.

### 23. Haptic testing in Flutter widget tests is a dead end
`HapticFeedback` calls go through platform channels which aren't mockable in standard widget tests. The plan's suggestion to verify "no crash on tap" was correct — structural verification (dart analyze compilation + widget rendering) is the practical gate. Real haptic timing validation needs physical device QA. Future phases: consolidate haptics into a `HapticService` abstraction for testability.

### 24. Button mash protection needed GestureDetector over ElevatedButton
ElevatedButton.onPressed fires immediately on tap-down, preventing the scale-down animation from being visible. Switching to Material+InkWell+Container gives control over onTapDown/onTapUp timing. Trade-off: lost ThemeData-based styling inheritance. All button styling is now manual. Worth it for the 0.97 scale animation.

### 25. SharedPrefs event flags are the simplest possible deduplication
`setEventFired(key)` with `event_fired_` prefix requires zero new packages, zero migrations. Obvious, but only because the analytics service is already debugPrint-only (no persistence). When Phase 2 adds Hive-backed analytics, these flags should migrate to event log queries instead of blind SharedPrefs writes.

### 26. Onboarding skip was 1 widget but 4 integration concerns
The "Set up later" TextButton is trivial to add. What matters: (1) partial draft persistence must not crash when some fields are empty, (2) the skip must complete onboarding (set flag) so the router doesn't redirect back, (3) the skip must navigate to dashboard not welcome, (4) the progress line widget must accept a Stack parent without breaking. One widget, many contracts.

### 27. Affirmation domain logic kept pure — worth the file overhead
Creating `lib/features/dashboard/domain/affirmation.dart` (a 40-line file with no Flutter imports) felt excessive for 3 conditions. But it makes the logic testable without widget pumps, Hive, or Riverpod. 7 tests run in milliseconds. The alternative (inline in dashboard initState) would be untestable. Small domain files are never wasted.

## Onboarding + Income Pipeline Bug Fixes (2026-06-14)

### 28. Onboarding liquid balance silently disappears between SharedPrefs and Safe-to-Spend
**Bug**: User entered liquid balance during onboarding, but it never appeared in the Income pipeline dashboard or Safe-to-Spend calculation.
**Root Cause**: Onboarding stored `liquidBalanceBdt` in `SharedPrefServices` but the S2S calculator and pipeline read from Hive (`incomeNotifierProvider`). Two separate data systems with no bridge.
**Fix**: In `_completeOnboarding()`, auto-create an `IncomeEntryEntity` with `status: received` and `receivedDate: now` when `_draft.liquidBalanceBdt > 0`. This converts the onboarding input into a pipeline entry that both the S2S calculator and dashboard can see.
**Lesson**: A user-entered value that isn't persisted to the same storage layer as the consuming system will silently disappear. Always trace the data flow from input → storage → consumption.

### 29. AddIncomeScreen provider timing issue in edit mode
**Bug**: `ref.read(incomeNotifierProvider)` in `initState()` could return an empty list if the provider hadn't finished loading yet.
**Root Cause**: `initState()` runs synchronously before any async initialization completes. Provider state may not be ready.
**Fix**: Defer the provider read to `addPostFrameCallback()` to ensure state is loaded before accessing.
**Lesson**: Never call `ref.read()` inside `initState()` for state that may not be initialized yet. Use post-frame callbacks for deferred reads in edit modes.

### 30. FX rate field missing validation for USD entries
**Bug**: USD entries could be saved with empty or invalid FX rates, causing silent exclusion from S2S calculations.
**Fix**: Added required validator for FX rate when currency is USD, requiring positive numbers.
**Additional fix**: Clear FX rate controller when switching from USD to BDT to prevent stale data submission.

### 31. Project name made optional to match onboarding UX
**Bug**: AddIncomeScreen required project name but FirstPipelinePage allowed empty project names, creating inconsistent UX.
**Fix**: Removed required validator, changed label to "Project Name (recommended)" to align with onboarding patterns.

### 32. PopScope needed for reliable back navigation
**Bug**: Back button using `context.pop()` could fail in edge cases with GoRouter (navigation context invalid, route stack edge cases, iOS swipe conflicts).
**Fix**: Wrapped AddIncomeScreen in `PopScope` with `canPop: true` and `onPopInvokedWithResult` fallback for robustness.
**Lesson**: For modal routes and screens that need reliable back navigation, always wrap in `PopScope` rather than relying solely on `IconButton.context.pop()`.
