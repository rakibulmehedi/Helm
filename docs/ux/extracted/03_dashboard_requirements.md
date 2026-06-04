# Dashboard Implementation Requirements

> **Extraction date:** 2026-06-04
> **Extracted by:** Senior Implementation Agent
> **Purpose:** Canonical dashboard requirements for Pocketa home screen implementation.

---

## Source Documents and Authority

| Doc ID | Document | Authority Level | Role |
|--------|----------|-----------------|------|
| **DR** | `docs/research/ux/Pocketa_Dashboard_Redesign.md` | Baseline | Original doctrine-aligned dashboard design. Provides foundational architecture, wireframes, and spec detail. |
| **CR** | `docs/research/ux/Pocketa_Dashboard_Tier1_Critique_Improved_v2.md` | **Override** | Tier-1 fintech design critique. Overrides DR on every point of conflict. Provides improved wireframes, state handling, component rules, and shippability criteria. |

**Authority rule:** Where DR and CR conflict, CR wins. Overridden requirements are marked with `[OVERRIDDEN BY v2]`.

---

## Section 1: Dashboard Cockpit Model

### DASH-001 — Dashboard is a cockpit, not a dashboard
- **Requirement:** The home screen is a decision surface ("what's possible?"), not a reporting surface ("what happened?"). It answers one question: "How much BDT is actually safe to spend right now?"
- **Rationale:** Pocketa's wedge is forward-looking pipeline-aware Safe-to-Spend. Backward-looking patterns belong to generic expense trackers.
- **Source:** DR S1, CR S0
- **Implementation:** No backward-looking aggregates (income/expense totals, recent transactions, spending categories) may appear on the home screen.

### DASH-002 — 2-second answer contract
- **Requirement:** The S2S number must be visible within 2 seconds of cold app open on a Samsung A14 over 3G.
- **Rationale:** A freelancer at a checkout counter has approximately 1.5 seconds of cognitive bandwidth. If the answer is not visible in time, the product premise is broken.
- **Source:** DR S1, S14
- **Implementation:** Performance budget: cold-start to first frame P95 < 800ms, S2S calc P95 < 50ms. CI gate must fail if `time_to_s2s_visible` > 2000ms.

### DASH-003 — Hierarchy model: Answer, Confidence, Pressure, Maintenance, Hope [OVERRIDDEN BY v2]
- **Requirement:** The dashboard follows the v2 hierarchy: (1) Answer (S2S), (2) Confidence (freshness + input status), (3) Pressure (next obligations with coverage), (4) Maintenance (conditional action strip), (5) Hope (money not counted yet).
- **Rationale:** The original DR hierarchy (Present, Threat, Hope) is emotionally correct but operationally insufficient. It lacks trust signaling (confidence) and actionable maintenance prompts.
- **Source:** CR S8. **Overrides** DR S3 "Three-Tier Cognitive Stack."
- **Implementation:** The section order must follow S17 of CR exactly. Maintenance strip appears conditionally between obligations and hope sections.

### DASH-004 — What the home screen is NOT
- **Requirement:** The home screen must never function as any of the following: a summary of income vs expenses, a recent transactions feed, a "financial health" overview, a net-worth screen combining USD+BDT, a reminders/notifications inbox, a spending categorization surface.
- **Rationale:** Each of these patterns belongs to a different product category (TallyKhata, generic expense apps) or is permanently killed by the Final Product Doctrine.
- **Source:** DR S1, CR S0
- **Implementation:** No widgets for these patterns may exist in the home screen widget tree.

---

## Section 2: Safe-to-Spend Hero Display Rules

### DASH-010 — S2S is the single hero number
- **Requirement:** The S2S number is the largest typographic element on the entire screen. No other element may have equivalent or greater visual weight.
- **Rationale:** This IS the entire product. Everything else is supporting evidence.
- **Source:** DR S5, CR S16.1
- **Implementation:** Hero number rendered in monospaced numeric font, approximately 64pt on a 6.1" device. No card, shadow, or gradient surrounds it -- it sits directly on canvas.

### DASH-011 — Hero label placement [OVERRIDDEN BY v2]
- **Requirement:** The label `SAFE-TO-SPEND` appears ABOVE the number in small uppercase (11-12pt), so the user reads what the number means before reading the number itself.
- **Rationale:** Reading the label first primes correct interpretation.
- **Source:** CR S9, S16.1. **Overrides** DR S5 where label "Safe to spend" appears below the number in sentence case.
- **Implementation:** Widget order: label (small caps) -> number -> meaning line -> accent line + state label.

### DASH-012 — Meaning line [OVERRIDDEN BY v2]
- **Requirement:** Below the hero number, a meaning line reads: `after fixed costs + 15% buffer` (or the actual buffer percentage).
- **Rationale:** Explains what was deducted. The user understands the composition without opening the drawer.
- **Source:** CR S9. **Overrides** DR S5 runway sub-line `covers N days at your usual pace` as the primary meaning line.
- **Implementation:** The runway ("covers N days") may still appear contextually (e.g., in Tight/At Risk states) but the primary meaning line is the deduction explanation.

### DASH-013 — Number color is always primary ink
- **Requirement:** The hero number is rendered in primary ink (near-black on light, off-white on dark). It is NEVER tinted by state.
- **Rationale:** Color tinting the number itself creates visual noise and competes with the accent line, which is the canonical state signal.
- **Source:** DR S5, CR S16.1
- **Implementation:** No conditional color on the hero number text. State conveyed solely through accent line.

### DASH-014 — Currency symbol weight
- **Requirement:** The taka symbol (BDT sign) renders at half the weight of the number. It labels; it does not compete.
- **Rationale:** Reduces visual clutter while maintaining currency identification.
- **Source:** DR S5
- **Implementation:** Currency symbol uses a lighter font weight or smaller size relative to the main digits.

