# Visual Identity Refinements — Extracted from Helm Visual Identity Critique & Refined System

> **Source:** `docs/research/ux/Helm_Visual_Identity_Critique_and_Refined_System.md`
> **Authority level:** OVERRIDES earlier Visual Identity System (`07_visual_identity_requirements.md`) where conflicts exist. This document is the final authority on visual decisions.
> **Review posture:** Global fintech design director -- adversarial, product-led, Bangladesh-aware.
> **Extraction date:** 2026-06-04

---

## 1. What Changed from the Earlier System and Why

### VISR-001: Core Metaphor Shift [REFINED]

**Statement:** The visual north star shifts from "clinical instrument / chronometer" to "calm Bangladeshi cashflow ledger that separates real money from hopeful money."

**What changed:** The earlier system described Helm as a "chronometer." The refined system argues this is too foreign, too cold, and too mechanical for the emotional job. Bangladeshi freelancers need a "quiet financial witness," not a Swiss instrument.

**Rationale:** The chronometer metaphor risks becoming emotionally cold. Users are not CFOs in boardrooms; they are freelancers checking money at 11 PM near month-end under stress. The product must be exact AND protective.

**Implementation implication:** All visual decisions should be evaluated against the ledger metaphor, not the chronometer metaphor. The distinction matters for warmth, locality, and emotional safety.

---

### VISR-002: Visual North Star [REFINED]

**Statement:** New north star replaces the earlier one:

> **Earlier:** "Helm looks like a calm clinical instrument that a Bangladeshi freelancer trusts at 11pm on Day 29."
>
> **Refined:** "Helm looks like a calm Bangladeshi cashflow ledger that separates real money from hopeful money with absolute clarity -- quiet enough for stress, exact enough for trust, and distinctive enough to never feel like a generic expense tracker."

**What changed:** Added Bangladesh specificity, cashflow ledger metaphor, real vs hopeful money separation, distinctiveness requirement, and anti-expense-tracker positioning.

**Rationale:** The earlier north star was defensively correct (killing bad patterns) but did not create positive distinctiveness. A blurred Helm screen was indistinguishable from Stripe, Wise, Notion, or a YC fintech MVP.

**Implementation implication:** Every screen must pass the "is this recognizably Helm?" test, not just the "does this avoid bad patterns?" test.

---

### VISR-003: Generic Visual Risk Diagnosis

**Statement:** The earlier system's strict "no everything" approach can still produce a template feeling because many premium app templates now use the same restraint language (off-white, black text, mono numbers, rounded cards, outline icons, teal accent, minimal tabs).

**What changed:** This is a new risk identification. The earlier system did not acknowledge that restraint alone can be generic.

**Rationale:** If you blur the logo and copy, the earlier system's output could be mistaken for any premium Flutter UI kit or YC fintech MVP. That is a distinctiveness failure.

**Implementation implication:** Helm needs ownable interface signatures (Ledger Rail, Reality Stack, Trust Strip, Calculation Trace, BDT-first Money Stamp) rather than relying solely on restraint.

---

### VISR-004: Emotional Posture Shift [REFINED]

**Statement:** Emotional posture moves from "I am exact" to "I am exact, and I will not let you emotionally misread your money."

**What changed:** The earlier system was purely clinical. The refined system adds a protective dimension without becoming cute or emotional.

**Rationale:** A purely clinical interface may feel trustworthy but not protective. Users may treat it like a calculator, not a companion habit.

**Implementation implication:** Visual warmth should come from softer human-readable sublines, transparent calculation rows, local financial language, slightly stronger money-state hierarchy, and calm warnings without alarm banners.

---

### VISR-005: Brand Personality Refinement [REFINED]

**Statement:** Refined brand personality:

| Dimension | Direction |
|---|---|
| Emotional temperature | Calm, protective, serious |
| Visual density | Sparse above the fold, detailed on demand |
| Trust model | Source + timestamp + calculation trace |
| Locality | BDT-first, Bangla-native, freelancer-aware |
| Distinction | Ledger rail, reality stack, calculation trace |
| Avoided territory | Neobank, crypto, expense tracker, accounting software, cute savings app |

