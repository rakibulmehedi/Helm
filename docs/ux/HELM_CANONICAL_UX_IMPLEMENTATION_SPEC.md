# Helm Canonical UX Implementation Spec

> **Status:** Canonical. Single source of truth for all UX implementation work.
> **Created:** 2026-06-05
> **Authority hierarchy applied:**
> 1. Final Product Doctrine (highest product authority)
> 2. UX Doctrine (highest UX authority)
> 3. Visual Identity Critique & Refined System (overrides earlier Visual Identity System)
> 4. Dashboard Tier-1 Critique v2 (overrides earlier Dashboard Redesign)
> 5. Microcopy System (copy authority)
> 6. Pipeline Interaction Optimization (pipeline interaction authority)
> 7. Onboarding Redesign (onboarding authority)
> 8. UX Research (evidence, not direct implementation law)
> 9. Existing code (implementation reality, not strategic authority)
>
> **Source extraction files:** `docs/ux/extracted/01-12`
> **Conflicts resolved:** 7 explicit conflicts documented in Section 10

---

## 1. Dashboard Cockpit Model

### Identity
The home screen is a **cockpit**, not a dashboard. It answers one question: "How much BDT can I actually spend right now?"

### Above-the-Fold Structure (Reality Stack)
The Refined Visual Identity overrides the earlier Threat/Hope tier model with a four-layer Reality Stack:

```
[Trust timestamp]                          label.sm, ink.secondary
Updated 11:42 PM . Received only

[Safe to spend]                            body.lg, ink.primary
Safe to spend
tk 36,000.00                               display.hero (64pt), JetBrains Mono
[Ledger Rail: Tight]                       3pt, 72-96pt wide, state color
Covers 17 days at your usual pace          body.sm, ink.secondary

[Already committed]                        heading.sm, ink.primary
tk 24,000.00 . 3 upcoming                  mono.financial + body.md

[Reserve protected]                        heading.sm, ink.secondary
tk 10,000.00 . not counted as spendable    mono.financial + body.md

[Not counted yet]                          heading.sm, state.hope
$ 600 pending . approx tk71,796.00         mono.financial, state.hopeMuted
```

### 9-Line Rule
Maximum 9 lines of content above the fold on 6.1" reference device. Enforced in layout tests.

### Dashboard Non-Negotiables
| Rule | Source | Implementation |
|------|--------|----------------|
| S2S visible < 2s on 3G | UX-015 | CI performance gate, Samsung A14 reference |
| S2S never animated as counter | UX-016 | 200ms fade-in only, no AnimatedCount |
| State via Ledger Rail only (3pt) | VISR-004 | `HelmLedgerRail` widget, replaces thin accent line |
| "Updated X min ago" always visible | UX-018 | `HelmTrustStrip` widget, mandatory |
| Bottom nav: 4 items max | UX-019 | Home, Pipeline, History, Settings |
| Single FAB: "Add Pipeline Entry" | UX-020 | 56pt circle, interactive bg, "+" icon |
| No avatars, welcome animations | UX-017 | Text greeting only, top-left, low prominence |
| No welcome banners post-onboarding | UX-021 | One-time only |

### Dashboard Forbidden List
No "What's new", no cross-promotion, no uninvited tooltips, no notification dots, no "scores", no charts above fold, no income/expense/balance stat cards, no 3-card dashboard summaries.

### Current Code Gap
Dashboard (IMPL-009) shows income/expense summary chips, transaction list, dev reset button. Must be completely redesigned to Reality Stack model. GAP-006 (no state colors), GAP-008 (dev reset visible).

---

## 2. Onboarding Model

### Philosophy
Onboarding is a trust handshake. Show value before demanding labor. First thing user sees post-onboarding is a computed S2S number.

