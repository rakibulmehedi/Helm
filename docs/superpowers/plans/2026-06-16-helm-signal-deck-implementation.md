# Helm Signal Deck Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the approved Helm Signal Deck visual architecture as a tested Flutter UI layer without changing financial business logic.

**Architecture:** Add Signal Deck tokens and reusable widgets under `lib/core/`, then replace the dashboard composition with a `Signal / Horizon / Decision Deck` layout. Keep income, safe-to-spend, audit, auth, persistence, and calculator logic unchanged. Navigation label changes and trace styling are isolated from core data flow.

**Tech Stack:** Flutter, Dart, Riverpod, GoRouter, existing Helm design tokens, `flutter_test`. No new runtime packages.

---

## File Structure

### New Files

- `lib/core/themes/helm_signal_theme.dart`
  - Signal Deck color aliases, semantic state helpers, shadow constants, and spring/timing constants.
- `lib/core/widgets/signal/helm_signal_horizon.dart`
  - Signature semantic horizon line with optional reduced-motion-safe pulse.
- `lib/core/widgets/signal/helm_signal_hero.dart`
  - Dominant Safe-to-Spend instrument with orbital state visual and supporting signals.
- `lib/core/widgets/signal/helm_decision_deck.dart`
  - One-event, one-action decision layer.
- `lib/core/widgets/signal/helm_flow_route.dart`
  - Compact `Expected → Transit → Usable` route indicator.
- `test/core/themes/helm_signal_theme_test.dart`
  - Token value and contrast tests.
- `test/core/widgets/signal/helm_signal_horizon_test.dart`
  - Horizon semantics, state color, reduced-motion behavior.
- `test/core/widgets/signal/helm_signal_hero_test.dart`
  - S2S dominance, supporting signals, no counter text behavior.
- `test/core/widgets/signal/helm_decision_deck_test.dart`
  - One-action deck behavior, semantics, CTA callback.
- `test/core/widgets/signal/helm_flow_route_test.dart`
  - Route labels and active stage semantics.
- `test/features/dashboard/presentation/dashboard_signal_deck_test.dart`
  - Dashboard uses Signal Deck composition and preserves trace opening affordance.
- `test/config/router/app_shell_signal_nav_test.dart`
  - Bottom navigation labels become `Signal / Flow / Trace`.

### Modified Files

- `.gitignore`
  - Add `.worktrees/` for isolated implementation workspace.
- `lib/core/themes/helm_motion.dart`
  - Add Signal Deck motion timing and spring constants only.
- `lib/features/dashboard/presentation/views/dashboard_screen.dart`
  - Replace `HelmRealityStack` dashboard composition with Signal Deck composition.
- `lib/core/widgets/helm_calculation_trace.dart`
  - Style trace as dark spatial sheet while preserving calculation rows.
- `lib/config/router/app_router.dart`
  - Change bottom nav labels/tooltips/icons to `Signal / Flow / Trace`.
- `lib/config/router/route_names.dart`
  - Add `trace` route alias to existing audit/log route if needed.
- `lib/features/income/presentation/widgets/confirm_received_sheet.dart`
  - Move confirm haptic after successful state commit and add delayed recalculation haptic trigger.
- `docs/tracking/TASKS.md`
  - Mark implementation-plan creation complete and add implementation tracking item.

---

## Parallelization Model

Task 1 is the foundation and must run first. After Task 1 passes and commits, Tasks 2, 3, 4, and 5 can run in parallel because their write sets are disjoint:

- Lane A: core Signal widgets (`lib/core/widgets/signal/**`, widget tests)
- Lane B: navigation labels (`lib/config/router/**`, router test)
- Lane C: calculation trace styling (`lib/core/widgets/helm_calculation_trace.dart`, trace tests)
- Lane D: confirm received haptic sequence (`confirm_received_sheet.dart`, confirm tests)

Task 6 integrates these lanes into the dashboard and runs full verification.

