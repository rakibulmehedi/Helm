# A4V-1: Adversarial UI/UX Attack Report

> **Sprint:** A4V-1 (Inspection Only -- No Implementation)
> **Posture:** Hostile fintech design examiner
> **Date:** 2026-06-08
> **Examiner mandate:** Decide whether Pocketa deserves to be seen by real Bangladeshi freelancers
> **Method:** Full code inspection of every screen, widget, token file, and route
> **Evidence:** file:line references from actual source code. No assumptions.

---

## Verdict: MAJOR VISUAL MATURITY GAP

Pocketa is **not visually beta-ready**. The core product screen (dashboard + S2S hero) is near-doctrine, but the periphery is so inconsistent that the app feels like two different products stitched together. A freelancer opening this app will see a beautiful cockpit, then encounter bright blue buttons, generic Material Icons, expense categories, and a splash screen that screams "student project."

The foundation is strong. The surface is fractured. The fix is migration, not redesign.

---

## Global Violation Inventory

| Pattern | Count | Files | Severity |
|---------|-------|-------|----------|
| `AppButton` (legacy buttons) | 29 | 13 | BLOCKER -- pumps #2453FF blue into every screen |
| `Icons.` (Material Icons) | 66 | 16 | BLOCKER -- zero Phosphor, generic Flutter look |
| `fontSize:` (hardcoded) | 69 | 14 | MAJOR -- bypasses PocketaTypography |
| `BorderRadius.circular` (hardcoded) | 98 | 28 | MAJOR -- inconsistent radii |
| `FontWeight.bold/w700+` | 26 | 8 | MAJOR -- exceeds max w600 |
| `Colors.black/white` (raw) | 20 | 12 | MAJOR -- breaks warm neutral palette |
| `AppColors` (deprecated) | 7 | 4 | MAJOR -- legacy color system |
| `BoxShadow` | 4 | 4 | MAJOR -- doctrine says zero shadows |
| `FontStyle.italic` | 3 | 3 | BLOCKER -- doctrine says zero italics |
| `withOpacity` (text) | 2 | 2 | MINOR -- mostly migrated to withValues |
| `elevation > 0` | 0 | 0 | PASS |
| `LinearGradient` | 0 | 0 | PASS |
| Phosphor icons in code | 0 | 0 | BLOCKER -- package not installed |

---

## Screen-by-Screen Inspection

### 1. Splash Screen -- Score: 25/100

**File:** `lib/features/splash/views/splash_screen.dart`

| Line | Finding | Severity | Doctrine Conflict |
|------|---------|----------|-------------------|
| 37 | `Duration(milliseconds: 1800)` -- 5.6x over max 320ms | BLOCKER | PocketaMotion.slow = 320ms max |
| 79-90 | `CircleAvatar` with letter "P" as logo | BLOCKER | TOY-02: placeholder logo destroys first impression |
| 85 | `fontSize: 52` hardcoded | MAJOR | Should use PocketaTypography token |
| 86 | `fontWeight: FontWeight.bold` (w700) | MAJOR | Max allowed is w600 |
| 95 | `fontSize: 32` hardcoded | MAJOR | Should use PocketaTypography.headingLg (22) or displayLarge (40) |
| 81 | `Colors.white` raw | MAJOR | Should use PocketaColors token |
| 96 | `Colors.white` raw | MAJOR | Should use PocketaColors token |
| 97 | `fontWeight: FontWeight.bold` (w700) | MAJOR | Max allowed is w600 |
| 41 | `Curves.easeIn` | MINOR | PocketaMotion.defaultCurve = Curves.easeOut only |

**Root cause:** Splash was never redesigned. Still the original dev placeholder from project init.

**Trust damage:** First screen user sees. Sets expectation for entire app. CircleAvatar "P" is indistinguishable from a Flutter tutorial output. 1800ms feels like the app is broken/slow on Redmi Note devices.

**Hidden potential:** Replace with clean teal-on-canvas wordmark + 300ms fade = instant premium feel.

---

### 2. Welcome Screen -- Score: 70/100

