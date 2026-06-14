# 11 - Implementation Atoms (Codebase Reality)

> Source: Codebase audit of `/Users/rakibulislammehedi/Helm-V2/lib/`
> Date: 2026-06-04
> Method: File-by-file read of all screens, widgets, entities, providers, routes, and theme definitions
> Scope: What the code actually does NOW -- not what docs say it should do

---

## 1. Navigation & Route Structure

### IMPL-001: Route Definitions
- **File:** `lib/config/router/route_names.dart:6-31`
- **Current state:** 10 route paths defined in `RouteNames` abstract class
  - Startup: `/` (splash), `/welcome`, `/onboarding`
  - Main: `/dashboard`
  - Transactions: `/add-transaction`, `/edit-transaction/:id`
  - Income: `/income`, `/add-income`, `/edit-income/:id`
  - STS: `/sts-settings`
- Reserved but commented out: `/transactions`, `/budget`, `/profile`
- No auth routes exist (no login, no PIN, no magic link)

### IMPL-002: Router Configuration
- **File:** `lib/config/router/app_router.dart:1-128`
- **Current state:** Single `GoRouter` instance with global redirect
- **Guard logic:**
  - If onboarding NOT completed: only allow splash, welcome, onboarding; all else redirects to `/welcome`
  - If onboarding IS completed: redirect splash and welcome to `/dashboard`
- **No auth guard** -- anyone past onboarding goes straight to dashboard
- Initial location: `/` (splash)
- Debug logging: disabled (`debugLogDiagnostics: false`)

### IMPL-003: Route Wiring
- **File:** `lib/config/router/app_router.dart:32-94`
- **Screens wired:**
  - `SplashScreen`, `WelcomeScreen`, `OnboardingScreen`, `DashboardScreen`
  - `AddTransactionScreen` (new + edit via `transactionId` param)
  - `IncomeListScreen` (with `initialFilter` via `state.extra`)
  - `AddIncomeScreen` (new + edit via `incomeId` param)
  - `StsSettingsScreen`
- Edit income has null/empty guard -- falls back to AddIncomeScreen

---

## 2. Splash Screen

