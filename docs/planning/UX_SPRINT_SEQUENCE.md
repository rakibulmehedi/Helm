# UX Sprint Sequence

> Implementation order for Pocketa UX Canon. Each sprint builds on prior.
> No lib/ changes in this planning sprint. This is the execution roadmap.
> Updated: 2026-06-05

---

## Sprint Overview

| Sprint | ID | Name | Depends On | Estimated Tasks |
|--------|-----|------|------------|-----------------|
| 1 | UX-5 | Visual Identity / Design System | None | 12 tasks |
| 2 | UX-1 | Dashboard Cockpit Redesign | UX-5 | 14 tasks |
| 3 | UX-2 | Onboarding Redesign | UX-5 | 11 tasks |
| 4 | UX-3 | Pipeline Quick-Update | UX-1, UX-5 | 10 tasks |
| 5 | UX-4 | Microcopy Replacement | UX-1, UX-2, UX-3 | 8 tasks |
| 6 | D1 | Trust Layer Foundation | UX-2 | 12 tasks |
| 7 | D2 | Beta Instrumentation | D1 | 6 tasks |
| 8 | D3 | Closed Beta Readiness | All above | 8 tasks |
| | | **Total** | | **81 tasks** |

---

## Sprint 1: UX-5 Visual Identity / Design System

**Rationale:** Foundation. Every other sprint depends on correct colors, typography, spacing, and widgets.

### Tasks
1. UX-5.01: Create `pocketa_colors.dart` with full doctrine palette
2. UX-5.02: Create `pocketa_typography.dart` with Inter + JetBrains Mono + Hind Siliguri
3. UX-5.03: Create `pocketa_spacing.dart` with 8pt grid tokens
4. UX-5.04: Create `pocketa_motion.dart` with animation timing tokens
5. UX-5.05: Rebuild `app_theme.dart` using new token files
6. UX-5.06: Create `PocketaAmount` widget (lakh/crore formatting)
7. UX-5.07: Create `PocketaLedgerRail` widget
8. UX-5.08: Create `PocketaTrustStrip` widget
9. UX-5.09: Create `PocketaToast` widget
10. UX-5.10: Create 5 card widgets (HeroZone, LedgerCard, AuditCard, SourceCard, CautionCard)
11. UX-5.11: Create `number_formatter.dart` (BDT lakh/crore, USD Western, 2 decimals)
12. UX-5.12: dart analyze clean + verify 0/0/0

---

## Sprint 2: UX-1 Dashboard Cockpit Redesign

**Rationale:** Home screen is the product. Must be rebuilt before anything else is visible.

### Tasks
1. UX-1.01: Create `PocketaRealityStack` widget
2. UX-1.02: Create `PocketaCalculationTrace` widget with stagger animation
3. UX-1.03: Create `PocketaHeroZone` with S2S display + Ledger Rail + Trust Strip
4. UX-1.04: Create "Already committed" section (upcoming obligations display)
5. UX-1.05: Create "Reserve protected" section
6. UX-1.06: Create "Not counted yet" section (pipeline summary)
7. UX-1.07: Create bottom navigation (4 tabs: Home, Pipeline, History, Settings)
8. UX-1.08: Redesign `dashboard_screen.dart` to Reality Stack layout
9. UX-1.09: Replace breakdown bottom sheet with PocketaCalculationTrace
10. UX-1.10: Add FAB "Add Pipeline Entry" (not "Add Transaction")
11. UX-1.11: Remove dev reset button from production (gate with kDebugMode)
12. UX-1.12: Implement empty state (zero pipeline, runway emphasis)
13. UX-1.13: Implement Reserve Mode layout variant
14. UX-1.14: dart analyze clean + verify 0/0/0

---

## Sprint 3: UX-2 Onboarding Redesign

**Rationale:** Onboarding is the trust handshake. Captures data needed for S2S to work.

