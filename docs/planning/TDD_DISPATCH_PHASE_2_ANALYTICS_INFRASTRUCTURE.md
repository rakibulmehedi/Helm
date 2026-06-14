# TDD + Clean Architecture Dispatch — Phase 2: Analytics Infrastructure

> Date: 2026-06-12
> Reference: `docs/planning/100_PERCENT_MASTER_PLAN.md`
> Status: Dispatch plan — implementation not yet started
> Depends on: Phase 1 (Behavioral Foundation)
> Effort: ~8 hours, 1-2 sprints
> Agent lead: UX Architect
> Review agents: Behavioral Nudge Engine, UI Designer, Persona Walkthrough
> Target: Behavioral 68→76, UI/UX 83→89

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

## GROUP 2A — Hive Event Persistence (P2.1–P2.7)

**Files touched (new):**
- `lib/core/analytics/models/analytics_event_model.dart` (new — HiveObject)
- `lib/core/analytics/domain/analytics_event_entity.dart` (new — pure domain)
- `lib/core/analytics/data/analytics_local_data_source.dart` (new — Hive box ops)
- `lib/core/analytics/data/analytics_repository_impl.dart` (new — implements contract)
- `lib/core/analytics/domain/analytics_repository.dart` (new — abstract contract)
- `lib/core/analytics/analytics_service.dart` (modify — dual-write)
- `lib/core/constants/app_box_names.dart` (modify — add box name)

**Architecture layer:** New `core/analytics/` sub-feature with full clean architecture (domain/data separation).

### TDD Approach

**Step 1 — Domain entity (pure Dart, no framework):**
```dart
// test/core/analytics/domain/analytics_event_entity_test.dart
test('AnalyticsEventEntity stores eventName, timestamp, properties', () {
  final entity = AnalyticsEventEntity(
    eventName: 'sts_viewed',
    timestamp: DateTime(2026, 6, 12, 10, 30),
    properties: {'screen': 'dashboard'},
  );
  expect(entity.eventName, equals('sts_viewed'));
  expect(entity.timestamp.isUtc, isTrue);
  expect(entity.properties['screen'], equals('dashboard'));
});

test('entities with same values are equal', () {
  final a = AnalyticsEventEntity(eventName: 'x', timestamp: now, properties: {});
  final b = AnalyticsEventEntity(eventName: 'x', timestamp: now, properties: {});
  expect(a, equals(b));
});
```

**Step 2 — Repository contract (abstract):**
```dart
// test/core/analytics/domain/analytics_repository_test.dart
// Test contract expectations — will fail until concrete implementation exists
```

**Step 3 — Hive model + data source:**
```dart
// test/core/analytics/data/analytics_local_data_source_test.dart
// Requires Hive.init() in setUp (Hive can run headless in tests)
test('persists AnalyticsEventModel to Hive box and retrieves it', () async {
  final ds = AnalyticsLocalDataSource();
  await ds.save(AnalyticsEventEntity(...));
  final events = await ds.getEventsSince(DateTime.now().subtract(Duration(hours: 1)));
  expect(events.length, equals(1));
});
```

**Step 4 — Repository implementation:**
```dart
// test/core/analytics/data/analytics_repository_impl_test.dart
test('repository delegates save to data source', () async { ... });
test('getEventsSince filters by timestamp', () async { ... });
test('getEventCount counts matching events', () async { ... });
test('getLastEventOf retrieves most recent event by name', () async { ... });
```

**Step 5 — Dual-write in AnalyticsService:**
```dart
// test/core/analytics/analytics_service_dual_write_test.dart
test('LocalAnalyticsService writes to Hive AND debugPrint', () async {
  final service = LocalAnalyticsService(repository: mockRepo);
  service.trackEvent('test_event', properties: {'k': 'v'});
  verify(mockRepo.save(argThat(hasEventName('test_event')))).called(1);
});
```

**Step 6 — Session dedup (P2.6):**
```dart
// test/core/analytics/analytics_session_dedup_test.dart
test('daily_active_session fires only once per calendar day', () async {
  // Fire at 10:00 → event recorded
  // Fire again at 14:00 on same day → event NOT recorded
  // Fire at 09:00 next day → event recorded
});
```

### Implementation Notes

**P2.1 — AnalyticsEvent Hive TypeAdapter:**
```dart
@HiveType(typeId: 6) // next available — check HIVE_TYPEID_REGISTRY.md
class AnalyticsEventModel extends HiveObject {
  @HiveField(0) final String eventName;
  @HiveField(1) final DateTime timestamp;
  @HiveField(2) final Map<String, String> properties;

  AnalyticsEventEntity toEntity() => AnalyticsEventEntity(
    eventName: eventName,
    timestamp: timestamp,
    properties: properties,
  );
}
```

