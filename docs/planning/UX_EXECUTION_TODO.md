# UX Execution TODO

> Atomic, verifiable implementation tasks for Pocketa UX Canon.
> Each task has 11 required fields. No lib/ changes in this planning sprint.
> Updated: 2026-06-05
> Total tasks: 81 across 8 sprints

---

## Sprint 1: UX-5 Visual Identity / Design System

### UX-5.01: Create pocketa_colors.dart

| Field | Value |
|-------|-------|
| **Task ID** | UX-5.01 |
| **Source Requirement** | VIS-001 to VIS-010, VISR-001 to VISR-008 (refined palette with solid hex values) |
| **Affected Screen/Module** | `core/themes` |
| **Likely Files Affected** | `lib/core/themes/pocketa_colors.dart` (new), `lib/core/themes/colors.dart` (deprecate) |
| **Expected Outcome** | New color token file with full doctrine palette: ink (primary `#141413`, secondary `#3B3A36`, disabled `#8A8880`), surface (base `#FAFAF7`, elevated `#FFFFFF`, sunken `#F0EFE9`), accent (safe `#2E7D32`, caution `#E65100`, atRisk `#B71C1C`, neutral `#1565C0`), rail colors (3 states). All solid hex, no alpha for text. |
| **Non-Goals** | Do not migrate existing widgets yet. Do not delete colors.dart yet. |
| **Acceptance Criteria** | File compiles. All colors match VISR refined spec. No alpha-based text colors. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, visual diff against VISR spec table |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Solid hex values prevent Android alpha rendering bugs on budget devices |
| **Suggested Commit** | `feat(theme): create pocketa_colors.dart with doctrine-aligned solid palette` |

---

### UX-5.02: Create pocketa_typography.dart

| Field | Value |
|-------|-------|
| **Task ID** | UX-5.02 |
| **Source Requirement** | VIS-011 to VIS-017, VISR-009 to VISR-012 (refined type system) |
| **Affected Screen/Module** | `core/themes` |
| **Likely Files Affected** | `lib/core/themes/pocketa_typography.dart` (new), `pubspec.yaml` (font deps) |
| **Expected Outcome** | Type scale with 3 font families: JetBrains Mono (money amounts only), Inter (all UI text), Hind Siliguri (Bangla with locale-specific lineHeight 1.6). Sizes: heroAmount 34pt mono, sectionHeader 16pt semibold, bodyText 14pt regular, caption 12pt, microLabel 10pt. |
| **Non-Goals** | Do not apply to screens yet. Do not remove Poppins/Noto Sans Bengali references yet. |
| **Acceptance Criteria** | All text styles defined per spec. JetBrains Mono restricted to amount contexts. Bangla line height 1.6. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, grep for font family assignments |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Hind Siliguri needs explicit lineHeight because Bangla glyphs are taller than Latin |
| **Suggested Commit** | `feat(theme): create pocketa_typography.dart with Inter/JetBrains Mono/Hind Siliguri` |

---

### UX-5.03: Create pocketa_spacing.dart

| Field | Value |
|-------|-------|
| **Task ID** | UX-5.03 |
| **Source Requirement** | VIS-018 to VIS-022 (8pt grid system) |
| **Affected Screen/Module** | `core/themes` |
| **Likely Files Affected** | `lib/core/themes/pocketa_spacing.dart` (new) |
| **Expected Outcome** | 8pt grid tokens: xs=4, sm=8, md=16, lg=24, xl=32, xxl=48. Card padding 16px. Section gap 24px. Screen margin 16px. Touch target minimum 48x48. |
| **Non-Goals** | Do not apply to existing screens. |
| **Acceptance Criteria** | All values on 8pt grid. Touch target minimum documented. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, verify all values divisible by 4 |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | 8pt grid ensures consistent density on varying Android screen sizes |
| **Suggested Commit** | `feat(theme): create pocketa_spacing.dart with 8pt grid tokens` |

---

### UX-5.04: Create pocketa_motion.dart

| Field | Value |
|-------|-------|
| **Task ID** | UX-5.04 |
| **Source Requirement** | VIS-038 to VIS-042 (motion system) |
| **Affected Screen/Module** | `core/themes` |
| **Likely Files Affected** | `lib/core/themes/pocketa_motion.dart` (new) |
| **Expected Outcome** | Animation timing tokens: micro=100ms, short=200ms, medium=300ms, long=500ms. Curves: default=easeOutCubic, enter=decelerate, exit=accelerate. Stagger delay 50ms per item. Rail state transitions 200ms. No bounce/spring effects. |
| **Non-Goals** | Do not implement actual animations yet. Token definitions only. |
| **Acceptance Criteria** | All durations and curves defined. No spring/bounce curves. `dart analyze` clean. |
| **Verification Method** | `dart analyze` |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Calm product = no playful bounces. Financial UI must feel precise, not fun. |
| **Suggested Commit** | `feat(theme): create pocketa_motion.dart with animation timing tokens` |

---

### UX-5.05: Rebuild app_theme.dart

| Field | Value |
|-------|-------|
| **Task ID** | UX-5.05 |
| **Source Requirement** | VIS-001 to VIS-045, VISR-001 to VISR-034 (full visual identity) |
| **Affected Screen/Module** | `core/themes` |
| **Likely Files Affected** | `lib/core/themes/app_theme.dart` (rewrite) |
| **Expected Outcome** | ThemeData rebuilt using pocketa_colors, pocketa_typography, pocketa_spacing tokens. Surface base `#FAFAF7` not pure white. AppBar transparent/surface. BottomNav uses doctrine colors. All Material overrides use new tokens. |
| **Non-Goals** | Do not fix individual screen styling yet. Theme file only. |
| **Acceptance Criteria** | App compiles with new theme. No hardcoded colors in theme file. All references use token files. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, app builds and runs |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Theme rebuild is high-risk; run app after to verify no runtime crashes |
| **Suggested Commit** | `refactor(theme): rebuild app_theme.dart using doctrine token files` |

---

### UX-5.06: Create PocketaAmount widget

| Field | Value |
|-------|-------|
| **Task ID** | UX-5.06 |
| **Source Requirement** | COPY-030 to COPY-035 (number formatting), VISR-009 (JetBrains Mono for money) |
| **Affected Screen/Module** | `core/widgets` |
| **Likely Files Affected** | `lib/core/widgets/pocketa_amount.dart` (new) |
| **Expected Outcome** | Widget displays BDT amounts in lakh/crore format with JetBrains Mono. Params: amount (int paisa), currency, showSign, size. BDT: `12,45,000` format. USD: `12,450.00` format. Always 2 decimal places. Monospace font for tabular alignment. |
| **Non-Goals** | Do not integrate into screens yet. Widget only. |
| **Acceptance Criteria** | Formats BDT in lakh/crore. Formats USD in Western. Uses JetBrains Mono. Handles zero, negative, large amounts. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, widget test with sample amounts |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Integer paisa storage avoids float precision errors in financial calculations |
| **Suggested Commit** | `feat(widget): create PocketaAmount with lakh/crore BDT formatting` |

---

### UX-5.07: Create PocketaLedgerRail widget

| Field | Value |
|-------|-------|
| **Task ID** | UX-5.07 |
| **Source Requirement** | VISR-013 to VISR-018 (Ledger Rail as ownable visual asset) |
| **Affected Screen/Module** | `core/widgets` |
| **Likely Files Affected** | `lib/core/widgets/pocketa_ledger_rail.dart` (new) |
| **Expected Outcome** | 3pt vertical rail with state-driven color: Safe=`#2E7D32`, Caution=`#E65100`, AtRisk=`#B71C1C`. State label next to rail. Animates color transition 200ms. Replaces thin accent line from earlier spec. |
| **Non-Goals** | Do not integrate into cards yet. Standalone widget. |
| **Acceptance Criteria** | Rail renders 3pt width. Color matches state. Label displays. Transition animates. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, widget test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Ledger Rail is ownable visual asset #1 — must be distinct from generic accent lines |
| **Suggested Commit** | `feat(widget): create PocketaLedgerRail with 3pt state-driven rail` |

---

### UX-5.08: Create PocketaTrustStrip widget

| Field | Value |
|-------|-------|
| **Task ID** | UX-5.08 |
| **Source Requirement** | VISR-019 to VISR-022 (Trust Strip), UX-078 to UX-082 (trust model) |
| **Affected Screen/Module** | `core/widgets` |
| **Likely Files Affected** | `lib/core/widgets/pocketa_trust_strip.dart` (new) |
| **Expected Outcome** | Compact strip showing: last updated timestamp, data source label, FX rate used (if applicable), tap-to-audit link. Required on every financial surface. Caption size text, muted color. |
| **Non-Goals** | Do not wire audit navigation yet. Placeholder onTap. |
| **Acceptance Criteria** | Displays all 4 trust elements. Caption text styling. Muted color from doctrine palette. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, widget test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Trust Strip is ownable visual asset #3 — visible proof Pocketa shows its work |
| **Suggested Commit** | `feat(widget): create PocketaTrustStrip with timestamp/source/audit display` |

---

### UX-5.09: Create PocketaToast widget

| Field | Value |
|-------|-------|
| **Task ID** | UX-5.09 |
| **Source Requirement** | UX-090 to UX-092 (feedback patterns), VIS-043 to VIS-045 (motion) |
| **Affected Screen/Module** | `core/widgets` |
| **Likely Files Affected** | `lib/core/widgets/pocketa_toast.dart` (new) |
| **Expected Outcome** | Financial-safe snackbar replacement. No confetti, no celebratory language. Neutral confirmation tone. Types: success (green rail), warning (orange rail), error (red rail), info (blue rail). Auto-dismiss after 3s. |
| **Non-Goals** | Do not replace existing SnackBars yet. |
| **Acceptance Criteria** | 4 toast types with correct rail colors. Auto-dismiss. No celebratory copy. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, widget test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Toasts must never celebrate financial events — calm confirmation only |
| **Suggested Commit** | `feat(widget): create PocketaToast with financial-safe feedback patterns` |

---

### UX-5.10: Create 5 card widgets

