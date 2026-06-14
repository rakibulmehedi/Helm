# Phase 7 — Implementation Risks

> Type: Implementation Governance
> Status: ACTIVE — Read before coding begins
> Created: 2026-05-22
> Scope: Phase 7 Income Pipeline implementation risks

---

## Risk Registry

---

### R1 — Dashboard Clutter

**Description:** Adding an Income Pipeline Summary section below the existing transaction summary may make the dashboard feel dense, overwhelming, or visually cluttered — degrading the "calm, reassuring" UX that is core to Helm's identity.

**Likelihood:** High (dashboard already has summary cards; adding more is additive risk)

**Impact:** Critical — dashboard is the primary screen; clutter breaks product promise

**Prevention:**
- Income summary is subordinate to transaction summary — use lighter visual weight
- Show Received as most prominent, Expected as least prominent (hierarchy reduces noise)
- Use conditional display: if all income values are zero, show a compact "Start tracking income" prompt instead of three zero cards
- Keep income section collapsible or compact in v1
- Do NOT add charts, progress bars, or animation to income summary in Phase 7

**Recovery:**
- If dashboard feels cluttered after 7d: stop. Simplify income section before shipping.
- Reduce card count, font size, or visual weight
- Move income section below fold (scrollable) if needed
- Escalate to Chief Architect before shipping cluttered dashboard

---

### R2 — Accounting Complexity Creep

**Description:** Pressure to add sub-states (escrow, in-transit, cleared), partial payments, or currency conversion logic within Phase 7 under the guise of "completeness."

**Likelihood:** Medium (spec explicitly excludes these; agent may rationalize additions)

**Impact:** High — violates MVP scope, increases model complexity, creates Phase 8 debt

**Prevention:**
- Three states only: Expected, Pending, Received. No sub-states.
- Currency field is display-only string ("BDT" or "USD") — no conversion math
- `amount` stores raw value — no exchange rate, no fee deduction
- If a use case requires sub-states: add to DECISION_LOG as a future consideration and stop

**Recovery:**
- Delete any sub-state code immediately — do not ship it
- Revert to three-state model
- Log the use case in `docs/tracking/LESSONS.md` for future phase consideration

---

### R3 — Provider Duplication / Spaghetti

**Description:** Income providers accidentally placed in wrong files (transaction provider file, app-level providers) OR income notifier accidentally watching transaction providers, creating invisible coupling.

**Likelihood:** Medium (easy mistake when in a rush)

**Impact:** High — creates fragile cross-feature dependencies, breaks frozen transaction system

**Prevention:**
- ALL income providers live exclusively in `lib/features/income/presentation/providers/income_providers.dart`
- No income provider `ref.watch`es any transaction provider and vice versa
- No income provider placed in `application/providers/` or any shared location
- Follow PHASE_7_FILE_MAP.md exactly

**Recovery:**
- Move misplaced providers to correct file
- Remove cross-feature `ref.watch` calls
- Re-run `dart analyze` to catch import violations

---

### R4 — Transaction/Income Domain Merge

**Description:** An agent creates a shared `FinancialEntry` base class, stores income in the transaction box, or adds income fields to `TransactionEntity` — collapsing the two separate domains into one.

**Likelihood:** Low-Medium (may seem like "code reuse" but is architectural violation)

**Impact:** Critical — destroys feature isolation, corrupts Hive data, makes Phase 8 impossible to build cleanly

**Prevention:**
- Separate Hive boxes: `transactionBox` (typeId: 0) and `incomeBox` (typeId: 2)
- Separate entity classes: `TransactionEntity` and `IncomeEntryEntity`
- Separate repository abstractions and implementations
- No shared base class between Transaction and Income domain models
- PHASE_7_FILE_MAP.md Feature Boundary Enforcement table is the authority

**Recovery:**
- Immediately separate the merged model back into two distinct entities
- Migrate any data written to wrong box
- Re-run `dart analyze` and verify no cross-feature imports remain

---

### R5 — Emotional UX Degradation