All implementation tasks must follow Red → Green → Refactor. Each task must include the failing test output in its completion summary.

---

## Task 1: Signal Deck Token Foundation

**Files:**
- Create: `lib/core/themes/helm_signal_theme.dart`
- Modify: `lib/core/themes/helm_motion.dart`
- Test: `test/core/themes/helm_signal_theme_test.dart`
- Test: `test/core/themes/helm_colors_contrast_test.dart`

- [ ] **Step 1: Write failing token tests**

Create `test/core/themes/helm_signal_theme_test.dart`:

```dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/helm_signal_theme.dart';

double _linearize(double channel) {
  return channel <= 0.03928
      ? channel / 12.92
      : pow((channel + 0.055) / 1.055, 2.4) as double;
}

double _relativeLuminance(Color c) {
  final r = _linearize((c.r * 255.0).round().clamp(0, 255) / 255.0);
  final g = _linearize((c.g * 255.0).round().clamp(0, 255) / 255.0);
  final b = _linearize((c.b * 255.0).round().clamp(0, 255) / 255.0);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double _contrast(Color a, Color b) {
  final l1 = _relativeLuminance(a);
  final l2 = _relativeLuminance(b);
  return (max(l1, l2) + 0.05) / (min(l1, l2) + 0.05);
}

void main() {
  group('HelmSignalTheme tokens', () {
    test('dark brand tokens match approved Signal Deck palette', () {
      expect(HelmSignalTheme.signalCanvas, const Color(0xFF06100E));
      expect(HelmSignalTheme.signalSurface, const Color(0xFF0E1A17));
      expect(HelmSignalTheme.signalDeck, const Color(0xFF14231F));
      expect(HelmSignalTheme.signalInkPrimary, const Color(0xFFEFF8F4));
      expect(HelmSignalTheme.signalInteractive, const Color(0xFF8BE5C9));
      expect(HelmSignalTheme.signalGlow, const Color(0xFF53C9A7));
    });

    test('critical dark text and CTA tokens meet WCAG AA contrast', () {
      expect(
        _contrast(
          HelmSignalTheme.signalInkPrimary,
          HelmSignalTheme.signalCanvas,
        ),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrast(
          HelmSignalTheme.signalInteractive,
          HelmSignalTheme.signalCanvas,
        ),
        greaterThanOrEqualTo(4.5),
      );
    });

    test('semantic states expose approved Signal Deck colors', () {
      expect(HelmSignalTheme.safe, const Color(0xFF83E3C7));
      expect(HelmSignalTheme.tight, const Color(0xFFD2A75B));
      expect(HelmSignalTheme.atRisk, const Color(0xFFD87868));
      expect(HelmSignalTheme.pending, const Color(0xFF789FB2));
      expect(HelmSignalTheme.protected, const Color(0xFFA69BC4));
    });

    test('shadow constants preserve non-Material depth model', () {
      expect(HelmSignalTheme.decisionDeckShadow.offset.dy, equals(-12));
      expect(HelmSignalTheme.decisionDeckShadow.blurRadius, equals(40));
      expect(HelmSignalTheme.floatingSheetShadow.offset.dy, equals(-8));
      expect(HelmSignalTheme.floatingSheetShadow.blurRadius, equals(32));
    });
  });
}
```

- [ ] **Step 2: Run token test and verify RED**

Run:

```bash
fvm flutter test test/core/themes/helm_signal_theme_test.dart
```

Expected: FAIL because `helm_signal_theme.dart` does not exist.

- [ ] **Step 3: Implement Signal Deck tokens**

Create `lib/core/themes/helm_signal_theme.dart`:

```dart
import 'package:flutter/material.dart';

abstract final class HelmSignalTheme {
  static const Color signalCanvas = Color(0xFF06100E);
  static const Color signalSurface = Color(0xFF0E1A17);
  static const Color signalDeck = Color(0xFF14231F);
  static const Color signalInkPrimary = Color(0xFFEFF8F4);
  static const Color signalInkSecondary = Color(0xFFA7BBB4);
  static const Color signalInkMuted = Color(0xFF789087);
  static const Color signalInteractive = Color(0xFF8BE5C9);
  static const Color signalGlow = Color(0xFF53C9A7);

  static const Color safe = Color(0xFF83E3C7);
  static const Color tight = Color(0xFFD2A75B);
  static const Color atRisk = Color(0xFFD87868);
  static const Color pending = Color(0xFF789FB2);
  static const Color protected = Color(0xFFA69BC4);

  static Color signalGlass(BuildContext context) =>
      Colors.white.withValues(alpha: 0.07);

  static Color signalBorder(BuildContext context) =>
      Colors.white.withValues(alpha: 0.13);

  static const BoxShadow decisionDeckShadow = BoxShadow(
    color: Color(0x2E000000),
    offset: Offset(0, -12),
    blurRadius: 40,
  );

  static const BoxShadow floatingSheetShadow = BoxShadow(
    color: Color(0x38000000),
    offset: Offset(0, -8),
    blurRadius: 32,
  );

  static Color stateColor(SignalDeckState state) {
    return switch (state) {
      SignalDeckState.safe => safe,
      SignalDeckState.tight => tight,
      SignalDeckState.atRisk => atRisk,
    };
  }

  static String stateLabel(SignalDeckState state) {
    return switch (state) {
      SignalDeckState.safe => 'Stable',
      SignalDeckState.tight => 'Tight',
      SignalDeckState.atRisk => 'At Risk',
    };
  }
}

enum SignalDeckState { safe, tight, atRisk }
```

Modify `lib/core/themes/helm_motion.dart` by adding constants without changing existing values:

```dart
  static const Duration signalTapFeedback = Duration(milliseconds: 90);
  static const Duration signalSmallStateChange = Duration(milliseconds: 180);
  static const Duration signalDeckTransition = Duration(milliseconds: 260);
  static const Duration signalFullScreenTransition = Duration(milliseconds: 320);

  static const double signalControlPressMass = 1.0;
  static const double signalControlPressStiffness = 650.0;
  static const double signalControlPressDamping = 48.0;
  static const double signalControlPressedScale = 0.975;

  static const double signalDeckSettleMass = 1.0;
  static const double signalDeckSettleStiffness = 420.0;
  static const double signalDeckSettleDamping = 38.0;
  static const double signalDeckSettleMaxTravel = 12.0;

  static const double signalPipelineMass = 1.0;
  static const double signalPipelineStiffness = 360.0;
  static const double signalPipelineDamping = 34.0;
```

- [ ] **Step 4: Run token test and contrast suite**

Run:

```bash
fvm flutter test test/core/themes/helm_signal_theme_test.dart test/core/themes/helm_colors_contrast_test.dart
```

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/core/themes/helm_signal_theme.dart lib/core/themes/helm_motion.dart test/core/themes/helm_signal_theme_test.dart
git commit -m "feat(design): add Signal Deck theme tokens"
```

---

## Task 2: Core Signal Widgets

**Files:**
- Create: `lib/core/widgets/signal/helm_signal_horizon.dart`
- Create: `lib/core/widgets/signal/helm_flow_route.dart`
- Create: `lib/core/widgets/signal/helm_decision_deck.dart`
- Create: `lib/core/widgets/signal/helm_signal_hero.dart`
- Test: `test/core/widgets/signal/helm_signal_horizon_test.dart`
- Test: `test/core/widgets/signal/helm_flow_route_test.dart`
- Test: `test/core/widgets/signal/helm_decision_deck_test.dart`
- Test: `test/core/widgets/signal/helm_signal_hero_test.dart`

- [ ] **Step 1: Write failing widget tests**

Create tests that assert:

```dart
expect(find.text('SAFE TO SPEND NOW'), findsOneWidget);
expect(find.text('৳36,000'), findsOneWidget);
expect(find.text('COMMITTED ৳24K'), findsOneWidget);
expect(find.text('HELD ৳10K'), findsOneWidget);
expect(find.text('PENDING $600'), findsOneWidget);
expect(find.text('EXPECTED'), findsOneWidget);
expect(find.text('TRANSIT'), findsOneWidget);
expect(find.text('USABLE'), findsOneWidget);
expect(find.text('VIEW TRACE'), findsOneWidget);
expect(find.text('REVIEW COMMITMENTS'), findsOneWidget);
```

Each test file must wrap widgets in `MaterialApp(theme: AppTheme.dark, home: Scaffold(body: child))`.

- [ ] **Step 2: Run widget tests and verify RED**

Run:

```bash
fvm flutter test test/core/widgets/signal
```

Expected: FAIL because Signal widgets do not exist.

- [ ] **Step 3: Implement `HelmSignalHorizon`**

Requirements:

- Constructor: `state`, `animatePulse = false`
- Uses `HelmSignalTheme.stateColor(state)`
- Height: 1dp base, visual glow via `BoxShadow`
- Semantics label: `Signal horizon: Stable`, `Signal horizon: Tight`, or `Signal horizon: At Risk`
- Reduced motion: if `MediaQuery.disableAnimations` is true, no pulse animation starts

- [ ] **Step 4: Implement `HelmFlowRoute`**

Requirements:

- Constructor: `activeStage`
- Enum: `SignalFlowStage.expected`, `transit`, `usable`
- Shows labels `EXPECTED`, `TRANSIT`, `USABLE`
- Uses solid text tokens, no alpha text
- Semantics label: `Money route: Expected to Transit to Usable. Current stage: <stage>`

- [ ] **Step 5: Implement `HelmDecisionDeck`**

Requirements:

- Constructor: `eventLabel`, `eventTitle`, `actionLabel`, `onAction`, `onTrace`, `flowStage`
- One CTA only
- `VIEW TRACE` is secondary control and calls `onTrace`
- CTA uses `HapticFeedback.lightImpact()` on press before callback
- Uses `HelmSignalTheme.decisionDeckShadow`
- Semantics label includes event title and action label

- [ ] **Step 6: Implement `HelmSignalHero`**

Requirements:

- Constructor: `safeToSpend`, `state`, `runwayLabel`, `committedSignal`, `heldSignal`, `pendingSignal`, `onTapTrace`
- Shows value as `৳36,000` using `NumberFormat('#,##0', 'en_US')`
- Does not animate numeric value as counter
- Uses restrained orbital decorative circle with `ExcludeSemantics`
- Tapping hero triggers `HapticFeedback.lightImpact()` then `onTapTrace`
- Semantics label starts with `Safe to spend now`

- [ ] **Step 7: Run widget tests**

Run:

```bash
fvm flutter test test/core/widgets/signal
```

Expected: PASS.

- [ ] **Step 8: Commit**

```bash
git add lib/core/widgets/signal test/core/widgets/signal
git commit -m "feat(design): add Signal Deck widgets"
```

---

## Task 3: Signal / Flow / Trace Navigation

**Files:**
- Modify: `lib/config/router/app_router.dart`
- Modify: `lib/config/router/route_names.dart`
- Test: `test/config/router/app_shell_signal_nav_test.dart`

- [ ] **Step 1: Write failing navigation test**

Create `test/config/router/app_shell_signal_nav_test.dart` with a widget test that pumps `appRouter`, disables auth gates through existing test setup if available, or directly asserts route constants and tab labels using a small extracted test fixture if app-router pumping is too coupled.

Minimum expectations:

```dart
expect(RouteNames.home, equals('/home'));
expect(RouteNames.pipeline, equals('/pipeline'));
expect(RouteNames.trace, equals('/trace'));
```

If direct shell pumping is feasible, assert:

```dart
expect(find.text('Signal'), findsOneWidget);
expect(find.text('Flow'), findsOneWidget);
expect(find.text('Trace'), findsOneWidget);
expect(find.text('Settings'), findsNothing);
```

- [ ] **Step 2: Run navigation test and verify RED**

Run:

```bash
fvm flutter test test/config/router/app_shell_signal_nav_test.dart
```

Expected: FAIL because `RouteNames.trace` and nav labels do not exist.

- [ ] **Step 3: Implement navigation changes**

Modify `RouteNames`:

```dart
static const String trace = '/trace';
```

Add a shell route for `RouteNames.trace` that renders `AuditLogScreen`.

Change `_tabs` in `app_router.dart`:

```dart
const List<_TabItem> _tabs = [
  _TabItem(
    path: RouteNames.home,
    icon: Icons.radar_rounded,
    label: 'Signal',
    tooltip: 'Safe-to-Spend signal',
  ),
  _TabItem(
    path: RouteNames.pipeline,
    icon: Icons.route_rounded,
    label: 'Flow',
    tooltip: 'Income flow',
  ),
  _TabItem(
    path: RouteNames.trace,
    icon: Icons.receipt_long_rounded,
    label: 'Trace',
    tooltip: 'Calculation trace and audit log',
  ),
];
```

Keep existing settings route available outside primary nav.

- [ ] **Step 4: Run navigation test**

Run:

```bash
fvm flutter test test/config/router/app_shell_signal_nav_test.dart
```

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/config/router/app_router.dart lib/config/router/route_names.dart test/config/router/app_shell_signal_nav_test.dart
git commit -m "feat(nav): align shell with Signal Deck"
```