| Field | Value |
|-------|-------|
| **Task ID** | UX-5.10 |
| **Source Requirement** | VIS-023 to VIS-037 (card system), VISR-023 to VISR-028 (refined cards) |
| **Affected Screen/Module** | `core/widgets/cards` |
| **Likely Files Affected** | `lib/core/widgets/cards/pocketa_hero_zone.dart`, `pocketa_ledger_card.dart`, `pocketa_audit_card.dart`, `pocketa_source_card.dart`, `pocketa_caution_card.dart` (all new) |
| **Expected Outcome** | 5 card types: HeroZone (S2S container, elevated surface, 12px radius), LedgerCard (standard money card with Ledger Rail), AuditCard (calculation trace container), SourceCard (source + status display), CautionCard (AtRisk state, red rail, caution surface). All use 8pt padding, doctrine colors, no decorative borders (1px functional divider only). |
| **Non-Goals** | Do not populate with real data. Shell widgets with slots. |
| **Acceptance Criteria** | All 5 cards render correctly. Use doctrine tokens. No decorative elements. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, widget tests |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Cards are functional containers, not decorative surfaces. 1px divider max. |
| **Suggested Commit** | `feat(widget): create 5 doctrine card widgets (Hero/Ledger/Audit/Source/Caution)` |

---

### UX-5.11: Create number_formatter.dart

| Field | Value |
|-------|-------|
| **Task ID** | UX-5.11 |
| **Source Requirement** | COPY-030 to COPY-035 (number formatting rules) |
| **Affected Screen/Module** | `core/utils` |
| **Likely Files Affected** | `lib/core/utils/number_formatter.dart` (new) |
| **Expected Outcome** | Utility with: `formatBDT(int paisa)` -> `12,45,000.00` (lakh/crore), `formatUSD(int cents)` -> `12,450.00` (Western), `formatCompact(int paisa)` -> `12.45L` or `1.2Cr`. Always 2 decimal places for full format. Integer input (paisa/cents), string output. |
| **Non-Goals** | Do not change PocketaAmount widget to use this yet (but it will). |
| **Acceptance Criteria** | BDT lakh/crore formatting correct. USD Western formatting correct. Compact format works. Zero/negative handling. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, unit tests |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Lakh/crore grouping: 12,45,000 not 1,245,000 — first 3 digits from right, then groups of 2 |
| **Suggested Commit** | `feat(utils): create number_formatter.dart with BDT lakh/crore and USD formatting` |

---

### UX-5.12: Sprint 1 dart analyze clean

| Field | Value |
|-------|-------|
| **Task ID** | UX-5.12 |
| **Source Requirement** | Architecture rule: 0/0/0 analyzer |
| **Affected Screen/Module** | All new Sprint 1 files |
| **Likely Files Affected** | Any file with lint issues from Sprint 1 |
| **Expected Outcome** | `dart analyze` returns 0 errors, 0 warnings, 0 infos across entire project. |
| **Non-Goals** | Do not fix pre-existing lint issues outside Sprint 1 scope. |
| **Acceptance Criteria** | `dart analyze` output shows 0/0/0. |
| **Verification Method** | `dart analyze` |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md`, mark Sprint 1 complete |
| **Learning/Reflection** | Run analyze after every file creation, not just at sprint end |
| **Suggested Commit** | `chore(lint): sprint 1 dart analyze clean 0/0/0` |

---

## Sprint 2: UX-1 Dashboard Cockpit Redesign

### UX-1.01: Create PocketaRealityStack widget

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.01 |
| **Source Requirement** | DR-001 to DR-008 (Reality Stack model), VISR-013 to VISR-018 |
| **Affected Screen/Module** | `core/widgets` |
| **Likely Files Affected** | `lib/core/widgets/pocketa_reality_stack.dart` (new) |
| **Expected Outcome** | 4-layer vertical stack: Layer 1 (HeroZone: S2S), Layer 2 (Already committed: obligations), Layer 3 (Reserve protected: buffer), Layer 4 (Not counted yet: pipeline). Each layer is a slot accepting child widgets. 9-line above-fold rule for Layer 1. |
| **Non-Goals** | Do not populate layers with real widgets yet. Slot-based container only. |
| **Acceptance Criteria** | 4 layers render in correct order. Scrollable. Layer 1 fits 9 lines above fold. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, visual inspection on reference device size |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Reality Stack is ownable visual asset #2 — the money hierarchy visualization |
| **Suggested Commit** | `feat(widget): create PocketaRealityStack with 4-layer money hierarchy` |

---

### UX-1.02: Create PocketaCalculationTrace widget

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.02 |
| **Source Requirement** | DR-009 to DR-014 (calculation transparency), UX-078 to UX-082 |
| **Affected Screen/Module** | `core/widgets` |
| **Likely Files Affected** | `lib/core/widgets/pocketa_calculation_trace.dart` (new) |
| **Expected Outcome** | Expandable drawer showing S2S math step by step. Format: `Balance: 1,50,000` / `- Fixed costs: 45,000` / `- Reserved: 22,500` / `= Safe to spend: 82,500`. Stagger animation 50ms per line. Uses JetBrains Mono for amounts. Each line tappable for source detail. |
| **Non-Goals** | Do not wire to real calculator yet. Mock data for now. |
| **Acceptance Criteria** | Shows calculation steps. Stagger animation works. Amounts in JetBrains Mono. Tappable lines. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, animation visual test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Calculation Trace is ownable visual asset #4 — "show your work" principle |
| **Suggested Commit** | `feat(widget): create PocketaCalculationTrace with stagger animation` |

---

### UX-1.03: Create PocketaHeroZone

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.03 |
| **Source Requirement** | DR-001 to DR-004 (hero zone spec), VISR-023 (hero card) |
| **Affected Screen/Module** | `core/widgets/cards` or `features/dashboard/presentation/widgets` |
| **Likely Files Affected** | `lib/core/widgets/cards/pocketa_hero_zone.dart` (enhance from UX-5.10) |
| **Expected Outcome** | Hero container combining: S2S amount (PocketaAmount, 34pt), Ledger Rail (state indicator), Trust Strip (timestamp + source), tap-to-expand for Calculation Trace. Elevated surface card. Label: "Safe to spend right now". |
| **Non-Goals** | Do not wire to real S2S provider yet. Accept props. |
| **Acceptance Criteria** | Displays S2S amount with correct typography. Ledger Rail visible. Trust Strip present. Tap expands trace area. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, visual inspection |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | HeroZone must answer "how much can I spend?" in under 1 second of looking |
| **Suggested Commit** | `feat(widget): enhance PocketaHeroZone with S2S display + rail + trust strip` |

---

### UX-1.04: Create "Already committed" section

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.04 |
| **Source Requirement** | DR-005 (obligations layer), UX-025 to UX-030 |
| **Affected Screen/Module** | `features/dashboard/presentation/widgets` |
| **Likely Files Affected** | `lib/features/dashboard/presentation/widgets/committed_section.dart` (new) |
| **Expected Outcome** | Reality Stack Layer 2. Shows upcoming fixed obligations (rent, subscriptions, etc.) with due dates. Uses LedgerCard format. Total committed amount at section header. Collapsed by default, expandable. |
| **Non-Goals** | Do not create obligation data model (uses existing transactions). |
| **Acceptance Criteria** | Section renders with header + collapsible list. Uses LedgerCard. Shows total. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, visual inspection |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | "Already committed" framing prevents users from mentally spending money twice |
| **Suggested Commit** | `feat(dashboard): create Already Committed section for Reality Stack` |

---

### UX-1.05: Create "Reserve protected" section

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.05 |
| **Source Requirement** | DR-006 (reserve layer), UX-031 to UX-035 |
| **Affected Screen/Module** | `features/dashboard/presentation/widgets` |
| **Likely Files Affected** | `lib/features/dashboard/presentation/widgets/reserve_section.dart` (new) |
| **Expected Outcome** | Reality Stack Layer 3. Shows anxiety buffer amount (percentage of income). Label: "Reserve protected — [X]% buffer". Simple display, not editable from dashboard. Shows buffer percentage and BDT amount. |
| **Non-Goals** | Do not change buffer calculation (that's D1.11). Display only. |
| **Acceptance Criteria** | Shows buffer percentage and amount. Uses doctrine copy. Not editable inline. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, visual inspection |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Reserve is "protected" framing — money the user chose to set aside, not money taken from them |
| **Suggested Commit** | `feat(dashboard): create Reserve Protected section for Reality Stack` |

---

### UX-1.06: Create "Not counted yet" section

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.06 |
| **Source Requirement** | DR-007 (pipeline layer), UX-036 to UX-040 |
| **Affected Screen/Module** | `features/dashboard/presentation/widgets` |
| **Likely Files Affected** | `lib/features/dashboard/presentation/widgets/pipeline_summary_section.dart` (new) |
| **Expected Outcome** | Reality Stack Layer 4. Shows pipeline total (expected + pending, not yet received). Uses SourceCard format. Link to Pipeline tab for details. Label: "Not counted yet — [N] entries in pipeline". Muted styling to reinforce "not real money yet". |
| **Non-Goals** | Do not show individual pipeline entries (that's Pipeline tab). Summary only. |
| **Acceptance Criteria** | Shows pipeline count and total. Muted visual treatment. Links to Pipeline tab. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, visual inspection |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | "Not counted yet" is the key Real vs Hopeful Money distinction |
| **Suggested Commit** | `feat(dashboard): create Not Counted Yet pipeline summary section` |

---

### UX-1.07: Create bottom navigation

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.07 |
| **Source Requirement** | DR-015 to DR-018 (navigation model) |
| **Affected Screen/Module** | `config/router` |
| **Likely Files Affected** | `lib/config/router/app_router.dart`, `lib/config/router/route_names.dart`, new shell route widget |
| **Expected Outcome** | 4-tab bottom navigation: Home (dashboard), Pipeline, History, Settings. GoRouter ShellRoute with BottomNavigationBar. Uses doctrine colors. Active tab = ink.primary, inactive = ink.disabled. No labels overflow. |
| **Non-Goals** | Do not build History or Settings screens yet (placeholder). |
| **Acceptance Criteria** | 4 tabs navigate correctly. GoRouter integration works. Active/inactive states correct. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, navigation test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Bottom nav is standard mobile pattern — do not innovate here, just execute cleanly |
| **Suggested Commit** | `feat(nav): create 4-tab bottom navigation with GoRouter shell route` |

---

### UX-1.08: Redesign dashboard_screen.dart

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.08 |
| **Source Requirement** | DR-001 to DR-018 (full dashboard cockpit model) |
| **Affected Screen/Module** | `features/dashboard/presentation/views` |
| **Likely Files Affected** | `lib/features/dashboard/presentation/views/dashboard_screen.dart` (rewrite) |
| **Expected Outcome** | Complete rewrite using Reality Stack layout. Remove: summary chips, transaction list from home, category breakdown pie chart, generic greeting. Add: PocketaRealityStack with all 4 layers, PocketaHeroZone at top, sections below. File under 300 lines. |
| **Non-Goals** | Do not fix S2S calculation logic. Display layer only. |
| **Acceptance Criteria** | Reality Stack layout visible. Old UI elements removed. Under 300 lines. Wired to existing providers. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, visual inspection, line count check |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | This is highest-risk task in Sprint 2 — test on device immediately after |
| **Suggested Commit** | `refactor(dashboard): rewrite dashboard_screen.dart to Reality Stack layout` |

---

### UX-1.09: Replace breakdown bottom sheet

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.09 |
| **Source Requirement** | DR-009 to DR-014 (calculation transparency replaces breakdown) |
| **Affected Screen/Module** | `features/safe_to_spend/presentation` |
| **Likely Files Affected** | `lib/features/safe_to_spend/presentation/widgets/safe_to_spend_hero.dart` (modify) |
| **Expected Outcome** | Remove existing breakdown bottom sheet. Replace with PocketaCalculationTrace expansion. Tap on S2S amount expands inline trace instead of opening modal. Wire to real S2S calculator outputs. |
| **Non-Goals** | Do not change S2S formula. Display refactor only. |
| **Acceptance Criteria** | Old bottom sheet removed. Calculation trace shows real math. Inline expansion works. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, tap test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Inline expansion is calmer than modal — fewer context switches |
| **Suggested Commit** | `refactor(dashboard): replace breakdown bottom sheet with PocketaCalculationTrace` |

---

### UX-1.10: Add FAB "Add Pipeline Entry"

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.10 |
| **Source Requirement** | COPY-001 to COPY-005 (terminology: "pipeline entry" not "transaction") |
| **Affected Screen/Module** | `features/dashboard/presentation/views` |
| **Likely Files Affected** | `lib/features/dashboard/presentation/views/dashboard_screen.dart` |
| **Expected Outcome** | FloatingActionButton labeled "Add Pipeline Entry" (not "Add Transaction" or "Add Income"). Navigates to add_income_screen. Uses accent.neutral color. |
| **Non-Goals** | Do not redesign add_income_screen yet (that's UX-3). |
| **Acceptance Criteria** | FAB visible on dashboard. Label says "Pipeline Entry". Navigates correctly. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, navigation test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Language shapes mental model — "pipeline entry" reinforces forward-looking cashflow |
| **Suggested Commit** | `feat(dashboard): add FAB for Add Pipeline Entry` |

---

### UX-1.11: Remove dev reset button from production

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.11 |
| **Source Requirement** | GAP-008 (dev reset button visible in production) |
| **Affected Screen/Module** | `features/dashboard/presentation/views` |
| **Likely Files Affected** | `lib/features/dashboard/presentation/views/dashboard_screen.dart` |
| **Expected Outcome** | Dev reset button (clears Hive data) wrapped in `if (kDebugMode)` guard. Not visible in release builds. |
| **Non-Goals** | Do not remove the button entirely — keep for development. |
| **Acceptance Criteria** | Button hidden in release mode. Visible in debug mode. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, build in release mode and verify |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Production UI must never show debug controls — trust violation |
| **Suggested Commit** | `fix(dashboard): gate dev reset button behind kDebugMode` |

---

### UX-1.12: Implement empty state

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.12 |
| **Source Requirement** | DR-019 to DR-022 (empty/zero states) |
| **Affected Screen/Module** | `features/dashboard/presentation/views` |
| **Likely Files Affected** | `lib/features/dashboard/presentation/views/dashboard_screen.dart` or new empty state widget |
| **Expected Outcome** | When pipeline is empty: show S2S as current balance only, emphasize "runway" days, show gentle prompt to add first pipeline entry. No broken/blank UI. Copy: "Add your first expected payment to see your full picture." |
| **Non-Goals** | Do not force onboarding repeat. |
| **Acceptance Criteria** | Empty pipeline shows meaningful state. No blank sections. Runway visible. CTA to add entry. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, test with empty Hive box |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Empty state is first impression for returning users — must feel helpful, not broken |
| **Suggested Commit** | `feat(dashboard): implement empty state for zero-pipeline scenario` |

---

### UX-1.13: Implement Reserve Mode layout

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.13 |
| **Source Requirement** | DR-023 to DR-025 (reserve mode variant) |
| **Affected Screen/Module** | `features/dashboard/presentation/views` |
| **Likely Files Affected** | `lib/features/dashboard/presentation/views/dashboard_screen.dart` |
| **Expected Outcome** | When S2S drops to AtRisk level: Ledger Rail turns red, HeroZone shows reserve depletion warning, "Already committed" section highlighted, copy shifts to "You're spending from your reserve." No panic language — calm clarity. |
| **Non-Goals** | Do not change when AtRisk triggers (calculator logic unchanged). |
| **Acceptance Criteria** | AtRisk state visually distinct. Red rail. Reserve warning copy. No panic language. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, test with AtRisk S2S values |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | AtRisk must be clear without being alarming — "calm alarm" is the tone |
| **Suggested Commit** | `feat(dashboard): implement Reserve Mode layout variant for AtRisk state` |

---

### UX-1.14: Sprint 2 dart analyze clean

| Field | Value |
|-------|-------|
| **Task ID** | UX-1.14 |
| **Source Requirement** | Architecture rule: 0/0/0 analyzer |
| **Affected Screen/Module** | All Sprint 2 files |
| **Likely Files Affected** | Any file with lint issues from Sprint 2 |
| **Expected Outcome** | `dart analyze` returns 0/0/0 across entire project. |
| **Non-Goals** | Do not fix issues outside Sprint 2 scope. |
| **Acceptance Criteria** | `dart analyze` 0/0/0. |
| **Verification Method** | `dart analyze` |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md`, mark Sprint 2 complete |
| **Learning/Reflection** | Dashboard rewrite is big — expect multiple analyze passes |
| **Suggested Commit** | `chore(lint): sprint 2 dart analyze clean 0/0/0` |