**Description:** Income entries displayed with red color, "overdue" language, alarming copy, or dense data presentation — triggering anxiety instead of reducing it.

**Likelihood:** Medium (default UI patterns tend toward alerts for "overdue" items)

**Impact:** High — violates core product identity ("reduces stress, not adds it")

**Prevention:**
- `IncomeStatusBadge`: grey (expected), blue or amber (pending), green (received). NO red.
- Copy rules: "still waiting" not "overdue"; "Expected by [date]" not "late"; "All payments received" not "Nothing pending"
- Empty states must be reassuring and include a clear action
- No exclamation marks, no warning icons for normal income states
- Review all SnackBar copy, empty state copy, and badge labels against UX rules before shipping

**Recovery:**
- Replace any red color with AppColors-sanctioned alternatives
- Replace alarming copy with neutral/reassuring alternatives
- Review spec section 6 (UX Rules) line by line before shipping 7c

---

### R6 — Over-Engineering

**Description:** Agent adds usecase classes, mapper classes, event/state sealed classes, or other enterprise patterns beyond what the spec requires — increasing complexity without adding user value.

**Likelihood:** Medium-High (agents often default to "clean architecture maximum")

**Impact:** Medium — increases file count, cognitive load, maintenance burden without MVP benefit

**Prevention:**
- No use case classes for Phase 7 (repository + notifier is sufficient)
- No event/state sealed classes (StateNotifier with List<IncomeEntryEntity> is sufficient)
- No mapper utility classes (model.toEntity() and fromEntity() on the model class are sufficient)
- No abstract factory pattern for data sources
- Match the existing transaction feature's pattern — no more complex than that

**Recovery:**
- Delete over-engineered classes
- Inline the logic into repository or notifier
- Verify file count matches PHASE_7_FILE_MAP.md

---

### R7 — Future Sync Risk (Phase 8+ Contamination)

**Description:** Agent adds `syncStatus` fields, `isLocal`/`isSynced` flags, Supabase imports, or cloud-readiness scaffolding to the income model "for the future."

**Likelihood:** Low-Medium (spec explicitly excludes sync; agent may try to be "helpful")

**Impact:** High — introduces unreviewed architecture, adds fields to Hive model that cannot easily be removed later, complicates Phase 8 planning

**Prevention:**
- `IncomeModel` fields are exactly as specified in spec — no extra fields
- No Supabase, Dio, http, or network imports anywhere in `features/income/`
- No `syncStatus`, `serverId`, `isSynced`, or `isDirty` fields
- Offline-first means Hive only — no sync scaffolding until explicitly designed

**Recovery:**
- Remove extra fields from `IncomeModel` (requires migration if already written to Hive)
- Delete any network imports
- Log the sync architecture need in `docs/tracking/DECISION_LOG.md` for future phase

---

### R8 — Offline-First Breakage

**Description:** Income feature accidentally introduces async loading states that depend on network, or Hive initialization fails silently, making income data unavailable offline.

**Likelihood:** Low (existing Hive pattern is established; risk is in deviating from it)

**Impact:** High — core product promise is offline-first

**Prevention:**
- Follow existing Hive initialization pattern in `hive_service.dart` exactly
- `incomeBox` must be opened before any provider that reads it initializes
- No `FutureProvider` that depends on network for income data
- Test manually in airplane mode after each sub-phase

**Recovery:**
- Fix initialization order in `hive_service.dart`
- Remove any network-dependent loading states from income feature

---

### R9 — State Explosion

**Description:** Income feature creates separate filter providers, sort providers, search providers, pagination providers, and loading/error state providers — causing a combinatorial explosion of Riverpod state.

**Likelihood:** Medium (temptation to make filtering "reactive" via separate providers)

**Impact:** Medium — increases complexity, harder to debug, harder for future agents to understand

**Prevention:**
- Single `incomeNotifierProvider` holds the list
- Filtering (Expected/Pending/Received tab) is computed locally in the widget using `.where()` on the list — NOT a separate provider
- Sort is computed locally in the widget — NOT a separate provider
- No separate loading/error providers in Phase 7 (handle errors inline in notifier)