---

## Task 4: Calculation Trace Spatial Sheet

**Files:**
- Modify: `lib/core/widgets/helm_calculation_trace.dart`
- Test: `test/core/widgets/helm_calculation_trace_signal_test.dart`

- [ ] **Step 1: Write failing trace test**

Create `test/core/widgets/helm_calculation_trace_signal_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/themes/helm_signal_theme.dart';
import 'package:helm/core/widgets/helm_calculation_trace.dart';
import 'package:helm/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';

void main() {
  testWidgets('calculation trace uses Signal Deck sheet surface', (tester) async {
    final result = SafeToSpendResult(
      totalReceivedIncomeBdt: 78000,
      totalExpenses: 0,
      liquidCash: 78000,
      taxReserve: 0,
      fixedCostsDue: 24000,
      anxietyBuffer: 10000,
      safeToSpend: 44000,
      rawSafeToSpend: 44000,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(body: HelmCalculationTrace(result: result)),
      ),
    );

    expect(find.text('How this was calculated'), findsOneWidget);
    final container = tester.widget<Container>(find.byKey(const Key('signal_trace_sheet')));
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, equals(HelmSignalTheme.signalDeck));
  });
}
```

- [ ] **Step 2: Run trace test and verify RED**

Run:

```bash
fvm flutter test test/core/widgets/helm_calculation_trace_signal_test.dart
```

Expected: FAIL because key/signal color is absent.

- [ ] **Step 3: Implement trace styling**

In `HelmCalculationTrace`, set sheet `Container` key and decoration:

```dart
key: const Key('signal_trace_sheet'),
decoration: const BoxDecoration(
  color: HelmSignalTheme.signalDeck,
  borderRadius: BorderRadius.vertical(
    top: Radius.circular(HelmSpacing.sheetTopRadius),
  ),
  boxShadow: [HelmSignalTheme.floatingSheetShadow],
),
```

Update text colors to Signal Deck dark tokens for trace context:

- Critical values: `HelmSignalTheme.signalInkPrimary`
- Labels: `HelmSignalTheme.signalInkSecondary`
- Metadata: `HelmSignalTheme.signalInkMuted`
- Divider before final result: `HelmSignalTheme.signalGlow`