**File:** `lib/features/onboarding/presentation/views/welcome_screen.dart`

| Finding | Severity |
|---------|----------|
| Uses PocketaTypography (headingLg, bodyLg) correctly | PASS |
| Uses PocketaSpacing.screenEdge correctly | PASS |
| Uses AppButton (legacy) -- injects #2453FF blue button | MAJOR |

**Root cause:** Screen was rewritten in UX sprints with proper tokens, but AppButton was not migrated.

**Trust damage:** Correct copy and typography, then a bright blue "Continue" button that contradicts deep teal brand.

---

### 3. Onboarding (6 Steps) -- Score: 65/100

**Files:** `lib/features/onboarding/presentation/views/pages/*.dart`

| File | Line | Finding | Severity |
|------|------|---------|----------|
| onboarding_screen.dart | 55 | `Duration(milliseconds: 300)` -- should use PocketaMotion.slow (320ms) or base (200ms) | MINOR |
| onboarding_progress_line.dart | 16 | `Duration(milliseconds: 300)` -- should use PocketaMotion token | MINOR |
| qualifying_question_page.dart | all | Uses PocketaTypography + PocketaColors correctly throughout | PASS |
| qualifying_question_page.dart | 128 | AppButton (5 instances across qualifying page) | MAJOR |
| liquid_balance_page.dart | all | Uses monoFinancialLg for amount -- CORRECT | PASS |
| liquid_balance_page.dart | 185-197 | Hardcoded progress line height: 2, BorderRadius: 1 | MINOR |
| fixed_costs_page.dart | 270 | `Duration(milliseconds: 200)` -- should use PocketaMotion.base | MINOR |
| fixed_costs_page.dart | 271-275 | Checkbox: hardcoded 20x20, BorderRadius: 4 | MAJOR |
| fixed_costs_page.dart | 315 | `width: 120` fixed for TextField | MAJOR |
| income_pattern_page.dart | 166 | `Duration(milliseconds: 200)` -- should use PocketaMotion.base | MINOR |
| income_pattern_page.dart | 171 | Uses PocketaSpacing.cardRadius correctly | PASS |
| buffer_comfort_page.dart | 110 | Hardcoded trackHeight: 3 for Slider | MINOR |
| buffer_comfort_page.dart | all | Uses PocketaTypography (headingLg, bodyLg, monoFinancialMd, bodySm) correctly | PASS |
| first_pipeline_page.dart | 105,135,153 | `BorderRadius.circular(12)` hardcoded 3x -- should use PocketaSpacing.cardRadius | MAJOR |
| first_pipeline_page.dart | 155 | Hardcoded contentPadding instead of PocketaSpacing | MINOR |
| ALL pages | - | AppButton used for primary actions | MAJOR |
| ALL pages | - | Material Icons (Icons.check, Icons.info_outline_rounded) | MAJOR |

**Root cause:** Onboarding content was rewritten with correct tokens, but form widgets and buttons still use legacy system.

**Trust damage:** User flows through a well-worded, correctly-typed journey, then hits bright blue buttons on every page. Breaks the calm teal identity.

---

### 4. Dashboard -- Score: 80/100

**File:** `lib/features/dashboard/presentation/views/dashboard_screen.dart`

| Line | Finding | Severity |
|------|---------|----------|
| 86 | `colors.canvas` for background -- CORRECT | PASS |
| 92 | `typography.headingMd` for title -- CORRECT | PASS |
| 111-117 | FAB: `colors.interactive` bg -- CORRECT | PASS |
| 116 | `Icon(Icons.add_rounded, color: Colors.white, size: 28)` -- Material icon + raw white | MAJOR |
| 102 | `Icon(Icons.refresh_rounded, size: 20)` -- Material icon (debug only, gated) | MINOR |
| 141 | `BorderRadius.circular(12)` hardcoded for hint box | MINOR |
| 138 | `EdgeInsets.symmetric(horizontal: 16, vertical: 12)` hardcoded | MINOR |
| 147-158 | `Icons.touch_app_rounded`, `Icons.close_rounded` -- Material icons in hint | MAJOR |
| 164 | `PocketaRealityStack` -- CORRECT | PASS |
| 166 | `S2sHeroBlock` with all correct props -- CORRECT | PASS |
| 175 | `PocketaCalculationTrace.show()` on tap -- CORRECT | PASS |
| 183-198 | CommittedSection + ReserveSection + NotCountedSection -- CORRECT structure | PASS |

