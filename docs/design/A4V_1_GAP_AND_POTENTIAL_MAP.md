# A4V-1: Gap and Potential Map

> **Sprint:** A4V-1
> **Date:** 2026-06-08
> **Purpose:** Map the distance between current state and beta-ready, and identify hidden product power being visually suppressed

---

## The Strategic Picture

Helm has already solved the hardest problems:

1. **Token system is perfect** -- 13 colors, 18 typography styles, 8pt spacing grid, motion tokens. All correct.
2. **Core widgets are excellent** -- 13 Helm-prefixed widgets, all fully token-compliant.
3. **Dashboard cockpit is near-doctrine** -- HelmRealityStack, S2sHeroBlock, HelmCalculationTrace, HelmLedgerRail, HelmTrustStrip.
4. **Architecture is sound** -- Feature-first clean architecture, Riverpod state, GoRouter with proper guards.
5. **Trust layer exists** -- PIN auth, audit log, export, deletion, analytics instrumentation.

The problem is not design. The problem is that **the designed core has not propagated to the periphery**. The dashboard feels like a fintech product. The settings screen feels like a todo app. The income list feels like a generic CRUD interface. The transaction screen identifies itself as an expense tracker.

**The hidden product power is the S2S cascade.** It is already computed correctly. It is already displayed correctly on the dashboard. But every other screen that touches financial data (income list, add income, pipeline, settings) renders numbers without monospace fonts, without HelmAmount, without ledger rails, without trust strips. The product's intelligence is present but visually invisible outside the home screen.

---

## Top 10 Maturity Opportunities

### 1. AppButton Migration (Highest ROI Fix in Codebase)