### Tasks
1. UX-2.01: Create onboarding data model (multi-step state)
2. UX-2.02: Create pain qualifier page (Step 1)
3. UX-2.03: Create liquid balance page (Step 2)
4. UX-2.04: Create fixed costs page (Step 3 -- guided checklist)
5. UX-2.05: Create income pattern page (Step 4 -- 3 picture cards)
6. UX-2.06: Create buffer comfort page (Step 5 -- slider with live BDT preview)
7. UX-2.07: Create first pipeline entry page (Step 6 -- optional)
8. UX-2.08: Create PIN setup page (Step 7)
9. UX-2.09: Wire 7-step flow in onboarding_screen.dart
10. UX-2.10: Fix welcome screen copy (remove "pocket accountant" / "Smart budgeting")
11. UX-2.11: Delete dead stub files + dart analyze clean

---

## Sprint 4: UX-3 Pipeline Quick-Update

**Rationale:** Pipeline maintenance drives S2S accuracy. 85% compliance = most important metric.

### Tasks
1. UX-3.01: Add fxRate, excludeFromCalculation, sourceLabel fields to income entity/model
2. UX-3.02: Create `ConfirmReceivedSheet` widget (the most important widget)
3. UX-3.03: Create `PipelineEntryCard` (state-driven display)
4. UX-3.04: Create `PipelineScreen` (grouped by state, overdue section)
5. UX-3.05: Create `PocketaFxEstimate` widget
6. UX-3.06: Create `PocketaMoneySourceLabel` widget
7. UX-3.07: Add FX rate input + exclude toggle to add_income_screen
8. UX-3.08: Update STS calculator to use per-entry FX + exclude flag
9. UX-3.09: Implement "Duplicate last" long-press gesture
10. UX-3.10: dart analyze clean + verify 0/0/0

---

## Sprint 5: UX-4 Microcopy Replacement

**Rationale:** All strings must align with Microcopy System before beta users see them.

### Tasks
1. UX-4.01: Audit all hardcoded strings across lib/
2. UX-4.02: Rewrite app_en.arb with all doctrine-aligned English strings
3. UX-4.03: Author app_bn.arb with native Bangla strings (not translated)
4. UX-4.04: Replace all hardcoded strings with l10n keys
5. UX-4.05: Implement lakh/crore number formatting in all amount displays
6. UX-4.06: Implement "show your work" copy in calculation trace
7. UX-4.07: Verify banned phrase list against all strings
8. UX-4.08: dart analyze clean + verify 0/0/0

---

## Sprint 6: D1 Trust Layer Foundation

**Rationale:** Auth, audit, export, deletion are MVP-blocking per doctrine.

### Tasks
1. D1.01: Create auth feature module (PIN setup + entry screens)
2. D1.02: Create PIN state management (Riverpod)
3. D1.03: Wire auth guard into router (PIN required on every app open)
4. D1.04: Create biometric support (optional, device-dependent)
5. D1.05: Create audit event entity + Hive model
6. D1.06: Wire audit logging to all financial edit paths
7. D1.07: Create audit log display screen
8. D1.08: Create CSV export service
9. D1.09: Create export screen with share action
10. D1.10: Create account deletion flow (full Hive purge)
11. D1.11: Convert anxiety buffer from absolute BDT to percentage (15% default, 5-30%)
12. D1.12: dart analyze clean + verify 0/0/0

---

## Sprint 7: D2 Beta Instrumentation

**Rationale:** Can't validate beta gates without measurement.

### Tasks
1. D2.01: Create analytics service abstraction
2. D2.02: Create event registry (transactional + boundary classes only)
3. D2.03: Wire S2S view events (daily frequency, session duration)
4. D2.04: Wire pipeline compliance events (state change timing)
5. D2.05: Wire notification events (sent, opened, dismissed)
6. D2.06: dart analyze clean + verify 0/0/0

---

## Sprint 8: D3 Closed Beta Readiness

**Rationale:** Final integration, QA, and gate verification.

### Tasks
1. D3.01: End-to-end flow test: fresh install -> onboarding -> S2S visible
2. D3.02: Performance test on Samsung A14 / 3G reference
3. D3.03: Accessibility audit (contrast, touch targets, screen reader)
4. D3.04: Microcopy audit against banned phrase list
5. D3.05: Real vs Hopeful Money Test on all screens
6. D3.06: Bangladeshi Freelancer Test on all screens
7. D3.07: Resolve any remaining doctrine conflicts
8. D3.08: Final dart analyze 0/0/0 + tag beta release