**Root cause:** Dashboard was redesigned in UX-1 sprint with full token compliance. Only Material Icons and a few hardcoded hint styles remain.

**Trust damage:** Minimal. This is the best screen. Material Icons are the only visible flaw to users.

---

### 5. S2S Hero Block -- Score: 90/100

**File:** `lib/features/dashboard/presentation/widgets/s2s_hero_block.dart`

| Line | Finding | Severity |
|------|---------|----------|
| 61 | `PocketaMotion.s2sAppear` (200ms) -- CORRECT | PASS |
| 64 | `PocketaMotion.defaultCurve` (easeOut) -- CORRECT | PASS |
| 69-77 | Respects `disableAnimations` reduced-motion -- CORRECT | PASS |
| 104 | `typography.labelSm` -- CORRECT | PASS |
| 105 | `letterSpacing: 1.5` -- typography rule: no letter-spacing overrides | MINOR |
| 103 | `'SAFE-TO-SPEND'` ALL-CAPS -- FIN-14 violation (no ALL-CAPS except tab bar) | MINOR |
| 117 | `typography.displayHero` for em-dash fallback -- CORRECT | PASS |
| 123-126 | `PocketaAmount(size: AmountSize.hero)` -- CORRECT | PASS |
| 131 | `typography.bodySm` -- CORRECT | PASS |
| 137-140 | `PocketaLedgerRail(state: ..., isHero: true)` -- CORRECT | PASS |
| 144-148 | `PocketaTrustStrip(updatedAt: ..., sourceLabel: ...)` -- CORRECT | PASS |

**Root cause:** Purpose-built in UX-1 sprint with full token system. Near-doctrine.

**Trust damage:** None. This is the product's strongest visual moment.

**NOTE:** `lib/features/safe_to_spend/presentation/widgets/safe_to_spend_hero.dart` is **DEAD CODE** (nobody imports it). Contains BoxShadow, 36pt font, wrong everything. Must be deleted.

---

### 6. Calculation Trace -- Score: 85/100

**File:** `lib/core/widgets/pocketa_calculation_trace.dart`

| Finding | Severity |
|---------|----------|
| Uses PocketaMotion tokens for stagger animation (24ms per row) | PASS |
| Uses PocketaAuditCard for ledger-style rows | PASS |
| Respects reduced-motion preference | PASS |
| Hardcoded drag handle: `width: 40, height: 4, BorderRadius: 2` | MINOR |

**Root cause:** Purpose-built widget. Minor hardcoded dimensions only.

---

### 7. Pipeline Screen -- Score: 60/100

**File:** `lib/features/income/presentation/views/pipeline_screen.dart`

| Line | Finding | Severity |
|------|---------|----------|
| 80 | `elevation: 0` AppBar -- CORRECT | PASS |
| 203 | `Container(width: 3, height: 14)` -- hardcoded state rail dimensions | MINOR |
| 246 | `BorderRadius.circular(4)` -- hardcoded | MINOR |
| 268,270 | `Icons.keyboard_arrow_up/down_rounded` -- Material icons | MAJOR |
| 305,316 | `Icons.add, color: Colors.white` -- Material icon + raw white | MAJOR |
| 336 | `size: 48` -- hardcoded empty state icon | MINOR |

**Root cause:** Pipeline structure correct (5 sections, color-coded), but visual polish uses Material defaults.

---

### 8. Income List Screen -- Score: 30/100

**File:** `lib/features/income/presentation/views/income_list_screen.dart`

