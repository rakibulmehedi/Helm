# Phase 7 — Execution Plan

> Type: Implementation Governance
> Status: APPROVED — GOVERNS PHASE 7 IMPLEMENTATION
> Created: 2026-05-22
> Spec Source: docs/specs/PHASE_7_FREELANCER_INCOME_TRACKING.md + docs/specs/INCOME_PIPELINE_MVP.md

---

## Goal

Implement Income Pipeline (Phase 7) incrementally and safely. A freelancer must be able to track Expected → Pending → Received payments and view a dashboard summary of their income pipeline — without breaking any existing system.

---

## Current System Context

| System | Status | Phase 7 Touch |
|--------|--------|---------------|
| Transaction CRUD | Stable, Frozen | NONE |
| Dashboard (`DashboardScreen`) | Stable | ADD income section only |
| Routing (`app_router.dart`) | Frozen | ADD 3 new routes only |
| Hive architecture | Frozen | ADD new box + adapter only |
| `app_box_names.dart` | Stable | ADD `incomeBox` constant |
| `hive_service.dart` | Stable | ADD adapter registration |
| Localization ARB files | Frozen | ADD new keys only |
| `transactionsProvider` | Frozen | NONE |
| Onboarding / Splash | Frozen | NONE |

---

## Implementation Philosophy

1. **Additive, never destructive.** Income is a new feature module. Existing systems are untouched except at defined integration points.
2. **Spec-first.** No implementation decision is made outside the spec. If spec is silent — ask Chief Architect, do not guess.
3. **Incremental delivery.** Each sub-phase must be independently analyzer-clean before the next begins.
4. **Offline-first by default.** All income data is Hive-persisted. No network calls. No loading spinners that depend on internet.
5. **UX preservation.** Dashboard must not become cluttered. Income section is additive and subordinate to existing transaction summary.
6. **Zero architectural mutation.** PHASE_7_FILE_MAP.md is the authority on what gets created and where.

---

## Recommended Incremental Phases

### Phase 7a — Income Data Layer

Goal: Income data model, Hive persistence, and repository — fully testable without UI.

Deliverables:
- `IncomeStatus` enum (in domain entity file)
- `IncomeEntryEntity` (pure Dart, no framework imports)
- `IncomeModel` (HiveObject, `@HiveType(typeId: 2)`)
- `IncomeModelAdapter` (generated via `build_runner`)
- `IncomeLocalDataSource` (abstract interface + Hive implementation)
- `IncomeRepository` (abstract class)
- `IncomeRepositoryImpl` (concrete implementation)
- `AppBoxNames.incomeBox` constant added to `core/constants/app_box_names.dart`
- Adapter + box registered in `core/local_storage/hive_service.dart`

Quality gate: `dart analyze` 0/0/0. No UI changes. Existing transaction/dashboard/routing untouched.

---

### Phase 7b — Income Entry UI

Goal: Create and edit income entry forms.

Deliverables:
- `IncomeNotifier` (StateNotifier)
- `incomeDataSourceProvider`, `incomeRepositoryProvider`, `incomeNotifierProvider`
- `AddIncomeScreen` at `/add-income`
- `EditIncomeScreen` at `/edit-income/:id` (may be unified with add screen in create/edit mode)
- Form fields: clientName, projectName, amount, currency toggle (BDT/USD), expectedDate picker, notes (optional)
- Per-field validation with error messages
- On save: navigate back + success SnackBar
- Double-submit guard (disable button after first tap until operation completes)
- `mounted` guard on all post-async navigation

Quality gate: `dart analyze` 0/0/0. User can add income entry. Entry persists across app restarts.

---

### Phase 7c — Income List & Filtering

Goal: Income list view with tab-based status filtering.

Deliverables:
- `IncomeListScreen` at `/income`
- Tab bar: All | Expected | Pending | Received
- `IncomeCard` widget: client name, project name, amount + currency, status badge, expected/received date
- `IncomeStatusBadge` widget (grey/blue/green — NO red)
- Swipe-to-delete + undo SnackBar ("Income entry deleted" + "Undo")
- Per-tab empty states (reassuring copy — see spec section 5)
- Sorting: by `expectedDate`, newest first within each status group

Quality gate: `dart analyze` 0/0/0. Full CRUD accessible. Existing transaction list untouched.

---

### Phase 7d — Dashboard Integration

Goal: Add Income Pipeline Summary section to existing dashboard.

Deliverables:
- `IncomePipelineSummary` widget (three summary cards: Expected, Pending, Received)
- Widget added BELOW existing transaction summary in `DashboardScreen`
- Received card visually most prominent; Expected least prominent
- Amounts formatted with `NumberFormat` + currency symbol
- Tap on card navigates to filtered income list (`/income?filter=expected|pending|received`)
- Empty state if all three values are zero
- Reactive to `incomeNotifierProvider`

CRITICAL: Do NOT modify existing transaction summary cards. Only INSERT below them.

Quality gate: `dart analyze` 0/0/0. Existing dashboard behavior completely unchanged. Income section responds reactively to Hive writes.

---

### Phase 7e — Status Transitions

Goal: One-tap status progression from income list card.