**Recovery:**
- Collapse multiple state providers back into single notifier
- Move filter/sort logic to presentation layer (widget) as pure functions

---

### R10 — Status Confusion / Backward Transition Bugs

**Description:** Status transitions not enforced correctly — agent allows Received → Expected via status button, or allows multi-hop backward transitions, or fails to set `receivedDate` when marking Received.

**Likelihood:** Medium (transition matrix is non-trivial)

**Impact:** Medium — data integrity issues, confusing UX for user

**Prevention:**
- Implement transitions as an explicit matrix in `IncomeNotifier`:
  - Expected → Pending: allowed
  - Expected → Received: allowed (skip)
  - Pending → Received: allowed
  - Pending → Expected: allowed (reverse)
  - Received → anything: NOT allowed via quick-action button
- When marking Received: auto-set `receivedDate = DateTime.now()` (user can override via edit screen)
- `IncomeCard` quick-action button only shown for Expected and Pending states; Received cards have no quick-action
- Full status control (including Received → anything) only in edit screen — by direct status field change

**Recovery:**
- Add transition guard in notifier's `updateStatus` method
- Remove quick-action button from Received cards
- Add `receivedDate` auto-population to Received transition

---

## Anti-Pattern Watchlist

Monitor for these during code review of each sub-phase:

| Anti-Pattern | Where It Appears | Why It's Wrong |
|--------------|-----------------|----------------|
| Raw hex color in widget | `income_card.dart`, `income_status_badge.dart` | Violates `AppColors` rule |
| `withOpacity()` | Any widget file | Deprecated — use `withValues(alpha:)` |
| `BuildContext` used after `await` without `mounted` check | `add_income_screen.dart`, `edit_income_screen.dart` | Crash risk |
| Direct `Hive.box()` call in widget or screen | Any view file | Bypasses repository — forbidden |
| `ChangeNotifier` in income feature | Any provider file | Use Riverpod `StateNotifier` |
| Income entries in `transactionBox` | Data source implementation | Wrong box — data corruption |
| `IncomeModel` with typeId other than 2 | `income_model.dart` | typeId collision |
| Future-phase logic (Safe-to-Spend calc) | Any income file | Scope creep |
| Merged `FinancialEntry` base class | Domain layer | Destroys feature isolation |
| Red color for pending/expected | Status badge | Emotional UX violation |
| "Overdue" copy | Empty states, cards | Scolding language — forbidden |
| File over 300 lines | Any file | Extract sub-widgets |
| Cross-feature import | Income importing from transactions | Forbidden coupling |
| Relative imports | Any file | Use package imports |

---

## Escalation Triggers

Stop implementation and report to Chief Architect when:

1. A required file (per PHASE_7_FILE_MAP.md) does not fit within 300 lines — need approval to split differently.
2. A spec requirement conflicts with an architecture rule — do not resolve unilaterally.
3. Dashboard feels cluttered after 7d — do not ship without approval.
4. A use case requires a 4th income status — do not add without approval.
5. Hive typeId conflict detected — stop immediately, do not assign a new one without approval.
6. A sub-phase breaks any frozen system — stop, revert mutation, report.
7. Analyzer shows issues that cannot be resolved without modifying a frozen file — report.

---

## Signs Phase 7 Is Going Wrong

Immediately stop and reassess if any of the following appear:

- `features/transactions/` has been modified
- `IncomeModel` has more than 11 HiveFields
- A shared `FinancialEntry` or `BasePayment` class exists anywhere
- Dashboard has more than 2 additional widgets beyond the income section
- Income providers live in `application/providers/`
- `income_providers.dart` has a `ref.watch(transactionsProvider)` call
- Any file in `lib/features/income/` imports from `lib/features/transactions/`
- Any income screen imports Hive directly (bypassing repository)
- `IncomeStatus` has more than 3 values
- Safe-to-Spend calculation logic exists in Phase 7 code
- Currency conversion math exists anywhere in `lib/features/income/`
- `dart analyze` is returning errors and the response is to add `// ignore:` suppressions
