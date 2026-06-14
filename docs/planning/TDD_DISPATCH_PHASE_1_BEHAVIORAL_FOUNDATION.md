# TDD + Clean Architecture Dispatch — Phase 1 Behavioral Foundation

> Date: 2026-06-12
> Phase: 1 of 6 (100% Master Plan)
> Trigger: Phase 0 (A5 Bangla + Release Build) complete ✅
> Target: Behavioral 62→68, UI/UX 78→83
> Effort: ~6 hours of implementation across 18 tasks

---

## Dispatch Architecture

```
                   ┌─────────────────────────────────┐
                   │     ORCHESTRATOR (Antigravity)    │
                   │   Owns all 18 implementation tasks │
                   └──────────┬──────────────────────┘
                              │
         ┌────────────────────┼────────────────────┐
         │                    │                    │
    ┌────▼─────┐      ┌──────▼──────┐      ┌─────▼─────┐
    │  REVIEW   │      │   REVIEW    │      │  REVIEW   │
    │ UX Arch   │      │ UI Designer │      │  Nudge    │
    │ Clean Arch │      │ Visual QA   │      │ Behavioral│
    └───────────┘      └─────────────┘      └───────────┘
         │                    │                    │
    ┌────▼─────┐      ┌──────▼──────┐      ┌─────▼─────┐
    │  REVIEW   │      │   DESIGN    │      │  DESIGN   │
    │  Brand    │      │  Whimsy     │      │  Persona  │
    │ Guardian  │      │  Injector   │      │ Walkthru  │
    └───────────┘      └─────────────┘      └───────────┘
```

**Orchestrator**: Antigravity executes every task, runs tests, verifies gates.
**Review agents**: Run in parallel AFTER each task group, validate before next group starts.
**Design support**: Whimsy Injector provides copy/content before implementation. Persona Walkthrough validates final flow.

---

## TDD Mandate Per Task Type

### Rule 1: Test First, Code Second
Every task follows: **Write test → Watch it fail (RED) → Implement → Watch it pass (GREEN) → Refactor → Verify still green**.

### Rule 2: Test Architecture
```
test/features/<feature>/<layer>/<file>_test.dart
```
Mirrors `lib/` structure exactly. Domain tests in `domain/`, widget tests in `presentation/`.

### Rule 3: Clean Architecture Gate
No task may:
- Import `data/` from `presentation/` (use abstract `domain/repositories/`)
- Import Flutter widgets into `domain/` (pure Dart only)
- Call `Hive.box()` directly from UI (go through repository)
- Use `setState()` for business logic (use Riverpod)
- Skip `mounted` check after async gap

---

## Task Group Dispatch

---

### GROUP A — Contrast Ratio Fixes (P1.9–P1.11)

**Files touched:** `lib/core/themes/helm_colors.dart` (light + dark)
**Architecture layer:** Theme (core/themes), no domain/feature changes
**Agent lead:** Antigravity (code change: 3 color values)
**Review agent:** UI Designer (verifies WCAG AA compliance)

#### TDD Approach
Color value changes are declarative — test the computed contrast ratio, not the color itself.

**Test file:** `test/core/themes/helm_colors_contrast_test.dart`

```dart
// Test that state tokens meet WCAG AA (4.5:1 minimum for normal text)
// Against canvas background (#FAFAF6 for light, #0E0E0C for dark)

test('stateSafe meets WCAG AA contrast on light canvas', () {
  final contrast = _computeContrast(HelmColors.light.stateSafe, Color(0xFFFAFAF6));
  expect(contrast, greaterThanOrEqualTo(4.5));
});

test('stateTight meets WCAG AA contrast on light canvas', () {
  final contrast = _computeContrast(HelmColors.light.stateTight, Color(0xFFFAFAF6));
  expect(contrast, greaterThanOrEqualTo(4.5));
});

test('dark interactive meets WCAG AA contrast on dark canvas', () {
  final contrast = _computeContrast(HelmColors.dark.interactive, Color(0xFF0E0E0C));
  expect(contrast, greaterThanOrEqualTo(4.5));
});
```

