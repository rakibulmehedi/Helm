# Income List Consolidation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove the superseded `IncomeListScreen` and its orphaned entry widget so the Pipeline tab is the single income view, with zero user-facing behaviour change.

**Architecture:** Pure deletion/consolidation. `PipelineScreen` already "Replaces IncomeListScreen" and reads the same `incomeNotifierProvider`. We remove the dead screen, its only (orphaned) caller `IncomePipelineSummary`, the `/income` route, `RouteNames.income`, and 15 now-orphaned l10n strings.

**Tech Stack:** Flutter (Dart), Riverpod, GoRouter, Flutter gen-l10n (ARB), Hive (untouched here).

## Testing philosophy for this plan

This is **dead-code removal**, so classic red-green TDD (write failing test → add behaviour) does not apply to most steps — there is no new behaviour to drive. The discipline used here is:

1. **Regression gate.** Establish a green baseline, then prove `fvm dart analyze` (0/0/0) and the full `fvm flutter test` suite stay green after every atomic removal. A red gate means a missed reference — stop and fix before continuing.
2. **One genuine red-green guard test** (Task 2) that asserts `/income` no longer resolves in the router. It fails while the route exists (RED) and passes after removal (GREEN), and stays as a permanent regression guard against re-introduction.

## Global Constraints

- Analyzer must be **0 errors / 0 warnings / 0 infos** after every task. (CLAUDE.md)
- Use `fvm dart` / `fvm flutter` for all commands. (CLAUDE.md)
- No new packages. No business-logic, persistence, or `PipelineScreen` behaviour changes. (spec Non-Goals)
- Commit convention: `type(scope): description`. Types: feat, fix, refactor, docs, chore, style. (CLAUDE.md)
- Files under 300 lines. (CLAUDE.md)
- Currency glyphs only via `NumberFormatter` — N/A here but do not introduce any. (Decision 037)

## File structure (blast radius)

- **Delete:** `lib/features/income/presentation/views/income_list_screen.dart` (757 lines; carries the `IncomeFilter` enum — zero other usages)
- **Delete:** `lib/features/income/presentation/widgets/income_pipeline_summary.dart` (orphaned)
- **Modify:** `lib/config/router/app_router.dart` (remove `/income` `GoRoute` block at lines ~111–123 + `IncomeListScreen` import)
- **Modify:** `lib/config/router/route_names.dart` (remove `static const String income = '/income';`, line 25)
- **Modify:** `lib/l10n/app_en.arb`, `lib/l10n/app_bn.arb` (remove 15 keys + regenerate)
- **Create:** `test/config/router/income_route_removed_test.dart` (permanent guard)
- **Modify:** `docs/tracking/DECISION_LOG.md`, `docs/tracking/PROJECT_STATE.md`, `docs/tracking/TASKS.md`

## Subagent dispatch guidance (honest assessment)

Sub-project A is **small and sequential with a shared analyzer/test gate**, and the tasks are interdependent (the route removal in Task 2 depends on Task 1 having removed the only other `RouteNames.income` reference; Task 3 depends on the files being gone). Per the dispatching-parallel-agents skill, parallel dispatch is **not appropriate here** — agents would contend on the same files and gates with no time saved.

Recommended execution: **subagent-driven-development**, one fresh subagent per task, reviewed between tasks (sequential). The genuine parallelism opportunity is **Sub-project B** (the History/audit tab), not A. The only parallel-friendly slice in A is an optional independent final-verification pass (a subagent that re-runs analyze + full suite + greps for any lingering references) after Task 4 — useful but not required.

---

### Task 1: Delete the orphaned `IncomePipelineSummary` widget

**Files:**
- Delete: `lib/features/income/presentation/widgets/income_pipeline_summary.dart`

**Interfaces:**
- Consumes: nothing.
- Produces: nothing. After this task, the only remaining references to `RouteNames.income` and `IncomeListScreen` live in `lib/config/router/app_router.dart` (removed in Task 2).

- [ ] **Step 1: Establish the green baseline**

Run:
```bash
fvm dart analyze
fvm flutter test
```
Expected: analyze reports `No issues found!`; test suite passes (this is the baseline — record the pass count).

- [ ] **Step 2: Confirm the widget is orphaned**

Run:
```bash
grep -rn "IncomePipelineSummary\|income_pipeline_summary" lib/ test/ | grep -v "income_pipeline_summary.dart:"
```
Expected: **no output** (no importer, no test). If anything prints, STOP — it is not orphaned; reassess.

- [ ] **Step 3: Delete the file**

Run:
```bash
git rm lib/features/income/presentation/widgets/income_pipeline_summary.dart
```

- [ ] **Step 4: Verify analyzer stays clean**

Run: `fvm dart analyze`
Expected: `No issues found!` (the file had no importers, so nothing breaks).

- [ ] **Step 5: Verify the suite stays green**

Run: `fvm flutter test`
Expected: same pass count as the baseline in Step 1.

- [ ] **Step 6: Commit**

```bash
git commit -m "refactor(income): remove orphaned IncomePipelineSummary widget"
```