---

## Sprint 3: UX-2 Onboarding Redesign

### UX-2.01: Create onboarding data model

| Field | Value |
|-------|-------|
| **Task ID** | UX-2.01 |
| **Source Requirement** | ONB-001 to ONB-010 (7-step data collection model) |
| **Affected Screen/Module** | `features/onboarding/domain` |
| **Likely Files Affected** | `lib/features/onboarding/domain/entities/onboarding_data.dart` (new), `lib/features/onboarding/presentation/providers/onboarding_data_provider.dart` (new) |
| **Expected Outcome** | Freezed/immutable data model capturing all 7 steps: painQualifier, liquidBalance, fixedCosts (list), incomePattern (enum), bufferComfort (percentage), firstPipelineEntry (optional), pinCode. Riverpod StateNotifier for step progression. |
| **Non-Goals** | Do not persist to Hive yet (onboarding completes then writes to existing models). |
| **Acceptance Criteria** | Model compiles. All 7 fields present. Provider tracks current step. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, unit test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Onboarding data is ephemeral until completion — then maps to existing domain entities |
| **Suggested Commit** | `feat(onboarding): create multi-step onboarding data model and provider` |

---

### UX-2.02: Create pain qualifier page

| Field | Value |
|-------|-------|
| **Task ID** | UX-2.02 |
| **Source Requirement** | ONB-011 to ONB-015 (Step 1: why are you here?) |
| **Affected Screen/Module** | `features/onboarding/presentation/views/pages` |
| **Likely Files Affected** | `lib/features/onboarding/presentation/views/pages/pain_qualifier_page.dart` (new) |
| **Expected Outcome** | Step 1 of 7. Question: "What brought you here?" with 3-4 selectable cards (e.g., "I never know how much I can actually spend", "My income is unpredictable", "I want to stop guessing"). Single selection. Conversational tone. Under 60 seconds to complete. |
| **Non-Goals** | Do not collect financial data on this page. Emotional qualifier only. |
| **Acceptance Criteria** | Cards render. Single selection works. Stores in onboarding provider. Under 60s cognitive load. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, time-to-complete test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Pain qualifier sets emotional context — user feels understood before data collection |
| **Suggested Commit** | `feat(onboarding): create pain qualifier page (Step 1)` |

---

### UX-2.03: Create liquid balance page

| Field | Value |
|-------|-------|
| **Task ID** | UX-2.03 |
| **Source Requirement** | ONB-016 to ONB-020 (Step 2: current balance) |
| **Affected Screen/Module** | `features/onboarding/presentation/views/pages` |
| **Likely Files Affected** | `lib/features/onboarding/presentation/views/pages/liquid_balance_page.dart` (new) |
| **Expected Outcome** | Step 2 of 7. Single BDT amount input for current liquid balance. Uses PocketaAmount formatting as user types. Helper text: "How much is in your accounts right now that you could spend?" No bank linking — manual entry. |
| **Non-Goals** | Do not ask about savings or investments. Liquid (spendable) only. |
| **Acceptance Criteria** | Amount input works with BDT formatting. Stores in provider. Clear helper text. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, input test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | "Liquid balance" framing avoids confusion with total net worth |
| **Suggested Commit** | `feat(onboarding): create liquid balance page (Step 2)` |

---

### UX-2.04: Create fixed costs page

| Field | Value |
|-------|-------|
| **Task ID** | UX-2.04 |
| **Source Requirement** | ONB-021 to ONB-026 (Step 3: guided checklist) |
| **Affected Screen/Module** | `features/onboarding/presentation/views/pages` |
| **Likely Files Affected** | `lib/features/onboarding/presentation/views/pages/fixed_costs_page.dart` (new) |
| **Expected Outcome** | Step 3 of 7. Guided checklist of common Bangladeshi fixed costs: Rent, Utilities, Internet, Phone, Transport, Family support, Subscriptions. User taps to include, enters amount for each. Can add custom items. Total updates live. |
| **Non-Goals** | Do not create recurring transaction system. One-time capture for S2S seed. |
| **Acceptance Criteria** | Checklist renders common items. Amounts editable. Total shows. Custom items addable. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, interaction test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Guided checklist reduces cognitive load vs blank "enter your expenses" field |
| **Suggested Commit** | `feat(onboarding): create fixed costs guided checklist page (Step 3)` |

---

### UX-2.05: Create income pattern page