**Gap:** AppButton uses #2453FF blue. Used in 13 files. Single file fix.
**Potential:** Rewriting `button_multiple_types.dart` to use `HelmColors.interactive` (#255E5B) will change the visual identity of every action button in the app from "Flutter template blue" to "calm financial deep teal." This one change affects: onboarding (6 pages), welcome, income screens, transaction screen, settings, and confirm-received sheet.

**Files affected:** `lib/core/widgets/buttons/button_multiple_types.dart`
**Estimated impact:** 13 screens instantly branded correctly.
**Risk:** Low. Single file, clear replacement pattern.

---

### 2. Phosphor Icon Migration (Identity Transformation)

**Gap:** 66 Material Icons, 0 Phosphor. No `phosphor_flutter` in pubspec.
**Potential:** Phosphor outline icons (1.5pt stroke) would give Helm a unique visual signature. Material Icons are recognizable as "default Flutter." Phosphor icons are less common, cleaner, and match the ledger-calm aesthetic. The 1.5pt stroke weight aligns with the hairline border philosophy.

**Files affected:** 16 files, 66 replacements.
**Estimated impact:** Entire app stops looking like a template.
**Risk:** Medium. Package addition required (needs approval). Systematic find-replace.

---

### 3. Typography Token Adoption (Visual System Completion)

**Gap:** 69 hardcoded fontSize + 30 ResponsiveUtilities.font() = ~99 text elements outside the token system.
**Potential:** When every text element uses HelmTypography, the app will have a visible type rhythm. Headers will be consistently headingMd/headingLg. Body text will be consistently bodyMd/bodyLg. Labels will be consistently labelSm/labelMd. Financial numbers will be consistently monoFinancial*. This rhythm is what separates a designed app from a coded app.

**Files affected:** 14 feature files.
**Estimated impact:** Typography system goes from 40% to 95% adoption.
**Risk:** Low. Mechanical replacement, clear mapping.

---

### 4. Income List Rebuild (Biggest User-Facing Win)

**Gap:** Income list is the worst frequently-seen screen (score: 30/100). 14+ hardcoded fonts, italic notes, generic filter chips, card radius 16 instead of 12, no HelmAmount for money values.
**Potential:** This screen shows the user's actual money pipeline entries. If rebuilt with HelmLedgerCard for entries, HelmAmount for values, HelmSourceCard for pipeline items, and proper token usage throughout, it would feel like a real financial ledger. The data is already there -- the rendering doesn't do it justice.

**Files affected:** `lib/features/income/presentation/views/income_list_screen.dart`
**Estimated impact:** Screen score from 30 to 70+.
**Risk:** Medium. Significant rewrite of a single screen.

---

### 5. Expense Category Removal (Identity Recovery)

**Gap:** 8 hardcoded expense categories (Food, Transport, Shopping, Bills, Entertainment, Health, Education, Other) in add_transaction_screen.dart.
**Potential:** Removing categories and replacing with simple "Cash out" recording (amount + note + date) would:
  - Remove the #1 signal that says "generic expense tracker"
  - Align with Final Product Doctrine ("Helm is not a backward-looking expense tracker")
  - Simplify the form (fewer fields = faster entry)
  - Focus user attention on what matters: "how much did I spend?" not "what category?"

**Files affected:** `lib/features/transactions/presentation/views/add_transaction_screen.dart`
**Estimated impact:** Identity-level. App stops being mistaken for TallyKhata.
**Risk:** Low. Removal is simpler than addition. Category data is not used in S2S calculation.

---

### 6. Splash Screen Redesign (First Impression Fix)

**Gap:** CircleAvatar "P" placeholder, 1800ms animation, hardcoded everything.
**Potential:** A clean splash with:
  - Canvas background (#FAFAF6)
  - "Helm" in Inter w600, inkPrimary color, centered
  - 300ms fade-in using HelmMotion.slow
  - Immediate navigation after fade completes
  This communicates: "confident, minimal, fast, designed."

**Files affected:** `lib/features/splash/views/splash_screen.dart`
**Estimated impact:** First impression goes from "student project" to "calm fintech."
**Risk:** Low. Small file, clear requirements.

---

### 7. STS Settings Token Migration (Trust Consistency)

**Gap:** Zero typography tokens. 9 hardcoded fontSize. FontStyle.italic. Zero spacing tokens.
**Potential:** This is where users adjust their safety buffer and fixed costs -- critical financial settings. Making this screen visually consistent with the dashboard (same typography, same spacing, same card styles) would reinforce trust. Currently, navigating from dashboard to settings feels like opening a different app.

**Files affected:** `lib/features/safe_to_spend/presentation/views/sts_settings_screen.dart`
**Estimated impact:** Screen score from 25 to 65+.
**Risk:** Low. Mechanical token replacement.

---

### 8. HelmAmount Adoption for All Money Values

**Gap:** HelmAmount widget exists and correctly renders monospace BDT-formatted numbers. But it's only used in the dashboard (S2sHeroBlock, CommittedSection, ReserveSection, NotCountedSection, CalcTrace). Income list, add income, pipeline summary, and STS settings all render money values with proportional fonts and inconsistent formatting.

**Potential:** If every money value in the app used HelmAmount, financial figures would be:
  - Always JetBrains Mono
  - Always BDT-formatted (lakh/crore grouping when applicable)
  - Always right-aligned
  - Always with consistent decimal places
  This is what makes banking apps feel "serious" vs "toy."

**Files affected:** income_list_screen, add_income_screen, pipeline_screen, sts_settings_screen, income_pipeline_summary.
**Estimated impact:** Every money figure in the app immediately looks professional.
**Risk:** Low. Widget exists, just needs adoption.

---

### 9. BoxShadow Removal (Zero-Shadow Compliance)

**Gap:** 4 BoxShadow instances in safe_to_spend_hero.dart (dead code), pipeline_entry_card.dart, income_pipeline_summary.dart, income_list_screen.dart.
**Potential:** Doctrine mandates zero shadows. Shadows make cards "float" above the surface, which creates visual noise on a calm ledger interface. Removing shadows and relying on hairline borders (1pt divider color) creates the "paper ledger" feel that matches the product metaphor.

**Files affected:** 4 files (1 is dead code to delete).
**Estimated impact:** Cards feel grounded, not floating.
**Risk:** Very low. Delete shadow declarations.

---

### 10. Bottom Nav 4th Tab (Doctrine Compliance)

**Gap:** 3 tabs (Home, Pipeline, Settings). Doctrine specifies 4 (Home, Pipeline, History, Settings).
**Potential:** History tab would provide a chronological view of all financial events (income received, expenses recorded, settings changed). This directly supports the audit/trust philosophy -- users can see a timeline of their financial reality.

**Files affected:** `lib/config/router/app_router.dart`
**Estimated impact:** Navigation matches doctrine. History provides trust through transparency.
**Risk:** Medium. Requires creating a new History screen.

---

## Hidden Product Power Being Visually Suppressed

### 1. The Calculation Trace Is the Product's Secret Weapon

**What it is:** When user taps S2S number, a breakdown drawer opens showing exactly how the number was computed: Income Received - Expenses - Tax Reserve - Fixed Costs - Buffer = Safe-to-Spend.

**Why it's suppressed:** It's hidden behind a tap with only a tiny hint ("Tap the number to see the math"). The visual treatment is correct (HelmAuditCard, stagger animation, HelmMotion). But discovery depends on the user tapping the right thing.

**How to surface it:** The Trust Strip ("Updated 11:42 PM . Received only") already links to the trace via `onTapAudit`. Consider making the entire S2S hero zone tappable (it is via S2sHeroBlock's HelmHeroZone). The one-time hint helps, but a persistent "See math" link in the Trust Strip would improve discovery.

### 2. The Ledger Rail Communicates State Without Alarm

**What it is:** A 3pt colored line (sage/amber/brick) below the S2S number that tells the user their financial state without using text or alarming colors.

**Why it's suppressed:** It works perfectly on the dashboard. But no other screen uses it. The income list could show a mini ledger rail next to pipeline entries. The pipeline screen could show an overall pipeline health rail. The calculation trace could show rails next to each row.

**How to surface it:** `HelmLedgerRail` widget is ready. Just needs adoption in more contexts.

### 3. The Reality Stack Architecture Is Unique

**What it is:** A 4-tier vertical layout: Hero (S2S) -> Pressure (fixed costs + reserve) -> Maintenance (future) -> Hope (pipeline). This is not a generic dashboard layout -- it's a custom financial narrative.

**Why it's suppressed:** Only the dashboard uses it. But the concept could extend: the calculation trace IS a mini reality stack (received - spent - reserved - buffered = safe). The onboarding completion screen could show a preview reality stack with the user's first S2S number.

### 4. The Trust Strip Pattern Is Trust Infrastructure

**What it is:** "Updated 11:42 PM . Received only" -- a timestamp + data source label that tells the user exactly when and how their number was computed.

**Why it's suppressed:** Only on dashboard hero. Could appear on:
  - Pipeline screen (when data was last updated)
  - Calculation trace header
  - Export preview (data freshness timestamp)

### 5. The BDT-First Money Stamp Is a Differentiator

**What it is:** HelmAmount renders money as `tk 36,000.00` -- taka prefix, lakh formatting, monospace JetBrains Mono.

**Why it's suppressed:** Only used in dashboard. Income list renders amounts with proportional fonts and `$ ${formatter.format(amount)}`. Pipeline summary uses ResponsiveUtilities.font() for amounts. The BDT-first rendering is the product's visual signature for Bangladeshi users, but it's invisible outside the home screen.

---

## Gap Severity Matrix

| Gap Area | Current | Required | Delta | Priority |
|----------|---------|----------|-------|----------|
| Button brand color | #2453FF | #255E5B | BLOCKER | P0 |
| Icon system | Material | Phosphor | BLOCKER | P0 |
| Splash identity | Placeholder | Designed | BLOCKER | P0 |
| Expense categories | Present | Removed | BLOCKER | P0 |
| Italic text | 3 instances | 0 | BLOCKER | P0 |
| Typography adoption | 40% | 95% | MAJOR | P1 |
| Spacing adoption | 50% | 90% | MAJOR | P1 |
| HelmAmount adoption | Dashboard only | All money values | MAJOR | P1 |
| BoxShadow | 4 instances | 0 | MAJOR | P1 |
| Colors.black/white | 20 instances | 0 | MAJOR | P1 |
| FontWeight.bold | 26 instances | 0 | MAJOR | P1 |
| Bottom nav tabs | 3 | 4 | MAJOR | P2 |
| Dead code cleanup | 1 file | 0 | MINOR | P2 |

---

## Migration Sequence (Recommended)

### Phase 1: Kill Blockers (Q1-Q7 from Toy-Feel report)
1. Rewrite AppButton -> HelmColors.interactive
2. Remove expense categories
3. Remove 3 italic instances
4. Replace CircleAvatar splash with wordmark
5. Reduce splash animation to 300ms
6. Delete safe_to_spend_hero.dart
7. Replace Colors.black/white with tokens

**Estimated effort:** 2-3 hours
**Outcome:** Zero BLOCKER findings. Score jumps from 52 to ~62.

### Phase 2: Typography + Weight Migration (D2-D3)
1. Replace 30+ ResponsiveUtilities.font() with HelmTypography tokens
2. Replace 69 hardcoded fontSize with tokens
3. Replace 26 FontWeight.bold with w600

**Estimated effort:** 3-4 hours
**Outcome:** Typography fully adopted. Score to ~70.

### Phase 3: Spacing + Shadow Migration (D4)
1. Replace 80+ hardcoded BorderRadius with HelmSpacing tokens
2. Remove 4 BoxShadow instances
3. Standardize EdgeInsets to HelmSpacing

**Estimated effort:** 2-3 hours
**Outcome:** Spacing fully adopted. Score to ~75.

### Phase 4: Icon System Migration (D1)
1. Add phosphor_flutter package (requires approval)
2. Replace 66 Material Icons with Phosphor equivalents
3. Establish icon mapping document

**Estimated effort:** 3-4 hours
**Outcome:** Entire app identity shifts. Score to ~82.

### Phase 5: Screen-Level Polish (D5-D6)
1. Splash redesign
2. Income list rebuild with HelmLedgerCard + HelmAmount
3. Add 4th bottom nav tab (History)
4. STS Settings full token migration

**Estimated effort:** 4-6 hours
**Outcome:** All screens above 60. Score to ~85+.

---

## Beta-Ready Target

| Metric | Current | Target | Gap |
|--------|---------|--------|-----|
| BLOCKERs | 7 | 0 | -7 |
| Material Icons | 66 | 0 | -66 |
| Hardcoded fontSize | 69 | < 10 | -59 |
| Typography adoption | 40% | 95% | +55% |
| Spacing adoption | 50% | 90% | +40% |
| Overall score | 52 | 75+ | +23 |
| Worst screen score | 20 | 50+ | +30 |

---

## Recommended A4V-2 Direction

```
A4V-2 -- Visual Maturity Migration Sprint

Scope: Execute Phase 1 (Kill Blockers) + Phase 2 (Typography Migration)

This is the highest-ROI combination:
- Phase 1 kills all 7 BLOCKERs in ~3 hours
- Phase 2 completes typography system adoption in ~4 hours
- Combined: score jumps from 52 to ~70, all BLOCKERs resolved

After A4V-2, the app will have:
- Correct brand color on all buttons (deep teal)
- No italic text
- No expense categories
- Clean splash (no placeholder)
- Typography fully token-compliant
- No FontWeight.bold violations
- No Colors.black/white violations

Remaining for A4V-3:
- Phosphor icons (package approval needed)
- Spacing/radius migration
- Income list rebuild
- History tab
```

---

*End of Gap and Potential Map. No code was modified.*
