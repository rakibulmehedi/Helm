# TDD + Clean Architecture Dispatch — Phase 3: Notification System

> Date: 2026-06-12
> Reference: `docs/planning/100_PERCENT_MASTER_PLAN.md`
> Status: Dispatch plan — implementation not yet started
> Depends on: Phase 2 (Analytics Infrastructure)
> Gate: `flutter_local_notifications` package approval (Chief Architect Decision 026 extension)
> Effort: ~12 hours, 2-3 sprints
> Agent lead: Behavioral Nudge Engine
> Review agents: UX Architect, UI Designer, Brand Guardian, Persona Walkthrough
> Target: Behavioral 76→82, UI/UX: no change

---

## Global TDD Mandate

```
RED: Write failing test → GREEN: Minimal implementation → REFACTOR: Clean architecture guard
```

**Test file convention:** `test/features/<feature>/<layer>/<file>_test.dart` mirrors `lib/` structure.

**Clean architecture gates (universal):**
- No `data/` imports in `presentation/`
- No Flutter/dart imports in `domain/`
- No `Hive.box()` in UI
- No `setState()` for business logic
- `mounted` check after every async gap in stateful widgets
- All domain entities are immutable (`final` fields, no setters)

---

## GROUP 3A — Notification Infrastructure (P3.1–P3.6)

**Files touched (new):**
- `lib/core/notifications/notification_service.dart` (new)
- `lib/main.dart` (modify — plugin init)

**Architecture layer:** New `core/notifications/` service. No domain — pure infrastructure.

### TDD Approach

NotificationService is platform-dependent (`flutter_local_notifications`). Test the Dart interface, mock the native plugin.

```dart
// test/core/notifications/notification_service_test.dart
test('scheduleDailyS2sSummary creates notification at user checkInTime', () async {
  final service = NotificationService(preferences: prefs);
  await service.scheduleDailyS2sSummary();
  // Verify pending notifications contains one at checkInTime
});

test('periodicCheck respects silent hours (10pm-7am)', () async {
  // Fire at 11pm → no notification scheduled
  // Fire at 8am → notification scheduled
});
```

### Implementation

```dart
class NotificationService {
  Future<void> scheduleDailyS2sSummary({required TimeOfDay checkInTime}) async {
    await _plugin.zonedSchedule(
      0,
      'Morning',
      'Your safe-to-spend is ৳X today.',
      _dailyTime(checkInTime),
      const NotificationDetails(android: ..., iOS: ...),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> schedulePeriodicOverdueCheck() async {
    await _plugin.periodicallyShow(
      1,
      'Pipeline check',
      '2 payments are past their expected date.',
      RepeatInterval.everyHour, // filtered by DND in handler
      ...
    );
  }
}
```

### Exit Gate
- [ ] Plugin initializes without crash
- [ ] Daily S2S summary schedules at user's time
- [ ] Periodic check respects DND (10pm-7am) and silent mode
- [ ] Silent mode respected (Cadence.silent → no notifications)

---

## GROUP 3B — Nudge Evaluator Engine (P3.7–P3.13)

**Files touched (new):**
- `lib/core/nudge/nudge_evaluator.dart` (new — Riverpod provider)
- `lib/core/nudge/nudge_rules.dart` (new — rule implementations)
- `lib/core/nudge/nudge_result.dart` (new — evaluation output)

**Architecture layer:** New `core/nudge/` module. Pure Dart domain logic — no Flutter.

### TDD Approach

The NudgeEvaluator is pure Dart logic with no platform dependencies. Fully unit-testable.