### DASH-015 — Decimal de-emphasis [OVERRIDDEN BY v2]
- **Requirement:** Decimals are always shown (e.g., `.00`) for precision trust, but typographically de-emphasized at 45-55% opacity or reduced size.
- **Rationale:** Full precision is a trust signal, but `.00` can imply false exactness when FX is manual. De-emphasis balances trust with visual clarity.
- **Source:** CR S3.2. **Overrides** DR S5 which shows decimals at full weight.
- **Implementation:** The integer portion renders at full weight; the decimal portion renders at reduced opacity or smaller font size.

### DASH-016 — Bangladeshi number formatting
- **Requirement:** All BDT amounts use the Bangladeshi lakh/crore convention: `1,32,400.00` not `132,400.00`.
- **Rationale:** Non-negotiable cultural correctness for Bangladeshi users.
- **Source:** DR S5, S12
- **Implementation:** Custom `bnFormatter` helper with lakh/crore grouping. Unit-test covering 0, 100, 1,000, 99,999, 1,00,000 (1 lakh), 1,00,00,000 (1 crore), negative values.

### DASH-017 — Number font
- **Requirement:** Monospaced numeric font (JetBrains Mono Variable or IBM Plex Mono) with `FontFeature.tabularFigures()` for decimal alignment.
- **Rationale:** Monospace ensures number alignment and readability. Tabular figures prevent layout shift on value changes.
- **Source:** DR S5, S14
- **Implementation:** Use `google_fonts` package with the selected monospace face.

### DASH-018 — Hero animation rules
- **Requirement:** 200ms fade-in on initial load. No pulse, shimmer, counter animation, rolling numbers, or slot-machine effect. "Sacred things do not wiggle."
- **Rationale:** Financial numbers require calm presentation. Animations create entertainment, not trust.
- **Source:** DR S5
- **Implementation:** Single `FadeTransition` with 200ms duration on `S2SResult.ok`. Respect `MediaQuery.disableAnimations` (collapse to instant).

### DASH-019 — Hero tap opens Calculation Breakdown drawer
- **Requirement:** Tapping the hero number or the meaning line opens a Calculation Breakdown drawer (240ms slide-up, dismissible by swipe-down or tap-outside).
- **Rationale:** The "show your work" pattern is the single most important interaction on the home screen.
- **Source:** DR S9, CR S14
- **Implementation:** `DraggableScrollableSheet` with 240ms transition. Respects reduce-motion preference.

### DASH-020 — Hero long-press is optional refresh shortcut only [OVERRIDDEN BY v2]
- **Requirement:** Long-press on the hero triggers a forced refresh/recalculate, but it must NOT be a primary path for any financial maintenance action.
- **Rationale:** Long-press is invisible. Core financial truth updates must always have visible affordances.
- **Source:** CR S6.3, S16.1. **Overrides** DR S9 which positioned long-press as a direct action path.
- **Implementation:** Long-press triggers recalculation but all primary actions (mark paid, confirm received) must have visible tap targets.

### DASH-021 — No gesture overrides the S2S number
- **Requirement:** The user cannot drag, edit, or "set" the S2S result. They edit inputs; the system computes the result.
- **Rationale:** Trust Layer 3 -- the number is computed, never stored or manually set.
- **Source:** DR S9
- **Implementation:** No edit affordance on the S2S display. No swipe, pinch, or double-tap on the hero.

---

## Section 3: State Accent Line and Color Coding

### DASH-030 — Three-state accent line
- **Requirement:** A single 2pt-tall, 64pt-wide accent line below the meaning line. Color indicates state: Safe, Tight, At Risk.
- **Rationale:** The accent line is the only state signal. It is subtle enough not to compete with the number.
- **Source:** DR S5, CR S16.1
- **Implementation:** Three predefined colors for the accent line only.

### DASH-031 — State accent colors
- **Requirement:**
  - **Safe:** Desaturated sage green `#6B8F71` -- liquid BDT comfortably covers all obligations + buffer.
  - **Tight:** Muted amber `#B88A4A` -- liquid BDT covers obligations but eats into buffer.
  - **At Risk:** Muted brick red `#9E4A3A` -- liquid BDT insufficient for an obligation due within 7 days.
- **Rationale:** Muted, desaturated tones avoid alarm fatigue while still conveying urgency gradation.
- **Source:** DR S5
- **Implementation:** Define these as named colors in `AppColors`. They apply to the accent line and state text labels only.

### DASH-032 — State label as text [OVERRIDDEN BY v2]
- **Requirement:** The state (Safe / Tight / At Risk) is shown as a text label beside or below the accent line, not just implied by color.
- **Rationale:** Explicit text labels are more accessible and clearer than color-only signals.
- **Source:** CR S9, S10, S11. **Overrides** DR S5 where state was conveyed primarily by accent line color.
- **Implementation:** Text label rendered in the corresponding accent color alongside the line.

### DASH-033 — No "Reserve Mode" label [OVERRIDDEN BY v2]
- **Requirement:** The dashboard must NEVER display "Reserve Mode" as a user-facing label. Use the canonical state vocabulary: Safe, Tight, At Risk.
- **Rationale:** "Reserve Mode" sounds like a scary financial lockdown. System-centric terms increase anxiety.
- **Source:** CR S4.2. **Overrides** DR S11 "Reserve Mode" UI state.
- **Implementation:** Remove any "Reserve mode is on" or mode-label copy. Use state name + explanation sentence instead.

### DASH-034 — S2S is always the hero metric, even at zero [OVERRIDDEN BY v2]
- **Requirement:** The hero metric is ALWAYS "Safe-to-Spend." When S2S computes to zero, show `0.00`. Never replace the hero with "Liquid BDT remaining."
- **Rationale:** Replacing S2S with a different metric breaks the product's core contract. Liquid BDT belongs in the breakdown drawer.
- **Source:** CR S3.1, S11. **Overrides** DR S11 Reserve Mode hero which showed "Liquid BDT remaining."
- **Implementation:** The hero label is always `SAFE-TO-SPEND`. The At Risk state shows `0.00` with an explanation line (e.g., "rent short by X in N days").