**What changed:** Added "protective" to emotional temperature. Added "source + timestamp + calculation trace" as active trust model (earlier relied on passive absence of bad patterns). Added specific ownable elements.

**Rationale:** The earlier system defined what NOT to be. The refined system also defines what TO be.

**Implementation implication:** Every screen must show at least one trust proof element (timestamp, source label, calculation access).

---

## 2. Refined Color Values

### VISR-006: Core Color Refinements [REFINED]

**Statement:** Refined core color tokens with specific changes:

| Token | Earlier | Refined | What changed |
|---|---|---|---|
| `canvas.light` | `#FAFAF7` | `#FAFAF6` | Keep (negligible change) |
| `surface.light` | `#FFFFFF` | `#FFFFFC` or keep `#FFFFFF` with stronger border | Warmer variant or stronger structural compensation |
| `ink.secondary.light` | `#141413 @ 60%` | `#3B3A36` (solid) | **Changed from alpha to solid color** |
| `ink.tertiary.light` | `#141413 @ 38%` | `#6A6760` (solid) | **Changed from alpha to solid color** |
| `interactive.light` | `#2C5F5D` | `#255E5B` | Slightly deeper teal |
| `divider.light` (cards) | `#141413 @ 8%` | `#D8D3C8` (solid, ~12% equivalent) | **Stronger for card borders** |
| `hairline.light` (new) | n/a | `#E9E5DB` | **New token** for internal dividers (8% equivalent) |

**Rationale:** Alpha-based text tokens produce inconsistent contrast across different surfaces. Solid resolved colors are reliable. Card borders at 8% disappear on low-quality Bangladesh Android screens.

**Implementation implication:** All text colors must use solid hex values, not `withOpacity()`. Card borders use the stronger `divider` token. Internal hairlines use the new `hairline` token. Custom lint: no `withOpacity()` on text colors.

---

### VISR-007: State Color Refinements [REFINED]

**Statement:** Refined state palette:

| State | Earlier light | Refined light | What changed |
|---|---|---|---|
| `state.safe` | `#6B8F71` | `#5F8569` | Slightly deeper sage |
| `state.tight` | `#B88A4A` | `#A97833` | Slightly deeper amber |
| `state.atRisk` | `#9E4A3A` | `#984635` | Slightly deeper brick red |
| `state.hope` | `#5A7A8C @ 40%` | `#5A7585` (solid for text) | **Solid for text, 40% only for dots/rails** |
| `state.hopeMuted` (new) | n/a | `#9BAAB2` | **New token** for expected dots, low-emphasis markers |

**What changed:** All state colors slightly deepened for better visibility on low-quality screens. Hope tier split into text (solid) and decorative (muted) variants. New `hopeMuted` token added.

**Rationale:** The muted state colors from the earlier system were calm but borderline faint on budget Android displays with screen protectors. The Hope tier at 40% alpha was unreliable for text readability.

**Implementation implication:** State colors must be updated in `HelmColors`. The `state.hope` token now has two variants: full-strength for text, muted for decorative elements.

---

### VISR-008: Alpha vs Solid Color Rule [REFINED]

**Statement:** Use alpha for decorative rails and markers. Use solid resolved colors for readable text. Do not rely on runtime opacity (`withOpacity()`) for text contrast.

**What changed:** The earlier system defined `ink.secondary` and `ink.tertiary` as alpha values over `ink.primary`. The refined system mandates solid hex values.

**Rationale:** Alpha over different surfaces (canvas, surface, cards) produces inconsistent contrast results. In Flutter, `withOpacity()` on text colors can create rendering inconsistencies.

**Implementation implication:** Replace all `color.withOpacity(x)` for text with pre-resolved solid color tokens. Lint rule: no `withOpacity()` on text colors.

---

## 3. Refined Typography Decisions

### VISR-009: Mono Usage Boundaries [REFINED]

**Statement:** JetBrains Mono is for money and calculation only. Inter (humanist sans) is for meaning.

