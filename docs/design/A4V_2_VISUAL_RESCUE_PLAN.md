# A4V-2: Visual Maturity Rescue Plan

> **Sprint:** A4V-2 (Plan Only -- No Implementation)
> **Date:** 2026-06-08
> **Posture:** Rescue architect -- converting hostile attack findings into safe migration path
> **Input:** A4V-0 Attack Plan, A4V-1 Attack Report, Toy-Feel Root Cause Report, Gap & Potential Map
> **Output:** Disciplined migration plan from 52/100 toy-like to 75+ beta-ready

---

## Strategic Diagnosis

Helm's visual problem is **adoption, not design**.

- Token system: **100% correct** (13 colors, 18 typography, 20+ spacing, 6 motion)
- Core widgets: **12/13 fully compliant** (HelmAmount, HelmLedgerRail, HelmTrustStrip, etc.)
- Dashboard: **80-90/100** (near-doctrine)
- Periphery: **20-40/100** (income list, settings, transaction, export)

The app has two visual personalities. The dashboard feels like a calm fintech cockpit. Everything else feels like a Flutter starter template. The rescue is not redesign -- it is propagation of the existing design system to its own periphery.

---

## The 10 Strategic Questions Answered

### 1. What changes first?

**AppButton migration.** Single file (`button_multiple_types.dart`), affects 13 screens instantly. Changes brand color from #2453FF bright blue to #255E5B deep teal. Highest ROI fix in entire codebase. Zero risk -- button interface stays identical, only internal color/token references change.

Second: kill expense categories, kill italic text, fix splash timing. These are BLOCKER-severity items that take <30 minutes combined.

### 2. What must NOT change?

| Component | Score | Reason |
|-----------|-------|--------|
| S2sHeroBlock | 90/100 | Near-perfect. Product's strongest visual moment. |
| HelmRealityStack | N/A | Correct 4-tier structure. Do not restructure. |
| HelmCalculationTrace | 85/100 | Correct stagger animation + audit pattern. |
| Dashboard layout | 80/100 | Reality Stack + FAB + bottom nav correct. |
| All 12 core Helm widgets | 100% | Token-compliant. Rescue = adoption, not rewrite. |
| HelmColors/Typography/Spacing/Motion | 100% | Token definitions are correct. Never change tokens. |
| Riverpod state management | N/A | Sound architecture. Visual migration only. |
| GoRouter navigation | N/A | Correct route guards. Visual migration only. |
| S2S calculation logic | N/A | Financial formula is correct. Never touch. |
| Hive persistence layer | N/A | Working. Visual migration only. |

**Hard rule: No business logic, state management, navigation, or persistence changes during visual migration.**

### 3. Which tokens/components cause the toy feeling?

**Tokens are not the cause.** Token definitions are 100% correct. The cause is **non-adoption**:

| Contamination Source | Blast Radius | Root Cause |
|---------------------|-------------|------------|
| `AppButton` (button_multiple_types.dart) | 13 screens | Uses deprecated `AppColors.primary` (#2453FF) |
| `AppColors` (colors.dart) | 4 files | Deprecated color system, never removed |
| `ResponsiveUtilities.font()` | 6 files | Bypasses HelmTypography entirely |
| `Material Icons` (Icons.*) | 16 files | No Phosphor package installed |
| Hardcoded `fontSize:` | 14 files | Predates token system |
| Hardcoded `BorderRadius.circular()` | 28 files | Predates spacing tokens |
| `FontWeight.bold` (w700) | 8 files | Exceeds max w600 |
| `Colors.black/white` | 12 files | Bypasses warm neutral palette |

### 4. Which screens create the biggest trust damage?

Ranked by trust damage (user-facing impact x frequency x identity violation):

| Rank | Screen | Score | Trust Damage | Why |
|------|--------|-------|-------------|-----|
| 1 | Add Transaction | 20 | CRITICAL | Expense categories = "this is TallyKhata" |
| 2 | Splash | 25 | HIGH | First impression = "student project" |
| 3 | STS Settings | 25 | HIGH | Financial settings look nothing like dashboard |
| 4 | Income List | 30 | HIGH | Money values in proportional font, italic notes |
| 5 | Export | 30 | MEDIUM | Raw ElevatedButton, hardcoded everything |
| 6 | Add Income | 40 | MEDIUM | Form inconsistency, ResponsiveUtilities |
| 7 | Audit Log | 45 | LOW | Hardcoded font, Material Icons |

### 5. Which fixes give highest maturity lift?

**ROI matrix** (visual impact / effort):

| Fix | Effort | Screens Fixed | Score Lift | ROI |
|-----|--------|-------------|-----------|-----|
| AppButton -> HelmColors | 15 min | 13 | +8 overall | EXTREME |
| Kill expense categories | 20 min | 1 | +5 (identity) | EXTREME |
| Kill 3 italic instances | 5 min | 2 | +3 (BLOCKER) | EXTREME |
| Splash timing 1800->320ms | 5 min | 1 | +2 (BLOCKER) | EXTREME |
| FontWeight.bold -> w600 | 30 min | 8 | +3 | HIGH |
| Colors.black/white -> tokens | 30 min | 12 | +3 | HIGH |
| Typography token migration | 3-4 hrs | 14 | +12 | HIGH |
| Phosphor icon migration | 3-4 hrs | 16 | +10 | MEDIUM |
| BorderRadius token migration | 2-3 hrs | 28 | +5 | MEDIUM |
| Splash redesign (wordmark) | 1 hr | 1 | +5 | MEDIUM |
| Income list rebuild | 2-3 hrs | 1 | +5 | LOW |

### 6. Which changes have high blast radius?

**High blast radius (proceed with extreme care):**

| Change | Files Touched | Risk |
|--------|-------------|------|
| Phosphor icon migration | 16 files, 66 replacements | Package addition required. Icon-by-icon mapping. One wrong icon = confusing UX. |
| BorderRadius token migration | 28 files, ~80 replacements | Many values are correct (12pt) but not using token reference. Mechanical but large. |
| Typography token migration | 14 files, ~99 replacements | Must map each hardcoded size to correct semantic token. Wrong mapping = broken hierarchy. |

**Low blast radius (safe to execute freely):**

| Change | Files Touched | Risk |
|--------|-------------|------|
| AppButton rewrite | 1 file | Interface unchanged. Only color refs change. |
| Kill expense categories | 1 file | Remove array + chips. No data dependency. |
| Kill italic | 2 files (3 instances) | Delete FontStyle.italic. Nothing depends on it. |
| Splash timing | 1 file | Change Duration value. |
| FontWeight.bold -> w600 | 8 files | Mechanical find-replace. |
| Colors.black/white | 12 files | Mechanical replacement with token refs. |
| Delete dead code | 1 file | Nobody imports it. |
| BoxShadow removal | 4 files | Delete shadow declarations. |

### 7. Which fixes must be staged?

**Must be staged (not safe to batch):**

1. **Phosphor icons** -- requires `pubspec.yaml` package addition (needs approval), then systematic replacement. Must be a separate commit because pubspec change is irreversible in a fast-forward merge.

2. **Income list rebuild** -- touches too many lines in one file. Must be reviewed separately from mechanical token migrations.

3. **Splash redesign** -- visual identity change (new wordmark). Must be visually verified on device before committing.

4. **History tab addition** -- new screen + router change. Must not be batched with visual-only fixes.

**Can be batched safely:**

- AppButton + italic kill + bold->w600 + Colors.black/white (all mechanical, independent)
- Typography token migration (all feature files, same pattern)
- BorderRadius token migration (all feature files, same pattern)
- BoxShadow removal (4 files, delete-only)

### 8. Which existing components can be rescued?

**Rescue (token migration only, no structural change):**

| Component | Current Score | Rescue Path | Target Score |
|-----------|-------------|-------------|-------------|
| Welcome Screen | 70 | AppButton fix propagates automatically | 85 |
| Onboarding (6 pages) | 65 | AppButton fix + hardcoded radius -> tokens | 80 |
| Pipeline Screen | 60 | Icon + Colors.white swap | 75 |
| PIN Entry/Setup | 55 | Typography token migration | 70 |
| Delete Account | 50 | Typography + icon migration | 65 |
| Audit Log | 45 | Typography + icon migration | 65 |
| Confirm Received Sheet | 65 | Minor radius + icon fixes | 75 |
| Pipeline Entry Card | 70 | Colors.black + icon swap | 80 |
| Dashboard | 80 | Icon + Colors.white on FAB | 88 |
| Add Income | 40 | Typography + radius migration | 65 |
| Export | 30 | Typography + button migration | 60 |
| STS Settings | 25 | Typography + italic kill + bold->w600 | 65 |

### 9. Which components should be rebuilt?

**Rebuild (structural change required):**

| Component | Current Score | Why Rebuild | Rebuild Scope |
|-----------|-------------|-------------|---------------|
| AppButton (button_multiple_types.dart) | 15 | Uses deprecated AppColors, wrong radius, ResponsiveUtilities for padding | Rewrite internals to HelmColors + HelmSpacing. Keep interface (label, onPressed, type). |
| Splash Screen | 25 | CircleAvatar placeholder, 1800ms, wrong curve | Replace with wordmark + HelmMotion.slow fade |
| Add Transaction Screen | 20 | Expense categories kill + full token migration | Remove categories, simplify to amount+note+date, migrate tokens |
| Income List Screen | 30 | 14+ ResponsiveUtilities calls, italic notes, wrong card radius | Heavy token migration + HelmAmount adoption for money values |

**Note:** "Rebuild" here means rewriting the visual layer only. All business logic, state management, and data flow stay identical.

### 10. What is the smallest path to "serious enough for beta"?

**Minimum Viable Visual Maturity (MVVM):**

Execute Phase 1 (Kill BLOCKERs) + Phase 2 (Typography) + Phase 3 (Weight/Color cleanup).

| Phase | Effort | Score Impact | BLOCKERs Killed |
|-------|--------|-------------|-----------------|
| Phase 1: Kill BLOCKERs | ~2 hrs | 52 -> 62 | 7 -> 0 |
| Phase 2: Typography migration | ~3 hrs | 62 -> 72 | 0 |
| Phase 3: Weight + color cleanup | ~1.5 hrs | 72 -> 76 | 0 |
| **Total MVVM** | **~6.5 hrs** | **52 -> 76** | **7 -> 0** |

This leaves Phosphor icons and spacing migration for a follow-up sprint. The app will look consistent and serious at 76/100 even with Material Icons, because:
- All buttons branded correctly (deep teal)
- All text using token typography
- No italics, no bold violations, no raw black/white
- No expense categories
- Splash is fast and clean
- All money values formatted consistently

Phosphor icons (Phase 4) and spacing (Phase 5) push to 85+ but are not beta-blocking.

---

## Migration Strategy

### Principle: Propagate, Don't Redesign

The design system is correct. The core widgets are correct. The dashboard proves the target aesthetic works. Every other screen must be brought UP to dashboard-level maturity by:

1. Replacing deprecated references (AppColors, ResponsiveUtilities, raw Colors) with existing tokens
2. Adopting existing Helm widgets where applicable (HelmAmount for money values)
3. Removing violations (italic, bold, shadows, categories)
4. Adding missing infrastructure only where required (Phosphor package, History screen)

### Principle: Inside-Out Token Propagation

Fix tokens at the source first (AppButton), then propagate outward:

```
Phase 1: Kill sources of contamination (AppButton, categories, italic, splash)
   |
Phase 2: Fix typography system adoption (fontSize -> tokens)
   |
Phase 3: Fix weight + color violations (bold -> w600, Colors -> tokens)
   |
Phase 4: Fix icon system (Material -> Phosphor) [requires approval]
   |
Phase 5: Fix spacing system (BorderRadius -> tokens, BoxShadow removal)
   |
Phase 6: Screen-level polish (splash redesign, income list, History tab)
   |
Phase 7: Final verification pass
```

### Principle: No Package Changes Without Approval

Phase 4 (Phosphor icons) requires adding `phosphor_flutter` to `pubspec.yaml`. This must be explicitly approved before execution. All other phases use only existing packages and tokens.

### Principle: Verify After Every Phase

After each phase:
1. Run `dart analyze` -- must be 0/0/0
2. Run `flutter test` -- all tests must pass
3. Visual inspection on device/simulator for affected screens
4. Commit with phase-specific message

---

## Risk Assessment

### Low Risk (Phase 1-3)

- All changes are mechanical token substitutions or deletions
- No new packages, no new files, no structural changes
- Each change is independently reversible via git
- Business logic untouched
- State management untouched
- Navigation untouched

### Medium Risk (Phase 4)

- Package addition (`phosphor_flutter`) is a pubspec change
- 66 icon replacements require correct semantic mapping
- Wrong icon choice is visible to users but not breaking
- Mitigation: create icon mapping document before executing

### Medium Risk (Phase 5)

- 80+ BorderRadius replacements across 28 files
- Most are already correct values (12) but need token reference
- Risk of accidentally changing a value that was intentionally different
- Mitigation: grep and categorize all values before replacing

### Low Risk (Phase 6)

- Splash redesign is a single isolated file
- Income list rebuild is a single file with no external API changes
- History tab is additive (new tab, new screen) -- no existing screens change

---

## What This Plan Does NOT Cover

1. **Phosphor icon package approval** -- Chief Architect must approve pubspec addition
2. **History screen implementation** -- requires new screen design (deferred to separate sprint)
3. **Bangla copy audit** -- deferred per UX-2 gaps
4. **First-run animation** -- deferred per UX-2 gaps
5. **Skeleton loading states** -- interaction maturity, not visual identity
6. **Haptic feedback** -- interaction maturity, not visual identity
7. **S2S performance gate** -- already passing per attack report
8. **Dark mode verification** -- HelmColors handles both modes via ThemeExtension

---

## Suggested First Implementation Sprint

**A4V-3: Kill BLOCKERs Sprint**

Scope: Phase 1 only (all 7 BLOCKERs resolved in ~2 hours)

Tasks:
1. Rewrite AppButton internals -> HelmColors.interactive + HelmSpacing
2. Remove expense categories from add_transaction_screen.dart
3. Remove 3 FontStyle.italic instances (sts_settings, income_list)
4. Reduce splash animation from 1800ms to 320ms
5. Delete safe_to_spend_hero.dart (dead code)
6. Replace Colors.white with HelmColors token in button_multiple_types.dart
7. Run dart analyze + flutter test + visual verification

After A4V-3: score jumps from 52 to ~62, zero BLOCKERs.

---

*End of A4V-2 Visual Rescue Plan. No code was modified.*