### The 7-Screen Flow (Pipeline Interaction Optimization authority)
| Screen | Purpose | Time Budget | Data Captured |
|--------|---------|-------------|---------------|
| 1. Pain qualifier | "Have you ever spent money thinking a payment had cleared...?" Yes/Not really | 15s | Qualification |
| 2. Liquid balance | "How much usable BDT do you have right now?" Single BDT input | 25s | liquidBDT |
| 3. Fixed costs | "What do you pay every month?" Guided checklist (Rent, Internet, Phone, Subscriptions, Family, Other) | 45s | fixedCosts[] |
| 4. Income pattern | "How does income arrive?" 3 picture cards (Marketplace/Direct/Retainer) | 15s | incomePattern |
| 5. Buffer comfort | Slider 5%/15%/25%/30% with live BDT preview | 20s | bufferPercent |
| 6. First pipeline entry | Optional: "Add your first expected payment?" | 20s | pipelineEntry (optional) |
| 7. PIN/biometric gate | "Only you should see your income. Set a 6-digit PIN." | 20s | authCredential |

**Total: ~180s median (3 minutes).** Hard constraint: P95 <= 5 minutes.

### Onboarding Rules
- Address user as "you", never by name
- Every step explains WHY in one sentence
- No "Let's get started" / "Almost there!" / "Just one more step"
- No "Done!" celebration — reward IS the S2S number
- State recovery: resume at exact step on re-open
- "Not really" on step 1 = graceful disqualification (not an error)
- Zero optional inputs within required steps; zero skip buttons that break S2S

### Current Code Gap
Onboarding (IMPL-006) is a 3-page motivational carousel with zero data collection. Copy conflicts with product identity ("Track your expenses", "Set your budget"). GAP-001 (MVP-blocking), GAP-002 (identity-breaking), GAP-003 (identity-breaking). Must be completely rebuilt.

---

## 3. Pipeline Interaction Model

### Three Active States + Two Terminal States
| State | Visual | S2S Impact | Transition |
|-------|--------|-----------|------------|
| **Expected** | Outline circle, muted | Hope tier only, never S2S | -> Pending, -> Received, -> Cancelled |
| **Pending** | Half-filled circle | Hope tier, conservative FX | -> Received, -> Expected (failed) |
| **Received** | Filled circle + check | Adds to liquid BDT, recalculates S2S | Terminal (no backward) |
| **Overdue** | Expected/Pending past date | Escalation timeline starts | State unchanged, visual flag |
| **Cancelled** | Struck-through | Removed from all calculations | Terminal |

### The Confirm-Received Sheet (Most Important Widget)
```
You expected:    $1,500 from Acme
Did you receive: tk1,79,500    [edit]
                 (at 119.66 BDT/USD)

[ Confirm Received ]    [ Not yet ]
```
One tap = Pending -> Received -> S2S recalculates. Breakdown drawer opens 1.2s, then closes.

### 2-Tap Notification Path
Notification arrives -> User taps -> Lands on Confirm-Received Sheet -> Confirms. Two taps total. 70% friction reduction from current flow.

### Pipeline Screen Rules
- Group by state, then by date
- Received entries collapse by default (monthly summary)
- Pending/Expected expand by default
- Overdue section at top (calm, not alarming)
- Conservative FX shown; optimistic one tap away
- FAB labeled "+ Expected" (not generic "+")
- No bulk operations
- No drag-and-drop
- No inline editing (all edits open focused sheet)
- No auto-marking received by date

### Duplicate Last Gesture
Long-press received entry -> "Duplicate as expected for next month?" -> One tap creates entry with same amount, FX, date +30 days. Critical for retainer cohort.

### Maintenance Strip
Pipeline screen shows a computation status strip: days since last update, pipeline health. Priority order enforced.

### Current Code Gap
Income pipeline (IMPL-023 to IMPL-028) has 3 correct states but missing: per-entry FX rate (GAP-012, MVP-blocking), exclude toggle (GAP-013, MVP-blocking), Confirm-Received sheet, notification path, duplicate gesture, conservative FX display.

---

## 4. Microcopy Model

### Voice Attributes
Calm, Objective, Specific, Direct, Respectful, Bangla-aware. Six attributes, non-negotiable.