**P2.3 — Dual-write modification:**
```dart
// In LocalAnalyticsService.trackEvent():
if (kDebugMode) debugPrint('[BETA_EVENT] $name$propsStr');
_repository.save(AnalyticsEventEntity(
  eventName: name,
  timestamp: DateTime.now().toUtc(),
  properties: properties?.map((k, v) => MapEntry(k, v.toString())) ?? {},
));
```

**P2.5 — NudgeEventLogger:**
```dart
class NudgeEventLogger {
  const NudgeEventLogger({required AnalyticsRepository repository}) : _repo = repository;

  void logNudgeSent(String nudgeId, String type, String channel) { ... }
  void logNudgeOpened(String nudgeId) { ... }
  void logNudgeDismissed(String nudgeId, DismissReason reason) { ... }
  void logNudgeActioned(String nudgeId, String action, Duration timeToAction) { ... }
}
```

### Exit Gate
- [ ] 12+ new tests pass (entity, contract, model, data source, repo impl, dual-write, session dedup, query methods)
- [ ] Events survive app restart (Hive persistence verified)
- [ ] `getEventsSince()` returns correct filtered results
- [ ] `daily_active_session` dedup works (SharedPrefs date flag)
- [ ] `dart analyze` 0/0/0

---

## GROUP 2B — Next-Best-Action Card (P2.8–P2.11)

**Files touched (new):**
- `lib/core/widgets/next_best_action_card.dart` (new — shared widget)
- `lib/features/dashboard/presentation/views/dashboard_screen.dart` (modify — insert in reality stack: Tier 3 maintenance slot)

**Architecture layer:** Core widget. Dashboard wires via providers.

### TDD Approach

```dart
// test/core/widgets/next_best_action_card_test.dart

// Variant 1: Overdue
testWidgets('shows overdue variant when pipeline has overdue entries', (tester) async {
  await tester.pumpWidget(ProviderScope(child: MaterialApp(
    home: NextBestActionCard(variant: ActionVariant.overdue, count: 2, ...),
  )));
  expect(find.textContaining('2 payments overdue'), findsOneWidget);
  expect(find.textContaining('Review'), findsOneWidget);
});

// Variant 2: S2S at risk
testWidgets('shows at-risk variant when S2S is tight', (tester) async { ... });

// Variant 3: Pipeline fully up to date (relief signal)
testWidgets('shows relief variant when 0 overdue AND S2S safe', (tester) async { ... });

// Variant 4: No data / onboarding not complete
testWidgets('shows setup variant when no pipeline entries exist', (tester) async { ... });

// Semantics (P2.11)
testWidgets('Semantics announces overdue count and action button', (tester) async {
  final semantics = tester.getSemantics(find.byType(NextBestActionCard));
  expect(semantics.label, contains('2 payments overdue'));
  expect(semantics.label, contains('Button: Review'));
});
```

### Implementation

**4 variants, 1 widget:**

| Variant | Trigger | Title | CTA | Visual State |
|---------|---------|-------|-----|-------------|
| `overdue` | pipeline has overdue entries | "2 payments overdue" | "Review" → nav to pipeline | `stateAtRisk` tint |
| `atRisk` | S2S raw ≤ 0, 0 overdue | "Safe-to-spend is tight" | "Review fixed costs" → settings | `stateTight` tint |
| `relief` | 0 overdue, S2S > 0 | "Pipeline up to date" | (no CTA — passive relief) | `stateSafe` tint |
| `setup` | 0 pipeline entries, onboarding done | "Add your first expected payment" | "Add payment" → add-income | `interactive` tint |

**Placement:** Reality Stack Tier 3 (`maintenanceTier` slot). The slot already exists in `HelmRealityStack` — just pass the card as `maintenanceTier`.

### Exit Gate
- [ ] 5 widget tests pass (4 variants + Semantics)
- [ ] Dashboard shows correct variant based on pipeline + S2S state
- [ ] Relief variant uses `stateSafe` colors (not celebration)
- [ ] `dart analyze` 0/0/0

---

## GROUP 2C — Semantics Coverage (P2.12–P2.17)

**Files touched:** FAB, bottom nav, forms, TextFormFields, switches, sliders — across all feature screens.

### TDD Approach

```dart
testWidgets('FAB has semantic label', (tester) async {
  await tester.pumpWidget(DashboardScreen());
  final fab = find.byType(FloatingActionButton);
  expect(tester.getSemantics(fab).label, contains('Add'));
});

testWidgets('bottom nav items have semantic labels', (tester) async {
  expect(tester.getSemantics(find.text('Home')).label, isNotNull);
  expect(tester.getSemantics(find.text('Pipeline')).label, isNotNull);
  expect(tester.getSemantics(find.text('Settings')).label, isNotNull);
});

testWidgets('slider has semantic label with current value', (tester) async {
  // tax rate slider: "Tax rate: 10%"
  // buffer slider: "Safety buffer: 15%"
});
```

