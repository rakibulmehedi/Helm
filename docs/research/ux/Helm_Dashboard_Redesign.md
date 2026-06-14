# Helm Dashboard Redesign

> **Status:** Doctrine-aligned redesign of the current home screen.
> **Posture:** Adversarial-mentor. Built directly against the Final Product Doctrine and UX Doctrine. Every choice below is a constraint, not a suggestion.
> **Verdict on current screen:** Not a redesign target — a *replacement* target. The existing dashboard is a generic expense tracker with Helm's name on it. The product thesis (Safe-to-Spend cockpit) does not appear anywhere on the home screen, and "In reserve mode · BDT 0.00" is a *wrong number*, which violates the most important Trust Layer in the entire product. Doctrine §10.1 + §10.3 are unambiguous: on calc failure, the answer is "—", never zero.

---

## 1. Dashboard Goal

### One-sentence goal

> **The home screen exists to answer one question in under two seconds: "How much BDT is actually safe to spend right now?" — with the math one tap away.**

### What it is NOT

| Mistaken framing | Why it's wrong |
|---|---|
| A summary of income vs expenses this month | TallyKhata's job. Helm does not look backward. |
| A dashboard of recent transactions | Looking backward. Backward is History tab. |
| A "financial health" overview | Health scores are killed (Doctrine §12). |
| A net-worth screen aggregating USD + BDT | Mental accounting violation (UX Doctrine §2 P2). |
| A reminders/notifications inbox | Engagement theater (Doctrine §9). |

### The contract the screen must honor

| Contract | Source |
|---|---|
| Loads to S2S visible in < 2 seconds on 3G + low-end Android | UX §4.1, §14 Impl. 7 |
| Shows exactly one hero number — the S2S | UX §3 (Tier 1) |
| Computes S2S; never stores it | Final §10 Trust Layer 2 |
| On calc failure → "—", never a wrong number | Final §10 + UX §10 |
| Respects 9-line rule above the fold | UX §8 (density discipline) |

---

## 2. First 2-Second Attention Path

The Bangladeshi freelancer who opens Helm at a checkout counter has **~1.5 seconds of cognitive bandwidth**. The visual hierarchy must do the thinking for them.

### The intended eye path (in order, by milliseconds)

| Time | Where the eye lands | What it learns |
|---|---|---|
| 0–200ms | Skeleton in the position of the hero number | "The answer is loading here." |
| 200–600ms | Greeting + "Updated X min ago" timestamp | "I'm in Helm. The number is fresh." |
| 600–1,200ms | The S2S number itself (largest element) | "৳ 32,400 is safe to spend." |
| 1,200–1,600ms | The runway sub-line ("covers 17 days...") | "...for about 17 days." |
| 1,600–2,000ms | Accent line color (Safe / Tight / At Risk) | Confirms emotional state. |
| 2,000ms+ (optional) | Threat tier (next 3 obligations) | "These are pressing." |
| 2,500ms+ (optional) | Hope tier (pending USD) | "And this is on the way." |

### What the path enforces

1. **The hero number is the largest typographic element on the entire screen** — no exception. Hero font size ~64pt on a standard 6.1" device.
2. **Nothing competes with it.** No card with equivalent visual weight (the current Income/Expense tiles do exactly this and must die).
3. **Color does not steal attention from typography.** The hero number is rendered in primary ink (near-black on light / near-white on dark). State is conveyed by a thin accent line *below* the number, not by tinting the number itself.
4. **The number appears fully formed, with a 200ms fade-in.** No counter rolling up (slot-machine pattern, killed).

### Anti-attention path (what the current screen does, and must stop)

Current screen draws the eye in this order:
1. Orange "BDT 0.00" hero (which is a wrong number — see §13)
2. Two equally-weighted Income/Expense tiles (mental accounting violation)
3. Income Pipeline card (three states, all in BDT, which inverts the USD-first reality)
4. Recent Transactions feed (the wrong tier of product entirely)

None of those land on "is it safe to spend right now?" The current screen answers "what happened" — Helm is supposed to answer "what's possible."

---

## 3. Information Architecture

### The Three-Tier Cognitive Stack (mandatory)

This is canon from UX §3. Every other architectural choice flows from it.