---

### Task 2: Remove the `/income` route, `IncomeListScreen`, and `RouteNames.income` (red-green)

**Files:**
- Create: `test/config/router/income_route_removed_test.dart`
- Modify: `lib/config/router/app_router.dart` (remove the `/income` `GoRoute` block, lines ~111–123, and the `IncomeListScreen` import)
- Modify: `lib/config/router/route_names.dart` (remove `static const String income = '/income';`)
- Delete: `lib/features/income/presentation/views/income_list_screen.dart`

**Interfaces:**
- Consumes: `appRouter` from `package:helm/config/router/app_router.dart`; `RouteConfiguration.routes` (`List<RouteBase>`), `GoRoute.path`, `GoRoute.name`, `RouteBase.routes` from `package:go_router/go_router.dart`.
- Produces: a permanent test asserting no route with path `/income` or name `income` exists in `appRouter.configuration`.

- [ ] **Step 1: Write the failing guard test**

Create `test/config/router/income_route_removed_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:helm/config/router/app_router.dart' show appRouter;

/// Flattens the router tree (GoRoute + ShellRoute children) into GoRoutes.
List<GoRoute> _allGoRoutes(List<RouteBase> routes) {
  final result = <GoRoute>[];
  for (final r in routes) {
    if (r is GoRoute) result.add(r);
    result.addAll(_allGoRoutes(r.routes));
  }
  return result;
}

void main() {
  test('the /income route is fully removed (consolidated into Pipeline)', () {
    final goRoutes = _allGoRoutes(appRouter.configuration.routes);
    final paths = goRoutes.map((r) => r.path).toList();
    final names = goRoutes.map((r) => r.name).whereType<String>().toList();

    expect(paths, isNot(contains('/income')),
        reason: 'IncomeListScreen was consolidated into PipelineScreen.');
    expect(names, isNot(contains('income')),
        reason: 'The /income GoRoute name must be gone.');
  });
}
```

- [ ] **Step 2: Run the guard test to verify it FAILS**

Run: `fvm flutter test test/config/router/income_route_removed_test.dart`
Expected: **FAIL** — `/income` is still registered, so `contains('/income')` is true.

- [ ] **Step 3: Remove the `/income` route + import from the router**

In `lib/config/router/app_router.dart`:
- Delete the entire `GoRoute` block for `RouteNames.income` (the `name: 'income'` builder that returns `IncomeListScreen(initialFilter: safeFilter)`, lines ~111–123).
- Delete the `IncomeListScreen` import line (`import '.../income_list_screen.dart';`).

- [ ] **Step 4: Delete the screen file**

Run:
```bash
git rm lib/features/income/presentation/views/income_list_screen.dart
```

- [ ] **Step 5: Remove the route name constant**

In `lib/config/router/route_names.dart`, delete the line:
```dart
static const String income = '/income';
```
(Keep `addIncome` and `editIncome` — those are live.)

- [ ] **Step 6: Run the guard test to verify it PASSES, then the full gate**

Run:
```bash
fvm flutter test test/config/router/income_route_removed_test.dart
fvm dart analyze
fvm flutter test
```
Expected: guard test PASS; analyze `No issues found!`; full suite green (baseline pass count **+1** new guard test). If analyze reports an undefined `RouteNames.income` or unused import, a reference was missed — fix before committing.

- [ ] **Step 7: Commit**

```bash
git add -A
git commit -m "refactor(income): remove superseded /income route and IncomeListScreen"
```

---

### Task 3: Remove the 15 orphaned l10n strings and regenerate

**Files:**
- Modify: `lib/l10n/app_en.arb` (remove 15 value entries + their `@`-metadata)
- Modify: `lib/l10n/app_bn.arb` (remove the 15 value entries)
- Regenerated (committed): `lib/l10n/app_localizations*.dart`

**Interfaces:**
- Consumes: nothing.
- Produces: nothing — these keys have zero remaining references after Tasks 1–2.

- [ ] **Step 1: Confirm the keys are now orphaned**

Run:
```bash
for k in addFirstExpectedPayment addOneForNewProject filterAll incomeByDate \
  incomeEntryCount incomePipeline incomeReceivedDate noExpectedPayments \
  noPaymentsInTransit noPaymentsInTransitNow noPaymentsReceivedThisMonth \
  noReceivedPaymentsYet nothingHere trackIncomePipeline useButtonToAdd; do
  echo "$k: $(grep -rl "\.$k\b" lib/ | grep -vE 'app_localization|/l10n/' | wc -l | tr -d ' ') live refs"
done
```
Expected: every key shows `0 live refs`. If any is non-zero, STOP and exclude that key.

- [ ] **Step 2: Remove the keys from `lib/l10n/app_en.arb`**

