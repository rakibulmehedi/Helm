# Helm Dashboard — Tier‑1 Fintech Design Critique & Improved Version v2

> **Role posture:** Tier‑1 fintech product design director.  
> **Review target:** `Helm_Dashboard_Redesign.md`  
> **Constraints:** Final Product Doctrine + UX Doctrine.  
> **Verdict:** The redesign is directionally correct, but still too much like a beautiful doctrine document translated into a screen. The next version must become a stricter **decision surface**: one answer, one freshness signal, one pressure summary, one maintenance action when needed.

---

## 0. Executive Verdict

The current redesign is **80% right strategically** and **60% right as a shippable mobile surface**.

It correctly kills the generic expense-dashboard pattern, centers Safe‑to‑Spend, separates Present → Threat → Hope, removes recent transactions, and introduces the calculation drawer. Those moves are on-strategy.

But a Tier‑1 fintech review would still block it from shipping because:

1. It is still **too visually and interactionally busy** for a user opening the app under financial stress.
2. It treats the 9-line rule as a mathematical pass instead of a cognitive safety margin.
3. It risks making pending USD feel more emotionally salient than it should.
4. It weakens the sacred S2S contract in Reserve Mode by swapping the hero metric to “Liquid BDT remaining.”
5. It pushes manual maintenance into a generic FAB instead of making the next required financial update obvious.
6. It has money states, but the home copy does not make those states brutally clear enough: **counted vs not counted**.

The improved dashboard should be less “dashboard with doctrine” and more **instrument panel with proof**.

---

## 1. Attack: Cognitive Overload

### What is working

The redesign removes the worst overload from the previous dashboard: Income/Expense cards, recent transactions, generic filter chips, and visually equal pipeline cards. Good.

### What still fails

#### 1. The screen is technically 9 lines, but cognitively over the limit

The draft claims the 9-line rule is satisfied. That is fragile. It counts each row as one visual line, but real users do not process a threat row as one line. A row like:

```text
↳ Internet bill         ৳ 1,500    in 2 days     ●
```

contains four cognitive atoms:

- obligation name
- amount
- due date
- urgency symbol

Three such rows equal twelve cognitive atoms, not three.

**Design director verdict:** The 9-line rule is being treated like a layout compliance metric, not a human attention metric.

#### 2. The top area wastes early attention

Current order:

```text
Helm
Good evening, Mehedi
Updated 2 min ago
৳ 32,400.00
```

For a finance cockpit, brand and greeting are secondary. A user in checkout-counter stress does not need social warmth first. They need truth first.

**Fix:** collapse greeting into a freshness/status line. Example:

```text
Updated 2 min ago · inputs current
```

This does more trust work than “Good evening, Mehedi.”

#### 3. Too many persistent affordances compete silently

The redesign includes:

- refresh icon
- tap hero
- long-press hero
- tap runway
- tap threat row
- long-press threat row
- tap hope block
- pull-to-refresh
- FAB
- bottom nav

This is acceptable in a spec, but risky in production. Most users will only discover tap and FAB. Long-press financial actions are especially weak because they are invisible.

**Fix:** do not rely on hidden gestures for core financial maintenance. Use visible, conditional action surfaces only when math needs the user.

---

## 2. Attack: Generic Finance App Patterns

### 2.1 The FAB still smells like a generic “add transaction” pattern

Even if the spec says the FAB means “Add Pipeline Entry,” a lone `+` on a finance home screen still reads as generic add transaction.

**Risk:** users trained by bKash/TallyKhata/expense apps may tap it expecting expense logging. That pulls Helm back toward generic accounting.

**Fix:** use an **extended FAB during MVP learning period**:

```text
+ Expected payment
```

After repeated use, collapse to `+` only if analytics show users understand it.

### 2.2 “Pending pipeline” is an internal product term

“Pipeline” is useful to us. It may not be instantly clear to a freelancer under stress.

**Better home label:**

```text
Not counted yet
$1,800 · 2 payments · expected ~Nov 18
```