**Coverage checklist:**

| # | Element | Screen | Semantic Label Pattern |
|---|---------|--------|----------------------|
| P2.12 | FAB (+) | Dashboard | "Add income entry" |
| P2.13 | Bottom nav: Home | All | "Dashboard" |
| P2.13 | Bottom nav: Pipeline | All | "Income pipeline" |
| P2.13 | Bottom nav: Settings | All | "Settings and preferences" |
| P2.14 | Save buttons | Add Income, Add Transaction, STS Settings | "Save changes" / "Confirm" |
| P2.15 | TextFormFields | Onboarding (all 6), Add Income, STS Settings | Per-field purpose |
| P2.16 | Toggle switches | Income entry (exclude), Settings | "Exclude from Safe-to-Spend: on" |
| P2.17 | Sliders | STS Settings (tax rate, buffer) | "Tax rate: 10%" |

### Exit Gate
- [ ] 8+ Semantics tests pass (1 per element type)
- [ ] All interactive elements have Semantics labels
- [ ] `dart analyze` 0/0/0

---

## GROUP 2D — Cadence Preference Discovery (P2.18–P2.21)

**Files touched (new):**
- `lib/core/analytics/domain/nudge_preferences_entity.dart` (new)
- `lib/core/analytics/data/nudge_preferences_model.dart` (new — Hive TypeAdapter)
- `lib/features/settings/presentation/views/cadence_preference_sheet.dart` (new)
- `lib/features/settings/presentation/views/settings_screen.dart` (modify — add "Notifications" link)
- `lib/features/onboarding/presentation/views/onboarding_screen.dart` (modify — show preference sheet after onboarding)

### TDD Approach

```dart
// test/core/analytics/domain/nudge_preferences_entity_test.dart
test('default preferences: daily, 9am, push+in-app enabled, quiet affirmations on', () {
  final prefs = NudgePreferencesEntity.defaults();
  expect(prefs.cadence, equals(Cadence.daily));
  expect(prefs.checkInTime, equals(const TimeOfDay(hour: 9, minute: 0)));
  expect(prefs.pushEnabled, isTrue);
  expect(prefs.inAppEnabled, isTrue);
  expect(prefs.quietAffirmationsEnabled, isTrue);
});
```

```dart
// test/features/settings/presentation/cadence_preference_sheet_test.dart
testWidgets('shows daily/weekly/silent radio options', (tester) async { ... });
testWidgets('time picker opens when daily is selected', (tester) async { ... });
testWidgets('persists preferences to Hive on save', (tester) async { ... });
testWidgets('Settings screen has Notifications section', (tester) async { ... });
```

### Implementation

**CadencePreferenceSheet design:**
```
┌─────────────────────────────────┐
│  Notification Preferences       │
├─────────────────────────────────┤
│                                 │
│  Cadence                        │
│  ○ Daily  ○ Weekly  ◎ Silent   │
│                                 │
│  Check-in time (if daily)       │
│  [  9:00 AM  ▼  ]              │
│                                 │
│  Channels                       │
│  [✓] Push notifications         │
│  [✓] In-app notifications       │
│  [✓] Quiet affirmations         │
│                                 │
│  [  Save Preferences  ]         │
└─────────────────────────────────┘
```

### Exit Gate
- [ ] 4+ tests pass (entity defaults, sheet UI, persistence, Settings link)
- [ ] Preference sheet appears once after onboarding completion
- [ ] Settings > Notifications is reachable
- [ ] Preferences persist across app restarts
- [ ] `dart analyze` 0/0/0

---

## Phase 2 Exit Gate (All Groups Complete)

```
[ ] 25+ new tests pass (across all 4 groups)
[ ] Events persist to Hive and survive app restart
[ ] Dashboard shows correct next-best-action variant
[ ] All interactive elements have Semantics labels
[ ] Cadence preferences captured and persisted
[ ] dart analyze 0/0/0
[ ] Persona Walkthrough: Rafiq sees helpful guidance card, not confusion
```

## Score projection after Phase 2

| Dimension | Before | After | Delta |
|---|---|---|---|
| Cognitive load management | 78 | 88 | +10 (next best action) |
| Cadence & personalization | 15 | 50 | +35 (preferences) |
| Analytics & behavioral data | 55 | 70 | +15 (persistence + tracking) |
| **Behavioral Total** | **68** | **76** | **+8** |
| Accessibility | 7/10 | 9/10 | +2 (Semantics) |
| Navigation | 8/10 | 9/10 | +1 (settings IA) |
| **UI/UX Total** | **83** | **89** | **+6** |