**Contrast formula (WCAG relative luminance):**
```dart
double _relativeLuminance(Color c) {
  final r = _linearize(c.red / 255.0);
  final g = _linearize(c.green / 255.0);
  final b = _linearize(c.blue / 255.0);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double _linearize(double channel) {
  return channel <= 0.03928 ? channel / 12.92 : pow((channel + 0.055) / 1.055, 2.4);
}

double _computeContrast(Color a, Color b) {
  final l1 = _relativeLuminance(a);
  final l2 = _relativeLuminance(b);
  final light = max(l1, l2);
  final dark = min(l1, l2);
  return (light + 0.05) / (dark + 0.05);
}
```

**Implementation:**
| Token | Before | After | Target Ratio |
|-------|--------|-------|-------------|
| `stateSafe` light | `#5F8569` | `#3D6B3C` | 4.7:1 (AA) |
| `stateTight` light | `#A97833` | `#8B6500` | 4.6:1 (AA) |
| `interactive` dark | `#3E807D` | `#4DA09C` | 5.0:1 (AA) |

**Clean architecture check:** Theme layer only. No domain/presentation changes. Color values are pre-computed hex (no method calls at build time).

**Exit gate:**
- [ ] 3 new contrast tests pass (all ≥4.5:1)
- [ ] Existing 78 tests still pass
- [ ] `dart analyze` 0/0/0
- [ ] UI Designer confirms all 3 ratios meet AA

---

### GROUP B — Boundary Event Wiring (P1.1–P1.4)

**Files touched:**
- `lib/features/dashboard/presentation/views/dashboard_screen.dart` (sts_at_risk_entered, reserve_depleted)
- `lib/features/income/presentation/providers/income_providers.dart` or notifier (first_pipeline_entry)
- `lib/features/income/presentation/views/confirm_received_sheet.dart` (pipeline_state_changed — transactional version already exists; wire boundary version)

**Architecture layer:** Presentation only. No domain/data changes.
**Agent lead:** Antigravity
**Review agent:** Behavioral Nudge Engine (verifies event timing + semantics)

#### TDD Approach

Each event requires: (1) trigger condition identification, (2) test that event fires when condition met, (3) test that event does NOT fire when condition not met.

**Test file:** `test/features/dashboard/presentation/dashboard_boundary_events_test.dart`

```dart
// P1.1: sts_at_risk_entered
testWidgets('fires sts_at_risk_entered when S2S drops below buffer', (tester) async {
  // Arrange: mock S2S result with rawSafeToSpend <= -anxietyBuffer
  // Act: pump dashboard
  // Assert: analytics.trackEvent called with BoundaryEvents.stsAtRiskEntered
});

// P1.2: reserve_depleted
testWidgets('fires reserve_depleted when buffer reaches zero', (tester) async {
  // Arrange: mock S2S result with anxietyBuffer == 0
  // Act: pump dashboard
  // Assert: analytics.trackEvent called with BoundaryEvents.reserveDepleted
});

// P1.3: first_pipeline_entry (in income notifier)
// P1.4: pipeline_state_changed boundary (separate from transactional version —
//        fires once per state change, not once per user action)
```

**Implementation triggers (codebase reality):**

| Event | Where to wire | Trigger condition | Guard |
|-------|--------------|-------------------|-------|
| `sts_at_risk_entered` | Dashboard `initState` after S2S calc | `rawSafeToSpend <= -anxietyBuffer` | Fire only once per session (SharedPrefs flag) |
| `reserve_depleted` | Dashboard `initState` | `anxietyBuffer == 0` | Fire only once per session |
| `first_pipeline_entry` | IncomeNotifier `addIncome()` | `existingEntryCount == 0` before add | Fire only once ever (SharedPrefs flag) |
| `pipeline_state_changed` | ConfirmReceivedSheet onConfirm | Entry status changed | Fire always (boundary event, not transactional) |

**Clean architecture guard:** Events fire from presentation layer. No domain code calls `analytics.trackEvent()` directly — domain is pure Dart. Presentation wires analytics as a cross-cutting concern via the `analyticsProvider`.

**Event de-duplication guard:**
```dart
// Pattern for once-per-session boundary events
if (!SharedPrefServices.getEventFired(eventKey)) {
  analytics.trackEvent(eventName);
  SharedPrefServices.setEventFired(eventKey, true);
}
```

**Exit gate:**
- [ ] 8 new tests (2 per event: fires + does-not-fire)
- [ ] All 4 events fire at correct trigger points
- [ ] No duplicate fire within same session
- [ ] Behavioral Nudge Engineer confirms event semantics
- [ ] `dart analyze` 0/0/0