| Line | Finding | Severity |
|------|---------|----------|
| 141 | `ResponsiveUtilities.font(context, 18)` -- bypasses tokens | MAJOR |
| 146 | `Icons.arrow_back_ios_new_rounded` -- Material icon | MAJOR |
| 155 | `size: 28` FAB icon -- hardcoded | MINOR |
| 198 | `ResponsiveUtilities.font(context, 12)` | MAJOR |
| 277-283 | `BorderRadius.circular(20)` filter chip -- hardcoded | MAJOR |
| 322-326 | `BorderRadius.circular(16)` dismiss bg -- hardcoded | MINOR |
| 365,368 | Card: `EdgeInsets.all(16)`, `BorderRadius.circular(16)` -- hardcoded, wrong radius (should be 12) | MAJOR |
| 389-390 | Status icon: `statusColor.withValues(alpha: 0.12)` -- hardcoded alpha | MINOR |
| 408 | `ResponsiveUtilities.font(context, 15)` | MAJOR |
| 418 | `ResponsiveUtilities.font(context, 12)` | MAJOR |
| 431-432 | Badge: hardcoded padding 10/4 | MINOR |
| 440 | `ResponsiveUtilities.font(context, 11)` | MAJOR |
| 460 | `ResponsiveUtilities.font(context, 18)` -- amount display not using PocketaAmount | MAJOR |
| 472,494 | `size: 11` -- icon sizes hardcoded | MINOR |
| 480,502,530 | 3x `ResponsiveUtilities.font(context, 11)` | MAJOR |
| 532 | `fontStyle: FontStyle.italic` -- notes rendered italic | BLOCKER |
| 597-601 | Empty state: hardcoded icon bg, `size: 40` | MINOR |
| 611,620,667,676 | 4x more ResponsiveUtilities.font hardcodes | MAJOR |
| ALL | Uses AppButton, Material Icons throughout | MAJOR |

**Root cause:** This screen was never redesigned. It is Phase 7c code from initial implementation. Zero token migration. ResponsiveUtilities.font() systematically bypasses PocketaTypography.

**Trust damage:** HIGH. Users see their income pipeline entries rendered with inconsistent font sizes, bright blue buttons, generic Material Icons, italic notes. Financial data displayed without monospace font (PocketaAmount not used for amounts). Card radius 16 instead of doctrine 12.

**Hidden potential:** This screen displays the user's actual money pipeline. With proper PocketaAmount for numbers, PocketaLedgerCard for entries, and PocketaSourceCard for pipeline items, it would feel like a real financial ledger.

---

### 9. Add Income Screen -- Score: 40/100

**File:** `lib/features/income/presentation/views/add_income_screen.dart`

| Line | Finding | Severity |
|------|---------|----------|
| 219 | `ResponsiveUtilities.font(context, 18)` | MAJOR |
| 409 | `BorderRadius.circular(12)` hardcoded (6+ instances across file) | MAJOR |
| 419,426,512,558,634 | 5x `ResponsiveUtilities.font()` hardcodes | MAJOR |
| 547,623 | `Duration(milliseconds: 200)` -- should use PocketaMotion.base | MINOR |
| 551,628 | `BorderRadius.circular(10)` -- correct value but not using token | MINOR |
| ALL | AppButton, Material Icons | MAJOR |
| 466 | `colors.inkTertiary.withValues(alpha: 0.6)` -- hardcoded alpha | MINOR |

**Root cause:** Form screen with correct fields (FX rate, exclude, source label) but legacy visual treatment.

---

### 10. Add Transaction Screen -- Score: 20/100

**File:** `lib/features/transactions/presentation/views/add_transaction_screen.dart`

| Line | Finding | Severity |
|------|---------|----------|
| 26-35 | EXPENSE CATEGORIES: Food, Transport, Shopping, Bills, Entertainment, Health, Education, Other | **BLOCKER** |
| ALL | AppButton with #2453FF primary color | MAJOR |
| ALL | Material Icons | MAJOR |
| ALL | ResponsiveUtilities.font() bypasses tokens | MAJOR |
| 311 | `BorderRadius.circular(10)` hardcoded | MINOR |
| 329,337 | `BorderRadius.circular(12)` hardcoded | MINOR |

