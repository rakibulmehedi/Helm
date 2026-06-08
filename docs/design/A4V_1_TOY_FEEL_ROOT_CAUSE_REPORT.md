# A4V-1: Toy-Feel Root Cause Report

> **Sprint:** A4V-1
> **Date:** 2026-06-08
> **Purpose:** Identify exactly WHY Pocketa feels like a toy and WHERE the feeling originates
> **Input:** Real-device feedback: "the app looks totally toy"

---

## The Diagnosis

The user is right. The app feels toy-like. But the reason is not what you might expect.

The **design system is correct**. PocketaColors, PocketaTypography, PocketaSpacing, PocketaMotion -- all 100% doctrine-compliant. 13 core widgets all use tokens properly. The S2S Hero Block is near-perfect. The dashboard is genuinely good.

The toy-feel comes from **the gap between the designed core and the undesigned periphery**. The user doesn't separate "dashboard" from "settings." They experience the app as one thing. And that one thing has a split personality: calm teal cockpit on the home screen, bright blue buttons and generic Material Icons everywhere else.

**The toy-feel is not a design problem. It is a migration problem.**

---

## Top 10 Toy-Feel Root Causes

### 1. AppButton Pumps Bright Blue (#2453FF) Into 13 Screens

**What:** `button_multiple_types.dart:39` uses `AppColors.primary` which is `#2453FF` -- a saturated bright blue that looks like a default Flutter template color. This button is used in 13 files: all onboarding pages, income screens, transaction screen, settings, and more.

**Why it feels toy:** Every fintech app that is NOT a toy uses muted, brand-specific button colors. Bright blue buttons are the universal signal for "developer didn't design this." When a user sees a calm teal header and then a bright blue button, the cognitive dissonance says "prototype."

**Blast radius:** 13 files, every user-facing action button.