---

### GROUP C — Haptic Feedback (P1.5–P1.8)

**Files touched:**
- `lib/features/auth/presentation/views/pin_entry_screen.dart` (P1.5: PIN taps)
- `lib/features/auth/presentation/views/pin_setup_screen.dart` (P1.6: confirm)
- `lib/features/transactions/presentation/views/` — delete confirmation (P1.6)
- Catch blocks across feature screens (P1.7: heavy on error)
- `lib/features/dashboard/presentation/widgets/s2s_hero_block.dart` (P1.8: card tap)
- `lib/features/income/presentation/views/confirm_received_sheet.dart` (P1.6: confirm)

**Architecture layer:** Presentation views/widgets only
**Agent lead:** Antigravity
**Review agent:** UI Designer (haptic intensity mapping), Behavioral Nudge Engine (Fogg Ability signal)

#### TDD Approach

Haptics call `HapticFeedback.lightImpact()` etc. from `flutter/services.dart`. These are side-effect calls — test that the call path is reached, not that the motor vibrates.

**Test approach:** Widget tests that verify no crash on tap (haptics fire on tap handler). Integration tests on physical device verify actual vibration.

For unit-testing that haptic is on the correct tap path:
```dart
testWidgets('PIN key tap triggers light haptic', (tester) async {
  // Can verify: tapping PIN button calls HapticFeedback.lightImpact
  // Approach: mock HapticFeedback, verify call count
  // OR: verify the callback is wired (test that no exception on tap)
});
```

**Haptic intensity map:**

| Action | Haptic | Intensity | Reason |
|--------|--------|-----------|--------|
| PIN digit tap | `lightImpact()` | Light | Confirms press registered |
| Confirm action | `mediumImpact()` | Medium | Committing a decision |
| Delete/undo | `mediumImpact()` | Medium | Destructive action confirmation |
| Error alert | `heavyImpact()` | Heavy | Requires immediate attention |
| Card tap (hero) | `lightImpact()` | Light | Opens breakdown |

**Clean architecture guard:** `HapticFeedback` is a Flutter service. Only called from widget build/event handlers in `presentation/`. Never called from providers (which are presentation-layer but should not know about motor haptics — haptics are a UI concern, not state logic).

**Pattern:**
```dart
onTap: () {
  HapticFeedback.lightImpact();
  // ... navigation or action
}
```

**Exit gate:**
- [ ] Haptic calls present on all 5 action types
- [ ] No haptic calls in providers or domain layer
- [ ] Widget tests pass (no crash on tap paths)
- [ ] UI Designer confirms intensity mapping
- [ ] Behavioral Nudge Engineer confirms Fogg Ability signal correct
- [ ] `dart analyze` 0/0/0

---

### GROUP D — Button Active/Pressed States (P1.12)

**Files touched:** `lib/core/widgets/` — shared button widgets
**Architecture layer:** Core widgets (shared across features)
**Agent lead:** UI Designer (spec) + Antigravity (implementation)
**Review agent:** UX Architect (flatten hierarchy check, no god widget creep)

#### TDD Approach

**Test file:** `test/core/widgets/button_pressed_state_test.dart`

```dart
testWidgets('button scales to 0.95 on press', (tester) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: AppButton(...))));
  // Create gesture, verify transform
  final gesture = await tester.createGesture();
  await gesture.down(tester.getCenter(find.byType(AppButton)));
  await tester.pump();
  // Verify scale transform applied
  final transform = tester.widget<Transform>(find.byType(Transform));
  expect(transform.transform, equals(Matrix4.diagonal3Values(0.95, 0.95, 1.0)));
});
```

**Implementation:** Wrap existing button in `AnimatedScale` or apply `withValues(alpha:)` color shift on `onHighlightChanged` callback. Prefer `AnimatedScale(scale: _isPressed ? 0.95 : 1.0, duration: 100ms)` — visual feedback without DOM repaint cost.

**Pattern:**
```dart
// Option A: Scale-down (preferred — no color computation at runtime)
GestureDetector(
  onTapDown: (_) => setState(() => _pressed = true),
  onTapUp: (_) => setState(() => _pressed = false),
  onTapCancel: () => setState(() => _pressed = false),
  child: AnimatedScale(
    scale: _pressed ? 0.97 : 1.0,
    duration: const Duration(milliseconds: 100),
    child: child,
  ),
)
```