Delete both the value line and the matching `@`-metadata for each of the 15 keys. Simple (single-line) pairs to remove, e.g.:
```json
"incomePipeline": "Income Pipeline",
"@incomePipeline": { "description": "Income list screen app bar title" },
"filterAll": "All",
"@filterAll": { "description": "Income list filter chip: all" },
"trackIncomePipeline": "Track your income pipeline",
"@trackIncomePipeline": { "description": "Income list first-time empty state title" },
"addFirstExpectedPayment": "Add your first expected payment to see\nwhen money is coming in.",
"@addFirstExpectedPayment": { "description": "Income list first-time empty state body" },
"noExpectedPayments": "No expected payments",
"@noExpectedPayments": { "description": "Income list filter empty: expected" },
"noPaymentsInTransit": "No payments in transit",
"@noPaymentsInTransit": { "description": "Income list filter empty: pending" },
"noReceivedPaymentsYet": "No received payments yet",
"@noReceivedPaymentsYet": { "description": "Income list filter empty: received" },
"nothingHere": "Nothing here",
"@nothingHere": { "description": "Income list filter empty: all" },
"addOneForNewProject": "Add one when you start a new project.",
"@addOneForNewProject": { "description": "Empty state subtitle: expected" },
"noPaymentsInTransitNow": "No payments in transit right now.",
"@noPaymentsInTransitNow": { "description": "Empty state subtitle: pending" },
"noPaymentsReceivedThisMonth": "No payments received this month yet.",
"@noPaymentsReceivedThisMonth": { "description": "Empty state subtitle: received" },
"useButtonToAdd": "Use the + button to add an income entry.",
"@useButtonToAdd": { "description": "Empty state subtitle: all" },
```
The three remaining keys are **plural/placeholder** entries with multi-line `@`-blocks — remove the value line AND the full `@`-block (from `"@key": {` through its closing `},`):
```json
"incomeEntryCount": "{count, plural, =1{1 entry} other{{count} entries}}",
"@incomeEntryCount": { ...full block... },
"incomeByDate": "By {date}",
"@incomeByDate": { ...full block... },
"incomeReceivedDate": "Received {date}",
"@incomeReceivedDate": { ...full block... },
```
After editing, ensure the file is still valid JSON (no trailing comma before a closing `}`).

- [ ] **Step 3: Remove the same 15 keys from `lib/l10n/app_bn.arb`**

Delete the Bangla value line for each of the 15 keys (the `.arb` translations file typically has no `@`-metadata — remove only the `"key": "…",` lines). Keep the JSON valid (watch trailing commas).

- [ ] **Step 4: Validate JSON and regenerate localizations**

Run:
```bash
python3 -c "import json; json.load(open('lib/l10n/app_en.arb')); json.load(open('lib/l10n/app_bn.arb')); print('ARB OK')"
fvm flutter gen-l10n
```
Expected: `ARB OK`, then gen-l10n completes without error and the generated `app_localizations*.dart` no longer declare the 15 getters.

- [ ] **Step 5: Run the full gate**

Run:
```bash
fvm dart analyze
fvm flutter test
```
Expected: analyze `No issues found!`; suite green (same count as end of Task 2). A reference to a removed getter would surface here as an analyzer error.

- [ ] **Step 6: Commit**

```bash
git add lib/l10n/
git commit -m "chore(l10n): remove 15 orphaned income-list strings"
```

---

### Task 4: Record the decision and update tracking docs

**Files:**
- Modify: `docs/tracking/DECISION_LOG.md` (append Decision 040)
- Modify: `docs/tracking/PROJECT_STATE.md`
- Modify: `docs/tracking/TASKS.md`

**Interfaces:**
- Consumes: nothing. Produces: nothing.

- [ ] **Step 1: Append Decision 040 to `docs/tracking/DECISION_LOG.md`**

Add at the end:
```markdown

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
```

- [ ] **Step 2: Note the change in `PROJECT_STATE.md` and `TASKS.md`**

In `docs/tracking/PROJECT_STATE.md`, record that the income view is consolidated onto the
Pipeline tab and the 757-line `income_list_screen.dart` violation is cleared. In
`docs/tracking/TASKS.md`, add a completed entry referencing Decision 040.

- [ ] **Step 3: Commit**

```bash
git add docs/tracking/
git commit -m "docs(tracking): record income view consolidation (Decision 040)"
```

---

## Self-review

**Spec coverage:**
- Delete `income_list_screen.dart` (+ `IncomeFilter`) → Task 2 ✓
- Delete orphaned `IncomePipelineSummary` → Task 1 ✓
- Remove `/income` `GoRoute` + import → Task 2 ✓
- Remove `RouteNames.income` (hard-delete, no redirect) → Task 2 ✓
- Remove 15 orphaned l10n keys from both ARB files + regenerate → Task 3 ✓
- `dart analyze` 0/0/0 + full suite green, no test edits → gate in every task ✓
- Decision 040 + tracking docs → Task 4 ✓
- Permanent guard against re-introduction → Task 2 guard test ✓ (exceeds spec)

**Placeholder scan:** No TBD/TODO; all code, commands, and ARB entries are concrete.

**Type consistency:** `appRouter`, `appRouter.configuration.routes`, `GoRoute.path`/`.name`,
`RouteBase.routes` used consistently in the guard test; key names in Task 3 match the spec's
orphan list exactly.
