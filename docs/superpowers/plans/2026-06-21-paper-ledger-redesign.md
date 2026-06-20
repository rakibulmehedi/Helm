# Paper Ledger Visual Redesign — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the dark glassmorphic "Signal Deck" UI with the warm-paper / warm-espresso "Paper Ledger" visual direction across every screen, in both light and dark mode, with zero business-logic / persistence / state changes.

**Architecture:** The app already centralizes color and typography in two `ThemeExtension`s (`HelmColors`, `HelmTypography`) consumed everywhere via `context.colors` / `context.textStyles`. Re-coloring those two extensions (field names unchanged) auto-cascades the new palette to ~23 of 24 screens. The only screens needing hand edits are the ones coupled to the parallel `HelmSignalTheme` static class (dashboard + calculation trace + 4 signal widgets), which is deleted and replaced by Paper Ledger widgets that read from `HelmColors`. The bottom-nav expansion to 4 tabs (founder-approved) is a bounded `_AppShell` edit — the `/settings` route already exists in the ShellRoute.

**Tech Stack:** Flutter (Dart ^3.7.2), Riverpod, Hive, GoRouter, `flutter_test` built-in goldens (no `golden_toolkit`), `flutter_lints` 6.0.0. FVM: use `fvm flutter` / `fvm dart`.

## Global Constraints

Copied verbatim from the spec (§6) and CLAUDE.md. Every task's requirements implicitly include this section.

- **No new packages** in `pubspec.yaml` without Chief Architect approval. Fraunces is a font **asset**, not a package — allowed.
- **No business-logic, persistence, routing-guard, or state-management changes.** `SafeToSpendCalculator`, Riverpod providers, Hive boxes, and the `_globalRedirect` guard are untouched. (The 4-tab bottom-nav `_tabs` edit is the one founder-approved structural exception — see Task 14; the `/settings` GoRoute already exists.)
- **`withValues(alpha:)` only**, never `withOpacity()`. Text colors are solid pre-resolved hex; alpha is reserved for decorative rails/dots.
- **Every file < 300 lines.** New widget files must stay focused.
- **`mounted` guards** on all post-async `setState` / navigation.
- **`dart analyze` 0 errors / 0 warnings / 0 infos** after every task.
- **`IdGenerator.uniqueId()`** for any new entity IDs (none expected in a visual reskin).
- **No raw hex in feature/widget code** — only `helm_colors.dart` may hold `Color(0x...)` literals. Widgets read `context.colors.*`.
- **Latin numerals for all money, always**, in both languages (`36,000`, never `৩৬,০০০`). `NumberFormatter` is the single currency boundary (Decision 037).
- **Typography rules:** display→Fraunces, UI body→Inter, money→mono family, Bangla→Hind Siliguri. No italic except the runway line (spec-approved Fraunces italic). Weights 400–600 only.
- **Run command prefix:** `fvm flutter test ...`, `fvm dart analyze`.

## File Structure

**Modified (token layer — Phase 1):**
- `lib/core/themes/helm_colors.dart` — recolor light + dark, both modes (hex only; field names, class, extension unchanged).
- `lib/core/themes/helm_typography.dart` — change `fontFamily` assignments only (display styles → Fraunces; money → mono; Bangla → HindSiliguri; UI → Inter). Style names + sizes + weights unchanged.
- `pubspec.yaml` — add `Fraunces` font family (weights 400/500/600) under `fonts:`.
- `test/core/themes/helm_colors_contrast_test.dart` — rewrite assertions to new palette + new canvas constants.

**Created (Paper Ledger widgets — Phase 2):**
- `lib/core/widgets/ledger/helm_ledger_hero.dart` — S2S hero (Fraunces number, 3pt rail, runway line). Replaces `HelmSignalHero`.
- `lib/core/widgets/ledger/helm_ledger_row.dart` — committed/reserve/pending row (label + mono figure + hairline). Replaces inline signal chips.
- `lib/core/widgets/ledger/helm_next_event_card.dart` — "one next event" card, terracotta action. Replaces `HelmDecisionDeck`.
- `lib/core/widgets/ledger/ledger_state.dart` — `LedgerState { safe, tight, atRisk }` enum + label/color mapping (replaces `SignalDeckState`).
- Test files mirroring each under `test/core/widgets/ledger/`.

**Deleted (Phase 2):**
- `lib/core/themes/helm_signal_theme.dart`
- `lib/core/widgets/signal/helm_signal_hero.dart`
- `lib/core/widgets/signal/helm_signal_horizon.dart`
- `lib/core/widgets/signal/helm_decision_deck.dart`
- `lib/core/widgets/signal/helm_flow_route.dart`
- `test/core/themes/helm_signal_theme_test.dart`
- `test/core/widgets/signal/*` (4 files)