This is more doctrine-aligned because it states the safety boundary directly. The key fact is not that there is a pipeline. The key fact is that the money is **not counted in Safe‑to‑Spend yet**.

### 2.3 Bottom nav item “You” is too lifestyle-app coded

For a fintech cockpit, `You` is vague. It feels consumer-social. It also hides security, export, deletion, and account controls behind a soft label.

**Better:**

```text
Home · Pipeline · History · Settings
```

Boring wins. Financial products should not be cute where clarity is available.

---

## 3. Attack: Trust Risks

### 3.1 Reserve Mode breaks the sacred metric

The draft’s Reserve Mode hero changes from:

```text
৳ 32,400.00
Safe to spend
```

to:

```text
৳ 5,400.00
Liquid BDT remaining
```

This is dangerous. It creates a state where the home screen no longer answers the product’s core question. The doctrine says the home exists to answer Safe‑to‑Spend. Reserve Mode should not replace the core metric; it should modify the **state and explanation**.

**Correct Reserve / At Risk behavior:**

```text
৳ 0.00
Safe to spend
Rent short by ৳14,100 in 6 days
```

If the math is valid and S2S is zero, show zero. If the math cannot be computed, show `—`. Never use “Liquid BDT remaining” as the hero replacement. Liquid BDT belongs in the breakdown drawer.

### 3.2 Decimals can create false precision

The doctrine wants decimals as a trust signal. Fine. But visually, `.00` can add noise and imply exactness beyond the user’s inputs, especially when FX is manual.

**Fix without violating doctrine:** keep decimals, but de-emphasize them typographically.

Example:

```text
৳ 32,400.00
```

- `32,400` = full weight
- `.00` = 45–55% opacity / smaller size

This preserves precision while reducing visual noise.

### 3.3 “Updated 2 min ago” is not enough trust context

Freshness is necessary, but not sufficient. The user also needs to know whether the inputs are current.

**Better freshness line:**

```text
Updated 2 min ago · inputs current
```

Or when not current:

```text
Updated 2 min ago · 1 payment needs review
```

This turns freshness into trust, not just metadata.

### 3.4 Breakdown drawer equation is semantically risky

The current draft includes:

```text
+ Pending USD (conservative)   ৳ 0.00 excluded
```

This is mathematically confusing. A line beginning with `+` visually implies inclusion, then says excluded. That is a trust smell.

**Fix:** split the drawer into two sections:

```text
Counted in Safe‑to‑Spend
Liquid BDT                         ৳ 52,400.00
− Fixed costs next 30 days         ৳ 14,280.00
− Safety buffer 15%                ৳  5,720.00
──────────────────────────────────────────────
Safe‑to‑Spend                      ৳ 32,400.00

Not counted yet
Pending USD                        $1,800 · 2 payments
Reason                             not received
```

The equation must not visually include excluded money.

---

## 4. Attack: Anxiety Triggers

### 4.1 Always showing three obligations may increase rumination

The doctrine wants the next obligations visible. Correct. But the draft shows three fixed costs with due dates and proximity dots, without clearly telling the user whether they are covered.

A due list without coverage status can create anxiety because the user must mentally reconcile it with S2S.

**Fix:** each row needs a tiny coverage state, not just a proximity dot.

```text
Internet        ৳1,500   in 2d   covered
Rent            ৳18,000  in 6d   covered
Adobe           ৳2,400   in 11d  later
```

When At Risk:

```text
Rent            ৳18,000  in 6d   short ৳14,100
```

This closes the loop. The user should not have to infer safety.

### 4.2 “Reserve mode is on” is system-centric and threatening

“Reserve Mode” may be useful internally, but as user-facing copy it sounds like the app has activated a scary financial lockdown.

**Better:** use the canonical state vocabulary:

- Safe
- Tight
- At Risk

Then explain the reason.

```text
At Risk
Rent short by ৳14,100 in 6 days
```

No mode label needed.

### 4.3 “The Path” section in Reserve Mode is too dramatic

The Path sounds like a crisis journey. In fintech, especially for financially stressed users, language should be calmer and more literal.