### Five Copy Archetypes
| Archetype | Format | Example |
|-----------|--------|---------|
| State statement | Subject + verb + number + context | "Safe-to-Spend is tk32,400 -- covers 17 days" |
| Action invitation | Verb-led + outcome stated | "Confirm received -> updates Safe-to-Spend" |
| Boundary statement | Direct statement + reason | "Helm does not move money." |
| Settlement copy | Past tense + value + invitation | "$800 settled at 119.66 -- added tk95,728" |
| Threat copy | Fact + math implication + action | "Rent tk18,000 due in 4 days. S2S after rent: tk14,400." |

### Permanent Ban List
"Oops!", "Hang in there!", "Don't worry!", "Looks like...", "Sorry, something went wrong", "Hi there!", "Awesome!", "Great job!", "Limited time offer", "Just one more thing...", all emoji in system copy, all exclamation marks.

### Show Your Work Pattern
S2S breakdown drawer mirrors spreadsheet formula bar:
```
Received usable BDT                    tk 78,500.00
Minus fixed commitments               (tk 24,000.00)
Minus tax reserve                      (tk  8,500.00)
Minus anxiety buffer                   (tk 10,000.00)
-------------------------------------------------
Safe to spend                          tk 36,000.00

Not counted yet
$ 600 pending from Payoneer . approx tk71,796.00
```
Every line tappable. Every line self-explains on tap. Values right-aligned mono. Labels in humanist sans.

### Number Formatting (Non-Negotiable)
- BDT: lakh/crore grouping (tk 1,32,400.00 not tk 132,400.00)
- USD: Western grouping ($1,800.00)
- Always two decimal places
- Currency symbol at half-weight of number
- Negative values in parentheses: (tk 4,200.00)
- BDT precedes USD vertically in dual-currency contexts
- Zero never used as placeholder for "unknown" -- use "---"

### Current Code Gap
Most UI text is hardcoded English (GAP-024). Copy conflicts with product identity (GAP-002, GAP-003). No lakh/crore formatting. Breakdown sheet uses generic labels.

---

## 5. Visual Identity Model

### Core Palette (Refined — overrides earlier system)
| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `canvas` | `#FAFAF6` | `#0E0E0C` | App background |
| `surface` | `#FFFFFC` | `#161614` | Cards, sheets |
| `ink.primary` | `#141413` | `#F2F1ED` | All money, critical text |
| `ink.secondary` | `#3B3A36` (solid) | TBD | Labels, timestamps, trust strip |
| `ink.tertiary` | `#6A6760` (solid) | TBD | Disabled, recessed only |
| `interactive` | `#255E5B` | `#3E807D` | All tappable affordances |
| `divider` | `#D8D3C8` | TBD | Card borders (~12% equiv) |
| `hairline` | `#E9E5DB` | TBD | Internal dividers |

### State Palette (Refined)
| State | Light | Usage |
|-------|-------|-------|
| `state.safe` | `#5F8569` | Ledger Rail, received dot |
| `state.tight` | `#A97833` | Ledger Rail, due 3-7 days |
| `state.atRisk` | `#984635` | Reserve Mode, urgent due |
| `state.hope` | `#5A7585` (solid for text) | Pending money text |
| `state.hopeMuted` | `#9BAAB2` | Expected dots, low-emphasis |

### Critical Rule: Solid Colors for Text
No `withOpacity()` on text colors. Alpha OK for decorative rails/markers only. Produces inconsistent results across surfaces.

### Typography
| Role | Font | Notes |
|------|------|-------|
| Financial numbers | JetBrains Mono Variable | Money and calculations ONLY |
| UI text (Latin) | Inter Variable | Labels, descriptions, all non-financial |
| Bangla text | Hind Siliguri | Locale-specific line heights (1.58 vs 1.50 for body) |

**Mono scope restriction:** Do NOT use mono for labels, descriptions, empty states, onboarding copy, error copy, button labels.

### Spacing
8pt grid. All margins/padding multiples of 8. S2S hero: 32pt above, 24pt below.

### Cards, Icons, Motion
- 5 card types: HeroZone, LedgerCard, AuditCard, SourceCard, CautionCard
- Phosphor Icons (outline, 1.5pt) + 6 custom icons (received-bdt, pending-usd, commitment, reserve-lock, audit-line, fx-estimate)
- No gradients, no shadows, no springs/bounces
- Breakdown drawer: 240ms ease-out + 24ms row stagger
- S2S appearance: 200ms linear fade only