| Tier | What it shows | Vertical canvas | Visual weight | Why it's here |
|---|---|---|---|---|
| **Tier 1 — THE ANSWER** | Safe-to-Spend (BDT, monospace, ~64pt) + state accent + runway sub-line + last-update timestamp | ~40% | Dominant | This is the entire product. Everything else is supporting evidence. |
| **Tier 2 — THE THREAT** | Next 3 upcoming fixed-cost obligations with days-to-due | ~25% | Secondary | These are imminent — the user's anxiety is already on them. |
| **Tier 3 — THE HOPE** | Pending USD pipeline (count, total, ETA window) | ~15–20% | Recessive | Future, uncertain. Should not pretend to be liquid. |
| Whitespace + minimal nav | — | ~15–20% | Invisible | Breathing room. Calm. |

### Why the order is fixed: Present → Threat → Hope

The temporal hierarchy mirrors how anxiety actually moves through the freelancer's mind:

- **Present** dominates because the question is *now*.
- **Threat** sits second because deadlines apply pressure on the present.
- **Hope** is demoted because pending USD is *not yet real money* and pretending it is causes the exact overspend behavior Helm exists to prevent.

The current dashboard inverts this: it puts a (wrong) hero number first, then aggregates from the past (Income/Expense), then shows pipeline as if it's spendable (BDT 100 "Pending"). That is the failure-mode tour in reverse.

### What never appears on Tier 1 (canon)

- Aggregate "net worth" combining USD + BDT
- Income / Expense aggregate tiles
- Pie or line charts
- Health scores, financial scores, ratings
- Promotional banners or upgrade prompts
- A notifications inbox or "what's new"
- Avatars, profile photos, mascots

---

## 4. Section Order (top to bottom)

```
┌──────────────────────────────────────────────────┐
│ 1. Top bar (wordmark left · refresh icon right)  │  ~6%
├──────────────────────────────────────────────────┤
│ 2. Greeting + freshness line                     │  ~4%
│    "Good evening, Mehedi"                        │
│    "Updated 2 min ago"                           │
├──────────────────────────────────────────────────┤
│                                                  │
│ 3. SAFE-TO-SPEND HERO (Tier 1)                   │  ~36%
│    ৳ 32,400.00                                   │
│    Safe to spend                                 │
│    ──────                                        │
│    "covers 17 days at your usual pace"           │
│                                                  │
├──────────────────────────────────────────────────┤
│ 4. THREAT TIER (next 3 fixed obligations)        │  ~22%
│    ↳ Internet bill   ৳ 1,500    in 2 days   ●    │
│    ↳ Rent            ৳18,000    in 6 days   ●    │
│    ↳ Adobe sub.      ৳ 2,400    in 11 days  ○    │
├──────────────────────────────────────────────────┤
│ 5. HOPE TIER (pending USD pipeline)              │  ~14%
│    Pending pipeline                              │
│    $1,800 across 2 invoices                      │
│    expected by ~Nov 18                           │
├──────────────────────────────────────────────────┤
│ 6. Whitespace                                    │  ~10%
├──────────────────────────────────────────────────┤
│ 7. Bottom nav: Home · Pipeline · History · You   │  ~8%
└──────────────────────────────────────────────────┘
            [FAB · Add pipeline entry]
```

**Note:** There is **no** Income/Expense card. **No** Income Pipeline card with three buckets. **No** Recent Transactions feed. Those go to other surfaces (see §13 and §8).

---

## 5. Safe-to-Spend Hero Design

### What

The single largest typographic element on the screen, rendered as:

```
       ৳ 32,400.00
       Safe to spend
       ──────────────
       covers 17 days at your usual pace
```

### Why

This is the entire product. The Doctrine is unambiguous (Final §1, UX §1, UX §3.3): every other element on the screen is supporting evidence for this one number. If the user reads nothing else, they have already received the value.

### How (specifications)

| Element | Specification |
|---|---|
| Number font | Monospaced numeric (JetBrains Mono Variable or IBM Plex Mono) |
| Number size | ~64pt on a 6.1" device |
| Number color | Primary ink (near-black light / off-white dark). **Never tinted by state.** |
| Currency symbol (৳) | Half-weight of the number. It labels, doesn't compete. |
| Decimals | Always shown — ৳ 32,400.00 (precision is a trust signal) |
| Number formatting | Bangladeshi lakh/crore convention — ৳ 1,32,400.00 not ৳ 132,400.00 |
| Label "Safe to spend" | Sentence case. Inter / Geist. ~14pt. Secondary ink at 60% opacity. |
| Accent line | A single 2pt-tall, 64pt-wide line below the label. Color = state (Safe / Tight / At Risk). |
| Runway sub-line | ~13pt, secondary ink. Format: *"covers N days at your usual pace"* |
| Vertical breathing room | 32pt above the hero, 24pt below before the Threat tier |
| Animation | None on the number itself. 200ms fade-in on initial load. No pulse, no shimmer, no counter. Sacred things do not wiggle. |
| Tap behavior | Opens Calculation Breakdown drawer (240ms slide-up) |
| Long-press behavior | Forced refresh (recalculate) |

