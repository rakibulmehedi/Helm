# 12 - Conflicts and Overrides (Code vs Doctrine Gap Registry)

> Source: Codebase audit cross-referenced against Final Product Doctrine and POCKETA_BRAIN.md
> Date: 2026-06-04
> Method: Line-by-line comparison of implemented behavior against documented requirements
> Reference Doctrine: `docs/strategy/POCKETA_FINAL_PRODUCT_DOCTRINE.md` (canonical)

---

## 1. Onboarding Gaps

### GAP-001: Onboarding Is Generic Carousel, Not Conversational
- **Doctrine requirement (S4, #2):** "3-minute conversational onboarding (NOT a form)" that captures fixed costs, default buffer %, single income pattern
- **Code reality:** `onboarding_screen.dart:37-41` -- Three hardcoded swipe pages with text: "Track your expenses", "Set your budget", "Achieve financial freedom"
- **Gap:** Zero data collection. No conversational flow. No fixed costs capture. No buffer setup. No income pattern input. Merely a carousel of motivational text.
- **Severity:** MVP-blocking

### GAP-002: Onboarding Copy Conflicts With Product Identity
- **Doctrine (S1):** Pocketa is "NOT a budgeting app" and "NOT a backward-looking expense tracker"
- **Code reality:**
  - `onboarding_screen.dart:38` -- "Track your expenses" (expense tracker language)
  - `onboarding_screen.dart:39` -- "Set your budget" (budgeting app language)
  - `onboarding_screen.dart:40` -- "Achieve financial freedom" (generic fintech platitude)
- **Gap:** All three copy lines position Pocketa as exactly what the Doctrine says it is NOT
- **Severity:** Identity-breaking

### GAP-003: Welcome Screen Copy Conflicts With Product Identity
- **Doctrine (S1):** "single-purpose calm cockpit for Bangladeshi USD-earning freelancers"
- **Code reality:**
  - `app_en.arb:5` -- tagLine: "Your pocket accountant for Smart budgeting"
  - `app_bn.arb:5` -- Bangla equivalent of same
- **Gap:** "pocket accountant" and "Smart budgeting" are generic expense tracker positioning, not freelancer cashflow clarity
- **Severity:** Identity-breaking

### GAP-004: Onboarding Header Step Mismatch
- **Code reality:** `onboarding_screen.dart:50` -- `OnboardingHeader(totalSteps: 4)` but only 3 pages in PageView (`onboardingTexts.length == 3`)
- **Gap:** Progress bar shows 4 steps but only 3 exist. UI inconsistency.
- **Severity:** Low (cosmetic bug)

### GAP-005: Stub Onboarding Pages Never Wired
- **Code reality:** Three page files exist under `pages/` directory:
  - `set_budget_categories.dart` -- empty (1 line)
  - `set_currency_and_earning_range.dart` -- empty (1 line)
  - `set_income_source.dart` -- single import line, no class
- **Gap:** Files were created for a planned conversational flow but never implemented. OnboardingScreen does not reference them.
- **Severity:** Dead code / incomplete intent

---

## 2. Dashboard Gaps

### GAP-006: No Dashboard State Colors (Safe / Tight / At Risk)
- **Doctrine (S5, V1 #6):** Dashboard state colors: Safe / Tight / At Risk
- **Code reality:** `safe_to_spend_hero.dart:54-63` -- Three states exist but use generic labels:
  - Normal: "Safe to spend" (default text color)
  - Negative: "In reserve mode" (amber warning)
  - Zero: "Fully allocated" (secondary text)
- **Gap:** No green/yellow/red state coloring system. No "Safe" / "Tight" / "At Risk" labels. This is noted as V1 in doctrine but the hero widget currently has no architecture for it.
- **Severity:** V1 scope (not MVP-blocking per doctrine)

### GAP-007: Horizon Number Computed But Never Displayed
- **Code reality:** `safe_to_spend_calculator.dart:66` -- `horizonNumber = safeToSpend + (pending * 0.8) + (expected * 0.3)` computed in every calculation
- **Gap:** Value exists in `SafeToSpendResult` but no widget reads or displays it. Wasted computation unless future UI uses it.
- **Severity:** Low (wasted compute, no user impact)

### GAP-008: Dev-Only Reset Button Visible In Production
- **Code reality:** `dashboard_screen.dart:100-108` -- Reset onboarding button with tooltip "Reset onboarding (dev only)" visible in AppBar
- **Gap:** No conditional gate (e.g., `kDebugMode` check). Will be visible to all users in production builds.
- **Severity:** Medium (UX issue, not functional breakage)

---

## 3. Safe-to-Spend Gaps

### GAP-009: Anxiety Buffer Is Absolute BDT Amount, Not Percentage
- **Doctrine (S4, #13):** "Default 15% safety buffer applied to S2S. Hard floor at 5%; editable within range [5-30%]"
- **Code reality:**
  - `sts_settings.dart:9` -- `anxietyBuffer` is `double` defaulting to `0.0` (BDT absolute)
  - `sts_settings_screen.dart:130-158` -- TextFormField for BDT amount with "taka" prefix
  - `safe_to_spend_calculator.dart:62` -- Subtracted as absolute value: `liquidCash - taxReserve - fixedCostsDue - settings.anxietyBuffer`
- **Gap:** Buffer is an absolute BDT amount (e.g., 5000 taka), NOT a percentage of income. Default is 0, not 15%. No 5-30% range enforcement. Fundamentally different mechanism than what Doctrine specifies.
- **Severity:** MVP-blocking (doctrine says "non-negotiable")

### GAP-010: No "---" Fallback On Calc Failure
- **Doctrine (S4, #14):** "NEVER show a wrong number" -- display "---" when S2S calculation fails or inputs are stale
- **Code reality:**
  - `safe_to_spend_hero.dart:47-49` -- When `totalReceivedIncomeBdt == 0`, shows "Add income to start" (not "---")
  - Calculator has no error/failure state -- always returns a result
  - No `try/catch` around the calculation display
- **Gap:** No explicit failure/stale state. If inputs are corrupt or calc throws, the app would crash rather than show "---"
- **Severity:** Medium (trust issue per doctrine)

### GAP-011: Tax Reserve In MVP Contradicts Doctrine
- **Doctrine (S4, excluded table):** "Tax reserve -- Tax ambiguity = trust bomb; V2 only"
- **Doctrine (S6, V2 #4):** "Tax Reserve (user-declared %, NOT algorithmic)"
- **Code reality:**
  - `sts_settings.dart:6` -- `taxRate` field exists, default 10%
  - `sts_settings_screen.dart:85-118` -- Tax rate slider (0-40%) labeled "Tax Reserve Rate"
  - `safe_to_spend_calculator.dart:52` -- `taxReserve = totalReceivedIncomeBdt * settings.taxRate`
- **Gap:** Tax reserve is actively implemented in MVP but doctrine explicitly excludes it from MVP. Gap analysis doc notes "Keep as-is, rename to avoid confusion" but the feature directly contradicts doctrine exclusion list.
- **Severity:** Doctrine conflict (acknowledged by team as intentional deviation -- see DOCTRINE_TO_CODE_GAP_ANALYSIS.md Section 3)

---

## 4. Income Pipeline Gaps

### GAP-012: No Per-Entry FX Rate Field
- **Doctrine (S4, #9):** "Editable inputs (FX rate per entry, expected date, exclude entry)"
- **Code reality:**
  - `income_entry_entity.dart` -- No `fxRate` field
  - `income_model.dart` -- No `fxRate` HiveField
  - `add_income_screen.dart` -- No FX rate input in form
- **Gap:** Currency is BDT/USD display-only label. No FX rate per entry. No way to record what rate was used for conversion.
- **Severity:** MVP-blocking per doctrine

### GAP-013: No Exclude-Entry Toggle Per Pipeline Entry
- **Doctrine (S4, #9):** "Editable inputs (...exclude entry)"
- **Code reality:** No `isExcluded` field on IncomeEntryEntity. USD entries auto-excluded by calculator (`safe_to_spend_calculator.dart:33-35`) but user cannot manually exclude any BDT entry.
- **Gap:** No user-facing toggle to exclude specific income entries from STS calculation
- **Severity:** MVP-blocking per doctrine

### GAP-014: Pipeline Summary Only Shows Current Month
- **Code reality:** `income_pipeline_summary.dart:56-68` -- Totals filtered by `_isSameMonth(date, now)` for current calendar month only
- **Gap:** No way to view pipeline for past or future months from dashboard. Income list shows all entries (no month filter), but dashboard summary is locked to current month.
- **Severity:** Low (design decision, not a doctrine violation)

---

## 5. Auth & Trust Layer Gaps

### GAP-015: No Authentication System
- **Doctrine (S4, #1):** "Magic Link auth + mandatory PIN/biometric on app open -- Finance trust floor; non-negotiable"
- **Code reality:** Zero auth infrastructure. No login screen, no PIN, no biometric, no magic link, no auth routes, no auth feature directory, no auth state.
- **Gap:** Complete absence. The most critical trust feature does not exist.
- **Severity:** MVP-blocking (doctrine says "non-negotiable")

### GAP-016: No Audit Log
- **Doctrine (S4, #10):** "Audit log on every financial edit -- Trust + dispute defense"
- **Code reality:** No audit log entity, model, provider, or storage. Financial edits (income updates, transaction edits, STS settings changes) leave no trail.
- **Gap:** Complete absence. No event sourcing, no edit history, no change tracking.
- **Severity:** MVP-blocking

### GAP-017: No CSV Data Export
- **Doctrine (S4, #11):** "Data export (CSV) -- Trust hygiene; portability"
- **Code reality:** No export functionality. No CSV generation. No share/download mechanism.
- **Gap:** Complete absence.
- **Severity:** MVP-blocking

### GAP-018: No Account Deletion
- **Doctrine (S4, #12):** "Account deletion (full purge) -- Trust hygiene; required from Day 1"
- **Code reality:** No account management screen. No deletion flow. No data purge mechanism (beyond the dev reset button which only clears onboarding flag).
- **Gap:** Complete absence.
- **Severity:** MVP-blocking

### GAP-019: No Closed-Beta Instrumentation
- **Doctrine (S4, #15):** "Closed-beta instrumentation (override-equivalent rate, update compliance, retention)"
- **Doctrine (S16):** 9+ event types required for beta evaluation
- **Code reality:** Zero analytics. No event tracking. No telemetry. No instrumentation hooks.
- **Gap:** Complete absence.
- **Severity:** Beta-blocking

---

## 6. Visual Identity & Theming Gaps

### GAP-020: No Documented Design System Colors
- **Code reality:** `colors.dart` defines 21 color constants with specific hex values
- **Gap:** No UX/design doc specifies what these colors should be. Current colors appear to be developer-chosen defaults. No brand guideline verification. No accessibility audit (contrast ratios not validated).
- **Severity:** Low (functional but unvalidated)

### GAP-021: Secondary Color Never Used In App
- **Code reality:** `colors.dart:9-11` defines `secondary` (#F57C00), `secondaryLight`, `secondaryDark` (orange palette)
- Grep across codebase: secondary color is defined but not referenced by any widget or theme definition
- **Gap:** Dead color definitions. Theme uses primary blue exclusively.
- **Severity:** Negligible (dead code)

### GAP-022: Typography Partially Hardcoded
- **Code reality:** `app_theme.dart` defines Poppins/Noto Sans Bengali via `getFontStyle()` in the theme
- Many widgets override with inline `TextStyle` (e.g., `onboarding_screen.dart:85-89`, `splash_screen.dart:81-84`) using raw font sizes not from theme
- **Gap:** Inconsistent typography application. Splash and onboarding bypass the theme system.
- **Severity:** Low (cosmetic inconsistency)

### GAP-023: Dark Mode Toggle Exists But Has No UI
- **Code reality:** `shared_pref_service.dart:31-37` stores `is_dark_mode` flag. `app_theme.dart` has full dark theme. Welcome/onboarding read `getIsDarkMode()`.
- **Gap:** No settings screen or toggle exists to let users switch between light/dark mode. Flag defaults to false (light). Only changeable programmatically.
- **Severity:** Low (feature exists but inaccessible)

---

## 7. Localization Gaps

### GAP-024: Most UI Text Is Hardcoded English
- **Code reality:** Only 3 strings are localized (welcomeMessage, tagLine, getStarted). All other UI text is hardcoded:
  - Onboarding pages: hardcoded English (`onboarding_screen.dart:38-40`)
  - Dashboard labels: "Pocketa", "Income", "Expense", "Recent Transactions" -- hardcoded
  - STS labels: "Safe to spend", "In reserve mode", "Fully allocated" -- hardcoded
  - Pipeline: "Income Pipeline", "Received", "Pending", "Expected" -- hardcoded
  - Settings: "Tax Reserve Rate", "Anxiety Buffer", "Fixed Costs" -- hardcoded
- **Gap:** App is functionally English-only despite having l10n infrastructure and a Bangla ARB file
- **Severity:** Medium (breaks Bangla user experience)

---

## 8. Architecture & Code Quality Gaps

### GAP-025: Dashboard File Exceeds 300-Line Limit
- **Code reality:** `dashboard_screen.dart` is 620+ lines (checked through line 620 and still contains widgets)
- **Architecture rule (ARCHITECTURE_RULES.md):** "Keep files under 300 lines"
- **Gap:** Over 2x the limit. Contains DashboardScreen + 4 private widget classes (_FilterChip, _TransactionListItem, _SectionCard, _SummaryChip) all in one file.
- **Severity:** Medium (tech debt, rule violation)

### GAP-026: SafeToSpendHero File Exceeds 300-Line Limit
- **Code reality:** `safe_to_spend_hero.dart` is 407 lines
- **Gap:** 107 lines over the limit. Contains SafeToSpendHero + _BreakdownRow + bottom sheet builder all in one file.
- **Severity:** Medium (tech debt)

### GAP-027: Income Pipeline Summary at 313 Lines
- **Code reality:** `income_pipeline_summary.dart` is 313 lines
- **Gap:** Slightly over the 300-line limit. Contains IncomePipelineSummary + _StatusRow.
- **Severity:** Low (marginal)

### GAP-028: Transaction Type Selector Hard-Locked to Expense
- **Code reality:** `add_transaction_screen.dart:51` -- `final TransactionType _selectedType = TransactionType.expense`
- **Gap:** The `TransactionType.income` enum value exists but cannot be selected from UI. The field is `final`, not user-changeable. This is intentional per Decision 015 (income moved to pipeline) but means the income enum value is dead code in the add-transaction flow.
- **Severity:** Negligible (intentional design)

---

## 9. Features In Code Not Mentioned In Docs

### GAP-029: Horizon Number Calculation
- **Code reality:** `safe_to_spend_calculator.dart:65-66` -- `horizonNumber = safeToSpend + (pending * 0.8) + (expected * 0.3)`
- **Gap:** Computed in every STS calculation and stored in result, but never displayed and not referenced in Final Doctrine MVP scope. May be intended for future use.
- **Severity:** Negligible (exists, no harm)

### GAP-030: Transaction Category System (Hardcoded)
- **Code reality:** `add_transaction_screen.dart:25-34` -- 8 hardcoded category strings: Food, Transport, Shopping, Bills, Entertainment, Health, Education, Other
- **Gap:** Doctrine does not mention expense categories at all. Categories box is defined in AppBoxNames but commented out in HiveService. Current implementation uses raw strings, not a category entity/model.
- **Severity:** Low (exists, functional, not specified in doctrine)

---

## 10. Stale/Outdated Implementations

### GAP-031: Onboarding Sub-page Architecture Is Dead
- **Files:** `set_budget_categories.dart`, `set_currency_and_earning_range.dart`, `set_income_source.dart`
- **Current state:** Empty stubs that were planned but never built
- **Gap:** These files suggest a planned conversational onboarding that was never implemented. The current OnboardingScreen uses inline pages instead.
- **Resolution needed:** Either implement these as part of conversational onboarding rebuild, or delete them

### GAP-032: Categories Box Never Opened
- **Code reality:** `app_box_names.dart:16` defines `categories` box name, `hive_service.dart:51` has `openBox` call commented out
- **Gap:** Category infrastructure was started in Phase 1 but never completed. Transactions use hardcoded string categories instead.
- **Resolution needed:** Either implement category model or remove dead references

### GAP-033: Legacy Income Type In Transaction System
- **Code reality:** `TransactionType.income` enum exists. Dashboard filters it out (`dashboard_screen.dart:77`). AddTransactionScreen locks to expense only.
- **Gap:** The income type is vestigial from pre-pipeline days. Decision 015 hid it but did not remove it from the enum or model.
- **Resolution needed:** Cannot remove from enum without Hive migration (existing data may reference it). Keep as-is.

---

## Summary Matrix

| Category | Items | MVP-Blocking | V1/V2 | Low/Cosmetic |
|----------|-------|-------------|-------|-------------|
| Onboarding | 5 gaps | 1 (GAP-001) | 0 | 4 |
| Dashboard | 3 gaps | 0 | 1 (GAP-006) | 2 |
| Safe-to-Spend | 3 gaps | 1 (GAP-009) | 0 | 2 |
| Income Pipeline | 3 gaps | 2 (GAP-012, GAP-013) | 0 | 1 |
| Auth & Trust | 5 gaps | 4 (GAP-015..018) | 0 | 1 |
| Visual/Theme | 4 gaps | 0 | 0 | 4 |
| Localization | 1 gap | 0 | 1 (GAP-024) | 0 |
| Code Quality | 4 gaps | 0 | 0 | 4 |
| Undocumented Features | 2 gaps | 0 | 0 | 2 |
| Stale Code | 3 gaps | 0 | 0 | 3 |
| **TOTAL** | **33 gaps** | **8** | **2** | **23** |

### MVP-Blocking Gaps (must resolve before MVP ship)
1. **GAP-001** -- Onboarding must become conversational and capture data
2. **GAP-009** -- Anxiety buffer must become percentage-based (15% default, 5-30% range)
3. **GAP-012** -- Per-entry FX rate field missing on income pipeline
4. **GAP-013** -- Per-entry exclude toggle missing on income pipeline
5. **GAP-015** -- Auth system completely missing (Magic Link + PIN/biometric)
6. **GAP-016** -- Audit log completely missing
7. **GAP-017** -- CSV export completely missing
8. **GAP-018** -- Account deletion completely missing