**Root cause:** Phase 6 legacy screen. Expense categories are explicitly on TOY-06 BLOCKER list AND killed by Final Product Doctrine ("Pocketa is not a backward-looking expense tracker"). Categories make the app indistinguishable from TallyKhata/Hishabee.

**Trust damage:** CRITICAL. Expense categories are the #1 signal that says "this is a generic expense tracker." Every freelancer who sees Food/Transport/Shopping will mentally categorize Pocketa as "another TallyKhata" and never discover the S2S value.

**Hidden potential:** Replace categories with simple "Cash out" recording (amount + optional note). No categorization. The product is about what you CAN spend, not where you DID spend.

---

### 11. STS Settings Screen -- Score: 25/100

**File:** `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart`

| Line | Finding | Severity |
|------|---------|----------|
| 37 | `TextStyle(fontSize: 16, fontWeight: FontWeight.bold)` | MAJOR |
| 42 | `fontSize: 13` hardcoded | MAJOR |
| 64 | `TextStyle(fontWeight: FontWeight.bold)` no token | MAJOR |
| 75 | `TextStyle(fontSize: 16, fontWeight: FontWeight.bold)` | MAJOR |
| 80 | `fontSize: 13` hardcoded | MAJOR |
| 87-88 | `fontSize: 13, fontStyle: FontStyle.italic` | **BLOCKER** |
| 113 | `TextStyle(fontWeight: FontWeight.bold)` | MAJOR |
| 124 | `TextStyle(fontSize: 16, fontWeight: FontWeight.bold)` | MAJOR |
| 129 | `fontSize: 13` | MAJOR |
| 162 | `Icon(Icons.delete, color: Colors.white)` | MAJOR |
| 189-190 | `TextStyle(fontWeight: FontWeight.bold, fontSize: 16)` | MAJOR |
| 365 | `fontSize: 20` hardcoded (not in type scale) | MAJOR |
| 23 | `Theme.of(context).scaffoldBackgroundColor` -- not using colors.canvas | MINOR |
| 30 | `EdgeInsets.all(16.0)` hardcoded | MINOR |
| 137,183,208,373,399,421 | 6x `BorderRadius.circular(12)` hardcoded | MINOR |
| ALL | AppButton, Material Icons | MAJOR |

**Root cause:** Never touched during UX sprints. Pure Phase 1 legacy. Zero token references for typography.

**Trust damage:** User adjusts their safety buffer (critical financial setting) on a screen that looks nothing like the dashboard. Visual inconsistency erodes trust in the calculation.

---

### 12. PIN Entry / PIN Setup -- Score: 55/100

**Files:** `lib/features/auth/presentation/views/pin_entry_screen.dart`, `pin_setup_screen.dart`

| Finding | Severity |
|---------|----------|
| Uses PocketaColors (canvas, interactive) correctly | PASS |
| 3x hardcoded fontSize (22, 14, 24) | MAJOR |
| Hardcoded EdgeInsets.symmetric(horizontal: 10/40) | MINOR |
| 72x72 numpad buttons with hairline borders | PASS (acceptable) |
| Analytics: pinGateOpened, pinAuthSuccess, pinAuthFailed | PASS |

**Root cause:** D1 Trust Layer sprint. Correct color tokens, but font sizes and spacing predate typography system.

---

### 13. Delete Account Screen -- Score: 50/100

**File:** `lib/features/account/presentation/views/delete_account_screen.dart`

| Line | Finding | Severity |
|------|---------|----------|
| 202 | `minimumSize: Size.fromHeight(52)` -- button height 52pt (should be 48pt per VIS-019) | MAJOR |
| 135 | `elevation: 0` -- CORRECT | PASS |
| ALL | Uses PocketaSpacing + PocketaTypography in some places | PARTIAL |
| ALL | Material Icons (remove_circle_outline) | MAJOR |
| 530-549 | Keypad: hardcoded 72x52 dimensions | MINOR |

---

### 14. Audit Log Screen -- Score: 45/100