Use mono for:
- Financial values
- FX rate values
- Calculation table values
- Dates only in audit/export context

Do NOT use mono for:
- Labels
- Descriptions
- Empty states
- Onboarding copy
- Error copy
- Button labels

**What changed:** The earlier system defined mono for "all BDT and USD figures everywhere" but did not explicitly restrict its non-use. The refined system draws a hard boundary to prevent mono from dominating and making the app feel too technical.

**Rationale:** If JetBrains Mono dominates too much, the product feels like a code editor rather than a human-facing financial tool.

**Implementation implication:** `HelmAmount` widget uses mono. All other text widgets use Inter. Code review must verify mono is not used for non-financial text.

---

### VISR-010: Bangla Line Height Adjustments [REFINED]

**Statement:** Bangla text requires slightly more line height than Latin:

| Token | Latin line height | Bangla line height |
|---|---|---|
| body.lg | 1.50 | 1.58 |
| body.md | 1.50 | 1.58 |
| body.sm | 1.45 | 1.52 |
| label.md | 1.30 | 1.38 |

**What changed:** The earlier system defined a single set of line heights. The refined system adds locale-specific line heights for Bangla.

**Rationale:** Hind Siliguri renders taller due to Bangla ascenders and descenders. Forcing Latin rhythm onto Bangla paragraphs causes cramped, unreadable text.

**Implementation implication:** `HelmTypography` must include locale-aware line heights. When Bangla locale is active, body and label text styles must switch to Bangla-specific line heights.

---

## 4. Contrast Improvements (Bangladesh Android-First)

### VISR-011: Contrast Philosophy Shift [REFINED]

**Statement:** The earlier system was tuned like a premium iPhone UI. Helm must be tuned like a Bangladesh Android-first financial instrument. "Helm can be quiet, but it cannot be faint."

**What changed:** The earlier system achieved correct WCAG scores but assumed ideal display conditions. The refined system accounts for real Bangladesh usage: outdoor use, high brightness, budget/midrange Android displays, screen protectors, reduced display quality over time, low-light rooms at night, and stress/fatigue/cognitive load.

**Rationale:** "Technically passes contrast" is not enough for the target context. What looks elegant on a Pixel 7 Pro becomes faint on a Redmi Note with a screen protector.

**Implementation implication:** All contrast decisions must be tested on a midrange Android device (e.g., Redmi Note series) with a screen protector, not just checked against WCAG calculators.

---

### VISR-012: Specific Contrast Fixes [REFINED]

**Statement:** Six specific contrast improvements:

| Element | Earlier | Refined | Reason |
|---|---|---|---|
| `surface` on `canvas` | `#FFFFFF` on `#FAFAF7` (1.04:1) | Use stronger border or `#FFFFFC` | Card boundaries disappear on low-quality screens |
| `divider` for cards | `#141413 @ 8%` | `#D8D3C8` (~12% equivalent) | 8% invisible under glare |
| `ink.tertiary` | `#141413 @ 38%` | `#6A6760` (~46% equivalent) | 38% safe only for large text; easy to misuse in body |
| `state.hope` for text | `#5A7A8C @ 40%` | `#5A7585` (~58% equivalent) | 40% too faint for USD pending rows |
| S2S accent line | 1-1.5pt | 3pt rail for hero, 1.5pt for secondary | 1pt too fragile for mission-critical state signal |
| Muted state colors | As earlier | Slightly deepened values | Calm but borderline invisible on budget screens |

**Rationale:** Each fix addresses a real-world visibility problem on Bangladesh Android devices.

**Implementation implication:** Update color tokens and accent line dimensions. Test all changes on a budget Android device.

---

## 5. Accessibility Improvements

### VISR-013: Trust Strip Requirement [REFINED]

**Statement:** Every financially meaningful surface must include a Trust Strip showing source, timestamp, and calculation access.

Example: `Updated 11:42 PM - Received only - FX tk119.66 - Tap to audit`

Specification:
| Property | Value |
|---|---|
| Font | label.sm |
| Color | ink.secondary (not tertiary) |
| Placement | Directly below financial number or bottom of card |
| Max length | 1 line on mobile; truncate only after source info |
| Tap target | Opens calculation/source sheet |