Do not change calculation line order or amount values.

- [ ] **Step 4: Run trace tests**

Run:

```bash
fvm flutter test test/core/widgets/helm_calculation_trace_signal_test.dart
```

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/helm_calculation_trace.dart test/core/widgets/helm_calculation_trace_signal_test.dart
git commit -m "feat(trace): apply Signal Deck calculation sheet"
```

---

## Task 5: Confirm Received Haptic Sequence

**Files:**
- Modify: `lib/features/income/presentation/widgets/confirm_received_sheet.dart`
- Test: `test/features/income/presentation/confirm_received_sheet_signal_test.dart`

- [ ] **Step 1: Write failing code-structure test**

Create `test/features/income/presentation/confirm_received_sheet_signal_test.dart`:

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('confirm received haptic fires after state commit', () {
    final source = File(
      'lib/features/income/presentation/widgets/confirm_received_sheet.dart',
    ).readAsStringSync();

    final updateIndex = source.indexOf('await notifier.updateIncome(updatedEntry);');
    final mediumIndex = source.indexOf('await HapticFeedback.mediumImpact();');

    expect(updateIndex, greaterThanOrEqualTo(0));
    expect(mediumIndex, greaterThan(updateIndex));
  });

  test('successful recalculation has one delayed light haptic', () {
    final source = File(
      'lib/features/income/presentation/widgets/confirm_received_sheet.dart',
    ).readAsStringSync();

    expect(source, contains('Future<void>.delayed'));
    expect(source, contains('HapticFeedback.lightImpact'));
  });
}
```

- [ ] **Step 2: Run test and verify RED**

Run:

```bash
fvm flutter test test/features/income/presentation/confirm_received_sheet_signal_test.dart
```

Expected: FAIL because `mediumImpact` currently fires before validation and state commit.

- [ ] **Step 3: Move haptics after commit**

In `_onConfirm`, remove the first line:

```dart
await HapticFeedback.mediumImpact();
```

After:

```dart
await notifier.updateIncome(updatedEntry);
```

add:

```dart
await HapticFeedback.mediumImpact();
unawaited(Future<void>.delayed(
  const Duration(milliseconds: 220),
  HapticFeedback.lightImpact,
));
```

Import `dart:async` if not already present.

- [ ] **Step 4: Run confirm haptic test**

Run:

```bash
fvm flutter test test/features/income/presentation/confirm_received_sheet_signal_test.dart
```

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/income/presentation/widgets/confirm_received_sheet.dart test/features/income/presentation/confirm_received_sheet_signal_test.dart
git commit -m "feat(income): align confirm haptics with Signal Deck"
```

---

## Task 6: Dashboard Signal Deck Integration

**Files:**
- Modify: `lib/features/dashboard/presentation/views/dashboard_screen.dart`
- Test: `test/features/dashboard/presentation/dashboard_signal_deck_test.dart`
- Modify: `docs/tracking/TASKS.md`

- [ ] **Step 1: Write failing dashboard integration test**

Create `test/features/dashboard/presentation/dashboard_signal_deck_test.dart` as a lightweight source-structure test if full Riverpod/Hive pumping is too coupled:

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dashboard composes Signal Deck widgets instead of Reality Stack', () {
    final source = File(
      'lib/features/dashboard/presentation/views/dashboard_screen.dart',
    ).readAsStringSync();

    expect(source, contains('HelmSignalHero'));
    expect(source, contains('HelmSignalHorizon'));
    expect(source, contains('HelmDecisionDeck'));
    expect(source, isNot(contains('HelmRealityStack(')));
  });

  test('dashboard keeps trace opening instrumentation', () {
    final source = File(
      'lib/features/dashboard/presentation/views/dashboard_screen.dart',
    ).readAsStringSync();

    expect(source, contains('TransactionalEvents.calculationBreakdownOpened'));
    expect(source, contains('HelmCalculationTrace.show'));
  });
}
```