| Field | Value |
|-------|-------|
| **Task ID** | UX-2.05 |
| **Source Requirement** | ONB-027 to ONB-031 (Step 4: income pattern selection) |
| **Affected Screen/Module** | `features/onboarding/presentation/views/pages` |
| **Likely Files Affected** | `lib/features/onboarding/presentation/views/pages/income_pattern_page.dart` (new) |
| **Expected Outcome** | Step 4 of 7. Three picture cards representing income patterns: "Regular monthly" (salary-like), "Project-based" (milestone payments), "Mixed/irregular" (freelance reality). Single selection. Visual cards, not radio buttons. Affects how pipeline suggestions work later. |
| **Non-Goals** | Do not collect actual income amounts here. Pattern selection only. |
| **Acceptance Criteria** | 3 picture cards render. Single selection. Stores pattern in provider. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, selection test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Picture cards reduce reading load — pattern is recognized visually |
| **Suggested Commit** | `feat(onboarding): create income pattern selection page (Step 4)` |

---

### UX-2.06: Create buffer comfort page

| Field | Value |
|-------|-------|
| **Task ID** | UX-2.06 |
| **Source Requirement** | ONB-032 to ONB-037 (Step 5: anxiety buffer as percentage) |
| **Affected Screen/Module** | `features/onboarding/presentation/views/pages` |
| **Likely Files Affected** | `lib/features/onboarding/presentation/views/pages/buffer_comfort_page.dart` (new) |
| **Expected Outcome** | Step 5 of 7. Slider for buffer comfort: 5% to 30%, default 15%. Live BDT preview showing what that percentage means against their stated income/balance. Copy: "How much breathing room do you want?" Not "anxiety buffer" in UI. |
| **Non-Goals** | Do not explain buffer calculation mechanics. Simple comfort slider. |
| **Acceptance Criteria** | Slider works 5-30%. Default 15%. Live BDT preview updates. Stores percentage in provider. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, slider test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | "Breathing room" framing is calmer than "anxiety buffer" or "safety net" |
| **Suggested Commit** | `feat(onboarding): create buffer comfort slider page (Step 5)` |

---

### UX-2.07: Create first pipeline entry page

| Field | Value |
|-------|-------|
| **Task ID** | UX-2.07 |
| **Source Requirement** | ONB-038 to ONB-042 (Step 6: optional first entry) |
| **Affected Screen/Module** | `features/onboarding/presentation/views/pages` |
| **Likely Files Affected** | `lib/features/onboarding/presentation/views/pages/first_pipeline_page.dart` (new) |
| **Expected Outcome** | Step 6 of 7 (optional, skippable). Simplified pipeline entry: amount, expected date, source label. Copy: "Any money you're expecting soon?" Skip button prominent. If filled, creates first income pipeline entry on completion. |
| **Non-Goals** | Do not build full pipeline entry form. Simplified version for onboarding context. |
| **Acceptance Criteria** | Entry form works. Skip button visible and functional. Stores in provider if filled. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, skip test + entry test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Optional step must feel genuinely optional — skip button as prominent as continue |
| **Suggested Commit** | `feat(onboarding): create first pipeline entry page (Step 6, optional)` |

---

### UX-2.08: Create PIN setup page

