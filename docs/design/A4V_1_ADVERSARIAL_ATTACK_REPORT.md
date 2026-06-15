# A4V-1: Adversarial UI/UX Attack Report

> **Sprint:** A4V-1 | **Date:** 2026-06-08
> **Posture:** Hostile fintech design examiner
> **Method:** Full code inspection — every screen, widget, token file, route

---

## Verdict: MAJOR VISUAL MATURITY GAP — 52/100

Not beta-ready. Dashboard + S2S hero near-doctrine. Periphery is a different product. Foundation strong, surface fractured. Fix = migration, not redesign.

---

## Global Violation Inventory

| Pattern | Count | Files | Severity |
|---------|-------|-------|----------|
| `AppButton` (legacy) | 29 | 13 | BLOCKER — pumps #2453FF into every screen |
| `Icons.` (Material) | 66 | 16 | BLOCKER — zero Phosphor, generic Flutter look |
| `FontStyle.italic` | 3 | 3 | BLOCKER — doctrine: zero italics |
| Phosphor icons | 0 | 0 | BLOCKER — package not installed |
| `fontSize:` hardcoded | 69 | 14 | MAJOR |
| `BorderRadius.circular` hardcoded | 98 | 28 | MAJOR |
| `FontWeight.bold/w700+` | 26 | 8 | MAJOR — exceeds max w600 |
| `Colors.black/white` raw | 20 | 12 | MAJOR |
| `AppColors` deprecated | 7 | 4 | MAJOR |
| `BoxShadow` | 4 | 4 | MAJOR — doctrine: zero shadows |
| `withOpacity` (text) | 2 | 2 | MINOR |
| `elevation > 0` | 0 | 0 | PASS |
| `LinearGradient` | 0 | 0 | PASS |

---

## Screen-by-Screen Findings

### 1. Splash Screen — 25/100

| Finding | Severity |
|---------|----------|
| `Duration(milliseconds: 1800)` — 5.6x over max 320ms | BLOCKER |
| `CircleAvatar` "P" placeholder logo | BLOCKER |
| `fontSize: 52`, `fontSize: 32` hardcoded | MAJOR |
| `FontWeight.bold` (w700) x2 | MAJOR |
| `Colors.white` x2 | MAJOR |
| `Curves.easeIn` instead of easeOut | MINOR |

### 2. Welcome Screen — 70/100

| Finding | Severity |
|---------|----------|
| HelmTypography (headingLg, bodyLg) used correctly | PASS |
| HelmSpacing.screenEdge used correctly | PASS |
| AppButton — injects #2453FF blue | MAJOR |

### 3. Onboarding (6 Steps) — 65/100

| Finding | Severity |
|---------|----------|
| HelmTypography + HelmColors used correctly in content | PASS |
| `HelmSpacing.cardRadius` used in income_pattern_page | PASS |
| AppButton on all pages — bright blue | MAJOR |
| `Icons.check`, `Icons.info_outline_rounded` on all pages | MAJOR |
| `fixed_costs_page.dart` — hardcoded checkbox 20x20, `BorderRadius: 4` | MAJOR |
| `fixed_costs_page.dart` — `width: 120` fixed TextField | MAJOR |
| `first_pipeline_page.dart` — `BorderRadius.circular(12)` x3 | MAJOR |
| Animation durations use literal 200/300ms instead of HelmMotion tokens | MINOR |

### 4. Dashboard — 80/100

| Finding | Severity |
|---------|----------|
| Background, typography, FAB color all token-correct | PASS |
| HelmRealityStack, S2sHeroBlock, HelmCalculationTrace wired correctly | PASS |
| `Icon(Icons.add_rounded, Colors.white)` on FAB | MAJOR |
| `Icons.touch_app_rounded`, `Icons.close_rounded` in hint | MAJOR |
| `BorderRadius.circular(12)` hardcoded in hint box | MINOR |

### 5. S2S Hero Block — 90/100

| Finding | Severity |
|---------|----------|
| HelmMotion, HelmAmount, HelmLedgerRail, HelmTrustStrip all correct | PASS |
| Reduced-motion respected | PASS |
| `letterSpacing: 1.5` override | MINOR |
| `'SAFE-TO-SPEND'` ALL-CAPS — FIN-14 violation | MINOR |

### 6. Calculation Trace — 85/100

| Finding | Severity |
|---------|----------|
| HelmMotion stagger, HelmAuditCard, reduced-motion — all correct | PASS |
| Hardcoded drag handle: `width: 40, height: 4, BorderRadius: 2` | MINOR |

### 7. Pipeline Screen — 60/100

| Finding | Severity |
|---------|----------|
| `elevation: 0` AppBar | PASS |
| `Icons.keyboard_arrow_up/down_rounded` | MAJOR |
| `Icons.add, color: Colors.white` | MAJOR |
| Hardcoded state rail dimensions, radii | MINOR |