- [ ] **Step 2: Run dashboard test and verify RED**

Run:

```bash
fvm flutter test test/features/dashboard/presentation/dashboard_signal_deck_test.dart
```

Expected: FAIL because dashboard still uses `HelmRealityStack`.

- [ ] **Step 3: Replace dashboard composition**

In `DashboardScreen`:

- Remove `HelmRealityStack` import and usage.
- Keep analytics, S2S hint, nudge evaluation, and trace opening logic unchanged.
- Add imports:

```dart
import 'package:helm/core/themes/helm_signal_theme.dart';
import 'package:helm/core/widgets/signal/helm_decision_deck.dart';
import 'package:helm/core/widgets/signal/helm_flow_route.dart';
import 'package:helm/core/widgets/signal/helm_signal_hero.dart';
import 'package:helm/core/widgets/signal/helm_signal_horizon.dart';
```

Derive state:

```dart
SignalDeckState _signalState(SafeToSpendResult result) {
  if (result.rawSafeToSpend > 0) return SignalDeckState.safe;
  if (result.rawSafeToSpend > -result.anxietyBuffer) return SignalDeckState.tight;
  return SignalDeckState.atRisk;
}
```

Build `Scaffold.backgroundColor` with `HelmSignalTheme.signalCanvas`.

Use a `Stack` or `Column` where:

- `HelmSignalHero` occupies upper region.
- `HelmSignalHorizon` appears below hero.
- `HelmDecisionDeck` appears below horizon.
- One CTA routes to these exact existing paths:
  - empty pipeline → `RouteNames.addIncome`
  - overdue → `RouteNames.pipeline`
  - at risk → `RouteNames.stsSettings`
  - relief → `RouteNames.pipeline`

Use existing values from `SafeToSpendResult`:

- committed signal: `COMMITTED ৳${fixedCostsDue compact}`
- held signal: `HELD ৳${anxietyBuffer compact}`
- pending signal: if available from result, use pending total; otherwise `PENDING $0`

- [ ] **Step 4: Update tracking docs**

In `docs/tracking/TASKS.md`, add under Signal Deck implementation:

```markdown
- [ ] Implement Signal Deck UI slice with TDD.
```

Mark it checked only after full verification passes.

- [ ] **Step 5: Run targeted tests**

Run:

```bash
fvm flutter test test/core/themes/helm_signal_theme_test.dart test/core/widgets/signal test/config/router/app_shell_signal_nav_test.dart test/core/widgets/helm_calculation_trace_signal_test.dart test/features/income/presentation/confirm_received_sheet_signal_test.dart test/features/dashboard/presentation/dashboard_signal_deck_test.dart
```

Expected: PASS.

- [ ] **Step 6: Run project verification**

Run:

```bash
fvm dart analyze
fvm flutter test
```

Expected: analyzer has 0 issues; full test suite passes.

- [ ] **Step 7: Commit**

```bash
git add lib/features/dashboard/presentation/views/dashboard_screen.dart test/features/dashboard/presentation/dashboard_signal_deck_test.dart docs/tracking/TASKS.md
git commit -m "feat(dashboard): implement Signal Deck home"
```

---

## Self-Review Checklist

- Spec coverage:
  - Signal Hero: Task 2 and Task 6
  - Signal Horizon: Task 2 and Task 6
  - Decision Deck: Task 2 and Task 6
  - Flow Navigation: Task 3
  - Trace Screen styling: Task 4
  - Haptic confirmation sequence: Task 5
  - No business logic changes: enforced in every task scope
- TDD: every production change has a failing test step before implementation.
- Parallel readiness: after Task 1, Tasks 2-5 have disjoint write sets.
- Package policy: no new package.
- Known limitation: this plan implements a shippable first visual slice, not every screen in the application.
