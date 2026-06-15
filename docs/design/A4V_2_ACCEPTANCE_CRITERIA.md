# A4V-2: Acceptance Criteria

> **Sprint:** A4V-2 | **Date:** 2026-06-08
> **Purpose:** Measurable pass/fail criteria per phase and final beta-ready state

---

## Phase 1: Kill BLOCKERs

| # | Criterion | Measurement | Pass |
|---|-----------|-------------|------|
| 1.1 | Zero AppColors in button file | `grep -rn "AppColors" lib/core/widgets/buttons/` | 0 results |
| 1.2 | Buttons render deep teal | Visual on device: #255E5B, not #2453FF | Confirmed |
| 1.3 | Zero expense categories | `grep -rn "_defaultCategories\|selectedCategory" lib/features/transactions/` | 0 results |
| 1.4 | Zero italic in features | `grep -rn "FontStyle.italic" lib/features/` | 0 results |
| 1.5 | Splash timing <= 500ms | Duration inspection in code | <= 500ms |
| 1.6 | Splash curve is easeOut | `grep -n "easeIn" lib/features/splash/` | 0 results |
| 1.7 | Dead code file deleted | `ls lib/features/safe_to_spend/presentation/widgets/safe_to_spend_hero.dart` | Not found |
| 1.8 | Analyzer clean | `dart analyze` | 0/0/0 |
| 1.9 | Tests pass | `flutter test` | All pass |

**Gate:** ALL 9 must pass. Any failure blocks Phase 2.

---

## Phase 2: Typography Migration

| # | Criterion | Measurement | Pass |
|---|-----------|-------------|------|
| 2.1 | Zero ResponsiveUtilities.font() in features | `grep -rn "ResponsiveUtilities.font" lib/features/` | 0 results |
| 2.2 | Hardcoded fontSize < 10 in features | `grep -rn "fontSize:" lib/features/ \| wc -l` | < 10 |
| 2.3 | STS settings uses tokens | `grep -n "fontSize:" lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart` | 0 results |
| 2.4 | Income list uses tokens | `grep -n "fontSize:\|ResponsiveUtilities" lib/features/income/presentation/views/income_list_screen.dart` | 0 results |
| 2.5 | Export uses AppButton | `grep -n "ElevatedButton" lib/features/export/` | 0 results |
| 2.6 | Type hierarchy consistent | Visual: headers > body > labels > captions across all screens | Confirmed |
| 2.7 | Analyzer clean | `dart analyze` | 0/0/0 |
| 2.8 | Tests pass | `flutter test` | All pass |

**Gate:** ALL 8 must pass. Any failure blocks Phase 5.

---

## Phase 3: Weight + Color Cleanup

| # | Criterion | Measurement | Pass |
|---|-----------|-------------|------|
| 3.1 | Zero FontWeight.bold in features | `grep -rn "FontWeight.bold\|FontWeight.w700" lib/features/` | 0 results |
| 3.2 | Zero Colors.white in features | `grep -rn "Colors.white" lib/features/` | 0 results |
| 3.3 | Zero Colors.black in features | `grep -rn "Colors.black" lib/features/` | 0 results |
| 3.4 | Zero AppColors in features/widgets | `grep -rn "AppColors" lib/features/ lib/core/widgets/` | 0 results |
| 3.5 | Warm palette consistent | Visual: no harsh black/white clashing with warm neutrals | Confirmed |
| 3.6 | Analyzer clean | `dart analyze` | 0/0/0 |
| 3.7 | Tests pass | `flutter test` | All pass |

**Gate:** ALL 7 must pass.

---

## Phase 4: Icon System Migration

| # | Criterion | Measurement | Pass |
|---|-----------|-------------|------|
| 4.1 | phosphor_flutter in pubspec | `grep "phosphor_flutter" pubspec.yaml` | Found |
| 4.2 | pub get succeeds | `flutter pub get` | exit 0 |
| 4.3 | Zero Material Icons in features | `grep -rn "Icons\." lib/features/` | 0 results |
| 4.4 | Zero Material Icons in router | `grep -rn "Icons\." lib/config/router/` | 0 results |
| 4.5 | Phosphor outline style consistent | Visual: 1.5pt stroke outline icons | Confirmed |
| 4.6 | Icon semantics correct | Visual: each icon communicates correct action | Confirmed |
| 4.7 | Analyzer clean | `dart analyze` | 0/0/0 |
| 4.8 | Tests pass | `flutter test` | All pass |

**Gate:** ALL 8 must pass. Requires prior approval for package addition.

---

## Phase 5: Spacing + Shadow Cleanup

| # | Criterion | Measurement | Pass |
|---|-----------|-------------|------|
| 5.1 | Zero BoxShadow in features | `grep -rn "BoxShadow" lib/features/` | 0 results |
| 5.2 | No card-context radius 16/20/24 | `grep -rn "BorderRadius.circular(16)\|circular(20)\|circular(24)" lib/features/` | 0 in card context |
| 5.3 | Cards feel grounded | Visual: hairline borders, no floating | Confirmed |
| 5.4 | Consistent radius family | Visual: cards=12, buttons=10, sheets=16 | Confirmed |
| 5.5 | Analyzer clean | `dart analyze` | 0/0/0 |
| 5.6 | Tests pass | `flutter test` | All pass |

**Gate:** ALL 6 must pass.

---

## Phase 6: Screen-Level Polish