Mandatory for: S2S hero, pipeline totals, FX converted amounts, reserve calculations, exported reports, any synced/imported amount.

**What changed:** The earlier system did not define a trust strip. Trust relied on visual restraint alone. The refined system makes trust a visible, auditable system.

**Rationale:** "Trust me because I look calm" is insufficient. Users need proof: "Trust me because every number has a source, a timestamp, and an explanation."

**Implementation implication:** New `HelmTrustStrip` widget. Must be included wherever `HelmAmount` shows a financially significant value.

---

### VISR-014: Empty State Teaching Rule [REFINED]

**Statement:** Typography-only empty states (from earlier system) are retained, but they must teach the mental model, not merely announce absence.

Example:
```
No received money yet

Add the money that is already usable in BDT. Pending client
payments can be added separately, but they will not increase
Safe to Spend.

[Add received money]
[Add pending payment]
```

**What changed:** The earlier system banned illustrations for empty states (correct) but did not specify what empty states should accomplish. The refined system requires them to educate about the real-vs-hopeful money model.

**Rationale:** First-time users seeing empty states need guided confidence, not just "nothing here yet."

**Implementation implication:** Every empty state string must include: (1) what is empty, (2) what to add and why, (3) how it relates to S2S.

---

### VISR-015: Error State Specificity [REFINED]

**Statement:** Error visuals must be calm but explicit. No generic "Something went wrong." In fintech, vague errors reduce trust.

Example:
```
Couldn't update the calculation

Your previous Safe-to-Spend amount is still shown. Check the
changed entry before relying on this number.

[Review entry]
```

**What changed:** The earlier system did not specify error visual treatment in detail. The refined system requires every error to name what failed and what the user should do, in the same calm tone as all other copy.

**Rationale:** Generic errors in a financial app are more damaging than in other categories because users need to know if their numbers are reliable.

**Implementation implication:** Error states must use `HelmCard` with standard styling (no red backgrounds, no alarm icons). Error copy follows the three-part pattern from the Microcopy System.

---

## 6. New Ownable Visual Assets

### VISR-016: Safe-to-Spend Ledger Rail [REFINED]

**Statement:** The earlier thin accent line (1-1.5pt) under S2S is replaced by a Ledger Rail.

Specification:
| Property | Value |
|---|---|
| Width | 72pt (compact screens), 96pt (regular screens) |
| Height | 3pt on hero, 1.5pt elsewhere |
| Radius | 2pt |
| Position | 8pt below S2S sublabel |
| Color | Safe / Tight / At Risk state token |
| Label | Always paired with text: "Safe", "Tight", or "Reserve Mode" |

**What changed:** Upgraded from decorative thin line to a recognizable product signature. The Ledger Rail is thicker, wider, always labeled, and becomes a visual identity element.

**Rationale:** A thin line feels like decoration. A rail feels like an instrument. The Ledger Rail becomes recognizably Helm.

**Implementation implication:** New `HelmLedgerRail` widget replacing `HelmAccentLine`. Must appear anywhere S2S number appears. Lint rule: no S2S value without `HelmLedgerRail`.

---

### VISR-017: Reality Stack [REFINED]

**Statement:** Helm's home screen must separate money reality levels in a defined stack:

```
1. Safe to spend       -> usable now          (highest weight, mono, ink.primary)
2. Already committed   -> obligations         (medium weight, ink.primary + risk marker)
3. Reserve protected   -> tax/buffer          (medium-low, ink.secondary)
4. Not counted yet     -> pending/expected     (recessed, state.hope, clearly separated)
```

Rule: Pending money must never appear in the same visual weight as usable money.

**What changed:** The earlier system had a "hope tier" concept with desaturated pending money. The refined system formalizes this into a four-layer Reality Stack with defined visual weights. This replaces the generic "balance / income / expense" hierarchy.

**Rationale:** The strongest product idea is separating money reality levels. This should be the visual identity, not just a feature.