**Fix:** Single file change. Rewrite `button_multiple_types.dart` to use `PocketaColors.interactive` (#255E5B).

**Acceptance criteria:** Zero `AppColors` references in `button_multiple_types.dart`. All buttons render deep teal in both light and dark mode.

---

### 2. Material Icons Make the App Look Like a Flutter Starter Template

**What:** 66 instances of `Icons.*` across 16 files. Zero Phosphor icons. The `phosphor_flutter` package is not even in `pubspec.yaml`.

**Why it feels toy:** Material Icons are the DEFAULT icon set for every Flutter project. They are recognizable. When a freelancer sees `Icons.home_rounded` and `Icons.settings_rounded`, their subconscious says "this is every other app I've seen." There is zero visual identity in the icon system. The doctrine specifies Phosphor outline icons (1.5pt stroke) + 6 custom money-state icons, which would create a unique, ledger-like feel.

**Blast radius:** Every screen, every navigation item, every action.

**Fix:** Add `phosphor_flutter` package. Replace all 66 `Icons.*` references with Phosphor equivalents.

**Acceptance criteria:** Zero `Icons.*` in lib/ feature files (Material Icons acceptable only in system widgets like DatePicker).

---

### 3. Splash Screen Is a CircleAvatar With "P"

**What:** `splash_screen.dart:79-90` -- a white CircleAvatar with a bold "P" in teal. This is the first screen every user sees.

**Why it feels toy:** TOY-02 in the attack criteria. This is literally the default avatar pattern from Flutter documentation. No fintech product that takes itself seriously shows a circle with a letter as its logo. It communicates "this is a placeholder that the developer never replaced."

**Blast radius:** First impression. Sets mental model for entire app.

**Fix:** Replace with clean wordmark ("Pocketa" in Inter w600) on canvas background, or a minimal geometric mark. Reduce animation from 1800ms to 300ms.

**Acceptance criteria:** No CircleAvatar on splash. Logo looks intentionally designed. Animation <= 320ms.

---

### 4. Expense Categories Say "Generic Expense Tracker"

**What:** `add_transaction_screen.dart:26-35` -- hardcoded list: Food, Transport, Shopping, Bills, Entertainment, Health, Education, Other.

**Why it feels toy:** TOY-06 BLOCKER. Expense categories are THE defining feature of generic expense trackers (TallyKhata, Hishabee, Mint, YNAB). The Final Product Doctrine explicitly kills categorization. When a user sees "Food" and "Shopping," they immediately classify Pocketa as "another expense tracker" and never discover the S2S value proposition. This is an identity-breaking violation.

**Blast radius:** Entire product positioning.

**Fix:** Remove category system. "Cash out" is just: amount + optional note + date. No categorization.

**Acceptance criteria:** Zero expense category references in codebase. Transaction form has: amount, note (optional), date.

---

### 5. ResponsiveUtilities.font() Bypasses the Token System

**What:** 30+ instances of `ResponsiveUtilities.font(context, XX)` across income_list_screen, add_income_screen, add_transaction_screen, income_pipeline_summary. This utility computes font sizes dynamically based on screen width, completely ignoring PocketaTypography tokens.

**Why it feels toy:** Font sizes become inconsistent across devices. A "13" on one screen becomes a "14" on another. Typography loses its rhythm and hierarchy. The eye subconsciously detects that "something is off" without being able to articulate what. Professional apps have locked type scales. Toy apps have font sizes that drift.

**Blast radius:** 4+ screens, 30+ text elements.

**Fix:** Replace all `ResponsiveUtilities.font()` calls with appropriate PocketaTypography tokens. The token system has 18 predefined styles that cover every use case.

**Acceptance criteria:** Zero `ResponsiveUtilities.font()` calls in feature files.

---

### 6. 69 Hardcoded Font Sizes Create Visual Chaos

**What:** 69 instances of `fontSize:` in feature files (excluding the 18 token definitions). Values include: 11, 12, 13, 14, 15, 16, 18, 20, 22, 24, 32, 36, 52.

**Why it feels toy:** Professional typography uses a locked type scale. Every size has a name and a purpose. When font sizes are hardcoded, the visual hierarchy becomes random. A "16" in settings is the same as a "16" in a card title, but they have different semantic meaning. The eye sees disorder even when sizes technically work.

**Blast radius:** 14 files.

**Fix:** Replace with PocketaTypography tokens. Map: 11->labelSm, 12->labelMd, 13->bodySm, 14->bodyMd, 15->headingSm, 16->bodyLg, 18->headingMd, 22->headingLg, 40->displayLarge, 64->displayHero.

**Acceptance criteria:** < 10 hardcoded fontSize in feature files (exceptions: one-off UI elements with documented rationale).

---

### 7. 1800ms Splash Animation Feels Broken

**What:** `splash_screen.dart:37` -- `Duration(milliseconds: 1800)` for fade-in. Total splash time is 2 seconds before navigation.

**Why it feels toy:** On a Redmi Note 11 (reference device), 2 seconds of splash feels like the app is frozen or loading slowly. Professional fintech apps (bKash, Nagad) show their splash for < 1 second. A confident app loads fast. A toy lingers on its logo because the developer didn't think about perceived performance.

**Blast radius:** Every app launch.

**Fix:** Reduce to 300ms fade + immediate navigation.

**Acceptance criteria:** Splash total visible time <= 500ms. Animation uses PocketaMotion.slow (320ms) max.

---

### 8. Inconsistent Border Radii Break Visual Rhythm

**What:** 98 instances of `BorderRadius.circular()` with values: 1, 2, 4, 7, 8, 10, 12, 14, 16, 20, 24, 100. No visual consistency. Income list uses 16 for cards while doctrine says 12. Buttons use 12 while token says 10.

**Why it feels toy:** Professional apps pick 2-3 radii and use them everywhere. Toy apps have whatever radius the developer typed in the moment. When cards have radius 16, buttons have 12, sheets have 24, and chips have 20, the surfaces don't feel like they belong to the same family.

**Blast radius:** 28 files.

**Fix:** Replace all hardcoded radii with PocketaSpacing tokens: cardRadius (12), buttonRadius (10), sheetTopRadius (16). Delete non-standard values.

**Acceptance criteria:** Zero `BorderRadius.circular(XX)` in feature files where a PocketaSpacing token exists for that value.

---

### 9. Colors.black/Colors.white Break the Warm Palette

**What:** 20 instances of raw `Colors.black` and `Colors.white` across 12 files. Used for icon colors, text colors, dismiss backgrounds, and button foregrounds.

**Why it feels toy:** The Pocketa doctrine uses warm-tinted neutrals: canvas #FAFAF6, ink.primary #141413. Pure black (#000000) and pure white (#FFFFFF) create harsh contrast that makes the warm elements look muddy by comparison. It's like having carefully selected paint colors in a room and then hanging a stark white fluorescent light -- everything else looks wrong.

**Blast radius:** 12 files, scattered throughout.

**Fix:** Replace `Colors.white` with `colors.surface` or `colors.canvas`. Replace `Colors.black` with `colors.inkPrimary`.

**Acceptance criteria:** Zero `Colors.black` or `Colors.white` in feature files.

---

### 10. FontWeight.bold (w700) Exceeds Typography Rules

**What:** 26 instances of `FontWeight.bold` (which is w700) or `FontWeight.w700` in 8 files. PocketaTypography restricts weights to 400-600. The heaviest allowed weight is w600 (semi-bold).

**Why it feels toy:** Bold text (w700) is the typographic equivalent of shouting. Financial apps use semi-bold (w600) for emphasis -- it's confident without being aggressive. When section headers, amounts, and labels are all w700, everything screams and nothing has emphasis. The hierarchy flattens.

**Blast radius:** 8 files, 26 text elements.

**Fix:** Replace all `FontWeight.bold` and `FontWeight.w700` with `FontWeight.w600`.

**Acceptance criteria:** Zero `FontWeight.bold`, `FontWeight.w700`, `FontWeight.w800`, `FontWeight.w900` in feature files.

---

## Most Damaging Components (Ranked)

| Rank | Component | Damage Score | Reason |
|------|-----------|-------------|--------|
| 1 | AppButton | 10/10 | Single component contaminates 13 screens with wrong brand color |
| 2 | Material Icons (global) | 9/10 | 66 instances make entire app look like Flutter template |
| 3 | Splash CircleAvatar | 8/10 | First impression is "student project" |
| 4 | Expense Categories | 8/10 | Kills product identity, makes Pocketa = TallyKhata |
| 5 | ResponsiveUtilities.font() | 7/10 | Bypasses typography system in 4 screens |
| 6 | safe_to_spend_hero.dart (dead code) | 3/10 | Confuses developers, no user impact |
| 7 | linear_progress_bar.dart (legacy) | 3/10 | Uses AppColors but limited exposure |

---

## Design Token Failures

| Token System | Tokens Defined | Correct | Adopted in Features |
|-------------|---------------|---------|-------------------|
| PocketaColors | 13 per mode | 13/13 | ~70% (AppButton and 4 legacy screens still on AppColors) |
| PocketaTypography | 18 styles | 18/18 | ~40% (69 hardcoded fontSize + 30 ResponsiveUtilities.font) |
| PocketaSpacing | 20+ tokens | All correct | ~50% (98 hardcoded BorderRadius, scattered EdgeInsets) |
| PocketaMotion | 6 timing + 2 curves | All correct | ~70% (splash 1800ms, progress_bar 500ms, 3-4 other violations) |

**The design system is 100% correctly defined. The problem is adoption, not design.**

---

## Layout Density Failures

| Check | Expected | Actual | Status |
|-------|----------|--------|--------|
| Dashboard 9-line rule | Max 9 lines above fold | Reality Stack fits within 9 lines | PASS |
| S2S breathing room | 32pt above, 24pt below | PocketaSpacing.s8 (32) above | PASS |
| Card-to-card gap | 12pt minimum | PocketaSpacing.s4 (16) between tiers | PASS |
| Screen edge gutter | 16pt minimum | PocketaSpacing.screenEdge (16) on dashboard | PASS |
| Income list card density | Comfortable reading | 16pt card radius (wrong), tight 16pt padding | FAIL |
| STS settings density | Financial settings need room | 16.0 EdgeInsets with tight section spacing | FAIL |
| Bottom nav height | 56pt | PocketaSpacing.bottomNavHeight = 56 themed | PASS |

---

## Interaction Maturity Failures

| Check | Expected | Actual | Status |
|-------|----------|--------|--------|
| S2S tap -> breakdown drawer | PocketaCalculationTrace | Present, correct | PASS |
| Breakdown stagger animation | 24ms per row, ease-out | PocketaMotion tokens used | PASS |
| Reduce-motion respect | System preference check | S2sHeroBlock checks disableAnimations | PASS |
| Haptic on confirm-received | Single haptic | Not found in code | FAIL |
| Loading states (skeleton) | Skeleton, not shimmer | No skeleton screens found | FAIL |
| Empty states (teaching) | Instructive copy | "Add income to start" -- adequate | PARTIAL |
| Swipe-to-delete with undo | PocketaToast undo | Present on transactions + income | PASS |
| No bounce/spring animations | Ease-out only | No Curves.bounce/elastic found | PASS |
| Tab transitions | Instant | No tab transition animation | PASS |

---

## Quick Wins vs Deep Fixes

### Quick Wins (< 30 minutes each, highest impact)

| # | Fix | Impact | Files |
|---|-----|--------|-------|
| Q1 | Rewrite AppButton to use PocketaColors.interactive | 13 screens fixed | 1 file |
| Q2 | Remove FontStyle.italic from 3 files | Kill 2 BLOCKERs | 3 files |
| Q3 | Delete safe_to_spend_hero.dart | Remove confusion | 1 file |
| Q4 | Replace Colors.black/white with PocketaColors | 12 files cleaner | 12 files |
| Q5 | Replace FontWeight.bold with w600 | 8 files corrected | 8 files |
| Q6 | Remove expense categories from add_transaction | Kill BLOCKER | 1 file |
| Q7 | Reduce splash animation to 300ms | Kill BLOCKER | 1 file |

### Deep Fixes (1-3 hours each)

| # | Fix | Impact | Files |
|---|-----|--------|-------|
| D1 | Add phosphor_flutter + replace 66 Material Icons | Entire app identity shift | 16 files |
| D2 | Replace ResponsiveUtilities.font with PocketaTypography | 4 screens token-compliant | 4 files |
| D3 | Replace 69 hardcoded fontSize with tokens | Typography system fully adopted | 14 files |
| D4 | Replace 80+ hardcoded BorderRadius with tokens | Spacing system fully adopted | 20+ files |
| D5 | Redesign splash screen (wordmark + fast animation) | First impression fixed | 1 file |
| D6 | Add 4th bottom nav tab (History) | Doctrine compliance | 1 file |

---

*End of Toy-Feel Root Cause Report. No code was modified.*
