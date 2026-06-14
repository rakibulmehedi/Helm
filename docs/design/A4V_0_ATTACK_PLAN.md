# A4V-0: Visual Adversarial Attack Plan

> **Sprint:** A4V-0 (Attack Plan Only -- No Implementation)
> **Posture:** Hostile fintech design examiner
> **Verdict prerequisite:** This plan must execute fully before any visual fix is attempted
> **Date:** 2026-06-07
> **Examiner mandate:** Decide whether Helm deserves to be seen by real Bangladeshi freelancers
> **Codebase state:** Post-A4 sprint. Design system ~90% migrated. 13 core widgets built. 12 feature files still on deprecated AppColors/AppButton.

---

## 1. Attack Philosophy

**Core thesis:** Helm has built a strong design system foundation (HelmColors, HelmTypography, HelmSpacing, HelmMotion, 13 core widgets) but the **last-mile adoption gap** means the app still presents inconsistently on a real device. Token definitions are correct; token usage is incomplete. The foundation is professional; the surface layer has cracks.

The app has the right bones. The question is: does it have the right skin?

**Attack posture:**

1. Every screen is guilty until proven mature
2. Every component is assumed to be a toy until it demonstrates financial trust
3. Every pixel that could belong to a generic expense tracker is a failure
4. "It works" is not a defense -- "it feels trustworthy to a stressed freelancer at 11pm" is the only passing grade
5. No credit for intent. Only credit for what ships on a Redmi Note screen

**Three kill questions for every surface:**

1. **The Blur Test:** If you blur the logo and text, could this be any Flutter template from pub.dev? If yes: FAIL.
2. **The 11pm Test:** Would a Bangladeshi freelancer anxious about rent trust this screen with their real money? If uncertain: FAIL.
3. **The Competitor Test:** Does this look more like Mint/YNAB/a crypto app than a calm BDT cashflow ledger? If yes: FAIL.

---

## 2. Screen-by-Screen Attack Route

Every screen listed below will be inspected in A4V-1. Each receives a maturity score.