### 8. Income List Screen — 30/100

| Finding | Severity |
|---------|----------|
| 14+ `ResponsiveUtilities.font()` calls — bypasses tokens entirely | MAJOR |
| `BorderRadius.circular(16)` cards — wrong (should be 12) | MAJOR |
| AppButton, Material Icons throughout | MAJOR |
| `fontStyle: FontStyle.italic` on notes | BLOCKER |
| Amount display not using HelmAmount | MAJOR |

### 9. Add Income Screen — 40/100

| Finding | Severity |
|---------|----------|
| 5+ `ResponsiveUtilities.font()` calls | MAJOR |
| 12+ `BorderRadius.circular(12)` hardcoded | MAJOR |
| AppButton, Material Icons | MAJOR |
| Animation durations literal instead of HelmMotion | MINOR |

### 10. Add Transaction Screen — 20/100

| Finding | Severity |
|---------|----------|
| EXPENSE CATEGORIES: Food, Transport, Shopping, Bills, Entertainment, Health, Education, Other | **BLOCKER** |
| AppButton, Material Icons, `ResponsiveUtilities.font()` throughout | MAJOR |
| Hardcoded radii | MINOR |

### 11. STS Settings Screen — 25/100

| Finding | Severity |
|---------|----------|
| Zero typography tokens — all `fontSize:` hardcoded | MAJOR |
| `FontStyle.italic` on buffer description | **BLOCKER** |
| `FontWeight.bold` x6+ | MAJOR |
| AppButton, `Icons.delete`, Material Icons | MAJOR |
| `Theme.of(context).scaffoldBackgroundColor` instead of `colors.canvas` | MINOR |

### 12. PIN Entry / PIN Setup — 55/100

| Finding | Severity |
|---------|----------|
| HelmColors (canvas, interactive) correct | PASS |
| 3x hardcoded fontSize (22, 14, 24) | MAJOR |
| 72x72 numpad buttons with hairline borders | PASS |

### 13. Delete Account Screen — 50/100

| Finding | Severity |
|---------|----------|
| `elevation: 0` correct | PASS |
| Button height 52pt instead of 48pt (VIS-019) | MAJOR |
| `Icons.remove_circle_outline` | MAJOR |

### 14. Audit Log Screen — 45/100

| Finding | Severity |
|---------|----------|
| State color tokens correct | PASS |
| `fontSize: 12` hardcoded | MAJOR |
| Material Icons throughout | MAJOR |

### 15. Export Screen — 30/100

| Finding | Severity |
|---------|----------|
| 4x hardcoded fontSize (22, 14, 16, 14) | MAJOR |
| Raw `ElevatedButton` — no AppButton | MAJOR |
| Material Icons | MAJOR |

### 16. Bottom Navigation — 65/100

| Finding | Severity |
|---------|----------|
| Themed correctly with HelmColors | PASS |
| `labelSm` token used | PASS |
| Material Icons | MAJOR |
| 3 tabs present — doctrine requires 4 (missing History) | MAJOR |

### 17. AppButton Component — 15/100

| Finding | Severity |
|---------|----------|
| Imports DEPRECATED `AppColors` | **BLOCKER** |
| `AppColors.primary` = #2453FF bright blue | **BLOCKER** |
| `Colors.grey[500/300]`, `AppColors.textLight/textDark` | MAJOR |
| `BorderRadius.circular(12)` — should be 10pt (buttonRadius) | MAJOR |
| `ResponsiveUtilities.verticalPadding` — no fixed 48pt height | MAJOR |

Single file responsible for more toy-feel than any other. Used in 13 files.

### 18. Dead Code: safe_to_spend_hero.dart

Not imported anywhere. Contains BoxShadow, 36pt font, italic, bold, wrong radii, Material Icons. **Delete.** S2sHeroBlock is the real widget.

---

## Design Token System Assessment

### Token Definitions: 100% Correct

| Token File | Status |
|------------|--------|
| helm_colors.dart | PERFECT — 13 tokens, light/dark |
| helm_typography.dart | PERFECT — 18 styles, 3 font families |
| helm_spacing.dart | PERFECT — 8pt grid, component dimensions |
| helm_motion.dart | PERFECT — ease-out only, max 320ms |
| app_theme.dart | CORRECT — ThemeExtension, elevation 0 |

### Token Adoption: 60% Migrated

| Metric | Value |
|--------|-------|
| Token refs in feature files | 228 |
| Hardcoded fontSize in features | 69 |
| Files fully migrated | 8/21 screens |
| Files with zero token usage | 4 (STS settings, export, add transaction, income list) |