**Implementation implication:** New `HelmRealityStack` widget. Home screen must use this structure. Lint rule: no "Balance / Income / Expense" summary card above the fold.

---

### VISR-018: Calculation Trace Pattern [REFINED]

**Statement:** The Calculation Breakdown drawer must follow a ledger-style trace pattern:

```
Received BDT                         tk 78,500.00
Minus fixed commitments             (tk 24,000.00)
Minus tax reserve                    (tk 8,500.00)
Minus anxiety buffer                 (tk 10,000.00)
----------------------------------------------------
Safe to spend                        tk 36,000.00
```

Rules:
- Values right-aligned in mono.
- Operators written in plain language, not symbols only.
- Divider before final result is stronger than normal divider.
- Final number uses display.large, not color drama.
- "Pending income not counted" appears as separate recessed block below.

**What changed:** The earlier system had a calculation breakdown but did not specify it as a repeating visual identity pattern. The refined system makes it a recognizable trust signature.

**Rationale:** The calculation trace should be so consistent that users recognize it even without the logo. Transparency made into visual identity.

**Implementation implication:** New `HelmCalculationTrace` widget. Must use consistent layout across S2S breakdown, pipeline totals, and any future calculation surface.

---

### VISR-019: BDT-First Money Stamp [REFINED]

**Statement:** For any dual-currency amount, BDT appears first and USD appears second and smaller:

```
tk 1,79,500.00
$ 1,500.00 - estimated @ tk119.66
```

Rules:
- BDT first, USD second and smaller.
- FX rate always shown when conversion affects S2S.
- Estimated conversion labeled as estimated.
- Received BDT and pending USD never share same visual block unless relation explicitly shown.

**What changed:** The earlier system specified BDT-before-USD ordering. The refined system formalizes this as a "Money Stamp" with FX rate visibility and estimation labeling rules.

**Rationale:** BDT is not just a currency. In Helm, BDT means usable reality. This distinction must be visually unmistakable.

**Implementation implication:** New `HelmFxEstimate` widget. Lint rule: no dual-currency amount without `HelmFxEstimate`. No pending amount inside same visual group as liquid BDT unless explicitly labeled.

---

## 7. Refined Card Hierarchy

### VISR-020: Card Type Expansion [REFINED]

**Statement:** Earlier system had 4 card types. Refined system has 5 with more specific financial meaning:

| Card type | Visual treatment | Use |
|---|---|---|
| `HelmHeroZone` | No visible card, spatial grouping only | S2S hero |
| `HelmLedgerCard` | 1pt divider border, 12pt radius | Main money facts |
| `HelmAuditCard` | Slightly stronger top rule, right-aligned values | Calculation trace |
| `HelmSourceCard` | Compact card with source icon + status | Payoneer/bank/bKash entries |
| `HelmCautionCard` | AtRisk rail on left, no red fill | Reserve Mode / urgent due |

New rule: Card borders define containers. Ledger rails define financial meaning. Do not use card color to communicate financial state.

**What changed:** Earlier had Hero/Data/Sheet/Inline row. Refined replaces generic "Data card" with purpose-specific types (Ledger, Audit, Source, Caution). This prevents all non-hero cards from looking identical.

**Rationale:** Border-only cards are good, but all cards becoming visually equal reduces scanability.

**Implementation implication:** Five card widgets replacing the earlier four. Each enforces its specific visual treatment.

---

## 8. Refined Iconography

### VISR-021: Custom Icon Subset [REFINED]

**Statement:** Phosphor Icons remain the base, but Helm needs a small custom icon subset for money reality states:

| Icon | Meaning |
|---|---|
| `received-bdt` | Usable local money |
| `pending-usd` | Expected or processing foreign income |
| `commitment` | Fixed cost or obligation |
| `reserve-lock` | Protected amount |
| `audit-line` | Calculation available |
| `fx-estimate` | Exchange rate estimate |

Rule: Custom icons must remain outline-only and match Phosphor geometry. No full-color brand logos in the main UI. Use simplified outline marks or text labels for bKash/Nagad/Payoneer.