| Field | Value |
|-------|-------|
| **Task ID** | UX-2.08 |
| **Source Requirement** | ONB-043 to ONB-046 (Step 7: PIN setup), D1 trust layer |
| **Affected Screen/Module** | `features/onboarding/presentation/views/pages` |
| **Likely Files Affected** | `lib/features/onboarding/presentation/views/pages/pin_setup_page.dart` (new) |
| **Expected Outcome** | Step 7 of 7. 4-digit PIN setup with confirmation. Copy: "Set a PIN to protect your financial data." Stores PIN hash (not plaintext). Biometric opt-in if available. |
| **Non-Goals** | Do not build full auth system (that's D1). PIN capture only during onboarding. |
| **Acceptance Criteria** | PIN entry works. Confirmation matches. Hash stored. Biometric prompt if available. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, PIN flow test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | PIN at end of onboarding — user already invested, more likely to complete |
| **Suggested Commit** | `feat(onboarding): create PIN setup page (Step 7)` |

---

### UX-2.09: Wire 7-step flow

| Field | Value |
|-------|-------|
| **Task ID** | UX-2.09 |
| **Source Requirement** | ONB-001 to ONB-049 (full onboarding flow) |
| **Affected Screen/Module** | `features/onboarding/presentation/views` |
| **Likely Files Affected** | `lib/features/onboarding/presentation/views/onboarding_screen.dart` (rewrite) |
| **Expected Outcome** | Complete rewrite of onboarding_screen.dart. Replace 3-page motivational carousel with 7-step conversational flow. PageView with step indicator. Back navigation between steps. Progress persisted in provider. On completion: write all data to existing domain models (balance, fixed costs, income entries, settings). |
| **Non-Goals** | Do not change existing domain entities. Map onboarding data to existing models. |
| **Acceptance Criteria** | 7 steps in correct order. Navigation forward/back works. Step indicator shows progress. Completion writes to Hive. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, full flow test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Onboarding rewrite is high-risk — test fresh install flow end to end |
| **Suggested Commit** | `refactor(onboarding): rewrite onboarding_screen.dart with 7-step conversational flow` |

---

### UX-2.10: Fix welcome screen copy

| Field | Value |
|-------|-------|
| **Task ID** | UX-2.10 |
| **Source Requirement** | COPY-001 to COPY-005 (banned phrases), GAP-003 |
| **Affected Screen/Module** | `features/onboarding/presentation/views` |
| **Likely Files Affected** | `lib/features/onboarding/presentation/views/welcome_screen.dart`, `lib/l10n/app_en.arb`, `lib/l10n/app_bn.arb` |
| **Expected Outcome** | Remove "pocket accountant" tagline. Remove "Smart budgeting". Replace with doctrine-aligned copy: positioning as cashflow clarity tool for freelancers. Update both English and Bangla ARB files. |
| **Non-Goals** | Do not redesign welcome screen layout. Copy change only. |
| **Acceptance Criteria** | No banned phrases on welcome screen. New copy matches doctrine positioning. Both languages updated. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, grep for banned phrases |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Welcome screen is first touchpoint — copy must match product identity exactly |
| **Suggested Commit** | `fix(onboarding): replace banned tagline and copy on welcome screen` |

---

### UX-2.11: Delete dead stubs + analyze clean

| Field | Value |
|-------|-------|
| **Task ID** | UX-2.11 |
| **Source Requirement** | GAP-004 (dead stub files), architecture cleanliness |
| **Affected Screen/Module** | `features/onboarding/presentation/views/pages` |
| **Likely Files Affected** | `lib/features/onboarding/presentation/views/pages/set_budget_categories.dart` (delete), `set_currency_and_earning_range.dart` (delete), `set_income_source.dart` (delete) |
| **Expected Outcome** | Delete 3 dead stub files from old onboarding. Verify no imports reference them. `dart analyze` 0/0/0. |
| **Non-Goals** | Do not delete any file that is still imported. |
| **Acceptance Criteria** | 3 files deleted. No broken imports. `dart analyze` 0/0/0. |
| **Verification Method** | `dart analyze`, grep for imports |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md`, mark Sprint 3 complete |
| **Learning/Reflection** | Dead code = confusion for future agents. Delete immediately when replaced. |
| **Suggested Commit** | `chore(onboarding): delete dead stub files + dart analyze clean` |

---

## Sprint 4: UX-3 Pipeline Quick-Update

### UX-3.01: Add fxRate, excludeFromCalculation, sourceLabel fields

| Field | Value |
|-------|-------|
| **Task ID** | UX-3.01 |
| **Source Requirement** | PIPE-001 to PIPE-010 (pipeline data model), GAP-012, GAP-013 |
| **Affected Screen/Module** | `features/income/domain`, `features/income/data` |
| **Likely Files Affected** | `lib/features/income/domain/entities/income_entry_entity.dart`, `lib/features/income/data/models/income_model.dart` |
| **Expected Outcome** | Add 3 fields to income entry: `fxRate` (double, nullable — conservative rate for USD->BDT), `excludeFromCalculation` (bool, default false), `sourceLabel` (String, nullable — e.g., "Upwork", "Fiverr", "Direct client"). New HiveFields with next available TypeIds. Migration-safe (nullable fields). |
| **Non-Goals** | Do not change calculator yet (that's UX-3.08). Data model only. |
| **Acceptance Criteria** | Fields added to entity and Hive model. Nullable/default values. Existing data unaffected. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, Hive box opens without error on existing data |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Hive field additions must be nullable to avoid breaking existing boxes |
| **Suggested Commit** | `feat(income): add fxRate, excludeFromCalculation, sourceLabel to income entity` |

---

### UX-3.02: Create ConfirmReceivedSheet

| Field | Value |
|-------|-------|
| **Task ID** | UX-3.02 |
| **Source Requirement** | PIPE-011 to PIPE-020 (the most important widget) |
| **Affected Screen/Module** | `features/income/presentation/widgets` |
| **Likely Files Affected** | `lib/features/income/presentation/widgets/confirm_received_sheet.dart` (new) |
| **Expected Outcome** | Bottom sheet for confirming pipeline entry receipt. Shows: expected amount, actual amount input (pre-filled with expected), date received, FX rate used. Two actions: "Confirm received" (moves to Received state) and "Not yet" (dismiss). Under 2 taps to confirm if amount matches. This is THE most important interaction in the app. |
| **Non-Goals** | Do not handle partial receipt yet. Full amount or dismiss. |
| **Acceptance Criteria** | Sheet opens from pipeline entry. Pre-fills expected amount. Confirm updates state to Received. Dismiss closes. Under 2 taps for happy path. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, tap count test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | 85% pipeline compliance depends on this being frictionless — every extra tap loses users |
| **Suggested Commit** | `feat(pipeline): create ConfirmReceivedSheet — the most important widget` |

---

### UX-3.03: Create PipelineEntryCard

| Field | Value |
|-------|-------|
| **Task ID** | UX-3.03 |
| **Source Requirement** | PIPE-021 to PIPE-028 (state-driven card) |
| **Affected Screen/Module** | `features/income/presentation/widgets` |
| **Likely Files Affected** | `lib/features/income/presentation/widgets/pipeline_entry_card.dart` (new) |
| **Expected Outcome** | Card displaying single pipeline entry with state-driven visuals. Expected: neutral rail, future date. Pending: caution rail, approaching date. Received: safe rail, confirmed amount. Overdue: red rail, days overdue badge. Shows: amount (PocketaAmount), source label, expected date, Ledger Rail, state label. Tap opens ConfirmReceivedSheet (for non-received entries). |
| **Non-Goals** | Do not handle bulk operations. Single entry card. |
| **Acceptance Criteria** | All 4 visual states render correctly. Tap triggers confirm sheet. Uses doctrine widgets. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, visual test per state |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | State-driven visuals = users learn the system by color without reading labels |
| **Suggested Commit** | `feat(pipeline): create PipelineEntryCard with state-driven visuals` |

---

### UX-3.04: Create PipelineScreen

| Field | Value |
|-------|-------|
| **Task ID** | UX-3.04 |
| **Source Requirement** | PIPE-029 to PIPE-038 (dedicated pipeline tab) |
| **Affected Screen/Module** | `features/income/presentation/views` |
| **Likely Files Affected** | `lib/features/income/presentation/views/pipeline_screen.dart` (new) |
| **Expected Outcome** | Full pipeline management screen (Tab 2 in bottom nav). Grouped by state: Overdue (if any, red header), Expected, Pending, Received (collapsed by default). Each group shows count and total. Overdue section at top with urgent styling. FAB to add new entry. |
| **Non-Goals** | Do not add filtering or search. Simple grouped list. |
| **Acceptance Criteria** | Groups render in correct order. Overdue at top. Counts and totals per group. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, visual inspection with mixed-state data |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Overdue at top creates urgency without alarm — visual priority, not red alerts |
| **Suggested Commit** | `feat(pipeline): create PipelineScreen with state-grouped entries` |

---

### UX-3.05: Create PocketaFxEstimate widget

| Field | Value |
|-------|-------|
| **Task ID** | UX-3.05 |
| **Source Requirement** | PIPE-039 to PIPE-042 (FX as first-class concept) |
| **Affected Screen/Module** | `core/widgets` |
| **Likely Files Affected** | `lib/core/widgets/pocketa_fx_estimate.dart` (new) |
| **Expected Outcome** | Dual-currency display: shows USD amount + BDT estimate at stored FX rate. Label: "~BDT [amount] at [rate]". Uses conservative rate (user-entered, not live). Muted secondary styling for estimate. |
| **Non-Goals** | Do not fetch live FX rates. User-entered conservative rate only. |
| **Acceptance Criteria** | Shows both currencies. Uses stored rate. Muted estimate styling. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, visual test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Conservative FX = user sets cautious rate, Pocketa never overpromises |
| **Suggested Commit** | `feat(widget): create PocketaFxEstimate dual-currency display` |

---

### UX-3.06: Create PocketaMoneySourceLabel widget

| Field | Value |
|-------|-------|
| **Task ID** | UX-3.06 |
| **Source Requirement** | PIPE-043 to PIPE-045 (source labeling) |
| **Affected Screen/Module** | `core/widgets` |
| **Likely Files Affected** | `lib/core/widgets/pocketa_money_source_label.dart` (new) |
| **Expected Outcome** | Compact label showing money source (e.g., "Upwork", "Fiverr", "Direct client", "Bank transfer"). Pill/chip style. Used in pipeline entries and Trust Strip. |
| **Non-Goals** | Do not build source management/CRUD. Label display only. |
| **Acceptance Criteria** | Label renders source name. Pill/chip styling. Consistent with doctrine tokens. `dart analyze` clean. |
| **Verification Method** | `dart analyze` |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Source labels build trust — user sees where each number came from |
| **Suggested Commit** | `feat(widget): create PocketaMoneySourceLabel pill display` |

---

### UX-3.07: Add FX rate input + exclude toggle to add_income_screen

| Field | Value |
|-------|-------|
| **Task ID** | UX-3.07 |
| **Source Requirement** | PIPE-039 to PIPE-042 (FX input), PIPE-046 (exclude toggle) |
| **Affected Screen/Module** | `features/income/presentation/views` |
| **Likely Files Affected** | `lib/features/income/presentation/views/add_income_screen.dart` |
| **Expected Outcome** | Add to existing add income form: FX rate field (shown when currency is USD), exclude from calculation toggle, source label selector (dropdown or text). FX rate pre-fills with last-used rate. |
| **Non-Goals** | Do not redesign entire form. Add 3 fields to existing. |
| **Acceptance Criteria** | FX field visible for USD entries. Exclude toggle works. Source selector works. Data saves to new entity fields. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, form test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | FX rate pre-fill reduces friction — most freelancers use same rate repeatedly |
| **Suggested Commit** | `feat(income): add FX rate, exclude toggle, source label to add income form` |

---

### UX-3.08: Update STS calculator

| Field | Value |
|-------|-------|
| **Task ID** | UX-3.08 |
| **Source Requirement** | PIPE-047 to PIPE-050 (per-entry FX + exclude flag) |
| **Affected Screen/Module** | `features/safe_to_spend/domain` |
| **Likely Files Affected** | `lib/features/safe_to_spend/domain/safe_to_spend_calculator.dart` |
| **Expected Outcome** | Update S2S calculator to: use per-entry fxRate instead of global rate, skip entries where excludeFromCalculation is true, convert USD entries to BDT using their stored conservative rate. No change to core formula structure. |
| **Non-Goals** | Do not change buffer calculation (that's D1.11). Do not add tax reserve. |
| **Acceptance Criteria** | Calculator uses per-entry FX. Excluded entries skipped. Results match manual calculation. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, unit test with mixed USD/BDT entries |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Per-entry FX is more conservative than global — each payment's rate reflects when it was negotiated |
| **Suggested Commit** | `feat(calculator): update STS to use per-entry FX rates and exclude flags` |

---

### UX-3.09: Implement "Duplicate last" gesture

| Field | Value |
|-------|-------|
| **Task ID** | UX-3.09 |
| **Source Requirement** | PIPE-048 (quick-add shortcuts) |
| **Affected Screen/Module** | `features/income/presentation/widgets` |
| **Likely Files Affected** | `lib/features/income/presentation/widgets/pipeline_entry_card.dart` or `pipeline_screen.dart` |
| **Expected Outcome** | Long-press on pipeline entry shows "Duplicate" option. Creates new entry with same amount, source, FX rate but next month's expected date. Reduces friction for recurring freelance payments. |
| **Non-Goals** | Do not build full recurring system. One-tap duplicate only. |
| **Acceptance Criteria** | Long-press triggers option. Duplicate creates correct entry. Date advanced by period. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, gesture test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Duplicate last is 85% compliance shortcut — most freelancers have repeating clients |
| **Suggested Commit** | `feat(pipeline): implement Duplicate Last long-press gesture` |

---

### UX-3.10: Sprint 4 dart analyze clean

| Field | Value |
|-------|-------|
| **Task ID** | UX-3.10 |
| **Source Requirement** | Architecture rule: 0/0/0 analyzer |
| **Affected Screen/Module** | All Sprint 4 files |
| **Likely Files Affected** | Any file with lint issues from Sprint 4 |
| **Expected Outcome** | `dart analyze` returns 0/0/0. |
| **Non-Goals** | Do not fix issues outside Sprint 4 scope. |
| **Acceptance Criteria** | `dart analyze` 0/0/0. |
| **Verification Method** | `dart analyze` |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md`, mark Sprint 4 complete |
| **Learning/Reflection** | Pipeline sprint touches data model + calculator — higher regression risk |
| **Suggested Commit** | `chore(lint): sprint 4 dart analyze clean 0/0/0` |

---

## Sprint 5: UX-4 Microcopy Replacement

### UX-4.01: Audit all hardcoded strings

| Field | Value |
|-------|-------|
| **Task ID** | UX-4.01 |
| **Source Requirement** | COPY-001 to COPY-046 (microcopy system) |
| **Affected Screen/Module** | All `lib/` files |
| **Likely Files Affected** | All screen and widget files containing hardcoded strings |
| **Expected Outcome** | Complete inventory of every hardcoded string in lib/ (not in ARB files). Document each with file:line, current text, and whether it needs replacement. Output: `docs/planning/STRING_AUDIT.md` |
| **Non-Goals** | Do not replace strings yet. Audit only. |
| **Acceptance Criteria** | Every hardcoded user-visible string documented. Count of total strings. Count matching banned phrases. |
| **Verification Method** | Grep for quoted strings in dart files |
| **Docs Update** | Create `docs/planning/STRING_AUDIT.md` |
| **Learning/Reflection** | Audit before replace prevents missed strings and inconsistent half-migrations |
| **Suggested Commit** | `docs(microcopy): audit all hardcoded strings across lib/` |

---

### UX-4.02: Rewrite app_en.arb

| Field | Value |
|-------|-------|
| **Task ID** | UX-4.02 |
| **Source Requirement** | COPY-001 to COPY-046 (all English copy per Microcopy System) |
| **Affected Screen/Module** | `l10n` |
| **Likely Files Affected** | `lib/l10n/app_en.arb` (rewrite) |
| **Expected Outcome** | All English strings rewritten to match doctrine: "Safe to spend" not "Available balance", "Pipeline entry" not "Transaction", no "budget/budgeting", no "pocket accountant", no "smart", no celebratory language. Every screen's strings present. |
| **Non-Goals** | Do not change Bangla file yet (separate task). Do not wire to screens yet. |
| **Acceptance Criteria** | All keys present for all screens. Zero banned phrases. Tone matches Microcopy System. |
| **Verification Method** | Grep for banned phrases, manual tone review |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | ARB rewrite before wiring prevents partial migration states |
| **Suggested Commit** | `feat(l10n): rewrite app_en.arb with doctrine-aligned English copy` |

---

### UX-4.03: Author app_bn.arb

| Field | Value |
|-------|-------|
| **Task ID** | UX-4.03 |
| **Source Requirement** | COPY-040 to COPY-046 (Bangla as native, not translated) |
| **Affected Screen/Module** | `l10n` |
| **Likely Files Affected** | `lib/l10n/app_bn.arb` (rewrite) |
| **Expected Outcome** | Bangla strings authored natively (not machine-translated from English). Must feel natural to Bangladeshi Bengali speakers. "Safe to spend" = "এখন খরচ করতে পারবেন" (culturally appropriate equivalent). All keys matching app_en.arb. |
| **Non-Goals** | Do not use Google Translate. Native authoring required. |
| **Acceptance Criteria** | All keys present matching English. Native Bangla (not translated). Culturally appropriate. |
| **Verification Method** | Native speaker review |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Translated Bangla reads as foreign — must be authored by native speaker |
| **Suggested Commit** | `feat(l10n): author native Bangla strings in app_bn.arb` |

---

### UX-4.04: Replace all hardcoded strings with l10n keys

| Field | Value |
|-------|-------|
| **Task ID** | UX-4.04 |
| **Source Requirement** | COPY-001 to COPY-046 (all copy through l10n) |
| **Affected Screen/Module** | All screens and widgets |
| **Likely Files Affected** | Every file identified in UX-4.01 audit |
| **Expected Outcome** | Every user-visible hardcoded string replaced with `AppLocalizations.of(context).keyName` call. No remaining hardcoded strings except technical/debug text. |
| **Non-Goals** | Do not change string content (already done in UX-4.02/03). Wiring only. |
| **Acceptance Criteria** | Zero hardcoded user-visible strings. All use l10n. App displays correctly in both languages. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, grep for remaining hardcoded strings |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Systematic replacement using audit file prevents random missed strings |
| **Suggested Commit** | `refactor(l10n): replace all hardcoded strings with localization keys` |

---

### UX-4.05: Implement lakh/crore in all amount displays

| Field | Value |
|-------|-------|
| **Task ID** | UX-4.05 |
| **Source Requirement** | COPY-030 to COPY-035 (BDT formatting) |
| **Affected Screen/Module** | All screens displaying money amounts |
| **Likely Files Affected** | All screens using amount display that don't yet use PocketaAmount |
| **Expected Outcome** | Every BDT amount display uses PocketaAmount widget or number_formatter utility. No Western comma grouping for BDT. All amounts show lakh/crore format. |
| **Non-Goals** | Do not change amount storage format. Display only. |
| **Acceptance Criteria** | Every BDT display uses lakh/crore. No `1,245,000` format anywhere. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, visual sweep of all screens |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Lakh/crore is not cosmetic — Bangladeshi users think in lakhs, Western format is confusing |
| **Suggested Commit** | `feat(display): implement lakh/crore formatting across all amount displays` |

---

### UX-4.06: Implement "show your work" copy

| Field | Value |
|-------|-------|
| **Task ID** | UX-4.06 |
| **Source Requirement** | UX-078 to UX-082 (calculation transparency) |
| **Affected Screen/Module** | `core/widgets` (PocketaCalculationTrace) |
| **Likely Files Affected** | `lib/core/widgets/pocketa_calculation_trace.dart` |
| **Expected Outcome** | Calculation trace lines use doctrine copy: "Your balance", "Minus fixed costs", "Minus breathing room", "Equals safe to spend". Not: "Income", "Expenses", "Buffer", "Available". Each line has l10n key. |
| **Non-Goals** | Do not change calculation logic. Copy layer only. |
| **Acceptance Criteria** | All trace lines use doctrine terminology. L10n keys used. Both languages correct. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, visual review |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | "Show your work" builds trust — users verify Pocketa's math themselves |
| **Suggested Commit** | `feat(copy): implement show-your-work terminology in calculation trace` |

---

### UX-4.07: Verify banned phrase list

| Field | Value |
|-------|-------|
| **Task ID** | UX-4.07 |
| **Source Requirement** | COPY-010 to COPY-015 (banned phrases) |
| **Affected Screen/Module** | All files |
| **Likely Files Affected** | Any file still containing banned phrases |
| **Expected Outcome** | Grep entire codebase for banned phrases: "budget", "budgeting", "expense tracker", "pocket accountant", "smart", "AI-powered", "your finances", "savings goal", "financial advisor", "investment", "wealth". Zero matches in user-visible strings. |
| **Non-Goals** | Technical comments referencing these terms are OK. User-visible strings only. |
| **Acceptance Criteria** | Zero banned phrases in user-visible strings (ARB files, hardcoded strings). |
| **Verification Method** | Grep for each banned phrase |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Banned phrase check is final gate — prevents identity confusion at beta |
| **Suggested Commit** | `chore(copy): verify zero banned phrases in user-visible strings` |

---

### UX-4.08: Sprint 5 dart analyze clean

| Field | Value |
|-------|-------|
| **Task ID** | UX-4.08 |
| **Source Requirement** | Architecture rule: 0/0/0 analyzer |
| **Affected Screen/Module** | All Sprint 5 files |
| **Likely Files Affected** | Any file with lint issues |
| **Expected Outcome** | `dart analyze` 0/0/0. |
| **Non-Goals** | None. |
| **Acceptance Criteria** | `dart analyze` 0/0/0. |
| **Verification Method** | `dart analyze` |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md`, mark Sprint 5 complete |
| **Learning/Reflection** | Microcopy sprint touches many files — high risk of import/reference breakage |
| **Suggested Commit** | `chore(lint): sprint 5 dart analyze clean 0/0/0` |

---

## Sprint 6: D1 Trust Layer Foundation

### D1.01: Create auth feature module

| Field | Value |
|-------|-------|
| **Task ID** | D1.01 |
| **Source Requirement** | PC-060 to PC-065 (trust layer), GAP-015 |
| **Affected Screen/Module** | `features/auth` (new module) |
| **Likely Files Affected** | `lib/features/auth/domain/entities/auth_state.dart`, `lib/features/auth/presentation/views/pin_setup_screen.dart`, `lib/features/auth/presentation/views/pin_entry_screen.dart` (all new) |
| **Expected Outcome** | New feature module: auth. PIN setup screen (4-digit + confirm). PIN entry screen (4-digit with attempt counter). Auth state entity (authenticated, locked, setup_required). Feature-first clean architecture. |
| **Non-Goals** | Do not add Magic Link auth (deferred per doctrine). PIN only for MVP. |
| **Acceptance Criteria** | Module structure correct. Screens render. State model compiles. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, screen render test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Auth module is new feature — follow existing module patterns exactly |
| **Suggested Commit** | `feat(auth): create auth feature module with PIN setup and entry screens` |

---

### D1.02: Create PIN state management

| Field | Value |
|-------|-------|
| **Task ID** | D1.02 |
| **Source Requirement** | PC-060 to PC-065 (auth requirement) |
| **Affected Screen/Module** | `features/auth/presentation/providers` |
| **Likely Files Affected** | `lib/features/auth/presentation/providers/auth_provider.dart` (new) |
| **Expected Outcome** | Riverpod provider for auth state. Stores PIN hash in Hive (new box). Tracks: isSetUp, isAuthenticated, failedAttempts. Auto-lock after 5 failed attempts (requires app restart). No plaintext PIN storage. |
| **Non-Goals** | Do not implement server-side auth. Local PIN only. |
| **Acceptance Criteria** | Provider compiles. PIN hash stored (not plaintext). Failed attempt tracking works. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, unit test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | PIN hash must use proper crypto — SHA-256 minimum, no plaintext |
| **Suggested Commit** | `feat(auth): create PIN state management with Riverpod + Hive` |

---

### D1.03: Wire auth guard into router

| Field | Value |
|-------|-------|
| **Task ID** | D1.03 |
| **Source Requirement** | PC-062 (PIN required on every app open) |
| **Affected Screen/Module** | `config/router` |
| **Likely Files Affected** | `lib/config/router/app_router.dart` |
| **Expected Outcome** | GoRouter redirect guard: if PIN is set up and user not authenticated, redirect to PIN entry. Runs on every app open (cold start + background resume). Does not block onboarding (PIN set up during onboarding Step 7). |
| **Non-Goals** | Do not add per-screen auth. App-level gate only. |
| **Acceptance Criteria** | App requires PIN on open. Onboarding accessible without PIN. Background resume triggers PIN. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, app lifecycle test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Auth guard must not block onboarding — new users haven't set PIN yet |
| **Suggested Commit** | `feat(auth): wire PIN auth guard into GoRouter` |

---

### D1.04: Create biometric support

| Field | Value |
|-------|-------|
| **Task ID** | D1.04 |
| **Source Requirement** | PC-063 (biometric optional) |
| **Affected Screen/Module** | `features/auth` |
| **Likely Files Affected** | `lib/features/auth/presentation/providers/auth_provider.dart`, PIN entry screen |
| **Expected Outcome** | Optional biometric unlock (fingerprint/face) using local_auth package. Offered during PIN setup if device supports it. Fallback to PIN always available. Does not replace PIN — supplements it. |
| **Non-Goals** | Do not require biometric. Always optional with PIN fallback. |
| **Acceptance Criteria** | Biometric prompt shows if available. Works on supported devices. PIN fallback always works. Graceful failure on unsupported devices. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, device test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Many budget Android phones lack biometric — PIN must always be primary |
| **Suggested Commit** | `feat(auth): add optional biometric authentication support` |

---

### D1.05: Create audit event entity + Hive model

| Field | Value |
|-------|-------|
| **Task ID** | D1.05 |
| **Source Requirement** | PC-066 to PC-070 (audit logging), GAP-016 |
| **Affected Screen/Module** | `features/audit_log` (new module) |
| **Likely Files Affected** | `lib/features/audit_log/domain/entities/audit_event.dart`, `lib/features/audit_log/data/models/audit_event_model.dart`, `lib/features/audit_log/data/datasources/audit_local_data_source.dart` (all new) |
| **Expected Outcome** | Audit event entity: id, timestamp, eventType (enum: created, updated, deleted, confirmed, exported), entityType (income, transaction, settings), entityId, previousValue, newValue, description. Hive model with TypeAdapter. Local data source for CRUD. |
| **Non-Goals** | Do not wire to screens yet. Data layer only. |
| **Acceptance Criteria** | Entity and model compile. Hive adapter registered. Data source CRUD works. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, unit test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Audit events are append-only — never delete or modify audit records |
| **Suggested Commit** | `feat(audit): create audit event entity, Hive model, and local data source` |

---

### D1.06: Wire audit logging to financial edit paths

| Field | Value |
|-------|-------|
| **Task ID** | D1.06 |
| **Source Requirement** | PC-067 (all financial changes logged) |
| **Affected Screen/Module** | `features/income`, `features/transactions`, `features/safe_to_spend` |
| **Likely Files Affected** | All repository/data source files that modify financial data |
| **Expected Outcome** | Every create/update/delete of income entries, transactions, and S2S settings writes an audit event. Captures before/after values. Automatic — not opt-in per screen. |
| **Non-Goals** | Do not audit read operations. Write operations only. |
| **Acceptance Criteria** | Income CRUD creates audit events. Transaction CRUD creates audit events. Settings changes create audit events. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, create income entry and verify audit box has event |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Audit at data source level (not UI level) ensures nothing slips through |
| **Suggested Commit** | `feat(audit): wire audit logging to all financial edit paths` |

---

### D1.07: Create audit log display screen

| Field | Value |
|-------|-------|
| **Task ID** | D1.07 |
| **Source Requirement** | PC-068 (user can view audit trail) |
| **Affected Screen/Module** | `features/audit_log/presentation` |
| **Likely Files Affected** | `lib/features/audit_log/presentation/views/audit_log_screen.dart` (new) |
| **Expected Outcome** | Screen showing chronological audit events. Each event shows: timestamp, action type, entity affected, before/after values. Scrollable list, newest first. Accessible from Settings tab. |
| **Non-Goals** | Do not add filtering or export from this screen. View only. |
| **Acceptance Criteria** | Screen renders audit events. Chronological order. Shows all event details. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, visual inspection |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Audit log display builds trust — user can verify exactly what changed and when |
| **Suggested Commit** | `feat(audit): create audit log display screen` |

---

### D1.08: Create CSV export service

| Field | Value |
|-------|-------|
| **Task ID** | D1.08 |
| **Source Requirement** | PC-071 to PC-073 (data export), GAP-017 |
| **Affected Screen/Module** | `features/export` (new module) |
| **Likely Files Affected** | `lib/features/export/domain/export_service.dart` (new) |
| **Expected Outcome** | Service that exports all user data to CSV: income entries (with all fields), transactions, S2S settings, audit log. One CSV per entity type. Zipped into single file. Uses temporary directory for file creation. |
| **Non-Goals** | Do not build JSON or PDF export. CSV only for MVP. |
| **Acceptance Criteria** | Exports all 4 entity types. CSV format correct. Handles empty data. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, export test with sample data |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | CSV export is trust layer requirement — user's data is always theirs to take |
| **Suggested Commit** | `feat(export): create CSV export service for all financial data` |

---

### D1.09: Create export screen with share action

| Field | Value |
|-------|-------|
| **Task ID** | D1.09 |
| **Source Requirement** | PC-071 to PC-073 (export UI) |
| **Affected Screen/Module** | `features/export/presentation` |
| **Likely Files Affected** | `lib/features/export/presentation/views/export_screen.dart` (new) |
| **Expected Outcome** | Screen with "Export my data" button. Shows what will be exported. Triggers CSV export service. Opens share sheet with generated file. Accessible from Settings tab. |
| **Non-Goals** | Do not add cloud backup. Local export via share only. |
| **Acceptance Criteria** | Screen renders. Export button triggers service. Share sheet opens with file. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, export flow test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Share sheet leverages OS native sharing — no custom email/upload needed |
| **Suggested Commit** | `feat(export): create export screen with share action` |

---

### D1.10: Create account deletion flow

| Field | Value |
|-------|-------|
| **Task ID** | D1.10 |
| **Source Requirement** | PC-074 to PC-076 (account deletion), GAP-018 |
| **Affected Screen/Module** | `features/account` (new module) |
| **Likely Files Affected** | `lib/features/account/presentation/views/delete_account_screen.dart` (new) |
| **Expected Outcome** | Screen with clear deletion warning. Requires PIN confirmation before deletion. Deletes ALL Hive boxes (income, transactions, settings, audit, auth). Returns to welcome screen. Copy: "This will permanently delete all your data. This cannot be undone." |
| **Non-Goals** | Do not add data recovery. Permanent deletion only. |
| **Acceptance Criteria** | PIN required to confirm. All Hive boxes cleared. Returns to welcome/onboarding. Clear warning copy. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, deletion flow test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Account deletion is trust requirement — users must always have an exit |

**Important: This is an irreversible action. The confirmation flow must use clear, unambiguous language and require explicit PIN entry — not a simple "Are you sure?" dialog.**

| **Suggested Commit** | `feat(account): create account deletion flow with PIN confirmation` |

---

### D1.11: Convert anxiety buffer to percentage

| Field | Value |
|-------|-------|
| **Task ID** | D1.11 |
| **Source Requirement** | GAP-009 (buffer is absolute BDT, should be percentage) |
| **Affected Screen/Module** | `features/safe_to_spend` |
| **Likely Files Affected** | `lib/features/safe_to_spend/domain/entities/sts_settings.dart`, `lib/features/safe_to_spend/domain/safe_to_spend_calculator.dart`, `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart` |
| **Expected Outcome** | Buffer stored as percentage (5-30%, default 15%) instead of absolute BDT amount. Calculator computes buffer as percentage of total expected income. Settings screen shows percentage slider. Migration: convert existing absolute values to nearest percentage. |
| **Non-Goals** | Do not change other calculator behavior. Buffer format change only. |
| **Acceptance Criteria** | Buffer stored as percentage. Calculator uses percentage. Settings shows slider 5-30%. Default 15%. Existing data migrated. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, calculation test, migration test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Percentage buffer scales with income — absolute BDT becomes meaningless as income changes |
| **Suggested Commit** | `refactor(calculator): convert anxiety buffer from absolute BDT to percentage (5-30%, default 15%)` |

---

### D1.12: Sprint 6 dart analyze clean

| Field | Value |
|-------|-------|
| **Task ID** | D1.12 |
| **Source Requirement** | Architecture rule: 0/0/0 analyzer |
| **Affected Screen/Module** | All Sprint 6 files |
| **Likely Files Affected** | Any file with lint issues |
| **Expected Outcome** | `dart analyze` 0/0/0. |
| **Non-Goals** | None. |
| **Acceptance Criteria** | `dart analyze` 0/0/0. |
| **Verification Method** | `dart analyze` |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md`, mark Sprint 6 complete |
| **Learning/Reflection** | Trust layer sprint adds 3 new feature modules — high integration risk |
| **Suggested Commit** | `chore(lint): sprint 6 dart analyze clean 0/0/0` |

---

## Sprint 7: D2 Beta Instrumentation

### D2.01: Create analytics service abstraction

| Field | Value |
|-------|-------|
| **Task ID** | D2.01 |
| **Source Requirement** | PC-077 to PC-079 (beta measurement) |
| **Affected Screen/Module** | `core/analytics` (new) |
| **Likely Files Affected** | `lib/core/analytics/analytics_service.dart` (new) |
| **Expected Outcome** | Abstract analytics service interface. Methods: trackEvent(name, properties), trackScreen(name), setUserProperty(key, value). Default implementation: local-only logging (no external service for MVP). Swappable for Firebase/Mixpanel later. |
| **Non-Goals** | Do not integrate external analytics SDK. Interface + local impl only. |
| **Acceptance Criteria** | Interface defined. Local implementation works. Events logged locally. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, unit test |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Abstraction first, vendor later — avoids SDK lock-in during beta |
| **Suggested Commit** | `feat(analytics): create analytics service abstraction with local implementation` |

---

### D2.02: Create event registry

| Field | Value |
|-------|-------|
| **Task ID** | D2.02 |
| **Source Requirement** | PC-077 (transactional + boundary classes only) |
| **Affected Screen/Module** | `core/analytics` |
| **Likely Files Affected** | `lib/core/analytics/event_registry.dart` (new) |
| **Expected Outcome** | Typed event constants for beta tracking. Two classes only: Transactional (pipeline_entry_created, pipeline_confirmed, sts_viewed, export_triggered) and Boundary (sts_at_risk_entered, reserve_depleted, first_pipeline_entry). No vanity metrics. No screen view tracking for every screen. |
| **Non-Goals** | Do not track engagement metrics. Only actionable beta gates. |
| **Acceptance Criteria** | Events categorized into 2 classes. Names follow convention. No vanity events. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, review event list against beta gates |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Two-class system prevents analytics bloat — only measure what validates beta gates |
| **Suggested Commit** | `feat(analytics): create event registry with transactional + boundary classes` |

---

### D2.03: Wire S2S view events

| Field | Value |
|-------|-------|
| **Task ID** | D2.03 |
| **Source Requirement** | Beta gate: daily S2S check frequency |
| **Affected Screen/Module** | `features/dashboard`, `features/safe_to_spend` |
| **Likely Files Affected** | Dashboard screen, S2S hero widget |
| **Expected Outcome** | Track: sts_viewed (each time dashboard opens), session_duration (app foreground time), daily_active (unique day check). These validate beta gate: "users check S2S daily." |
| **Non-Goals** | Do not track scroll depth or tap patterns. Macro behavior only. |
| **Acceptance Criteria** | Events fire on dashboard open. Session duration tracked. Daily active recorded. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, local analytics log review |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Daily check frequency is primary beta gate — must measure accurately |
| **Suggested Commit** | `feat(analytics): wire S2S view events for beta validation` |

---

### D2.04: Wire pipeline compliance events

| Field | Value |
|-------|-------|
| **Task ID** | D2.04 |
| **Source Requirement** | Beta gate: 85% pipeline compliance |
| **Affected Screen/Module** | `features/income` |
| **Likely Files Affected** | Pipeline-related screens and providers |
| **Expected Outcome** | Track: pipeline_state_changed (with from/to states), time_to_confirm (duration from Expected to Received), overdue_count (entries past expected date without confirmation). These validate beta gate: "85% pipeline compliance." |
| **Non-Goals** | Do not track individual entry details. Aggregate compliance only. |
| **Acceptance Criteria** | State changes tracked. Time-to-confirm measured. Overdue count available. `dart analyze` clean. |
| **Verification Method** | `dart analyze`, local analytics log review |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | 85% compliance = most important product metric — measurement must be precise |
| **Suggested Commit** | `feat(analytics): wire pipeline compliance events for beta validation` |

---

### D2.05: Wire notification events

| Field | Value |
|-------|-------|
| **Task ID** | D2.05 |
| **Source Requirement** | Beta gate: notification response rates |
| **Affected Screen/Module** | Notification service (if exists) |
| **Likely Files Affected** | Notification handler files |
| **Expected Outcome** | Track: notification_sent (type + timestamp), notification_opened (type + latency), notification_dismissed (type). Only transactional and boundary notifications tracked. Validates: "notifications drive pipeline updates." |
| **Non-Goals** | Do not build notification system in this task. Wire events if system exists, stub if not. |
| **Acceptance Criteria** | Events defined and wired (or stubbed). `dart analyze` clean. |
| **Verification Method** | `dart analyze` |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md` |
| **Learning/Reflection** | Notification events may be stubbed if notification system isn't built yet |
| **Suggested Commit** | `feat(analytics): wire notification events for beta validation` |

---

### D2.06: Sprint 7 dart analyze clean

| Field | Value |
|-------|-------|
| **Task ID** | D2.06 |
| **Source Requirement** | Architecture rule: 0/0/0 analyzer |
| **Affected Screen/Module** | All Sprint 7 files |
| **Likely Files Affected** | Any file with lint issues |
| **Expected Outcome** | `dart analyze` 0/0/0. |
| **Non-Goals** | None. |
| **Acceptance Criteria** | `dart analyze` 0/0/0. |
| **Verification Method** | `dart analyze` |
| **Docs Update** | Update `docs/tracking/CURRENT_SPRINT.md`, mark Sprint 7 complete |
| **Learning/Reflection** | Instrumentation sprint is low-risk — mostly additive, no data model changes |
| **Suggested Commit** | `chore(lint): sprint 7 dart analyze clean 0/0/0` |

---

## Sprint 8: D3 Closed Beta Readiness

### D3.01: End-to-end flow test

| Field | Value |
|-------|-------|
| **Task ID** | D3.01 |
| **Source Requirement** | AC-001 to AC-005 (acceptance criteria) |
| **Affected Screen/Module** | All |
| **Likely Files Affected** | None (test only) |
| **Expected Outcome** | Full flow test: fresh install -> welcome -> 7-step onboarding -> dashboard with S2S visible -> add pipeline entry -> confirm received -> S2S updates. All transitions smooth. No crashes. Data persists across app restart. |
| **Non-Goals** | Do not fix bugs found during test in this task. Document them. |
| **Acceptance Criteria** | Complete flow works without crash. S2S visible after onboarding. Pipeline flow completes. Data persists. |
| **Verification Method** | Manual test on device, document results |
| **Docs Update** | Create `docs/testing/E2E_RESULTS.md` |
| **Learning/Reflection** | E2E test on real device reveals issues emulator hides |
| **Suggested Commit** | `docs(testing): document end-to-end flow test results` |

---

### D3.02: Performance test on reference device

| Field | Value |
|-------|-------|
| **Task ID** | D3.02 |
| **Source Requirement** | PC-040 to PC-045 (Samsung A14 / 3G reference) |
| **Affected Screen/Module** | All |
| **Likely Files Affected** | None (test only), possibly performance fixes |
| **Expected Outcome** | Test on Samsung A14 (or equivalent low-end Android) on 3G connection. Measure: cold start time (<3s target), dashboard render (<1s), pipeline list scroll (60fps), onboarding flow completion. Document results. |
| **Non-Goals** | Do not optimize for flagship devices. Low-end is the reference. |
| **Acceptance Criteria** | Cold start <3s. Dashboard renders <1s. Scroll at 60fps. No jank. |
| **Verification Method** | Device test with performance profiling |
| **Docs Update** | Create `docs/testing/PERFORMANCE_RESULTS.md` |
| **Learning/Reflection** | Bangladesh primary device = budget Android. If it works on A14, it works everywhere. |
| **Suggested Commit** | `docs(testing): document performance test results on reference device` |

---

### D3.03: Accessibility audit

| Field | Value |
|-------|-------|
| **Task ID** | D3.03 |
| **Source Requirement** | VIS-040 to VIS-045, VISR-029 to VISR-034 (contrast, touch targets) |
| **Affected Screen/Module** | All screens |
| **Likely Files Affected** | Any screen failing accessibility checks |
| **Expected Outcome** | Audit: contrast ratios (4.5:1 minimum for text, 3:1 for large text), touch targets (48x48dp minimum), screen reader labels (all interactive elements), focus order (logical tab sequence). Document findings. Fix critical issues. |
| **Non-Goals** | Do not target WCAG AAA. AA level for MVP. |
| **Acceptance Criteria** | All text meets 4.5:1 contrast. All touch targets 48x48dp. Screen reader navigable. |
| **Verification Method** | Flutter accessibility inspector, contrast checker tool |
| **Docs Update** | Create `docs/testing/ACCESSIBILITY_AUDIT.md` |
| **Learning/Reflection** | Outdoor Dhaka sunlight = high contrast mandatory, not optional |
| **Suggested Commit** | `docs(testing): document accessibility audit results` |

---

### D3.04: Microcopy audit against banned phrases

| Field | Value |
|-------|-------|
| **Task ID** | D3.04 |
| **Source Requirement** | COPY-010 to COPY-015 (banned phrases final check) |
| **Affected Screen/Module** | All |
| **Likely Files Affected** | Any file with remaining banned phrases |
| **Expected Outcome** | Final sweep: grep all user-visible strings for banned phrases. Cross-reference with UX-4.07 results. Verify zero banned phrases remain after all sprint changes. |
| **Non-Goals** | Should be clean from UX-4.07. This is verification only. |
| **Acceptance Criteria** | Zero banned phrases in final build. |
| **Verification Method** | Grep for each banned phrase across all files |
| **Docs Update** | Update `docs/testing/ACCESSIBILITY_AUDIT.md` or create `docs/testing/COPY_AUDIT.md` |
| **Learning/Reflection** | Final copy audit catches phrases introduced during later sprints |
| **Suggested Commit** | `docs(testing): final microcopy audit — zero banned phrases confirmed` |

---

### D3.05: Real vs Hopeful Money Test

| Field | Value |
|-------|-------|
| **Task ID** | D3.05 |
| **Source Requirement** | AC-020 to AC-025 (Real vs Hopeful Money Test) |
| **Affected Screen/Module** | All screens showing financial amounts |
| **Likely Files Affected** | Any screen conflating real and pipeline money |
| **Expected Outcome** | Review every screen for Real vs Hopeful Money distinction. Real money (received, confirmed) must never be mixed visually with hopeful money (expected, pending pipeline). Pipeline amounts must always have "not counted yet" framing. S2S must only include received money. |
| **Non-Goals** | Do not change S2S formula. Visual/copy verification only. |
| **Acceptance Criteria** | No screen mixes real and hopeful money without clear distinction. Pipeline always labeled. S2S uses only received. |
| **Verification Method** | Screen-by-screen visual review |
| **Docs Update** | Create `docs/testing/REAL_VS_HOPEFUL_TEST.md` |
| **Learning/Reflection** | This is THE product test — if users confuse real and hopeful money, the product fails |
| **Suggested Commit** | `docs(testing): Real vs Hopeful Money Test results` |

---

### D3.06: Bangladeshi Freelancer Test

| Field | Value |
|-------|-------|
| **Task ID** | D3.06 |
| **Source Requirement** | AC-026 to AC-033 (Bangladeshi Freelancer Test) |
| **Affected Screen/Module** | All |
| **Likely Files Affected** | Any screen failing the test |
| **Expected Outcome** | Persona test: Bangladeshi freelancer earning USD from Upwork, paid in BDT via bKash. Verify: BDT as primary currency, lakh/crore formatting, conservative FX handling, pipeline reflects freelance reality (irregular, multi-source), Bangla copy feels native, S2S answers "how much can I spend in BDT right now?" |
| **Non-Goals** | Not a usability study. Internal persona validation only. |
| **Acceptance Criteria** | All persona touchpoints pass. BDT primary. FX handled. Pipeline works for freelance pattern. Bangla feels native. |
| **Verification Method** | Walkthrough with persona scenario |
| **Docs Update** | Create `docs/testing/FREELANCER_TEST.md` |
| **Learning/Reflection** | If it doesn't work for this exact persona, it doesn't work at all |
| **Suggested Commit** | `docs(testing): Bangladeshi Freelancer Test results` |

---

### D3.07: Resolve remaining doctrine conflicts

| Field | Value |
|-------|-------|
| **Task ID** | D3.07 |
| **Source Requirement** | All gap documents, conflict resolutions |
| **Affected Screen/Module** | Varies |
| **Likely Files Affected** | Varies based on findings |
| **Expected Outcome** | Review all documented gaps (GAP-001 to GAP-033) and verify each is resolved or explicitly deferred with rationale. No unresolved MVP-blocking gaps. Update gap document with final status per item. |
| **Non-Goals** | Do not resolve V1/V2 deferred items. MVP gaps only. |
| **Acceptance Criteria** | All 8 MVP-blocking gaps resolved. All other gaps have documented status. |
| **Verification Method** | Gap document review |
| **Docs Update** | Update `docs/ux/extracted/12_conflicts_and_overrides.md` |
| **Learning/Reflection** | Gap resolution is final quality gate before beta tag |
| **Suggested Commit** | `docs(planning): resolve all MVP-blocking doctrine gaps` |

---

### D3.08: Final dart analyze + tag beta release

| Field | Value |
|-------|-------|
| **Task ID** | D3.08 |
| **Source Requirement** | Architecture rule + beta readiness |
| **Affected Screen/Module** | All |
| **Likely Files Affected** | Any remaining lint issues |
| **Expected Outcome** | Final `dart analyze` 0/0/0. All tests pass. All testing docs complete. Tag release as `v0.1.0-beta.1`. Update ROADMAP.md to reflect beta milestone. |
| **Non-Goals** | Do not publish to Play Store. Internal beta only. |
| **Acceptance Criteria** | `dart analyze` 0/0/0. All test docs complete. Git tag created. ROADMAP updated. |
| **Verification Method** | `dart analyze`, `git tag`, doc review |
| **Docs Update** | Update `docs/core/ROADMAP.md`, `docs/tracking/PROJECT_STATE.md` |
| **Learning/Reflection** | Beta tag is a milestone, not a finish line — begins validation phase |
| **Suggested Commit** | `chore(release): final dart analyze clean + tag v0.1.0-beta.1` |

---

## Summary

| Sprint | Tasks | Key Risk |
|--------|-------|----------|
| UX-5 Design System | 12 | Font loading on low-end devices |
| UX-1 Dashboard | 14 | 620-line screen rewrite |
| UX-2 Onboarding | 11 | 3-page to 7-step rewrite |
| UX-3 Pipeline | 10 | Hive model migration |
| UX-4 Microcopy | 8 | Cross-file string replacement |
| D1 Trust Layer | 12 | 3 new feature modules |
| D2 Instrumentation | 6 | Low risk (additive) |
| D3 Beta Readiness | 8 | Integration testing |
| **Total** | **81** | |