### Core Widget Compliance: 12/13 PASS

All pass (HelmHeroZone, HelmLedgerCard, HelmAuditCard, HelmCautionCard, HelmSourceCard, HelmAmount, HelmTrustStrip, HelmLedgerRail, HelmRealityStack, HelmCalculationTrace, HelmMoneySourceLabel, HelmToast) except HelmFxEstimate (PARTIAL, minor).

---

## BLOCKER Findings (Must Fix Before Beta)

| # | Location | Finding | Fix |
|---|----------|---------|-----|
| B1 | AppButton | AppColors.primary (#2453FF) on 13 screens | Rewrite to HelmColors.interactive |
| B2 | Add Transaction | Expense categories | Kill categories, replace with "Cash out" |
| B3 | Splash | CircleAvatar "P" placeholder | Replace with wordmark |
| B4 | Splash | 1800ms animation | Reduce to 320ms |
| B5 | Global | Zero Phosphor icons — 66 Material across 16 files | Add package, replace all Icons.* |
| B6 | STS Settings:88 | FontStyle.italic on buffer description | Remove italic |
| B7 | Income List:532 | FontStyle.italic on notes | Remove italic |

---

## MAJOR Findings

| # | Screen | Finding | Fix |
|---|--------|---------|-----|
| M1 | Income List | 14+ hardcoded fontSize via ResponsiveUtilities | HelmTypography tokens |
| M2 | STS Settings | 9 hardcoded fontSize, zero tokens | Full HelmTypography migration |
| M3 | Export | 4 hardcoded fontSize, raw ElevatedButton | Tokens + AppButton |
| M4 | 8 files | 26x FontWeight.bold (w700) | Replace with w600 |
| M5 | 12 files | 20x Colors.black/Colors.white | HelmColors tokens |
| M6 | 4 files | 4x BoxShadow | Remove entirely |
| M7 | Add Income | 12+ hardcoded BorderRadius, 5+ hardcoded fontSize | Token migration |
| M8 | Bottom Nav | 3 tabs instead of 4 (missing History) | Add History tab |
| M9 | Delete Account | Button height 52pt instead of 48pt | Fix to 48pt |
| M10 | Pipeline | Material Icons + Colors.white on FAB | Token replacement |
| M11 | safe_to_spend_hero.dart | Dead code file | Delete |

---

## MINOR Findings

| # | Area | Finding |
|---|------|---------|
| N1 | S2sHeroBlock:105 | letterSpacing: 1.5 on label |
| N2 | S2sHeroBlock:103 | ALL-CAPS "SAFE-TO-SPEND" |
| N3 | Onboarding | Literal 200/300ms instead of HelmMotion tokens |
| N4 | CalcTrace | Hardcoded drag handle dimensions |
| N5 | Pipeline | Hardcoded state rail dimensions (3x14) |
| N6 | Various | ~80 hardcoded BorderRadius matching correct values but not token refs |
| N7 | Confirm Sheet | Bengali Taka symbol without l10n |
| N8 | Various | Hardcoded alpha on decorative elements |
| N9 | Splash:41 | Curves.easeIn instead of easeOut |

---

## Worst-to-Best Screen Ranking

| Rank | Screen | Score |
|------|--------|-------|
| 21 | AppButton | 15 |
| 20 | Add Transaction | 20 |
| 19 | Splash | 25 |
| 18 | STS Settings | 25 |
| 17 | Income List | 30 |
| 16 | Export | 30 |
| 15 | Income Pipeline Summary | 40 |
| 14 | Add Income | 40 |
| 13 | Audit Log | 45 |
| 12 | Delete Account | 50 |
| 11 | PIN Entry | 55 |
| 10 | PIN Setup | 55 |
| 9 | Pipeline Screen | 60 |
| 8 | Confirm Received Sheet | 65 |
| 7 | Onboarding | 65 |
| 6 | Bottom Navigation | 65 |
| 5 | Pipeline Entry Card | 70 |
| 4 | Welcome | 70 |
| 3 | Dashboard | 80 |
| 2 | Calculation Trace | 85 |
| 1 | S2S Hero Block | 90 |

---

## Acceptance Criteria for Beta-Ready

| Criterion | Current | Required |
|-----------|---------|----------|
| BLOCKER findings | 7 | 0 |
| Material Icons | 66 | 0 |
| AppButton on AppColors | 29 | 0 |
| Italic usage | 3 | 0 |
| BoxShadow | 4 | 0 |
| Expense categories | present | removed |
| Splash logo | placeholder | designed |
| Hardcoded fontSize in features | 69 | < 10 |
| Screen score floor | 20 | > 50 |
| Overall weighted score | 52 | > 70 |

---

*End of A4V-1 Adversarial Attack Report. No code was modified.*