**Modified (consumers — Phase 2):**
- `lib/features/dashboard/presentation/views/dashboard_screen.dart` — swap signal widgets → ledger widgets, scaffold uses `context.colors.canvas`.
- `lib/core/widgets/helm_calculation_trace.dart` — drop `HelmSignalTheme`, read `context.colors` (it's the hero-tap trace sheet; trust layer).

**Modified (nav — Phase 6):**
- `lib/config/router/app_router.dart` — add 4th `_TabItem` (Settings) to `_tabs`; relabel tabs to Paper Ledger naming (Home/Pipeline/History/Settings).

**Golden + QA (Phases 1 & 7):**
- `test/golden/dashboard_golden_test.dart` — regenerate baselines (Phase 1 cascade); add dark-mode variants (Phase 7).
- `test/golden/goldens/*.png` — regenerated.

---

## Task 1: Add Fraunces font asset

**Files:**
- Modify: `pubspec.yaml` (the `flutter: fonts:` section)
- Add binaries: `assets/fonts/Fraunces-Regular.ttf`, `assets/fonts/Fraunces-Medium.ttf`, `assets/fonts/Fraunces-SemiBold.ttf`

**Interfaces:**
- Consumes: nothing.
- Produces: a bundled font family named `Fraunces` (weights 400, 500, 600) usable as `fontFamily: 'Fraunces'`.

- [ ] **Step 1: Place font binaries**

Download Fraunces static TTFs (Regular/Medium/SemiBold) from Google Fonts and place them at:
```
assets/fonts/Fraunces-Regular.ttf
assets/fonts/Fraunces-Medium.ttf
assets/fonts/Fraunces-SemiBold.ttf
```
Verify they exist:
```bash
ls -la assets/fonts/Fraunces-*.ttf
```
Expected: 3 files listed, non-zero size.

- [ ] **Step 2: Declare the family in pubspec.yaml**

In `pubspec.yaml`, under `flutter:` → `fonts:`, after the existing `HindSiliguri` family block, add:

```yaml
    - family: Fraunces
      fonts:
        - asset: assets/fonts/Fraunces-Regular.ttf
          weight: 400
        - asset: assets/fonts/Fraunces-Medium.ttf
          weight: 500
        - asset: assets/fonts/Fraunces-SemiBold.ttf
          weight: 600
```

- [ ] **Step 3: Resolve assets + verify analyzer**

Run:
```bash
fvm flutter pub get && fvm dart analyze
```
Expected: `pub get` succeeds; analyze reports `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock assets/fonts/Fraunces-Regular.ttf assets/fonts/Fraunces-Medium.ttf assets/fonts/Fraunces-SemiBold.ttf
git commit -m "chore(theme): bundle Fraunces font asset for Paper Ledger"
```

---

## Task 2: Recolor HelmColors to Paper Ledger palette (light + dark)

**Files:**
- Modify: `lib/core/themes/helm_colors.dart` (the `static const HelmColors light` and `static const HelmColors dark` blocks only)
- Test: `test/core/themes/helm_colors_contrast_test.dart` (rewritten)

**Interfaces:**
- Consumes: nothing.
- Produces: `HelmColors.light` and `HelmColors.dark` with Paper Ledger hex values. Field names, class, `copyWith`, `lerp`, and `BuildContextHelmColors.colors` all unchanged — every existing `context.colors.*` call stays valid.

- [ ] **Step 1: Write the failing contrast test (new palette)**

Replace the entire body of `test/core/themes/helm_colors_contrast_test.dart`'s `main()` with assertions against the new canvases. Keep the `_linearize` / `_relativeLuminance` / `_computeContrast` helpers as-is. New `main()`:

```dart
void main() {
  const lightCanvas = Color(0xFFF3ECE0);
  const darkCanvas = Color(0xFF1E1813);

  group('HelmColors light mode WCAG AA contrast (>=4.5:1 on paper canvas)', () {
    test('stateSafe on light canvas', () {
      expect(_computeContrast(HelmColors.light.stateSafe, lightCanvas),
          greaterThanOrEqualTo(4.5));
    });
    test('stateTight on light canvas', () {
      expect(_computeContrast(HelmColors.light.stateTight, lightCanvas),
          greaterThanOrEqualTo(4.5));
    });
    test('stateAtRisk on light canvas', () {
      expect(_computeContrast(HelmColors.light.stateAtRisk, lightCanvas),
          greaterThanOrEqualTo(4.5));
    });
    test('inkPrimary on light canvas', () {
      expect(_computeContrast(HelmColors.light.inkPrimary, lightCanvas),
          greaterThanOrEqualTo(7.0));
    });
    test('inkSecondary on light canvas', () {
      expect(_computeContrast(HelmColors.light.inkSecondary, lightCanvas),
          greaterThanOrEqualTo(4.5));
    });
  });

  group('HelmColors dark mode WCAG AA contrast (>=4.5:1 on espresso canvas)', () {
    test('interactive on dark canvas', () {
      expect(_computeContrast(HelmColors.dark.interactive, darkCanvas),
          greaterThanOrEqualTo(4.5));
    });
    test('inkPrimary on dark canvas', () {
      expect(_computeContrast(HelmColors.dark.inkPrimary, darkCanvas),
          greaterThanOrEqualTo(7.0));
    });
    test('stateSafe on dark canvas', () {
      expect(_computeContrast(HelmColors.dark.stateSafe, darkCanvas),
          greaterThanOrEqualTo(4.5));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
fvm flutter test test/core/themes/helm_colors_contrast_test.dart
```
Expected: FAIL — old hex values don't match new canvases / some contrasts under threshold (and `inkSecondary` check is new).

- [ ] **Step 3: Recolor the light block**

In `lib/core/themes/helm_colors.dart`, replace the `static const HelmColors light = HelmColors(...)` block with:

```dart
  static const HelmColors light = HelmColors(
    canvas:         Color(0xFFF3ECE0), // warm paper
    surface:        Color(0xFFEAE0D0), // cards, elevated panels
    inkPrimary:     Color(0xFF2B2521), // numbers, critical text
    inkSecondary:   Color(0xFF5C5247), // labels, timestamps
    inkTertiary:    Color(0xFF8A7A5E), // helper text, metadata
    interactive:    Color(0xFFC2603F), // terracotta — tappable affordances
    divider:        Color(0xFFDED2BF), // card borders
    hairline:       Color(0xFFE8DECB), // internal dividers
    stateSafe:      Color(0xFF5E7C63), // stable signal, runway rail
    stateTight:     Color(0xFF9A7B2F), // reduced runway
    stateAtRisk:    Color(0xFFA8443A), // imminent harm only
    stateHope:      Color(0xFF5A7585), // uncertain/pending money text
    stateHopeMuted: Color(0xFF8A9DA6), // pending decorative markers
  );
```

- [ ] **Step 4: Recolor the dark block**

Replace the `static const HelmColors dark = HelmColors(...)` block with:

```dart
  static const HelmColors dark = HelmColors(
    canvas:         Color(0xFF1E1813), // warm espresso (NOT black)
    surface:        Color(0xFF271F18),
    inkPrimary:     Color(0xFFF3EAD9),
    inkSecondary:   Color(0xFFC7B9A2),
    inkTertiary:    Color(0xFF9A8A70),
    interactive:    Color(0xFFD8744F), // terracotta, lifted for dark
    divider:        Color(0xFF3A2F25),
    hairline:       Color(0xFF332A21),
    stateSafe:      Color(0xFF86A88A),
    stateTight:     Color(0xFFD4A668),
    stateAtRisk:    Color(0xFFC56A58),
    stateHope:      Color(0xFF7A95A8),
    stateHopeMuted: Color(0xFF5A6E77),
  );
```

- [ ] **Step 5: Run test to verify it passes**

Run:
```bash
fvm flutter test test/core/themes/helm_colors_contrast_test.dart
```
Expected: PASS — all contrast assertions green. If `stateTight` light fails (gold on paper is borderline), darken to `Color(0xFF8A6E2A)` and re-run. If `inkSecondary` light fails, darken to `Color(0xFF544A40)`.

- [ ] **Step 6: Verify analyzer**

```bash
fvm dart analyze lib/core/themes/helm_colors.dart
```
Expected: `No issues found!`

- [ ] **Step 7: Commit**

```bash
git add lib/core/themes/helm_colors.dart test/core/themes/helm_colors_contrast_test.dart
git commit -m "feat(theme): recolor HelmColors to Paper Ledger palette (light + dark)"
```

---

## Task 3: Rebuild HelmTypography font families

**Files:**
- Modify: `lib/core/themes/helm_typography.dart` (the `build()` factory only — `fontFamily` strings)
- Test: `test/core/themes/helm_typography_fonts_test.dart` (create)

**Interfaces:**
- Consumes: `HelmColors` (unchanged signature).
- Produces: `HelmTypography.build(colors)` where `displayHero`/`displayLarge`/`headingLg`/`headingMd`/`headingSm` use `'Fraunces'`; `bodyLg`/`bodyMd`/`bodySm`/`labelMd`/`labelSm` use `'Inter'`; `monoFinancial*`/`monoHero` use `'JetBrainsMono'`; `*Bn` use `'HindSiliguri'`. All style names, sizes, weights, heights unchanged.

- [ ] **Step 1: Write the failing test**

Create `test/core/themes/helm_typography_fonts_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/themes/helm_typography.dart';

void main() {
  final t = HelmTypography.build(HelmColors.light);

  group('Display + heading styles use Fraunces', () {
    test('displayHero', () => expect(t.displayHero.fontFamily, 'Fraunces'));
    test('displayLarge', () => expect(t.displayLarge.fontFamily, 'Fraunces'));
    test('headingLg', () => expect(t.headingLg.fontFamily, 'Fraunces'));
    test('headingMd', () => expect(t.headingMd.fontFamily, 'Fraunces'));
    test('headingSm', () => expect(t.headingSm.fontFamily, 'Fraunces'));
  });

  group('Body + label styles use Inter', () {
    test('bodyLg', () => expect(t.bodyLg.fontFamily, 'Inter'));
    test('bodyMd', () => expect(t.bodyMd.fontFamily, 'Inter'));
    test('bodySm', () => expect(t.bodySm.fontFamily, 'Inter'));
    test('labelMd', () => expect(t.labelMd.fontFamily, 'Inter'));
    test('labelSm', () => expect(t.labelSm.fontFamily, 'Inter'));
  });

  group('Money styles use the mono family', () {
    test('monoFinancialSm', () => expect(t.monoFinancialSm.fontFamily, 'JetBrainsMono'));
    test('monoFinancialMd', () => expect(t.monoFinancialMd.fontFamily, 'JetBrainsMono'));
    test('monoFinancialLg', () => expect(t.monoFinancialLg.fontFamily, 'JetBrainsMono'));
    test('monoHero', () => expect(t.monoHero.fontFamily, 'JetBrainsMono'));
  });

  group('Bangla styles use Hind Siliguri', () {
    test('bodyLgBn', () => expect(t.bodyLgBn.fontFamily, 'HindSiliguri'));
    test('labelMdBn', () => expect(t.labelMdBn.fontFamily, 'HindSiliguri'));
  });

  test('weights stay within 400-600', () {
    for (final s in [t.displayHero, t.headingLg, t.bodyMd, t.labelSm]) {
      final w = s.fontWeight!.index;
      expect(w, inInclusiveRange(FontWeight.w400.index, FontWeight.w600.index));
    }
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
fvm flutter test test/core/themes/helm_typography_fonts_test.dart
```
Expected: FAIL — display styles currently report `'Inter'`, not `'Fraunces'`.

- [ ] **Step 3: Change the font families in build()**

In `lib/core/themes/helm_typography.dart`, inside `static HelmTypography build(HelmColors colors)`, change the `fontFamily:` line of each style. Set:
- `displayHero`, `displayLarge`, `headingLg`, `headingMd`, `headingSm` → `fontFamily: 'Fraunces',`
- `bodyLg`, `bodyMd`, `bodySm`, `labelMd`, `labelSm` → leave `fontFamily: 'Inter',`
- `monoFinancialSm`, `monoFinancialMd`, `monoFinancialLg`, `monoHero` → leave `fontFamily: 'JetBrainsMono',`
- `bodyLgBn`, `bodyMdBn`, `bodySmBn`, `labelMdBn` → leave `fontFamily: 'HindSiliguri',`

Do not touch `fontSize`, `fontWeight`, `height`, or `color`. Also update the file's header comment block (the `// UI text (Latin): Inter` lines) to note display→Fraunces.

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
fvm flutter test test/core/themes/helm_typography_fonts_test.dart
```
Expected: PASS.

- [ ] **Step 5: Verify analyzer**

```bash
fvm dart analyze lib/core/themes/helm_typography.dart
```
Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/core/themes/helm_typography.dart test/core/themes/helm_typography_fonts_test.dart
git commit -m "feat(theme): map display styles to Fraunces in HelmTypography"
```

---

## Task 4: Regenerate light-mode golden baselines (Phase 1 cascade)

**Files:**
- Modify (regenerated images): `test/golden/goldens/*.png`
- Test (unchanged code): `test/golden/dashboard_golden_test.dart`

**Interfaces:**
- Consumes: new `HelmColors` + `HelmTypography` (Tasks 2–3). These widgets (`S2sHeroBlock`, `CommittedSection`, `ReserveSection`, `NotCountedSection`, `NextBestActionCard`) read `context.colors`/`context.textStyles`, so they re-skin automatically; only their pixel baselines shift.
- Produces: updated golden PNGs that encode the Paper Ledger look.

- [ ] **Step 1: Confirm goldens currently fail against new tokens**

Run:
```bash
fvm flutter test test/golden/dashboard_golden_test.dart
```
Expected: FAIL — pixel diffs because colors + fonts changed.

- [ ] **Step 2: Regenerate baselines**

Run:
```bash
fvm flutter test test/golden/dashboard_golden_test.dart --update-goldens
```
Expected: PASS, PNGs rewritten under `test/golden/goldens/`.

- [ ] **Step 3: Re-run to verify clean**

Run:
```bash
fvm flutter test test/golden/dashboard_golden_test.dart
```
Expected: PASS — no diffs.

- [ ] **Step 4: Visually sanity-check one baseline**

Open `test/golden/goldens/s2s_hero_block_safe.png` and confirm warm paper background + serif number. If it still looks white/dark, Tasks 2–3 didn't apply — stop and re-check.

- [ ] **Step 5: Commit**

```bash
git add test/golden/goldens
git commit -m "test(golden): regenerate light baselines for Paper Ledger tokens"
```

---

## Task 5: Run full suite — confirm token cascade is non-breaking

**Files:** none (verification gate).

**Interfaces:**
- Consumes: Tasks 1–4.
- Produces: a green baseline proving the ~23 token-only screens migrated with no code edits.

- [ ] **Step 1: Analyze whole project**

```bash
fvm dart analyze
```
Expected: `No issues found!` (0/0/0).

- [ ] **Step 2: Run full test suite (excluding goldens for speed parity with CI)**

```bash
fvm flutter test --exclude-tags golden
```
Expected: all PASS. If any widget test asserted an old hex value directly, fix that test to read `context.colors` or the new value, then re-run.

- [ ] **Step 3: Run golden suite**

```bash
fvm flutter test test/golden/dashboard_golden_test.dart
```
Expected: PASS.

- [ ] **Step 4: Commit any test fixes**

```bash
git add -A
git commit -m "test: align stray theme assertions with Paper Ledger tokens"
```
(If nothing changed, skip the commit.)

---

## Task 6: Create LedgerState enum

**Files:**
- Create: `lib/core/widgets/ledger/ledger_state.dart`
- Test: `test/core/widgets/ledger/ledger_state_test.dart`

**Interfaces:**
- Consumes: `HelmColors` via `BuildContext`.
- Produces:
  - `enum LedgerState { safe, tight, atRisk }`
  - `Color ledgerStateColor(BuildContext context, LedgerState state)` → `context.colors.stateSafe / stateTight / stateAtRisk`
  - `String ledgerStateLabel(LedgerState state)` → `'Stable' / 'Tight' / 'At Risk'`

- [ ] **Step 1: Write the failing test**

Create `test/core/widgets/ledger/ledger_state_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/widgets/ledger/ledger_state.dart';

void main() {
  test('labels map correctly', () {
    expect(ledgerStateLabel(LedgerState.safe), 'Stable');
    expect(ledgerStateLabel(LedgerState.tight), 'Tight');
    expect(ledgerStateLabel(LedgerState.atRisk), 'At Risk');
  });

  testWidgets('colors resolve from HelmColors', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light,
      home: Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      }),
    ));
    expect(ledgerStateColor(ctx, LedgerState.safe), HelmColors.light.stateSafe);
    expect(ledgerStateColor(ctx, LedgerState.tight), HelmColors.light.stateTight);
    expect(ledgerStateColor(ctx, LedgerState.atRisk), HelmColors.light.stateAtRisk);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
fvm flutter test test/core/widgets/ledger/ledger_state_test.dart
```
Expected: FAIL — `ledger_state.dart` does not exist.

- [ ] **Step 3: Write minimal implementation**

Create `lib/core/widgets/ledger/ledger_state.dart`:

```dart
// lib/core/widgets/ledger/ledger_state.dart
// Paper Ledger — runway state used by HelmLedgerHero.
// Replaces SignalDeckState. Colors resolve from HelmColors (theme-aware).

import 'package:flutter/material.dart';

import '../../themes/helm_colors.dart';

enum LedgerState { safe, tight, atRisk }

Color ledgerStateColor(BuildContext context, LedgerState state) {
  final colors = context.colors;
  return switch (state) {
    LedgerState.safe => colors.stateSafe,
    LedgerState.tight => colors.stateTight,
    LedgerState.atRisk => colors.stateAtRisk,
  };
}

String ledgerStateLabel(LedgerState state) {
  return switch (state) {
    LedgerState.safe => 'Stable',
    LedgerState.tight => 'Tight',
    LedgerState.atRisk => 'At Risk',
  };
}
```

- [ ] **Step 4: Run test to verify it passes**

```bash
fvm flutter test test/core/widgets/ledger/ledger_state_test.dart && fvm dart analyze lib/core/widgets/ledger/ledger_state.dart
```
Expected: PASS + `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/ledger/ledger_state.dart test/core/widgets/ledger/ledger_state_test.dart
git commit -m "feat(ledger): add LedgerState enum + theme-aware mappings"
```

---

## Task 7: Create HelmLedgerRow

**Files:**
- Create: `lib/core/widgets/ledger/helm_ledger_row.dart`
- Test: `test/core/widgets/ledger/helm_ledger_row_test.dart`

**Interfaces:**
- Consumes: `context.colors`, `context.textStyles`.
- Produces:
  ```dart
  class HelmLedgerRow extends StatelessWidget {
    const HelmLedgerRow({
      required String label,
      required String value,   // pre-formatted money string (Latin numerals)
      bool muted = false,      // pending rows use inkTertiary
      bool showDivider = true, // hairline below
      Key? key,
    });
  }
  ```

- [ ] **Step 1: Write the failing test**

Create `test/core/widgets/ledger/helm_ledger_row_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/widgets/ledger/helm_ledger_row.dart';

Widget _wrap(Widget child) =>
    MaterialApp(theme: AppTheme.light, home: Scaffold(body: child));

void main() {
  testWidgets('renders label and value', (tester) async {
    await tester.pumpWidget(_wrap(
      const HelmLedgerRow(label: 'Already committed', value: '24,000'),
    ));
    expect(find.text('Already committed'), findsOneWidget);
    expect(find.text('24,000'), findsOneWidget);
  });

  testWidgets('muted row exposes muted flag without throwing', (tester) async {
    await tester.pumpWidget(_wrap(
      const HelmLedgerRow(label: 'Not counted yet', value: r'$600', muted: true),
    ));
    expect(find.byType(HelmLedgerRow), findsOneWidget);
    expect(find.text(r'$600'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
fvm flutter test test/core/widgets/ledger/helm_ledger_row_test.dart
```
Expected: FAIL — file missing.

- [ ] **Step 3: Write minimal implementation**

Create `lib/core/widgets/ledger/helm_ledger_row.dart`:

```dart
// lib/core/widgets/ledger/helm_ledger_row.dart
// Paper Ledger — a single committed/reserve/pending row.
// Label (Inter) on the left, money figure (mono, Latin numerals) on the right,
// optional hairline divider beneath.

import 'package:flutter/material.dart';

import '../../themes/helm_colors.dart';
import '../../themes/helm_spacing.dart';
import '../../themes/helm_typography.dart';

class HelmLedgerRow extends StatelessWidget {
  const HelmLedgerRow({
    required this.label,
    required this.value,
    this.muted = false,
    this.showDivider = true,
    super.key,
  });

  final String label;
  final String value;
  final bool muted;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.textStyles;
    final valueColor = muted ? colors.inkTertiary : colors.inkPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: HelmSpacing.s3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: typography.bodySm.copyWith(color: colors.inkSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: HelmSpacing.s3),
              Text(
                value,
                style: typography.monoFinancialSm.copyWith(color: valueColor),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: colors.hairline),
      ],
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

```bash
fvm flutter test test/core/widgets/ledger/helm_ledger_row_test.dart && fvm dart analyze lib/core/widgets/ledger/helm_ledger_row.dart
```
Expected: PASS + `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/ledger/helm_ledger_row.dart test/core/widgets/ledger/helm_ledger_row_test.dart
git commit -m "feat(ledger): add HelmLedgerRow"
```

---

## Task 8: Create HelmLedgerHero

**Files:**
- Create: `lib/core/widgets/ledger/helm_ledger_hero.dart`
- Test: `test/core/widgets/ledger/helm_ledger_hero_test.dart`

**Interfaces:**
- Consumes: `context.colors`, `context.textStyles`, `LedgerState` (Task 6), `HelmLedgerRow` (Task 7).
- Produces:
  ```dart
  class HelmLedgerHero extends StatelessWidget {
    const HelmLedgerHero({
      required double safeToSpend,
      required LedgerState state,
      required String runwayLabel,
      required String committedValue, // pre-formatted, Latin numerals
      required String reserveValue,
      required String pendingValue,
      required VoidCallback onTapTrace,
      bool showUnavailable = false,
      Key? key,
    });
  }
  ```
  Renders the S2S number in Fraunces (`displayHero`), a 3pt rail colored by `ledgerStateColor`, an italic Fraunces runway line, then three `HelmLedgerRow`s (committed, reserve, pending-muted). Whole hero is tappable → `onTapTrace`. No CustomPainter, no animation.

- [ ] **Step 1: Write the failing test**

Create `test/core/widgets/ledger/helm_ledger_hero_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/widgets/ledger/helm_ledger_hero.dart';
import 'package:helm/core/widgets/ledger/ledger_state.dart';

Widget _wrap(Widget child) =>
    MaterialApp(theme: AppTheme.light, home: Scaffold(body: child));

HelmLedgerHero _hero({VoidCallback? onTap, bool unavailable = false}) =>
    HelmLedgerHero(
      safeToSpend: 36000,
      state: LedgerState.safe,
      runwayLabel: 'Covers 17 days at your usual pace',
      committedValue: '24,000',
      reserveValue: '10,000',
      pendingValue: r'$600',
      showUnavailable: unavailable,
      onTapTrace: onTap ?? () {},
    );

void main() {
  testWidgets('shows formatted amount and runway', (tester) async {
    await tester.pumpWidget(_wrap(_hero()));
    expect(find.textContaining('36,000'), findsOneWidget);
    expect(find.text('Covers 17 days at your usual pace'), findsOneWidget);
  });

  testWidgets('shows em dash when unavailable', (tester) async {
    await tester.pumpWidget(_wrap(_hero(unavailable: true)));
    expect(find.textContaining('—'), findsOneWidget);
  });

  testWidgets('tapping invokes onTapTrace', (tester) async {
    var tapped = false;
    TestWidgetsFlutterBinding.ensureInitialized();
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
    await tester.pumpWidget(_wrap(_hero(onTap: () => tapped = true)));
    await tester.tap(find.byType(HelmLedgerHero));
    await tester.pump();
    expect(tapped, isTrue);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
fvm flutter test test/core/widgets/ledger/helm_ledger_hero_test.dart
```
Expected: FAIL — file missing.

- [ ] **Step 3: Write minimal implementation**

Create `lib/core/widgets/ledger/helm_ledger_hero.dart`:

```dart
// lib/core/widgets/ledger/helm_ledger_hero.dart
// Paper Ledger — the Safe-to-Spend hero.
// Fraunces number on paper, 3pt runway rail (state color), italic runway line,
// then committed/reserve/pending rows. Tappable -> calculation trace.
// No decorative animation: calm, static, trustworthy.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/helm_colors.dart';
import '../../themes/helm_spacing.dart';
import '../../themes/helm_typography.dart';
import '../../utils/number_formatter.dart';
import 'helm_ledger_row.dart';
import 'ledger_state.dart';

class HelmLedgerHero extends StatelessWidget {
  const HelmLedgerHero({
    required this.safeToSpend,
    required this.state,
    required this.runwayLabel,
    required this.committedValue,
    required this.reserveValue,
    required this.pendingValue,
    required this.onTapTrace,
    this.showUnavailable = false,
    super.key,
  });

  final double safeToSpend;
  final LedgerState state;
  final String runwayLabel;
  final String committedValue;
  final String reserveValue;
  final String pendingValue;
  final VoidCallback onTapTrace;
  final bool showUnavailable;

  Future<void> _handleTap() async {
    await HapticFeedback.lightImpact();
    onTapTrace();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.textStyles;
    final railColor = ledgerStateColor(context, state);

    final amount = showUnavailable
        ? '—' // em dash
        : '৳${NumberFormatter.formatBDTCompact(safeToSpend).replaceFirst('tk ', '')}';

    return Semantics(
      label: 'Safe to spend now '
          '${showUnavailable ? 'unavailable' : amount}. '
          '${ledgerStateLabel(state)}. $runwayLabel.',
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: Container(
          padding: const EdgeInsets.all(HelmSpacing.s5),
          decoration: BoxDecoration(
            color: colors.canvas,
            borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SAFE TO SPEND NOW',
                style: typography.labelSm.copyWith(color: colors.inkSecondary),
              ),
              const SizedBox(height: HelmSpacing.s2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  amount,
                  maxLines: 1,
                  style: typography.displayHero.copyWith(color: colors.inkPrimary),
                ),
              ),
              const SizedBox(height: HelmSpacing.s3),
              Container(
                height: 3,
                width: 80,
                decoration: BoxDecoration(
                  color: railColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: HelmSpacing.s3),
              Text(
                runwayLabel,
                style: typography.bodySm.copyWith(
                  color: colors.inkSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: HelmSpacing.s4),
              HelmLedgerRow(label: 'Already committed', value: committedValue),
              HelmLedgerRow(label: 'Reserve · protected', value: reserveValue),
              HelmLedgerRow(
                label: 'Not counted yet',
                value: pendingValue,
                muted: true,
                showDivider: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

```bash
fvm flutter test test/core/widgets/ledger/helm_ledger_hero_test.dart && fvm dart analyze lib/core/widgets/ledger/helm_ledger_hero.dart
```
Expected: PASS + `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/ledger/helm_ledger_hero.dart test/core/widgets/ledger/helm_ledger_hero_test.dart
git commit -m "feat(ledger): add HelmLedgerHero (static, paper, serif)"
```

---

## Task 9: Create HelmNextEventCard

**Files:**
- Create: `lib/core/widgets/ledger/helm_next_event_card.dart`
- Test: `test/core/widgets/ledger/helm_next_event_card_test.dart`

**Interfaces:**
- Consumes: `context.colors`, `context.textStyles`.
- Produces:
  ```dart
  class HelmNextEventCard extends StatelessWidget {
    const HelmNextEventCard({
      required String eventLabel,   // e.g. "NEXT EVENT"
      required String eventTitle,
      required String actionLabel,
      required VoidCallback onAction,
      VoidCallback? onTrace,
      Key? key,
    });
  }
  ```
  Paper `surface` card with `divider` border, Fraunces title (`headingSm`), terracotta `ElevatedButton` (inherits `interactive` from theme), optional "View trace" TextButton.

- [ ] **Step 1: Write the failing test**

Create `test/core/widgets/ledger/helm_next_event_card_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/widgets/ledger/helm_next_event_card.dart';

Widget _wrap(Widget child) =>
    MaterialApp(theme: AppTheme.light, home: Scaffold(body: child));

void main() {
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
  });

  testWidgets('renders label, title, action', (tester) async {
    await tester.pumpWidget(_wrap(HelmNextEventCard(
      eventLabel: 'NEXT EVENT',
      eventTitle: 'Upwork payout lands in 3 days',
      actionLabel: 'Mark as received',
      onAction: () {},
    )));
    expect(find.text('NEXT EVENT'), findsOneWidget);
    expect(find.text('Upwork payout lands in 3 days'), findsOneWidget);
    expect(find.text('Mark as received'), findsOneWidget);
  });

  testWidgets('tapping action fires callback', (tester) async {
    var fired = false;
    await tester.pumpWidget(_wrap(HelmNextEventCard(
      eventLabel: 'NEXT EVENT',
      eventTitle: 'x',
      actionLabel: 'Go',
      onAction: () => fired = true,
    )));
    await tester.tap(find.text('Go'));
    await tester.pump();
    expect(fired, isTrue);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
fvm flutter test test/core/widgets/ledger/helm_next_event_card_test.dart
```
Expected: FAIL — file missing.

- [ ] **Step 3: Write minimal implementation**

Create `lib/core/widgets/ledger/helm_next_event_card.dart`:

```dart
// lib/core/widgets/ledger/helm_next_event_card.dart
// Paper Ledger — the one "next event" card. Paper surface, terracotta action.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../themes/helm_colors.dart';
import '../../themes/helm_spacing.dart';
import '../../themes/helm_typography.dart';

class HelmNextEventCard extends StatelessWidget {
  const HelmNextEventCard({
    required this.eventLabel,
    required this.eventTitle,
    required this.actionLabel,
    required this.onAction,
    this.onTrace,
    super.key,
  });

  final String eventLabel;
  final String eventTitle;
  final String actionLabel;
  final VoidCallback onAction;
  final VoidCallback? onTrace;

  Future<void> _handleAction() async {
    await HapticFeedback.lightImpact();
    onAction();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.textStyles;

    return Container(
      padding: const EdgeInsets.all(HelmSpacing.s5),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(HelmSpacing.cardRadius),
        border: Border.all(color: colors.divider, width: HelmSpacing.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            eventLabel,
            style: typography.labelSm.copyWith(color: colors.inkTertiary),
          ),
          const SizedBox(height: HelmSpacing.s2),
          Text(
            eventTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: typography.headingSm.copyWith(color: colors.inkPrimary),
          ),
          const SizedBox(height: HelmSpacing.s4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleAction,
              child: Text(actionLabel, textAlign: TextAlign.center),
            ),
          ),
          if (onTrace != null) ...[
            const SizedBox(height: HelmSpacing.s1),
            TextButton(onPressed: onTrace, child: const Text('View trace')),
          ],
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

```bash
fvm flutter test test/core/widgets/ledger/helm_next_event_card_test.dart && fvm dart analyze lib/core/widgets/ledger/helm_next_event_card.dart
```
Expected: PASS + `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/ledger/helm_next_event_card.dart test/core/widgets/ledger/helm_next_event_card_test.dart
git commit -m "feat(ledger): add HelmNextEventCard"
```

---

## Task 10: Migrate HelmCalculationTrace off HelmSignalTheme

**Files:**
- Modify: `lib/core/widgets/helm_calculation_trace.dart`
- Test: `test/core/widgets/helm_calculation_trace_test.dart` (create if absent)

**Interfaces:**
- Consumes: `context.colors`, `context.textStyles`.
- Produces: the same `HelmCalculationTrace.show(context, result)` API and `Key('signal_trace_sheet')` (kept so existing references/tests don't break), but rendered on `surface` with `inkPrimary`/`inkSecondary`/`hairline` instead of `HelmSignalTheme.*`.

- [ ] **Step 1: Write the failing test**

Create `test/core/widgets/helm_calculation_trace_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/widgets/helm_calculation_trace.dart';
import 'package:helm/features/safe_to_spend/domain/entities/safe_to_spend_result.dart';
import 'package:helm/l10n/app_localizations.dart';

const _result = SafeToSpendResult(
  liquidCash: 100000,
  safeToSpend: 45000,
  rawSafeToSpend: 45000,
  fixedCostsDue: 15000,
  anxietyBuffer: 5000,
  taxReserve: 10000,
  totalReceivedIncomeBdt: 100000,
  totalExpenses: 25000,
  pendingIncome: 20000,
  expectedIncome: 30000,
  horizonNumber: 75000,
  excludedUsdIncome: 0,
  excludedUsdEntryCount: 0,
);

void main() {
  testWidgets('trace sheet renders on paper surface', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light,
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('bn')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const Scaffold(body: HelmCalculationTrace(result: _result)),
    ));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('signal_trace_sheet')), findsOneWidget);

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byKey(const Key('signal_trace_sheet')),
        matching: find.byType(Container),
      ).first,
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, HelmColors.light.surface);
  });
}
```

> The real guard for this task is Step 4's grep proving zero `HelmSignalTheme` references remain. This test asserts the sheet now paints on `HelmColors.light.surface`. Add `import 'package:helm/core/themes/helm_colors.dart';` to the test imports.

- [ ] **Step 2: Run test to verify it fails (or trace still imports signal theme)**

```bash
fvm flutter test test/core/widgets/helm_calculation_trace_test.dart
```
Expected: PASS structurally but the file still imports `helm_signal_theme.dart`. Confirm the coupling:
```bash
grep -n "HelmSignalTheme" lib/core/widgets/helm_calculation_trace.dart
```
Expected: several matches (these must all be gone after Step 3).

- [ ] **Step 3: Replace HelmSignalTheme usages with context.colors**

In `lib/core/widgets/helm_calculation_trace.dart`:

1. Delete the import `import 'package:helm/core/themes/helm_signal_theme.dart';`.
2. In the `DraggableScrollableSheet` builder, replace the sheet `Container` decoration:
   ```dart
   decoration: BoxDecoration(
     color: context.colors.surface,
     borderRadius: const BorderRadius.vertical(
       top: Radius.circular(HelmSpacing.sheetTopRadius),
     ),
   ),
   ```
   (Drop `HelmSignalTheme.floatingSheetShadow` — Paper Ledger uses borders, not glass shadows.)
3. Drag handle color → `context.colors.hairline`.
4. Header title `color:` → `context.colors.inkPrimary`; subtitle → `context.colors.inkSecondary`.
5. Header divider `color:` → `context.colors.hairline`.
6. In `_TraceLineRow.build`, replace the `colors.copyWith(inkPrimary: HelmSignalTheme..., inkTertiary: HelmSignalTheme...)` override with plain `colors` (no override needed now that the sheet is on `surface`):
   ```dart
   final amountTheme = Theme.of(context).copyWith(
     extensions: <ThemeExtension<dynamic>>[colors, typography],
   );
   ```
7. Final-row divider color (`HelmSignalTheme.signalGlow`) → `context.colors.stateSafe`.
8. Label colors: final row → `colors.inkPrimary`; normal rows → `colors.inkSecondary`.

- [ ] **Step 4: Run test + analyzer**

```bash
fvm flutter test test/core/widgets/helm_calculation_trace_test.dart && grep -c "HelmSignalTheme" lib/core/widgets/helm_calculation_trace.dart
```
Expected: test PASS; grep prints `0`.

- [ ] **Step 5: Commit**

```bash
git add lib/core/widgets/helm_calculation_trace.dart test/core/widgets/helm_calculation_trace_test.dart
git commit -m "refactor(trace): render calculation trace on Paper Ledger tokens"
```

---

## Task 11: Rewrite dashboard_screen.dart to Paper Ledger

**Files:**
- Modify: `lib/features/dashboard/presentation/views/dashboard_screen.dart`
- Test: `test/features/dashboard/presentation/dashboard_screen_test.dart` (create if absent)

**Interfaces:**
- Consumes: `HelmLedgerHero` (Task 8), `HelmNextEventCard` (Task 9), `LedgerState` (Task 6), existing providers (`safeToSpendProvider`, `incomeNotifierProvider`), `NumberFormatter`, `HelmCalculationTrace`.
- Produces: a dashboard with no `HelmSignalTheme` / signal-widget imports. Keeps ALL analytics + nudge + affirmation logic untouched. Renames `_SignalDeckAction` → `_NextEventAction` (drops the `flowStage` field; `HelmNextEventCard` has no flow route).

- [ ] **Step 1: Write the failing test**

Create `test/features/dashboard/presentation/dashboard_screen_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/core/widgets/ledger/helm_ledger_hero.dart';
import 'package:helm/features/dashboard/presentation/views/dashboard_screen.dart';
import 'package:helm/l10n/app_localizations.dart';

void main() {
  testWidgets('dashboard shows the Paper Ledger hero', (tester) async {
    await tester.pumpWidget(ProviderScope(
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
        home: const DashboardScreen(),
      ),
    ));
    await tester.pump();
    expect(find.byType(HelmLedgerHero), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
fvm flutter test test/features/dashboard/presentation/dashboard_screen_test.dart
```
Expected: FAIL — dashboard still builds `HelmSignalHero`, not `HelmLedgerHero`.

- [ ] **Step 3: Swap imports**

In `dashboard_screen.dart`, remove:
```dart
import 'package:helm/core/themes/helm_signal_theme.dart';
import 'package:helm/core/widgets/signal/helm_decision_deck.dart';
import 'package:helm/core/widgets/signal/helm_flow_route.dart';
import 'package:helm/core/widgets/signal/helm_signal_hero.dart';
import 'package:helm/core/widgets/signal/helm_signal_horizon.dart';
```
Add:
```dart
import 'package:helm/core/themes/helm_colors.dart';
import 'package:helm/core/widgets/ledger/helm_ledger_hero.dart';
import 'package:helm/core/widgets/ledger/helm_next_event_card.dart';
import 'package:helm/core/widgets/ledger/ledger_state.dart';
```

- [ ] **Step 4: Replace Scaffold colors + body**

Change `backgroundColor: HelmSignalTheme.signalCanvas` → `backgroundColor: context.colors.canvas`. In the AppBar title `color:` → `context.colors.inkPrimary`; remove the `iconTheme` `HelmSignalTheme` color (let it inherit). For the S2S hint banner, replace `HelmSignalTheme.signalGlass`/`signalBorder`/`signalInteractive`/`signalInkMuted` with `context.colors.surface` (bg), `context.colors.divider` (border), `context.colors.interactive` (icon + text), `context.colors.inkTertiary` (close icon).

Replace the hero/horizon/deck `Column` children with:
```dart
HelmLedgerHero(
  safeToSpend: stsResult.safeToSpend,
  state: _ledgerState(stsResult),
  runwayLabel: _affirmation ?? _runwayLabel(stsResult),
  showUnavailable: _showUnavailableAmount(stsResult),
  committedValue: _compactBdtValue(stsResult.fixedCostsDue),
  reserveValue: _compactBdtValue(stsResult.anxietyBuffer),
  pendingValue: _compactBdtValue(stsResult.pendingIncome),
  onTapTrace: () => _openCalculationTrace(stsResult),
),
const SizedBox(height: HelmSpacing.s4),
HelmNextEventCard(
  eventLabel: deck.eventLabel,
  eventTitle: deck.eventTitle,
  actionLabel: deck.actionLabel,
  onTrace: () => _openCalculationTrace(stsResult),
  onAction: () => context.push(deck.routePath),
),
```
(Delete `HelmSignalHorizon` — Paper Ledger has no horizon line; the rail lives inside the hero.)

- [ ] **Step 5: Update the state mapper + helpers**

Rename `_signalState` → `_ledgerState` returning `LedgerState`:
```dart
LedgerState _ledgerState(SafeToSpendResult result) {
  if (result.rawSafeToSpend > 0) return LedgerState.safe;
  if (result.rawSafeToSpend > -result.anxietyBuffer) return LedgerState.tight;
  return LedgerState.atRisk;
}
```
Add a value-only formatter (no signal label prefix):
```dart
String _compactBdtValue(double amount) =>
    NumberFormatter.formatBDTCompact(amount).replaceFirst('tk ', '৳');
```
Keep `_runwayLabel`, `_showUnavailableAmount`, `_openCalculationTrace` as-is. Delete the old `_compactBdt` if now unused.

- [ ] **Step 6: Rename _SignalDeckAction → _NextEventAction**

Replace the private class + its builder return types: drop the `flowStage` field everywhere, rename `_SignalDeckAction` → `_NextEventAction`, and rename `_buildDecisionDeckAction` → `_buildNextEventAction`. Remove the `SignalFlowStage.*` values from each returned record.

- [ ] **Step 7: Run test + analyzer**

```bash
fvm flutter test test/features/dashboard/presentation/dashboard_screen_test.dart && fvm dart analyze lib/features/dashboard/presentation/views/dashboard_screen.dart
```
Expected: PASS + `No issues found!`

- [ ] **Step 8: Commit**

```bash
git add lib/features/dashboard/presentation/views/dashboard_screen.dart test/features/dashboard/presentation/dashboard_screen_test.dart
git commit -m "feat(dashboard): rebuild cockpit with Paper Ledger widgets"
```

---

## Task 12: Delete Signal Deck code + tests

**Files:**
- Delete: `lib/core/themes/helm_signal_theme.dart`, `lib/core/widgets/signal/helm_signal_hero.dart`, `helm_signal_horizon.dart`, `helm_decision_deck.dart`, `helm_flow_route.dart`
- Delete: `test/core/themes/helm_signal_theme_test.dart`, `test/core/widgets/signal/` (4 files)

**Interfaces:**
- Consumes: confirmation that Tasks 10–11 removed the last non-signal importers.
- Produces: a codebase with zero `HelmSignalTheme` / `SignalDeckState` / `SignalFlowStage` references.

- [ ] **Step 1: Confirm no remaining importers in lib/**

```bash
grep -rln "helm_signal_theme\|HelmSignalTheme\|SignalDeckState\|SignalFlowStage\|widgets/signal/" lib/
```
Expected: only the 5 signal files themselves. If any other file appears, fix it before deleting.

- [ ] **Step 2: Delete source + test files**

```bash
git rm lib/core/themes/helm_signal_theme.dart \
  lib/core/widgets/signal/helm_signal_hero.dart \
  lib/core/widgets/signal/helm_signal_horizon.dart \
  lib/core/widgets/signal/helm_decision_deck.dart \
  lib/core/widgets/signal/helm_flow_route.dart \
  test/core/themes/helm_signal_theme_test.dart \
  test/core/widgets/signal/helm_signal_hero_test.dart \
  test/core/widgets/signal/helm_signal_horizon_test.dart \
  test/core/widgets/signal/helm_decision_deck_test.dart \
  test/core/widgets/signal/helm_flow_route_test.dart
```

- [ ] **Step 3: Verify analyzer + full suite**

```bash
fvm dart analyze && fvm flutter test --exclude-tags golden
```
Expected: `No issues found!` and all tests PASS (no dangling imports).

- [ ] **Step 4: Commit**

```bash
git commit -m "chore(signal): remove Signal Deck widgets + theme"
```

---

## Task 13: Phase 2 golden refresh + dashboard gate

**Files:**
- Modify (regenerated): `test/golden/goldens/*.png`

**Interfaces:**
- Consumes: Tasks 6–12.
- Produces: golden baselines reflecting the new dashboard widgets.

- [ ] **Step 1: Regenerate goldens**

```bash
fvm flutter test test/golden/ --update-goldens
```

- [ ] **Step 2: Verify clean**

```bash
fvm flutter test test/golden/
```
Expected: PASS.

- [ ] **Step 3: Verify dashboard non-negotiables (manual gate)**

Confirm against spec §4: hero shows S2S with 200ms-or-less fade only (no counter), the 3pt rail is the sole state signal, no charts/stat-cards above the fold, trust strip present. Read the rebuilt `dashboard_screen.dart` and check the `HelmLedgerHero` has no `AnimationController`.

- [ ] **Step 4: Commit**

```bash
git add test/golden/goldens
git commit -m "test(golden): refresh baselines for Paper Ledger dashboard"
```

---

## Task 14: Expand bottom nav to 4 tabs (founder-approved)

**Files:**
- Modify: `lib/config/router/app_router.dart` (the `_tabs` list + tab labels/icons)
- Test: `test/config/router/app_shell_tabs_test.dart` (create)

**Interfaces:**
- Consumes: existing `RouteNames.home/pipeline/trace/settings` (all already defined; `/settings` ShellRoute already exists at lines 88–92).
- Produces: a 4-item `BottomNavigationBar` — Home, Pipeline, History, Settings — matching spec §4 (UX-019). No new routes, no guard changes.

- [ ] **Step 1: Write the failing test**

Create `test/config/router/app_shell_tabs_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/config/router/app_router.dart' show debugAppShellTabLabels;

void main() {
  test('bottom nav has the four Paper Ledger tabs in order', () {
    expect(debugAppShellTabLabels,
        equals(['Home', 'Pipeline', 'History', 'Settings']));
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

```bash
fvm flutter test test/config/router/app_shell_tabs_test.dart
```
Expected: FAIL — `debugAppShellTabLabels` undefined and current labels are Signal/Flow/Trace.

- [ ] **Step 3: Update _tabs + expose a debug accessor**

In `lib/config/router/app_router.dart`, replace the `const List<_TabItem> _tabs = [...]` with:

```dart
const List<_TabItem> _tabs = [
  _TabItem(
    path: RouteNames.home,
    icon: Icons.home_rounded,
    label: 'Home',
    tooltip: 'Safe-to-Spend',
  ),
  _TabItem(
    path: RouteNames.pipeline,
    icon: Icons.account_balance_wallet_rounded,
    label: 'Pipeline',
    tooltip: 'Income pipeline',
  ),
  _TabItem(
    path: RouteNames.trace,
    icon: Icons.receipt_long_rounded,
    label: 'History',
    tooltip: 'History and audit trail',
  ),
  _TabItem(
    path: RouteNames.settings,
    icon: Icons.settings_rounded,
    label: 'Settings',
    tooltip: 'Settings',
  ),
];

/// Test-only accessor for the bottom-nav tab labels.
List<String> get debugAppShellTabLabels =>
    _tabs.map((t) => t.label).toList(growable: false);
```

- [ ] **Step 4: Run test + analyzer**

```bash
fvm flutter test test/config/router/app_shell_tabs_test.dart && fvm dart analyze lib/config/router/app_router.dart
```
Expected: PASS + `No issues found!`

- [ ] **Step 5: Smoke-test navigation didn't break**

```bash
fvm flutter test --exclude-tags golden
```
Expected: all PASS (router guard + existing navigation tests still green).

- [ ] **Step 6: Commit**

```bash
git add lib/config/router/app_router.dart test/config/router/app_shell_tabs_test.dart
git commit -m "feat(nav): expand bottom nav to 4 tabs (Home/Pipeline/History/Settings)"
```

---

## Task 15: Onboarding dark-mode + Fraunces verification (Phase 3)

**Files:**
- Verify (likely no edits): `lib/features/onboarding/presentation/views/welcome_screen.dart` + 6 pages + `onboarding_screen.dart`
- Test: extend an existing onboarding widget test or add `test/features/onboarding/presentation/onboarding_paper_ledger_test.dart`

**Interfaces:**
- Consumes: new tokens (Tasks 2–3). All onboarding screens already use `context.colors`/`context.textStyles`, so they re-skin automatically. This task is verification + fixing any screen that hardcodes a heading font or assumes a light-only background.

- [ ] **Step 1: Grep for hardcoded styling in onboarding**

```bash
grep -rn "fontFamily:\|Color(0x\|Colors\.\(white\|black\)" lib/features/onboarding/
```
Expected: ideally empty. Any hit is a screen to fix to `context.colors`/`context.textStyles`.

- [ ] **Step 2: Write a dark-mode smoke test**

Create `test/features/onboarding/presentation/onboarding_paper_ledger_test.dart` (adjust the widget under test to the simplest stateless page, `WelcomeScreen`):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:helm/core/themes/app_theme.dart';
import 'package:helm/features/onboarding/presentation/views/welcome_screen.dart';
import 'package:helm/l10n/app_localizations.dart';

Widget _app(ThemeData theme) => MaterialApp(
      theme: theme,
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('bn')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const WelcomeScreen(),
    );

void main() {
  testWidgets('welcome renders in light mode', (tester) async {
    await tester.pumpWidget(_app(AppTheme.light));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });

  testWidgets('welcome renders in dark mode', (tester) async {
    await tester.pumpWidget(_app(AppTheme.dark));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}
```

- [ ] **Step 3: Run test**

```bash
fvm flutter test test/features/onboarding/presentation/onboarding_paper_ledger_test.dart
```
Expected: PASS in both modes. If dark fails (e.g. a hardcoded `Colors.white` background swallowing text), fix that line to `context.colors.canvas` / `context.colors.inkPrimary` and re-run.

- [ ] **Step 4: Fix any hits from Step 1, then re-analyze**

```bash
fvm dart analyze lib/features/onboarding/
```
Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "test(onboarding): verify Paper Ledger in light + dark"
```

---

## Task 16: Income / Pipeline verification (Phase 4)

**Files:**
- Verify (likely no edits): `add_income_screen.dart`, `income_list_screen.dart`, `pipeline_screen.dart`
- Test: `test/features/income/presentation/income_paper_ledger_test.dart` (create)

**Interfaces:**
- Consumes: new tokens. These screens use `context.colors` (two use the `theme.extension<HelmColors>()` fallback — still valid). Money figures already route through `NumberFormatter`.

- [ ] **Step 1: Grep for hardcoded styling**

```bash
grep -rn "fontFamily:\|Color(0x\|Colors\.\(white\|black\)" lib/features/income/
```
Expected: empty. Fix any hit to tokens.

- [ ] **Step 2: Write a dark+light smoke test for PipelineScreen**

Create `test/features/income/presentation/income_paper_ledger_test.dart` following the Task 15 Step 2 pattern, swapping `WelcomeScreen` → `PipelineScreen` (wrap in `ProviderScope`). Assert `find.byType(PipelineScreen)` in both `AppTheme.light` and `AppTheme.dark`.

- [ ] **Step 3: Run test + analyze**

```bash
fvm flutter test test/features/income/presentation/income_paper_ledger_test.dart && fvm dart analyze lib/features/income/
```
Expected: PASS + `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "test(income): verify Paper Ledger in light + dark"
```

---

## Task 17: Auth screens verification (Phase 5)

**Files:**
- Verify (likely no edits): `pin_setup_screen.dart`, `pin_entry_screen.dart`, `magic_link_screen.dart`
- Test: `test/features/auth/presentation/auth_paper_ledger_test.dart` (create)

**Interfaces:**
- Consumes: new tokens. No trust-layer logic changes.

- [ ] **Step 1: Grep for hardcoded styling**

```bash
grep -rn "fontFamily:\|Color(0x\|Colors\.\(white\|black\)" lib/features/auth/
```
Expected: empty. Fix any hit.

- [ ] **Step 2: Write a light+dark smoke test**

Create `test/features/auth/presentation/auth_paper_ledger_test.dart` using the Task 15 pattern for `MagicLinkScreen` (it takes `onAuthenticated`/`onGuest` callbacks — pass empty async closures). Assert it renders in both themes.

- [ ] **Step 3: Run test + analyze**

```bash
fvm flutter test test/features/auth/presentation/auth_paper_ledger_test.dart && fvm dart analyze lib/features/auth/
```
Expected: PASS + `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "test(auth): verify Paper Ledger in light + dark"
```

---

## Task 18: Long-tail screens verification (Phase 6)

**Files:**
- Verify (likely no edits): `sts_settings_screen.dart`, `audit_log_screen.dart`, `export_screen.dart`, `add_transaction_screen.dart`, `delete_account_screen.dart`, plus `splash_screen.dart`, `compromised_device_screen.dart`, `notification_center_screen.dart`, `cadence_preference_sheet.dart`
- Test: `test/features/long_tail_paper_ledger_test.dart` (create)

**Interfaces:**
- Consumes: new tokens.

- [ ] **Step 1: Grep across all remaining screens**

```bash
grep -rn "fontFamily:\|Color(0x\|Colors\.\(white\|black\)" \
  lib/features/safe_to_spend/ lib/features/audit_log/ lib/features/export/ \
  lib/features/transactions/ lib/features/account/ lib/features/splash/ \
  lib/core/security/views/ lib/core/nudge/presentation/screens/ \
  lib/features/settings/
```
Expected: empty. Fix any hit to `context.colors` / `context.textStyles`.

- [ ] **Step 2: Write light+dark smoke tests for the two simplest screens**

Create `test/features/long_tail_paper_ledger_test.dart` covering `ExportScreen` and `AuditLogScreen` (wrap in `ProviderScope` + localization delegates per Task 15). Assert each renders in `AppTheme.light` and `AppTheme.dark`.

- [ ] **Step 3: Run test + analyze whole project**

```bash
fvm flutter test test/features/long_tail_paper_ledger_test.dart && fvm dart analyze
```
Expected: PASS + `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add -A
git commit -m "test(long-tail): verify Paper Ledger in light + dark"
```

---

## Task 19: Dark-mode golden coverage (Phase 7)

**Files:**
- Modify: `test/golden/dashboard_golden_test.dart` (add a dark-mode group)
- Add (regenerated): `test/golden/goldens/*_dark.png`

**Interfaces:**
- Consumes: all prior tasks.
- Produces: dark-mode golden baselines so future regressions in espresso mode are caught.

- [ ] **Step 1: Add a dark wrapper + one dark golden group**

In `test/golden/dashboard_golden_test.dart`, add below `buildTestWidget`:
```dart
Widget buildDarkTestWidget({required Widget child}) {
  return MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: MaterialApp(
      theme: AppTheme.dark,
      locale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('bn')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    ),
  );
}
```
Add a new group at the end of `main()`:
```dart
group('S2sHeroBlock dark golden', () {
  testWidgets('s2s_hero_block - safe state (dark)', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildDarkTestWidget(
      child: S2sHeroBlock(
        result: _safeResult,
        updatedAt: _referenceTime,
        onTapTrace: null,
        affirmation: null,
      ),
    ));
    await tester.pumpAndSettle();
    await expectLater(find.byType(S2sHeroBlock),
        matchesGoldenFile('goldens/s2s_hero_block_safe_dark.png'));
  });
});
```

- [ ] **Step 2: Generate the dark baseline**

```bash
fvm flutter test test/golden/dashboard_golden_test.dart --update-goldens
```

- [ ] **Step 3: Verify clean**

```bash
fvm flutter test test/golden/dashboard_golden_test.dart
```
Expected: PASS.

- [ ] **Step 4: Visually confirm espresso**

Open `test/golden/goldens/s2s_hero_block_safe_dark.png` — background must be warm espresso `#1E1813`, not black.

- [ ] **Step 5: Commit**

```bash
git add test/golden/dashboard_golden_test.dart test/golden/goldens
git commit -m "test(golden): add dark-mode baseline for hero block"
```

---

## Task 20: Final verification gate + tracking docs

**Files:**
- Modify: `docs/tracking/DECISION_LOG.md`, `docs/tracking/PROJECT_STATE.md`, `docs/core/ROADMAP.md`

**Interfaces:**
- Consumes: Tasks 1–19.
- Produces: a fully green project + tracking docs recording the supersession (spec §7).

- [ ] **Step 1: Full analyzer + full test suite**

```bash
fvm dart analyze && fvm flutter test
```
Expected: `No issues found!` (0/0/0) and the entire suite (incl. goldens) PASS.

- [ ] **Step 2: Confirm zero Signal Deck residue**

```bash
grep -rln "HelmSignalTheme\|SignalDeckState\|SignalFlowStage\|widgets/signal/" lib/ test/
```
Expected: no output.

- [ ] **Step 3: Add the DECISION_LOG entry**

Append a new decision to `docs/tracking/DECISION_LOG.md` (next number after 038):
```markdown
## Decision 039 — Paper Ledger Visual Direction (2026-06-21)

**Supersedes:** Decision 036 (Signal Deck).
**Decision:** Adopt Paper Ledger — warm paper (`#F3ECE0`) / warm espresso (`#1E1813`)
dual mode, terracotta (`#C2603F`) accent, Fraunces display + Inter UI + JetBrains Mono
money + Hind Siliguri Bangla. Latin numerals for all money.
**Why:** "calm & human" product feeling target; terracotta owns no state meaning so it
never collides with semantic state colors; warm espresso preserves human feeling at night.
**Scope:** Visual only — no business-logic, persistence, or routing-guard changes. Bottom
nav expanded to 4 tabs (Home/Pipeline/History/Settings) — founder-approved.
**Signal Deck code removed**, not hidden.
**Spec:** docs/superpowers/specs/2026-06-21-paper-ledger-redesign.md
```

- [ ] **Step 4: Update PROJECT_STATE + ROADMAP**

In `docs/tracking/PROJECT_STATE.md`, update the visual-system entry to "Paper Ledger (Decision 039)". In `docs/core/ROADMAP.md`, note the Signal Deck → Paper Ledger direction change.

- [ ] **Step 5: Commit**

```bash
git add docs/tracking/DECISION_LOG.md docs/tracking/PROJECT_STATE.md docs/core/ROADMAP.md
git commit -m "docs(tracking): record Paper Ledger supersession (Decision 039)"
```

- [ ] **Step 6: Final completion report**

Produce a structured completion report (per CLAUDE.md): docs used, tasks completed, analyzer result, test result, screens migrated, and the Definition-of-Done checklist from spec §8 ticked.

---

## Parallelization Notes (for subagent-driven execution)

Strict ordering where state is shared; parallelize independent leaf tasks:

- **Sequential foundation:** Task 1 → Task 2 → Task 3 → Task 4 → Task 5. (Tokens must land before anything renders correctly.)
- **Parallel batch A** (after Task 5, all independent — new files, no shared edits): **Task 6, Task 7, Task 9** can run concurrently. **Task 8** depends on 6+7 (run after). **Task 10** is independent of 6–9 (run anytime after Task 5).
- **Sequential integration:** Task 11 (needs 6,8,9) → Task 12 (needs 11+10 done) → Task 13.
- **Task 14** is independent of the widget work — can run any time after Task 5.
- **Parallel batch B** (after Task 13, pure per-feature verification, no shared files): **Task 15, 16, 17, 18** run concurrently.
- **Sequential finish:** Task 19 → Task 20.

Each task is a self-contained TDD cycle (failing test → impl → green → commit) and is independently reviewable.

## Out of Scope (explicit)

- **Spline Sans Mono** money font — spec §9 open item; default keeps JetBrains Mono. Not in this plan.
- **No new routes or guard changes** — only the `_tabs` list grows (Task 14); `/settings` route already exists.
- **No SafeToSpend / provider / Hive / FX logic** touched anywhere.