**Exit gate:**
- [ ] All shared buttons have visible pressed state
- [ ] 1 widget test per button variant (verify scale or color shift)
- [ ] Animation duration ≤ 150ms (no UX delay)
- [ ] Respects `MediaQuery.of(context).disableAnimations`
- [ ] UI Designer confirms visual feedback matches spec

---

### GROUP E — Slider Stepper Buttons (P1.13–P1.14)

**Files touched:** `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart`
**Architecture layer:** Feature presentation (STS settings)
**Agent lead:** Antigravity
**Review agent:** UI Designer (visual placement), Behavioral Nudge Engine (Fogg Ability — fine control)

#### TDD Approach

**Test file:** `test/features/safe_to_spend/presentation/sts_settings_slider_test.dart`

```dart
testWidgets('tax rate + button increases value by 1%', (tester) async {
  await tester.pumpWidget(ProviderScope(child: MaterialApp(home: StsSettingsScreen())));
  final initialValue = /* read slider value */;
  await tester.tap(find.byKey(const Key('tax_rate_plus')));
  await tester.pump();
  final newValue = /* read slider value */;
  expect(newValue, equals(initialValue + 1.0));
});

testWidgets('tax rate — button decreases value by 1%', (tester) async {
  // Same pattern
});

testWidgets('buffer % + button increases by 1%', (tester) async { ... });
testWidgets('buffer % — button decreases by 1%', (tester) async { ... });

testWidgets('stepper buttons respect min/max bounds', (tester) async {
  // Set slider to min, verify minus button doesn't go below
  // Set slider to max, verify plus button doesn't go above
});
```

**Implementation:** Add `IconButton(Icons.remove)` / `IconButton(Icons.add)` on either side of the slider, calling `onChanged(currentValue ± 1.0)` with bounds clamping.

**Pattern:**
```dart
Row(
  children: [
    IconButton(
      icon: const Icon(Icons.remove_circle_outline),
      onPressed: currentValue > min
          ? () => onChanged(max(min, currentValue - 1.0))
          : null, // disabled at min
    ),
    Expanded(child: Slider(...)),
    IconButton(
      icon: const Icon(Icons.add_circle_outline),
      onPressed: currentValue < max
          ? () => onChanged(min(max, currentValue + 1.0))
          : null, // disabled at max
    ),
  ],
)
```

**Exit gate:**
- [ ] 6 slider tests pass (2 per slider: +/−, bounds)
- [ ] Both sliders (tax rate, buffer) have stepper buttons
- [ ] Buttons disable at min/max bounds
- [ ] UI Designer confirms visual placement
- [ ] `dart analyze` 0/0/0

---

### GROUP F — Onboarding Global Skip (P1.15)

**Files touched:** `lib/features/onboarding/presentation/views/onboarding_screen.dart`
**Architecture layer:** Feature presentation (onboarding)
**Agent lead:** UX Architect (flow design) + Antigravity (implementation)
**Review agent:** Persona Walkthrough (Rafiq simulation — does skip feel safe?)

#### TDD Approach

**Test file:** `test/features/onboarding/presentation/onboarding_skip_test.dart`

```dart
testWidgets('skip button visible on every onboarding step', (tester) async {
  await tester.pumpWidget(ProviderScope(child: MaterialApp(home: OnboardingScreen())));
  
  // Step 1: skip visible
  expect(find.byKey(const Key('onboarding_skip')), findsOneWidget);
  
  // Navigate to step 2
  await tester.tap(find.byKey(const Key('onboarding_next')));
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('onboarding_skip')), findsOneWidget);
  
  // ... all steps
});

testWidgets('skip navigates to home and marks onboarding complete', (tester) async {
  // Verify GoRouter navigation to home
  // Verify sharedPrefs onboarding_complete flag set
});

testWidgets('skip preserves partial data entered so far', (tester) async {
  // Enter data on step 2, skip on step 3
  // Verify data from steps 1-2 is persisted
});
```

**Implementation:**
```dart
// Top-right persistent skip button in onboarding AppBar area
// (ONB-002 says no AppBar — use a positioned widget)
Positioned(
  top: MediaQuery.of(context).padding.top + 8,
  right: 16,
  child: TextButton(
    key: const Key('onboarding_skip'),
    onPressed: () => _skipToHome(),
    child: Text('Set up later', style: ...),
  ),
)
```

