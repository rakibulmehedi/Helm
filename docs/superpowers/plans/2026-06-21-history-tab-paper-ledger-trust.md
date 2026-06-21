# History Tab — Paper Ledger Reskin + Trust Surfacing Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Bring the History tab (`AuditLogScreen`) to the Paper Ledger standard and close its functional gaps — date-grouped tappable event cards, a per-event before→after detail sheet, a verify-on-open ledger-integrity strip backed by real SHA-256 chain re-verification, and an honest retention note.

**Architecture:** Presentation-layer reskin (feature-first, `features/audit_log/presentation/`) plus one pure domain addition (`AuditChainService.verifyChain`). The screen composes three new extracted widgets so every file stays under 300 lines. No audit-event *writing*, datasource, retention value, or canonical hash payload changes.

**Tech Stack:** Flutter, Riverpod (`flutter_riverpod`), Hive (`hive_ce`), `crypto` (SHA-256, already a dep), `intl`, Flutter gen-l10n. FVM toolchain (`fvm dart` / `fvm flutter`).

## Global Constraints

- Analyzer must be **0/0/0** (errors/warnings/infos) after every task: `fvm dart analyze`.
- Every new/changed file **under 300 lines**.
- Use `context.colors` / `context.textStyles` / `context.l10n` extensions and `HelmSpacing.*` tokens — **no raw hex**, no raw magic spacing.
- Use `withValues(alpha: x)`, never `withOpacity(x)`.
- Guard all `setState` and post-async navigation with `mounted`.
- Currency glyphs only via `NumberFormatter` (Decision 037). The before→after diff shows stored values **verbatim** — it does not parse or re-format currency, so this constraint is not triggered.
- Do **not** add packages to `pubspec.yaml`.
- Do **not** modify `AuditChainService._canonicalPayload`, `appendAndHash`, the append-only datasource, or `kAuditRetentionDays`.
- Bottom sheets follow the `confirm_received_sheet.dart` convention: a `static Future<void> show(BuildContext, ...)` using `showModalBottomSheet` with `isScrollControlled: true`, `useSafeArea: true`, `backgroundColor: context.colors.surface`, and `RoundedRectangleBorder` top radius `HelmSpacing.sheetTopRadius`.
- Golden tests are tagged `@Tags(['golden'])` and excluded from logic CI via `--exclude-tags golden`.
- **Git hygiene:** stage only files this plan names (`git add <path>` / `git rm <path>`). NEVER `git add -A`/`git add .` — the working tree carries unrelated `ios/*`, `Podfile.lock`, `macos/Podfile`, `test/golden/failures/` that must never be committed. Verify `git status --short` before each commit.

### Token reference (verified to exist)

- **Colors** (`context.colors`): `canvas`, `surface`, `divider`, `hairline`, `inkPrimary`, `inkSecondary`, `inkTertiary`, `interactive`, `stateSafe`, `stateAtRisk`, `stateTight`, `stateHope`, `stateHopeMuted`.
- **Typography** (`context.textStyles`): `displayHero`, `displayLarge`, `headingLg/Md/Sm`, `bodyLg/Md/Sm`, `labelMd`, `labelSm`, `monoFinancialLg/Md/Sm`, `monoHero`.
- **Spacing** (`HelmSpacing`): `s1..s12`, `cardRadius` (12), `sheetTopRadius` (16), `screenEdge` (16), `cardBorder` (1), `iconSm/Md/Lg/Xl`.

### Existing interfaces (consumed, unchanged)

- `AuditEvent { String id; DateTime timestamp; AuditEventType eventType; AuditEntityType entityType; String entityId; String? previousValue; String? newValue; String description; }` — `lib/features/audit_log/domain/entities/audit_event.dart`.
- `enum AuditEventType { unknown, created, updated, deleted, confirmed, exported }`; `enum AuditEntityType { unknown, income, transaction, stsSettings, fixedCost }`.
- `auditEventsProvider` → `FutureProvider<List<AuditEvent>>` (newest-first) — `lib/features/audit_log/presentation/providers/audit_providers.dart`.
- `auditLocalDataSourceProvider` → `Provider<AuditLocalDataSourceImpl>`.
- `AuditChainService` — `appendAndHash`, `hashFor(id)`, `previousHashFor(id)`, `terminalHash()`, `clear()`, `_canonicalPayload` (private). Box: `AppBoxNames.auditChainBox` (`Box<String>`).
- `AuditLocalDataSourceImpl({AuditChainService? chainService})` — constructor accepts an injectable chain service.
- Test helper: `TestHive.init()` / `TestHive.tearDown()` / `TestHive.openBox(name)` — `test/helpers/test_hive.dart`.

### Parallelization notes (for the controller)

Subagent-Driven Development executes implementation tasks **sequentially** (never dispatch two implementers at once — they conflict on the shared tree). Where this plan notes "independent," it means the task has no code dependency on its siblings and could be parallelized in a *worktree-isolated* workflow; under standard SDD, run them in listed order. The genuine independent cluster is **Tasks 1, 2, 3** (domain verify, pure helpers, l10n) — none import the others. Tasks 4–9 have real dependencies and must follow.

---

### Task 1: Chain verification (domain logic)

**Files:**
- Modify: `lib/features/audit_log/data/services/audit_chain_service.dart`
- Test: `test/features/audit_log/data/services/audit_chain_service_verify_test.dart`

**Interfaces:**
- Consumes: existing `AuditChainService` (`appendAndHash`, `hashFor`, `terminalHash`, private `_canonicalPayload`), `AuditEvent`.
- Produces: `class ChainVerification { final bool isIntact; final String? firstBrokenEventId; final int verifiedCount; }` and `Future<ChainVerification> AuditChainService.verifyChain(List<AuditEvent> eventsNewestFirst)`.

**Assumption (document in a code comment):** events were appended in ascending-timestamp order (true in practice — every event is appended at creation time), so sorting `eventsNewestFirst` to oldest-first reconstructs the original append order and therefore the chain.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/audit_log/data/services/audit_chain_service_verify_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/features/audit_log/data/services/audit_chain_service.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import '../../../../helpers/test_hive.dart';

AuditEvent _event(String id, int minute, {String? prev, String? next}) => AuditEvent(
      id: id,
      timestamp: DateTime(2026, 6, 1, 10, minute),
      eventType: AuditEventType.updated,
      entityType: AuditEntityType.income,
      entityId: 'e-$id',
      previousValue: prev,
      newValue: next,
      description: 'change $id',
    );