```dart
// test/core/nudge/nudge_evaluator_test.dart

test('rules: overdue entries → confirm-oldest nudge', () {
  final result = evaluator.evaluate(
    pipelineState: PipelineState(overdueCount: 3),
    s2sState: S2sState.safe,
    daysSinceLastSession: 1,
  );
  expect(result.nudgeType, equals(NudgeType.confirmOverdue));
  expect(result.priority, equals(NudgePriority.high));
  expect(result.targetEntryId, equals(oldestOverdueEntry.id));
});

test('rules: S2S at risk + 0 overdue → review-fixed-costs nudge', () {
  final result = evaluator.evaluate(
    pipelineState: PipelineState(overdueCount: 0),
    s2sState: S2sState.atRisk,
  );
  expect(result.nudgeType, equals(NudgeType.reviewFixedCosts));
  expect(result.channel, equals(Channel.inAppOnly)); // never push for at-risk
});

test('rules: 3+ days no session → re-engagement nudge', () {
  final result = evaluator.evaluate(
    daysSinceLastSession: 4,
  );
  expect(result.nudgeType, equals(NudgeType.reEngagement));
  expect(result.priority, equals(NudgePriority.low));
});

test('rules: 7+ days consistent tracking + 0 overdue → quiet affirmation (no push)', () {
  final result = evaluator.evaluate(
    pipelineState: PipelineState(overdueCount: 0),
    trackingStreak: 7,
  );
  expect(result.nudgeType, equals(NudgeType.quietAffirmation));
  expect(result.channel, equals(Channel.none));
});

test('rules: pipeline up to date + S2S safe → relief signal (no push)', () {
  final result = evaluator.evaluate(
    pipelineState: PipelineState(overdueCount: 0, totalEntries: 5),
    s2sState: S2sState.safe,
    trackingStreak: 14,
  );
  expect(result.nudgeType, equals(NudgeType.reliefSignal));
});

test('rules: no conditions met → no nudge', () {
  final result = evaluator.evaluate(
    pipelineState: PipelineState(overdueCount: 0, totalEntries: 0),
    s2sState: S2sState.noData,
    daysSinceLastSession: 0,
  );
  expect(result.nudgeType, isNull);
});
```

### Implementation

```dart
class NudgeEvaluator {
  final NudgePreferences _prefs;
  final PipelineRepository _pipelineRepo;
  final SafeToSpendRepository _stsRepo;

  NudgeResult? evaluate() {
    final pipeline = _pipelineRepo.getState();
    final s2s = _stsRepo.getCurrent();

    // Rule priority order (first match wins)
    if (pipeline.overdueCount > 0) return _confirmOverdue(pipeline);
    if (s2s.state == S2sState.atRisk) return _reviewCosts(s2s);
    if (pipeline.isClean && s2s.state == S2sState.safe) return _reliefSignal();
    if (_daysSinceLastSession > 3) return _reEngagement();
    if (trackingStreak >= 7) return _quietAffirmation(trackingStreak);
    return null;
  }
}
```

### Exit Gate
- [ ] 12+ nudge evaluator tests pass (all rule conditions + edge cases)
- [ ] Evaluator is pure Dart (no Flutter imports)
- [ ] NudgeType enum defined: confirmOverdue, reviewFixedCosts, reEngagement, quietAffirmation, reliefSignal
- [ ] Channel enum: push, inAppOnly, none

---

## GROUP 3C — In-App Notification Center (P3.14–P3.18)

**Files touched:**
- `lib/features/notifications/presentation/views/notification_center_screen.dart` (new)
- `lib/features/notifications/data/nudge_log_model.dart` (new — Hive TypeAdapter)
- `lib/features/notifications/domain/nudge_log_entry.dart` (new)
- `lib/features/settings/presentation/views/settings_screen.dart` (modify — badge + link)
- `lib/config/router/app_router.dart` (modify — add route)
- `lib/config/router/route_names.dart` (modify — add name)

### TDD Approach

```dart
// test/features/notifications/domain/nudge_log_entry_test.dart
test('NudgeLogEntry stores read status, type, timestamp, body, actionUrl', () { ... });

// test/features/notifications/presentation/notification_center_test.dart
testWidgets('groups by date: Today / Yesterday / This Week / Older', (tester) async {
  await tester.pumpWidget(NotificationCenterScreen(entries: testEntries));
  expect(find.text('Today'), findsOneWidget);
  expect(find.text('Yesterday'), findsOneWidget);
});

testWidgets('unread entries show blue dot', (tester) async { ... });

testWidgets('swipe-to-dismiss removes entry with undo snackbar', (tester) async {
  await tester.fling(find.byType(Dismissible), const Offset(-500, 0), 1000);
  await tester.pumpAndSettle();
  expect(find.text('Removed'), findsOneWidget);
});

testWidgets('tap notification navigates to correct screen', (tester) async { ... });
```