### DASH-035 — Tight state copy
- **Requirement:** Tight state meaning line says `buffer is being used` -- NOT "Warning: low balance."
- **Rationale:** Specific, calm, mathematically grounded language reduces anxiety.
- **Source:** CR S10
- **Implementation:** Conditional copy in Tight state hero section.

### DASH-036 — At Risk state copy
- **Requirement:** At Risk meaning line specifies the exact shortfall: `[obligation] short by [amount] in [N] days`.
- **Rationale:** The user should know exactly what is at risk without mental calculation.
- **Source:** CR S11
- **Implementation:** Dynamically generated copy from obligation data identifying the first uncovered obligation.

### DASH-037 — Color rules for money states on home
- **Requirement:**
  - `covered` -- neutral secondary ink (no color)
  - `uses buffer` -- muted amber text
  - `short [amount]` -- muted brick red text
  - Pending/expected USD -- cool desaturated blue `#5A7A8C` at 40% opacity
  - Hero number -- always primary ink, never tinted
- **Rationale:** Color is used sparingly and only to convey countedness and risk. No vibrant reds/greens.
- **Source:** DR S5, S7, CR S16.2
- **Implementation:** Named color tokens in `AppColors`. No raw hex in widget code.

---

## Section 4: Pipeline Summary Display (Hope Tier / "Not Counted Yet")

### DASH-040 — Label: "Not counted yet" [OVERRIDDEN BY v2]
- **Requirement:** The Hope tier on the home screen is labeled `Not counted yet`, NOT "Pending pipeline."
- **Rationale:** "Pipeline" is an internal product term. "Not counted yet" directly communicates the safety boundary: this money is NOT in your S2S. This is the highest-leverage copy change in the entire redesign.
- **Source:** CR S2.2, S5.3, S16.3. **Overrides** DR S6 "Pending pipeline."
- **Implementation:** Section header is always "Not counted yet." The word "pipeline" is reserved for the Pipeline tab.

### DASH-041 — Pipeline summary format [OVERRIDDEN BY v2]
- **Requirement:** Format: `$[amount] . [N] payments . expected ~[date]` with a chevron (navigation affordance).
- **Rationale:** Single-line summary in USD. No breakdown into Expected/Pending/Received buckets on home. Breakdown lives in the Pipeline tab.
- **Source:** CR S9. **Overrides** DR S6 format of `$1,800 across 2 invoices / expected by ~Nov 18` on separate lines.
- **Implementation:** One-line summary with dot separators. Tap navigates to Pipeline tab.

### DASH-042 — No BDT equivalent on home
- **Requirement:** Pending USD is shown in USD only on the home screen. No BDT conversion is displayed at home.
- **Rationale:** Showing BDT-equivalent of pending USD at home tempts the user to mentally add it to S2S, causing overspend.
- **Source:** DR S6, CR S16.3
- **Implementation:** Conservative BDT amount shown only on Pipeline tab, never on dashboard.

### DASH-043 — Pipeline never adds to hero number
- **Requirement:** Pending USD is never included in the S2S hero number. The two are visually and computationally severed.
- **Rationale:** Pending USD is not yet real money. Including it causes the exact overspend behavior Pocketa exists to prevent.
- **Source:** DR S6
- **Implementation:** S2S calculator excludes all non-received pipeline entries.

### DASH-044 — Pipeline visual weight is recessive
- **Requirement:** The pipeline summary uses secondary ink, smaller font sizes (12-13pt), and cool desaturated blue accent. It must be visually subordinate to both the hero and the obligations.
- **Rationale:** Future, uncertain money must not feel emotionally salient or spendable.
- **Source:** DR S6, CR S5.3
- **Implementation:** No emphasis treatment. No exclamation marks, urgent language, or celebration copy.

### DASH-045 — Pipeline copy restrictions
- **Requirement:** The Hope tier never uses urgent or exciting language. No "incoming!", "Almost there!", or celebration framing. Hope is recessive, not exciting.
- **Rationale:** Excitement implies imminence and certainty. Pending USD has neither.
- **Source:** DR S6
- **Implementation:** Copy review gate: no exclamation marks, no urgency words in pipeline copy.

---

## Section 5: Obligation / Threat Tier Display (Pressure Section)

### DASH-050 — Section label [OVERRIDDEN BY v2]
- **Requirement:** The obligations section is labeled `Next obligations`, NOT "The Path" or any dramatic label.
- **Rationale:** "The Path" sounds like a crisis journey. Boring copy is a feature in fintech.
- **Source:** CR S4.3. **Overrides** DR S7 unlabeled threat tier and DR S11 "The Path."
- **Implementation:** Section header: "Next obligations."

### DASH-051 — Obligation row content [OVERRIDDEN BY v2]
- **Requirement:** Each row shows: obligation name, amount, days-to-due (compact: "in Nd"), and coverage status text.
- **Rationale:** Coverage status (covered / uses buffer / short X) closes the cognitive loop so the user does not have to mentally reconcile obligations against S2S.
- **Source:** CR S4.1, S16.2. **Overrides** DR S7 which used proximity dots without coverage status.
- **Implementation:** Row format: `[Name]  [Amount]  in [N]d  [coverage status]`.

### DASH-052 — Proximity dots replaced by coverage text [OVERRIDDEN BY v2]
- **Requirement:** The proximity dots (filled/half/outline) from DR are replaced with explicit coverage status text: `covered`, `uses buffer`, `short [amount]`.
- **Rationale:** Dots require mental math. Text closes the loop directly.
- **Source:** CR S4.1, S18. **Overrides** DR S7 proximity dot system.
- **Implementation:** Coverage status is computed from S2S breakdown data and rendered as text in the corresponding color.