**Better label:**

```text
Next obligations
```

or

```text
Upcoming fixed costs
```

Boring copy is a feature here.

---

## 5. Attack: Wrong Hierarchy

### 5.1 The current draft still gives brand/greeting too much surface weight

The cockpit should start with truth, not identity. Helm’s brand is the math, not the wordmark.

**Improved hierarchy:**

1. Freshness + input confidence
2. Safe‑to‑Spend label
3. Safe‑to‑Spend number
4. Meaning line
5. Next obligation coverage
6. Not-counted money
7. One conditional maintenance action

### 5.2 Threat tier should not always be visually equal

If all upcoming obligations are covered, the threat tier should visually calm down. If one is not covered, that row earns emphasis.

**Rule:** obligations are sorted by due date, but weighted by harm.

Priority formula:

```text
Due soon + not covered > due soon + covered > later + covered
```

This keeps the doctrine’s temporal model while respecting actual risk.

### 5.3 Hope tier needs a stronger boundary label

“Pending pipeline” is too neutral. It does not tell the user whether the money affects the hero number.

**Better:**

```text
Not counted yet
$1,800 · 2 payments · expected ~Nov 18
```

This single copy change reduces overspend risk.

---

## 6. Attack: Manual Friction

### 6.1 The most important manual action is not prominent enough

The doctrine says one-tap Pending → Received is the single most important UX moment. But the home redesign gives the persistent proactive affordance to “Add Pipeline Entry,” not “Confirm expected payment” when a payment is due.

**Fix:** the dashboard needs a **conditional Maintenance Strip** that appears only when the user needs to preserve S2S truth.

Examples:

```text
1 payment expected today
Confirm received → updates Safe‑to‑Spend
```

```text
1 input needs review
Add FX rate → restores Safe‑to‑Spend
```

This strip should appear above obligations when action is required. The FAB remains secondary.

### 6.2 Add Pipeline Entry is too heavy for MVP if it asks too much at once

The draft says the Add Pipeline Entry sheet includes:

- USD amount
- client
- expected date
- FX rate with sanity check

That is not terrible, but it risks feeling like finance homework.

**MVP sheet should be staged:**

Step 1 — required:

```text
Amount
Expected date
```

Step 2 — optional but encouraged:

```text
Client / source
FX rate
```

If FX is missing, the entry is allowed but clearly marked as not counted.

**Rule:** missing inputs should reduce confidence, not block capture.

### 6.3 Long-press “mark paid” is not acceptable as a primary path

Long-press is a power-user shortcut. It should never be required for an action that changes financial truth.

**Fix:** keep long-press as a shortcut, but visible row actions must exist inside the tap sheet.

---

## 7. Attack: Unclear Money States

Helm lives or dies on the user understanding what money is real.

The current draft has the right internal states:

- Expected
- Pending
- Received
- Liquid BDT
- Safe‑to‑Spend
- Fixed costs
- Safety buffer

But the home screen still does not make the most important distinction loud enough:

> **Counted in Safe‑to‑Spend vs not counted yet.**

That should be the language system.

### Better state language

| Internal state | User-facing home language | Counts in S2S? |
|---|---|---:|
| Liquid BDT | Already counted | Yes |
| Fixed costs | Already reserved | Yes, deducted |
| Safety buffer | Held aside | Yes, deducted |
| Expected USD | Not counted yet | No |
| Pending USD | Not counted yet | No |
| Received | Added to liquid balance | Yes |
| Missing FX | Needs input | No |
| Calculation failure | Safe‑to‑Spend unavailable | No display number |

The user does not need to understand the system’s whole model on home. They need to understand whether a rupee/taka/dollar is counted.

---

# Improved Version v2

## 8. New Dashboard Principle

> **Answer → Confidence → Pressure → Maintenance.**

The current redesign uses:

> Present → Threat → Hope.

That is correct emotionally, but not sufficient operationally. Helm also needs to tell the user whether the answer is trustworthy and whether they need to update anything.

So the improved hierarchy becomes:

1. **Answer** — Safe‑to‑Spend
2. **Confidence** — freshness + input status
3. **Pressure** — next obligations, with coverage status
4. **Maintenance** — exactly one action when S2S truth needs user input
5. **Hope** — money not counted yet, visually demoted

---

## 9. Improved Normal State Wireframe

Reference: 6.1" Android, 412 × 915 logical px, 8pt grid.

```text
┌──────────────────────────────────────────────┐
│ Helm                                   ↻  │
│ Updated 2 min ago · inputs current           │
│                                              │
│ SAFE‑TO‑SPEND                                │
│              ৳ 32,400.00                     │
│ after fixed costs + 15% buffer               │
│ ───────────────  Safe                         │
│                                              │
│ Next obligations                             │
│ Internet        ৳ 1,500    in 2d   covered   │
│ Rent            ৳18,000    in 6d   covered   │
│                                              │
│ Not counted yet                              │
│ $1,800 · 2 payments · expected ~Nov 18    ›  │
│                                              │
└──────────────────────────────────────────────┘
                        [+ Expected payment]
┌──────────────────────────────────────────────┐
│ Home        Pipeline        History Settings │
└──────────────────────────────────────────────┘
```

### Why this is better

- The greeting is removed. The screen speaks like an instrument.
- Freshness and input confidence are joined into one trust line.
- The hero label is above the number, so the user reads what the number means before reading the number.
- The meaning line says what was deducted: fixed costs + buffer.
- Obligations include coverage status, removing mental math.
- Hope is renamed to “Not counted yet,” reducing overspend temptation.
- FAB is labeled as “Expected payment,” not generic `+`.

---

## 10. Improved Tight State Wireframe

```text
┌──────────────────────────────────────────────┐
│ Helm                                   ↻  │
│ Updated 4 min ago · inputs current           │
│                                              │
│ SAFE‑TO‑SPEND                                │
│              ৳ 8,900.00                      │
│ after fixed costs + 15% buffer               │
│ ───────────────  Tight                        │
│ buffer is being used                          │
│                                              │
│ Next obligations                             │
│ Internet        ৳ 1,500    in 2d   covered   │
│ Rent            ৳18,000    in 6d   covered   │
│                                              │
│ Not counted yet                              │
│ $1,800 · 2 payments · expected ~Nov 18    ›  │
└──────────────────────────────────────────────┘
                        [+ Expected payment]
```

### Key copy rule

Do not say:

```text
Warning: low balance
```

Say:

```text
buffer is being used
```

This is specific, calm, and mathematically grounded.

---

## 11. Improved At Risk State Wireframe

```text
┌──────────────────────────────────────────────┐
│ Helm                                   ↻  │
│ Updated 1 min ago · inputs current           │
│                                              │
│ SAFE‑TO‑SPEND                                │
│              ৳ 0.00                          │
│ rent short by ৳14,100 in 6 days              │
│ ───────────────  At Risk                      │
│                                              │
│ Next obligations                             │
│ Internet        ৳ 1,500    in 2d   covered   │
│ Rent            ৳18,000    in 6d   short ৳14,100 │
│                                              │
│ Not counted yet                              │
│ $1,800 · 2 payments · expected ~Nov 18    ›  │
└──────────────────────────────────────────────┘
                        [+ Expected payment]
```

### Why this is better than Reserve Mode

- It keeps Safe‑to‑Spend as the sacred hero metric.
- It does not replace the answer with “Liquid BDT remaining.”
- It explains the financial harm in one sentence.
- It avoids dramatic mode language.
- It shows zero only when zero is a valid computed answer.
- It still uses `—` when calculation fails.

---

## 12. Improved Calculation Failure State

```text
┌──────────────────────────────────────────────┐
│ Helm                                   ↻  │
│ Updated 2 min ago · 1 input needs review     │
│                                              │
│ SAFE‑TO‑SPEND                                │
│                  —                           │
│ add FX rate to calculate safely              │
│ ───────────────                              │
│                                              │
│ Needs review                                 │
│ Acme payment · $1,500 · FX rate missing   ›  │
│                                              │
│ Next obligations                             │
│ Internet        ৳1,500     in 2d             │
│ Rent            ৳18,000    in 6d             │
└──────────────────────────────────────────────┘
```