**What changed:** The earlier system used Phosphor for everything. The refined system adds 6 custom icons for Helm-specific financial concepts that Phosphor does not cover.

**Rationale:** Phosphor Icons are acceptable but not distinctive. Product-specific money states need product-specific visual markers.

**Implementation implication:** Design and build 6 custom outline icons matching Phosphor metrics (1.5pt stroke, rounded joins/caps, 2pt corner radius). Bundle as custom assets.

---

## 9. Refined Motion

### VISR-022: Breakdown Drawer Stagger [REFINED]

**Statement:** The breakdown drawer animation is refined with a stagger sequence:

1. Sheet slides up: 240ms ease-out.
2. Calculation rows fade in top-to-bottom with 24ms stagger between rows.
3. Final S2S row appears last with a slightly stronger divider already visible.
4. No number rolling, no bounce, no celebration.

Reduce motion: All stagger removed. Sheet appears instantly with 80ms opacity transition.

**What changed:** The earlier system specified the 240ms slide-up but not the row-level stagger. The refined system adds a 24ms stagger to make the math appear sequentially, reinforcing the calculation-trace identity.

**Rationale:** The breakdown drawer is Helm's trust theater. Making math materialize line-by-line emphasizes transparency.

**Implementation implication:** `HelmCalculationTrace` widget must implement staggered `AnimatedOpacity` per row with 24ms delay. Reduce-motion path must skip all stagger.

---

## 10. Bangladesh Context Layer

### VISR-023: Local Financial State Language [REFINED]

**Statement:** Replace generic finance states with Bangladesh freelancer-aware states:

| Generic | Helm |
|---|---|
| Balance | Usable BDT |
| Income | Payment expected / payment received |
| Pending | Processing / client promised / platform clearing |
| Savings | Reserve protected |
| Budget | Monthly commitments |
| Expense | Paid / committed |
| Conversion | FX estimate |

**What changed:** The earlier system treated Bangladesh context as formatting (BDT-first, lakh/crore). The refined system extends this to conceptual vocabulary.

**Rationale:** Bangladesh-first fintech context includes bKash/Nagad mental models, Payoneer transfer delays, family-support obligations, manual cash tracking, and month-end stress. Formatting alone does not capture this.

**Implementation implication:** All home screen labels and hierarchy must use Helm-specific vocabulary, not generic finance terms. Lint rule: no "Balance / Income / Expense" above the fold.

---

### VISR-024: Source Labels [REFINED]

**Statement:** Helm must support visible source labels for money origins: Payoneer, Wise, Bank, bKash, Nagad, Upay, Cash, Manual.

Source labels appear as low-emphasis text, not brand-colored logos.

Example: `Payoneer - processing - not counted yet`

**What changed:** The earlier system did not specify source labeling as a visual identity element. The refined system makes source visibility a trust requirement.

**Rationale:** Freelancers mentally separate "client promised" vs "Payoneer arrived" vs "bank withdrawn." Helm must reflect this separation.

**Implementation implication:** New `HelmMoneySourceLabel` widget. Pipeline entries must show source labels.

---

### VISR-025: Bangla Copy Authoring [REFINED]

**Statement:** Bangla UI copy must be authored separately by a native Bangla speaker, not translated from English. Helm should not sound translated.

Key Bangla terms:
| English | Bangla |
|---|---|
| Safe to spend | nirapade khoroch kora jabe |
| Not counted yet | ekhono dhora hoyni |
| Reserve protected | reserve alada rakha hoyeche |
| Already committed | age thekei nirdhaarito |
| Calculation available | hisab dekha jabe |
| Estimated FX | aanumaanik rate |

**What changed:** The earlier system mentioned Bangla as first-class. The refined system provides specific authored Bangla examples and emphasizes separate authoring vs translation.

**Rationale:** Translated Bangla sounds unnatural to native speakers and undermines trust.

**Implementation implication:** Bangla localization file must be independently authored. A/B or QA testing with native Bangla speakers required.

---

## 11. New Hard Rules Added by Refined System

### VISR-026: Ten New Visual Rules [REFINED]