### DASH-053 — Maximum 2-3 obligation rows [OVERRIDDEN BY v2]
- **Requirement:** Show 2-3 rows maximum on home. If more exist, show the most risk-relevant rows only (not covered > covered soon > covered later). Overflow navigates to a full list.
- **Rationale:** Three full rows with four cognitive atoms each (name, amount, due, status) already push cognitive limits. Showing only 2-3 reduces overload.
- **Source:** CR S5.2, S16.2. **Overrides** DR S7 fixed 3-row display.
- **Implementation:** Obligation list sorted by harm priority: `due soon + not covered > due soon + covered > later + covered`. Show top 2-3.

### DASH-054 — Threat tier is not an alarm
- **Requirement:** Obligation rows use all neutral colors for amounts and names. No row is tinted red in its entirety. Only the coverage status text uses state colors when relevant (short = brick red, uses buffer = amber).
- **Rationale:** The accent line at Tier 1 carries alarm. Tier 2 carries facts. Over-alarming the obligations section causes anxiety, not clarity.
- **Source:** DR S7, CR S16.2
- **Implementation:** Row backgrounds are transparent. Only the coverage status label applies conditional color.

### DASH-055 — Obligation row height
- **Requirement:** 44pt minimum row height for accessible touch targets.
- **Rationale:** Accessibility requirement for reliable tap interaction.
- **Source:** DR S7
- **Implementation:** Minimum `44.0` logical pixels for each obligation row.

### DASH-056 — Obligation tap behavior
- **Requirement:** Tapping an obligation row opens an edit sheet for that fixed cost (amount, day-of-month, exclude flag, mark paid this cycle).
- **Rationale:** Direct edit access supports the maintenance model.
- **Source:** DR S9, CR S6.3
- **Implementation:** Sheet includes visible "mark paid this cycle" button (not hidden behind long-press).

### DASH-057 — Paid obligations hidden from home [OVERRIDDEN BY v2]
- **Requirement:** Obligations already paid this cycle do not appear on the home screen. They are visible in History.
- **Rationale:** Home shows only forward-looking pressure. Past obligations are historical data.
- **Source:** CR S16.2
- **Implementation:** Filter obligation list to exclude `paidThisCycle == true`.

---

## Section 6: Information Hierarchy and Section Order

### DASH-060 — Canonical section order [OVERRIDDEN BY v2]
- **Requirement:** Top to bottom:
  1. Top bar (Pocketa wordmark left, refresh icon right, freshness + input confidence line)
  2. S2S Hero (label above number, number, meaning line, accent line + state label)
  3. Conditional Maintenance Strip (only when action needed)
  4. Next Obligations (2-3 rows with coverage status)
  5. Not Counted Yet (pending/expected USD summary)
  6. Bottom nav (Home, Pipeline, History, Settings)
  7. Extended FAB during MVP ("+ Expected payment")
- **Rationale:** This order mirrors the improved cognitive hierarchy: Answer, Confidence, Pressure, Maintenance, Hope.
- **Source:** CR S17. **Overrides** DR S4 section order.
- **Implementation:** Widget tree must follow this exact order. No rearrangement.

### DASH-061 — Freshness + input confidence combined [OVERRIDDEN BY v2]
- **Requirement:** The freshness line combines timestamp AND input status in one line. Normal: `Updated 2 min ago . inputs current`. Degraded: `Updated 2 min ago . 1 payment needs review`.
- **Rationale:** Freshness alone is not enough trust context. Input confidence status turns metadata into actionable trust information.
- **Source:** CR S3.3. **Overrides** DR S2/S4 separate greeting + freshness.
- **Implementation:** Single `Text` widget with dynamically assembled content.

### DASH-062 — Greeting removed [OVERRIDDEN BY v2]
- **Requirement:** The greeting line ("Good evening, Mehedi") is removed from the dashboard.
- **Rationale:** Consumes early attention without increasing trust. A finance cockpit speaks like an instrument, not a social app.
- **Source:** CR S1.2, S18. **Overrides** DR S2/S4 greeting line.
- **Implementation:** No greeting widget in home screen. The first content the eye hits is the freshness/confidence line, then S2S.

### DASH-063 — Bottom nav labels [OVERRIDDEN BY v2]
- **Requirement:** Bottom nav items: Home, Pipeline, History, Settings.
- **Rationale:** "You" is too lifestyle-app coded. "Settings" is boring and clear. Financial products should not be cute.
- **Source:** CR S2.3. **Overrides** DR S4/S13 "You" tab.
- **Implementation:** Fourth nav item label is "Settings."

### DASH-064 — Canvas allocation
- **Requirement:** Approximate vertical canvas allocation: Tier 1 (S2S hero) ~36-40%, Tier 2 (obligations) ~22-25%, Tier 3 (not counted yet) ~14-20%, whitespace + nav ~15-20%.
- **Rationale:** The hero dominates. Everything else is secondary. Whitespace is intentional calm.
- **Source:** DR S3, S4
- **Implementation:** Layout weights reflect these proportions on the reference device (412x915 logical px).

### DASH-065 — Nothing competes with the hero
- **Requirement:** No card, tile, or section may have equivalent visual weight to the hero number. The current Income/Expense tiles pattern (two equally-weighted blocks) is explicitly killed.
- **Rationale:** Competing visual weight dilutes the cockpit's single-answer purpose.
- **Source:** DR S2
- **Implementation:** Visual hierarchy audit: no element > 32pt text except the hero number.

---

## Section 7: Trust Indicators on Dashboard

### DASH-070 — Freshness timestamp always visible
- **Requirement:** The time since last calculation is always visible in the freshness line: "Updated X min ago."
- **Rationale:** A number without a timestamp is a number without authority.
- **Source:** DR S2, S13, CR S3.3
- **Implementation:** Relative timestamp, auto-updating.