### State accent line colors (UX §4.3, §8 color system)

| State | Accent color | Triggered when |
|---|---|---|
| Safe | Desaturated sage green `#6B8F71` | Liquid BDT comfortably covers all obligations + buffer |
| Tight | Muted amber `#B88A4A` | Liquid BDT covers obligations but eats into buffer |
| At Risk | Muted brick red `#9E4A3A` | Liquid BDT insufficient for an obligation due ≤7 days |

### Where it lives

The hero block occupies ~36% of the visible canvas (above the fold). Below the greeting/freshness line, above the Threat tier. Always centered horizontally. No card boundary, no shadow, no gradient — it sits directly on canvas.

### The "—" fallback (critical)

If S2S cannot be computed (missing FX rate, stale data, contradictory inputs), the hero renders:

```
            —
       Safe to spend
       ──────
       Some inputs need attention. Tap to review.
```

This is the **single most important error state in the entire product** (Doctrine §10 + UX §10.1). Better one hour of "—" than one second of a wrong number. The current screen's "BDT 0.00" violates this rule.

---

## 6. Pipeline Summary Design (Hope Tier)

### What

A single-block summary of pending USD pipeline. **Recessive**, not prominent. Visually demoted from the hero.

```
Pending pipeline
$1,800 across 2 invoices
expected by ~Nov 18  ›
```

### Why

Pending USD is **not safe to spend** (Doctrine §3, UX §2 P2). Treating it visually as if it is *causes the exact overspend behavior Helm exists to prevent.* The Hope tier exists so the user knows pipeline exists, but its visual weight states clearly: *this is not yet real.*

This is the inversion of the current screen's "Income Pipeline" card, which shows three buckets in BDT with the same visual weight as Tier 1 — treating future capital as equivalent to present capital. Mental accounting violation.

### How (specifications)

| Element | Specification |
|---|---|
| Label "Pending pipeline" | 12pt, secondary ink at 60% opacity |
| USD total | 16pt, primary ink, monospace |
| Count "across N invoices" | 13pt, secondary ink |
| ETA line | "expected by ~Nov 18" — 12pt, secondary ink. The "~" softens the certainty. |
| Color | Cool desaturated blue `#5A7A8C` at 40% opacity — Hope-tier accent only |
| BDT-equivalent | **Not shown on home.** Available one tap below on the Pipeline tab as conservative ৳ amount + "live rate would give..." |
| Tap behavior | Navigates to Pipeline tab |

### What the Hope tier never does

- Never shows pending USD as if it's BDT-equivalent at home (only on Pipeline tab, conservative rate, with optimistic shown demoted).
- Never adds pending USD to the hero number. They are visually severed (UX §2 P2).
- Never shows count of "Expected" + "Pending" as separate buckets on home. Home shows one summary line; the breakdown lives one layer below.
- Never uses urgent language ("$1,800 incoming!", "Almost there!"). Hope is recessive, not exciting.

### Pipeline state nomenclature (correction)

The current screen uses **Received / Pending / Expected** but the Doctrine defines the states as:

| State (canonical) | Meaning |
|---|---|
| **Expected** | Invoice sent, not yet acknowledged |
| **Pending** | Acknowledged or in transit (e.g., Upwork → Payoneer) |
| **Received** | Funds in liquid wallet, counts toward S2S |

The current screen's order (Received → Pending → Expected with BDT values) is backwards and shows "Received: BDT 0.00" — a confusing dead column that adds nothing.

---

## 7. Fixed Cost / Pressure Design (Threat Tier)

### What

A list of the next **three** upcoming fixed-cost obligations, sorted by due date ascending.

```
↳ Internet bill         ৳ 1,500       in 2 days    ●
↳ Rent                  ৳18,000       in 6 days    ●
↳ Adobe subscription    ৳ 2,400       in 11 days   ○
```

### Why

The freelancer's anxiety is already on these. By surfacing them at Tier 2, Helm *closes the cognitive loop* (UX §2 P4 — Zeigarnik antidote) instead of leaving the user to mentally track them. This is the calm-cockpit move.

It also gives mathematical context to the S2S hero: when the user sees ৳ 32,400 + the threat tier showing ৳21,900 of obligations in ≤11 days, they understand *why* the number is what it is without opening the breakdown drawer.