### 2.1 Splash Screen
- **File:** `lib/features/splash/views/splash_screen.dart`
- **Known issues from recon:**
  - Uses `interactive` color for background (deep teal #255E5B) -- correct token but inspect if this is right for splash
  - White CircleAvatar with "P" letter -- still a placeholder logo
  - 1800ms fade animation -- too long per motion philosophy (max 320ms for transitions)
  - Hardcoded fontSize: 52 and 32 instead of typography tokens
- **Attack vectors:** Logo maturity, animation timing, hardcoded font sizes, first-impression trust

### 2.2 Welcome Screen
- **File:** `lib/features/onboarding/presentation/views/welcome_screen.dart`
- **Status:** Copy rewrite may have occurred in recent sprints -- INSPECT current state
- **Known issues from recon:**
  - Still uses deprecated AppColors/AppButton (confirmed in agent recon)
- **Attack vectors:** Legacy color/button usage, copy identity, logo maturity, value prop

### 2.3 Onboarding (6-Step Conversational Flow)
- **File:** `lib/features/onboarding/presentation/views/onboarding_screen.dart`
- **Sub-pages (6 files):**
  - `pages/qualifying_question_page.dart` -- "You earn in USD. You spend in BDT." + Bangla rephrase after 12s
  - `pages/liquid_balance_page.dart` -- Lakh/crore formatter, taka prefix, monoFinancialLg
  - `pages/fixed_costs_page.dart` -- Add/edit/delete fixed costs
  - `pages/income_pattern_page.dart` -- 3 pattern cards with AnimatedContainer
  - `pages/buffer_comfort_page.dart` -- 4-anchor slider (5/15/25/30%) with live preview
  - `pages/first_pipeline_page.dart` -- Optional client/amount/currency entry
- **Known issues from recon:**
  - Uses correct HelmColors tokens (canvas, interactive, inkPrimary)
  - Has NeverScrollableScrollPhysics (no swipe -- forward-only, correct)
  - Still uses deprecated AppButton in some sub-pages
  - Hardcoded BorderRadius.circular(12) instead of HelmSpacing.cardRadius
  - Progress values defined as [0.0, 0.20, 0.40, 0.55, 0.70, 0.90]
- **Attack vectors:** Legacy AppButton adoption, hardcoded radii, animation timing (300ms easeOutCubic -- should be 200ms ease-out per HelmMotion), copy maturity

### 2.4 Dashboard / Home Screen
- **File:** `lib/features/dashboard/presentation/views/dashboard_screen.dart`
- **Known state from recon (POST A4):**
  - Uses HelmRealityStack (4-tier: hero + pressure + maintenance + hope) -- CORRECT pattern
  - S2sHeroBlock with onTapTrace -> HelmCalculationTrace -- CORRECT interaction
  - CommittedSection + ReserveSection + NotCountedSection -- CORRECT structure
  - FAB with interactive bg, add_rounded icon -- inspect label ("Expected" or generic "+")
  - First-run S2S hint (dismissible, one-time) -- inspect visual
  - Dev reset button gated by kDebugMode -- CORRECT (not visible in production)
  - Analytics: stsViewed, dailyActiveSession, calculationBreakdownOpened -- CORRECT
  - AppBar: "Helm" title (headingMd) -- inspect if this feels right
- **Remaining attack vectors:** Verify Reality Stack renders correctly, inspect spacing compliance, check S2S hero size (should be 64pt monoHero), verify Ledger Rail presence, check Trust Strip

### 2.5 S2S Hero Widget
- **File:** `lib/features/safe_to_spend/presentation/widgets/safe_to_spend_hero.dart`
- **Known issues from recon:**
  - Hardcoded spacing values (20, 4.0, 6.0, 8.0, 12) -- should use HelmSpacing tokens
  - Hardcoded BorderRadius.circular(2) at line 215 -- inconsistent
  - Design system widgets (HelmAmount, HelmLedgerRail) may or may not be used here
- **Attack vectors:** Verify 64pt monoHero usage, spacing token compliance, Ledger Rail integration, Trust Strip presence, "--" fallback for calc failure

### 2.6 Breakdown / Calculation Trace
- **File:** `lib/core/widgets/helm_calculation_trace.dart`
- **Known state from recon:**
  - Draggable bottom sheet with staggered fade animations (24ms per row) -- CORRECT per VISR-022
  - Labels left, values right-aligned -- CORRECT trace pattern
  - HelmAuditCard with 1.5pt divider between rows, final row bold -- CORRECT
- **Attack vectors:** Verify mono right-alignment, verify stagger timing, verify reduce-motion path, verify copy ("Received usable BDT" not "Income Received")

### 2.7 Pipeline Screen
- **File:** `lib/features/income/presentation/views/pipeline_screen.dart`
- **Known state from recon:**
  - 5 sections: Needs decision -> Overdue -> Pending -> Expected -> Received (collapsed)
  - Color-coded section headers with 3pt vertical color bar
  - PipelineEntryCard widgets
  - Extended FAB ("Expected") when < 5 entries
  - Received section collapsible
- **Attack vectors:** Section header compliance, card styling, color token usage, empty state copy, icon system (material vs Phosphor)

### 2.8 Income List Screen
- **File:** `lib/features/income/presentation/views/income_list_screen.dart`
- **Known issues from recon:**
  - Still uses deprecated AppColors/AppButton
  - Hardcoded BorderRadius values (20, 16, 12, 8) -- scattered
  - Status icon box uses statusColor alpha 0.12 -- should use solid tokens
  - Notes rendered in italic (11pt) -- VIOLATES VIS-009 rule 1 (NO italics)
  - Status badge uses pill-shaped bg -- inspect maturity
- **Attack vectors:** Legacy color migration, italic violation, hardcoded radii, icon system

### 2.9 Add Income Screen
- **File:** `lib/features/income/presentation/views/add_income_screen.dart`
- **Known issues from recon:**
  - Still uses deprecated AppColors/AppButton
  - Hardcoded BorderRadius.circular(12) (6+ instances) -- should use HelmSpacing.cardRadius
  - Has FX rate field (conditional on USD) -- CORRECT
  - Has exclude-from-S2S checkbox -- CORRECT
  - Has source label field -- CORRECT
  - Currency toggle (BDT/USD) with AnimatedContainer (200ms) -- CORRECT timing
  - Status toggle with color-coded backgrounds -- inspect colors
- **Attack vectors:** Legacy color migration, hardcoded radii, form field styling, status color compliance

### 2.10 Add Transaction Screen
- **File:** `lib/features/transactions/presentation/views/add_transaction_screen.dart`
- **Known issues from recon:**
  - Still uses deprecated AppColors/AppButton
  - Hardcoded BorderRadius values (10, 12) -- inconsistent
  - 8 hardcoded expense categories (Food, Transport, Shopping, etc.)
  - Category system is a doctrine concern (Helm doesn't categorize per kill list) but transaction expenses may be acceptable as simple labeling
- **Attack vectors:** Legacy color migration, hardcoded radii, category labeling review, form styling

### 2.11 STS Settings Screen
- **File:** `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart`
- **Known issues from recon:**
  - Still uses deprecated AppColors/AppButton
  - Hardcoded fontSize: 16 and 13 -- should use typography tokens
  - Hardcoded EdgeInsets.all(16.0) -- should use HelmSpacing.s4
  - Hardcoded fontWeight: FontWeight.bold / w600 at multiple lines
  - Bottom nav items: Export, Change history, Delete account -- CORRECT
  - Buffer now percentage-based slider (5-30%) -- CORRECT
- **Attack vectors:** Heaviest legacy debt of any screen -- most hardcoded values

### 2.12 PIN Entry / PIN Setup Screens
- **Files:** `lib/features/auth/presentation/views/pin_entry_screen.dart`, `pin_setup_screen.dart`
- **Known state from recon:**
  - PIN Setup: 4-dot indicators (interactive filled / interactive border), 72x72 numpad buttons, hairline borders
  - PIN Entry: Lockout after 5 attempts, attempt tracking, stateAtRisk for lockout message
  - Uses canvas bg, interactive for buttons and dots -- CORRECT tokens
  - Hardcoded fontSize: 22, 14, 24 -- should use typography tokens
  - Hardcoded EdgeInsets.symmetric(horizontal: 10/40) -- should use spacing tokens
  - Analytics: pinGateOpened, pinAuthSuccess, pinAuthFailed -- CORRECT
- **Attack vectors:** Hardcoded font sizes, hardcoded spacing, numpad button visual polish

### 2.13 Delete Account Screen
- **File:** `lib/features/account/presentation/views/delete_account_screen.dart`
- **Known state from recon:**
  - Warning card: stateAtRisk bg (alpha 0.08) + border (alpha 0.35), 12pt radius -- inspect compliance
  - PIN confirmation dialog or type "DELETE" dialog -- CORRECT dual path
  - Bulleted list with remove_circle_outline icons -- material icons, not Phosphor
  - 52pt button height -- should be 48pt per VIS-019
- **Attack vectors:** Button height, icon system, hardcoded values

### 2.14 Audit Log Screen
- **File:** `lib/features/audit_log/presentation/views/audit_log_screen.dart`
- **Known issues from recon:**
  - Hardcoded fontSize: 12 -- should use typography.labelMd
  - Uses material icons (add_circle_outline, edit_outlined, etc.) -- not Phosphor
  - Event-type color coding uses correct state tokens (stateSafe, interactive, stateAtRisk, stateTight)
- **Attack vectors:** Hardcoded font size, icon system, list item density

### 2.15 Export Screen
- **File:** `lib/features/export/presentation/views/export_screen.dart`
- **Known issues from recon:**
  - Hardcoded fontSize values at lines 57, 67, 75, 133
  - Hardcoded padding values (16, 4)
  - Uses ElevatedButton directly instead of AppButton -- inconsistent
  - Uses check_circle_outline (material) for export items
- **Attack vectors:** Hardcoded values, button consistency, icon system

---

## 3. Component-by-Component Attack Route

### 3.1 Color System
- **Token file:** `lib/core/themes/helm_colors.dart` -- BUILT, 13 tokens per mode, ThemeExtension
- **Legacy file:** `lib/core/themes/colors.dart` -- DEPRECATED, still exists, re-exports HelmColors
- **Current state:** Token definitions are CORRECT (canvas #FAFAF6, interactive #255E5B, all state colors match VISR-006/007)
- **Gap:** 12 feature files still reference deprecated AppColors
- **Attack:** Grep for AppColors usage. Every remaining reference is a migration failure. Check withOpacity() on text colors.

### 3.2 Typography System
- **File:** `lib/core/themes/helm_typography.dart` -- BUILT, 18 styles, ThemeExtension
- **Current:** Inter (Latin) + JetBrains Mono (financial) + Hind Siliguri (Bangla) -- ALL CORRECT
- **Type scale:** 64pt monoHero, 40pt displayLarge, 22pt headingLg, etc. -- matches VIS-008
- **Bangla line heights:** 1.58 for bodyLg/Md, 1.52 for bodySm, 1.38 for labelMd -- CORRECT
- **Gap:** 40+ hardcoded fontSize values in feature files
- **Attack:** Grep all `fontSize:` in feature code. Every hardcoded value is debt. Check for italic usage. Check for fontWeight outside 400-600.

### 3.3 Theme Architecture
- **File:** `lib/core/themes/app_theme.dart` -- BUILT with ThemeExtension integration
- **Current:** Custom ThemeData with HelmColors + HelmTypography extensions. NO ColorScheme.fromSeed. Correct.
- **ColorScheme mapping:** primary=interactive, error=stateAtRisk, surface=surface, onSurface=inkPrimary
- **Component styling:** Card elevation 0, 12pt radius, 1pt divider border -- CORRECT
- **ElevatedButton:** elevation 0, interactive bg, 10pt radius, 14pt vertical padding -- MOSTLY correct
- **Attack:** Verify no elevation > 0 anywhere. Verify card borders use divider token. Verify button specs match VIS-019.

### 3.4 Button System
- **File:** `lib/core/widgets/buttons/button_multiple_types.dart`
- **Current:** Still uses LEGACY AppColors (confirmed by agents) -- this is a known high-blast-radius file
- **Required:** Should use HelmColors tokens. 4 types (primary/secondary/tertiary/destructive), 10pt radius, 48pt height
- **Attack:** This file is the #1 migration target. Verify all screens that consume AppButton.

### 3.5 Card System
- **Current:** 5 doctrine-correct card widgets EXIST (HelmHeroZone, HelmLedgerCard, HelmAuditCard, HelmCautionCard, HelmSourceCard)
- **Implementation:** 12pt radius, 1pt divider border, NO shadow, NO elevation -- CORRECT
- **Gap:** Some feature screens may still use raw Card or Container instead of Helm card widgets
- **Attack:** Grep for raw `Card(` and raw `Container(` with BoxShadow in feature files.

### 3.6 Icon System
- **Current:** Material Icons used throughout (confirmed in Income List, Add Transaction, Audit Log, Delete Account, Pipeline, etc.)
- **Required:** Phosphor Icons (outline only, 1.5pt stroke) + 6 custom money-state icons (VIS-022, VISR-021)
- **Gap:** NO phosphor_flutter package appears to be in use. This is a MAJOR remaining gap.
- **Attack:** Grep for `Icons.` usage across all files. Count material icon references. Check pubspec for phosphor_flutter.

### 3.7 Spacing System
- **Token file:** `lib/core/themes/helm_spacing.dart` -- BUILT, full 8pt grid + component dimensions
- **Current:** Tokens defined correctly (s1=4, s2=8, s3=12, s4=16... cardRadius=12, buttonRadius=10, screenEdge=16)
- **Gap:** Feature files use hardcoded EdgeInsets (10, 20, 40, 4.0, 6.0, 8.0) instead of HelmSpacing references
- **Attack:** Grep all `EdgeInsets` and `SizedBox(` with hardcoded values. Flag non-token usage.

### 3.8 Motion System
- **Token file:** `lib/core/themes/helm_motion.dart` -- BUILT, 6 timing tokens + curves
- **Current:** instant/fast/base/medium/slow/s2sAppear defined. Ease-out only. drawerRowStagger=24ms. CORRECT.
- **Gap:** Splash still uses 1800ms fade. Onboarding pages use 300ms easeOutCubic instead of 200ms ease-out.
- **Attack:** Grep for Duration values in feature files. Flag any > 320ms or non-ease-out curves. Flag Curves.bounceIn/Out/elasticIn/Out.

---

## 4. Toy-Feel Detection Criteria

A screen or component exhibits "toy feel" when it matches ANY of these patterns:

| ID | Signal | Severity |
|----|--------|----------|
| TOY-01 | Bright saturated primary color (blue, purple, hot orange) | BLOCKER |
| TOY-02 | CircleAvatar with letter as logo | BLOCKER |
| TOY-03 | "Track expenses" / "Set budget" / "Financial freedom" copy | BLOCKER |
| TOY-04 | Poppins or other rounded-friendly font for financial data | BLOCKER |
| TOY-05 | Green income / Red expense color coding | MAJOR |
| TOY-06 | Expense categories (Food, Shopping, Entertainment) | BLOCKER |
| TOY-07 | Card shadows / elevation > 0 | MAJOR |
| TOY-08 | Dot carousel indicators | MAJOR |
| TOY-09 | Filled material icons | MAJOR |
| TOY-10 | "Get Started" / "Let's go" / "Welcome!" copy | MAJOR |
| TOY-11 | Border radius > 14pt on cards | MINOR |
| TOY-12 | Full-width buttons on every screen | MINOR |
| TOY-13 | Progress bar with percentage | MINOR |
| TOY-14 | Generic filter chips (All, Recent) | MINOR |
| TOY-15 | Dev/debug controls visible in production | BLOCKER |

---

## 5. Fintech Maturity Criteria

A screen passes fintech maturity when ALL of these are true:

| ID | Criterion | Weight |
|----|-----------|--------|
| FIN-01 | Financial numbers in monospace font | Required |
| FIN-02 | Lakh/crore BDT formatting (1,32,400) | Required |
| FIN-03 | Two decimal places always shown (.00) | Required |
| FIN-04 | Currency symbol visible on every monetary value | Required |
| FIN-05 | Warm-tinted neutrals (not pure white/black) | Required |
| FIN-06 | Deep teal interactive color (not bright blue) | Required |
| FIN-07 | State colors are desaturated, not material-bright | Required |
| FIN-08 | Cards use borders, not shadows | Required |
| FIN-09 | Touch targets >= 44pt | Required |
| FIN-10 | No gradients anywhere | Required |
| FIN-11 | No celebration/reward animations | Required |
| FIN-12 | Outline icons only | Required |
| FIN-13 | No italics | Required |
| FIN-14 | No ALL-CAPS (except tab bar) | Recommended |
| FIN-15 | 8pt grid spacing | Recommended |
| FIN-16 | Calculation breakdown accessible from financial numbers | Required |
| FIN-17 | Timestamp/source visible near key numbers | Required |
| FIN-18 | Error state shows "--" not wrong number | Required |

---

## 6. Trust-Damage Criteria

These patterns actively damage user trust in a financial context:

| ID | Pattern | Damage Level |
|----|---------|-------------|
| TRD-01 | Wrong number displayed (stale, calc error shown as value) | CRITICAL |
| TRD-02 | Generic "Something went wrong" error | HIGH |
| TRD-03 | Mixing liquid BDT with pending USD in same visual weight | HIGH |
| TRD-04 | No calculation transparency (user cannot verify math) | HIGH |
| TRD-05 | No timestamp on financial figures | HIGH |
| TRD-06 | Celebration animations on financial events | MEDIUM |
| TRD-07 | Gamification elements (streaks, scores, badges) | HIGH |
| TRD-08 | "AI-powered" or "smart" labeling | MEDIUM |
| TRD-09 | Vague reassurance copy ("Everything looks fine") | MEDIUM |
| TRD-10 | Missing currency symbol on amounts | MEDIUM |
| TRD-11 | Proportional-width font on financial figures | MEDIUM |
| TRD-12 | Bright red as alarm color outside At-Risk state | MEDIUM |

---

## 7. Typography Attack Criteria

### Font Family Audit
| Check | Expected | Token Defined (HelmTypography) | Verdict |
|-------|----------|-----------------------------------|---------|
| Financial numerals font | JetBrains Mono Variable | JetBrains Mono (monoFinancial*) | CORRECT |
| UI text font (Latin) | Inter Variable | Inter (headingLg, bodyLg, etc.) | CORRECT |
| Bangla text font | Hind Siliguri | Hind Siliguri (bodyLgBn, etc.) | CORRECT |
| Font loading | Bundled assets | INSPECT (check pubspec for asset fonts vs Google Fonts runtime) | INSPECT |

### Type Scale Audit
| Check | Expected | Token Defined | Feature Adoption | Verdict |
|-------|----------|---------------|------------------|---------|
| S2S hero size | 64pt | monoHero = 64pt, w600 | INSPECT if actually used in hero widget | INSPECT |
| S2S hero weight | 600 | w600 defined | INSPECT | |
| S2S hero font | JetBrains Mono | monoHero uses JetBrains Mono | INSPECT actual widget | |
| Body text size | 16pt | bodyLg = 16pt, w400 | ~60% adopted | PARTIAL |
| Label size | 12pt | labelMd = 12pt, w500 | Hardcoded in some files | PARTIAL |
| Min font size | 11pt | labelSm = 11pt (smallest) | INSPECT for < 11pt | |

### Typographic Rules Audit
| Rule | Status |
|------|--------|
| No italics anywhere | VIOLATION FOUND -- income_list_screen notes rendered italic |
| No ALL-CAPS | INSPECT |
| No weight < 400 | INSPECT (HelmTypography restricts to 400-600, but hardcoded FontWeight.w300 possible) |
| No weight > 600 | INSPECT (FontWeight.bold = 700, found in hardcoded feature code) |
| No letter-spacing overrides | INSPECT |
| Bangla baseline alignment | Bangla line heights defined (1.58/1.52/1.38) -- INSPECT runtime rendering |

---

## 8. Spacing/Density Attack Criteria

### Grid Compliance
- **Expected:** Every spacing value is a multiple of 4pt, biased to 8pt
- **Current:** Hardcoded `EdgeInsets` values throughout -- many likely off-grid
- **Attack method:** Grep all `EdgeInsets`, `SizedBox(height:`, `SizedBox(width:`, `padding:`, `margin:` values and flag non-multiples-of-4

### Density Checks
| Check | Expected | Status |
|-------|----------|--------|
| Home screen 9-line rule | Max 9 lines above fold | INSPECT (likely violated by Income/Expense chips + transaction list) |
| S2S breathing room | 32pt above, 24pt below | INSPECT |
| Card-to-card gap | 12pt minimum | INSPECT |
| Screen edge gutter | 16pt minimum | INSPECT |
| Bottom nav height | 56pt | INSPECT (no bottom nav exists -- uses AppBar) |

### Missing Layout Elements
| Element | Status |
|---------|--------|
| Bottom navigation bar (4 items: Home, Pipeline, History, Settings) | MISSING -- uses AppBar navigation |
| Safe area respect | INSPECT |
| Vertical rhythm budget (~616pt) | INSPECT |

---

## 9. Color/Surface/Radius Attack Criteria

### Color Token Audit (HelmColors vs Doctrine)
| Token | Expected (VISR-006 refined) | Current (HelmColors) | Status |
|-------|-----------------------------|-------------------------|--------|
| canvas.light | #FAFAF6 | #FAFAF6 | CORRECT |
| surface.light | #FFFFFC | #FFFFFC | CORRECT |
| ink.primary | #141413 | #141413 | CORRECT |
| ink.secondary | #3B3A36 (solid) | #3B3A36 | CORRECT |
| ink.tertiary | #6A6760 | #6A6760 | CORRECT |
| interactive | #255E5B (deep teal) | #255E5B | CORRECT |
| divider | #D8D3C8 | #D8D3C8 | CORRECT |
| hairline | #E9E5DB | #E9E5DB | CORRECT |
| state.safe | #5F8569 | #5F8569 | CORRECT |
| state.tight | #A97833 | #A97833 | CORRECT |
| state.atRisk | #984635 | #984635 | CORRECT |
| state.hope | #5A7585 | #5A7585 | CORRECT |
| state.hopeMuted | #9BAAB2 | #9BAAB2 | CORRECT |

**Summary:** 13 out of 13 core color tokens match doctrine PERFECTLY. Token definitions are correct.

**Gap:** The issue is ADOPTION -- 12 feature files still reference deprecated AppColors which still has:
- Primary: #2453FF (bright blue -- wrong)
- Secondary: #F57C00 (hot orange -- banned)
- Success: #10B981 (neon green -- too saturated)
- Warning: #F59E0B (hot amber -- too bright)
- Error: #EF4444 (material red -- not muted brick)

### Legacy Color References to Kill
| Pattern | Status |
|---------|--------|
| AppColors.primary (#2453FF) | PRESENT in button_multiple_types.dart |
| AppColors.success (#10B981) | PRESENT in legacy income list items |
| AppColors.error (#EF4444) | INSPECT remaining usage |
| withOpacity() on text | INSPECT |
| Raw Colors.black / Colors.white | INSPECT |

### Border Radius Audit
| Component | Expected | Token Defined | Feature Files | Status |
|-----------|----------|---------------|---------------|--------|
| Cards | 12pt | HelmSpacing.cardRadius = 12 | Hardcoded 12 in ~10 places | TOKEN EXISTS but not always referenced |
| Primary buttons | 10pt | HelmSpacing.buttonRadius = 10 | AppButton uses 12px | MAJOR -- button still wrong |
| Sheets | 16pt top | HelmSpacing.sheetTopRadius = 16 | INSPECT | |
| FAB | Full circle | HelmSpacing.fabSize = 56 | INSPECT | |
| Income list | 12pt | -- | 20, 16, 12, 8 (scattered) | MAJOR -- inconsistent |

### Shadow/Elevation Audit
| Rule | Status |
|------|--------|
| Card elevation 0 | CORRECT in app_theme.dart (line 62) |
| No BoxShadow on core cards | CORRECT (5 card widgets have no shadow) |
| No elevation on ElevatedButton | CORRECT in app_theme.dart |
| Legacy feature code | INSPECT for remaining BoxShadow or elevation usage |

---

## 10. Interaction Maturity Criteria

| Check | Expected | Status |
|-------|----------|--------|
| S2S tap -> breakdown drawer | Present but wrong visual treatment | INSPECT details |
| One-tap confirm (Pending -> Received) | Unknown | INSPECT |
| Swipe-to-delete with undo | Present on transactions | OK concept, INSPECT visual |
| Loading states (skeleton, not shimmer) | Unknown | INSPECT |
| Error states (specific, not generic) | Unknown | INSPECT |
| Empty states (teaching, not announcing) | INSPECT | |
| Reduce-motion respect | Unknown | INSPECT |
| Haptic on confirm-received only | Unknown | INSPECT |
| No bounce/spring animations | Unknown | INSPECT |
| Breakdown drawer 240ms ease-out | Unknown | INSPECT |
| Tab transitions instant | No tabs exist (no bottom nav) | BLOCKER -- missing nav |

---

## 11. Screenshot Evidence Protocol

### If Device Screenshots Exist
1. Capture or locate screenshots for every screen listed in Section 2
2. Each screenshot is evaluated against all criteria in Sections 4-10
3. Screenshots annotated with findings using file:line references

### If No Screenshots Available (Current State)
1. All evaluation performed via code inspection
2. Widget tree analysis substitutes for visual inspection
3. Color hex values compared directly against doctrine values
4. Font sizes, weights, and families compared against type scale
5. Spacing values compared against grid system
6. Findings reference exact file:line locations

### Screenshot Capture Recommendation for A4V-1
Before A4V-1 implementation begins, the Chief Architect should capture device screenshots of:
- Splash screen
- Welcome screen
- Each onboarding page
- Dashboard (empty state)
- Dashboard (with data)
- S2S breakdown sheet
- Income pipeline (empty + populated)
- Add income form
- Add transaction form
- STS settings
- PIN entry / PIN setup

---

## 12. Scoring Method

### Per-Screen Score (0-100)

| Category | Weight | Max Points |
|----------|--------|------------|
| Color system compliance | 20% | 20 |
| Typography compliance | 20% | 20 |
| Spacing/density compliance | 15% | 15 |
| Component compliance (cards, buttons, icons) | 15% | 15 |
| Identity/copy compliance | 15% | 15 |
| Interaction maturity | 10% | 10 |
| Trust element presence | 5% | 5 |

### Deduction Rules
- Each BLOCKER finding: -20 points (capped at score floor of 0)
- Each MAJOR finding: -10 points
- Each MINOR finding: -3 points

### Overall App Score
- Average of all screen scores
- Any screen scoring below 20 = app-level BLOCKER
- Overall score below 40 = "not ready for real users"

### Predicted Current Score (Pre-Inspection Estimate)
Based on corrected recon data (post-A4 sprint, design system ~90% migrated):

| Screen | Score | Rationale |
|--------|-------|-----------|
| Splash | ~40/100 | Correct color token but placeholder logo, 1800ms violation, hardcoded sizes |
| Welcome | ~45/100 | Likely rewritten but still uses AppColors/AppButton legacy |
| Onboarding (6 steps) | ~65/100 | Correct flow, correct tokens in most pages, AppButton legacy, hardcoded radii |
| Dashboard | ~70/100 | Reality Stack + HelmCalculationTrace + correct FAB. Inspect polish. |
| S2S Hero | ~55/100 | Hardcoded spacing values, may use correct monoHero but inspect |
| Calculation Trace | ~80/100 | Purpose-built widget, stagger animation, audit card -- near-doctrine |
| Pipeline Screen | ~60/100 | Correct sections/colors, material icons (not Phosphor) |
| Income List | ~40/100 | Legacy AppColors, italic notes (violation), hardcoded radii |
| Add Income | ~50/100 | Correct fields (FX, exclude, source), legacy styling debt |
| Add Transaction | ~35/100 | Legacy colors, hardcoded radii, expense categories question |
| STS Settings | ~35/100 | Heaviest legacy debt -- most hardcoded values of any screen |
| PIN Screens | ~55/100 | Correct tokens (canvas, interactive), hardcoded font/spacing |
| Delete Account | ~50/100 | Correct structure, material icons, 52pt button (should be 48) |
| Audit Log | ~45/100 | Correct colors, hardcoded fontSize, material icons |
| Export | ~40/100 | Hardcoded everything, uses raw ElevatedButton |

**Estimated overall: ~50/100 -- FOUNDATION STRONG, SURFACE INCONSISTENT**

**Key gaps preventing beta readiness:**
1. 12 files still on deprecated AppColors/AppButton (~15% of surface area)
2. Material Icons throughout (should be Phosphor -- systemic gap)
3. 40+ hardcoded font sizes (should use HelmTypography tokens)
4. Scattered hardcoded spacing/radii (should use HelmSpacing tokens)
5. Splash 1800ms animation (motion violation)
6. Italic text in income list notes (typography violation)
7. Button radius 12px in AppButton (should be 10pt per buttonRadius token)

---

## 13. Severity Classification

### BLOCKER (Must fix before any beta user sees the app)

A finding is BLOCKER when it:
1. Directly contradicts product identity ("pocket accountant", "track expenses", expense categories)
2. Uses a completely wrong visual language (bright blue instead of deep teal, Poppins instead of Inter/JetBrains Mono)
3. Makes the app indistinguishable from a generic expense tracker template
4. Causes a stressed freelancer to distrust the financial data
5. Violates a "permanently killed" pattern from VIS-039 or UX-082

### MAJOR (Must fix before closed beta launch)

A finding is MAJOR when it:
1. Uses wrong values for a correct concept (36pt instead of 64pt, 14px radius instead of 12pt)
2. Missing a required trust element (no Ledger Rail, no Trust Strip)
3. Uses material-default colors instead of doctrine colors
4. Has card shadows or elevation
5. Uses filled icons instead of outline
6. Missing bottom navigation

### MINOR (Should fix, can ship closed beta with acknowledgment)

A finding is MINOR when it:
1. Slightly off-spec values (12px radius instead of 10pt on buttons)
2. Missing locale-specific adjustments (Bangla line heights)
3. Missing accessibility labels
4. Non-critical spacing violations
5. Missing reduce-motion support

---

## 14. Pre-Implementation Inspection Checklist

Before ANY visual implementation work begins, A4V-1 must verify these items by reading actual code:

### Design System Foundation
- [ ] Read `lib/core/themes/colors.dart` -- audit every hex value
- [ ] Read `lib/core/themes/app_theme.dart` -- audit ThemeData structure
- [ ] Search for `HelmColors` -- confirm ThemeExtension existence or absence
- [ ] Search for `HelmTypography` -- confirm ThemeExtension existence or absence
- [ ] Search for `HelmSpacing` -- confirm ThemeExtension existence or absence
- [ ] Search for `HelmMotion` -- confirm ThemeExtension existence or absence
- [ ] Grep `BoxShadow` -- count shadow violations
- [ ] Grep `elevation` -- count elevation violations
- [ ] Grep `withOpacity` -- count opacity violations on text
- [ ] Grep `LinearGradient|RadialGradient` -- count gradient violations
- [ ] Grep `FontStyle.italic` -- count italic violations
- [ ] Grep `FontWeight.bold|FontWeight.w700|FontWeight.w800|FontWeight.w900` -- count weight violations
- [ ] Grep `Colors.black|Colors.white` -- count raw black/white violations
- [ ] Grep hardcoded hex colors (0xFF pattern not in colors.dart)

### Screen-Level Inspection
- [ ] Read every *_screen.dart file listed in Section 2
- [ ] For each screen: document font sizes, colors, spacing, radius, shadows
- [ ] For each screen: evaluate against Toy-Feel (Section 4) and Fintech Maturity (Section 5)
- [ ] For each screen: check for Trust-Damage patterns (Section 6)

### Component Inspection
- [ ] Read AppButton -- audit against VIS-018/019/020/021
- [ ] Read all card-containing widgets -- audit against VIS-016/017
- [ ] Identify all Icon usage -- audit against VIS-022/023/024
- [ ] Identify all number formatting -- audit against UX-049/050

### Identity/Copy Inspection
- [ ] Grep all user-facing strings for banned phrases (UX-038)
- [ ] Grep for "expense", "budget", "track" -- flag identity violations
- [ ] Grep for "!", emoji characters -- flag tone violations
- [ ] Check localization coverage -- hardcoded vs ARB strings

---

## 15. Next Command: A4V-1

### Command
```
Run A4V-1 -- Visual Adversarial Inspection.

Execute the full attack plan from A4V_0_ATTACK_PLAN.md.
Inspect every screen, every component, every color, every font, every spacing value.
Score each screen using the scoring method in Section 12.
Classify every finding as BLOCKER / MAJOR / MINOR using Section 13 criteria.
Complete the pre-implementation inspection checklist from Section 14.

Output: docs/design/A4V_1_INSPECTION_REPORT.md

The report must include:
1. Per-screen inspection results with file:line references
2. Per-screen maturity scores
3. Complete BLOCKER/MAJOR/MINOR finding inventory
4. Design system gap analysis (current vs required)
5. Prioritized fix order (BLOCKERs first)
6. Overall app maturity verdict
7. Recommended A4V-2 implementation scope
```

### Suggested Commit Message
```
docs(design): A4V-0 Visual Adversarial Attack Plan -- hostile fintech design audit methodology

- 15-section attack plan for visual maturity assessment
- Screen-by-screen and component-by-component attack routes
- Toy-feel detection criteria (15 signals)
- Fintech maturity criteria (18 requirements)
- Trust-damage criteria (12 patterns)
- Scoring model with severity classification
- Pre-implementation inspection checklist
- Estimated current score: ~18/100 (not ready for real users)
- Next: A4V-1 full inspection execution
```

---

## Appendix A: Files to Inspect in A4V-1

### Screens (15 files)
| Screen | File |
|--------|------|
| Splash | `lib/features/splash/views/splash_screen.dart` |
| Welcome | `lib/features/onboarding/presentation/views/welcome_screen.dart` |
| Onboarding (controller) | `lib/features/onboarding/presentation/views/onboarding_screen.dart` |
| Onboarding: Qualifying | `lib/features/onboarding/presentation/views/pages/qualifying_question_page.dart` |
| Onboarding: Balance | `lib/features/onboarding/presentation/views/pages/liquid_balance_page.dart` |
| Onboarding: Fixed Costs | `lib/features/onboarding/presentation/views/pages/fixed_costs_page.dart` |
| Onboarding: Income Pattern | `lib/features/onboarding/presentation/views/pages/income_pattern_page.dart` |
| Onboarding: Buffer | `lib/features/onboarding/presentation/views/pages/buffer_comfort_page.dart` |
| Onboarding: First Pipeline | `lib/features/onboarding/presentation/views/pages/first_pipeline_page.dart` |
| Dashboard | `lib/features/dashboard/presentation/views/dashboard_screen.dart` |
| Pipeline | `lib/features/income/presentation/views/pipeline_screen.dart` |
| S2S Hero | `lib/features/safe_to_spend/presentation/widgets/safe_to_spend_hero.dart` |
| Income List | `lib/features/income/presentation/views/income_list_screen.dart` |
| Add Income | `lib/features/income/presentation/views/add_income_screen.dart` |
| Add Transaction | `lib/features/transactions/presentation/views/add_transaction_screen.dart` |
| STS Settings | `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart` |
| PIN Entry | `lib/features/auth/presentation/views/pin_entry_screen.dart` |
| PIN Setup | `lib/features/auth/presentation/views/pin_setup_screen.dart` |
| Delete Account | `lib/features/account/presentation/views/delete_account_screen.dart` |
| Audit Log | `lib/features/audit_log/presentation/views/audit_log_screen.dart` |
| Export | `lib/features/export/presentation/views/export_screen.dart` |

### Design System (6 token files + 2 legacy)
| Component | File | Status |
|-----------|------|--------|
| Colors (active) | `lib/core/themes/helm_colors.dart` | CORRECT |
| Typography (active) | `lib/core/themes/helm_typography.dart` | CORRECT |
| Spacing (active) | `lib/core/themes/helm_spacing.dart` | CORRECT |
| Motion (active) | `lib/core/themes/helm_motion.dart` | CORRECT |
| Theme builder | `lib/core/themes/app_theme.dart` | CORRECT |
| Colors (deprecated) | `lib/core/themes/colors.dart` | KILL TARGET |
| Button (legacy) | `lib/core/widgets/buttons/button_multiple_types.dart` | MIGRATION TARGET |
| Progress bar (legacy) | `lib/core/widgets/progress_bar/linear_progress_bar.dart` | MIGRATION TARGET |

### Core Widget Library (13 files)
| Widget | File |
|--------|------|
| HelmHeroZone | `lib/core/widgets/cards/helm_hero_zone.dart` |
| HelmLedgerCard | `lib/core/widgets/cards/helm_ledger_card.dart` |
| HelmAuditCard | `lib/core/widgets/cards/helm_audit_card.dart` |
| HelmCautionCard | `lib/core/widgets/cards/helm_caution_card.dart` |
| HelmSourceCard | `lib/core/widgets/cards/helm_source_card.dart` |
| HelmAmount | `lib/core/widgets/helm_amount.dart` |
| HelmTrustStrip | `lib/core/widgets/helm_trust_strip.dart` |
| HelmFxEstimate | `lib/core/widgets/helm_fx_estimate.dart` |
| HelmLedgerRail | `lib/core/widgets/helm_ledger_rail.dart` |
| HelmRealityStack | `lib/core/widgets/helm_reality_stack.dart` |
| HelmCalculationTrace | `lib/core/widgets/helm_calculation_trace.dart` |
| HelmMoneySourceLabel | `lib/core/widgets/helm_money_source_label.dart` |
| HelmToast | `lib/core/widgets/helm_toast.dart` |

### Doctrine References (3 files)
| Doc | File |
|-----|------|
| Visual Identity Requirements | `docs/ux/extracted/07_visual_identity_requirements.md` |
| Visual Identity Refinements | `docs/ux/extracted/08_visual_identity_refinements.md` |
| UX Canon | `docs/ux/HELM_CANONICAL_UX_IMPLEMENTATION_SPEC.md` |

---

## Appendix B: Doctrine Color Reference (Quick Lookup)

### Light Mode (VISR-006 Refined -- Final Authority)
| Token | Hex | Usage |
|-------|-----|-------|
| canvas | #FAFAF6 | App background |
| surface | #FFFFFF or #FFFFFC | Card surfaces |
| ink.primary | #141413 | All critical text, S2S number |
| ink.secondary | #3B3A36 | Labels, timestamps |
| ink.tertiary | #6A6760 | Disabled, recessed |
| interactive | #255E5B | Every tappable affordance |
| divider | #D8D3C8 | Card borders |
| hairline | #E9E5DB | Internal dividers |
| state.safe | #5F8569 | Safe state |
| state.tight | #A97833 | Tight state |
| state.atRisk | #984635 | At Risk state |
| state.hope | #5A7585 | Hope text |
| state.hopeMuted | #9BAAB2 | Hope dots/rails |

### Dark Mode (VIS-003)
| Token | Hex |
|-------|-----|
| canvas | #0E0E0C |
| surface | #161614 |
| ink.primary | #F2F1ED |
| interactive | #3E807D |

---

*End of A4V-0 Attack Plan. No code was modified. No features were suggested. Only the attack methodology has been defined.*
