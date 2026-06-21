# Design Spec — History Tab: Paper Ledger Reskin + Trust Surfacing (Sub-project B)

- **Date:** 2026-06-21
- **Status:** Approved (design) — pending implementation plan
- **Type:** UX/UI reskin + functionality + feature-gap closure
- **Scope authority:** Decision 039 (Paper Ledger reskin precedent); HELM_FINAL_PRODUCT_DOCTRINE — "Trust layer = non-negotiable"
- **Follows:** Sub-project A (Income List Consolidation) — same `paper-ledger-reskin` branch

## Context

The **History** tab is the bottom-nav destination `AuditLogScreen`
(`lib/features/audit_log/presentation/views/audit_log_screen.dart`, 159 lines).
It is the last primary nav destination still on the **pre–Paper Ledger** look:
plain Material `AppBar` + `ListTile` + `Divider`, a `CircularProgressIndicator`
loading state, and bare centered `Text` for empty/error. Home (`DashboardScreen`)
and Pipeline (`PipelineScreen`) were reskinned under Decision 039; this screen
was not.

Beyond styling, the screen discards most of its own data and hides a real
trust-layer capability:

1. **Event detail is thrown away.** Every `AuditEvent` carries `description`,
   `previousValue`, and `newValue` (the before→after of each change). The UI
   shows only an icon, a generic title, and a timestamp. Rows are not tappable.
2. **No grouping.** A flat newest-first list with no time structure.
3. **The tamper-evidence chain is invisible.** `AuditChainService` already
   maintains a SHA-256 hash chain over every event, but nothing in the UI tells
   the user the ledger is verified/intact — despite the Doctrine calling the
   Trust Layer "non-negotiable."
4. **90-day retention** (`kAuditRetentionDays`) prunes silently; the user is
   never told history is finite.

## Goal

Bring the History tab to the Paper Ledger standard **and** close the gaps above:
date-grouped event cards, a tappable per-event detail sheet showing the
before→after change, a verify-on-open ledger-integrity strip backed by real
chain re-verification, and an honest retention note. No change to how audit
events are written.

## Non-Goals

- **No** type/entity **filter chips** and **no search.** Date grouping + detail
  deliver the value; deferrable to a later cycle.
- **No** pull-to-refresh. Verify-on-open + provider refresh on navigation covers
  freshness for purely-local data.
- **No** change to audit-event **writing**, the append-only datasource, the
  retention policy value, or the canonical hash payload.
- **No** change to other screens, routing, or persistence schemas.

## Architecture

Feature-first, presentation-layer work plus one domain-layer addition
(chain verification). New files are extracted so each stays well under the
300-line limit.

### Files created

| File | Responsibility |
|---|---|
| `lib/features/audit_log/presentation/widgets/ledger_integrity_strip.dart` | `_LedgerIntegrityStrip` — renders the verify-on-open integrity result (verified / issue). |
| `lib/features/audit_log/presentation/widgets/audit_event_card.dart` | Tappable Paper Ledger event card (icon + title + relative time). Opens the detail sheet. |
| `lib/features/audit_log/presentation/widgets/audit_event_detail_sheet.dart` | `AuditEventDetailSheet` — modal bottom sheet with full event detail + before→after diff + record hash. |

### Files modified

| File | Change |
|---|---|
| `lib/features/audit_log/presentation/views/audit_log_screen.dart` | Reskin to Paper Ledger idiom; compose strip + date-grouped sections + retention footer; themed loading/error/empty. Date-bucketing helper lives here (or an extracted pure helper if it pushes the file over budget). |
| `lib/features/audit_log/data/services/audit_chain_service.dart` | Add `verifyChain(...)` (see below). No change to `_canonicalPayload`, `appendAndHash`, or any existing method. |
| `lib/features/audit_log/presentation/providers/audit_providers.dart` | Add `auditIntegrityProvider` (FutureProvider) that verifies the chain once. |
| `lib/l10n/app_en.arb` + `lib/l10n/app_bn.arb` | New keys (below); regenerate. |

## Components & data flow

### 1. Screen shell (`AuditLogScreen`)
- AppBar: `colors.canvas` background, `elevation: 0`, `scrolledUnderElevation: 0`,
  title `l10n.changeHistory` in `typo.headingSm`/`colors.inkPrimary`, left-aligned
  — matching `PipelineScreen`.
- Body (`data` state): single `ListView`, `HelmSpacing.screenEdge` horizontal
  padding, order = integrity strip → date-grouped sections → retention footer.
