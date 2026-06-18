# Helm Full UI/UX Migration Master Plan

> **Status:** Decision-grade planning document
> **Date:** 2026-06-16
> **Author:** Principal Product Design Architect (Claude Opus 4.6)
> **Scope:** Complete experience-system migration — not a visual reskin
> **Hard boundary:** No production code modified. Planning and architecture only.

---

## Table of Contents

1. [Executive Decision Summary](#1-executive-decision-summary)
2. [Inspected Evidence and Authoritative Sources](#2-inspected-evidence-and-authoritative-sources)
3. [Current-State UI/UX Diagnosis](#3-current-state-uiux-diagnosis)
4. [Runtime Screen Inventory](#4-runtime-screen-inventory)
5. [Current Design-System Map](#5-current-design-system-map)
6. [Target Experience Definition](#6-target-experience-definition)
7. [Philosophy Translation into Product Rules](#7-philosophy-translation-into-product-rules)
8. [Complete Journey Map](#8-complete-journey-map)
9. [Target Component Architecture](#9-target-component-architecture)
10. [Token Migration Plan](#10-token-migration-plan)
11. [Screen-by-Screen Migration Matrix](#11-screen-by-screen-migration-matrix)
12. [Phased Implementation Roadmap](#12-phased-implementation-roadmap)
13. [Dependency Graph](#13-dependency-graph)
14. [Verification and Test Strategy](#14-verification-and-test-strategy)
15. [Accessibility and Localization Strategy](#15-accessibility-and-localization-strategy)
16. [Performance Strategy](#16-performance-strategy)
17. [Rollback and Release-Safety Strategy](#17-rollback-and-release-safety-strategy)
18. [Risks and Mitigations](#18-risks-and-mitigations)
19. [Unresolved Decisions](#19-unresolved-decisions)
20. [Recommended First Implementation Slice](#20-recommended-first-implementation-slice)
21. [Definition of Done](#21-definition-of-done)

---

## 1. Executive Decision Summary

### The Situation

Helm has **two coexisting visual systems** — legacy `AppColors`/`getFontStyle()` and the newer `HelmColors`/`HelmTypography`/`HelmSpacing`/`HelmMotion` token system. The Helm tokens are well-designed (13 color tokens, 18 typography styles, 8pt grid, ease-out-only motion) but **not fully migrated across all screens**. This dual-system state damages trust more than either system alone (Lesson L20).

A Signal Deck redesign (dark-first, glass effects, spring physics) was approved, implemented across 10 commits, and **rolled back**. The philosophy exploration produced a clear recommendation: **Warm Ledger + Native Ground hybrid** — a typography-led, BDT-first, culturally grounded financial notebook.

### The Decision Required

Commit to one visual direction and execute a phased migration that:
1. Eliminates the dual-system state
2. Completes the Helm token migration
3. Infuses Native Ground cultural specificity (BDT-first, Bangla-equal, source-aware)
4. Keeps the app releasable at every phase boundary
5. Validates through testing, not visual opinion

### Recommended Path

**Warm Ledger + Native Ground hybrid** (Option A from philosophy exploration). Reasons:
- Highest weighted score (7.87/10) across 14 criteria
- Extends existing token system (~25-35 hours vs ~40-60 for Signal Deck)
- Best-in-class Android performance (zero BackdropFilter, zero spring physics)
- Strongest founder-belief alignment across all criteria
- Eliminates Warm Ledger's generic-appearance weakness through cultural specificity
- Typography ages slowly; cultural specificity is evergreen

### What This Plan Does NOT Decide

- Exact color hex values (token tuning happens during implementation)
- Final dark mode strategy (light-first confirmed; dark mode quality is Phase 6)
- Whether to run user validation experiments first (recommended but optional)

---

## 2. Inspected Evidence and Authoritative Sources

### Documents Read (Authoritative)

| Document | Path | Authority Level |
|---|---|---|
| Final Product Doctrine | `docs/strategy/HELM_FINAL_PRODUCT_DOCTRINE.md` | **Canonical** — supersedes all prior docs |
| Product Brain | `docs/core/HELM_BRAIN.md` | Primary product identity |
| Architecture Rules | `docs/core/ARCHITECTURE_RULES.md` | Binding technical constraints |
| Decision Log | `docs/tracking/DECISION_LOG.md` | Decisions 022-032 reviewed |
| UI Philosophy Exploration | `docs/design/HELM_UI_PHILOSOPHY_EXPLORATION.md` | Decision-grade design analysis |

### Code Inspected

| Area | Files Audited | Method |
|---|---|---|
| Design tokens | `helm_colors.dart`, `helm_typography.dart`, `helm_spacing.dart`, `helm_motion.dart`, `app_theme.dart`, `colors.dart` | Direct read |
| Router/Navigation | `app_router.dart`, `route_names.dart` | Direct read |
| Dashboard | `dashboard_screen.dart` + 4 section widgets | Direct read |
| Core widgets | 19 shared widgets in `lib/core/widgets/` | Agent audit (49 tool calls) |
| Feature widgets | 8 feature-specific widgets across dashboard, income, onboarding, nudge | Agent audit |
| Formatters | `number_formatter.dart`, `input_validator.dart`, `id_generator.dart` | Agent audit |
| Screen files | 16 main screens + 6 onboarding pages (22 total) | Agent audit (completed) |
| State management | 40+ Riverpod providers across 11 provider files | Agent audit (completed) |
| Tests | 44 test files, 347 test cases, zero golden tests | Agent audit (completed) |
| Localization | 121 en keys, 114 bn keys in ARB; only 1 screen uses `context.l10n` | Agent audit (completed) |
| Domain logic | SafeToSpendCalculator, income status transitions, number formatting | Agent audit (completed) |

### Key Finding: What Is Actually Used at Runtime

The **Helm token system** (`HelmColors`, `HelmTypography`, `HelmSpacing`, `HelmMotion`) is the active system for all core widgets and the dashboard. The legacy `AppColors` exists as a deprecated re-export. The legacy `getFontStyle()` exists for backward compatibility but all audited screens use `context.textStyles.*` or `context.colors`.

**Evidence:** 18/19 core widgets use Helm tokens at 95%+ compliance. The `colors.dart` file exports HelmColors internally. `AppThemeData` delegates to `AppTheme` internally.

---

## 3. Current-State UI/UX Diagnosis

### 3.1 Visual Systems Present

| System | Status | Usage |
|---|---|---|
| **HelmColors** (ThemeExtension, 13 tokens) | Active, authoritative | All core widgets, dashboard, pipeline |
| **HelmTypography** (ThemeExtension, 18 styles) | Active, authoritative | All core widgets, most screens |
| **HelmSpacing** (static, 8pt grid) | Active, authoritative | All core widgets |
| **HelmMotion** (static, ease-out only) | Active, authoritative | Calculation trace, buttons, onboarding |
| **AppColors** (deprecated static class) | Legacy re-export | Referenced in `colors.dart` barrel |
| **getFontStyle()** (legacy function) | Backward compat | Some feature screens may still call this |
| **ResponsiveUtilities** | Active | Used in transaction/income screens for padding |

### 3.2 Product UX Problems

| ID | Problem | Evidence | Severity |
|---|---|---|---|
| UX-P1 | **100% hardcoded English strings** | All screen files use inline English strings, no `AppLocalizations` | HIGH |
| UX-P2 | **Bangla is afterthought** | Hind Siliguri tokens defined but no runtime Bangla content except one qualifying question | HIGH |
| UX-P3 | **No contextual intelligence on dashboard** | Dashboard shows same layout regardless of financial state | MEDIUM |
| UX-P4 | **Empty states teach but don't guide** | CommittedSection empty state says "No fixed costs" but doesn't explain why that matters | MEDIUM |
| UX-P5 | **Transaction screen still feels like expense tracker** | "Record cash out" language conflicts with "not an expense tracker" identity | MEDIUM |

### 3.3 Visual-System Problems

| ID | Problem | Evidence | Severity |
|---|---|---|---|
| VS-P1 | **Two visual systems coexist** | `AppColors` deprecated but still importable; `getFontStyle()` still callable | HIGH |
| VS-P2 | **Number formatting inconsistency** | `HelmFxEstimate` uses raw `NumberFormat` instead of `NumberFormatter.formatBDT()`. `HelmSourceCard` has custom `_formatAmount()`. `PipelineEntryCard` has manual string formatting. | HIGH |
| VS-P3 | **Duplicate OnboardingHeader** | Identical class in `skip_button.dart` and `linear_progress_bar.dart` (76 lines each) | MEDIUM |
| VS-P4 | **No ownable visual signature** | Product looks like "any premium Flutter UI kit" (VISR-003) | MEDIUM |
| VS-P5 | **Dashboard hero uses `DateTime.now()` on every build** | `S2sHeroBlock` receives `updatedAt: DateTime.now()` from dashboard build, not actual data timestamp | LOW |

### 3.4 Interaction Problems

| ID | Problem | Evidence | Severity |
|---|---|---|---|
| IX-P1 | **No swipe-to-navigate between pipeline states** | Pipeline screen has swipe-to-confirm on individual cards but no horizontal swipe for state filtering | LOW |
| IX-P2 | **FAB label says "Add income entry" but screen says "Add Pipeline Entry"** | Tooltip/label mismatch between FAB and actual screen header | LOW |

### 3.5 Architecture Problems

| ID | Problem | Evidence | Severity |
|---|---|---|---|
| AR-P1 | **Dashboard initState has 6+ concerns** | Analytics, affirmation, nudge evaluation, STS hint, stopwatch — all in one initState. Uses `setState()` alongside Riverpod (mixed paradigms). | HIGH |
| AR-P2 | **Direct Hive access in presentation layer** | `AuthNotifier` accesses `Hive.box<dynamic>(AppBoxNames.authBox)` directly. `NudgePreferencesNotifier` has `Hive.box<NudgePreferencesModel>()`. Both violate data-layer abstraction. | HIGH |
| AR-P3 | **200+ LOC duplicated across section widgets** | CommittedSection, ReserveSection, NotCountedSection share amount-or-empty-state pattern | MEDIUM |
| AR-P4 | **Transaction feature is legacy** | TransactionEntity has no pipeline awareness; "Record cash out" screen was the v0.1 expense tracker | LOW |
| AR-P5 | **Inconsistent async state patterns** | TransactionsNotifier uses `AsyncValue<List>`, IncomeNotifier uses sync `List`. Error handling differs. | LOW |

### 3.6 Accessibility Problems

| ID | Problem | Evidence | Severity |
|---|---|---|---|
| A11Y-P1 | **7/19 widgets lack Semantics** | HelmShimmer, HelmMoneySourceLabel, HelmSourceCard, HelmHeroZone, HelmCautionCard, plus feature widgets | HIGH |
| A11Y-P2 | **HelmShimmer ignores reduced motion** | No `MediaQuery.disableAnimations` check (1500ms repeating animation) | MEDIUM |
| A11Y-P3 | **OnboardingHeader/ProgressLine skip disableAnimations** | 95% motion compliant, missing the final guard | LOW |

### 3.7 Localization Problems

| ID | Problem | Evidence | Severity |
|---|---|---|---|
| L10N-P1 | **Localization infrastructure exists but ~95% unused** | ARB files contain 121 en + 114 bn keys, but only `StsSettingsScreen` uses `context.l10n`. All other screens hardcode English. | CRITICAL |
| L10N-P2 | **7 Bangla translations missing** | 121 en keys vs 114 bn keys — 7 keys have no Bangla translation | HIGH |
| L10N-P3 | **Bangla typography tokens exist but unused** | `bodyLgBn`, `bodyMdBn`, `bodySmBn`, `labelMdBn` defined but no code selects them based on locale | MEDIUM |
| L10N-P4 | **No RTL/BiDi layout handling** | No `textDirection` or `Directionality` widgets found; Bangla needs more vertical space | MEDIUM |

### 3.8 Performance Problems

| ID | Problem | Evidence | Severity |
|---|---|---|---|
| PERF-P1 | **None identified in current codebase** | Zero BackdropFilter, zero spring physics, solid colors only. 60fps on any Android device expected. | N/A |

### 3.9 Testing and Verification Gaps

| ID | Problem | Evidence | Severity |
|---|---|---|---|
| TEST-P1 | **No golden tests** | Zero screenshot comparison tests across 44 test files | HIGH |
| TEST-P2 | **Limited widget tests** | Only 6 widget test files; 60%+ of screens untested (dashboard, income screens, onboarding pages, settings UI, notification center) | HIGH |
| TEST-P3 | **No Bangla overflow tests** | Hind Siliguri at 1.58 line height not tested against container constraints | HIGH |
| TEST-P4 | **Semantics test exists but incomplete** | `semantics_coverage_test.dart` has 14 groups but only covers 12/19 widgets | MEDIUM |
| TEST-P5 | **Strong domain test coverage** | S2S calculator (36 groups), auth (60+ cases), nudge (15 groups), number formatting (32 groups) — domain well-tested | INFO |

---

## 4. Runtime Screen Inventory

### 4.1 Pre-Shell Screens (No Bottom Navigation)

| Screen | Route | Class | Purpose | Token Compliance | Key Issues |
|---|---|---|---|---|---|
| Splash | `/` | `SplashScreen` | Auth/onboarding gate | Helm tokens | Redirect-only, minimal UI |
| Welcome | `/welcome` | `WelcomeScreen` | First-time welcome | Helm tokens | Hardcoded English |
| Onboarding | `/onboarding` | `OnboardingScreen` | 6-step setup flow | Helm tokens | Qualifying question has inline Bangla; rest is English-only |
| Magic Link | `/magic-link` | `MagicLinkScreen` | Email verification | Helm tokens | Hardcoded English |
| PIN Setup | `/pin-setup` | `PinSetupScreen` | Create 4-digit PIN | Helm tokens | Hardcoded English |
| PIN Entry | `/pin-entry` | `PinEntryScreen` | Unlock app | Helm tokens | Hardcoded English |

### 4.2 Shell Screens (Bottom Navigation: Home / Pipeline / Settings)

| Screen | Route | Class | Purpose | Token Compliance | Key Issues |
|---|---|---|---|---|---|
| Dashboard (Home) | `/home` | `DashboardScreen` | S2S Reality Stack | Helm tokens | Core value screen; hardcoded English; initState overloaded |
| Pipeline | `/pipeline` | `PipelineScreen` | Income pipeline list | Helm tokens | Hardcoded English |
| Settings | `/settings` | `StsSettingsScreen` | S2S configuration | Helm tokens | Also accessible via `/sts-settings` |

### 4.3 Modal/Overlay Screens (No Bottom Navigation)

| Screen | Route | Class | Purpose | Token Compliance | Key Issues |
|---|---|---|---|---|---|
| Add Transaction | `/add-transaction` | `AddTransactionScreen` | Record expense | Mixed (uses `ResponsiveUtilities` + Helm tokens) | Legacy "cash out" language |
| Edit Transaction | `/edit-transaction/:id` | `AddTransactionScreen` | Edit expense | Same as above | Same issues |
| Income List | `/income` | `IncomeListScreen` | All income entries | Helm tokens | Hardcoded English |
| Add Income | `/add-income` | `AddIncomeScreen` | Create pipeline entry | Mixed | Hardcoded English; many form fields |
| Edit Income | `/edit-income/:id` | `AddIncomeScreen` | Edit pipeline entry | Same as above | Same issues |
| S2S Settings | `/sts-settings` | `StsSettingsScreen` | Buffer %, fixed costs, FX rate | Helm tokens | Duplicate route with shell `/settings` |
| Audit Log | `/audit-log` | `AuditLogScreen` | Security event log | Helm tokens | Hardcoded English |
| Delete Account | `/delete-account` | `DeleteAccountScreen` | Account deletion | Helm tokens | Hardcoded English |
| Export Data | `/export-data` | `ExportScreen` | CSV export | Helm tokens | Hardcoded English |
| Notifications | `/notifications` | `NotificationCenterScreen` | Nudge center | Helm tokens | Hardcoded English |

### 4.4 Bottom Sheet / Dialog States

| Component | Trigger | Purpose |
|---|---|---|
| `HelmCalculationTrace` | Tap S2S hero number | Full S2S calculation breakdown |
| `ConfirmReceivedSheet` | Pipeline card swipe/tap | Confirm income receipt with FX/date |
| Date picker | Form date fields | Native Material date picker |

---

## 5. Current Design-System Map

### 5.1 Token Architecture

```
ThemeData
├── extensions: [HelmColors, HelmTypography]
├── colorScheme: hand-mapped from HelmColors
├── textTheme: mapped from HelmTypography
├── appBarTheme, cardTheme, buttonTheme, inputTheme, dividerTheme, bottomNavTheme
└── useMaterial3: true
```

### 5.2 Color Tokens (13)

| Token | Light Value | Dark Value | Semantic Role |
|---|---|---|---|
| `canvas` | `#FAFAF6` warm white | `#0E0E0C` | Page background |
| `surface` | `#FFFFFC` warmer white | `#161614` | Card surfaces |
| `inkPrimary` | `#141413` 14.8:1 AAA | `#F2F1ED` 15.1:1 | Numbers, critical text |
| `inkSecondary` | `#3B3A36` | `#B0ADA6` | Labels, timestamps |
| `inkTertiary` | `#6A6760` | `#857F77` | Helper text |
| `interactive` | `#255E5B` deep teal | `#4DA09C` 5.0:1 AA | All tappable affordances |
| `divider` | `#D8D3C8` | `#2A2925` | Card borders |
| `hairline` | `#E9E5DB` | `#232220` | Internal dividers |
| `stateSafe` | `#3D6B3C` 4.7:1 AA | `#82A887` | Cashflow safe |
| `stateTight` | `#8B6500` 4.6:1 AA | `#D4A668` | Cashflow tight |
| `stateAtRisk` | `#984635` | `#C56A58` | Cashflow at risk |
| `stateHope` | `#5A7585` | `#7A95A8` | Expected/pending text |
| `stateHopeMuted` | `#9BAAB2` | `#5A6E77` | Decorative hope markers |

### 5.3 Typography Tokens (18)

**Latin (Inter):** displayHero (64/w600), displayLarge (40/w600), headingLg (22/w600), headingMd (18/w600), headingSm (15/w600), bodyLg (16/w400), bodyMd (14/w400), bodySm (13/w400), labelMd (12/w500), labelSm (11/w500)

**Monospace Financial (JetBrains Mono):** monoFinancialSm (16/w500), monoFinancialMd (24/w500), monoFinancialLg (40/w600), monoHero (64/w600)

**Bangla (Hind Siliguri):** bodyLgBn (16/w400/h1.58), bodyMdBn (14/w400/h1.58), bodySmBn (13/w400/h1.52), labelMdBn (12/w500/h1.38)

**Rules:** No italic. No fontWeight outside 400-600. No letterSpacing overrides. TextScaler disabled for financial figures.

### 5.4 Spacing Tokens (8pt Grid)

s0=0, s1=4, s2=8, s3=12, s4=16 (card padding/screen edge), s5=20, s6=24 (tier spacing), s8=32, s10=40, s12=48. Card radius=12, button radius=10, sheet top radius=16.

### 5.5 Motion Tokens

Durations: instant(0), fast(120ms), base(200ms), medium(240ms), slow(320ms), s2sAppear(200ms). Curves: easeOut ONLY. Forbidden: springs, bounces, duration >320ms. Drawer row stagger: 24ms. Reduced-motion fallback: 80ms.

### 5.6 Legacy APIs (Deprecated, To Remove)

| API | File | Replacement |
|---|---|---|
| `AppColors` | `colors.dart` | `context.colors` (HelmColors) |
| `getFontStyle(lang, size, weight, color)` | `app_theme.dart:171` | `context.textStyles.*` |
| `AppThemeData.lightTheme(context, lang)` | `app_theme.dart:159` | `AppTheme.light` |

---

## 6. Target Experience Definition

### 6.1 Philosophy: Warm Ledger + Native Ground Hybrid

**One-sentence pitch:** "A calm, typography-led financial notebook that is unmistakably made for the Bangladeshi freelancer."

**Structural foundation (Warm Ledger):**
- Typography-only hierarchy — the ONLY decoration
- Warm white canvas, solid colors, zero shadows, zero gradients
- Reality Stack: 4 tiers of money truth
- Trust Strip, Ledger Rail, Calculation Trace as trust mechanisms
- 200ms ease-out transitions, no springs, no bounces

**Personality layer (Native Ground):**
- BDT-first Money Stamp — BDT at full visual weight, USD always secondary
- Bangla-equal typography — Hind Siliguri at equal visual weight, not smaller/lighter
- Culturally specific empty states — Bangla-first, not translated English
- Source-label system — Payoneer, bKash, Nagad as recognizable labels
- Lakh/crore formatting as visual feature, not localization detail

### 6.2 Information Hierarchy

1. **S2S Hero** (dominant) — The one number. 64pt JetBrains Mono. BDT amount.
2. **Ledger Rail** — 3pt state-colored bar (safe/tight/atRisk) below hero.
3. **Trust Strip** — Source + timestamp + FX rate + audit tap. 11pt. Always visible.
4. **Committed (Pressure)** — Fixed costs. Amount or empty-state CTA.
5. **Reserve (Buffer)** — Anxiety buffer percentage.
6. **Next Best Action** — Context-aware card (overdue/atRisk/relief/setup).
7. **Not Counted (Hope)** — Pipeline money in dim/recessed style.

### 6.3 Experience Rules

| Rule | Mechanism |
|---|---|
| **BDT is the hero currency** | S2S always in BDT. USD amounts labeled "~estimate". |
| **Show the math** | Tap any number to see calculation trace. |
| **Separate real from hopeful** | HelmAmount `dimmed: true` for hope tier. stateHope color. |
| **No alarm colors for money** | `stateAtRisk` is brick red, not fire-engine red. No red backgrounds. |
| **Neutral for deductions** | Subtraction rows in Calculation Trace use parentheses, not red text. |
| **Pessimistic by default** | Buffer deducted before showing S2S. Surplus is positive surprise. |
| **Bangla reads as native** | Bangla empty states, labels, and error messages written by native speaker. |
| **Consistent layout across sessions** | Reality Stack layout fixed. Content changes; structure doesn't. |
| **Progressive disclosure earned** | Calculation Trace on tap. Detail screens on navigate. Never imposed. |

### 6.4 What Is Retained from Current System

- All 13 HelmColors tokens (values may be tuned for Native Ground warmth)
- All 18 HelmTypography styles (Bangla styles promoted to equal use)
- 8pt spacing grid
- Ease-out-only motion policy
- Reality Stack layout architecture
- Existing core widgets (HelmAmount, HelmLedgerRail, HelmTrustStrip, HelmCalculationTrace, etc.)
- Ledger Rail, Trust Strip, Calculation Trace as trust mechanisms
- Riverpod state management
- Feature-first clean architecture

### 6.5 What Is Modified

- Color warmth may shift slightly warmer (e.g., canvas from `#FAFAF6` → `#FAF8F2` — TBD during implementation)
- Interactive teal may warm slightly (e.g., `#255E5B` → `#2A5E55` — TBD)
- Bangla typography tokens promoted from secondary to equal-weight
- Empty states rewritten Bangla-first
- All hardcoded strings moved to ARB localization files
- Source labels (Payoneer, bKash, etc.) given first-class visual treatment
- Number formatting unified through NumberFormatter everywhere

### 6.6 What Is Rejected

| Element | Source | Reason for Rejection |
|---|---|---|
| Dark-first canvas | Signal Deck | Budget Android TFT LCDs render dark poorly; light-first confirmed |
| BackdropFilter glass effects | Signal Deck | 3-8ms/frame cost on Samsung A14; performance kill |
| Spring physics | Signal Deck | Violates ease-out-only motion policy |
| Orbital visualization | Signal Deck | Decoration without product function |
| Glow accents | Signal Deck | Trend-dependent; dates quickly |
| Ultra-low density (5-6 elements) | Still Water | Freelancers with 4 pending payments need more information |
| Full-screen monospace | Sharp Edge | Anxiety amplification from high information density |
| Ruled notebook lines inside cards | Native Ground | Too decorative; Warm Ledger restraint wins |

---

## 7. Philosophy Translation into Product Rules

### 7.1 Financial Semantics

| Financial State | Color Token | Ledger Rail | Copy Tone |
|---|---|---|---|
| Safe (S2S > 0, buffer intact) | `stateSafe` | 3pt green | Neutral confirmation |
| Tight (S2S > 0, buffer partially consumed) | `stateTight` | 3pt amber | Calm factual |
| At Risk (S2S <= 0 or buffer exhausted) | `stateAtRisk` | 3pt brick | Honest, not alarming |
| Hope (expected/pending income) | `stateHope` / `stateHopeMuted` | None (dimmed) | Cautious, labeled |
| No Data (no income entries) | `inkTertiary` | None | Guiding, educational |

### 7.2 Card and Container Rules

- **HelmHeroZone:** No border. Canvas background. Spatial breathing only.
- **HelmLedgerCard:** 1pt `divider` border. `surface` fill. 12pt radius.
- **HelmCautionCard:** Left rail (3pt critical, 1.5pt warning). No full border color change.
- **No shadows.** Zero elevation throughout.
- **No gradients.** Solid fills only.

### 7.3 Typography Rules

- Hero S2S: `monoHero` (64pt JetBrains Mono w600)
- All financial amounts: JetBrains Mono with `TextScaler` disabled
- All UI text (English): Inter
- All UI text (Bangla): Hind Siliguri at **equal** size/weight to Inter equivalent
- No italic anywhere
- No fontWeight outside 400-600
- Hierarchy communicated through size and weight only, not color variation

### 7.4 Motion Rules

- Transitions: 200ms ease-out
- Calculation Trace drawer: 240ms with 24ms row stagger
- Reduced motion: 80ms flat, no stagger
- Button press: AnimatedScale 0.97x, 120ms
- S2S appear: 200ms fade-in
- **Forbidden:** springs, bounces, duration >320ms, animated counters

### 7.5 Navigation Rules

Current shell: Home / Pipeline / Settings (3 tabs)
- Home = S2S Reality Stack (dashboard_screen.dart)
- Pipeline = Income lifecycle (pipeline_screen.dart)
- Settings = S2S configuration (sts_settings_screen.dart)

No changes to navigation structure in this migration. The 3-tab shell is correct for the current product scope.

---

## 8. Complete Journey Map

### 8.1 First Launch to Completed Onboarding

```
Splash → [magic link not done?] → Magic Link Screen → [email verified] →
[onboarding not done?] → Welcome Screen → Onboarding (6 steps):
  1. Qualifying Question (en + bn rephrase)
  2. Currency selection
  3. Income source setup
  4. Income pattern
  5. Fixed costs / buffer %
  6. Liquid balance
→ [PIN not set?] → PIN Setup → Dashboard
```

**Migration needs:** All 8 screens need localization. Welcome and Onboarding need Bangla-first empty states. PIN screens need Bangla labels.

### 8.2 Adding First Income

```
Dashboard (empty pipeline) → FAB "Add Pipeline Entry" → Add Income Screen →
  Fill: client, project, amount, currency, expected date, source label →
  Save → Dashboard (pipeline populated, S2S computed)
```

**Migration needs:** Add Income form needs localization. Source label field should suggest common sources (Payoneer, Fiverr, Upwork, Direct).

### 8.3 Moving Income Through Pipeline

```
Pipeline Screen → Expected entries listed →
  Swipe-to-confirm OR tap → ConfirmReceivedSheet →
    Fill: actual amount, FX rate, received date →
    Confirm → Entry moves to "Received" → S2S recalculated →
    Dashboard updates
```

**Migration needs:** Confirm sheet needs localization. Swipe hint needs localization. State transitions need culturally appropriate feedback.

### 8.4 Understanding Safe-to-Spend

```
Dashboard → See S2S hero number → [curious about math?] →
  Tap number → HelmCalculationTrace opens →
    Shows: Total received (BDT) - Fixed costs - Buffer = S2S →
    Each row labeled, right-aligned mono numbers →
  Close sheet → return to dashboard
```

**Migration needs:** Trace row labels need localization. BDT formatting must use lakh/crore.

### 8.5 Handling Low-Money States

```
Dashboard → S2S shows tight/atRisk →
  Ledger Rail color changes (amber/brick) →
  NextBestActionCard shows context-aware guidance →
    "overdue" variant: "X entries overdue" with Pipeline CTA →
    "atRisk" variant: "Your safe amount is under pressure" →
  Analytics fires stsAtRiskEntered / reserveDepleted
```

**Migration needs:** NBA card copy needs localization. Emotional tone must be "honest but not alarming" per product doctrine.

### 8.6 Switching Language

```
Settings → Language toggle (en/bn) →
  App rebuilds with new locale →
  All strings switch to Bangla/English →
  Typography tokens switch to Hind Siliguri / Inter →
  Number formatting remains BDT lakh/crore (locale-independent)
```

**Migration needs:** This journey DOES NOT WORK currently. No runtime localization exists. This is the highest-priority migration gap.

### 8.7 Returning After Long Absence

```
App launch → PIN Entry → [correct PIN] → Dashboard →
  S2S recomputed from stored data →
  Nudge evaluator runs →
  If overdue entries exist → NBA card shows overdue variant →
  Affirmation computed based on session count + overdue state
```

**Migration needs:** Return experience should show relevant state immediately. No loading walls. Trust Strip timestamp helps user orient ("last updated X").

---

## 9. Target Component Architecture

### 9.1 Existing Components (Retain)

| Component | File | Responsibility | Changes Needed |
|---|---|---|---|
| HelmAmount | `helm_amount.dart` | BDT/USD display with JetBrains Mono | Add `compact` param for tight contexts |
| HelmFxEstimate | `helm_fx_estimate.dart` | Dual-currency FX display | **Fix: use NumberFormatter, not raw NumberFormat** |
| HelmTrustStrip | `helm_trust_strip.dart` | Proof-of-calculation strip | Localize labels |
| HelmMoneySourceLabel | `helm_money_source_label.dart` | Payment source pill | **Add Semantics** |
| HelmLedgerRail | `helm_ledger_rail.dart` | State color bar (safe/tight/atRisk) | None — well-built |
| HelmRealityStack | `helm_reality_stack.dart` | 4-tier home scaffold | None — well-built |
| HelmCalculationTrace | `helm_calculation_trace.dart` | S2S breakdown sheet | Localize row labels |
| HelmLedgerCard | `cards/helm_ledger_card.dart` | Standard money card | None — well-built |
| HelmCautionCard | `cards/helm_caution_card.dart` | Warning card with rail | **Add Semantics** |
| HelmHeroZone | `cards/helm_hero_zone.dart` | S2S hero container | **Add Semantics** |
| HelmSourceCard | `cards/helm_source_card.dart` | Pipeline source card | **Fix: use NumberFormatter; add Semantics** |
| HelmAuditCard | `cards/helm_audit_card.dart` | Ledger-style trace card | None — well-built |
| AppButton | `buttons/button_multiple_types.dart` | Primary/secondary/outline button | None — well-built |
| HelmToast | `helm_toast.dart` | Border-signaled toast | Localize messages |
| NextBestActionCard | `next_best_action_card.dart` | Context-aware action card | Localize all 4 variants |
| HelmShimmer | `shimmer/helm_shimmer.dart` | Loading skeleton | **Add Semantics; respect reduced motion** |

### 9.2 Components to Consolidate

| New Component | Replaces | Reason |
|---|---|---|
| None proposed | CommittedSection + ReserveSection + NotCountedSection | **Decision: Do NOT abstract.** The 200 LOC duplication is acceptable. Each section has distinct financial semantics. Premature abstraction would couple unrelated concerns. |

### 9.3 Components to Remove

| Component | File | Reason |
|---|---|---|
| Duplicate OnboardingHeader | `progress_bar/linear_progress_bar.dart` | Identical copy of `skip_button.dart` version |
| `AppColors` | `colors.dart` | Deprecated re-export. Remove after confirming zero direct imports. |
| `getFontStyle()` | `app_theme.dart:171-184` | Legacy. Remove after confirming zero callers. |
| `AppThemeData` | `app_theme.dart:158-163` | Legacy. Remove after `main.dart` migrated to `AppTheme.light/dark`. |

### 9.4 New Components Needed

| Component | Responsibility | Priority |
|---|---|---|
| **HelmLocaleText** | Locale-aware text widget that auto-selects Bangla/Inter typography based on active locale | Phase 1 |
| **HelmEmptyState** | Standardized empty-state pattern: icon + message + optional CTA, localized | Phase 2 |
| **HelmFormField** | Token-compliant text field with currency-aware validation, monospace for amounts | Phase 4 |

Minimal new components. The existing widget system is well-designed. The migration is primarily about **fixing inconsistencies and adding localization**, not creating new abstractions.

---

## 10. Token Migration Plan

### 10.1 Tokens to Retain (No Changes)

All 13 HelmColors, all 18 HelmTypography styles, all HelmSpacing constants, all HelmMotion constants.

### 10.2 Tokens Requiring Refinement (Optional, Phase 6)

| Token | Current | Potential Refinement | Reason |
|---|---|---|---|
| `canvas` | `#FAFAF6` | `#FAF8F2` (warmer) | Native Ground warmth shift — test on device first |
| `interactive` | `#255E5B` | `#2A5E55` (warmer teal) | Native Ground warmth — test contrast first |

**Decision:** Token refinement is **deferred to Phase 6 (Hardening)**. Current values are well-tuned with WCAG AA+ contrast. Changes are cosmetic, not structural.

### 10.3 Tokens to Deprecate

| Token/API | File | Deprecation Method | Removal Phase |
|---|---|---|---|
| `AppColors.*` | `colors.dart` | `@Deprecated` annotation already present | Phase 1 |
| `getFontStyle()` | `app_theme.dart` | Find-and-replace callers → `context.textStyles.*` | Phase 1 |
| `AppThemeData` | `app_theme.dart` | Update `main.dart` to use `AppTheme.light/dark` | Phase 1 |

### 10.4 New Tokens Needed

None. The existing token system is complete for Warm Ledger + Native Ground.

### 10.5 Migration Linting Rules

During migration, enforce:
1. No new imports of `colors.dart` (use `helm_colors.dart`)
2. No new calls to `getFontStyle()` (use `context.textStyles.*`)
3. No hardcoded color hex values (use `context.colors.*`)
4. No hardcoded English strings in widget `build()` methods (use ARB keys)
5. All `NumberFormat` calls must go through `NumberFormatter`

---

## 11. Screen-by-Screen Migration Matrix

| Screen | Phase | Token Fix | Localize | A11y Fix | Widget Fix | Complexity | Risk |
|---|---|---|---|---|---|---|---|
| Dashboard | 3 | Minor | 15 strings | Add Semantics to 3 sub-widgets | Fix DateTime.now() in hero | MEDIUM | HIGH (core value screen) |
| S2sHeroBlock | 3 | None | 3 strings | Already good | None | LOW | HIGH |
| CommittedSection | 3 | None | 4 strings | Add Semantics | None | LOW | MEDIUM |
| ReserveSection | 3 | None | 3 strings | Add Semantics | None | LOW | LOW |
| NotCountedSection | 3 | None | 5 strings | Add Semantics | None | LOW | LOW |
| NextBestActionCard | 3 | None | 12 strings (4 variants x 3) | Already good | None | MEDIUM | MEDIUM |
| HelmCalculationTrace | 3 | None | 8 strings | Already good | None | MEDIUM | MEDIUM |
| PipelineScreen | 4 | None | 8 strings | Add Semantics | None | MEDIUM | MEDIUM |
| PipelineEntryCard | 4 | Fix `_formatAmount` | 6 strings | Add Semantics | None | MEDIUM | MEDIUM |
| ConfirmReceivedSheet | 4 | None | 12 strings | Add Semantics | None | HIGH | MEDIUM |
| AddIncomeScreen | 4 | None | 20 strings | Add Semantics | None | HIGH | LOW |
| AddTransactionScreen | 5 | Fix legacy patterns | 15 strings | Add Semantics | None | MEDIUM | LOW |
| IncomeListScreen | 4 | None | 6 strings | Add Semantics | None | MEDIUM | LOW |
| OnboardingScreen (all pages) | 5 | None | 40+ strings | Review | None | HIGH | MEDIUM |
| WelcomeScreen | 5 | None | 5 strings | Review | None | LOW | LOW |
| MagicLinkScreen | 5 | None | 8 strings | Review | None | LOW | LOW |
| PinSetupScreen | 5 | None | 6 strings | Review | None | LOW | LOW |
| PinEntryScreen | 5 | None | 6 strings | Review | None | LOW | LOW |
| StsSettingsScreen | 5 | None | 10 strings | Review | None | MEDIUM | LOW |
| AuditLogScreen | 5 | None | 5 strings | Review | None | LOW | LOW |
| DeleteAccountScreen | 5 | None | 8 strings | Review | None | LOW | LOW |
| ExportScreen | 5 | None | 6 strings | Review | None | LOW | LOW |
| NotificationCenterScreen | 5 | None | 5 strings | Review | None | LOW | LOW |
| HelmFxEstimate | 2 | **Fix NumberFormatter** | 1 string | None | None | LOW | LOW |
| HelmSourceCard | 2 | **Fix _formatAmount** | None | **Add Semantics** | None | LOW | LOW |
| HelmShimmer | 2 | None | None | **Add Semantics; reduced motion** | None | LOW | LOW |
| HelmMoneySourceLabel | 2 | None | None | **Add Semantics** | None | LOW | LOW |

---

## 12. Phased Implementation Roadmap

### Phase 1: Foundation (Week 1, Days 1-3)

**Objective:** Eliminate dual design system. Establish localization infrastructure.

**Scope:**
- [ ] Remove deprecated `AppColors` re-export after confirming zero direct imports
- [ ] Remove `getFontStyle()` after migrating any remaining callers
- [ ] Update `main.dart` to use `AppTheme.light/dark` directly
- [ ] Remove `AppThemeData` legacy wrapper
- [ ] Remove duplicate `OnboardingHeader` in `linear_progress_bar.dart`
- [ ] Verify existing ARB infrastructure works (`lib/l10n/app_en.arb` — 121 keys, `app_bn.arb` — 114 keys)
- [ ] Add missing 7 Bangla translations to `app_bn.arb`
- [ ] Audit existing ARB keys vs hardcoded strings to identify coverage gaps
- [ ] Create `HelmLocaleText` widget for auto-selecting Bangla typography
- [ ] Establish localization lint rule: no hardcoded strings in `build()` methods

**Prerequisites:** None
**Deliverables:** Single authoritative design system. Localization infrastructure ready.
**Verification:** `dart analyze` clean. All 44 test files pass (347 cases). No `AppColors` or `getFontStyle` imports remain.
**Rollback:** Revert git commits. Zero user-facing risk.
**Definition of Done:** Zero deprecated API usage. ARB coverage gaps documented. `context.l10n` accessible on all screens.

### Phase 2: Shared Component Fixes (Week 1, Days 3-5)

**Objective:** Fix all known widget-level issues before screen migration.

**Scope:**
- [ ] Fix `HelmFxEstimate` to use `NumberFormatter.formatBDT()` instead of raw NumberFormat
- [ ] Fix `HelmSourceCard._formatAmount()` to use `NumberFormatter`
- [ ] Fix `PipelineEntryCard._formatAmount()` to use `NumberFormatter`
- [ ] Add `Semantics` to `HelmShimmer` (loading state label)
- [ ] Add reduced-motion check to `HelmShimmer`
- [ ] Add `Semantics` to `HelmMoneySourceLabel`
- [ ] Add `Semantics` to `HelmSourceCard`
- [ ] Add `Semantics` to `HelmHeroZone`
- [ ] Add `Semantics` to `HelmCautionCard`
- [ ] Add `disableAnimations` check to `OnboardingHeader` / `OnboardingProgressLine`

**Prerequisites:** Phase 1 complete
**Deliverables:** All 19 core widgets at 100% token compliance and 100% accessibility.
**Verification:** Widget tests pass. Manual screen-reader test on 3 key screens.
**Rollback:** Revert individual widget commits. Each fix is independent.
**Definition of Done:** All widgets pass token compliance audit. No formatting bypasses.

### Phase 3: Core Value Journey (Week 2)

**Objective:** Migrate the most important screen — Dashboard and S2S presentation.

**Scope:**
- [ ] Localize Dashboard screen (15 strings → ARB)
- [ ] Localize S2sHeroBlock (3 strings)
- [ ] Localize CommittedSection, ReserveSection, NotCountedSection
- [ ] Localize NextBestActionCard (all 4 variants)
- [ ] Localize HelmCalculationTrace row labels
- [ ] Localize HelmTrustStrip labels
- [ ] Add Semantics to dashboard sub-widgets
- [ ] Fix `S2sHeroBlock` to use actual data timestamp instead of `DateTime.now()`
- [ ] Write Bangla versions of all dashboard strings (native speaker review required)
- [ ] Test Reality Stack with Bangla labels for overflow

**Prerequisites:** Phase 2 complete (widget fixes)
**Deliverables:** Dashboard fully localized en/bn. S2S presentation is the reference for all subsequent screens.
**Verification:** Widget tests. Golden tests for S2S hero in both locales. Manual Bangla overflow check.
**Rollback:** Revert localization commits. Original English strings preserved as `app_en.arb` defaults.
**Definition of Done:** Dashboard renders correctly in en and bn. All strings from ARB. Zero hardcoded text.

### Phase 4: Income System (Week 3, Days 1-3)

**Objective:** Migrate pipeline screens — the second most important user journey.

**Scope:**
- [ ] Localize PipelineScreen
- [ ] Localize PipelineEntryCard
- [ ] Localize ConfirmReceivedSheet
- [ ] Localize AddIncomeScreen
- [ ] Localize IncomeListScreen
- [ ] Add Semantics to pipeline widgets
- [ ] Test pipeline state transitions with Bangla labels
- [ ] Test ConfirmReceivedSheet form with Bangla labels for overflow

**Prerequisites:** Phase 3 complete (dashboard migration established the pattern)
**Deliverables:** Full income journey localized en/bn.
**Verification:** Widget tests. Manual test of add → confirm → receive flow in both locales.
**Rollback:** Revert per-screen. Each screen migration is independent.
**Definition of Done:** Pipeline journey works in en and bn. Zero hardcoded strings.

### Phase 5: Supporting Journeys (Week 3, Days 3-5 + Week 4 Day 1)

**Objective:** Migrate all remaining screens.

**Scope:**
- [ ] Localize AddTransactionScreen + fix legacy patterns
- [ ] Localize OnboardingScreen (all 6 pages — largest localization effort)
- [ ] Localize WelcomeScreen
- [ ] Localize MagicLinkScreen
- [ ] Localize PinSetupScreen + PinEntryScreen
- [ ] Localize StsSettingsScreen
- [ ] Localize AuditLogScreen, DeleteAccountScreen, ExportScreen
- [ ] Localize NotificationCenterScreen

**Prerequisites:** Phase 4 complete
**Deliverables:** Every screen in the app localized.
**Verification:** Smoke test every route in both locales.
**Rollback:** Revert per-screen.
**Definition of Done:** Zero hardcoded English strings in any `build()` method.

### Phase 6: Hardening (Week 4)

**Objective:** Polish, test, and verify the complete migration.

**Scope:**
- [ ] Dark mode verification (all screens render correctly)
- [ ] Accessibility audit (Semantics coverage, contrast check, touch target verification)
- [ ] Bangla overflow testing (every screen, every financial state)
- [ ] Financial-state scenario testing (safe/tight/atRisk/noData x en/bn)
- [ ] Performance profiling on Samsung A14-class device (if available)
- [ ] Golden test suite creation for key screens
- [ ] Optional: token color warmth tuning for Native Ground
- [ ] Remove any remaining TODO comments related to migration
- [ ] Final `dart analyze` clean pass

**Prerequisites:** Phase 5 complete
**Deliverables:** Production-ready migrated app.
**Verification:** Full verification matrix (Section 14).
**Rollback:** Individual fixes. The app is releasable at Phase 5 completion.
**Definition of Done:** All items in Section 21.

---

## 13. Dependency Graph

```
Phase 1 (Foundation)
    │
    ▼
Phase 2 (Widget Fixes) ──── independent of Phase 3+
    │
    ▼
Phase 3 (Dashboard) ──── establishes localization pattern
    │
    ├──▶ Phase 4 (Income) ──── follows Phase 3 pattern
    │         │
    │         ▼
    └──▶ Phase 5 (Supporting) ──── follows Phase 3 pattern
              │
              ▼
         Phase 6 (Hardening)
```

**Critical path:** Phase 1 → Phase 2 → Phase 3 → Phase 4 → Phase 5 → Phase 6

**Parallelizable:** Phase 4 and Phase 5 screens are independent of each other (but both depend on Phase 3 for the established pattern).

---

## 14. Verification and Test Strategy

### 14.1 Widget Tests

- Every localized screen gets a widget test verifying ARB key rendering
- Every Semantics addition gets a `find.bySemanticsLabel()` test
- NumberFormatter consistency tests for all fixed formatting callsites

### 14.2 Golden Tests

Create golden screenshots for:
- Dashboard in `safe` state (en + bn)
- Dashboard in `atRisk` state (en + bn)
- Dashboard empty state (en + bn)
- S2S Calculation Trace sheet (en + bn)
- Pipeline entry card in each state (expected/pending/received)

### 14.3 Financial-State Scenario Matrix

| Scenario | S2S State | Ledger Rail | NBA Variant | Trust Strip | Test Both Locales |
|---|---|---|---|---|---|
| No income, no transactions | noData | hidden | setup | hidden | Yes |
| One received entry, no fixed costs | safe | green | relief | visible | Yes |
| Received + pending, with fixed costs | safe | green | relief | visible | Yes |
| Low S2S, buffer partially consumed | tight | amber | atRisk | visible | Yes |
| S2S <= 0 | atRisk | brick | atRisk | visible | Yes |
| Overdue expected entries | depends | depends | overdue | visible | Yes |
| All USD entries (no BDT received) | noData | hidden | setup | FX note | Yes |
| Very large BDT values (1,00,00,000+) | safe | green | relief | visible (overflow test) | Yes |

### 14.4 Localization Tests

- Every ARB key renders in en and bn
- Bangla text does not overflow containers
- Number formatting uses lakh/crore in both locales (locale-independent)
- Date formatting respects locale

### 14.5 Accessibility Tests

- All financial amounts have Semantics labels
- All tappable elements have button semantics
- All loading states have "loading" labels
- All state indicators have text labels (not color-only)
- Reduced motion respected where applicable

---

## 15. Accessibility and Localization Strategy

### 15.1 Accessibility Targets

- **WCAG AA** contrast on all text (already achieved in current tokens)
- **Semantics on every interactive element** (7 widgets need fixes — Phase 2)
- **Reduced motion support** on all animations (2 widgets need fixes — Phase 2)
- **No color-only state signals** (Ledger Rail always has text label — already correct)
- **Touch targets >= 44pt** (AppButton already enforces; verify on new components)

### 15.2 Localization Architecture

```
lib/l10n/
├── app_en.arb          # English (source)
├── app_bn.arb          # Bangla
```

Access: `AppLocalizations.of(context)!.keyName` or `context.l10n.keyName` via extension.

**String naming convention:** `screenName_elementName_variant`
- Example: `dashboard_heroLabel`, `dashboard_nbaTitleOverdue`, `pipeline_confirmButton`

### 15.3 Bangla Typography Rules

- Use `bodyLgBn`/`bodyMdBn`/`bodySmBn`/`labelMdBn` when locale is `bn`
- Line height: 1.52-1.58 (vs 1.25-1.50 for Latin)
- Allow 20% more vertical space for Bangla containers
- Test every screen for overflow after localization

---

## 16. Performance Strategy

### 16.1 Current Performance Profile

**Excellent.** Zero `BackdropFilter`, zero spring physics, solid colors only. The Warm Ledger + Native Ground direction maintains this advantage.

### 16.2 Performance Constraints

| Constraint | Limit | Current Status |
|---|---|---|
| Frame time P50 | < 8ms (60fps) | Expected clean |
| Frame time P95 | < 16ms | Expected clean |
| S2S time-to-visible | < 2 seconds | Tracked via analytics (P4.4) |
| App cold start | < 3 seconds | Hive init + auth check |
| No BackdropFilter | Enforced | Clean |
| No spring physics | Enforced | Clean |

### 16.3 Performance Budget for Migration

The migration adds:
- ARB string lookup (negligible — cached at build time)
- Locale-aware typography selection (one `if` per widget — negligible)
- 7 additional Semantics widgets (negligible)

**Expected performance impact of migration: Zero measurable difference.**

---

## 17. Rollback and Release-Safety Strategy

### 17.1 Rollback Architecture

Each phase produces git commits that can be reverted independently:
- **Phase 1:** Legacy API removal + localization infrastructure
- **Phase 2:** Per-widget fix commits (each widget independent)
- **Phase 3-5:** Per-screen localization commits
- **Phase 6:** Hardening commits

### 17.2 Release Safety

The app is **releasable at every phase boundary**:
- After Phase 1: English-only, single design system (**better than current**)
- After Phase 2: English-only, all widgets fixed (**better than Phase 1**)
- After Phase 3: Dashboard localized, rest English (**releasable**)
- After Phase 4: Dashboard + Pipeline localized (**releasable**)
- After Phase 5: Fully localized (**releasable**)
- After Phase 6: Fully verified (**production-ready**)

### 17.3 Play Console Considerations

- No new permissions required
- No new packages required (flutter_localizations is already a Flutter SDK dependency)
- No database schema changes
- No Hive box changes

---

## 18. Risks and Mitigations

### 18.1 Risk Matrix

| # | Risk | Likelihood | Impact | Detection | Prevention | Recovery |
|---|---|---|---|---|---|---|
| R1 | Breaking S2S calculation while changing presentation | LOW | CRITICAL | Widget tests + golden tests | UI changes only — never touch domain/data layer | Revert presentation commits; domain untouched |
| R2 | Bangla text overflow in containers | MEDIUM | HIGH | Bangla overflow tests per screen | 20% vertical buffer; test every screen | Fix container constraints per-screen |
| R3 | Inconsistent partial migration | MEDIUM | MEDIUM | Phase completion gates | Each phase has verification gate | Complete phase before starting next |
| R4 | Scope explosion (adding features during migration) | MEDIUM | HIGH | Phase scope boundaries | This plan explicitly lists included/excluded scope per phase | Reject non-migration changes during active phase |
| R5 | Bangla copy quality (translated vs. native) | MEDIUM | MEDIUM | Native speaker review | Write Bangla-first, not translate from English | Revise copy with native speaker feedback |
| R6 | Dark mode regression | LOW | MEDIUM | Dark mode golden tests | Test both modes per screen | Fix per-screen |
| R7 | Low-end Android rendering of warm tint | LOW | LOW | Device test in Phase 6 | Use solid hex values (no alpha on text) | Adjust token values |
| R8 | Test coverage gaps allow silent regression | MEDIUM | HIGH | Pre-migration test audit | Write golden tests in Phase 3 before modifying Dashboard | Add tests incrementally per phase |

### 18.2 Critical Risk: R1 — S2S Calculation Integrity

**The single most important risk.** S2S is the product's core value proposition.

**Mitigation protocol:**
1. NEVER modify files in `domain/` or `data/` layers during UI migration
2. NEVER modify Riverpod providers that compute S2S
3. All widget tests must assert S2S values match expected computation
4. Calculation Trace must be tested against known input → expected output

---

## 19. Unresolved Decisions

| # | Decision | Blocker For | Owner | Options |
|---|---|---|---|---|
| U1 | Should token warmth shift (canvas #FAFAF6 → #FAF8F2)? | Phase 6 only | Founder | A) Keep current values. B) Shift warmer. Test on device. |
| U2 | Native Bangla copy author — who writes the bn ARB? | Phase 3 | Founder | A) Founder writes. B) Hire native copywriter. C) AI-generated with founder review. |
| U3 | Should "Record cash out" screen be renamed? | Phase 5 | Founder | A) "Record expense". B) "Record payment". C) Keep for now. |
| U4 | Run user validation experiments before committing? | None (recommended but optional) | Founder | A) Run 4 experiments (8 hours). B) Skip, proceed with plan. |
| U5 | History tab — should it return? | Post-migration | Founder | Router has no `/history` route. Tab removed from shell. Product decision. |

---

## 20. Recommended First Implementation Slice

### The Slice

**Localize the S2S Hero Block + Calculation Trace in both en and bn.**

This single slice validates:
- ARB localization infrastructure works end-to-end
- Bangla typography at hero scale (64pt) renders correctly
- Bangla typography at body/label scale renders correctly
- JetBrains Mono financial figures are locale-independent
- NumberFormatter lakh/crore formatting works in both locales
- Trust Strip timestamp is locale-aware
- Calculation Trace row labels translate naturally
- Bangla text does not overflow hero zone or trace sheet containers

### Files Touched

1. `lib/l10n/app_en.arb` (add ~20 keys for hero + trace to existing 121)
2. `lib/l10n/app_bn.arb` (add ~20 keys to existing 114)
3. `lib/features/dashboard/presentation/widgets/s2s_hero_block.dart` (replace hardcoded strings)
4. `lib/core/widgets/helm_calculation_trace.dart` (replace hardcoded strings)
5. `lib/core/widgets/helm_trust_strip.dart` (replace hardcoded strings)

### What It Does NOT Touch

- No domain logic
- No provider changes
- No navigation changes
- No new dependencies
- No database changes

### Rollback Path

Revert 3 widget files. Remove ARB files. Zero blast radius.

### Success Criteria

1. `flutter test` passes
2. S2S hero renders correctly in English
3. S2S hero renders correctly in Bangla
4. Calculation Trace opens and shows Bangla labels
5. No Bangla text overflow
6. `dart analyze` clean

---

## 21. Definition of Done — Complete Migration

The migration is complete when ALL of the following are true:

### Design System

- [ ] Zero imports of deprecated `AppColors`, `getFontStyle()`, or `AppThemeData`
- [ ] All widgets use `context.colors` and `context.textStyles` exclusively
- [ ] All number formatting goes through `NumberFormatter`
- [ ] No hardcoded color hex values in widget files
- [ ] No hardcoded English strings in `build()` methods

### Localization

- [ ] Every user-facing string in `app_en.arb` and `app_bn.arb`
- [ ] Bangla typography tokens (`bodyLgBn`, etc.) used when locale is `bn`
- [ ] All screens render correctly in both en and bn
- [ ] No Bangla text overflow in any screen, any financial state
- [ ] Bangla copy reviewed by native speaker

### Accessibility

- [ ] Every widget with user interaction has Semantics
- [ ] Every financial amount has a semantic label
- [ ] Every loading state has a semantic label
- [ ] Reduced motion respected on all animations
- [ ] No color-only state indicators

### Testing

- [ ] Widget tests for all localized screens
- [ ] Golden tests for Dashboard (safe/tight/atRisk x en/bn)
- [ ] Golden tests for Calculation Trace (en/bn)
- [ ] Financial-state scenario matrix fully covered
- [ ] `dart analyze` 0/0/0

### Performance

- [ ] No `BackdropFilter` in any widget
- [ ] No spring physics in any animation
- [ ] No duration > 320ms in any animation
- [ ] S2S time-to-visible < 2 seconds (tracked via analytics)

### Release

- [ ] App builds and runs on Android
- [ ] App builds and runs on iOS
- [ ] No new package dependencies added without approval
- [ ] No database schema changes
- [ ] Releasable to Play Console

---

## Appendix A: File Counts

| Category | Count |
|---|---|
| Core shared widgets | 19 |
| Feature-specific widgets | 8 |
| Design token classes | 4 |
| Screens | 16 main + 6 onboarding pages = 22 |
| Routes | 15 |
| Existing ARB keys (en) | 121 (need ~80 more for full coverage) |
| Existing ARB keys (bn) | 114 (7 missing translations) |
| Test files | 44 (347 cases; zero golden tests) |
| Riverpod providers | 40+ across 11 files |
| Estimated migration effort | 25-35 hours across 4 weeks |

## Appendix B: Widget Token Compliance Summary (Pre-Migration)

| Metric | Current | Target |
|---|---|---|
| HelmColors usage | 18/19 (95%) | 19/19 (100%) |
| HelmTypography usage | 17/19 (89%) | 19/19 (100%) |
| Semantics coverage | 12/19 (63%) | 19/19 (100%) |
| Motion compliance | 16/19 (84%) | 19/19 (100%) |
| NumberFormatter usage | 16/19 (84%) | 19/19 (100%) |

---

*End of document. This plan is ready for founder review and implementation handoff.*