**File:** `lib/features/audit_log/presentation/views/audit_log_screen.dart`

| Line | Finding | Severity |
|------|---------|----------|
| 78 | `fontSize: 12` hardcoded | MAJOR |
| 24 | `elevation: 0` -- CORRECT | PASS |
| ALL | Material Icons (add_circle_outline, edit_outlined, etc.) | MAJOR |
| ALL | Correct state color tokens for event types | PASS |

---

### 15. Export Screen -- Score: 30/100

**File:** `lib/features/export/presentation/views/export_screen.dart`

| Line | Finding | Severity |
|------|---------|----------|
| 57 | `fontSize: 22` hardcoded (not in type scale) | MAJOR |
| 67 | `fontSize: 14` hardcoded | MAJOR |
| 75 | `fontSize: 16` hardcoded | MAJOR |
| 133 | `fontSize: 14` hardcoded | MAJOR |
| 50 | `EdgeInsets.all(16)` hardcoded | MINOR |
| ALL | Uses raw ElevatedButton, not AppButton (inconsistent) | MAJOR |
| ALL | Material Icons (check_circle_outline) | MAJOR |

---

### 16. Bottom Navigation -- Score: 65/100

**File:** `lib/config/router/app_router.dart:203`

| Finding | Severity |
|---------|----------|
| BottomNavigationBar EXISTS with 3 tabs (Home, Pipeline, Settings) | PASS |
| Themed correctly in app_theme.dart with PocketaColors | PASS |
| Uses Material Icons (home_rounded, inbox_rounded, settings_rounded) | MAJOR |
| Doctrine says 4 tabs (Home, Pipeline, History, Settings) -- only 3 present | MAJOR |
| Typography uses labelSm token | PASS |

---

### 17. AppButton Component -- Score: 15/100

**File:** `lib/core/widgets/buttons/button_multiple_types.dart`

| Line | Finding | Severity |
|------|---------|----------|
| 5 | `import '../../themes/colors.dart'` -- imports DEPRECATED AppColors | **BLOCKER** |
| 39 | `AppColors.primary` = #2453FF bright blue | **BLOCKER** |
| 41 | `Colors.white` foreground | MAJOR |
| 45-47 | `Colors.grey[500]`, `Colors.grey[300]`, `AppColors.textLight/textDark` | MAJOR |
| 52-53 | `AppColors.primary` for outline type | MAJOR |
| 66 | `BorderRadius.circular(12)` -- should be 10pt (buttonRadius) | MAJOR |
| 64 | `ResponsiveUtilities.verticalPadding` -- no fixed 48pt height | MAJOR |

**Root cause:** The #1 visual contamination vector. Used in 13 files. Every screen that uses AppButton shows bright blue (#2453FF) instead of deep teal (#255E5B). This single file is responsible for more toy-feel than any other.

---

### 18. Dead Code: safe_to_spend_hero.dart

**File:** `lib/features/safe_to_spend/presentation/widgets/safe_to_spend_hero.dart`

| Finding | Severity |
|---------|----------|
| NOT IMPORTED ANYWHERE -- confirmed via grep | CAN_DELAY |
| Contains BoxShadow (lines 40-46) | -- |
| Contains 36pt font instead of 64pt | -- |
| Contains BorderRadius: 16 instead of 12 | -- |
| Contains FontStyle.italic (line 376) | -- |
| Contains FontWeight.bold throughout | -- |
| Contains Material Icons | -- |

**Action:** Delete. Causes confusion during code review. S2sHeroBlock is the real widget.

---

## Design Token System Assessment

### Token Definitions: 100% Correct

| Token File | Status | Notes |
|------------|--------|-------|
| pocketa_colors.dart | PERFECT | 13 tokens, light/dark, all match doctrine |
| pocketa_typography.dart | PERFECT | 18 styles, 3 font families, Bangla variants |
| pocketa_spacing.dart | PERFECT | Full 8pt grid, component dimensions |
| pocketa_motion.dart | PERFECT | Ease-out only, max 320ms, stagger tokens |
| app_theme.dart | CORRECT | ThemeExtension integration, elevation 0 |

