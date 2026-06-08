# A4V-2: Visual Rescue Tasks

> **Sprint:** A4V-2
> **Date:** 2026-06-08
> **Purpose:** Complete task inventory for visual maturity migration
> **Format:** Each task includes: id, priority, source issue, affected files, expected visual change, non-goals, risk, verification method, acceptance criteria

---

## Phase 1: Kill BLOCKERs

---

### VR-001: Rewrite AppButton to PocketaColors

| Field | Value |
|-------|-------|
| **Task ID** | VR-001 |
| **Priority** | P0-BLOCKER |
| **Phase** | 1 |
| **Source Issue** | A4V-1 B1, TOY-01 |
| **Affected Files** | `lib/core/widgets/buttons/button_multiple_types.dart` |
| **Expected Visual Change** | All 13 screens using AppButton change from bright blue (#2453FF) to deep teal (#255E5B). Button radius changes from 12 to 10 (PocketaSpacing.buttonRadius). Disabled state uses PocketaColors.interactive.withValues(alpha: 0.4). Foreground uses PocketaColors surface token instead of Colors.white. |
| **Non-Goals** | Do not change AppButton interface (label, onPressed, type enum). Do not rename the widget. Do not refactor callers. |
| **Risk** | LOW. Single file, no interface change. All 13 callers get fixed automatically. |
| **Verification** | `grep -rn "AppColors" lib/core/widgets/buttons/` returns 0. `grep -rn "Colors.white\|Colors.grey" lib/core/widgets/buttons/` returns 0. Visual: buttons are teal on all screens. |
| **Acceptance Criteria** | Zero AppColors references in button file. All buttons render #255E5B in light mode, corresponding dark mode token in dark mode. Button radius = 10pt. Disabled state uses alpha 0.4 on interactive color. |

---

### VR-002: Remove Expense Categories

| Field | Value |
|-------|-------|
| **Task ID** | VR-002 |
| **Priority** | P0-BLOCKER |
| **Phase** | 1 |
| **Source Issue** | A4V-1 B2, TOY-06, Final Product Doctrine |
| **Affected Files** | `lib/features/transactions/presentation/views/add_transaction_screen.dart` |
| **Expected Visual Change** | Expense category chips (Food, Transport, Shopping, Bills, Entertainment, Health, Education, Other) removed from transaction form. Form shows: amount field (primary), optional note field, date picker. "Cash out" framing instead of "Add Expense". |
| **Non-Goals** | Do not change transaction data model. Do not remove amount/note/date fields. Do not change how transactions are stored or used in S2S calculation. Category field in data model can remain (just unused) -- do not break persistence. |
| **Risk** | LOW. Removal is simpler than addition. Category data is not used in S2S calculation. Existing transactions with categories are unaffected (field stays in Hive, just not displayed on form). |
| **Verification** | `grep -rn "_defaultCategories\|categoryChip\|selectedCategory" lib/features/transactions/` returns 0. Visual: transaction form has no category selection. |
| **Acceptance Criteria** | Zero expense category references in transaction screen. Form has exactly 3 inputs: amount, note (optional), date. No category chips or category-related UI. |

---

### VR-003: Remove Italic from STS Settings

| Field | Value |
|-------|-------|
| **Task ID** | VR-003 |
| **Priority** | P0-BLOCKER |
| **Phase** | 1 |
| **Source Issue** | A4V-1 B6 |
| **Affected Files** | `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart` (line ~88) |
| **Expected Visual Change** | Buffer description text changes from italic to regular weight. Text remains bodySm or equivalent token style. |
| **Non-Goals** | Do not change the text content. Do not migrate other typography in this file (that is P2). |
| **Risk** | VERY LOW. Delete one `fontStyle: FontStyle.italic` property. |
| **Verification** | `grep -n "FontStyle.italic" lib/features/safe_to_spend/` returns 0. |
| **Acceptance Criteria** | Zero FontStyle.italic in STS settings file. |

---

### VR-004: Remove Italic from Income List

| Field | Value |
|-------|-------|
| **Task ID** | VR-004 |
| **Priority** | P0-BLOCKER |
| **Phase** | 1 |
| **Source Issue** | A4V-1 B7 |
| **Affected Files** | `lib/features/income/presentation/views/income_list_screen.dart` (line ~532) |
| **Expected Visual Change** | Income entry notes rendered in regular weight instead of italic. |
| **Non-Goals** | Do not change note content or display logic. Do not migrate other typography (that is P2). |
| **Risk** | VERY LOW. Delete one `fontStyle: FontStyle.italic` property. |
| **Verification** | `grep -n "FontStyle.italic" lib/features/income/` returns 0. |
| **Acceptance Criteria** | Zero FontStyle.italic in income feature files. |

---

### VR-005: Fix Splash Animation Timing

| Field | Value |
|-------|-------|
| **Task ID** | VR-005 |
| **Priority** | P0-BLOCKER |
| **Phase** | 1 |
| **Source Issue** | A4V-1 B4 |
| **Affected Files** | `lib/features/splash/views/splash_screen.dart` (line ~37) |
| **Expected Visual Change** | Splash visible time drops from ~2000ms to ~500ms. Animation uses PocketaMotion.slow (320ms) duration and Curves.easeOut. App feels fast on launch. |
| **Non-Goals** | Do not redesign splash visual (that is P6 VR-028). Only fix timing and curve. |
| **Risk** | VERY LOW. Change Duration value and Curves constant. |
| **Verification** | `grep -n "1800\|easeIn" lib/features/splash/` returns 0. Splash total visible time <= 500ms. |
| **Acceptance Criteria** | Splash animation duration = PocketaMotion.slow (320ms). Curve = Curves.easeOut. Total splash time <= 500ms. |

---

### VR-006: Delete Dead Code (safe_to_spend_hero.dart)

| Field | Value |
|-------|-------|
| **Task ID** | VR-006 |
| **Priority** | P1-MAJOR |
| **Phase** | 1 |
| **Source Issue** | A4V-1 M11 |
| **Affected Files** | `lib/features/safe_to_spend/presentation/widgets/safe_to_spend_hero.dart` |
| **Expected Visual Change** | None (file is not imported anywhere). Removes confusion during code review. |
| **Non-Goals** | Do not touch S2sHeroBlock (the real hero widget). |
| **Risk** | VERY LOW. Grep confirms nobody imports this file. |
| **Verification** | File does not exist. `grep -rn "safe_to_spend_hero" lib/` returns 0. |
| **Acceptance Criteria** | File deleted. No import references anywhere. |

---

## Phase 2: Typography Migration

---

### VR-007: STS Settings Typography Migration

| Field | Value |
|-------|-------|
| **Task ID** | VR-007 |
| **Priority** | P1-MAJOR |
| **Phase** | 2 |
| **Source Issue** | A4V-1 M2 |
| **Affected Files** | `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart` |
| **Expected Visual Change** | All text uses PocketaTypography tokens. Section headers use headingMd. Descriptions use bodySm. Amounts use monoFinancial tokens. Consistent type rhythm throughout screen. |
| **Non-Goals** | Do not change layout structure. Do not add PocketaAmount here (that is P6 VR-030). Do not change spacing (that is P5). |
| **Risk** | LOW. Mechanical replacement. Each fontSize maps to a known token. |
| **Verification** | `grep -n "fontSize:" lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart` returns 0. Visual: consistent type scale on STS settings screen. |
| **Acceptance Criteria** | Zero hardcoded fontSize in file. All text styles reference PocketaTypography. Sheet title uses headingLg. Section headers use headingMd. Descriptions use bodySm. Percentage values use monoFinancialSm. |

---

### VR-008: Income List Typography Migration

| Field | Value |
|-------|-------|
| **Task ID** | VR-008 |
| **Priority** | P1-MAJOR |
| **Phase** | 2 |
| **Source Issue** | A4V-1 M1 |
| **Affected Files** | `lib/features/income/presentation/views/income_list_screen.dart` |
| **Expected Visual Change** | All 14+ ResponsiveUtilities.font() calls replaced with PocketaTypography tokens. All hardcoded fontSize replaced. Consistent type hierarchy. Money amounts use monoFinancial tokens (not PocketaAmount widget yet -- that is P6). |
| **Non-Goals** | Do not restructure the screen layout. Do not add PocketaAmount (P6). Do not change filter logic. |
| **Risk** | MEDIUM. Most ResponsiveUtilities.font() replacements. Screen may reflow slightly at different widths since ResponsiveUtilities was width-adaptive. Test on 360px and 390px widths. |
| **Verification** | `grep -n "ResponsiveUtilities.font\|fontSize:" lib/features/income/presentation/views/income_list_screen.dart` returns 0. Visual: consistent type scale, no size drift across device widths. |
| **Acceptance Criteria** | Zero ResponsiveUtilities.font() in file. Zero hardcoded fontSize. All text uses PocketaTypography tokens. |

---

### VR-009: Add Income Typography Migration

| Field | Value |
|-------|-------|
| **Task ID** | VR-009 |
| **Priority** | P1-MAJOR |
| **Phase** | 2 |
| **Source Issue** | A4V-1 M7 (typography portion) |
| **Affected Files** | `lib/features/income/presentation/views/add_income_screen.dart` |
| **Expected Visual Change** | All ResponsiveUtilities.font() and hardcoded fontSize replaced with PocketaTypography tokens. |
| **Non-Goals** | Do not change form field structure. Do not change FX rate or exclude logic. |
| **Risk** | LOW. Mechanical replacement. |
| **Verification** | `grep -n "ResponsiveUtilities.font\|fontSize:" lib/features/income/presentation/views/add_income_screen.dart` returns 0. |
| **Acceptance Criteria** | Zero ResponsiveUtilities.font(). Zero hardcoded fontSize. All text uses tokens. |

---

### VR-010: Add Transaction Typography Migration

| Field | Value |
|-------|-------|
| **Task ID** | VR-010 |
| **Priority** | P1-MAJOR |
| **Phase** | 2 |
| **Source Issue** | A4V-1 screen score 20 |
| **Affected Files** | `lib/features/transactions/presentation/views/add_transaction_screen.dart` |
| **Expected Visual Change** | All ResponsiveUtilities.font() and hardcoded fontSize replaced with PocketaTypography tokens. Post-category-removal form uses clean token typography. |
| **Non-Goals** | Do not change transaction data model. Do not add new fields. |
| **Risk** | LOW. Categories already removed in P1. Typography migration is mechanical. |
| **Verification** | `grep -n "ResponsiveUtilities.font\|fontSize:" lib/features/transactions/presentation/views/add_transaction_screen.dart` returns 0. |
| **Acceptance Criteria** | Zero ResponsiveUtilities.font(). Zero hardcoded fontSize. |

---

### VR-011: Export Screen Typography Migration

| Field | Value |
|-------|-------|
| **Task ID** | VR-011 |
| **Priority** | P1-MAJOR |
| **Phase** | 2 |
| **Source Issue** | A4V-1 M3 |
| **Affected Files** | `lib/features/export/presentation/views/export_screen.dart` |
| **Expected Visual Change** | 4 hardcoded fontSize replaced with tokens. Raw ElevatedButton replaced with AppButton (now teal after P1). |
| **Non-Goals** | Do not change export logic or data format. |
| **Risk** | LOW. Small file, 4 replacements + button swap. |
| **Verification** | `grep -n "fontSize:" lib/features/export/presentation/views/export_screen.dart` returns 0. |
| **Acceptance Criteria** | Zero hardcoded fontSize. Uses AppButton instead of raw ElevatedButton. |

---

### VR-012: Splash Typography Migration

| Field | Value |
|-------|-------|
| **Task ID** | VR-012 |
| **Priority** | P1-MAJOR |
| **Phase** | 2 |
| **Source Issue** | A4V-1 splash score 25 |
| **Affected Files** | `lib/features/splash/views/splash_screen.dart` |
| **Expected Visual Change** | Hardcoded fontSize: 52 and fontSize: 32 replaced with PocketaTypography tokens. |
| **Non-Goals** | Do not redesign splash visual (P6 VR-028). Only replace font sizes. |
| **Risk** | LOW. 2 replacements. |
| **Verification** | `grep -n "fontSize:" lib/features/splash/` returns 0. |
| **Acceptance Criteria** | Zero hardcoded fontSize in splash screen. |

---

### VR-013: PIN Screens Typography Migration

| Field | Value |
|-------|-------|
| **Task ID** | VR-013 |
| **Priority** | P1-MAJOR |
| **Phase** | 2 |
| **Source Issue** | A4V-1 PIN score 55 |
| **Affected Files** | `lib/features/auth/presentation/views/pin_entry_screen.dart`, `lib/features/auth/presentation/views/pin_setup_screen.dart` |
| **Expected Visual Change** | 3 hardcoded fontSize (22, 14, 24) replaced with PocketaTypography tokens. |
| **Non-Goals** | Do not change PIN logic, numpad layout, or auth flow. |
| **Risk** | LOW. 3 replacements across 2 files. |
| **Verification** | `grep -n "fontSize:" lib/features/auth/presentation/views/` returns 0. |
| **Acceptance Criteria** | Zero hardcoded fontSize in PIN screen files. |

---

### VR-014: Audit Log Typography Migration

| Field | Value |
|-------|-------|
| **Task ID** | VR-014 |
| **Priority** | P1-MAJOR |
| **Phase** | 2 |
| **Source Issue** | A4V-1 audit log score 45 |
| **Affected Files** | `lib/features/audit_log/presentation/views/audit_log_screen.dart` |
| **Expected Visual Change** | Hardcoded fontSize: 12 replaced with PocketaTypography.labelMd. |
| **Non-Goals** | Do not change audit log data or event types. |
| **Risk** | VERY LOW. 1 replacement. |
| **Verification** | `grep -n "fontSize:" lib/features/audit_log/` returns 0. |
| **Acceptance Criteria** | Zero hardcoded fontSize in audit log. |

---

### VR-015: Delete Account Typography Migration

| Field | Value |
|-------|-------|
| **Task ID** | VR-015 |
| **Priority** | P1-MAJOR |
| **Phase** | 2 |
| **Source Issue** | A4V-1 delete account score 50 |
| **Affected Files** | `lib/features/account/presentation/views/delete_account_screen.dart` |
| **Expected Visual Change** | Hardcoded fontSize replaced with PocketaTypography tokens. |
| **Non-Goals** | Do not change deletion logic or PIN verification flow. |
| **Risk** | LOW. Mechanical replacement. |
| **Verification** | `grep -n "fontSize:" lib/features/account/` returns 0. |
| **Acceptance Criteria** | Zero hardcoded fontSize in delete account screen. |

---

### VR-016: Pipeline Summary Typography Migration

| Field | Value |
|-------|-------|
| **Task ID** | VR-016 |
| **Priority** | P1-MAJOR |
| **Phase** | 2 |
| **Source Issue** | A4V-1 pipeline summary score 40 |
| **Affected Files** | `lib/features/income/presentation/widgets/income_pipeline_summary.dart` |
| **Expected Visual Change** | ResponsiveUtilities.font() and hardcoded fontSize replaced with PocketaTypography tokens. |
| **Non-Goals** | Do not change summary calculation logic. |
| **Risk** | LOW. Mechanical replacement. |
| **Verification** | `grep -n "ResponsiveUtilities.font\|fontSize:" lib/features/income/presentation/widgets/income_pipeline_summary.dart` returns 0. |
| **Acceptance Criteria** | Zero ResponsiveUtilities.font(). Zero hardcoded fontSize. |

---

### VR-017: Onboarding Form Typography Hardcodes

| Field | Value |
|-------|-------|
| **Task ID** | VR-017 |
| **Priority** | P2-MINOR |
| **Phase** | 2 |
| **Source Issue** | A4V-1 onboarding score 65 |
| **Affected Files** | `lib/features/onboarding/presentation/views/pages/fixed_costs_page.dart`, `first_pipeline_page.dart` |
| **Expected Visual Change** | Hardcoded form widget sizes (checkbox 20x20, TextField width: 120) replaced with token-appropriate values. |
| **Non-Goals** | Do not change onboarding flow or data collection. |
| **Risk** | LOW. Minor form widget adjustments. |
| **Verification** | Visual: onboarding forms look consistent with rest of token system. |
| **Acceptance Criteria** | No hardcoded form widget dimensions that conflict with token system. |

---

## Phase 3: Weight + Color Cleanup

---

### VR-018: FontWeight.bold -> w600 (All Files)

| Field | Value |
|-------|-------|
| **Task ID** | VR-018 |
| **Priority** | P1-MAJOR |
| **Phase** | 3 |
| **Source Issue** | A4V-1 M4 |
| **Affected Files** | `sts_settings_screen.dart`, `export_screen.dart`, `splash_screen.dart`, `add_income_screen.dart`, `income_list_screen.dart`, `add_transaction_screen.dart`, `linear_progress_bar.dart` (7 files after dead code deleted in P1) |
| **Expected Visual Change** | All text currently w700 (bold) becomes w600 (semi-bold). Subtle but meaningful -- text no longer shouts. Headers have confident emphasis without aggression. |
| **Non-Goals** | Do not change text that already uses PocketaTypography tokens (tokens already specify correct weight). Only fix hardcoded FontWeight.bold/w700. |
| **Risk** | LOW. Mechanical find-replace. Visual change is subtle (w700 -> w600). |
| **Verification** | `grep -rn "FontWeight.bold\|FontWeight.w700\|FontWeight.w800\|FontWeight.w900" lib/features/` returns 0. |
| **Acceptance Criteria** | Zero FontWeight.bold, w700, w800, w900 in feature files. Maximum weight in features is w600. |

---

### VR-019: Colors.white -> PocketaColors Token (All Files)

| Field | Value |
|-------|-------|
| **Task ID** | VR-019 |
| **Priority** | P1-MAJOR |
| **Phase** | 3 |
| **Source Issue** | A4V-1 M5 |
| **Affected Files** | 12 files (see Migration Sequence P3 file list) |
| **Expected Visual Change** | Pure white (#FFFFFF) replaced with warm-tinted canvas/surface tokens. Subtle warmth improvement -- elements no longer clash with warm neutral palette. |
| **Non-Goals** | Do not change structural layout. Colors.white in system widgets (DatePicker, etc.) is acceptable. |
| **Risk** | LOW. Mechanical replacement. Each `Colors.white` maps to `colors.surface` (on cards/buttons) or `colors.canvas` (on backgrounds). |
| **Verification** | `grep -rn "Colors.white" lib/features/` returns 0. |
| **Acceptance Criteria** | Zero Colors.white in feature files. All white surfaces use PocketaColors.surface or .canvas. |

---

### VR-020: Colors.black -> PocketaColors Token (All Files)

| Field | Value |
|-------|-------|
| **Task ID** | VR-020 |
| **Priority** | P1-MAJOR |
| **Phase** | 3 |
| **Source Issue** | A4V-1 M5 |
| **Affected Files** | Subset of 12 files with Colors.black |
| **Expected Visual Change** | Pure black (#000000) replaced with warm-tinted inkPrimary (#141413). Subtle improvement -- text and icons no longer harsh against warm backgrounds. |
| **Non-Goals** | Same as VR-019. System widget colors acceptable. |
| **Risk** | LOW. Each `Colors.black` maps to `colors.inkPrimary`. |
| **Verification** | `grep -rn "Colors.black" lib/features/` returns 0. |
| **Acceptance Criteria** | Zero Colors.black in feature files. All black elements use PocketaColors.inkPrimary. |

---

### VR-021: Remove Deprecated AppColors Imports

| Field | Value |
|-------|-------|
| **Task ID** | VR-021 |
| **Priority** | P1-MAJOR |
| **Phase** | 3 |
| **Source Issue** | A4V-1 global violation inventory |
| **Affected Files** | Remaining files importing `AppColors` after VR-001 (button fix). Estimated: `linear_progress_bar.dart`, plus any feature files. |
| **Expected Visual Change** | None directly. Code cleanup -- deprecated color system fully removed from usage. |
| **Non-Goals** | Do not delete the AppColors file itself yet (may be referenced in tests). Just remove all imports in feature/widget code. |
| **Risk** | LOW. Find all imports, replace referenced colors with PocketaColors equivalents. |
| **Verification** | `grep -rn "AppColors" lib/features/ lib/core/widgets/` returns 0 (excluding the definition file itself). |
| **Acceptance Criteria** | Zero AppColors references in feature files and widget files. |

---

## Phase 4: Icon System Migration

---

### VR-022: Add Phosphor Flutter Package

| Field | Value |
|-------|-------|
| **Task ID** | VR-022 |
| **Priority** | P0-BLOCKER |
| **Phase** | 4 |
| **Source Issue** | A4V-1 B5 |
| **Affected Files** | `pubspec.yaml` |
| **Expected Visual Change** | None (package installation only). |
| **Non-Goals** | Do not replace any icons in this task. Package install only. |
| **Risk** | MEDIUM. Package addition requires Chief Architect approval. Must verify package compatibility with current Flutter SDK. |
| **Verification** | `flutter pub get` succeeds. `dart analyze` clean. `flutter test` all pass. |
| **Acceptance Criteria** | `phosphor_flutter` in pubspec.yaml dependencies. pub get succeeds. No analyzer warnings from new package. |

---

### VR-023: Replace Material Icons with Phosphor (All 16 Files)

| Field | Value |
|-------|-------|
| **Task ID** | VR-023 |
| **Priority** | P0-BLOCKER |
| **Phase** | 4 |
| **Source Issue** | A4V-1 B5, TOY-02 |
| **Affected Files** | 16 files: `app_router.dart`, `dashboard_screen.dart`, `pipeline_screen.dart`, `pipeline_entry_card.dart`, `income_list_screen.dart`, `add_income_screen.dart`, `add_transaction_screen.dart`, `sts_settings_screen.dart`, `export_screen.dart`, `audit_log_screen.dart`, `delete_account_screen.dart`, `confirm_received_sheet.dart`, `fixed_costs_page.dart`, `first_pipeline_page.dart`, `income_pipeline_summary.dart`, `pipeline_screen.dart` |
| **Expected Visual Change** | All icons change from Material filled/rounded to Phosphor outline (1.5pt stroke). App stops looking like Flutter template. Unique ledger-calm icon identity. |
| **Non-Goals** | Do not create custom icons. Do not change icon sizing (use same size values). Material Icons in Flutter system widgets (DatePicker, etc.) are acceptable. |
| **Risk** | MEDIUM. 66 replacements. Each must be semantically correct. Use icon mapping from Migration Sequence. |
| **Verification** | `grep -rn "Icons\." lib/features/ lib/config/` returns 0 (excluding comments). Visual: all icons are Phosphor outline style. |
| **Acceptance Criteria** | Zero Icons.* references in feature files and router. All icons use PhosphorIcons.*. Consistent outline style throughout. |

---

## Phase 5: Spacing + Shadow Cleanup

---

### VR-024: Remove All BoxShadow

| Field | Value |
|-------|-------|
| **Task ID** | VR-024 |
| **Priority** | P1-MAJOR |
| **Phase** | 5 |
| **Source Issue** | A4V-1 M6 |
| **Affected Files** | `income_pipeline_summary.dart`, `income_list_screen.dart`, `pipeline_entry_card.dart` (3 files after dead code deleted in P1) |
| **Expected Visual Change** | Cards no longer float with shadow. Grounded on surface with hairline borders. Paper ledger feel. |
| **Non-Goals** | Do not add borders as shadow replacement (cards should already have appropriate borders from card widget). Do not change card elevation (should already be 0). |
| **Risk** | LOW. Delete BoxShadow declarations. |
| **Verification** | `grep -rn "BoxShadow" lib/features/` returns 0. |
| **Acceptance Criteria** | Zero BoxShadow in feature files. Cards grounded with border only, no shadow. |

---

### VR-025: Card Radius Migration (12pt)

| Field | Value |
|-------|-------|
| **Task ID** | VR-025 |
| **Priority** | P1-MAJOR |
| **Phase** | 5 |
| **Source Issue** | A4V-1 N6, screen-level findings |
| **Affected Files** | ~20 files with BorderRadius.circular in card context |
| **Expected Visual Change** | All card-context BorderRadius use PocketaSpacing.cardRadius (12). Cards that used 16 become 12. Consistent surface family. |
| **Non-Goals** | Do not change button radii (separate token). Do not change pill/circle indicators (100 is acceptable for those). |
| **Risk** | MEDIUM. Must distinguish card context from button/pill context before replacing. |
| **Verification** | `grep -rn "BorderRadius.circular" lib/features/ | grep -v "10\|100"` returns only documented exceptions. |
| **Acceptance Criteria** | All card-context borders use PocketaSpacing.cardRadius. No BorderRadius.circular(16) or (20) in card context. |

---

### VR-026: Button Radius Migration (10pt)

| Field | Value |
|-------|-------|
| **Task ID** | VR-026 |
| **Priority** | P2-MINOR |
| **Phase** | 5 |
| **Source Issue** | A4V-1 various |
| **Affected Files** | Files with BorderRadius.circular(12) or (10) in button/input context |
| **Expected Visual Change** | All button-context BorderRadius use PocketaSpacing.buttonRadius (10). |
| **Non-Goals** | AppButton already fixed in VR-001. This covers TextFormField borders and OutlinedButton borders in feature files. |
| **Risk** | LOW. Mechanical replacement in form contexts. |
| **Verification** | Visual: all buttons and form inputs have consistent 10pt radius. |
| **Acceptance Criteria** | All button/input borders use PocketaSpacing.buttonRadius or equivalent token. |

---

### VR-027: EdgeInsets Standardization

| Field | Value |
|-------|-------|
| **Task ID** | VR-027 |
| **Priority** | P2-MINOR |
| **Phase** | 5 |
| **Source Issue** | A4V-1 various MINOR findings |
| **Affected Files** | Feature files with hardcoded EdgeInsets that match PocketaSpacing tokens |
| **Expected Visual Change** | Hardcoded EdgeInsets.all(16) -> PocketaSpacing.screenEdge where applicable. Hardcoded SizedBox(height: 8/16/24/32) -> PocketaSpacing tokens. |
| **Non-Goals** | Do not obsess over every SizedBox. Focus on screen-level padding and section spacing. Leave minor gaps between form fields as-is if they look correct. |
| **Risk** | LOW. Most values are already correct (16 = screenEdge, 8 = s2, etc.). Just adding token references. |
| **Verification** | Spot-check major screens for consistent spacing. |
| **Acceptance Criteria** | Screen-level padding uses PocketaSpacing.screenEdge. Major section gaps use PocketaSpacing tokens. |

---

## Phase 6: Screen-Level Polish

---

### VR-028: Splash Screen Redesign

| Field | Value |
|-------|-------|
| **Task ID** | VR-028 |
| **Priority** | P0-BLOCKER |
| **Phase** | 6 |
| **Source Issue** | A4V-1 B3 |
| **Affected Files** | `lib/features/splash/views/splash_screen.dart` |
| **Expected Visual Change** | CircleAvatar "P" replaced with "Pocketa" wordmark text: Inter font, w600 weight, inkPrimary color, centered on canvas background. 320ms PocketaMotion.slow fade-in. Immediate navigation after fade. Clean, confident, minimal. |
| **Non-Goals** | Do not add logo image/SVG (text wordmark only). Do not add tagline. Do not add loading indicator. Do not add animation beyond fade. |
| **Risk** | LOW. Single file. Visual identity change requires device verification. |
| **Verification** | Visual on device: "Pocketa" text centered, canvas bg, fast fade, no CircleAvatar. `grep -n "CircleAvatar" lib/features/splash/` returns 0. |
| **Acceptance Criteria** | No CircleAvatar. "Pocketa" in Inter w600 centered on canvas. PocketaMotion.slow fade. Total splash <= 500ms. |

---

### VR-029: Income List PocketaAmount Adoption

| Field | Value |
|-------|-------|
| **Task ID** | VR-029 |
| **Priority** | P1-MAJOR |
| **Phase** | 6 |
| **Source Issue** | A4V-1 Gap Map #8 |
| **Affected Files** | `lib/features/income/presentation/views/income_list_screen.dart` |
| **Expected Visual Change** | All money values on income list rendered via PocketaAmount widget. Monospace JetBrains Mono. BDT-formatted (taka prefix, lakh grouping). Right-aligned. Consistent decimal places. Financial data looks serious. |
| **Non-Goals** | Do not restructure income list layout. Do not add PocketaLedgerCard (that would be a full rebuild, deferred). |
| **Risk** | MEDIUM. Must ensure PocketaAmount receives correct amount values from existing data. |
| **Verification** | Visual: all money values on income list in monospace with "tk" prefix. `grep -n "formatter.format(amount)\|toStringAsFixed" lib/features/income/presentation/views/income_list_screen.dart` returns 0 for money display contexts. |
| **Acceptance Criteria** | All money values on income list use PocketaAmount widget. Monospace font. BDT formatting. |

---

### VR-030: STS Settings PocketaAmount Adoption

| Field | Value |
|-------|-------|
| **Task ID** | VR-030 |
| **Priority** | P1-MAJOR |
| **Phase** | 6 |
| **Source Issue** | A4V-1 STS settings score 25 |
| **Affected Files** | `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart` |
| **Expected Visual Change** | Fixed cost amounts (`'৳ ${cost.amount.toStringAsFixed(0)}'`) rendered via PocketaAmount widget. Consistent with dashboard money display. |
| **Non-Goals** | Do not change slider or form inputs for percentage values. |
| **Risk** | LOW. Replace Text widget with PocketaAmount in ListTile trailing. |
| **Verification** | Visual: fixed cost amounts in monospace with BDT formatting. |
| **Acceptance Criteria** | Fixed cost amounts use PocketaAmount. No manual taka symbol concatenation for amounts. |

---

### VR-031: Transaction Form Post-Category Cleanup

| Field | Value |
|-------|-------|
| **Task ID** | VR-031 |
| **Priority** | P2-MINOR |
| **Phase** | 6 |
| **Source Issue** | VR-002 follow-up |
| **Affected Files** | `lib/features/transactions/presentation/views/add_transaction_screen.dart` |
| **Expected Visual Change** | After category removal (P1), form layout is clean: amount field prominent at top, optional note below, date picker at bottom. No empty space where categories used to be. "Record cash out" framing. |
| **Non-Goals** | Do not add new form fields. Do not change data model. |
| **Risk** | LOW. Layout adjustment after deletion. |
| **Verification** | Visual: clean 3-field form with no visual gap or orphaned UI. |
| **Acceptance Criteria** | Form has exactly: amount, note (optional), date. Clean layout. No category remnants. |

---

### VR-032: Delete Account Button Height Fix

| Field | Value |
|-------|-------|
| **Task ID** | VR-032 |
| **Priority** | P2-MINOR |
| **Phase** | 6 |
| **Source Issue** | A4V-1 M9 |
| **Affected Files** | `lib/features/account/presentation/views/delete_account_screen.dart` |
| **Expected Visual Change** | Button height changes from 52pt to 48pt per VIS-019. |
| **Non-Goals** | Do not change deletion flow. |
| **Risk** | VERY LOW. Single value change. |
| **Verification** | `grep -n "52" lib/features/account/presentation/views/delete_account_screen.dart` -- no button height of 52. |
| **Acceptance Criteria** | Button height = 48pt (PocketaSpacing.buttonHeight). |

---

## Phase 7: Final Verification

---

### VR-033: Full Verification Pass

| Field | Value |
|-------|-------|
| **Task ID** | VR-033 |
| **Priority** | P0-CRITICAL |
| **Phase** | 7 |
| **Source Issue** | All phases |
| **Affected Files** | None (verification only) |
| **Expected Visual Change** | None. Produces verification report documenting final state. |
| **Non-Goals** | Do not make changes. Observe and document only. |
| **Risk** | None. |
| **Verification** | Run full checklist from Migration Sequence P7. Run dart analyze + flutter test. Re-score all screens. |
| **Acceptance Criteria** | All P7 checklist items pass. Overall weighted score >= 75. Zero BLOCKERs. Screen floor >= 60. |

---

## Task Summary

| Phase | Tasks | Priority Mix | Total Tasks |
|-------|-------|-------------|-------------|
| P1 Kill BLOCKERs | VR-001 to VR-006 | 4 P0, 1 P1, 1 P1 | 6 |
| P2 Typography | VR-007 to VR-017 | 10 P1, 1 P2 | 11 |
| P3 Weight + Color | VR-018 to VR-021 | 4 P1 | 4 |
| P4 Icons | VR-022 to VR-023 | 2 P0 | 2 |
| P5 Spacing | VR-024 to VR-027 | 2 P1, 2 P2 | 4 |
| P6 Screen Polish | VR-028 to VR-032 | 1 P0, 2 P1, 2 P2 | 5 |
| P7 Verification | VR-033 | 1 P0 | 1 |
| **Total** | | | **33** |

---

*End of A4V-2 Visual Rescue Tasks. No code was modified.*