### DASH-071 — Input confidence indicator [OVERRIDDEN BY v2]
- **Requirement:** The freshness line includes an input confidence suffix: "inputs current" when all inputs are valid, or "N input(s) need(s) review" when action is required.
- **Rationale:** The user needs to know not just that the calculation is fresh, but that its inputs are trustworthy.
- **Source:** CR S3.3. **Overrides** DR which had freshness-only.
- **Implementation:** Input validation check runs on each recalculation and feeds the confidence suffix.

### DASH-072 — Calculation Breakdown drawer as trust proof [OVERRIDDEN BY v2]
- **Requirement:** The breakdown drawer is split into two semantic sections: "Counted in Safe-to-Spend" (liquid BDT, minus fixed costs, minus buffer = S2S) and "Not counted yet" (pending payments with reason). Excluded money must NOT appear inside the equation as a `+` line.
- **Rationale:** A `+ Pending USD ... excluded` line is mathematically confusing. Showing excluded money inside the inclusion equation is a trust smell.
- **Source:** CR S3.4, S14. **Overrides** DR S9 breakdown drawer format.
- **Implementation:** Two visually separated sections. Equation section contains only included items. Excluded section below, clearly separated.

### DASH-073 — Breakdown drawer row behavior [OVERRIDDEN BY v2]
- **Requirement:**
  - Liquid BDT: tap to edit current aggregated balance
  - Fixed costs: tap to view fixed cost list
  - Safety buffer: tap to adjust 5-30% buffer slider
  - Pending payments: tap to open Pipeline
  - Safe-to-Spend total: not editable; tap shows boundary explanation: "Pocketa never edits Safe-to-Spend directly. Edit the inputs to change the number."
- **Rationale:** Every line is tappable and explains itself. The S2S total is read-only to enforce Trust Layer 3.
- **Source:** CR S14. **Overrides** DR S9 row behavior (minor refinements).
- **Implementation:** Each row has a tap handler navigating to the appropriate edit surface.

### DASH-074 — No Tax Reserve in MVP drawer [OVERRIDDEN BY v2]
- **Requirement:** The breakdown drawer does not show a Tax Reserve line during MVP, since tax reserve is a V2 feature.
- **Rationale:** Showing a feature line with `0.00` or "V2" confuses users and violates the doctrine's phase boundaries.
- **Source:** CR S14. **Overrides** DR S9 which included `- Tax reserve (V2)  0.00`.
- **Implementation:** Omit the tax reserve row entirely until the V2 feature is implemented.

### DASH-075 — S2S is computed, never stored
- **Requirement:** Safe-to-Spend is always computed on-demand from current inputs. It is never persisted as a stored value.
- **Rationale:** Trust Layer 2 -- storing a computed value creates staleness risk. Always recompute.
- **Source:** DR S1, S5
- **Implementation:** `S2SResult` computed via a pure function in the domain layer. No persistence of the result.

### DASH-076 — The dash fallback is sacred
- **Requirement:** When S2S cannot be computed (missing FX rate, stale data, contradictory inputs), the hero renders `--` (em dash) in the same font, same size, same color. NEVER show `0.00` on calculation failure.
- **Rationale:** Better one hour of "--" than one second of a wrong number. "BDT 0.00" on failure is a trust bomb.
- **Source:** DR S5, S11, CR S12
- **Implementation:** `S2SResult.error` maps to "--" display. Zero is shown ONLY when zero is a valid computed answer.

---

## Section 8: Conditional Maintenance Strip

### DASH-080 — Maintenance strip appears only when action is needed [OVERRIDDEN BY v2]
- **Requirement:** A Maintenance Strip appears between the hero and obligations ONLY when the user needs to take action to preserve S2S truth. Examples: "1 payment expected today / Confirm received -> updates Safe-to-Spend" or "1 input needs review / Add FX rate -> restores Safe-to-Spend."
- **Rationale:** The product lives or dies on manual pipeline maintenance. When a payment needs confirmation, that job temporarily outranks the Hope tier.
- **Source:** CR S6.1, S13. This is a new element not present in DR.
- **Implementation:** Conditional widget that renders above obligations when any pipeline entry or input requires user action. Not visible in normal state.

### DASH-081 — Maintenance strip is not engagement bait
- **Requirement:** The strip appears only for genuine financial maintenance. No inbox dots, no "check your app" prompts, no engagement notifications.
- **Rationale:** Engagement theater is killed by Doctrine S9. The strip exists for truth preservation only.
- **Source:** CR S13
- **Implementation:** Strip triggered only by: payment expected today, missing FX rate, stale critical input, or calculation failure requiring user input.

### DASH-082 — Maintenance strip temporarily outranks Hope tier
- **Requirement:** When the maintenance strip is visible, it replaces the Hope tier's visual priority. The strip appears above obligations; the Hope tier remains at the bottom.
- **Rationale:** Confirming a received payment changes S2S immediately and is the most important behavioral metric in the MVP.
- **Source:** CR S6.1, S17
- **Implementation:** Maintenance strip inserts between hero and obligations in the layout.

---

## Section 9: Interaction Patterns

### DASH-090 — Gesture/surface mapping
- **Requirement:**
  - Hero S2S number: tap = Calculation Breakdown drawer
  - Hero meaning line: tap = same as hero tap
  - Hero: long-press = optional refresh (not primary path)
  - Obligation row: tap = edit sheet for that fixed cost
  - "Not counted yet" block: tap = navigate to Pipeline tab
  - Freshness line: tap = no action (label only)
  - Refresh icon (top-right): tap = forced refresh with spinner
  - Home screen: pull-down = pull-to-refresh with sync timestamp
  - Extended FAB: tap = Add Expected Payment sheet