### IMPL-004: SplashScreen
- **File:** `lib/features/splash/views/splash_screen.dart:1-103`
- **Current state:** Fade-in animation (1800ms) of centered "P" CircleAvatar + "Helm" text
- Background: `AppColors.primary` (solid blue #2453FF)
- Logo: White CircleAvatar (radius 40) with "P" character, fontSize 52
- After 2-second timer, navigates to `/welcome` (GoRouter redirect handles final destination)
- Uses `SingleTickerProviderStateMixin` for animation
- No loading indicator, no version number, no splash image asset

---

## 3. Welcome Screen

### IMPL-005: WelcomeScreen
- **File:** `lib/features/onboarding/presentation/views/welcome_screen.dart:1-93`
- **Current state:** Single-page welcome with centered layout
- Elements (top to bottom):
  1. Spacer
  2. CircleAvatar (radius 40, primary bg) with "P" letter
  3. "Helm" title text (bold, 32pt responsive)
  4. Spacer
  5. Welcome message (localized: "Welcome to Helm!")
  6. Tag line (localized: "Your pocket accountant for Smart budgeting")
  7. Spacer
  8. "Get Started" AppButton -> navigates to `/onboarding`
- Uses `ResponsiveUtilities` for padding and font sizing
- Dark/light mode: reads `SharedPrefServices.getIsDarkMode()`
- Localized strings (EN + BN) via `context.l10n`
- **Issue:** Tag line references "pocket accountant" and "Smart budgeting" -- conflicts with product identity

---

## 4. Onboarding Flow

### IMPL-006: OnboardingScreen
- **File:** `lib/features/onboarding/presentation/views/onboarding_screen.dart:1-163`
- **Current state:** 3-page horizontal PageView swipe carousel
- Page texts (hardcoded strings, NOT localized):
  1. "Track your expenses"
  2. "Set your budget"
  3. "Achieve financial freedom"
- Contains: `OnboardingHeader` (with progress bar, title empty), dot indicator, Back/Next buttons
- Back button: `AppButton` secondary type
- Next button: shows "Get Started" on last page, "Next" otherwise
- Completion: calls `SharedPrefServices.setOnboardingCompleted(true)` then navigates to `/dashboard`
- **No data collection** -- does not capture fixed costs, income sources, currency preference, buffer percentage, or any user profile information
- Header shows `totalSteps: 4` but only 3 pages exist (mismatch)

### IMPL-007: Onboarding Sub-pages (Stub Files)
- **Files:**
  - `lib/features/onboarding/presentation/views/pages/set_budget_categories.dart` -- 1 line (empty/stub)
  - `lib/features/onboarding/presentation/views/pages/set_currency_and_earning_range.dart` -- 1 line (empty/stub)
  - `lib/features/onboarding/presentation/views/pages/set_income_source.dart` -- 1 line (single import, no class)
- These files exist but contain no implementation
- Not referenced by `OnboardingScreen` (it uses inline text pages, not these sub-pages)

### IMPL-008: Onboarding State Provider
- **File:** `lib/features/onboarding/presentation/providers/onboarding_state_provider.dart:1-7`
- **Current state:** Single `StateProvider<bool>` wrapping `SharedPrefServices.getOnboardingCompleted()`
- No onboarding data model, no multi-step state tracking, no form state

---

## 5. Dashboard Screen

### IMPL-009: DashboardScreen Layout
- **File:** `lib/features/dashboard/presentation/views/dashboard_screen.dart:1-508`
- **Type:** `ConsumerStatefulWidget` (Riverpod-aware)
- **Layout (top to bottom):**
  1. AppBar: "Helm" title (left-aligned), reset-onboarding dev button (right)
  2. SafeToSpendHero widget (const)
  3. Income/Expense summary row (two `_SummaryChip` widgets side by side)
  4. IncomePipelineSummary widget
  5. "Recent Transactions" section header
  6. Filter chips row (All, Expense)
  7. Transaction list (grouped by date: Today, Yesterday, or formatted date)
- FAB: "+" button, navigates to `/add-transaction`
- Transaction totals: `totalIncome` from `stsResult.totalReceivedIncomeBdt`, `totalExpense` from `stsResult.totalExpenses`

### IMPL-010: Transaction Filter
- **File:** `lib/features/dashboard/presentation/views/dashboard_screen.dart:20`
- **Current state:** `TransactionFilter` enum with values: `all`, `expense`
- Legacy income transactions hidden by filtering out `TransactionType.income` (Decision 015)
- No "income" filter chip exposed to user

### IMPL-011: Transaction List Items
- **File:** `lib/features/dashboard/presentation/views/dashboard_screen.dart:374-508`
- **Current state:** `_TransactionListItem` widget
- Shows: icon (income/expense), title, categoryId, note (italic, 1 line), amount with +/- prefix, date
- Swipe-to-delete with Dismissible (endToStart) + Undo SnackBar
- Tap navigates to edit transaction route (using `pushNamed` with path parameter)
- Grouped by date (Today/Yesterday/formatted)

### IMPL-012: Summary Chips
- **File:** `lib/features/dashboard/presentation/views/dashboard_screen.dart:543-620`
- **Current state:** `_SummaryChip` widget showing label, icon, amount
- Income chip: green (`AppColors.success`), down arrow
- Expense chip: red (`AppColors.error`), up arrow
- Card-style container with border, shadow, rounded corners (14px)

### IMPL-013: Section Card
- **File:** `lib/features/dashboard/presentation/views/dashboard_screen.dart:510-541`
- **Current state:** Reusable card container used for empty transaction state
- Rounded corners (16px), border, shadow

### IMPL-014: Dev Reset Button
- **File:** `lib/features/dashboard/presentation/views/dashboard_screen.dart:100-108`
- **Current state:** Refresh icon in AppBar actions
- Tooltip: "Reset onboarding (dev only)"
- Resets onboarding flag and navigates to welcome screen
- **No production gate** -- visible to all users

---

## 6. Safe-to-Spend System

### IMPL-015: SafeToSpendHero Widget
- **File:** `lib/features/safe_to_spend/presentation/widgets/safe_to_spend_hero.dart:1-407`
- **Type:** `ConsumerWidget`
- **Display states:**
  1. **Empty state** (totalReceivedIncomeBdt == 0): Shows "Safe to spend" label + "Add income to start" text + settings gear
  2. **Active state**: Shows status label, formatted STS amount (36pt bold), info button, settings gear
- **Status labels and colors:**
  - Normal: "Safe to spend", default text color
  - Negative (rawSafeToSpend < 0): "In reserve mode", warning amber
  - Zero: "Fully allocated", secondary text
- **Info button** opens calculation breakdown bottom sheet
- **Settings gear** navigates to `/sts-settings`
- Container: card style, primary-tinted border (0.3 dark / 0.1 light), subtle primary shadow
- **No "---" fallback** for calc failure -- shows 0 or "Add income to start"

### IMPL-016: Breakdown Bottom Sheet
- **File:** `lib/features/safe_to_spend/presentation/widgets/safe_to_spend_hero.dart:165-342`
- **Title:** "How we calculate this"
- **Subtitle:** "A transparent breakdown of your liquid cash."
- **Breakdown rows:**
  1. Income Received (+, green)
  2. Expenses Deducted (-, secondary)
  3. Divider
  4. Estimated Tax Reserve (-)
  5. Fixed Costs Due (-)
  6. Anxiety Buffer (-, conditional: only if > 0)
  7. USD exclusion info row (conditional: if excludedUsdIncome > 0)
  8. Divider
  9. Safe to Spend (bold, warning color if raw < 0)
  10. Negative-balance info message (conditional)
- **Trust copy:** "Pending or expected income is intentionally excluded to protect your cashflow." (shield icon)
- Uses `_BreakdownRow` widget for each line item

### IMPL-017: SafeToSpendCalculator
- **File:** `lib/features/safe_to_spend/domain/safe_to_spend_calculator.dart:1-106`
- **Formula:** `safeToSpend = max(0, liquidCash - taxReserve - fixedCostsDue - anxietyBuffer)`
  - `liquidCash = totalReceivedIncomeBdt - totalExpenses`
  - `taxReserve = totalReceivedIncomeBdt * settings.taxRate`
  - `fixedCostsDue = sum of fixed costs due within next 30 days`
  - `anxietyBuffer = settings.anxietyBuffer` (absolute BDT amount)
- **Income rules:**
  - Only `IncomeStatus.received` + `currency == 'BDT'` counts toward `totalReceivedIncomeBdt`
  - `IncomeStatus.received` + `currency == 'USD'` tracked in `excludedUsdIncome` (excluded from STS)
  - Pending and expected tracked separately for horizon number only
- **Horizon Number:** `safeToSpend + (pending * 0.8) + (expected * 0.3)` -- computed but NOT displayed anywhere in current UI
- **Fixed cost window:** due day checked against next 30 days from `now`
- Clamped to 0 minimum for display (`safeToSpend`), raw value preserved (`rawSafeToSpend`)
- Pure static method, no side effects, no persistence

### IMPL-018: SafeToSpendResult Entity
- **File:** `lib/features/safe_to_spend/domain/entities/safe_to_spend_result.dart:1-99`
- **Fields:** liquidCash, totalReceivedIncomeBdt, totalExpenses, taxReserve, fixedCostsDue, anxietyBuffer, safeToSpend, rawSafeToSpend, pendingIncome, expectedIncome, horizonNumber, excludedUsdIncome, excludedUsdEntryCount
- Value object with equality and hashCode

### IMPL-019: StsSettings Entity
- **File:** `lib/features/safe_to_spend/domain/entities/sts_settings.dart:1-41`
- **Fields:**
  - `taxRate`: double, default 0.10 (10%), range 0.0-0.40 (enforced by assert)
  - `anxietyBuffer`: double, default 0.0 BDT (absolute amount, NOT percentage)
- No percentage-based buffer, no 5-30% range enforcement
- Immutable with copyWith

### IMPL-020: FixedCostEntry Entity
- **File:** `lib/features/safe_to_spend/domain/entities/fixed_cost_entry.dart:1-53`
- **Fields:** id, label, amount (BDT), dueDayOfMonth (1-28 enforced), createdAt
- Domain rule: dueDayOfMonth must be 1-28 (assertion enforced)
- Immutable with copyWith, equality by id

### IMPL-021: STS Settings Screen
- **File:** `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart:1-300+`
- **Sections:**
  1. **Tax Reserve Rate**: Slider (0%-40%, 50 divisions), label shows current %
  2. **Anxiety Buffer**: TextFormField for BDT amount + Save button, prefix "taka sign"
  3. **Fixed Costs**: List of fixed costs with swipe-to-delete + undo, "Add Fixed Cost" button
- Add/Edit fixed cost: modal bottom sheet with label, amount, due day fields
- No percentage-based anxiety buffer option

### IMPL-022: STS Provider Chain
- **File:** `lib/features/safe_to_spend/presentation/providers/safe_to_spend_providers.dart:1-123`
- **Provider hierarchy:**
  - `fixedCostDataSourceProvider` -> `fixedCostRepositoryProvider` -> `fixedCostNotifierProvider` (StateNotifierProvider)
  - `stsSettingsDataSourceProvider` -> `stsSettingsRepositoryProvider` -> `stsSettingsProvider` (StateNotifierProvider)
  - `safeToSpendProvider` (computed Provider) watches: income, transactions, settings, fixed costs
- STS recomputed every build from live data -- never persisted

---

## 7. Income Pipeline System

### IMPL-023: IncomeEntryEntity
- **File:** `lib/features/income/domain/entities/income_entry_entity.dart:1-133`
- **Fields:** id, clientName, projectName, amount, currency, status (IncomeStatus enum), expectedDate, receivedDate (nullable), notes, createdAt, updatedAt
- **IncomeStatus enum:** expected, pending, received (3 states)
- **Transition rules (documented in comments):**
  - Happy path: expected -> pending -> received
  - Allowed edge cases: expected -> received (direct), pending -> expected (failed)
  - Forbidden: received -> any prior state (terminal)
- Currency: "BDT" or "USD" (display only, no conversion)
- copyWith with `clearReceivedDate` and `clearNotes` flags

### IMPL-024: IncomeModel (Hive)
- **File:** `lib/features/income/data/models/income_model.dart:1-165`
- **TypeId:** 2 (permanent)
- **HiveFields:** 0-10 (id, clientName, projectName, amount, currency, statusIndex, expectedDate, receivedDate, notes, createdAt, updatedAt)
- Status stored as int index (not enum) for forward compatibility
- Fallback: unknown statusIndex -> IncomeStatus.expected
- toEntity/fromEntity and toJson/fromJson converters

### IMPL-025: Income Providers
- **File:** `lib/features/income/presentation/providers/income_providers.dart:1-123`
- **Provider chain:** incomeDataSourceProvider -> incomeRepositoryProvider -> incomeNotifierProvider
- **IncomeNotifier:** StateNotifier managing `List<IncomeEntryEntity>`
- CRUD: addIncome (duplicate-safe), updateIncome (defensive append), deleteIncome, clearIncomes
- Domain isolation: does NOT watch any transaction provider
- Filter/sort delegated to widget layer

### IMPL-026: IncomePipelineSummary Widget
- **File:** `lib/features/income/presentation/widgets/income_pipeline_summary.dart:1-313`
- **Type:** ConsumerWidget
- **Display states:**
  1. **Empty state** (no entries or all zero this month): Card with "Income Pipeline" label, subtitle ("Start tracking" or "No activity this month"), arrow icon, tappable
  2. **Active state**: Header with "View all" link, three `_StatusRow` widgets:
     - Received (green, check icon)
     - Pending (blue/info, sync icon)
     - Expected (grey, schedule icon)
- Computes totals at render time from `incomeNotifierProvider`
- Filters by current calendar month AND dashboard currency
- Floating-point drift protection: clamps to 2 decimal places
- Tapping empty state: navigates to add-income (if no entries) or income list (if entries exist but zero this month)
- Tapping status rows: pushes to income list with filter (received/pending/expected)

### IMPL-027: IncomeListScreen
- **File:** `lib/features/income/presentation/views/income_list_screen.dart:1-300+`
- **Filter chips:** All, Expected, Pending, Received
- **Sorting:** Newest expectedDate first, updatedAt as tiebreaker
- **Features:** Entry count label, swipe-to-delete with undo, empty states (first-time, filter-no-results)
- FAB: "+" to add income
- Back button via `context.pop()`
- Receives optional `initialFilter` from route extra

### IMPL-028: AddIncomeScreen
- **File:** `lib/features/income/presentation/views/add_income_screen.dart:1-300+`
- **Form fields:** Client Name, Project Name, Amount + Currency selector (BDT/USD), Status selector, Expected Date, Received Date (conditional on status==received), Notes
- **Features:** Double-submit guard (`_isSaving`), mounted checks, missing-entity error state for edit mode
- Currency selector: `['BDT', 'USD']` only
- Validation: required client/project names, amount > 0, received date required when received status
- **No FX rate field**, no exclude-entry toggle

---

## 8. Transaction System

### IMPL-029: TransactionEntity
- **File:** `lib/features/transactions/domain/entities/transaction_entity.dart:1-84`
- **Fields:** id, title, amount (always positive), date, categoryId (nullable), type (TransactionType), note (nullable)
- No currency field (assumed BDT)
- Equality by id

### IMPL-030: TransactionType Enum
- **File:** `lib/features/transactions/domain/entities/transaction_type.dart:1-19`
- **Values:** income, expense
- Income type exists but hidden on dashboard (Decision 015)

### IMPL-031: AddTransactionScreen
- **File:** `lib/features/transactions/presentation/views/add_transaction_screen.dart:1-100+`
- **Type selector:** Hard-set to `TransactionType.expense` (line 51: `final TransactionType _selectedType = TransactionType.expense`)
- Cannot create income transactions from UI (income type field is final, not user-changeable)
- **Categories:** Hardcoded list: Food, Transport, Shopping, Bills, Entertainment, Health, Education, Other
- Double-submit guard, mounted checks, missing-entity error state

---

## 9. Theme & Visual Identity

### IMPL-032: AppColors
- **File:** `lib/core/themes/colors.dart:1-41`
- **Primary brand:** primary #2453FF, primaryLight #6785FF, primaryDark #0031CB
- **Secondary:** secondary #F57C00, secondaryLight #FFAD42, secondaryDark #BB4D00
- **Neutrals:** white, black, grey #6B7280, greyLight #E5E7EB, greyDark #374151
- **Backgrounds:** backgroundLight #FAFAFA, backgroundDark #1A1A1A, cardLight #F9FAFB, cardDark #2C2C2C
- **Text:** textPrimary #111827, textSecondary #6B7280, textLight #F9FAFB, textDark #1F2937
- **Status:** success #10B981, warning #F59E0B, error #EF4444, info #3B82F6
- **Border/Shadow:** border #D1D5DB, shadow #1A000000 (10% black)
- All colors are static const, no dynamic theming

### IMPL-033: AppThemeData
- **File:** `lib/core/themes/app_theme.dart:1-156`
- **Light + Dark theme** configurations
- **Typography:** Google Fonts -- Poppins (English), Noto Sans Bengali (Bangla)
- Responsive font sizing via `ResponsiveUtilities.font()`
- Language-aware via `AppLanguage` parameter
- Button theme: primary bg, white fg, 12px border radius
- Input theme: filled, 12px border radius, primary focus border
- AppBar: no elevation, matching scaffold background

### IMPL-034: AppButton Widget
- **File:** `lib/core/widgets/buttons/button_multiple_types.dart:1-90`
- **Types:** primary (blue), secondary (grey), outline (transparent + blue border)
- Full-width ElevatedButton with loading state (CircularProgressIndicator)
- Disabled state: 40% alpha primary
- Responsive padding and font sizing

### IMPL-035: OnboardingHeader Widget
- **File:** `lib/core/widgets/progress_bar/linear_progress_bar.dart:1-73`
- Shows animated LinearProgressIndicator when `step` is provided
- Title text below progress bar
- Reusable across onboarding pages

---

## 10. Core Infrastructure

### IMPL-036: SharedPrefServices
- **File:** `lib/core/local_storage/shared_pref_service.dart:1-50`
- **Stored values:**
  - `onboarding_completed` (bool, default false)
  - `is_dark_mode` (bool, default false)
  - `user_currency` (String, default "BDT")
  - `user_language` (String, default "en")
- No income pattern, no buffer preference, no fixed costs, no auth tokens

### IMPL-037: HiveService
- **File:** `lib/core/local_storage/hive_service.dart:1-63`
- **Registered adapters:** TransactionModel (typeId 0), TransactionType (typeId 4), IncomeModel (typeId 2), FixedCostModel (typeId 3)
- **Open boxes:** transactions, income_box, fixed_costs_box
- Categories box: commented out (not yet registered)
- TypeId 1: reserved (unused)

### IMPL-038: AppBoxNames
- **File:** `lib/core/constants/app_box_names.dart:1-25`
- **Active:** transactions, incomeBox ("income_box"), fixedCostsBox ("fixed_costs_box")
- **Defined but not used:** categories ("categories")

### IMPL-039: IdGenerator
- **File:** `lib/core/utils/id_generator.dart:1-26`
- Generates `<timestamp_ms>_<random_6_hex>` format IDs
- Uses `Random.secure()` for suffix
- Abstract final class (no instantiation)

### IMPL-040: Localization
- **Languages:** English (en), Bangla (bn) via ARB files
- **Current strings:** welcomeMessage, tagLine, getStarted
- Very limited -- most UI text is hardcoded English in widgets, not localized

---

## 11. Feature Directory Inventory

### IMPL-041: Feature Modules
| Feature | Path | Architecture | Status |
|---------|------|-------------|--------|
| dashboard | `features/dashboard/presentation/views/` | presentation only | Active, 1 screen |
| income | `features/income/data+domain+presentation/` | full clean arch | Active, full CRUD |
| safe_to_spend | `features/safe_to_spend/data+domain+presentation/` | full clean arch | Active, calculator + settings |
| transactions | `features/transactions/data+domain+presentation/` | full clean arch | Active, expense-only CRUD |
| onboarding | `features/onboarding/presentation/` | presentation only | Active but minimal |
| splash | `features/splash/views/` | presentation only | Active, animation only |

### IMPL-042: Missing Feature Modules (Not Yet Created)
- No `auth/` feature directory
- No `audit_log/` feature directory
- No `export/` feature directory
- No `account/` feature directory (deletion, profile)
- No `analytics/` or `instrumentation/` feature directory