### How (specifications)

| Element | Specification |
|---|---|
| Max items shown | 3 (more bleeds into "View all" navigation to Settings → Fixed Costs) |
| Row height | 44pt (accessible touch target) |
| Item label | 14pt, primary ink |
| Amount | 14pt, monospace, primary ink, right-aligned |
| Days-to-due | 13pt, secondary ink |
| Proximity dot | ● filled = ≤7 days · ◐ half = 8–14 days · ○ outline = 15–30 days |
| Color | All neutral. **No row is tinted red.** Tier 1's accent line carries the alarm — Tier 2 carries the facts. |
| Tap row | Opens edit sheet: amount, day-of-month, exclude flag, mark paid this cycle |
| Long-press row | Quick "mark paid this cycle" |

### Critical: the Threat tier is not an alarm

The current dashboard has nothing in this tier. When it's added, the temptation will be to make it red/loud/scary. **Resist.** The dots are enough. The accent line at Tier 1 is where alarm lives. Tier 2 is *information*, not *alarm*.

### Empty Threat tier

If there are no fixed costs in the next 30 days:

```
No fixed costs in the next 30 days.
Add a recurring bill?  ›
```

No alarm. No "Add some bills!" energy. A quiet invitation if relevant.

---

## 8. Recent Activity Design

### Verdict: Remove from the home screen entirely.

This is the most disagreement-likely section of this redesign, so the rationale is explicit.

### Why removed

1. **Doctrine forbids it.** UX §3 lists Tier 1 / 2 / 3 — there is no "Tier 4 — Recent activity." Adding a transactions feed on home directly violates the 9-line rule (UX §8).
2. **It's a TallyKhata pattern.** Generic expense apps put a transactions feed on home because they answer "what happened?" Helm answers "what's possible?" — a different cognitive direction.
3. **It dilutes the cockpit.** The eye path described in §2 ends at the Hope tier. A transactions feed below adds 200–800ms of "should I read this?" cognition for zero S2S value.
4. **It looks-backward when the product looks-forward.** Helm's wedge is the forward-looking pipeline → S2S cascade (Final §1). Recent activity is the past. The past lives in the History tab.

### Where it goes instead

A dedicated **History tab** in the bottom nav (Home · Pipeline · History · You). The History tab is the right home for:

- Confirmed received pipeline entries
- Paid fixed costs (audit log of "this bill was paid on Oct 28")
- Manual income additions
- All edits with audit log

### What to do with the "recent transactions" data currently displayed

The two entries in the screenshot ("Salman -BDT 15,000" and "Meth -BDT 50…") appear to be manual expenses. **Manual expense logging is a category check** — is this Helm or TallyKhata?

- If these are *fixed cost payments* (paid rent, paid internet) → they belong in the Threat tier history, accessible by tapping a fixed-cost row.
- If these are *arbitrary daily expenses* (groceries, transport) → **this feature should be killed.** The Permanent Kill List (Final §8) explicitly removes "generic expense categorization" — TallyKhata territory. Helm is not an expense tracker; it is a cashflow cockpit.

This is a Doctrine drift to address in the data model, not on the dashboard.

---

## 9. Interaction Model

### Gesture / surface mapping

| Surface | Gesture | Outcome |
|---|---|---|
| Hero S2S number | Tap | Calculation Breakdown drawer slides up over 240ms |
| Hero S2S number | Long-press | Forced refresh — recalculate from latest inputs |
| Hero runway sub-line | Tap | Same as hero tap — opens breakdown drawer |
| Threat tier row | Tap | Edit sheet for that fixed cost |
| Threat tier row | Long-press | Quick "mark paid this cycle" |
| Hope tier block | Tap | Navigate to Pipeline tab |
| Greeting / freshness line | Tap | No action — it's a label |
| Refresh icon (top-right) | Tap | Same as long-press hero — forced refresh, with subtle spinner replacing icon |
| Home screen | Pull-down | Pull-to-refresh + last sync timestamp visible while pulling |
| FAB (bottom-right) | Tap | Add Pipeline Entry sheet (NOT a generic "add transaction") |

### The Calculation Breakdown drawer (tap S2S)

This is the **single most important interaction in the home screen** (UX §7 "show your work" pattern). Slides up over 240ms, dismissible by swipe-down or tap-outside.