- **Rationale:** Every interactive surface has exactly one purpose. No competing gestures.
- **Source:** DR S9, CR S6, S16.1
- **Implementation:** Gesture handlers assigned per surface. No swipe, pinch, or double-tap on the hero.

### DASH-091 — Extended FAB during MVP [OVERRIDDEN BY v2]
- **Requirement:** The FAB is an extended FAB labeled `+ Expected payment` during the MVP learning period. Not a lone `+` icon.
- **Rationale:** A lone `+` on a finance home screen reads as generic "add transaction" to users trained by bKash/TallyKhata. The label clarifies purpose.
- **Source:** CR S2.1. **Overrides** DR S9/S13 lone `+` icon FAB.
- **Implementation:** `FloatingActionButton.extended` with label text. May collapse to icon-only after analytics confirm user understanding.

### DASH-092 — Add Expected Payment sheet is staged [OVERRIDDEN BY v2]
- **Requirement:** The Add Expected Payment sheet has two steps. Step 1 (required): Amount + Expected date. Step 2 (optional but encouraged): Client/source + FX rate. Missing FX is allowed but the entry is marked "not counted."
- **Rationale:** Capture should be easy. Counting should be strict. Requiring all fields at once feels like finance homework.
- **Source:** CR S15. **Overrides** DR S9 single-step entry form.
- **Implementation:** Two-step sheet. Missing optional inputs reduce confidence but do not block save.

### DASH-093 — Long-press "mark paid" is shortcut only [OVERRIDDEN BY v2]
- **Requirement:** Long-press on an obligation row to "mark paid this cycle" is allowed as a power-user shortcut, but the primary "mark paid" action must be a visible button inside the tap-opened edit sheet.
- **Rationale:** Hidden gestures must never be the only path for actions that change financial truth.
- **Source:** CR S6.3. **Overrides** DR S9 which positioned long-press as a co-equal action path.
- **Implementation:** Edit sheet includes visible "Mark paid this cycle" button. Long-press is convenience, not primary.

### DASH-094 — Pull-to-refresh
- **Requirement:** Pull-down on the home screen triggers a refresh. The last sync timestamp is visible while pulling.
- **Rationale:** Standard mobile pattern for manual data refresh.
- **Source:** DR S9
- **Implementation:** `RefreshIndicator` widget with timestamp display.

---

## Section 10: Empty States

### DASH-100 — Fresh install (post-onboarding, pipeline empty)
- **Requirement:** S2S works from Day 1 with liquid balance and fixed costs alone. The hero number is NEVER gated behind "complete setup." The Hope tier shows: `Add your first expected payment to forecast further >`.
- **Rationale:** The hero must provide value immediately. Blocking S2S behind setup completion destroys first-session trust.
- **Source:** DR S10
- **Implementation:** S2S calculator produces a valid result with zero pipeline entries. Empty Hope tier shows onboarding prompt.

### DASH-101 — First-ever app open (PIN set, no data)
- **Requirement:** Hero shows `--` with sub-line: `Add your liquid balance to see your first number. >`. Below, a setup checklist: (1) Your current BDT balance, (2) Your monthly fixed costs, (3) Your first expected payment (optional).
- **Rationale:** "--" is correct for cold-start. Showing `0.00` during first open is the same trust failure as the current screen.
- **Source:** DR S10
- **Implementation:** Conditional layout when no liquid balance is set. Setup checklist items are tappable navigation links.

### DASH-102 — No fixed costs configured
- **Requirement:** Hero populates normally. Obligation section shows: `No fixed costs in the next 30 days. / Add a recurring bill? >`.
- **Rationale:** No alarm, no "Add some bills!" energy. A quiet invitation if relevant.
- **Source:** DR S10
- **Implementation:** Conditional empty state in obligation section.

### DASH-103 — No pending pipeline (the Trough)
- **Requirement:** Hero populates normally. Hope section shows: `No pending pipeline right now. / Add expected payments as work comes in. >`. NEVER show "0 expected income" with alarm framing. Truth without alarm.
- **Rationale:** The Trough (between contracts) is the high-anxiety moment. Pocketa must pivot to runway emphasis, never panic.
- **Source:** DR S10
- **Implementation:** Conditional empty state in "Not counted yet" section. No alarm copy.

### DASH-104 — All fixed costs paid for the cycle
- **Requirement:** Obligation section shows: `All this month's fixed costs are paid. / Next: [obligation] on the [date] >`.
- **Rationale:** Confirmation + forward-looking next-item reduces Zeigarnik effect.
- **Source:** DR S10
- **Implementation:** Conditional display when all current-cycle obligations are marked paid.

---

## Section 11: Data Freshness and Staleness Indicators

### DASH-110 — Relative timestamp
- **Requirement:** Freshness line shows relative time: "Updated just now", "Updated 2 min ago", "Updated 4 hours ago", etc.
- **Rationale:** Relative time is immediately comprehensible without mental math.
- **Source:** DR S2, CR S3.3
- **Implementation:** Auto-updating relative timestamp.

### DASH-111 — Stale data handling
- **Requirement:** When last sync exceeds a staleness threshold, the freshness line updates to show stale state: "Last sync 4 hours ago. Tap to refresh." The last known computed S2S is shown but marked with staleness context.
- **Rationale:** Offline-tolerant design. The user is never blocked, but staleness is surfaced.
- **Source:** DR S11
- **Implementation:** Conditional styling on freshness line when staleness threshold is exceeded.

### DASH-112 — Offline tolerance
- **Requirement:** "No internet" is never a blocker. Local edits queue and sync on reconnection. The user can still use Pocketa offline. Display: "You can still use Pocketa offline."
- **Rationale:** Freelancers in Bangladesh may have intermittent connectivity. Blocking on network is unacceptable.
- **Source:** DR S11
- **Implementation:** Local-first architecture. Queued sync with connectivity listener.

