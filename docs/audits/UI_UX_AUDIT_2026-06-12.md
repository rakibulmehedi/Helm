# 🔍 Pocketa V2 — UI/UX Design Audit
**Auditor:** Senior Product Designer (DAN Persona)
**Date:** June 12, 2026
**Product:** Freelancer Cashflow Clarity App (FinTech, Mobile-First, Flutter)
**Score:** **78/100** — Good foundation with targeted gaps

---

## 1. COLOR & CONTRAST — Score: 72/100

### What's Working
- **inkPrimary on canvas (Light): 17.6:1 ✅ AAA** — Excellent readability for body text
- **inkSecondary on canvas (Light): 10.9:1 ✅ AAA** — Secondary text is crisp
- **inkPrimary on canvas (Dark): 17.1:1 ✅ AAA** — Dark mode text is perfect
- **interactive on canvas (Light): 7.1:1 ✅ AAA** — Teal accent passes with flying colors
- **Warm white canvas (#FAFAF6)** + slightly warmer cards creates subtle depth without shadows

### What Needs Fixing

| Token | Pair | Ratio | Issue |
|-------|------|-------|-------|
| `stateSafe` | #5B8C5A on #FAFAF6 | **3.8:1** | Below 4.5:1 AA minimum |
| `stateTight` | #B8860B on #FAFAF6 | **3.1:1** | Below even 3:1 AA Large |
| `interactive` (Dark) | #3E807D on #0E0E0C | **4.2:1** | Below 4.5:1 AA |

**Mitigation:** LedgerRail always shows text labels alongside color, so these aren't *blockers*. But for any standalone colored text (e.g., status badges in Pipeline), these become real accessibility failures.

**Recommendation:** Darken `stateSafe` to `#3D6B3C` (4.7:1), darken `stateTight` to `#8B6500` (4.6:1), brighten dark `interactive` to `#4DA09C` (5.0:1).

---

## 2. TYPOGRAPHY & READABILITY — Score: 85/100

### Strengths
- **Strict weight discipline:** 400-600 only, no italic anywhere — consistent, professional
- **JetBrains Mono for financial numbers:** Monospace on money is the correct call
- **TextScaler.noScaling on financial figures:** Prevents layout breakage at large accessibility font sizes — critical for fintech
- **Line height:** All financial numbers are tight and numeric — body text should use 1.5 (standard Flutter defaults used, acceptable)
- **Hind Siliguri for Bangla:** Regional font choice shows product empathy for target audience

### Weakness
- **Font family diversity:** 3 font families (Inter, JetBrains Mono, Hind Siliguri) loaded at app start. Each adds ~150KB+ to the binary. Consider lazy-loading Hind Siliguri only when Bangla locale is active.

---

## 3. ACCESSIBILITY — Score: 70/100

### Done Right
- ✅ **4 `Semantics` widgets** on critical financial displays (amount, ledger rail, trust strip, ledger card)
- ✅ **Never color-only signaling** — LedgerRail has text + shape + color
- ✅ **44pt minimum touch targets** on PocketaTrustStrip
- ✅ **`prefers-reduced-motion` respected** via `MediaQuery.disableAnimations`
- ✅ **`TextScaler.noScaling`** on all `PocketaAmount` widgets

### Missing / Needs Work

| Issue | Severity | Details |
|-------|----------|---------|
| **No Semantics on buttons** | CRITICAL | FAB, nav items, form submit buttons, skip buttons — all invisible to screen readers |
| **No Semantics on form fields** | HIGH | All TextFormFields in onboarding, add-income, settings lack semantic labels |
| **No Semantics on toggle switches** | HIGH | "Exclude from Safe-to-Spend" switch has no screen reader label |
| **No Semantics on slider** | MEDIUM | Tax rate and buffer sliders in settings |
| **Interactive in dark mode below AA** | MEDIUM | 4.2:1 — if used as interactive text (e.g., "Add fixed costs →"), fails for screen-reader-dependent color use |
| **No focus management** | LOW | Mobile-first, so less critical — but Switch Control users exist |

**Recommendation:** Add `Semantics` wrappers to all buttons, FABs, and form fields. This is the single biggest accessibility gap.

---

## 4. TOUCH & INTERACTION — Score: 65/100

### Done Right
- ✅ **Proper keyboard types:** `numberWithOptions(decimal: true)` for amounts, `TextInputType.number` for day-of-month
- ✅ **44pt touch targets** on trust strip
- ✅ **Form-level validation** with `GlobalKey<FormState>` pattern
- ✅ **Double-submit guard:** `_isSaving` flag prevents duplicate submissions
- ✅ **Swipe gestures:** Pipeline entry cards use `Dismissible` with `confirmDismiss` gate (60% threshold, green hint)
- ✅ **Undo pattern:** 4-5s undo toasts for destructive actions (delete income, delete fixed cost, confirm received)

### Missing / Needs Work

| Issue | Severity | Details |
|-------|----------|---------|
| **ZERO haptic feedback** | CRITICAL | No `HapticFeedback` anywhere. For a fintech app: PIN taps, confirm received, delete, error states — all should have haptic. This is a **mobile-native expectation**, not web. |
| **No active/pressed states** | HIGH | `InkWell` handles ripple, but button elements lack explicit `onPressed` visual transformation (scale-95 equivalent) |
| **Slider UX is… slider-y** | MEDIUM | 50 divisions on tax rate slider and 25 on buffer slider create a jumpy, imprecise feel. Consider stepper buttons (±1%) + slider for macro, or `SliderInteractionType.tapAndSlide` |
| **Onboarding is unskippable** | MEDIUM | UX best-practice says provide Skip button. The qualifier is skippable via "Not really" → disqualify, but there's no "I'll do this later" for the 6-step flow |

**Recommendation:** Add `HapticFeedback.lightImpact()` on PIN key taps, `HapticFeedback.mediumImpact()` on confirm/delete actions, `HapticFeedback.heavyImpact()` on errors. This is table-stakes for fintech mobile apps.

---

## 5. EMPTY & LOADING STATES — Score: 80/100

### Done Right
- ✅ **Empty pipeline:** "Add an expected payment when you invoice…" + CTA
- ✅ **Empty income list:** Wallet icon + "Add Income" CTA button
- ✅ **Empty fixed costs:** Card with "No fixed costs added yet" + CTA
- ✅ **No-data S2S:** Em-dash "—" instead of misleading ৳0
- ✅ **Filter-empty states:** Contextual icon + message per filter chip
- ✅ **Error state:** "Income entry not found" + "Go Back" button
- ✅ **No celebration screen after onboarding** (ONB-012 — doesn't distract from core value)

### Missing
- **No skeleton screens:** `CircularProgressIndicator` is used directly in buttons, but there's no shimmer/skeleton pattern for sections loading. Given the app is offline-first with Hive reads being near-instant, this is low-priority — but if backend sync (V2) arrives, this becomes critical.

---

## 6. ANIMATION & MOTION — Score: 88/100

### Done Right
- ✅ **Strict motion tokens:** 120-320ms, ease-out only, no springs/bounces/elastic
- ✅ **`PocketaMotion` system:** Centralized timing + curve constants
- ✅ **Staggered calculation trace:** 24ms stagger with `Interval` curves
- ✅ **Reduced motion compliance:** `MediaQuery.disableAnimations` skips to final state
- ✅ **FadeTransition on hero:** 200ms entrance, not scale/bounce

### Minor Observation
- The splash screen `FadeTransition` at 320ms + 500ms delay timer before navigation could feel sluggish on fast devices. Consider reducing delay to 200ms or skipping entirely if Hive init is already complete.

---

## 7. LAYOUT & SPACING — Score: 82/100

### Done Right
- ✅ **8pt grid:** `PocketaSpacing` with s0-s12 tokens
- ✅ **Consistent card radii:** 12pt cards, 10pt buttons, 16pt sheets
- ✅ **Screen edge padding:** 16pt horizontal
- ✅ **Bottom nav + FAB clearance:** 100pt bottom padding on scroll view
- ✅ **4-tier Reality Stack:** Hero → Pressure → (Maintenance) → Hope — clear information hierarchy
- ✅ **Zero-elevation cards:** Hairline borders instead of shadows — flat, clinical, warm

### Minor Issues
- **Settings screen vertical density:** Tax slider → buffer slider → fixed costs list → buttons → data tiles → danger zone — this is a long scroll. Consider collapsing "Data export" and "Change history" into a grouped section.
- **Pipeline section collapsing:** Received section collapses with animated chevron. Good pattern, but the chevron alone is too subtle — consider a tappable section header with count text.

---

## 8. NAVIGATION & IA — Score: 78/100

### Done Right
- ✅ **3-tab shell:** Home, Pipeline, Settings — minimal, focused
- ✅ **Bottom nav:** Selected = interactive color, Unselected = inkTertiary, labelSm, fixed type
- ✅ **FAB placement:** Add pipeline entry — primary action, prominent
- ✅ **ShellRoute + modal overlay:** Non-tab screens (add, edit, PIN, settings detail) float above shell
- ✅ **Global redirect guard:** Enforces onboarding → PIN auth flow correctly

### Issue
- **Settings is a tab, not a modal.** The tax rate slider, buffer slider, and fixed costs list are settings — having "Settings" as a bottom tab isn't wrong, but the screen contains both quick-adjust controls AND navigation links. This creates a hybrid page that feels like a navigation drawer trapped in a tab. Consider moving "Data export," "Change history," and "Delete all data" to a separate "More" or "Data" page accessible from settings.

---

## 9. DARK MODE — Score: 75/100

### Done Right
- ✅ **System-following:** `ThemeMode.system`
- ✅ **Hand-tuned tokens:** Not auto-generated from `ColorScheme.fromSeed`
- ✅ **inkPrimary Dark:** 17.1:1 AAA — outstanding
- ✅ **Canvas Dark:** `#0E0E0C` — near-OLED black, power-efficient
- ✅ **Surface Dark:** `#161614` — slightly lighter than canvas for card differentiation
- ✅ **All state colors brightness-shifted**

### Issue
- **interactive on dark canvas: 4.2:1** — The teal accent is the app's primary tappable affordance. On dark mode, it barely passes AA for large text only. All interactive text (CTAs, links, "Add →" prompts) in dark mode is harder to read than it should be.

---

## 10. OVERALL SCORING MATRIX

| Criteria | Score | Notes |
|----------|-------|-------|
| Color palette | 7/10 | Warm, professional, but 2 state colors fail contrast |
| Typography | 9/10 | Excellent discipline, correct monospace for money |
| Spacing/Layout | 8/10 | 8pt grid, consistent, clear hierarchy |
| Accessibility | 7/10 | Semantics on 4 widgets only — needs broader coverage |
| Motion | 9/10 | Strict, centralized, reduced-motion compliant |
| Touch/Interaction | 6/10 | Missing haptics and active states |
| Empty/Loading states | 8/10 | Empty states excellent, skeletons absent |
| Dark mode | 8/10 | Hand-tuned, one contrast gap |
| Navigation | 8/10 | Clean shell, settings hybrid concern |

**Weighted Total: 78/100**

---

## TOP 5 ACTIONS

| # | Action | Impact | Effort |
|---|--------|--------|--------|
| 1 | **Add haptic feedback** — `lightImpact` on PIN taps, `mediumImpact` on confirm/delete, `heavyImpact` on errors | CRITICAL | Low |
| 2 | **Fix 3 contrast ratios** — darken stateSafe, stateTight; brighten dark interactive | CRITICAL | Low |
| 3 | **Add Semantics to ALL interactive elements** — buttons, FABs, nav items, form fields, switches, sliders | HIGH | Medium |
| 4 | **Add active/pressed states** — visual feedback on button press beyond InkWell ripple | MEDIUM | Low |
| 5 | **Improve slider UX** — ±1% stepper buttons alongside sliders, or reduce division count | MEDIUM | Low |