```
Safe-to-Spend calculation             [as of 2 min ago]

  Liquid BDT                              ৳ 52,400.00
+ Pending USD (conservative)              ৳      0.00   excluded ›
- Fixed costs (next 30 days)              ৳ 14,280.00   3 items ›
- Safety buffer (15%)                     ৳  5,720.00   adjust ›
- Tax reserve (V2)                        ৳      0.00
─────────────────────────────────────────────────────────
  Safe-to-Spend                           ৳ 32,400.00

Every line tappable. Every line explains itself on tap.
```

Each row tapped opens its respective edit affordance:
- *Liquid BDT* → reconcile balances modal (V1+)
- *Pending USD* → Pipeline tab
- *Fixed costs* → fixed-cost list with inline edit
- *Safety buffer* → buffer slider 5%–30% with live BDT preview

### What no gesture does

- **No gesture overrides the S2S number.** The user cannot drag, edit, or "set" the result. They edit *inputs*. (UX §2 P3, Final §10 Trust Layer 3.)
- **No swipe on the hero.** Pinch, swipe-left, swipe-right do nothing on the hero. The number is sacred.
- **No double-tap.** Double-tap is reserved for nothing — adding it would compete with single-tap.

### Persistent FAB

The Add Pipeline Entry button is the **only proactive affordance on home** (UX §4.7).

- Position: bottom-right, 16pt from edges
- Color: deep teal `#2C5F5D` (single interactive accent)
- Icon: `+` outline, 1.5pt stroke
- Tap: opens Add Pipeline Entry sheet (USD amount, client, expected date, FX rate with sanity check)

**Not** "Add transaction." **Not** "Quick action menu." One purpose, one tap.

---

## 10. Empty States

### Fresh install (post-onboarding, no pipeline yet)

The S2S works without pipeline — it computes from liquid balance and fixed costs alone.

```
Good evening, Mehedi
Updated just now

           ৳ 18,400.00
           Safe to spend
           ──────
           covers 14 days at your usual pace

[ Threat tier — populated from onboarding-declared fixed costs ]

Pending pipeline
Add your first expected payment to forecast further  ›
```

Key choice: **the hero works on Day 1.** No "complete setup to see your number." S2S is never gated.

### No fixed costs configured

```
[ Hero — populated normally ]

No fixed costs in the next 30 days.
Add a recurring bill?  ›

Pending pipeline
$1,800 across 2 invoices · expected by ~Nov 18
```

### No pending pipeline (the Trough — between contracts)

This is the high-anxiety moment. Doctrine §10 + §11 are explicit: **pivot to runway emphasis, never panic.**

```
Good evening, Mehedi
Updated 4 min ago

           ৳ 18,400.00
           Safe to spend
           ──────
           covers 14 days at your usual pace

[ Threat tier — unchanged ]

Pending pipeline
No pending pipeline right now.
Add expected payments as work comes in.  ›
```

**Never** show "৳0 expected income" with alarm framing. Truth without alarm.

### All fixed costs paid for the cycle

```
[ Hero — populated normally ]

All this month's fixed costs are paid.
Next: Rent on the 1st  ›

Pending pipeline
$1,800 across 2 invoices · expected by ~Nov 18
```

### First-ever app open (PIN set, no data)

```
Good evening, Mehedi
Updated just now

           —
           Safe to spend
           ──────
           Add your liquid balance to see your first number.  ›

[ Tier 2 and Tier 3 — replaced with single line: ]
Helm needs three things to begin:
  1. Your current BDT balance  ›
  2. Your monthly fixed costs  ›
  3. Your first expected payment (optional)  ›
```

Note: "—" is correct here. Showing ৳ 0.00 as the S2S during cold-start would be the same trust failure as the current screen.

---

## 11. Error / Fallback States

### Category 1 — Calculation failure (S2S cannot be safely computed)

Triggered by: missing FX rate on a pending entry, stale input, contradictory inputs.

```
           —
           Safe to spend
           ──────
           Some inputs need attention. Tap to review.
```

The "—" is rendered in the same monospace font, same size, same color. The dash is the answer.

Tap → opens a focused list: *"These entries need attention before Safe-to-Spend can be computed:"* with each problematic entry and a one-tap fix.

**Never** show "BDT 0.00" on calc failure. The current dashboard does this. **It's a trust bomb.**

### Category 2 — Sync / connectivity error

```
[ Hero — last known computed value, marked as "as of 4 hours ago" ]

Last sync 4 hours ago. Tap to refresh.
You can still use Helm offline.
```

Helm is offline-tolerant. Local edits queue and sync on reconnection. The user *never* sees "no internet" as a blocker. (UX §14 Impl. 9.)

### Category 3 — Input validation error (e.g., FX rate way off the 90-day average)