void main() {
  late AuditChainService service;

  setUp(() async {
    await TestHive.init();
    await TestHive.openBox(AppBoxNames.auditChainBox);
    service = AuditChainService();
  });

  tearDown(() async => TestHive.tearDown());

  test('empty list verifies as intact with zero count', () async {
    final result = await service.verifyChain(const []);
    expect(result.isIntact, isTrue);
    expect(result.verifiedCount, 0);
    expect(result.firstBrokenEventId, isNull);
  });

  test('intact chain built via appendAndHash verifies', () async {
    final a = _event('a', 1, next: '100');
    final b = _event('b', 2, prev: '100', next: '200');
    final c = _event('c', 3, prev: '200', next: '300');
    for (final e in [a, b, c]) {
      await service.appendAndHash(e);
    }
    // Provider supplies newest-first.
    final result = await service.verifyChain([c, b, a]);
    expect(result.isIntact, isTrue);
    expect(result.verifiedCount, 3);
    expect(result.firstBrokenEventId, isNull);
  });

  test('tampering with one event is detected at that event', () async {
    final a = _event('a', 1, next: '100');
    final b = _event('b', 2, prev: '100', next: '200');
    final c = _event('c', 3, prev: '200', next: '300');
    for (final e in [a, b, c]) {
      await service.appendAndHash(e);
    }
    // Tamper: b's stored content changed after hashing.
    final tamperedB = b.copyWith(newValue: '999');
    final result = await service.verifyChain([c, tamperedB, a]);
    expect(result.isIntact, isFalse);
    expect(result.firstBrokenEventId, 'b');
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/features/audit_log/data/services/audit_chain_service_verify_test.dart`
Expected: FAIL — `verifyChain` / `ChainVerification` not defined.

- [ ] **Step 3: Add `ChainVerification` and `verifyChain` to the service**

Append to `lib/features/audit_log/data/services/audit_chain_service.dart` (outside the existing class for `ChainVerification`; add the method inside `AuditChainService`). Reuse `_canonicalPayload` so verification can never drift from `appendAndHash`.

```dart
/// Result of re-verifying the audit hash chain.
class ChainVerification {
  /// True when every recomputed hash matches the stored hash.
  final bool isIntact;

  /// id of the first event whose recomputed hash != stored hash; null if intact.
  final String? firstBrokenEventId;

  /// Number of events that were verified before stopping (or all, if intact).
  final int verifiedCount;

  const ChainVerification({
    required this.isIntact,
    required this.verifiedCount,
    this.firstBrokenEventId,
  });
}
```

Add inside `AuditChainService`:

```dart
  /// Recomputes the chain over [eventsNewestFirst] and compares each event's
  /// recomputed hash against the stored hash.
  ///
  /// Assumes events were appended in ascending-timestamp order (true in
  /// practice — every event is appended at creation time), so reversing to
  /// oldest-first reconstructs the original append order and chain.
  /// Re-uses [_canonicalPayload] so verification and append stay in lockstep.
  /// Any storage failure is surfaced as a non-intact result, never thrown.
  Future<ChainVerification> verifyChain(
    List<AuditEvent> eventsNewestFirst,
  ) async {
    if (eventsNewestFirst.isEmpty) {
      return const ChainVerification(isIntact: true, verifiedCount: 0);
    }
    try {
      final box = await _chainBox;
      final chronological = eventsNewestFirst.reversed.toList();
      var previousHash = '';
      var verified = 0;
      for (final event in chronological) {
        final payload = _canonicalPayload(event, previousHash);
        final recomputed = sha256.convert(utf8.encode(payload)).toString();
        final stored = box.get(event.id);
        if (stored == null || stored != recomputed) {
          return ChainVerification(
            isIntact: false,
            verifiedCount: verified,
            firstBrokenEventId: event.id,
          );
        }
        previousHash = recomputed;
        verified++;
      }
      // Confirm the terminal hash matches the last recomputed hash.
      final terminal = box.get(_lastHashKey) ?? '';
      if (terminal != previousHash) {
        return ChainVerification(
          isIntact: false,
          verifiedCount: verified,
          firstBrokenEventId: chronological.last.id,
        );
      }
      return ChainVerification(isIntact: true, verifiedCount: verified);
    } on Exception catch (_) {
      return const ChainVerification(
        isIntact: false,
        verifiedCount: 0,
        firstBrokenEventId: null,
      );
    }
  }
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `fvm flutter test test/features/audit_log/data/services/audit_chain_service_verify_test.dart`
Expected: PASS (3 tests). Then `fvm dart analyze` → 0/0/0.

- [ ] **Step 5: Commit**

```bash
git add lib/features/audit_log/data/services/audit_chain_service.dart test/features/audit_log/data/services/audit_chain_service_verify_test.dart
git commit -m "feat(audit): add verifyChain integrity re-verification

- ChainVerification result type
- verifyChain recomputes SHA-256 over events, reuses _canonicalPayload
- detects tampering + terminal-hash mismatch; fails safe on storage error
- dart analyze clean"
```

---

### Task 2: History grouping + relative-time helpers (pure)

**Files:**
- Create: `lib/features/audit_log/presentation/utils/audit_history_grouping.dart`
- Test: `test/features/audit_log/presentation/audit_history_grouping_test.dart`

**Interfaces:**
- Consumes: `AuditEvent`.
- Produces:
  - `enum HistoryBucket { today, yesterday, thisWeek, earlier }`
  - `HistoryBucket bucketFor(DateTime eventTime, DateTime now)`
  - `List<MapEntry<HistoryBucket, List<AuditEvent>>> groupByRecency(List<AuditEvent> newestFirst, DateTime now)` — ordered today→earlier, omitting empty buckets, preserving newest-first within each bucket.
  - `String relativeTimeLabel(DateTime eventTime, DateTime now)` returns a *token* string so l10n stays in the widget layer: returns `'justNow'`, `'mAgo:<n>'`, `'hAgo:<n>'`, or `'clock'` (today, ≥ today's start) / `'date'` (older). The widget maps tokens to localized strings (Task 7). This keeps the helper pure and locale-free.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/audit_log/presentation/audit_history_grouping_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/utils/audit_history_grouping.dart';

AuditEvent _at(DateTime t) => AuditEvent(
      id: t.toIso8601String(),
      timestamp: t,
      eventType: AuditEventType.created,
      entityType: AuditEntityType.income,
      entityId: 'x',
      description: 'd',
    );

void main() {
  final now = DateTime(2026, 6, 21, 14, 0); // Sunday afternoon

  group('bucketFor', () {
    test('same day → today', () {
      expect(bucketFor(DateTime(2026, 6, 21, 1, 0), now), HistoryBucket.today);
    });
    test('previous calendar day → yesterday', () {
      expect(bucketFor(DateTime(2026, 6, 20, 23, 0), now), HistoryBucket.yesterday);
    });
    test('within last 7 days but before yesterday → thisWeek', () {
      expect(bucketFor(DateTime(2026, 6, 16, 9, 0), now), HistoryBucket.thisWeek);
    });
    test('older than 7 days → earlier', () {
      expect(bucketFor(DateTime(2026, 6, 10, 9, 0), now), HistoryBucket.earlier);
    });
  });

  group('groupByRecency', () {
    test('orders buckets and omits empties, newest-first within bucket', () {
      final t1 = _at(DateTime(2026, 6, 21, 13, 0)); // today, newer
      final t2 = _at(DateTime(2026, 6, 21, 8, 0)); // today, older
      final e1 = _at(DateTime(2026, 6, 1, 8, 0)); // earlier
      final grouped = groupByRecency([t1, t2, e1], now);
      expect(grouped.map((e) => e.key).toList(),
          [HistoryBucket.today, HistoryBucket.earlier]);
      expect(grouped.first.value, [t1, t2]);
    });
    test('empty input → empty list', () {
      expect(groupByRecency(const [], now), isEmpty);
    });
  });

  group('relativeTimeLabel', () {
    test('under a minute → justNow', () {
      expect(relativeTimeLabel(DateTime(2026, 6, 21, 13, 59, 30), now), 'justNow');
    });
    test('minutes today → mAgo:n', () {
      expect(relativeTimeLabel(DateTime(2026, 6, 21, 13, 30), now), 'mAgo:30');
    });
    test('hours today → hAgo:n', () {
      expect(relativeTimeLabel(DateTime(2026, 6, 21, 11, 0), now), 'hAgo:3');
    });
    test('not today → date', () {
      expect(relativeTimeLabel(DateTime(2026, 6, 19, 11, 0), now), 'date');
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/features/audit_log/presentation/audit_history_grouping_test.dart`
Expected: FAIL — library not found.

- [ ] **Step 3: Write the helper**

```dart
// lib/features/audit_log/presentation/utils/audit_history_grouping.dart
//
// Pure, locale-free helpers for the History tab: recency bucketing and a
// relative-time token (the widget layer localizes the token).

import 'package:helm/features/audit_log/domain/entities/audit_event.dart';

enum HistoryBucket { today, yesterday, thisWeek, earlier }

DateTime _midnight(DateTime t) => DateTime(t.year, t.month, t.day);

HistoryBucket bucketFor(DateTime eventTime, DateTime now) {
  final today = _midnight(now);
  final eventDay = _midnight(eventTime);
  final dayDelta = today.difference(eventDay).inDays;
  if (dayDelta <= 0) return HistoryBucket.today;
  if (dayDelta == 1) return HistoryBucket.yesterday;
  if (dayDelta <= 7) return HistoryBucket.thisWeek;
  return HistoryBucket.earlier;
}

/// Groups [newestFirst] into ordered buckets (today→earlier), omitting empty
/// buckets and preserving newest-first order within each bucket.
List<MapEntry<HistoryBucket, List<AuditEvent>>> groupByRecency(
  List<AuditEvent> newestFirst,
  DateTime now,
) {
  final byBucket = <HistoryBucket, List<AuditEvent>>{};
  for (final event in newestFirst) {
    byBucket.putIfAbsent(bucketFor(event.timestamp, now), () => []).add(event);
  }
  return HistoryBucket.values
      .where(byBucket.containsKey)
      .map((b) => MapEntry(b, byBucket[b]!))
      .toList();
}

/// Returns a locale-free token: 'justNow', 'mAgo:<n>', 'hAgo:<n>', or 'date'.
String relativeTimeLabel(DateTime eventTime, DateTime now) {
  if (bucketFor(eventTime, now) != HistoryBucket.today) return 'date';
  final diff = now.difference(eventTime);
  if (diff.inMinutes < 1) return 'justNow';
  if (diff.inMinutes < 60) return 'mAgo:${diff.inMinutes}';
  return 'hAgo:${diff.inHours}';
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `fvm flutter test test/features/audit_log/presentation/audit_history_grouping_test.dart`
Expected: PASS (10 tests). Then `fvm dart analyze` → 0/0/0.

- [ ] **Step 5: Commit**

```bash
git add lib/features/audit_log/presentation/utils/audit_history_grouping.dart test/features/audit_log/presentation/audit_history_grouping_test.dart
git commit -m "feat(audit): add recency grouping + relative-time helpers

- HistoryBucket + bucketFor/groupByRecency (omits empty buckets)
- locale-free relativeTimeLabel token
- dart analyze clean"
```

---

### Task 3: Localization keys

**Files:**
- Modify: `lib/l10n/app_en.arb` (template, with `@`-metadata)
- Modify: `lib/l10n/app_bn.arb`
- Regenerate: `lib/l10n/app_localizations*.dart` (via `fvm flutter gen-l10n`)
- Test: `test/features/audit_log/audit_l10n_keys_test.dart`

**Interfaces:**
- Produces generated getters used by Tasks 5–8: `ledgerVerified(int count)`, `ledgerIntegrityIssue`, `ledgerVerifying`, `historyRetentionNote(int days)`, `historyGroupToday`, `historyGroupYesterday`, `historyGroupThisWeek`, `historyGroupEarlier`, `auditDetailBefore`, `auditDetailAfter`, `auditDetailDescription`, `auditDetailTimestamp`, `auditDetailEntity`, `auditDetailRecordHash`, `auditRelativeJustNow`, `auditRelativeMinutesAgo(int minutes)`, `auditRelativeHoursAgo(int hours)`.

- [ ] **Step 1: Add keys to `lib/l10n/app_en.arb`**

Insert these key/`@`-metadata pairs (place near the other `audit*` keys):

```json
  "ledgerVerified": "Ledger verified · {count} records",
  "@ledgerVerified": {
    "description": "History integrity strip, intact state",
    "placeholders": { "count": { "type": "int" } }
  },
  "ledgerIntegrityIssue": "Integrity issue detected",
  "@ledgerIntegrityIssue": { "description": "History integrity strip, broken state" },
  "ledgerVerifying": "Verifying ledger…",
  "@ledgerVerifying": { "description": "History integrity strip, loading state" },
  "historyRetentionNote": "History keeps the last {days} days",
  "@historyRetentionNote": {
    "description": "Footer note on History tab about retention",
    "placeholders": { "days": { "type": "int" } }
  },
  "historyGroupToday": "Today",
  "@historyGroupToday": { "description": "History date group header" },
  "historyGroupYesterday": "Yesterday",
  "@historyGroupYesterday": { "description": "History date group header" },
  "historyGroupThisWeek": "This week",
  "@historyGroupThisWeek": { "description": "History date group header" },
  "historyGroupEarlier": "Earlier",
  "@historyGroupEarlier": { "description": "History date group header" },
  "auditDetailBefore": "Before",
  "@auditDetailBefore": { "description": "Audit detail sheet, before value label" },
  "auditDetailAfter": "After",
  "@auditDetailAfter": { "description": "Audit detail sheet, after value label" },
  "auditDetailDescription": "Description",
  "@auditDetailDescription": { "description": "Audit detail sheet, description label" },
  "auditDetailTimestamp": "When",
  "@auditDetailTimestamp": { "description": "Audit detail sheet, timestamp label" },
  "auditDetailEntity": "Record",
  "@auditDetailEntity": { "description": "Audit detail sheet, entity label" },
  "auditDetailRecordHash": "Record hash",
  "@auditDetailRecordHash": { "description": "Audit detail sheet, hash label" },
  "auditRelativeJustNow": "Just now",
  "@auditRelativeJustNow": { "description": "Relative time, under one minute" },
  "auditRelativeMinutesAgo": "{minutes}m ago",
  "@auditRelativeMinutesAgo": {
    "description": "Relative time in minutes",
    "placeholders": { "minutes": { "type": "int" } }
  },
  "auditRelativeHoursAgo": "{hours}h ago",
  "@auditRelativeHoursAgo": {
    "description": "Relative time in hours",
    "placeholders": { "hours": { "type": "int" } }
  },
```

- [ ] **Step 2: Add the same keys (values only, no `@`-metadata) to `lib/l10n/app_bn.arb`**

Use Bangla translations consistent with the existing file's style. Suggested values:

```json
  "ledgerVerified": "লেজার যাচাই করা হয়েছে · {count} টি রেকর্ড",
  "ledgerIntegrityIssue": "অখণ্ডতার সমস্যা শনাক্ত হয়েছে",
  "ledgerVerifying": "লেজার যাচাই করা হচ্ছে…",
  "historyRetentionNote": "ইতিহাস সর্বশেষ {days} দিন সংরক্ষণ করে",
  "historyGroupToday": "আজ",
  "historyGroupYesterday": "গতকাল",
  "historyGroupThisWeek": "এই সপ্তাহে",
  "historyGroupEarlier": "আগের",
  "auditDetailBefore": "আগে",
  "auditDetailAfter": "পরে",
  "auditDetailDescription": "বিবরণ",
  "auditDetailTimestamp": "কখন",
  "auditDetailEntity": "রেকর্ড",
  "auditDetailRecordHash": "রেকর্ড হ্যাশ",
  "auditRelativeJustNow": "এইমাত্র",
  "auditRelativeMinutesAgo": "{minutes} মিনিট আগে",
  "auditRelativeHoursAgo": "{hours} ঘণ্টা আগে",
```

- [ ] **Step 3: Regenerate localizations**

Run: `fvm flutter gen-l10n`
Expected: regenerates `lib/l10n/app_localizations*.dart` with no errors.

- [ ] **Step 4: Write a guard test that the keys resolve**

```dart
// test/features/audit_log/audit_l10n_keys_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:helm/l10n/app_localizations.dart';

void main() {
  testWidgets('new History/audit l10n keys resolve in en', (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialAppL10nProbe(onBuilt: (value) => l10n = value),
    );
    expect(l10n.ledgerVerified(3), contains('3'));
    expect(l10n.ledgerIntegrityIssue, isNotEmpty);
    expect(l10n.historyRetentionNote(90), contains('90'));
    expect(l10n.historyGroupToday, isNotEmpty);
    expect(l10n.auditDetailBefore, isNotEmpty);
    expect(l10n.auditRelativeMinutesAgo(5), contains('5'));
  });
}

class MaterialAppL10nProbe extends StatelessWidget {
  const MaterialAppL10nProbe({super.key, required this.onBuilt});
  final void Function(AppLocalizations) onBuilt;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: const Color(0xFF000000),
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('bn')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, _) {
        onBuilt(AppLocalizations.of(context)!);
        return const SizedBox.shrink();
      },
    );
  }
}
```

- [ ] **Step 5: Run test + analyze**

Run: `fvm flutter test test/features/audit_log/audit_l10n_keys_test.dart`
Expected: PASS. Then `fvm dart analyze` → 0/0/0.

- [ ] **Step 6: Commit**

```bash
git add lib/l10n/app_en.arb lib/l10n/app_bn.arb lib/l10n/app_localizations.dart lib/l10n/app_localizations_en.dart lib/l10n/app_localizations_bn.dart test/features/audit_log/audit_l10n_keys_test.dart
git commit -m "feat(l10n): add History tab + audit-detail strings (en + bn)

- 17 keys for integrity strip, date groups, detail sheet, relative time
- regenerated localizations
- dart analyze clean"
```

> Note: confirm the exact generated filenames with `git status --short` before staging; stage only the `app_localizations*.dart` files that actually changed.

---

### Task 4: Integrity provider

**Files:**
- Modify: `lib/features/audit_log/presentation/providers/audit_providers.dart`
- Test: `test/features/audit_log/presentation/audit_integrity_provider_test.dart`

**Interfaces:**
- Consumes: `auditEventsProvider`, `auditLocalDataSourceProvider`, `AuditChainService.verifyChain` (Task 1), `ChainVerification`.
- Produces: `auditChainServiceProvider` → `Provider<AuditChainService>`; `auditIntegrityProvider` → `FutureProvider<ChainVerification>`.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/audit_log/presentation/audit_integrity_provider_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/constants/app_box_names.dart';
import 'package:helm/features/audit_log/data/models/audit_event_model.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:hive_ce/hive_ce.dart';
import '../../../helpers/test_hive.dart';

void main() {
  setUp(() async {
    await TestHive.init();
    // Register adapters + open the boxes the datasource/chain need.
    // (Adapter registration mirrors HiveService.init; see audit_event_model.)
  });
  tearDown(() async => TestHive.tearDown());

  test('intact appended chain → provider reports isIntact', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final ds = container.read(auditLocalDataSourceProvider);
    await ds.addEvent(AuditEvent(
      id: 'a',
      timestamp: DateTime(2026, 6, 1, 10),
      eventType: AuditEventType.created,
      entityType: AuditEntityType.income,
      entityId: 'e1',
      newValue: '100',
      description: 'added',
    ));

    final result = await container.read(auditIntegrityProvider.future);
    expect(result.isIntact, isTrue);
    expect(result.verifiedCount, 1);
  });
}
```

> Implementer note: this test needs the `audit_events_box` (`Box<AuditEventModel>`) and `audit_chain_box` (`Box<String>`) open plus the `AuditEventModel` adapter registered. Follow the exact registration/open sequence used by the existing `audit_event_model_test.dart` and `HiveService.init`. If box setup proves heavy, it is acceptable to test `auditIntegrityProvider` by overriding `auditEventsProvider` and `auditChainServiceProvider` with fakes instead — assert the provider wires events into `verifyChain`. Pick whichever gives a reliable green; record which in the report.

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/features/audit_log/presentation/audit_integrity_provider_test.dart`
Expected: FAIL — `auditIntegrityProvider` not defined.

- [ ] **Step 3: Add providers**

Append to `lib/features/audit_log/presentation/providers/audit_providers.dart`:

```dart
import 'package:helm/features/audit_log/data/services/audit_chain_service.dart';

/// Shared chain service for verification.
final auditChainServiceProvider = Provider<AuditChainService>((ref) {
  return AuditChainService();
});

/// Verifies the audit hash chain once on read. Re-runs when events change.
final auditIntegrityProvider = FutureProvider<ChainVerification>((ref) async {
  final events = await ref.watch(auditEventsProvider.future);
  final service = ref.read(auditChainServiceProvider);
  return service.verifyChain(events);
});
```

- [ ] **Step 4: Run test + analyze**

Run: `fvm flutter test test/features/audit_log/presentation/audit_integrity_provider_test.dart`
Expected: PASS. Then `fvm dart analyze` → 0/0/0.

- [ ] **Step 5: Commit**

```bash
git add lib/features/audit_log/presentation/providers/audit_providers.dart test/features/audit_log/presentation/audit_integrity_provider_test.dart
git commit -m "feat(audit): add auditIntegrityProvider (verify-on-read)

- auditChainServiceProvider + auditIntegrityProvider wiring verifyChain
- dart analyze clean"
```

---

### Task 5: Detail bottom sheet (`AuditEventDetailSheet`)

**Files:**
- Create: `lib/features/audit_log/presentation/widgets/audit_event_detail_sheet.dart`
- Test: `test/features/audit_log/presentation/audit_event_detail_sheet_test.dart`

**Interfaces:**
- Consumes: `AuditEvent`, `auditChainServiceProvider` (Task 4) for `hashFor`, l10n (Task 3), event-type icon/title mapping (moved from the old screen; see shared mapping note below).
- Produces: `class AuditEventDetailSheet extends ConsumerWidget` with `static Future<void> show(BuildContext, AuditEvent)`.

**Shared mapping note:** the `_iconFor`, `_colorFor`, `_titleFor`, `_entityLabel` logic currently private in `audit_log_screen.dart` is reused by both this sheet and the card (Task 7). Extract it once into `lib/features/audit_log/presentation/utils/audit_event_presentation.dart` as top-level functions `auditIconFor(AuditEventType)`, `auditColorFor(HelmColors, AuditEventType)`, `auditTitleFor(AuditEvent, AppLocalizations)`, `auditEntityLabel(AuditEntityType, AppLocalizations)`. Create that file as the first step of this task (it is a pure move — no behavior change) and a small test asserting one icon + one title mapping. The old screen will switch to these in Task 8.

- [ ] **Step 1: Create the shared presentation mapping + its test**

```dart
// lib/features/audit_log/presentation/utils/audit_event_presentation.dart
import 'package:flutter/material.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/l10n/app_localizations.dart';

IconData auditIconFor(AuditEventType type) {
  switch (type) {
    case AuditEventType.created:
      return Icons.add_circle_outline;
    case AuditEventType.updated:
      return Icons.edit_outlined;
    case AuditEventType.deleted:
      return Icons.delete_outline;
    case AuditEventType.confirmed:
      return Icons.check_circle_outline;
    case AuditEventType.exported:
      return Icons.upload_outlined;
    case AuditEventType.unknown:
      return Icons.help_outline;
  }
}

Color auditColorFor(HelmColors colors, AuditEventType type) {
  switch (type) {
    case AuditEventType.created:
      return colors.stateSafe;
    case AuditEventType.updated:
      return colors.interactive;
    case AuditEventType.deleted:
      return colors.stateAtRisk;
    case AuditEventType.confirmed:
      return colors.stateSafe;
    case AuditEventType.exported:
      return colors.stateTight;
    case AuditEventType.unknown:
      return colors.inkTertiary;
  }
}

String auditEntityLabel(AuditEntityType type, AppLocalizations l10n) {
  switch (type) {
    case AuditEntityType.income:
      return l10n.auditEntityIncome;
    case AuditEntityType.transaction:
      return l10n.auditEntityTransaction;
    case AuditEntityType.stsSettings:
      return l10n.auditEntitySettings;
    case AuditEntityType.fixedCost:
      return l10n.auditEntityFixedCost;
    case AuditEntityType.unknown:
      return l10n.auditEntityRecord;
  }
}

String auditTitleFor(AuditEvent event, AppLocalizations l10n) {
  final entityLabel = auditEntityLabel(event.entityType, l10n);
  switch (event.eventType) {
    case AuditEventType.created:
      return l10n.auditEventAdded(entityLabel);
    case AuditEventType.updated:
      return l10n.auditEventUpdated(entityLabel);
    case AuditEventType.deleted:
      return l10n.auditEventDeleted(entityLabel);
    case AuditEventType.confirmed:
      return l10n.auditEventConfirmed(entityLabel);
    case AuditEventType.exported:
      return l10n.auditEventExported(entityLabel);
    case AuditEventType.unknown:
      return l10n.auditEventChanged(entityLabel);
  }
}
```

```dart
// test/features/audit_log/presentation/audit_event_presentation_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/utils/audit_event_presentation.dart';

void main() {
  test('icon mapping covers created', () {
    expect(auditIconFor(AuditEventType.created), Icons.add_circle_outline);
  });
}
```

- [ ] **Step 2: Write the failing sheet widget test**

```dart
// test/features/audit_log/presentation/audit_event_detail_sheet_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/widgets/audit_event_detail_sheet.dart';
import 'package:helm/l10n/app_localizations.dart';

void main() {
  testWidgets('shows before and after values', (tester) async {
    final event = AuditEvent(
      id: 'a',
      timestamp: DateTime(2026, 6, 1, 10, 30),
      eventType: AuditEventType.updated,
      entityType: AuditEntityType.income,
      entityId: 'e1',
      previousValue: 'OLD-123',
      newValue: 'NEW-456',
      description: 'Amount changed',
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          supportedLocales: const [Locale('en'), Locale('bn')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(body: AuditEventDetailSheet(event: event)),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('OLD-123'), findsOneWidget);
    expect(find.text('NEW-456'), findsOneWidget);
    expect(find.text('Amount changed'), findsOneWidget);
  });
}
```

- [ ] **Step 3: Run test to verify it fails**

Run: `fvm flutter test test/features/audit_log/presentation/audit_event_detail_sheet_test.dart`
Expected: FAIL — widget not found.

- [ ] **Step 4: Write the sheet widget**

```dart
// lib/features/audit_log/presentation/widgets/audit_event_detail_sheet.dart
//
// Modal detail for one audit event: description, before→after diff, record hash.
// Convention mirrors confirm_received_sheet.dart.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:helm/features/audit_log/presentation/utils/audit_event_presentation.dart';
import 'package:helm/l10n/app_localization.dart';

class AuditEventDetailSheet extends ConsumerWidget {
  const AuditEventDetailSheet({super.key, required this.event});

  final AuditEvent event;

  static Future<void> show(BuildContext context, AuditEvent event) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(HelmSpacing.sheetTopRadius),
        ),
      ),
      builder: (_) => AuditEventDetailSheet(event: event),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;
    final dash = '—';

    final hashAsync = ref.watch(_eventHashProvider(event.id));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(HelmSpacing.s5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(auditIconFor(event.eventType),
                    color: auditColorFor(colors, event.eventType),
                    size: HelmSpacing.iconLg),
                const SizedBox(width: HelmSpacing.s2),
                Expanded(
                  child: Text(auditTitleFor(event, l10n),
                      style: typo.headingSm.copyWith(color: colors.inkPrimary)),
                ),
              ],
            ),
            const SizedBox(height: HelmSpacing.s4),
            _row(typo, colors, l10n.auditDetailEntity,
                auditEntityLabel(event.entityType, l10n)),
            _row(typo, colors, l10n.auditDetailTimestamp,
                DateFormat('MMM d, yyyy · h:mm a').format(event.timestamp)),
            if (event.description.isNotEmpty)
              _row(typo, colors, l10n.auditDetailDescription, event.description),
            const SizedBox(height: HelmSpacing.s3),
            Divider(color: colors.divider, height: 1),
            const SizedBox(height: HelmSpacing.s3),
            _monoRow(typo, colors, l10n.auditDetailBefore,
                event.previousValue ?? dash),
            const SizedBox(height: HelmSpacing.s2),
            _monoRow(typo, colors, l10n.auditDetailAfter,
                event.newValue ?? dash),
            const SizedBox(height: HelmSpacing.s3),
            _monoRow(typo, colors, l10n.auditDetailRecordHash,
                hashAsync.maybeWhen(
                    data: (h) => h ?? dash, orElse: () => dash)),
          ],
        ),
      ),
    );
  }

  Widget _row(HelmTypography typo, HelmColors colors, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HelmSpacing.s2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: typo.labelSm.copyWith(color: colors.inkTertiary)),
          const SizedBox(height: HelmSpacing.s1),
          Text(value, style: typo.bodyMd.copyWith(color: colors.inkPrimary)),
        ],
      ),
    );
  }

  Widget _monoRow(
      HelmTypography typo, HelmColors colors, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: typo.labelSm.copyWith(color: colors.inkTertiary)),
        const SizedBox(height: HelmSpacing.s1),
        Text(value,
            style: typo.monoFinancialSm.copyWith(color: colors.inkSecondary)),
      ],
    );
  }
}

/// Resolves the stored hash for one event id.
final _eventHashProvider =
    FutureProvider.family<String?, String>((ref, eventId) async {
  final service = ref.read(auditChainServiceProvider);
  return service.hashFor(eventId);
});
```

- [ ] **Step 5: Run tests + analyze**

Run: `fvm flutter test test/features/audit_log/presentation/audit_event_detail_sheet_test.dart test/features/audit_log/presentation/audit_event_presentation_test.dart`
Expected: PASS. Then `fvm dart analyze` → 0/0/0.

- [ ] **Step 6: Commit**

```bash
git add lib/features/audit_log/presentation/utils/audit_event_presentation.dart lib/features/audit_log/presentation/widgets/audit_event_detail_sheet.dart test/features/audit_log/presentation/audit_event_presentation_test.dart test/features/audit_log/presentation/audit_event_detail_sheet_test.dart
git commit -m "feat(audit): add event detail sheet + shared presentation mapping

- AuditEventDetailSheet: description, before→after diff, record hash
- extracted auditIconFor/auditColorFor/auditTitleFor/auditEntityLabel
- dart analyze clean"
```

---

### Task 6: Ledger-integrity strip (`LedgerIntegrityStrip`)

**Files:**
- Create: `lib/features/audit_log/presentation/widgets/ledger_integrity_strip.dart`
- Test: `test/features/audit_log/presentation/ledger_integrity_strip_test.dart`

**Interfaces:**
- Consumes: `auditIntegrityProvider` (Task 4), `ChainVerification`, l10n (Task 3).
- Produces: `class LedgerIntegrityStrip extends ConsumerWidget`.

- [ ] **Step 1: Write the failing test (override the provider for each state)**

```dart
// test/features/audit_log/presentation/ledger_integrity_strip_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/audit_log/data/services/audit_chain_service.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:helm/features/audit_log/presentation/widgets/ledger_integrity_strip.dart';
import 'package:helm/l10n/app_localizations.dart';

Widget _host(Override override) => ProviderScope(
      overrides: [override],
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('bn')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const Scaffold(body: LedgerIntegrityStrip()),
      ),
    );

void main() {
  testWidgets('intact → verified copy with count', (tester) async {
    await tester.pumpWidget(_host(
      auditIntegrityProvider.overrideWith((ref) async =>
          const ChainVerification(isIntact: true, verifiedCount: 4)),
    ));
    await tester.pump();
    expect(find.textContaining('4'), findsOneWidget);
    expect(find.textContaining('verified'), findsOneWidget);
  });

  testWidgets('broken → issue copy', (tester) async {
    await tester.pumpWidget(_host(
      auditIntegrityProvider.overrideWith((ref) async =>
          const ChainVerification(
              isIntact: false, verifiedCount: 1, firstBrokenEventId: 'b')),
    ));
    await tester.pump();
    expect(find.textContaining('Integrity issue'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/features/audit_log/presentation/ledger_integrity_strip_test.dart`
Expected: FAIL — widget not found.

- [ ] **Step 3: Write the strip widget**

```dart
// lib/features/audit_log/presentation/widgets/ledger_integrity_strip.dart
//
// Verify-on-open integrity indicator for the History tab.
// Fails loud: any error renders as the issue state, never a false "verified".

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:helm/l10n/app_localization.dart';

class LedgerIntegrityStrip extends ConsumerWidget {
  const LedgerIntegrityStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;
    final state = ref.watch(auditIntegrityProvider);

    return state.when(
      loading: () => _bar(colors, typo, Icons.hourglass_empty,
          colors.inkTertiary, l10n.ledgerVerifying),
      error: (_, __) => _bar(colors, typo, Icons.warning_amber_rounded,
          colors.stateAtRisk, l10n.ledgerIntegrityIssue),
      data: (result) => result.isIntact
          ? _bar(colors, typo, Icons.verified_outlined, colors.stateSafe,
              l10n.ledgerVerified(result.verifiedCount))
          : _bar(colors, typo, Icons.warning_amber_rounded, colors.stateAtRisk,
              l10n.ledgerIntegrityIssue),
    );
  }

  Widget _bar(HelmColors colors, HelmTypography typo, IconData icon,
      Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: HelmSpacing.s3),
      child: Row(
        children: [
          Icon(icon, size: HelmSpacing.iconSm, color: color),
          const SizedBox(width: HelmSpacing.s2),
          Expanded(
            child: Text(label, style: typo.labelMd.copyWith(color: color)),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test + analyze**

Run: `fvm flutter test test/features/audit_log/presentation/ledger_integrity_strip_test.dart`
Expected: PASS. Then `fvm dart analyze` → 0/0/0.

- [ ] **Step 5: Commit**

```bash
git add lib/features/audit_log/presentation/widgets/ledger_integrity_strip.dart test/features/audit_log/presentation/ledger_integrity_strip_test.dart
git commit -m "feat(audit): add ledger integrity strip (verify-on-open, fails loud)

- watches auditIntegrityProvider; verified/issue/loading states
- dart analyze clean"
```

---

### Task 7: Event card (`AuditEventCard`)

**Files:**
- Create: `lib/features/audit_log/presentation/widgets/audit_event_card.dart`
- Test: `test/features/audit_log/presentation/audit_event_card_test.dart`

**Interfaces:**
- Consumes: `AuditEvent`, shared mapping (Task 5), `relativeTimeLabel` (Task 2), l10n (Task 3), `AuditEventDetailSheet.show` (Task 5).
- Produces: `class AuditEventCard extends StatelessWidget { final AuditEvent event; }`.

- [ ] **Step 1: Write the failing test**

```dart
// test/features/audit_log/presentation/audit_event_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/widgets/audit_event_card.dart';
import 'package:helm/l10n/app_localizations.dart';

void main() {
  testWidgets('tapping a card opens the detail sheet', (tester) async {
    final event = AuditEvent(
      id: 'a',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      eventType: AuditEventType.created,
      entityType: AuditEntityType.income,
      entityId: 'e1',
      newValue: 'NEW-1',
      description: 'Added income',
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          supportedLocales: const [Locale('en'), Locale('bn')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(body: AuditEventCard(event: event)),
        ),
      ),
    );
    await tester.tap(find.byType(AuditEventCard));
    await tester.pumpAndSettle();
    // The sheet shows the description.
    expect(find.text('Added income'), findsWidgets);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/features/audit_log/presentation/audit_event_card_test.dart`
Expected: FAIL — widget not found.

- [ ] **Step 3: Write the card widget**

```dart
// lib/features/audit_log/presentation/widgets/audit_event_card.dart
//
// Tappable Paper Ledger card for one audit event. Opens AuditEventDetailSheet.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/utils/audit_event_presentation.dart';
import 'package:helm/features/audit_log/presentation/utils/audit_history_grouping.dart';
import 'package:helm/features/audit_log/presentation/widgets/audit_event_detail_sheet.dart';
import 'package:helm/l10n/app_localization.dart';

class AuditEventCard extends StatelessWidget {
  const AuditEventCard({super.key, required this.event});

  final AuditEvent event;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;

    return InkWell(
      borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
      onTap: () => AuditEventDetailSheet.show(context, event),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
          border: Border.all(color: colors.divider, width: HelmSpacing.cardBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.all(HelmSpacing.s3),
          child: Row(
            children: [
              Icon(auditIconFor(event.eventType),
                  color: auditColorFor(colors, event.eventType),
                  size: HelmSpacing.iconMd),
              const SizedBox(width: HelmSpacing.s3),
              Expanded(
                child: Text(auditTitleFor(event, l10n),
                    style: typo.bodyMd
                        .copyWith(color: colors.inkPrimary, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(width: HelmSpacing.s2),
              Text(_relative(context, l10n),
                  style: typo.labelSm.copyWith(color: colors.inkTertiary)),
            ],
          ),
        ),
      ),
    );
  }

  String _relative(BuildContext context, AppLocalizations l10n) {
    final token = relativeTimeLabel(event.timestamp, DateTime.now());
    if (token == 'justNow') return l10n.auditRelativeJustNow;
    if (token.startsWith('mAgo:')) {
      return l10n.auditRelativeMinutesAgo(int.parse(token.substring(5)));
    }
    if (token.startsWith('hAgo:')) {
      return l10n.auditRelativeHoursAgo(int.parse(token.substring(5)));
    }
    return DateFormat('MMM d').format(event.timestamp);
  }
}
```

- [ ] **Step 4: Run test + analyze**

Run: `fvm flutter test test/features/audit_log/presentation/audit_event_card_test.dart`
Expected: PASS. Then `fvm dart analyze` → 0/0/0.

- [ ] **Step 5: Commit**

```bash
git add lib/features/audit_log/presentation/widgets/audit_event_card.dart test/features/audit_log/presentation/audit_event_card_test.dart
git commit -m "feat(audit): add tappable Paper Ledger event card

- icon + title + relative time; opens AuditEventDetailSheet on tap
- dart analyze clean"
```

---

### Task 8: Reskin `AuditLogScreen` (compose strip + grouped cards + footer)

**Files:**
- Modify: `lib/features/audit_log/presentation/views/audit_log_screen.dart`
- Test: `test/features/audit_log/presentation/audit_log_screen_test.dart`

**Interfaces:**
- Consumes: `auditEventsProvider`, `groupByRecency` + `HistoryBucket` (Task 2), `LedgerIntegrityStrip` (Task 6), `AuditEventCard` (Task 7), shared mapping (Task 5, replacing the deleted private helpers), `kAuditRetentionDays`, l10n (Task 3).

- [ ] **Step 1: Write the failing widget test**

```dart
// test/features/audit_log/presentation/audit_log_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:helm/features/audit_log/presentation/views/audit_log_screen.dart';
import 'package:helm/features/audit_log/presentation/widgets/audit_event_card.dart';
import 'package:helm/l10n/app_localizations.dart';

Widget _host(List<Override> overrides) => ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('bn')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const AuditLogScreen(),
      ),
    );

void main() {
  testWidgets('empty state shows empty copy', (tester) async {
    await tester.pumpWidget(_host([
      auditEventsProvider.overrideWith((ref) async => <AuditEvent>[]),
    ]));
    await tester.pump();
    expect(find.byType(AuditEventCard), findsNothing);
  });

  testWidgets('renders grouped cards for events', (tester) async {
    final events = [
      AuditEvent(
        id: 'a',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        eventType: AuditEventType.created,
        entityType: AuditEntityType.income,
        entityId: 'e1',
        description: 'd1',
      ),
      AuditEvent(
        id: 'b',
        timestamp: DateTime.now().subtract(const Duration(days: 10)),
        eventType: AuditEventType.updated,
        entityType: AuditEntityType.transaction,
        entityId: 'e2',
        description: 'd2',
      ),
    ];
    await tester.pumpWidget(_host([
      auditEventsProvider.overrideWith((ref) async => events),
    ]));
    await tester.pump();
    expect(find.byType(AuditEventCard), findsNWidgets(2));
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Earlier'), findsOneWidget);
  });
}
```

> Note: with `auditEventsProvider` overridden, `auditIntegrityProvider` (which `watch`es it) recomputes against the real chain box — which isn't open in this test. The strip will land in its error/loading state and render the issue copy; that's fine for these assertions (we assert on cards + group headers, not the strip). If the strip throws during pump, also override `auditIntegrityProvider` with a stub `ChainVerification(isIntact: true, verifiedCount: 0)` in `_host`.

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/features/audit_log/presentation/audit_log_screen_test.dart`
Expected: FAIL — old screen lacks grouping / `AuditEventCard`.

- [ ] **Step 3: Replace the screen body**

Rewrite `lib/features/audit_log/presentation/views/audit_log_screen.dart`. Delete the old `_AuditEventTile` and all private `_iconFor/_colorFor/_titleFor/_entityLabel/_formatTimestamp` helpers (now provided by Task 5's shared file and the card). New file:

```dart
// lib/features/audit_log/presentation/views/audit_log_screen.dart
//
// History tab — Paper Ledger reskin.
// Integrity strip → date-grouped event cards → retention footer.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_spacing.dart';
import 'package:helm/core/themes/helm_typography.dart';
import 'package:helm/features/audit_log/core/audit_log_constants.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:helm/features/audit_log/presentation/utils/audit_history_grouping.dart';
import 'package:helm/features/audit_log/presentation/widgets/audit_event_card.dart';
import 'package:helm/features/audit_log/presentation/widgets/ledger_integrity_strip.dart';
import 'package:helm/l10n/app_localization.dart';

class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;
    final eventsAsync = ref.watch(auditEventsProvider);

    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: AppBar(
        backgroundColor: colors.canvas,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(l10n.changeHistory,
            style: typo.headingSm.copyWith(color: colors.inkPrimary)),
      ),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _StateMessage(
            icon: Icons.error_outline, message: l10n.auditLogLoadError),
        data: (events) {
          if (events.isEmpty) {
            return _StateMessage(
                icon: Icons.history, message: l10n.auditLogEmpty);
          }
          final groups = groupByRecency(events, DateTime.now());
          return ListView(
            padding: const EdgeInsets.fromLTRB(
                HelmSpacing.screenEdge, 0, HelmSpacing.screenEdge, HelmSpacing.s6),
            children: [
              const LedgerIntegrityStrip(),
              for (final group in groups) ...[
                _GroupHeader(bucket: group.key, count: group.value.length),
                const SizedBox(height: HelmSpacing.s2),
                ...group.value.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: HelmSpacing.s2),
                      child: AuditEventCard(event: e),
                    )),
                const SizedBox(height: HelmSpacing.s3),
              ],
              const SizedBox(height: HelmSpacing.s2),
              Text(
                l10n.historyRetentionNote(kAuditRetentionDays),
                style: typo.labelSm.copyWith(color: colors.inkTertiary),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.bucket, required this.count});
  final HistoryBucket bucket;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    final l10n = context.l10n;
    final label = switch (bucket) {
      HistoryBucket.today => l10n.historyGroupToday,
      HistoryBucket.yesterday => l10n.historyGroupYesterday,
      HistoryBucket.thisWeek => l10n.historyGroupThisWeek,
      HistoryBucket.earlier => l10n.historyGroupEarlier,
    };
    return Row(
      children: [
        Container(width: 3, height: 14, color: colors.inkSecondary),
        const SizedBox(width: HelmSpacing.s2),
        Text(label, style: typo.labelMd.copyWith(color: colors.inkSecondary)),
        const Spacer(),
        Text('$count', style: typo.labelSm.copyWith(color: colors.inkTertiary)),
      ],
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({required this.icon, required this.message});
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.textStyles;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(HelmSpacing.s5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colors.inkTertiary),
            const SizedBox(height: HelmSpacing.s3),
            Text(message,
                style: typo.bodyMd.copyWith(color: colors.inkSecondary),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run tests + analyze**

Run: `fvm flutter test test/features/audit_log/presentation/audit_log_screen_test.dart`
Expected: PASS. Then run the whole audit_log suite + `fvm dart analyze`:
`fvm flutter test test/features/audit_log/ --exclude-tags golden` → green; analyze 0/0/0.

- [ ] **Step 5: Commit**

```bash
git add lib/features/audit_log/presentation/views/audit_log_screen.dart test/features/audit_log/presentation/audit_log_screen_test.dart
git commit -m "feat(audit): reskin History tab to Paper Ledger

- canvas appbar, integrity strip, date-grouped cards, retention footer
- themed loading/error/empty; old ListTile + private helpers removed
- dart analyze clean"
```

---

### Task 9: Golden baselines (light + dark)

**Files:**
- Create: `test/golden/history_golden_test.dart`
- Create: `test/golden/goldens/history_*.png` (generated)

**Interfaces:**
- Consumes: `AuditEventCard`, `LedgerIntegrityStrip` (with overridden provider), the `_GroupHeader` via a small seeded composition, or the full `AuditLogScreen` with overridden providers.

- [ ] **Step 1: Write the golden test (light + dark)**

Mirror `test/golden/dashboard_golden_test.dart`: `@Tags(['golden'])`, `buildTestWidget`/`buildDarkTestWidget` helpers, a fixed reference set of events spanning Today + Earlier, and `auditIntegrityProvider` overridden to an intact result for determinism. Pump the reskinned `AuditLogScreen` inside a `ProviderScope` with overridden `auditEventsProvider` + `auditIntegrityProvider`, and assert against `matchesGoldenFile('goldens/history_light.png')` / `history_dark.png`.

```dart
// test/golden/history_golden_test.dart
@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/audit_log/data/services/audit_chain_service.dart';
import 'package:helm/features/audit_log/domain/entities/audit_event.dart';
import 'package:helm/features/audit_log/presentation/providers/audit_providers.dart';
import 'package:helm/features/audit_log/presentation/views/audit_log_screen.dart';
import 'package:helm/l10n/app_localizations.dart';

final _ref = DateTime(2026, 6, 21, 14, 0);

List<AuditEvent> _events() => [
      AuditEvent(
        id: 'a',
        timestamp: _ref.subtract(const Duration(hours: 1)),
        eventType: AuditEventType.created,
        entityType: AuditEntityType.income,
        entityId: 'e1',
        newValue: '100',
        description: 'Added income',
      ),
      AuditEvent(
        id: 'b',
        timestamp: _ref.subtract(const Duration(days: 12)),
        eventType: AuditEventType.confirmed,
        entityType: AuditEntityType.income,
        entityId: 'e2',
        description: 'Confirmed received',
      ),
    ];

Widget _app(ThemeData theme) => ProviderScope(
      overrides: [
        auditEventsProvider.overrideWith((ref) async => _events()),
        auditIntegrityProvider.overrideWith((ref) async =>
            const ChainVerification(isIntact: true, verifiedCount: 2)),
      ],
      child: MaterialApp(
        theme: theme,
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('bn')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const AuditLogScreen(),
      ),
    );

void main() {
  testWidgets('history light golden', (tester) async {
    await tester.pumpWidget(_app(AppTheme.light));
    await tester.pumpAndSettle();
    await expectLater(find.byType(AuditLogScreen),
        matchesGoldenFile('goldens/history_light.png'));
  });

  testWidgets('history dark golden', (tester) async {
    await tester.pumpWidget(_app(AppTheme.dark));
    await tester.pumpAndSettle();
    await expectLater(find.byType(AuditLogScreen),
        matchesGoldenFile('goldens/history_dark.png'));
  });
}
```

- [ ] **Step 2: Generate baselines**

Run: `fvm flutter test test/golden/history_golden_test.dart --update-goldens`
Expected: creates `test/golden/goldens/history_light.png` + `history_dark.png`.

- [ ] **Step 3: Verify they pass**

Run: `fvm flutter test test/golden/history_golden_test.dart`
Expected: PASS. Then `fvm dart analyze` → 0/0/0.

- [ ] **Step 4: Commit**

```bash
git add test/golden/history_golden_test.dart test/golden/goldens/history_light.png test/golden/goldens/history_dark.png
git commit -m "test(golden): add History tab baselines (light + dark)

- seeded events across Today + Earlier; intact integrity strip
- dart analyze clean"
```

---

### Task 10: Documentation updates

**Files:**
- Modify: `docs/tracking/DECISION_LOG.md`
- Modify: `docs/tracking/PROJECT_STATE.md`
- Modify: `docs/tracking/TASKS.md`
- Modify (if it tracks trust-layer surfacing): `docs/core/ROADMAP.md`

- [ ] **Step 1: Add Decision 041 to `DECISION_LOG.md`**

Append a decision entry in the file's existing format:

> **Decision 041 — History tab brought to Paper Ledger standard + Trust Layer surfaced.**
> `AuditLogScreen` reskinned (canvas appbar, date-grouped tappable cards, themed states). Per-event detail sheet now exposes `description` + before→after diff + record hash (previously discarded). `AuditChainService.verifyChain` added; `auditIntegrityProvider` + `LedgerIntegrityStrip` surface verify-on-open tamper-evidence for the first time, satisfying the Doctrine's non-negotiable Trust Layer. Filters/search/pull-to-refresh deferred. Supersedes the pre–Paper Ledger History UI.

- [ ] **Step 2: Update `PROJECT_STATE.md` + `TASKS.md`**

Record: History tab is now Paper Ledger + trust-surfaced; note Sub-project B complete. Update the test count to the new total (read the actual number from the final run — do **not** hardcode; run `fvm flutter test --exclude-tags golden` and use its reported pass/skip count). Leave historical entries untouched.

- [ ] **Step 3: Update `ROADMAP.md` if applicable**

If the roadmap tracks trust-layer visibility, add a one-line milestone note that audit-chain integrity is now user-visible. If it has no relevant section, skip and say so in the report.

- [ ] **Step 4: Commit**

```bash
git add docs/tracking/DECISION_LOG.md docs/tracking/PROJECT_STATE.md docs/tracking/TASKS.md docs/core/ROADMAP.md
git commit -m "docs(tracking): record Decision 041 (History tab + trust surfacing)"
```

> Stage only the docs files you actually edited; if `ROADMAP.md` was not changed, drop it from the `git add`.

---

## Self-review (against the spec)

- **Spec coverage:** reskin shell (Task 8), date grouping (Tasks 2, 8), event card (Task 7), detail sheet w/ before→after + hash (Task 5), `verifyChain` + provider + strip (Tasks 1, 4, 6), retention footer (Task 8), l10n (Task 3), tests incl. golden (Tasks 1–9), docs (Task 10). All Definition-of-Done items map to a task.
- **Placeholder scan:** every code step contains complete, compilable code; the only intentional latitude is the Task 4 test-setup choice (real boxes vs fakes) and the Task 9 golden seed, both with explicit guidance.
- **Type consistency:** `ChainVerification` fields (`isIntact`, `firstBrokenEventId`, `verifiedCount`) used identically across Tasks 1/4/6/9; `HistoryBucket` values and `groupByRecency` shape consistent between Tasks 2 and 8; shared mapping function names (`auditIconFor`/`auditColorFor`/`auditTitleFor`/`auditEntityLabel`) consistent across Tasks 5/7/8; l10n getter names match between Task 3 and their consumers.

## Execution handoff

Plan saved to `docs/superpowers/plans/2026-06-21-history-tab-paper-ledger-trust.md`.

Recommended execution: **Subagent-Driven Development** — fresh implementer per task, task review (spec + quality) after each, broad whole-branch review at the end. Tasks 1–3 are independent; Tasks 4–10 have real dependencies and run in order.