| # | Criterion | Measurement | Pass |
|---|-----------|-------------|------|
| 6.1 | Splash: no CircleAvatar | `grep -n "CircleAvatar" lib/features/splash/` | 0 results |
| 6.2 | Splash: wordmark present | Visual: "Helm" text centered on canvas | Confirmed |
| 6.3 | Splash: fast | Total visible time <= 500ms | Confirmed |
| 6.4 | Income list: HelmAmount for money | Visual: monospace with tk prefix | Confirmed |
| 6.5 | STS settings: HelmAmount for costs | Visual: fixed cost amounts monospace | Confirmed |
| 6.6 | Transaction form: clean 3-field | Visual: amount + note + date only | Confirmed |
| 6.7 | Delete account: button 48pt | Button height = 48pt | Confirmed |
| 6.8 | Analyzer clean | `dart analyze` | 0/0/0 |
| 6.9 | Tests pass | `flutter test` | All pass |

**Gate:** ALL 9 must pass.

---

## Phase 7: Final Verification

| # | Criterion | Measurement | Pass |
|---|-----------|-------------|------|
| 7.1 | Zero BLOCKERs | All B1-B7 resolved | 0 |
| 7.2 | Overall weighted score >= 75 | Re-score all screens (A4V-1 methodology) | >= 75 |
| 7.3 | Screen floor >= 60 | Lowest scoring screen | >= 60 |
| 7.4 | Hardcoded fontSize < 10 | Grep count | < 10 |
| 7.5 | Zero italic | Grep | 0 |
| 7.6 | Zero bold violations | Grep | 0 |
| 7.7 | Zero raw Colors | Grep | 0 |
| 7.8 | Zero BoxShadow | Grep | 0 |
| 7.9 | Zero AppColors in features | Grep | 0 |
| 7.10 | Analyzer clean | `dart analyze` | 0/0/0 |
| 7.11 | All tests pass | `flutter test` | All pass |

**Gate:** ALL 11 must pass for Visual Beta Ready declaration.

---

## Beta-Ready Acceptance Matrix

| Metric | A4V-1 Baseline | After P1-P3 (MVVM) | After P1-P7 (Full) |
|--------|---------------|---------------------|---------------------|
| BLOCKERs | 7 | 0 | 0 |
| Material Icons | 66 | 66 (deferred) | 0 |
| AppButton on AppColors | 29 | 0 | 0 |
| FontStyle.italic | 3 | 0 | 0 |
| BoxShadow | 4 | 4 (deferred) | 0 |
| Expense categories | Present | Removed | Removed |
| Splash logo | CircleAvatar | Timing fixed | Wordmark |
| Hardcoded fontSize | 69 | < 10 | < 10 |
| FontWeight.bold violations | 26 | 0 | 0 |
| Colors.black/white | 20 | 0 | 0 |
| ResponsiveUtilities.font() | 30+ | 0 | 0 |
| Overall weighted score | 52 | ~76 | ~80+ |
| Screen floor | 20 | ~55 | ~65 |

---

## Per-Screen Score Targets

| Screen | A4V-1 | After P1-P3 | After P1-P7 |
|--------|-------|-------------|-------------|
| AppButton | 15 | 75 | 85 |
| Add Transaction | 20 | 60 | 65 |
| Splash | 25 | 45 | 80 |
| STS Settings | 25 | 60 | 70 |
| Income List | 30 | 55 | 70 |
| Export | 30 | 55 | 65 |
| Income Pipeline Summary | 40 | 60 | 70 |
| Add Income | 40 | 60 | 70 |
| Audit Log | 45 | 60 | 70 |
| Delete Account | 50 | 60 | 70 |
| PIN Entry/Setup | 55 | 65 | 72 |
| Pipeline Screen | 60 | 65 | 78 |
| Confirm Received Sheet | 65 | 70 | 78 |
| Onboarding | 65 | 75 | 82 |
| Bottom Navigation | 65 | 68 | 80 |
| Pipeline Entry Card | 70 | 75 | 82 |
| Welcome | 70 | 82 | 85 |
| Dashboard | 80 | 85 | 90 |
| Calculation Trace | 85 | 86 | 88 |
| S2S Hero Block | 90 | 91 | 92 |

---

## Verification Commands

```bash
# BLOCKERs
grep -rn "FontStyle.italic" lib/features/
grep -rn "AppColors" lib/core/widgets/buttons/ lib/features/
grep -rn "_defaultCategories" lib/

# Typography
grep -rn "ResponsiveUtilities.font" lib/features/
grep -rn "fontSize:" lib/features/ | wc -l

# Weight + Color
grep -rn "FontWeight.bold\|FontWeight.w700" lib/features/
grep -rn "Colors.black\|Colors.white" lib/features/

# Icons (after P4)
grep -rn "Icons\." lib/features/ lib/config/

# Spacing (after P5)
grep -rn "BoxShadow" lib/features/
grep -rn "BorderRadius.circular" lib/features/ | wc -l

# Always
dart analyze
flutter test
```

---

## Definition of Done

Done when all Phase 7 criteria pass, `dart analyze` 0/0/0, `flutter test` all pass, and visual inspection on reference device (Redmi Note 11 or equivalent 6.1" Android) confirms consistent visual language across all screens. Verification report committed to `docs/`.

Declaration: **VISUALLY BETA READY**.

---

*End of A4V-2 Acceptance Criteria. No code was modified.*