Modal, not a home-screen surface:

```
FX rate of 140.00 is 18% above the 90-day average of 118.50.
Are you sure?
[ Adjust ]   [ Confirm anyway ]
```

Validation is a conversation, not a rejection (UX §10 Cat 3).

### Category 4 — Reserve Mode (this is the state the current dashboard botched)

Reserve Mode is **not** an error state. It is an automatic UI mode entered when liquid BDT drops below the safety buffer OR runway < 10 days with no pipeline (UX §11).

```
Good evening, Mehedi
Reserve mode is on · Updated 2 min ago

           ৳ 5,400.00
           Liquid BDT remaining
           ──────
           covers 6 days at minimum-essentials pace
                                          [muted brick red accent]

The Path
↳ Internet bill — ৳ 1,500 in 2 days — covered
↳ Rent — ৳18,000 in 6 days — short by ৳14,100
↳ Adobe subscription — ৳ 2,400 in 11 days — short by ৳18,500

[ View suggested actions ]
```

**Critical differences from how the current dashboard renders Reserve Mode:**

| Current dashboard (wrong) | Doctrine-correct |
|---|---|
| Hero label: "In reserve mode" + "BDT 0.00" | Hero label: "Liquid BDT remaining" + actual remaining BDT |
| Hero color: orange tint on number | Hero number: primary ink. Brick-red accent line only. |
| Below hero: Income/Expense + Income Pipeline | Below hero: "The Path" block — concrete obligations + suggested actions |
| No runway in days | "covers N days at minimum-essentials pace" |
| Generic icons | None — no decoration in Reserve Mode |

### What error states never do (canon, from UX §10)

- Show "Something went wrong" without specifying what
- Show stack traces or error codes
- Default to "Try again later" without an alternative
- Lose user-entered input on modal error
- Make the user feel they broke something
- Show ৳ 0.00 when the correct answer is "—"

---

## 12. Mobile Layout Wireframe Description

Reference device: 6.1" Android (Samsung A14 class, ~412 × 915 logical px). 8pt grid throughout.

### Above the fold (the 9-line rule applies — UX §8)

```
┌──────────────────────────────────────────────────────────┐
│  status bar                                              │  44pt
├──────────────────────────────────────────────────────────┤
│  Helm                                          ↻      │  56pt
│  ─────────────────────────────────────────────────────── │
│                                                          │
│  Good evening, Mehedi                                    │  36pt
│  Updated 2 min ago                                       │
│                                                          │
│                                                          │  ↕ 32pt
│                                                          │
│                     ৳ 32,400.00                          │  72pt
│                                                          │
│                     Safe to spend                        │  20pt
│                                                          │
│                     ──────                               │  6pt accent
│                                                          │
│                     covers 17 days                       │  20pt
│                     at your usual pace                   │
│                                                          │
│                                                          │  ↕ 24pt
│  ─────────────────────────────────────────────────────── │
│                                                          │
│  ↳ Internet bill         ৳ 1,500    in 2 days     ●      │  44pt
│  ↳ Rent                  ৳18,000    in 6 days     ●      │  44pt
│  ↳ Adobe subscription    ৳ 2,400    in 11 days    ○      │  44pt
│                                                          │
│  ─────────────────────────────────────────────────────── │
│                                                          │
│  Pending pipeline                                        │  16pt
│  $1,800 across 2 invoices                                │  20pt
│  expected by ~Nov 18                                ›    │  18pt
│                                                          │
└──────────────────────────────────────────────────────────┘
                                                  ┌─────┐
                                                  │  +  │  56pt FAB
                                                  └─────┘
┌──────────────────────────────────────────────────────────┐
│   Home    Pipeline    History    You                     │  64pt nav
└──────────────────────────────────────────────────────────┘
```

### Density verification

Lines of content above the fold (excluding system chrome and nav):

1. Helm wordmark
2. "Good evening, Mehedi"
3. "Updated 2 min ago"
4. ৳ 32,400.00 (counts as one visual line — dominant)
5. "Safe to spend"
6. "covers 17 days at your usual pace"
7. Threat row 1 (Internet)
8. Threat row 2 (Rent)
9. Threat row 3 (Adobe)

→ **9 lines exactly.** The 9-line rule (UX §8 + §14 Impl. 12) is satisfied. The Hope tier sits at the fold boundary or just below — visible on most devices, scrollable on smaller ones.

### Dark mode