- Loading: centered `CircularProgressIndicator` on `colors.canvas`.
- Error: styled like `_EmptyPipelineView` (icon + `bodyMd`/`inkSecondary`),
  copy = `l10n.auditLogLoadError`.
- Empty (no events): icon + `l10n.auditLogEmpty` in the same styled treatment.

### 2. Date grouping
Pure function over the already-newest-first `List<AuditEvent>` → ordered buckets:
**Today / Yesterday / This week / Earlier**, computed against `DateTime.now()`
normalized to local midnight (mirroring `PipelineScreen`'s `today` calc).
- "This week" = within the last 7 days but before yesterday.
- Empty buckets are omitted entirely (no placeholder rows).
- Each non-empty bucket renders a `_SectionHeader`-style row: colored bar +
  `labelMd` label (`colors.inkSecondary`) + per-bucket count in `labelSm`
  (`colors.inkTertiary`) on the right.

### 3. Event card (`AuditEventCard`)
Replaces `ListTile`. Tappable (`InkWell`) card in the surface/divider/`cardRadius`
idiom (cf. `HelmAuditCard`):
- Leading: type icon via the existing `_iconFor` + `_colorFor` mapping (preserved
  verbatim, moved into this widget).
- Title: existing `_titleFor`/`_entityLabel` logic (preserved, moved in).
- Trailing/subtitle: **relative** time — "Just now" / "Nm ago" / "Nh ago" for
  today; otherwise short clock or date — in `labelSm`/`inkTertiary`.
- Tap → `showModalBottomSheet` with `AuditEventDetailSheet(event: event)`.

### 4. Detail sheet (`AuditEventDetailSheet`)
Modal bottom sheet (convention: Pipeline's `ConfirmReceivedSheet`):
- Header: type icon + `_titleFor` title.
- Rows: entity label; **exact** timestamp `DateFormat('MMM d, yyyy · h:mm a')`;
  `description`.
- **Before → After diff:** two labeled values, `previousValue` and `newValue`,
  rendered **verbatim** in `monoFinancialSm`. Null-aware: a null side renders as
  "—" (created has no previous; deleted has no new). Values are shown as stored
  strings — not parsed or re-formatted — so Decision 037 (NumberFormatter as the
  sole currency boundary) is not implicated.
- **Record hash:** fetched via `chainService.hashFor(event.id)`, shown in
  `monoFinancialSm`/`inkTertiary` with a label; if null, render "—".

### 5. Chain verification (domain addition)
Add to `AuditChainService`:

```dart
/// Result of re-verifying the audit hash chain.
class ChainVerification {
  final bool isIntact;
  /// id of the first event whose recomputed hash != stored hash; null if intact.
  final String? firstBrokenEventId;
  final int verifiedCount;
  const ChainVerification({
    required this.isIntact,
    required this.verifiedCount,
    this.firstBrokenEventId,
  });
}

/// Recomputes the chain over [eventsNewestFirst] and compares each event's
/// recomputed hash against the stored hash, confirming the terminal hash.
/// Re-uses [_canonicalPayload] so verification and append stay in lockstep.
Future<ChainVerification> verifyChain(List<AuditEvent> eventsNewestFirst) async { ... }
```

Algorithm: reverse to chronological (oldest-first) order; walk the chain
starting from `previousHash = ''`; for each event recompute
`sha256(_canonicalPayload(event, previousHash))`, compare to the stored
`hashFor(event.id)`; on mismatch return `isIntact: false` with that event id;
set `previousHash = recomputed` and continue; finally confirm the last
recomputed hash equals `terminalHash()`. Empty list ⇒ `isIntact: true`,
`verifiedCount: 0`. All Hive access stays inside the service; failures are
caught and surfaced as a non-intact result rather than thrown.

### 6. Integrity provider + strip
- `auditIntegrityProvider`: `FutureProvider<ChainVerification>` that reads the
  events (depends on `auditEventsProvider`) and calls
  `chainService.verifyChain(...)`. Runs once on open; re-runs if events change.
- `_LedgerIntegrityStrip` watches it:
  - loading → neutral "Verifying ledger…" in `inkTertiary`.
  - intact → ✓ `l10n.ledgerVerified(count)` in `colors.stateSafe`.
  - not intact → ⚠ `l10n.ledgerIntegrityIssue` in `colors.stateAtRisk`.
  - error → treated as the issue state (fail safe / loud, not silent).

### 7. Retention footer
Quiet `labelSm`/`inkTertiary` line below the list:
`l10n.historyRetentionNote(kAuditRetentionDays)` → "History keeps the last 90
days." Driven by the constant so copy and policy never drift.

## Localization

New keys (template `app_en.arb` with `@`-metadata, plus `app_bn.arb`), then
`fvm flutter gen-l10n`:

| Key | English | Notes |
|---|---|---|
| `ledgerVerified` | "Ledger verified · {count} records" | placeholder `count` (int) |
| `ledgerIntegrityIssue` | "Integrity issue detected" | |
| `ledgerVerifying` | "Verifying ledger…" | |
| `historyRetentionNote` | "History keeps the last {days} days" | placeholder `days` (int) |
| `historyGroupToday` | "Today" | |
| `historyGroupYesterday` | "Yesterday" | |
| `historyGroupThisWeek` | "This week" | |
| `historyGroupEarlier` | "Earlier" | |
| `auditDetailBefore` | "Before" | detail diff label |
| `auditDetailAfter` | "After" | detail diff label |
| `auditDetailDescription` | "Description" | detail label |
| `auditDetailTimestamp` | "When" | detail label |
| `auditDetailEntity` | "Record" | detail label |
| `auditDetailRecordHash` | "Record hash" | detail label |
| `auditRelativeJustNow` | "Just now" | |
| `auditRelativeMinutesAgo` | "{minutes}m ago" | placeholder `minutes` (int) |
| `auditRelativeHoursAgo` | "{hours}h ago" | placeholder `hours` (int) |

(Existing keys reused: `changeHistory`, `auditLogLoadError`, `auditLogEmpty`,
`auditEvent*`, `auditEntity*`. Bangla values follow existing translation style.)

## Error handling

- Provider/datasource failure → screen error state (existing copy).
- Chain box unavailable or verification throws → strip shows the **issue**
  state (fail loud), never a false "verified."
- Null `previousValue`/`newValue`/hash → "—" in the sheet, no crash.
- All `setState`/post-async navigation guarded with `mounted`.

## Testing

- **Unit:** `verifyChain` — intact chain, single-event tampering (returns the
  right id), reordering detected, empty list (intact, count 0). Date-bucketing
  helper — boundaries at today/yesterday/7-day/earlier. `auditIntegrityProvider`
  — intact and broken paths.
- **Widget:** strip renders verified/issue/loading; an `AuditEventCard` tap opens
  the detail sheet with before→after values; themed empty and error states.
- **Golden:** light + dark baselines for the reskinned screen (with a seeded
  set of events spanning multiple date buckets), following the Paper Ledger
  golden convention. Tagged `golden`.
- **Gates:** `fvm dart analyze` → 0/0/0; `fvm flutter test` green
  (`--exclude-tags golden` for logic CI, full run incl. goldens locally).

## Risk & rollback

- **Risk: low–medium.** Presentation reskin is low risk; the one real logic
  addition (`verifyChain`) is pure and unit-tested, and re-uses the existing
  canonical payload so it cannot drift from `appendAndHash`. No writes change.
- **Rollback:** revert the feature commits; no schema/persistence migration is
  involved.

## Documentation updates (per CLAUDE.md)

- `docs/tracking/DECISION_LOG.md` — add **Decision 041**: History tab brought to
  Paper Ledger standard; tamper-evidence chain surfaced via verify-on-open
  integrity strip; event detail (before→after) exposed.
- `docs/tracking/PROJECT_STATE.md` / `docs/tracking/TASKS.md` — record the
  reskin + trust surfacing; update test count.
- `docs/core/ROADMAP.md` — note Trust Layer visibility milestone if it tracks
  trust-layer surfacing.

## Definition of done

- [ ] `AuditLogScreen` reskinned to Paper Ledger idiom; themed loading/error/empty.
- [ ] Events date-grouped (Today/Yesterday/This week/Earlier) with section headers.
- [ ] Tappable `AuditEventCard` → `AuditEventDetailSheet` showing description,
      before→after diff, and record hash.
- [ ] `AuditChainService.verifyChain` added + unit-tested; `auditIntegrityProvider`
      added; `_LedgerIntegrityStrip` shows verify-on-open result.
- [ ] Retention footer driven by `kAuditRetentionDays`.
- [ ] New l10n keys in both ARBs; `gen-l10n` regenerated; currency only via
      NumberFormatter (Decision 037).
- [ ] Each new/changed file under 300 lines.
- [ ] `dart analyze` 0/0/0; `flutter test` green (incl. new + golden tests).
- [ ] Decision 041 + tracking docs updated.

## Follow-up (out of scope, candidates for a later cycle)

- Type/entity filter chips and search.
- Pull-to-refresh.
- Tap-to-re-verify on the integrity strip.