**Skip behavior:** Persists any partial draft data (liquid balance, fixed costs already entered). Navigates directly to dashboard with `context.goNamed(RouteNames.dashboard)`. Sets `SharedPrefServices.setOnboardingComplete(true)`.

**Exit gate:**
- [ ] Skip visible on all 6 onboarding steps
- [ ] Skip navigates to dashboard
- [ ] Partial data persisted correctly
- [ ] Persona Walkthrough: Rafiq feels safe skipping (not abandoned)
- [ ] `dart analyze` 0/0/0

---

### GROUP G — Quiet Affirmation Signals (P1.16–P1.18)

**Files touched:**
- `lib/core/widgets/helm_trust_strip.dart` (affirmation slot)
- `lib/features/dashboard/presentation/views/dashboard_screen.dart` (condition computation)
- `lib/features/income/domain/entities/income_entry_entity.dart` (read-only, check overdue)

**Architecture layer:** Presentation + core widgets. Domain entities read-only.
**Agent lead:** Antigravity (implementation)
**Design support:** Whimsy Injector (copy design — quiet, not gamified)
**Review agent:** Behavioral Nudge Engine (verifies celebration tension resolved correctly), Brand Guardian (copy consistency)

#### TDD Approach

Affirmation conditions must be computed from domain data. The computation is new logic — test it separately.

**Test file:** `test/features/dashboard/presentation/dashboard_affirmations_test.dart`

```dart
// P1.16: "Pipeline up to date" — 0 overdue entries
test('shows pipeline up to date when 0 overdue entries', () {
  final result = _computeAffirmation(entries: [], sessionCount: 0);
  expect(result.type, equals(AffirmationType.pipelineUpToDate));
});

test('does NOT show pipeline up to date when 1+ overdue entries', () {
  final result = _computeAffirmation(
    entries: [overdueEntry()],
    sessionCount: 0,
  );
  expect(result.type, isNot(equals(AffirmationType.pipelineUpToDate)));
});

// P1.17: "7 days tracked"
test('shows 7 days tracked when sessionCount == 7', () {
  final result = _computeAffirmation(entries: [], sessionCount: 7);
  expect(result.type, equals(AffirmationType.daysTracked));
  expect(result.days, equals(7));
});

// P1.18: "14 days tracked"
test('shows 14 days tracked when sessionCount == 14', () {
  final result = _computeAffirmation(entries: [], sessionCount: 14);
  expect(result.type, equals(AffirmationType.daysTracked));
  expect(result.days, equals(14));
});

// No affirmation when nothing to affirm
test('shows nothing when pipeline has overdue AND sessionCount < 7', () {
  final result = _computeAffirmation(entries: [overdueEntry()], sessionCount: 3);
  expect(result.type, equals(AffirmationType.none));
});
```

**Implementation approach:**

1. Add `AffirmationType` enum + `Affirmation` value object in dashboard domain (or compute inline — keep it simple, this is a conditional display, not a business rule)
2. Compute from `SafeToSpendResult` + `List<IncomeEntryEntity>`: count overdue entries, check session count from `SharedPrefServices`
3. Display in `HelmTrustStrip` as a small text line below the timestamp

**Trust strip affirmation slot:**
```dart
// Current HelmTrustStrip signature (check actual):
// updatedAt, sourceLabel, onTapAudit

// Add:
// affirmation: Affirmation? — shown below sourceLabel when present

if (affirmation != null)
  Text(
    affirmation.copy, // e.g. "Pipeline up to date"
    style: typography.bodyXs.copyWith(color: colors.stateSafe),
  ),
```

**Copy design (Whimsy Injector — quiet, not celebration):**

| Condition | Copy | Not |
|-----------|------|-----|
| 0 overdue | "Pipeline up to date" | ~~"All clear!"~~ ~~"Great job!"~~ |
| 7 sessions | "7 days tracked" | ~~"One week streak!"~~ ~~"🔥"~~ |
| 14 sessions | "14 days tracked" | ~~"Two weeks!"~~ ~~"You're on fire!"~~ |

Rule: Facts only. No exclamation marks. No emoji. No comparative language ("great", "amazing"). The user interprets the signal — the app just states the fact.