**Statement:** Ten rules added to the earlier system's rule set:

1. **Every key number must have a source, timestamp, or calculation path.**
2. **Pending money must be visibly lower in hierarchy than usable BDT.**
3. **The Ledger Rail must appear anywhere the S2S number appears.**
4. **No generic balance/income/expense summary above the fold.**
5. **No app-store-style finance dashboard cards.**
6. **No alpha-based text tokens for body text. Use resolved solid colors.**
7. **No trust-critical divider below 12% contrast equivalent on mobile core surfaces.**
8. **Bangla line heights must be tested separately.**
9. **Every dual-currency conversion must reveal FX rate and estimate status.**
10. **Every visual screen must pass the "real vs hopeful money" test.**

**What changed:** These are all net-new rules not present in the earlier system.

**Rationale:** Each addresses a gap identified in the critique: generic-visual risk, weak trust cues, poor contrast on real devices, emotional mismatch, app-store-template feeling, and Bangladesh context mismatch.

**Implementation implication:** Add these to the visual review checklist. Rules 3, 4, 6 should be enforced by lint rules.

---

### VISR-027: The Real vs Hopeful Money Test [REFINED]

**Statement:** Before shipping any screen, verify:

1. Can the user instantly tell which money is usable today?
2. Can the user instantly tell which money is pending or uncertain?
3. Can the user see why the S2S number changed?
4. Can the user audit the calculation without hunting?
5. Does BDT feel more grounded than USD?
6. Does the screen avoid generic finance-app patterns?
7. Does the design reduce anxiety without hiding risk?

If any answer is no, the screen fails.

**What changed:** This is a new quality gate not present in the earlier system.

**Rationale:** This test operationalizes Helm's core product truth into a design review checklist.

**Implementation implication:** Add to PR review template for any change that affects visual layout or financial data display.

---

## 12. Refined Home Screen Structure

### VISR-028: Home Screen Layout [REFINED]

**Statement:** Refined above-the-fold home screen structure:

```
[Trust timestamp]

Safe to spend
tk 36,000.00
[Ledger Rail: Tight]
Covers 17 days at your usual pace

Already committed this month
tk 24,000.00 - 3 upcoming

Reserve protected
tk 10,000.00 - not counted as spendable

Not counted yet
$ 600 pending - estimated tk71,796.00
```

**What changed:** Earlier home screen had: greeting + S2S hero + accent line + threat rows + hope tier. Refined replaces this with: trust timestamp + S2S hero + Ledger Rail + Reality Stack (committed / reserve / not counted).

**Rationale:** The refined structure avoids generic dashboard patterns, makes safe-vs-hopeful money unmistakable, shows trust context immediately, localizes mental model around "usable BDT," and reduces anxiety without hiding danger.

**Implementation implication:** Home screen widget tree must be rebuilt around the Reality Stack pattern. The earlier "threat tier" and "hope tier" are replaced by the four-layer Reality Stack.

---

## 13. App Store Identity

### VISR-029: App Icon Direction [REFINED]

**Statement:** App icon should avoid: wallet, coin, pie chart, upward graph, green money, generic letter "P". Instead, use a ledger rail inside a rounded square with a small BDT grounding mark. Deep teal accent only. No gradient, no shadow.

**What changed:** The earlier system did not specify app icon direction. This is new.

**Rationale:** The app icon must feel like the product's visual identity, not a generic fintech symbol.

**Implementation implication:** Icon design task required before app store submission.

---

### VISR-030: App Store Screenshot Language [REFINED]

**Statement:** Screenshot headings must reflect product-specific value, not generic finance marketing.

Bad: "Track your expenses", "Manage your money", "See your dashboard"
Good: "Know what is actually safe to spend", "Separate received money from pending money", "See the calculation behind every amount", "Built for BDT/USD freelancer cashflow"

**What changed:** The earlier system did not address app store presentation. This is new.

**Rationale:** App store screenshots are the first impression. Generic finance marketing undermines the product's distinctive positioning.

**Implementation implication:** Screenshot design must use warm off-white background, one phone mockup per slide, large headline, real BDT/USD examples, and the calculation trace as trust moment. No lifestyle photos or stock illustrations.