Identical layout. Canvas `#0E0E0C`. Primary ink `#F5F5F0`. Accent colors unchanged (they're already muted enough for dark surfaces). No manual toggle — follows system.

### Bangla layout consideration

Bangla text typically renders 8–12% taller than Latin at the same point size. Reserve vertical padding accordingly. Number formatting must use Bangladeshi lakh/crore convention (৳ 1,32,400.00 not ৳ 132,400.00) — this is non-negotiable cultural correctness (UX §8 typography).

---

## 13. What To Remove From Current Dashboard

Ranked by severity of Doctrine violation.

### Kill list (in order)

| # | Element | Doctrine violation | Replacement |
|---|---|---|---|
| 1 | **"In reserve mode · BDT 0.00" as hero** | Wrong number on calc failure (Trust Layer 2). Reserve Mode hero should show *liquid BDT remaining* not zero. | Either Safe-to-Spend hero (normal mode) or Reserve Mode hero showing remaining liquid BDT + runway days |
| 2 | **Orange tint on the hero number** | Number is tinted by state, but Doctrine §3 says number is always primary ink; state lives in the accent line only | Black/off-white number with thin accent line below |
| 3 | **Income / Expense aggregate tiles (BDT 22,366 / BDT 15,500)** | Mental accounting violation (P2). Aggregates without S2S context. Looks-backward. TallyKhata pattern. | Removed entirely. Income lives in Pipeline tab; outgoing lives in fixed-costs + History tab. |
| 4 | **Income Pipeline card with Received / Pending / Expected in BDT** | (a) State labels reversed from canonical Expected / Pending / Received order. (b) Receivables shown in BDT instead of USD with conservative BDT-equivalent. (c) "Received: BDT 0.00" is a confusing dead bucket. (d) Card has the same visual weight as the hero — violates Tier 1 dominance. | Hope-tier summary line with USD-first + ETA |
| 5 | **Recent Transactions feed on home (Salman / Meth)** | No "Tier 4." Violates 9-line rule. Looks-backward. Generic expense-tracker pattern. | Move to History tab. Possibly kill outright if these are arbitrary expenses (see §8). |
| 6 | **"All / Expense" filter chips above transactions** | Categorization is V3-or-killed depending on definition. Filter chips on home are noise. | Removed. Filtering lives on History tab. |
| 7 | **Settings (⚙) and info (ⓘ) icons inside the hero card** | Hero is sacred. No competing affordances inside it. | Settings moves to "You" tab in bottom nav. Info — if it explains S2S — becomes a tap on the hero (opens breakdown drawer). |
| 8 | **Vibrant red/green icon backgrounds on Income/Expense tiles** | Violates color palette restraint. Only one red exists (At Risk), used sparingly. | Removed with the tiles. |
| 9 | **"View all" affordance on Income Pipeline** | Implies the home has insufficient detail. Doctrine says home does not link to "more details" — depth is gesture-revealed (UX §3). | Removed. Tap Hope tier → Pipeline tab. |
| 10 | **No timestamp / "Updated X min ago"** | A number without a timestamp is a number without authority (UX §4.4). | Add greeting + freshness line beneath the wordmark. |
| 11 | **No runway sub-line ("covers N days")** | The runway framing is the cortisol-reducing micro-copy (UX §1 + §2 P1). | Add beneath the accent line. |
| 12 | **No state accent line (Safe / Tight / At Risk)** | Three-state visual reinforcement is canon (UX §4.3). | Add 2pt accent line below "Safe to spend" label. |

### Things to keep (with refinement)

| Element | Refinement |
|---|---|
| Helm wordmark top-left | Keep. Smaller weight, same position. |
| Refresh icon top-right (↻) | Keep. Becomes the manual sync affordance. |
| FAB bottom-right (+) | Keep, but **single purpose**: Add Pipeline Entry. Not a multi-action menu. |

---

## 14. Implementation Notes

### Flutter-specific (for your stack)

| Concern | Approach |
|---|---|
| Hero number font | Use `google_fonts` with `JetBrainsMono` or self-host IBM Plex Mono. Apply `FontFeature.tabularFigures()` to ensure decimals align. |
| Bangladeshi number formatting | `NumberFormat` with custom pattern OR write a `bnFormatter` helper using lakh/crore grouping. Standard `NumberFormat.currency(locale: 'bn_BD')` doesn't always render the lakh/crore convention correctly — write a custom formatter and unit-test it. |
| Integer paisa storage | All amounts as `int` (paisa) in domain. Conversion to display BDT happens **only** in a `Money` value object's `format()` method, never in widget code. |
| S2S compute as pure function | Pure Dart function in `domain/s2s_calculator.dart`. Returns a sealed class: `S2SResult.ok(int paisa)` or `S2SResult.error(S2SFailureReason)`. UI maps `error → "—"`. No exceptions thrown. |
| State management | Riverpod (your stack). Wrap `S2SResult` in an `AsyncValue` provider. Loading state shows skeleton in number's position. Error state shows "—". Success shows formatted number with 200ms `FadeTransition`. |
| Performance budget | Cold-start to first frame P95 < 800ms. S2S calc P95 < 50ms. Use `Profile` mode benchmarking on a real low-end Android (not the simulator). Add CI gate via integration test that fails if `time_to_s2s_visible` exceeds 2,000ms. |
| Audit log | Append-only Postgres table from Day 1 (whether backend is Next.js or Supabase). Every financial-entry write goes through a repository method that writes both the entity update and the audit event in one transaction. |
| Event sourcing | Stub from MVP. Even if the current UI doesn't show per-entry history, the writes go through the event log. Snapshot job stubbed but inactive. |
| Theming | Single `ThemeData` for light + dark. Five named colors only — define as `ColorScheme` extension. Lint rule (or code review checklist) blocks any new `Color()` literal in widgets. |
| Localization | `flutter_localizations` + ARB files for `en` and `bn`. No hardcoded strings anywhere — enforced by a custom linter or simple grep in CI. |
| Reduce-motion accessibility | Respect `MediaQuery.disableAnimations`. The 240ms drawer animation collapses to instant when reduce-motion is on. |
| 9-line rule enforcement | Write an integration test using `tester.binding.window` set to reference device dimensions. Render home. Count text nodes above the fold. Fail CI if count > 9. |

### What CLI coding agents can do here (your workflow)

- Scaffold the home screen widget tree with the three tiers per the wireframe in §12.
- Generate `S2SResult` sealed class + repository tests for all failure reasons.
- Generate Bangladeshi-number-formatter with unit tests covering: 0, 100, 1,000, 99,999, 1,00,000 (1 lakh), 1,00,00,000 (1 crore), negative values.
- Scaffold the Calculation Breakdown drawer as a `DraggableScrollableSheet`.

### What CLI coding agents must NOT do here

- Decide whether something fits the Doctrine. That decision is yours, against the Doctrine docs.
- Skip the "—" fallback because it "looks empty." Insist on it. Test for it.
- Add "delightful" touches — counter animations, gradients, illustrations, micro-interactions on the hero. All killed by the UX Doctrine.

### What I'd push back on if you ask me to extend this

If you come back asking for:

- **Charts on the home screen** — pushback: "Doctrine §12 kills charts at home. What question are you trying to answer? If it's S2S, the breakdown drawer is the answer. If it's history, it's the History tab."
- **A spending categorization feature** — pushback: "That's TallyKhata. Permanent Kill List (Final §8). What problem are you actually trying to solve?"
- **Push notifications for re-engagement** — pushback: "Notification Doctrine §9 limits us to two classes — transactional and boundary. 'Time to check Helm' is engagement; it's not allowed."
- **A "financial health score"** — pushback: "Health scores are killed (UX §12). They compete with S2S as a sacred metric. No."
- **An AI insights panel** — pushback: "Final §8 kills 'AI insights' under Helm brand. Hallucination risk on financial data is unforgivable. No."

### The single most important implementation rule

> **The Safe-to-Spend number must render in under 2 seconds from cold app open on a Samsung A14 over 3G, OR the entire product premise is broken.**

This is not a "nice to have." It is the wedge (Final §1, UX §1, UX §14 Impl. 7). Performance regressions block deploy. Treat it like a database migration — non-negotiable.

---

## Closing note (adversarial-mentor)

Mehedi — the gap between the current dashboard and the Doctrine is so large that "redesign" understates it. You have a generic expense app on screen and a clinical-grade financial cockpit in the Doctrine. The Doctrine is correct. The current screen is what happens when an MVP is built from feature instinct instead of from the document.

Two things to internalize before any code changes:

1. **The hero must be a *correct* number or "—".** "BDT 0.00 in reserve mode" on the current screen is, by the Doctrine's own definition, a *wrong number*. Fix that one line and you have already done more for trust than any visual polish ever will.

2. **The home screen is a cockpit, not a dashboard.** A cockpit informs *the next decision*. A dashboard reports *the recent past*. The current screen reports. The redesign decides. Internalize that one distinction and every future call ("should I add this feature here?") answers itself.

Build the boring, narrow, trust-heavy version. Ship it. Then we talk about V1.