### DASH-113 — Calculation failure surfaces repair needs immediately [OVERRIDDEN BY v2]
- **Requirement:** When S2S cannot be computed, the home becomes a repair surface. The broken input is shown immediately on the home screen (e.g., "Acme payment . $1,500 . FX rate missing >"), NOT hidden behind the breakdown drawer.
- **Rationale:** The user should not have to open the drawer to discover what is broken.
- **Source:** CR S12. **Overrides** DR S11 which put the repair list inside the tap-to-review drawer.
- **Implementation:** A "Needs review" section appears on home when any input blocks S2S calculation, with tappable items to fix each issue.

---

## Section 12: Anti-Patterns (What the Dashboard Must NOT Do)

### DASH-120 — No income/expense aggregate tiles
- **Requirement:** No "Income: BDT X / Expense: BDT Y" summary tiles on the home screen.
- **Rationale:** Mental accounting violation. Aggregates without S2S context look backward. TallyKhata pattern.
- **Source:** DR S3, S13
- **Implementation:** Kill list item. No aggregate tile widgets on home.

### DASH-121 — No recent transactions feed
- **Requirement:** No transaction list, recent activity, or transaction history on the home screen.
- **Rationale:** Violates the 9-line cognitive limit. Looks backward. Generic expense-tracker pattern. Transactions belong in the History tab.
- **Source:** DR S8, S13
- **Implementation:** Kill list item. Transaction feeds exist only in the History tab.

### DASH-122 — No charts, graphs, or visualizations
- **Requirement:** No pie charts, line charts, bar graphs, or any data visualization on the home screen.
- **Rationale:** Killed by Doctrine S12. If the question is S2S, the breakdown drawer answers it. If the question is historical, it belongs in History.
- **Source:** DR S3, S14
- **Implementation:** Kill list item.

### DASH-123 — No health scores, financial scores, or ratings
- **Requirement:** No "financial health score," creditworthiness indicator, or any aggregate rating on the home screen.
- **Rationale:** Health scores compete with S2S as the sacred metric. Permanently killed.
- **Source:** DR S3, S14
- **Implementation:** Kill list item.

### DASH-124 — No promotional banners or upgrade prompts
- **Requirement:** No ads, upgrade prompts, "what's new" banners, or promotional content on the home screen.
- **Rationale:** The home screen is a financial instrument, not a marketing surface.
- **Source:** DR S3
- **Implementation:** Kill list item.

### DASH-125 — No avatars, profile photos, or mascots
- **Requirement:** No user avatars, profile images, mascots, or decorative illustrations on the home screen.
- **Rationale:** Visual clutter that competes with the hero number.
- **Source:** DR S3
- **Implementation:** Kill list item.

### DASH-126 — No counter/rolling-number animations
- **Requirement:** No slot-machine, counter-roll, or incrementing number animations on the hero or any financial figure.
- **Rationale:** Gamification of financial data destroys trust. Sacred things do not wiggle.
- **Source:** DR S5
- **Implementation:** Kill list item.

### DASH-127 — No tinting the hero number
- **Requirement:** The hero number is never tinted by state color (no orange, red, green on the number itself).
- **Rationale:** State is conveyed by the accent line. Tinting the number adds visual noise and creates an alarm surface where there should be a fact.
- **Source:** DR S5, S13
- **Implementation:** Hero number color is always `AppColors.primaryInk`.

### DASH-128 — No "Something went wrong" without specificity
- **Requirement:** Error states must always specify what is wrong and what the user can do. Never show generic "Something went wrong" or "Try again later" without an alternative path.
- **Rationale:** Vague errors make the user feel they broke something. Pocketa errors must be specific and actionable.
- **Source:** DR S11
- **Implementation:** All error states map to specific copy with remediation paths.

### DASH-129 — No direct S2S override by the user
- **Requirement:** No gesture, input field, or setting allows the user to directly set or override the S2S number. They edit inputs; the system computes the result.
- **Rationale:** Trust Layer 3 -- the calculation is the product. Overriding it makes Pocketa a manual tracker, not a cockpit.
- **Source:** DR S9, CR S14
- **Implementation:** No edit affordance on S2S display. Breakdown drawer S2S row tap shows boundary explanation only.

### DASH-130 — No stored S2S value
- **Requirement:** S2S is never persisted to storage. It is always computed fresh from inputs.
- **Rationale:** Trust Layer 2 -- staleness of a stored computed value is a trust violation.
- **Source:** DR S1
- **Implementation:** S2S exists only as a computed `AsyncValue` in the Riverpod provider layer.

### DASH-131 — No engagement notification artifacts
- **Requirement:** No notification badges, inbox dots, "what's new" indicators, or engagement-theater elements on the dashboard.
- **Rationale:** Notification Doctrine limits to two classes: transactional and boundary. "Time to check Pocketa" is engagement and is not allowed.
- **Source:** DR S14, CR S19
- **Implementation:** No badge widgets on home. Maintenance strip serves genuine maintenance only.

### DASH-132 — No generic expense categories
- **Requirement:** No spending categories, category chips, or category-based filtering on the home screen.
- **Rationale:** Permanent Kill List -- generic expense categorization is TallyKhata territory.
- **Source:** DR S8, S13
- **Implementation:** Kill list item. Categorization, if ever implemented, lives elsewhere.

### DASH-133 — No AI insights panel
- **Requirement:** No "AI insights," ML-generated tips, or automated financial advice on the home screen.
- **Rationale:** Hallucination risk on financial data is unforgivable. Killed under Pocketa brand.
- **Source:** DR S14
- **Implementation:** Kill list item.

---

## Section 13: Conflict Resolution Log

This section documents every conflict between DR (Dashboard Redesign) and CR (Tier-1 Critique v2), with the winning decision.