### Rule

When S2S cannot be computed, the home becomes a **repair surface**, not a normal dashboard.

The user should not have to open the breakdown drawer to discover what is broken. The broken input is shown immediately.

---

## 13. Improved “Payment Expected Today” State

This state directly supports the MVP’s most important behavioral metric: pipeline update compliance.

```text
┌──────────────────────────────────────────────┐
│ Helm                                   ↻  │
│ Updated 12 min ago · 1 payment due today     │
│                                              │
│ SAFE‑TO‑SPEND                                │
│              ৳ 32,400.00                     │
│ after fixed costs + 15% buffer               │
│ ───────────────  Safe                         │
│                                              │
│ 1 payment expected today                     │
│ Acme · $1,500                                │
│ Confirm received → updates Safe‑to‑Spend  ›  │
│                                              │
│ Next obligations                             │
│ Internet        ৳1,500    in 2d    covered   │
└──────────────────────────────────────────────┘
```

### Why this matters

The redesign’s normal dashboard is calm, but the product lives or dies on manual pipeline maintenance. When a payment needs confirmation, that job temporarily outranks the Hope tier.

**Rule:** the maintenance strip appears only when action is required. No engagement bait. No inbox dot. No “check your app.”

---

## 14. Improved Breakdown Drawer

### Default drawer

```text
Safe‑to‑Spend calculation
as of 2 min ago

Counted in Safe‑to‑Spend
Liquid BDT                              ৳ 52,400.00
− Fixed costs next 30 days              ৳ 14,280.00
− Safety buffer 15%                     ৳  5,720.00
────────────────────────────────────────────────
Safe‑to‑Spend                           ৳ 32,400.00

Not counted yet
Pending payments                         $1,800 · 2
Reason                                   not received
```

### Why this drawer is better

- It avoids the confusing `+ Pending USD ... excluded` pattern.
- It makes the safety boundary explicit.
- It mirrors how trust actually forms: first show the equation, then show excluded money.
- It avoids showing Tax Reserve in MVP if tax reserve is not shipped yet.

### Row behavior

| Row | Tap outcome |
|---|---|
| Liquid BDT | Edit current aggregated balance |
| Fixed costs | View fixed cost list |
| Safety buffer | Adjust 5–30% buffer |
| Pending payments | Open Pipeline |
| Safe‑to‑Spend | No edit; show boundary explanation |

Boundary copy:

```text
Helm never edits Safe‑to‑Spend directly. Edit the inputs to change the number.
```

---

## 15. Improved Add Expected Payment Sheet

### Problem with current draft

The draft’s Add Pipeline Entry sheet risks becoming a mini accounting form.

### Improved MVP sheet

```text
Add expected payment

Amount
$ [        ]

Expected date
[  Jun 18  ]

Optional details
Client/source
[        ]

FX rate
[        ]  optional

[ Save expected payment ]
```

### Save behavior

| Input state | Result |
|---|---|
| Amount + date only | Entry saved as Expected; not counted in S2S |
| Amount + date + FX | Entry saved; conservative BDT shown in Pipeline only |
| Missing FX | Home says “Not counted yet”; no calculation failure unless the entry is required for a visible estimate |
| Suspicious FX | Confirmation modal, not hard block |

### Principle

Capture should be easy. Counting should be strict.

---

## 16. Improved Component Rules

### 16.1 Hero rules

| Element | Decision |
|---|---|
| Label | `SAFE‑TO‑SPEND` small uppercase, 11–12pt |
| Number | Largest element, monospaced numeric |
| Decimal | shown but de-emphasized |
| Meaning line | `after fixed costs + 15% buffer` |
| State | one text label beside/below accent line |
| State color | accent line only |
| Tap | opens calculation drawer |
| Long press | optional refresh shortcut only; not primary |

### 16.2 Obligation rules