### Token Adoption: 60% Migrated

| Metric | Value |
|--------|-------|
| PocketaTypography/Spacing/Motion refs in feature files | 228 |
| Hardcoded fontSize in feature files | 69 |
| Hardcoded BorderRadius in feature files | ~80 (excluding core) |
| Files fully migrated to tokens | 8/21 screens |
| Files with zero token usage | 4 (STS settings, export, add transaction, income list) |

### Core Widget Compliance: 12/13 PASS

| Widget | Token Compliance |
|--------|-----------------|
| PocketaHeroZone | FULL |
| PocketaLedgerCard | FULL |
| PocketaAuditCard | FULL |
| PocketaCautionCard | FULL |
| PocketaSourceCard | FULL |
| PocketaAmount | FULL |
| PocketaTrustStrip | FULL |
| PocketaFxEstimate | PARTIAL (minor) |
| PocketaLedgerRail | FULL |
| PocketaRealityStack | FULL |
| PocketaCalculationTrace | FULL |
| PocketaMoneySourceLabel | FULL |
| PocketaToast | FULL |

---

## BLOCKER Findings (Must Fix Before Beta)

| # | Screen/Component | Finding | Root Cause | Fix Direction |
|---|-----------------|---------|------------|---------------|
| B1 | AppButton | Uses AppColors.primary (#2453FF) -- bright blue buttons on 13 screens | Legacy button never migrated | Rewrite to use PocketaColors.interactive (#255E5B) |
| B2 | Add Transaction | Expense categories (Food/Transport/Shopping/etc.) | Phase 6 legacy -- identity violation | Kill categories. Replace with simple "Cash out" label |
| B3 | Splash | CircleAvatar "P" placeholder logo | Never designed | Replace with wordmark or minimal geometric mark |
| B4 | Splash | 1800ms animation | Never revised | Reduce to PocketaMotion.slow (320ms) max |
| B5 | Global | Zero Phosphor icons -- 66 Material Icons across 16 files | phosphor_flutter not in pubspec | Add package, replace all Icons.* refs |
| B6 | STS Settings:88 | FontStyle.italic on buffer description | Phase 1 legacy | Remove italic |
| B7 | Income List:532 | FontStyle.italic on notes | Phase 7c legacy | Remove italic |

---

## MAJOR Findings

| # | Screen | Finding | Fix Direction |
|---|--------|---------|---------------|
| M1 | Income List | 14+ hardcoded fontSize via ResponsiveUtilities | Replace with PocketaTypography tokens |
| M2 | STS Settings | 9 hardcoded fontSize, zero typography tokens | Full migration to PocketaTypography |
| M3 | Export | 4 hardcoded fontSize, raw ElevatedButton | Migrate to tokens + AppButton |
| M4 | 8 files | 26x FontWeight.bold (w700) | Replace with FontWeight.w600 |
| M5 | 12 files | 20x Colors.black/Colors.white | Replace with PocketaColors tokens |
| M6 | 4 files | 4x BoxShadow | Remove entirely |
| M7 | Add Income | 12+ hardcoded BorderRadius, 5+ hardcoded fontSize | Migrate to tokens |
| M8 | Bottom Nav | 3 tabs instead of doctrine 4 (missing History) | Add History tab |
| M9 | Delete Account | Button height 52pt instead of 48pt | Fix to 48pt |
| M10 | Pipeline | Material Icons + Colors.white on FAB | Replace with tokens |
| M11 | safe_to_spend_hero.dart | Dead code file still exists | Delete file |

---

## MINOR Findings

| # | Area | Finding |
|---|------|---------|
| N1 | S2sHeroBlock:105 | letterSpacing: 1.5 on label |
| N2 | S2sHeroBlock:103 | ALL-CAPS "SAFE-TO-SPEND" |
| N3 | Onboarding | Animation durations use literal 200/300 instead of PocketaMotion tokens |
| N4 | CalcTrace | Hardcoded drag handle dimensions |
| N5 | Pipeline | Hardcoded state rail dimensions (3x14) |
| N6 | Various | ~80 hardcoded BorderRadius.circular matching correct values but not using tokens |
| N7 | Confirm Sheet | Bengali Taka symbol hardcoded without l10n |
| N8 | Various | Hardcoded alpha values (withValues) on decorative elements |
| N9 | Splash:41 | Curves.easeIn instead of easeOut |

---

## Worst-to-Best Screen Ranking

| Rank | Screen | Score | Primary Damage |
|------|--------|-------|----------------|
| 21 | AppButton (component) | 15 | #1 contamination vector -- bright blue on 13 screens |
| 20 | Add Transaction | 20 | Expense categories BLOCKER + legacy everything |
| 19 | Splash | 25 | CircleAvatar placeholder + 1800ms animation |
| 18 | STS Settings | 25 | Zero tokens, italic, heaviest legacy debt |
| 17 | Income List | 30 | 14+ hardcoded fonts, italic, worst frequently-seen screen |
| 16 | Export | 30 | 4 hardcoded fonts, raw ElevatedButton |
| 15 | Income Pipeline Summary | 40 | 6 hardcoded fonts, Material Icons, BoxShadow |
| 14 | Add Income | 40 | 9+ hardcoded fonts, 12+ hardcoded radii |
| 13 | Audit Log | 45 | Hardcoded font, Material Icons |
| 12 | Delete Account | 50 | Button height wrong, Material Icons |
| 11 | PIN Entry | 55 | Hardcoded fonts/spacing, correct colors |
| 10 | PIN Setup | 55 | Same as PIN Entry |
| 9 | Pipeline Screen | 60 | Material Icons, Colors.white |
| 8 | Confirm Received Sheet | 65 | Hardcoded radii, withOpacity |
| 7 | Onboarding (6 steps) | 65 | AppButton legacy, hardcoded form radii |
| 6 | Bottom Navigation | 65 | Material Icons, missing History tab |
| 5 | Pipeline Entry Card | 70 | Colors.black, Material Icons |
| 4 | Welcome | 70 | AppButton only issue |
| 3 | Dashboard | 80 | Material Icons, Colors.white on FAB |
| 2 | Calculation Trace | 85 | Minor hardcoded dimensions |
| 1 | S2S Hero Block | 90 | Near-perfect. ALL-CAPS label only issue |

---

## Overall Score: 52/100 -- MAJOR VISUAL MATURITY GAP

**Weighted by user-facing importance:**

| Screen Group | Weight | Avg Score | Contribution |
|-------------|--------|-----------|-------------|
| Dashboard + S2S Hero + CalcTrace | 30% | 85 | 25.5 |
| Onboarding + Welcome | 15% | 66 | 9.9 |
| Pipeline flow | 15% | 55 | 8.25 |
| Auth screens | 10% | 55 | 5.5 |
| Income management | 10% | 35 | 3.5 |
| Settings/utility | 10% | 27 | 2.7 |
| Add Transaction | 5% | 20 | 1.0 |
| Export/Audit/Delete | 5% | 40 | 2.0 |
| **TOTAL** | **100%** | | **58.35** |

**Adjusted for BLOCKERs (-5 each):** 58.35 - (7 BLOCKERs x 5) = **~23/100 effective**

The raw score is 58, but 7 BLOCKER findings mean the app cannot ship. Each BLOCKER is a dealbreaker that must be resolved before any beta user sees the product.

---

## Acceptance Criteria for Beta-Ready

| Criterion | Current | Required |
|-----------|---------|----------|
| BLOCKER findings | 7 | 0 |
| Material Icons | 66 | 0 |
| AppButton on AppColors | 29 refs | 0 |
| Italic usage | 3 | 0 |
| BoxShadow | 4 | 0 |
| Expense categories | present | removed |
| Splash logo | placeholder | designed |
| Hardcoded fontSize in features | 69 | < 10 |
| Screen score floor | 20 (add transaction) | > 50 |
| Overall weighted score | 52 | > 70 |

---

*End of A4V-1 Adversarial Attack Report. No code was modified.*