**Exit gate:**
- [ ] 6 affirmation tests pass (conditions + copy)
- [ ] No exclamation marks, emoji, or comparative language in copy
- [ ] Brand Guardian confirms copy matches Helm voice
- [ ] Behavioral Nudge Engineer confirms celebration tension resolved (facts, not gamification)
- [ ] Trust strip does not shift layout when affirmation appears (pre-allocated space or animated reveal)
- [ ] `dart analyze` 0/0/0

---

## Parallel Execution Sequence

Groups are ordered by dependency and file-touch conflict risk.

```
WAVE 1 (parallel, independent files):
  ├── GROUP A — Contrast Fixes (helm_colors.dart only)
  ├── GROUP C — Haptics (pin_screen, hero_block, confirm_sheet)
  ├── GROUP D — Button States (core/widgets/ buttons)
  └── GROUP E — Slider Steppers (sts_settings_screen.dart)

WAVE 2 (depends on Wave 1 group G design):
  └── GROUP G — Quiet Affirmations (needs Whimsy Injector copy first)

WAVE 3 (depends on Wave 1 groups, independent otherwise):
  ├── GROUP B — Event Wiring (dashboard + income providers — conflicts with GROUP G on dashboard)
  └── GROUP F — Onboarding Skip (onboarding_screen.dart — independent)
```

**Conflict resolution:**
- Group B and Group G both touch `dashboard_screen.dart` — serialize them (G first, B after)
- Group A touches `helm_colors.dart` which every widget imports — but only changes hex values (no API change), so it's safe to parallel
- Group C touches 5+ files across features — no overlap with other groups

---

## Agent Assignment Matrix

| Task Group | Implementation | Design/Content | Architecture Review | Behavioral Review | Brand Review |
|-----------|---------------|----------------|-------------------|------------------|-------------|
| A — Contrast | Antigravity | UI Designer | UX Architect | — | — |
| B — Events | Antigravity | — | UX Architect | Nudge Engine | — |
| C — Haptics | Antigravity | UI Designer | UX Architect | Nudge Engine | — |
| D — Buttons | Antigravity | UI Designer | UX Architect | — | — |
| E — Sliders | Antigravity | UI Designer | UX Architect | Nudge Engine | — |
| F — Skip | Antigravity | UX Architect | UX Architect | Persona Walkthrough | Brand Guardian |
| G — Affirmations | Antigravity | **Whimsy Injector** | UX Architect | Nudge Engine | Brand Guardian |

---

## Full Quality Gate (Phase 1 Exit)

```
[ ] dart analyze 0/0/0
[ ] All existing 78 tests pass
[ ] 25+ new tests pass (see per-group counts)
[ ] 4 boundary events fire correctly
[ ] Haptic feedback present on 5 action types
[ ] 3 contrast ratios ≥4.5:1 (WCAG AA)
[ ] All shared buttons have visible pressed states
[ ] Both sliders have ±1% stepper buttons
[ ] Onboarding skip visible on all 6 steps
[ ] Trust strip shows quiet affirmations (facts only, no exclamation marks)
[ ] 0 analytics calls in domain/ layer
[ ] 0 haptic calls in domain/ layer
[ ] No new packages added to pubspec.yaml
[ ] Persona Walkthrough: Rafiq completes flow without confusion
[ ] UI Designer: all visual changes meet spec
[ ] Behavioral Nudge Engineer: all behavioral triggers correct
[ ] Brand Guardian: all copy matches Helm voice
```

---

## Immediate Actions

1. [ ] Antigravity reads all touched files (dashboard, onboarding, sts_settings, pin_screen, trust_strip, helm_colors, core widgets, analytics service)
2. [ ] Whimsy Injector designs affirmation copy for 3 states (deliver before GROUP G starts)
3. [ ] Antigravity dispatches Wave 1 (Groups A, C, D, E in sequence)
4. [ ] Antigravity dispatches Wave 2 (Group G — affirmation computation + trust strip)
5. [ ] Antigravity dispatches Wave 3 (Group B — events, Group F — skip)
6. [ ] Antigravity runs full test suite + dart analyze after each wave
7. [ ] UX Architect reviews clean architecture after all groups complete
8. [ ] Persona Walkthrough simulates Rafiq through final flow
9. [ ] All review agents sign off → Phase 1 COMPLETE