### Exit Gate
- [ ] 6+ notification center tests pass
- [ ] Settings badge shows unread count
- [ ] Swipe-to-dismiss with undo works
- [ ] Tap-to-navigate targets correct screen
- [ ] `dart analyze` 0/0/0

---

## GROUP 3D — Nudge Copy (P3.19–P3.25)

**Review gate:** All copy reviewed by Brand Guardian BEFORE implementation. Persona Walkthrough validates Rafiq's emotional response.

Copy designed in Helm voice: clinical-warm, factual, consequence-aware. No exclamation marks. No emoji. No "great job" / "amazing" / comparative language.

| # | Copy | Context | Channel |
|---|---|---|---|
| P3.19 | "Morning. Your safe-to-spend is ৳X today." | Daily S2S | Push |
| P3.20 | "This week: ৳X received, ৳Y safe. 2 payments confirmed." | Weekly summary | Push |
| P3.21 | "A payment from [Client] was expected [date]. Confirm or update?" | Overdue single | Push |
| P3.22 | "2 payments are past their expected date. Tap to review." | Overdue multiple | Push |
| P3.23 | "Your safe-to-spend is tighter than usual. Review fixed costs?" | S2S at risk | In-app only |
| P3.24 | "Your safety buffer is empty. Rebuilding it protects next month." | Buffer depleted | In-app only |
| P3.25 | "Haven't seen you in a few days. Your pipeline has 2 updates." | Re-engagement | Push |

### Exit Gate
- [ ] All 7 copy strings reviewed by Brand Guardian
- [ ] Persona Walkthrough: Rafiq doesn't feel anxious, patronized, or spammed
- [ ] No emoji, exclamation marks, or comparative language in any nudge

---

## GROUP 3E — Nudge Effectiveness Tracking (P3.26–P3.30)

### TDD Approach

```dart
// test/core/analytics/nudge_event_logger_test.dart
test('NUDGE_SENT logged when notification delivered', () {
  logger.logNudgeSent(nudgeId: 'n-001', type: 'daily_s2s', channel: 'push');
  final events = logger.getEventsForNudge('n-001');
  expect(events.first.status, equals('SENT'));
});

test('NUDGE_ACTIONED logged when user acts within 30 min', () { ... });
test('NUDGE_DISMISSED logged when user dismisses without acting', () { ... });
```

**Effectiveness report format:**
```
[NUDGE_REPORT]
  daily_s2s:  sent=14  opened=11  actioned=8  dismissRate=21%  actionRate=57%
  overdue:    sent=3   opened=3   actioned=2  dismissRate=0%   actionRate=67%
  re_engage:  sent=2   opened=1   actioned=0  dismissRate=50%  actionRate=0%
```

### Exit Gate
- [ ] 4 NUDGE_* events logged correctly
- [ ] Effectiveness report renders
- [ ] `actionRate = actioned / opened`

---

## Phase 3 Exit Gate

```
[ ] 25+ new tests pass
[ ] Daily S2S push fires at user's check-in time
[ ] Overdue notifications fire when entries pass expected date
[ ] Notification center shows grouped, actionable history
[ ] Nudge evaluator produces correct nudge type for all 6 rule conditions
[ ] All nudge copy reviewed by Brand Guardian + Persona Walkthrough
[ ] Nudge effectiveness tracks SENT/OPENED/DISMISSED/ACTIONED
[ ] flutter_local_notifications package approved (Decision 026 extension)
[ ] dart analyze 0/0/0
```

## Score projection after Phase 3

| Dimension | Before | After | Delta |
|---|---|---|---|
| Cadence & personalization | 50 | 75 | +25 (notifications + adaptive) |
| Nudge delivery mechanisms | 20 | 80 | +60 (push + in-app + scheduled) |
| Analytics & behavioral data | 70 | 80 | +10 (nudge tracking) |
| Celebration & reinforcement | 35 | 50 | +15 (relief signals + quiet affirms) |
| **Behavioral Total** | **76** | **82** | **+6** |
| **UI/UX Total** | **89** | **89** | — |