---

## 14. Additional Flutter Implementation Notes

### VISR-031: New Required Widgets [REFINED]

**Statement:** Six new widgets required beyond the earlier system's list:

| Widget | Purpose |
|---|---|
| `HelmLedgerRail` | Replaces `HelmAccentLine`; ownable S2S state visual |
| `HelmTrustStrip` | Timestamp/source/calculation proof |
| `HelmRealityStack` | Safe / committed / reserve / pending hierarchy |
| `HelmCalculationTrace` | Auditable math drawer with stagger animation |
| `HelmMoneySourceLabel` | Payoneer/bank/bKash/Nagad/manual source clarity |
| `HelmFxEstimate` | FX rate and estimate status display |

**What changed:** These are net-new widgets reflecting the five ownable visual assets.

**Rationale:** Each widget mechanically enforces a refined system concept.

**Implementation implication:** These widgets must be built alongside (or replacing) the earlier system's widget list.

---

### VISR-032: Additional Lint Rules [REFINED]

**Statement:** Seven additional lint rules beyond the earlier system:

1. No `withOpacity()` on text colors.
2. No "Balance / Income / Expense" summary card above the fold.
3. No financial amount without a `HelmAmount` widget.
4. No S2S value without `HelmLedgerRail`.
5. No dual-currency amount without `HelmFxEstimate`.
6. No pending amount inside same visual group as liquid BDT unless explicitly labeled.
7. No generic `SnackBar`; use `HelmToast` with financial-safe copy.

**What changed:** These are net-new lint rules not in the earlier system.

**Rationale:** Each prevents a specific refinement regression.

**Implementation implication:** Add to `custom_lint` configuration alongside the earlier system's lint rules.

---

## 15. Before/After Summary

### VISR-033: Comprehensive Change Summary

**Statement:** Summary of all changes from earlier to refined system:

| Area | Earlier | Refined |
|---|---|---|
| Core metaphor | Clinical instrument / chronometer | Calm Bangladeshi cashflow ledger |
| Visual distinctiveness | Tasteful but generic-minimal risk | Ownable ledger rail + reality stack |
| Trust cues | Calm visual restraint (passive) | Source + timestamp + calculation trace (active) |
| Contrast | Premium subtle | Bangladesh Android-first robustness |
| Emotional posture | Exact but cold | Exact + protective |
| Bangladesh context | Formatting-aware | Cashflow-reality-aware |
| App-store risk | Minimal finance template risk | Product-specific screenshot language |
| State signal | Thin accent line (1-1.5pt) | Ledger rail (3pt) with label and meaning |
| Pending money | Desaturated hope tier | Structurally separated "not counted yet" layer |
| Card hierarchy | 4 generic types | 5 purpose-specific types |
| Iconography | Phosphor only | Phosphor + 6 custom money-state icons |
| Text colors | Alpha-based | Solid resolved colors |
| Bangla typography | Single line heights | Locale-specific line heights |
| Flutter enforcement | Strong token system | Token system + identity-specific widgets + expanded lints |

**Rationale:** The refined system does not discard the earlier system. It builds on its restraint while adding distinctiveness, trust proof, and Bangladesh-first robustness.

**Implementation implication:** When the earlier system and refined system conflict, the refined system wins. The earlier system's kill lists and core rules (no shadows, no gradients, no springs, etc.) remain fully in effect.

---

## 16. Final Doctrine

### VISR-034: Final Refined Identity Principle

**Statement:** Helm's visual identity is not the color palette, the logo, Inter + JetBrains Mono, or "minimalism." The brand is the repeated visual separation between:

```
Real money
Committed money
Protected money
Hopeful money
```

That separation is the identity.

> "Do not make Helm prettier. Make it harder to misunderstand."

**Rationale:** The earlier system's restraint is preserved. The refined system adds recognition and purpose to that restraint.

**Implementation implication:** Every visual decision must be evaluated against whether it makes the real-vs-hopeful money distinction clearer, not whether it makes the app prettier.