### Current Code Gap
Colors (IMPL-032) use blue primary (#2453FF), orange secondary, Poppins font. Completely different from doctrine palette. Cards use shadows. No design system alignment.

---

## 6. Refined Visual Signatures (5 Ownable Assets)

### 6.1 Safe-to-Spend Ledger Rail
Replaces thin accent line. Recognizable Helm signature.
- Width: 72pt compact / 96pt regular
- Height: 3pt hero / 1.5pt elsewhere
- Radius: 2pt
- Always paired with text label: "Safe", "Tight", "Reserve Mode"
- Must appear anywhere S2S number appears
- **Widget:** `HelmLedgerRail`

### 6.2 Reality Stack
Four-layer money hierarchy replacing generic dashboard.
1. Safe to spend (highest weight, mono, ink.primary)
2. Already committed (medium, ink.primary + risk marker)
3. Reserve protected (medium-low, ink.secondary)
4. Not counted yet (recessed, state.hope, separated)
- **Widget:** `HelmRealityStack`

### 6.3 Trust Strip
Mandatory on every financially meaningful surface.
Format: `Updated 11:42 PM . Received only . FX tk119.66 . Tap to audit`
- Font: label.sm, color: ink.secondary
- Required on: S2S hero, pipeline totals, FX amounts, reserves, exports
- **Widget:** `HelmTrustStrip`

### 6.4 Calculation Trace
Auditable math drawer. Values right-aligned mono. Labels plain language. Stronger divider before total. "Pending not counted" as recessed block below.
- **Widget:** `HelmCalculationTrace`

### 6.5 BDT-First Money Stamp
BDT first and larger. USD second and smaller. FX rate always shown. Estimated labeled as estimated.
- **Widget:** `HelmFxEstimate` + `HelmMoneySourceLabel`

---

## 7. Real vs Hopeful Money Test

Before shipping any screen, verify all 7:

1. Can user instantly tell which money is usable today?
2. Can user instantly tell which money is pending/uncertain?
3. Can user see why S2S number changed?
4. Can user audit calculation without hunting?
5. Does BDT feel more grounded than USD?
6. Does screen avoid generic finance-app patterns?
7. Does design reduce anxiety without hiding risk?

**Any "no" = screen fails review.**

---

## 8. Bangladesh Android-First Contrast Rules

### Context
Users operate on: budget/midrange Android, outdoor/high brightness, screen protectors, variable display quality, low-light at night, under stress/fatigue.

### Rules
1. No trust-critical divider below 12% contrast equivalent
2. Card borders use `divider` token (#D8D3C8), not hairline
3. State colors deepened from earlier spec for budget screen visibility
4. All text uses solid resolved colors, not alpha
5. S2S state signal is 3pt Ledger Rail, not 1pt line
6. Hope tier uses solid color (#5A7585) for text readability
7. WCAG AAA on S2S number, AA on all body text
8. Touch targets minimum 44pt x 44pt everywhere
9. Bangla line heights tested separately (1.58 vs 1.50 for body)
10. Test on Redmi Note series with screen protector, not just WCAG calculator

### The Governing Rule
> "Helm can be quiet, but it cannot be faint."

---

## 9. Source/Timestamp/Calculation Trust Model

### Trust is Active, Not Passive
Earlier system: "trust me because I look calm" (absence of bad patterns).
Refined system: "trust me because every number has a source, a timestamp, and an explanation."

### Three Trust Mechanisms
1. **Trust Strip** — Every financial surface shows: when updated, what's included, what FX rate, how to audit
2. **Calculation Trace** — Every S2S number opens to full math. Every line tappable. Every line self-explains.
3. **Source Labels** — Money origin visible: Payoneer, Wise, Bank, bKash, Nagad, Upay, Cash, Manual. As low-emphasis text, not brand logos.

### Trust Rules
- Every key number has source + timestamp + calculation path
- Pending money visibly lower hierarchy than usable BDT
- Every dual-currency conversion reveals FX rate and estimate status
- Conservative FX default; optimistic one tap away
- S2S is pure function (computed, never stored)
- "---" on calc failure, never a wrong number
- Event sourcing for all financial inputs (append-only audit log)
- Integer paisa storage internally (no floats for money)

---

## 10. Conflicts Found and Resolved

### Conflict 1: Accent Line vs Ledger Rail
- **Earlier VI System:** 1-1.5pt accent line under S2S
- **Refined VI Critique:** 3pt Ledger Rail
- **Resolution:** Ledger Rail wins. Earlier accent line is overridden. Source: VISR-004.

### Conflict 2: Chronometer vs Cashflow Ledger Metaphor
- **Earlier VI System / UX Doctrine:** "clinical instrument / chronometer"
- **Refined VI Critique:** "calm Bangladeshi cashflow ledger"
- **Resolution:** Cashflow ledger wins. Earlier metaphor too cold/foreign. Source: VISR-001.

### Conflict 3: Alpha-Based vs Solid Text Colors
- **Earlier VI System:** ink.secondary = #141413 @ 60%, ink.tertiary = #141413 @ 38%
- **Refined VI Critique:** ink.secondary = #3B3A36, ink.tertiary = #6A6760 (solid)
- **Resolution:** Solid colors win. Alpha inconsistent across surfaces. Source: VISR-009.

### Conflict 4: Dashboard Layout Model
- **Earlier Dashboard Redesign:** Greeting > S2S > Threat tier > Hope tier
- **Tier-1 Critique v2 / Refined VI:** Trust timestamp > S2S + Ledger Rail > Reality Stack (committed/reserve/not counted)
- **Resolution:** Reality Stack wins. Source: VISR-016, DASH critique v2.

### Conflict 5: Tax Reserve in MVP
- **Final Doctrine:** Tax reserve explicitly V2 ("tax ambiguity = trust bomb")
- **Current code:** Tax reserve implemented with 10% default slider
- **Resolution:** Doctrine wins. Tax reserve should be removed from MVP S2S calculation or clearly labeled as user-declared reserve (not tax advice). Acknowledged deviation documented in DOCTRINE_TO_CODE_GAP_ANALYSIS.md.

### Conflict 6: Onboarding Steps Count
- **UX Doctrine S5:** 5 steps (qualifying, balance, fixed costs, income pattern, buffer)
- **Onboarding Redesign:** 7 screens (adds optional first pipeline entry + PIN gate)
- **Pipeline Interaction Optimization:** 7 screens (same as Onboarding Redesign)
- **Resolution:** 7 screens wins (Onboarding Redesign is onboarding authority + Pipeline Optimization authority). UX Doctrine's 5 core data steps + PIN gate + optional pipeline entry = 7.

### Conflict 7: Card Border Treatment
- **Earlier VI System:** 1pt divider at 8% ink opacity
- **Refined VI Critique:** Structural divider at #D8D3C8 (~12% equivalent) for cards, hairline at #E9E5DB for internal
- **Resolution:** Refined treatment wins. 8% invisible on budget Android. Source: VISR-010.

---

## 11. Required New Widgets

| Widget | Purpose | Replaces |
|--------|---------|----------|
| `HelmLedgerRail` | S2S state indicator (3pt rail + label) | Current accent line concept |
| `HelmTrustStrip` | Timestamp + source + FX + audit link | Nothing (new requirement) |
| `HelmRealityStack` | 4-layer money hierarchy for home screen | Current dashboard layout |
| `HelmCalculationTrace` | Auditable math drawer with stagger | Current breakdown bottom sheet |
| `HelmMoneySourceLabel` | Payoneer/bank/bKash/etc source labels | Nothing (new requirement) |
| `HelmFxEstimate` | FX rate + estimate status display | Nothing (new requirement) |
| `HelmAmount` | Financial amount with proper formatting | Current inline number formatting |
| `HelmHeroZone` | S2S hero container (no visible card) | Current SafeToSpendHero |
| `HelmLedgerCard` | Standard money fact card (1pt border, 12r) | Current card patterns |
| `HelmAuditCard` | Calculation trace card (stronger top rule) | Nothing (new) |
| `HelmSourceCard` | Compact source + status card | Nothing (new) |
| `HelmCautionCard` | AtRisk rail on left, no red fill | Nothing (new) |
| `HelmToast` | Financial-safe snackbar replacement | Current SnackBar usage |

---

## 12. Implementation Lint Rules

1. No `withOpacity()` on text colors
2. No "Balance / Income / Expense" summary card above fold
3. No financial amount without `HelmAmount` widget
4. No S2S value without `HelmLedgerRail`
5. No dual-currency amount without `HelmFxEstimate`
6. No pending amount in same visual group as liquid BDT unless labeled
7. No generic `SnackBar` -- use `HelmToast`
8. No gradients (LinearGradient, RadialGradient)
9. No BoxShadow or elevation > 0 on cards
10. No fontStyle: FontStyle.italic
11. No exclamation marks in system strings
12. No emoji in localization files (except state indicators)

---

## 13. Notification Model

### Two Classes Only
- **Transactional:** Triggered by state change in user's data
- **Boundary:** Triggered by mathematical proximity to financial harm
- No other class exists. Type system enforces this.

### Constraints
- Quiet hours: 10pm-8am local
- Max 2/day
- <= 140 characters
- Must contain specific BDT/USD number
- Must state implication
- Exactly one tappable action
- No exclamation marks, no emoji

### Killed Notification Types
"We miss you", "Time to update", "You saved X", cross-sell, "New feature", holidays, tips, streaks, marketing. Permanently.

---

## 14. Empty/Error/Reserve States

### Empty States
Typography-only. Must teach the mental model, not merely announce absence. Every empty state explains: what's empty, what to add and why, how it relates to S2S.

### Error States
- S2S calc failure: show "---", never a wrong number. Most important error pattern.
- Sync errors: non-blocking. "Last sync X hours ago. You can still use Helm offline."
- Validation: conversation, not rejection. "FX rate 18% above average. Are you sure?"
- Never "Something went wrong" without specifying what.
- Never lose user input on error.

### Reserve Mode
Activates when: liquid BDT < buffer, or S2S negative without buffer, or no pipeline + < 10 days runway.
- Home becomes runway UI (not panic UI)
- No feature promotions, no paywalls
- Tone: extra-clinical (not warm -- empathy reads as pity)
- Silent exit when conditions clear (no celebration)

---

## 15. MVP-Blocking Code Gaps

Per codebase audit, 8 gaps must resolve before MVP:

| # | Gap | Current State | Required |
|---|-----|---------------|----------|
| 1 | GAP-001 | Onboarding is motivational carousel | 7-screen conversational flow |
| 2 | GAP-009 | Buffer is absolute BDT amount | Percentage-based (15% default, 5-30%) |
| 3 | GAP-012 | No per-entry FX rate | FX rate field on income model |
| 4 | GAP-013 | No exclude-entry toggle | Exclude flag on income model |
| 5 | GAP-015 | No auth system | Magic Link + PIN/biometric |
| 6 | GAP-016 | No audit log | Append-only event log |
| 7 | GAP-017 | No CSV export | Data export functionality |
| 8 | GAP-018 | No account deletion | Full data purge flow |

---

## 16. Acceptance Criteria Summary

### The Bangladeshi Freelancer Test (Final Gate)
Would a Bangladeshi freelancer at 11pm on Day 29, anxious about rent due Day 5:
- Find this screen useful?
- Trust the number enough to act on it?
- Feel respected as an adult professional?

**Any "no" = not ready to ship.**

### Performance Gates
- Time-to-S2S-visible: P95 < 2,000ms
- Cold start to first frame: P95 < 800ms
- S2S calculation time: P95 < 50ms
- Breakdown drawer: 240ms +/- 20ms

### Closed Beta Validation Gates
- Override-equivalent rate < 15% (users rarely override S2S)
- Pipeline update compliance >= 85%
- 14-day retention >= 60%
- Session < 90s median

---

*End of Canonical UX Implementation Spec. All implementation work references this document.*