| Condition | Display |
|---|---|
| Covered | `covered` neutral secondary ink |
| Eats buffer | `uses buffer` muted amber text |
| Not covered | `short ৳X` muted brick red text |
| Paid this cycle | hidden from home; visible in History |
| More than 2–3 obligations | show top risk-relevant rows only |

### 16.3 Not-counted money rules

Home should never say:

```text
Pending pipeline
```

Home should say:

```text
Not counted yet
```

This is the highest-leverage copy change in the whole redesign.

---

## 17. Final Improved Section Order

```text
1. Top bar
   - Helm wordmark
   - refresh icon
   - freshness + input confidence

2. S2S Hero
   - SAFE‑TO‑SPEND label
   - number / dash
   - meaning line
   - state accent + state label

3. Conditional Maintenance Strip
   - appears only when input/payment action is needed
   - replaces Hope tier priority when present

4. Next Obligations
   - 2–3 rows
   - amount + due date + coverage status

5. Not Counted Yet
   - pending/expected USD summary
   - no BDT equivalent on home

6. Bottom nav
   - Home · Pipeline · History · Settings

7. Extended FAB during MVP
   - + Expected payment
```

---

## 18. What to Kill From the Current Redesign v1

| Kill / Change | Reason |
|---|---|
| Greeting line as separate line | Consumes attention without increasing trust |
| Exact 9-line layout as “pass” | Too fragile for Bangla, small devices, dynamic states |
| `Pending pipeline` label on home | Too internal; weak safety boundary |
| Reserve Mode hero = Liquid BDT remaining | Breaks sacred S2S metric |
| `+ Pending USD ... excluded` in equation | Mathematically confusing visual language |
| Lone `+` FAB in MVP | Reads as generic add transaction |
| Long-press as core action | Hidden gesture; weak for finance truth updates |
| Proximity dots as only obligation status | Requires mental math; does not close loop |
| `You` tab | Vague; use Settings |
| Hope tier always visible above maintenance needs | Wrong when payment confirmation is due |

---

## 19. Shippability Checklist

A dashboard build is not ready unless every item below passes.

### Calm

- [ ] One dominant number or dash appears first.
- [ ] No row forces the user to mentally calculate coverage.
- [ ] At Risk state is factual, not dramatic.
- [ ] No mode label creates panic.

### Trust

- [ ] Every number has unit and freshness.
- [ ] S2S is computed from the same function used by the drawer.
- [ ] Dash appears on calculation failure.
- [ ] Zero appears only when zero is a valid computed answer.
- [ ] Excluded money is not shown inside the equation as a plus line.

### Clarity

- [ ] Home distinguishes counted vs not counted.
- [ ] Pending USD never appears as BDT-equivalent on home.
- [ ] Fixed costs show coverage status.
- [ ] The next required manual action is visible when needed.

### Friction

- [ ] Add expected payment requires only amount + expected date.
- [ ] Payment confirmation is one tap from the maintenance strip or notification landing sheet.
- [ ] Missing optional details do not block capture.
- [ ] Suspicious values are challenged, not rejected.

### Doctrine

- [ ] No generic expense categories on home.
- [ ] No charts, scores, AI insights, or promo banners.
- [ ] No engagement notification artifacts.
- [ ] No direct S2S override.
- [ ] No stored S2S value.

---

## 20. Final Director Verdict

The existing redesign is a strong doctrine translation. The improved v2 turns it into a stricter product surface.

The biggest upgrade is not visual. It is semantic:

> Replace “Pending pipeline” with **“Not counted yet.”**

That phrase protects the user from the exact overspend error Helm exists to prevent.

The second biggest upgrade is Reserve Mode correction:

> Never replace Safe‑to‑Spend with Liquid BDT remaining. If the computed S2S is zero, show `৳0.00`. If it cannot be computed, show `—`.

The third biggest upgrade is maintenance priority:

> When a payment needs confirmation, the home screen temporarily becomes an update surface. No hidden gesture. No generic FAB dependency.

Build this version. It is more boring, clearer, safer, and closer to the product truth.