Deliverables:
- Quick-action button on `IncomeCard`: "Mark Pending" / "Mark Received"
- Forward transitions: Expected → Pending, Pending → Received (always allowed)
- Skip transition: Expected → Received allowed (cash payment scenario)
- Backward transition: Pending → Expected allowed (failed transfer scenario)
- Received → backward: NOT allowed via status button (edit screen only; delete + recreate if truly needed)
- When marking Received: `receivedDate` auto-set to `DateTime.now()` (user can override via edit screen)
- Status badge updates reactively in list and dashboard

Quality gate: `dart analyze` 0/0/0. Full status lifecycle works. All transition edge cases manually verified.

---

## Dependency Order

```
7a — Income Data Layer
     └── 7b — Income Entry UI         (depends on: entities, providers from 7a)
          └── 7c — List & Filtering   (depends on: screens from 7b, notifier from 7a)
               └── 7d — Dashboard     (depends on: providers from 7a, list navigation from 7c)
                    └── 7e — Status   (depends on: list from 7c, notifier from 7a)
```

Do NOT start a sub-phase before its dependency is analyzer-clean and manually verified.

---

## Frozen Systems

| System | Allowed Touch | Forbidden |
|--------|--------------|-----------|
| `features/transactions/` — any file | NONE | Any modification |
| `DashboardScreen` | Add `IncomePipelineSummary()` widget below existing summary | Modify existing cards, reorder, change layout structure |
| `config/router/app_router.dart` | ADD 3 new GoRoute entries | Restructure existing routes |
| `config/router/route_names.dart` | ADD 3 new constants | Rename existing constants |
| `core/constants/app_box_names.dart` | ADD `incomeBox` | Rename/remove existing constants |
| `core/local_storage/hive_service.dart` | ADD adapter + box registration at end | Change existing registration order |
| `l10n/*.arb` | ADD new keys | Modify/remove existing keys |
| `transactionsProvider` | NONE | Any modification |
| `TransactionModel` | NONE | Any field/typeId modification |

---

## UX Preservation Rules

1. Dashboard must not feel cluttered after 7d. If it does — stop and escalate to Chief Architect.
2. No red color for Expected or Pending states. Use soft grey and soft blue from `AppColors`.
3. No scolding language. Use "still waiting" not "overdue". Use "Expected by [date]" not "late".
4. Status transitions must be max 1 tap from the income list card.
5. Delete must show undo SnackBar — consistent with existing transaction delete pattern.
6. Empty states must be reassuring and include a clear next action.
7. Fast entry: adding an income entry must take < 15 seconds.
8. Progressive disclosure: summary on dashboard → details on tap → edit on tap.

---

## Architecture Preservation Rules

1. Follow feature-first structure exactly as defined in PHASE_7_FILE_MAP.md.
2. Domain entities (`income_entry_entity.dart`) have zero framework imports — pure Dart only.
3. Presentation never imports from `data/` directly. Wire through Riverpod providers.
4. All colors via `AppColors` — no raw hex anywhere.
5. Use `withValues(alpha: x)` — NEVER `withOpacity(x)`.
6. Use `IdGenerator.uniqueId()` for all income entry IDs — never manual ID generation.
7. All files under 300 lines. Extract sub-widgets when `build()` exceeds 100 lines.
8. Use package imports: `package:helm_v2/...` — no relative imports.
9. Income feature is fully isolated from transaction feature — no cross-feature dependencies.

---

## Quality Gates

Each sub-phase must pass all gates before the next begins:

| Gate | Requirement |
|------|-------------|
| Analyzer | `dart analyze` → 0 errors, 0 warnings, 0 infos |
| Regression — transactions | Existing transaction CRUD works end-to-end |
| Regression — dashboard | Existing dashboard renders and summarizes correctly |
| Regression — routing | Existing routes work (onboarding, splash, transactions) |
| Persistence | Income entries survive app hot restart |
| Offline | Feature works with airplane mode enabled |
| File size | No file over 300 lines |
| No future scope | No Phase 8+ logic (Safe-to-Spend, Virtual Wallets, sync) introduced |
| No banned patterns | No raw hex, no `withOpacity`, no `ChangeNotifier`, no direct Hive calls from UI |

---

## Rollback Strategy

**If a frozen system is mutated:**
1. Stop immediately — do NOT push forward.
2. `git diff` to identify the mutation.
3. Revert only the mutation, not the entire sub-phase.
4. Re-run `dart analyze`.
5. Report to Chief Architect before continuing.

**If dashboard becomes visually cluttered after 7d:**
1. Stop — do NOT add more UI elements.
2. Simplify income section — reduce visual weight, fewer cards, smaller typography.
3. Get Chief Architect approval before shipping.

**If analyzer shows warnings from generated files:**
1. Re-run `dart run build_runner build --delete-conflicting-outputs`.
2. Do NOT manually edit `.g.dart` files.

---

## Final Validation Requirements

Before Phase 7 is marked complete, all of the following must be true:

1. All items in `docs/implementation/PHASE_7_ACCEPTANCE_CHECKLIST.md` are checked.
2. `dart analyze` → 0/0/0.
3. Existing transaction flows work end-to-end (add, edit, delete, undo, dashboard summary).
4. Income CRUD works end-to-end (add, edit, delete, undo, list, filter).
5. Dashboard shows income summary reactively (data added → summary updates without restart).
6. All status transitions work: Expected→Pending, Pending→Received, Expected→Received, Pending→Expected.
7. Received→backward NOT possible via status button.
8. No Phase 8+ code present anywhere in `lib/features/income/`.
9. Completion report delivered to Chief Architect per `docs/governance/AGENT_WORKFLOW.md` format.
