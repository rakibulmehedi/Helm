# A4V-2: Visual Maturity Rescue Plan

> **Sprint:** A4V-2 | **Date:** 2026-06-08
> **Input:** A4V-1 Attack Report | **Output:** Migration plan 52/100 → 75+ beta-ready

---

## Strategic Diagnosis

Token system 100% correct. Core widgets 12/13 compliant. Dashboard 80-90/100. Periphery 20-40/100. Fix = propagate existing design system to periphery. Not redesign.

---

## What Must NOT Change

| Component | Reason |
|-----------|--------|
| S2sHeroBlock, HelmCalculationTrace, Dashboard layout | Near-perfect. Do not touch. |
| All 12 core Helm widgets | Token-compliant. |
| HelmColors/Typography/Spacing/Motion | Token definitions are correct. Never change. |
| Riverpod, GoRouter, S2S calculation, Hive | Visual migration only. |

**Hard rule: No business logic, state management, navigation, or persistence changes during visual migration.**

---

## Contamination Sources

| Source | Blast Radius | Root Cause |
|--------|-------------|------------|
| `AppButton` (button_multiple_types.dart) | 13 screens | Uses deprecated `AppColors.primary` (#2453FF) |
| `AppColors` (colors.dart) | 4 files | Deprecated color system, never removed |
| `ResponsiveUtilities.font()` | 6 files | Bypasses HelmTypography |
| `Material Icons` (Icons.*) | 16 files | No Phosphor package installed |
| Hardcoded `fontSize:` | 14 files | Predates token system |
| Hardcoded `BorderRadius.circular()` | 28 files | Predates spacing tokens |
| `FontWeight.bold` (w700) | 8 files | Exceeds max w600 |
| `Colors.black/white` | 12 files | Bypasses warm neutral palette |

---

## Screen Trust Damage Ranking

| Rank | Screen | Score | Trust Damage |
|------|--------|-------|-------------|
| 1 | Add Transaction | 20 | CRITICAL — expense categories = "TallyKhata" |
| 2 | Splash | 25 | HIGH — first impression = "student project" |
| 3 | STS Settings | 25 | HIGH — looks nothing like dashboard |
| 4 | Income List | 30 | HIGH — italic notes, proportional money font |
| 5 | Export | 30 | MEDIUM — raw ElevatedButton |
| 6 | Add Income | 40 | MEDIUM — form inconsistency |
| 7 | Audit Log | 45 | LOW — hardcoded font, Material Icons |

---

## ROI Matrix

| Fix | Effort | Screens Fixed | Score Lift | ROI |
|-----|--------|-------------|-----------|-----|
| AppButton → HelmColors | 15 min | 13 | +8 overall | EXTREME |
| Kill expense categories | 20 min | 1 | +5 (identity) | EXTREME |
| Kill 3 italic instances | 5 min | 2 | +3 (BLOCKER) | EXTREME |
| Splash timing 1800→320ms | 5 min | 1 | +2 (BLOCKER) | EXTREME |
| FontWeight.bold → w600 | 30 min | 8 | +3 | HIGH |
| Colors.black/white → tokens | 30 min | 12 | +3 | HIGH |
| Typography token migration | 3-4 hrs | 14 | +12 | HIGH |
| Phosphor icon migration | 3-4 hrs | 16 | +10 | MEDIUM |
| BorderRadius token migration | 2-3 hrs | 28 | +5 | MEDIUM |
| Splash redesign (wordmark) | 1 hr | 1 | +5 | MEDIUM |
| Income list rebuild | 2-3 hrs | 1 | +5 | LOW |

---

## High Blast Radius Changes

| Change | Files | Risk |
|--------|-------|------|
| Phosphor icon migration | 16 files, 66 replacements | Requires package approval. Wrong icon = confusing UX. |
| BorderRadius token migration | 28 files, ~80 replacements | Must categorize values before replacing. |
| Typography token migration | 14 files, ~99 replacements | Wrong mapping = broken hierarchy. |

---

## Staging Requirements

**Must be staged separately:**
1. **Phosphor icons** — pubspec change requires approval first.
2. **Income list rebuild** — too many lines, needs isolated review.
3. **Splash redesign** — visual identity change, must verify on device.
4. **History tab** — new screen + router change.

**Safe to batch:** AppButton + italic + bold→w600 + Colors.black/white; Typography migration; BorderRadius migration; BoxShadow removal.

---

## Rescue vs. Rebuild

**Rescue (token migration only):**

| Component | Score | Target |
|-----------|-------|--------|
| Welcome Screen | 70 | 85 |
| Onboarding (6 pages) | 65 | 80 |
| Pipeline Screen | 60 | 75 |
| PIN Entry/Setup | 55 | 70 |
| Delete Account | 50 | 65 |
| Audit Log | 45 | 65 |
| Dashboard | 80 | 88 |

**Rebuild (structural visual change):**

| Component | Score | Rebuild Scope |
|-----------|-------|---------------|
| AppButton | 15 | Rewrite internals to HelmColors + HelmSpacing. Keep interface. |
| Splash Screen | 25 | Wordmark + HelmMotion.slow fade. |
| Add Transaction | 20 | Remove categories, simplify to amount+note+date, migrate tokens. |
| Income List | 30 | Heavy token migration + HelmAmount for money values. |

---

## Migration Phases

```
Phase 1: Kill BLOCKERs (~2 hrs)       → 52→62, 7 BLOCKERs→0
Phase 2: Typography migration (~3 hrs) → 62→72
Phase 3: Weight + color cleanup (~1.5 hrs) → 72→76
Phase 4: Phosphor icons [needs approval]
Phase 5: BorderRadius + BoxShadow removal
Phase 6: Splash redesign, income list rebuild, History tab
Phase 7: Final verification pass
```

**MVVM (Phases 1-3, ~6.5 hrs): 52 → 76, zero BLOCKERs.**

After Phase 3 the app is consistent even with Material Icons:
- Buttons branded deep teal
- Token typography everywhere
- No italics, bold violations, raw black/white, expense categories
- Fast clean splash

---

## Principles

- **Propagate, don't redesign.** Dashboard proves the target aesthetic works.
- **Inside-out token propagation.** Fix sources first (AppButton), then outward.
- **No package changes without approval.** Phase 4 requires explicit pubspec approval.
- **Verify after every phase.** `dart analyze` 0/0/0, `flutter test` all pass, visual inspection, commit.

---

## Risk Summary

| Phase | Risk | Mitigation |
|-------|------|-----------|
| 1-3 | Low — mechanical substitutions, no new packages | Each change independently reversible via git |
| 4 | Medium — pubspec change + 66 icon replacements | Create icon mapping doc before executing |
| 5 | Medium — 80+ replacements across 28 files | Grep and categorize all values before replacing |
| 6 | Low — isolated files, additive History tab | Verify splash + income list on device |

---

## What This Plan Does NOT Cover

- Phosphor package approval (Chief Architect must decide)
- History screen design (separate sprint)
- Bangla copy audit, first-run animation, skeleton loading, haptic feedback (deferred)
- Dark mode verification (HelmColors handles both via ThemeExtension)

---

## Suggested First Sprint (A4V-3)

Phase 1 only (~2 hours):
1. Rewrite AppButton internals → HelmColors.interactive + HelmSpacing
2. Remove expense categories from `add_transaction_screen.dart`
3. Remove 3 FontStyle.italic instances
4. Reduce splash from 1800ms to 320ms
5. Delete `safe_to_spend_hero.dart`
6. Replace Colors.white in `button_multiple_types.dart`
7. `dart analyze` + `flutter test` + visual verification

Score jumps 52 → ~62. Zero BLOCKERs.

---

*End of A4V-2 Visual Rescue Plan. No code was modified.*