| ID | Topic | DR Position | CR Position (WINS) | Resolution |
|----|-------|-------------|---------------------|------------|
| C-01 | Dashboard hierarchy | Present -> Threat -> Hope (3 tiers) | Answer -> Confidence -> Pressure -> Maintenance -> Hope (5 layers) | CR wins. Adds confidence and conditional maintenance. |
| C-02 | Hero label placement | Below number, sentence case ("Safe to spend") | Above number, small uppercase ("SAFE-TO-SPEND") | CR wins. Label primes interpretation before reading number. |
| C-03 | Meaning line content | "covers N days at your usual pace" (runway) | "after fixed costs + 15% buffer" (deduction explanation) | CR wins. Deduction explanation is more informative as primary line. |
| C-04 | Decimal display | Full weight, always shown | Shown but de-emphasized (reduced opacity/size) | CR wins. Preserves precision trust while reducing visual noise. |
| C-05 | Greeting line | "Good evening, Mehedi" as separate line | Removed entirely | CR wins. Consumes attention without trust benefit. |
| C-06 | Freshness line | "Updated 2 min ago" (timestamp only) | "Updated 2 min ago . inputs current" (timestamp + confidence) | CR wins. Adds input trust context. |
| C-07 | Reserve Mode hero | "Liquid BDT remaining" replaces S2S | S2S is always the hero; show `0.00` or "--" | CR wins. Never replace the sacred metric. |
| C-08 | "Reserve Mode" label | "Reserve mode is on" shown on screen | Killed. Use state names: Safe/Tight/At Risk | CR wins. Mode labels cause panic. |
| C-09 | Obligation status | Proximity dots (filled/half/outline) | Coverage text (covered/uses buffer/short X) | CR wins. Text closes the cognitive loop. |
| C-10 | Max obligation rows | Fixed 3 rows always | 2-3 rows, risk-weighted | CR wins. Reduces cognitive atom overload. |
| C-11 | Hope tier label | "Pending pipeline" | "Not counted yet" | CR wins. Highest-leverage copy change. |
| C-12 | Pipeline summary format | Multi-line with "across N invoices" | Single-line with dot separators | CR wins. More compact. |
| C-13 | FAB design | Lone `+` icon | Extended FAB: "+ Expected payment" | CR wins. Avoids generic "add transaction" pattern. |
| C-14 | Add entry form | Single step: amount, client, date, FX | Two steps: required (amount+date) then optional (client+FX) | CR wins. Reduces capture friction. |
| C-15 | Long-press as action path | Co-equal with tap for "mark paid" | Shortcut only; primary action in visible sheet | CR wins. Hidden gestures must not be primary for financial truth. |
| C-16 | Breakdown drawer format | Single equation with `+ Pending USD ... excluded` | Two sections: "Counted" equation + "Not counted yet" separate | CR wins. Avoids mathematical confusion. |
| C-17 | Tax reserve in MVP drawer | Shown as `- Tax reserve (V2)  0.00` | Omitted entirely in MVP | CR wins. No V2 features in MVP UI. |
| C-18 | Bottom nav "You" tab | "You" | "Settings" | CR wins. Boring clarity over lifestyle coding. |
| C-19 | Calc failure repair UX | Tap "--" to open repair list in drawer | Broken input shown on home immediately ("Needs review" section) | CR wins. Repair surface, not buried in drawer. |
| C-20 | "The Path" label (Reserve Mode) | "The Path" for obligation list in reserve | "Next obligations" always | CR wins. No dramatic labels. |
| C-21 | Maintenance strip | Not present | Conditional strip for payment confirmation/input review | CR wins. New element supporting pipeline maintenance. |
| C-22 | Obligation section label | Unlabeled | "Next obligations" | CR wins. Explicit section labeling. |

---

## Section 14: Shippability Checklist (from CR S19)

Before the dashboard build can ship, every item must pass:

**Calm:**
- [ ] One dominant number or dash appears first.
- [ ] No row forces the user to mentally calculate coverage.
- [ ] At Risk state is factual, not dramatic.
- [ ] No mode label creates panic.

**Trust:**
- [ ] Every number has unit and freshness.
- [ ] S2S is computed from the same function used by the drawer.
- [ ] Dash appears on calculation failure.
- [ ] Zero appears only when zero is a valid computed answer.
- [ ] Excluded money is not shown inside the equation as a plus line.

**Clarity:**
- [ ] Home distinguishes counted vs not counted.
- [ ] Pending USD never appears as BDT-equivalent on home.
- [ ] Fixed costs show coverage status.
- [ ] The next required manual action is visible when needed.

**Friction:**
- [ ] Add expected payment requires only amount + expected date.
- [ ] Payment confirmation is one tap from the maintenance strip.
- [ ] Missing optional details do not block capture.
- [ ] Suspicious values are challenged, not rejected.

**Doctrine:**
- [ ] No generic expense categories on home.
- [ ] No charts, scores, AI insights, or promo banners.
- [ ] No engagement notification artifacts.
- [ ] No direct S2S override.
- [ ] No stored S2S value.

---

## Appendix: Dark Mode and Accessibility Notes

### DASH-A01 — Dark mode
- **Requirement:** Identical layout. Canvas `#0E0E0C`. Primary ink `#F5F5F0`. Accent colors unchanged (already muted for dark surfaces). Follows system preference; no manual toggle.
- **Source:** DR S12

### DASH-A02 — Bangla text height
- **Requirement:** Bangla text renders 8-12% taller than Latin at the same point size. Reserve vertical padding accordingly.
- **Source:** DR S12

### DASH-A03 — Reduce-motion accessibility
- **Requirement:** Respect `MediaQuery.disableAnimations`. The 240ms drawer animation collapses to instant when reduce-motion is on. The 200ms hero fade-in also collapses.
- **Source:** DR S14

### DASH-A04 — Reference device
- **Requirement:** Design reference: 6.1" Android (Samsung A14 class), 412 x 915 logical px, 8pt grid throughout.
- **Source:** DR S12, CR S9
