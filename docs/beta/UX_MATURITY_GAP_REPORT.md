# UX Maturity Gap Report

> A1 Sprint Deliverable. Identifies UX gaps between doctrine spec and current implementation.
> Date: 2026-06-07

---

## 1. Design System Migration Status

| Component | Token System | Screen Usage | Gap |
|-----------|-------------|-------------|-----|
| helm_colors.dart | Created | Dashboard, Pipeline, PIN, Export, Delete Account | STS Settings, Audit Log use legacy AppColors |
| helm_typography.dart | Created | Dashboard, Pipeline, AppShell | STS Settings uses inline TextStyle. Audit Log uses Theme.of() |
| helm_spacing.dart | Created | Dashboard, Pipeline, Delete Account | STS Settings uses raw 16.0 padding |
| helm_motion.dart | Created | Onboarding PageView | Not applied to most transitions |

**Migration Score: ~65%** — New screens use doctrine tokens. Pre-UX-5 screens still use legacy shim.

---

## 2. Doctrine Widget Usage Audit

| Widget | Defined | Used In Screens | Gap |
|--------|---------|----------------|-----|
| HelmRealityStack | Yes | Dashboard | Only 1 screen uses it (as intended) |
| HelmAmount | Yes | S2sHeroBlock | NOT used in Pipeline cards, STS Settings amounts, Export |
| HelmLedgerRail | Yes | PipelineEntryCard, S2sHeroBlock | Not in Audit Log or Settings |
| HelmTrustStrip | Yes | S2sHeroBlock | Not in Pipeline, Settings, or any other screen |
| HelmToast | Yes | **UNUSED** — SnackBars used instead everywhere |
| HelmCalculationTrace | Yes | Dashboard (modal) | Correctly used |
| HelmFxEstimate | Yes | PipelineEntryCard | Correctly used |
| HelmMoneySourceLabel | Yes | PipelineEntryCard | Correctly used |
| HelmHeroZone (card) | Yes | S2sHeroBlock wraps it | Correctly used |
| HelmLedgerCard | Yes | CommittedSection, ReserveSection | Correctly used |
| HelmAuditCard | Yes | **UNUSED** — Audit Log uses basic ListTile |
| HelmSourceCard | Yes | NotCountedSection | Correctly used |
| HelmCautionCard | Yes | **UNUSED** — Reserve mode uses inline styling |

**Widget Adoption: 9/13 (69%)** — 4 widgets created but never integrated into screens.

---

## 3. UX Gaps by Screen

### Dashboard (Score: 5/5)
- Reality Stack layout: complete
- S2S hero with calculation trace: complete
- FAB "Add Pipeline Entry": complete
- Empty state: complete
- Reserve mode variant: complete
- No gaps found

### Onboarding (Score: 4/5)
- 5-step conversational flow: complete
- Pain qualifier: complete
- No first pipeline entry step (Step 6): **GAP**
- No PIN setup step (Step 7): by design, handled by router redirect
- No back button: correct per spec
- Progress line: complete

### PIN Setup / Entry (Score: 4/5)
- Custom numpad: complete
- 4-digit with confirmation: complete
- SHA-256 + salt: complete
- 5-attempt lockout: complete
- No biometric option: **GAP** (deferred)

### Pipeline (Score: 5/5)
- State-grouped sections: complete
- Needs Decision header for 30+ day overdue: complete
- Swipe-to-advance gesture: complete
- ConfirmReceivedSheet: complete
- 5s undo snackbar: complete
- Duplicate-last gesture: complete
- Empty state: complete
- No gaps found

### Settings / STS (Score: 3/5)
- Tax rate slider: complete
- Buffer % slider: complete
- Fixed costs CRUD: complete
- **Missing audit log link**: GAP (B1)
- **Legacy design tokens**: GAP (M1)
- **No HelmTypography**: GAP — uses inline TextStyle
- **No doctrine card widgets**: GAP — uses Material ListTile
- Export and Delete links: complete

### Audit Log (Score: 2/5)
- Chronological event list: complete
- Event type icons: complete
- **Unreachable from UI**: GAP (B1)
- **Raw Material colors**: GAP (M2)
- **HelmAuditCard not used**: GAP
- **No before/after value display**: GAP — only shows "Income added", not what changed
- **Not using HelmColors/Typography**: GAP

### Export (Score: 4/5)
- 5 CSV types: complete
- Share sheet: complete
- "Your data belongs to you" copy: excellent
- Loading state: complete
- Error handling: complete
- No gaps found

### Account Deletion (Score: 5/5)
- 2-step flow: complete
- PIN confirmation: complete
- Clear warning language: complete
- Full data purge: complete
- No gaps found

### History Tab (Score: 1/5)
- Placeholder text only: **CRITICAL GAP**
- No transaction list
- No filtering
- No date grouping

### Add Expense (Score: 3/5)
- Form validation: complete
- Category selection: complete
- Double-submit prevention: complete
- **No HelmAmount formatting in input**: GAP
- **Categories are placeholder strings**: GAP

---

## 4. Copy / Microcopy Status

| Area | Status | Notes |
|------|--------|-------|
| Banned phrases eliminated | PASS | UX-4 string audit completed |
| ARB files rewritten | PASS | app_en.arb doctrine-aligned |
| Bangla strings | NOT DONE | app_bn.arb needs native authoring |
| "Safe to spend" terminology | PASS | Used consistently |
| "Pipeline entry" terminology | PASS | Used instead of "transaction" for income |
| "Breathing room" for buffer | PASS | Used in onboarding and settings |
| Celebratory language | PASS | No confetti, no "Welcome!", no hype |

---

## 5. Trust Transparency Gaps

| Trust Element | Required By | Status |
|---------------|------------|--------|
| S2S always computed, never stored | Doctrine §10.2 | PASS |
| Calculation breakdown on tap | Doctrine §10.2 | PASS |
| "---" on calc failure | Doctrine §10.2 | **FAIL** — shows 0 |
| Audit log visible to user | Doctrine §10.4 | **FAIL** — unreachable |
| Before/after values in audit | Doctrine §10.4 | **PARTIAL** — event stored but not displayed |
| CSV export on demand | Doctrine §10.5 | PASS |
| Account deletion | Doctrine §10.5 | PASS |
| PIN on every app-open | Doctrine §10.1 | **NEEDS VERIFICATION** |

---

## 6. Recommended UX Maturity Priorities

1. **Fix audit log accessibility** — add to Settings tab (15 min)
2. **Verify and fix PIN cold-start** — ensure PIN required on every open (30 min)
3. **Add "---" fallback** — never show wrong number (30 min)
4. **Migrate Settings to doctrine tokens** — visual consistency (45 min)
5. **Replace HelmToast for SnackBars** — use the widget you built (2h)
6. **Use HelmAuditCard in Audit Log** — visual consistency (1h)
7. **Add before/after values to audit display** — trust transparency (1h)
8. **Decide on History tab** — implement or hide (30 min - 4h)
