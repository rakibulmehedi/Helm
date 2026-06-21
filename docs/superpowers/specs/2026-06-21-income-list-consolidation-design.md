# Design Spec — Income List Consolidation (Sub-project A)

- **Date:** 2026-06-21
- **Status:** Approved (design) — pending implementation plan
- **Type:** Dead-code removal / consolidation (no user-facing behaviour change)
- **Scope authority:** Decision 039 (Paper Ledger) precedent — "removed, not hidden"

## Context

The Paper Ledger reskin (Decision 039) landed on **Home** (`DashboardScreen`) and
**Pipeline** (`PipelineScreen`). While scoping the next screen upgrade, investigation
revealed that `IncomeListScreen` is **superseded legacy code**:

- `pipeline_screen.dart:5` states verbatim: *"Replaces IncomeListScreen at /pipeline route."*
  `PipelineScreen` is the reskinned, richer, state-grouped, action-oriented view of the
  **same** `incomeNotifierProvider` data (Needs-decision / Overdue / Pending / Expected /
  Received), with confirm-received and duplicate-as-next-month interactions.
- `IncomeListScreen`'s **only** entry point is the widget `IncomePipelineSummary`.
- `IncomePipelineSummary` is **orphaned**: zero references in `lib/` outside its own file.
  Git history shows it was mounted on the dashboard in Phase 7d (`bbadfa5`) and dropped
  during the Paper Ledger dashboard migration (`3450a89`), but never deleted.

Net: `IncomeListScreen` is dead code reachable only from another dead widget. Reskinning it
would polish a screen users cannot navigate to. The correct action is removal, consolidating
all income viewing onto the **Pipeline** tab.

## Goal

Remove the superseded `IncomeListScreen` and its orphaned entry widget so the **Pipeline**
tab is the single, unambiguous income view. No behaviour change for users — every deleted
path is unreachable in the current build.

## Non-Goals

- No changes to `PipelineScreen` behaviour, layout, or styling.
- No changes to income domain/data layers, providers, or persistence.
- No new features. (Feature/UX work moves to Sub-project B — the History/audit tab.)

## Changes

### Files deleted (2)

| File | Notes |
|---|---|
| `lib/features/income/presentation/views/income_list_screen.dart` | 757 lines. Removes the `IncomeFilter` enum with it (zero other usages in `lib/`). |
| `lib/features/income/presentation/widgets/income_pipeline_summary.dart` | Orphaned widget; not mounted since the Paper Ledger dashboard migration. |

### Files edited (2)

| File | Change |
|---|---|
| `lib/config/router/app_router.dart` | Remove the `/income` `GoRoute` (the builder block at lines ~111–123) and the now-unused `IncomeListScreen` import. **Hard-delete** — no redirect (the only caller is being deleted in the same change). |
| `lib/config/router/route_names.dart` | Remove `static const String income = '/income';`. |

### Localization cleanup

15 l10n keys are used **only** by the two deleted files and become orphaned. Remove each
key (and its `@key` metadata block in the template) from both ARB files, then regenerate.

Orphaned keys:

```
addFirstExpectedPayment   addOneForNewProject   filterAll
incomeByDate              incomeEntryCount      incomePipeline
incomeReceivedDate        noExpectedPayments    noPaymentsInTransit
noPaymentsInTransitNow    noPaymentsReceivedThisMonth
noReceivedPaymentsYet     nothingHere           trackIncomePipeline
useButtonToAdd
```

Steps:
1. Remove each key + its `@key` metadata block from `lib/l10n/app_en.arb` (template).
2. Remove each key from `lib/l10n/app_bn.arb`.
3. Regenerate: `fvm flutter gen-l10n` (project uses `generate: true`, `l10n.yaml`).

> Caution: several of these keys carry placeholders/plurals (`incomeEntryCount`,
> `incomeByDate`, `incomeReceivedDate`, `noPaymentsReceivedThisMonth`). Remove their full
> `@`-metadata blocks, not just the value lines.

## Data flow / architecture

No runtime data flow changes. Removing `IncomeListScreen` deletes a duplicate read path on
`incomeNotifierProvider`; the canonical read path (`PipelineScreen`) is untouched. This
*reduces* a 757-line file (over the 300-line limit) to zero and eliminates duplication.

## Risk & rollback

- **Risk: very low.** All removed code is unreachable today; the only caller is removed in
  the same change. No barrel/`export`/`part` re-exports reference the deleted files.
- **Rollback:** single-commit revert restores all files (git).

## Testing

- No test or golden file references `income_list_screen`, `IncomeListScreen`,
  `income_pipeline_summary`, `IncomePipelineSummary`, or `IncomeFilter` (verified).
- Acceptance gates:
  - `fvm dart analyze` → **0/0/0** (errors/warnings/infos).
  - `fvm flutter test` → full suite green, including the 49 flow tests, with **no test
    edits required**. Any failure indicates a missed reference and blocks the change.

## Documentation updates (per CLAUDE.md)

- `docs/tracking/DECISION_LOG.md` — add **Decision 040**: income view consolidated onto the
  Pipeline tab; `IncomeListScreen` + `IncomePipelineSummary` removed (supersession recorded).
- `docs/tracking/PROJECT_STATE.md` / `docs/tracking/TASKS.md` — note the removal and the
  757-line file-limit violation cleared.

## Definition of done

- [ ] 2 files deleted, 2 files edited as above.
- [ ] 15 orphaned l10n keys removed from both ARB files; `gen-l10n` regenerated.
- [ ] `dart analyze` 0/0/0.
- [ ] `flutter test` fully green, no test edits.
- [ ] Decision 040 + tracking docs updated.

## Follow-up

**Sub-project B** (separate spec → plan → implementation cycle): UX/UI + feature-gap upgrade
of the **History** tab (`AuditLogScreen`) — the live nav destination still on the pre–Paper
Ledger look.
